//
//  Tesla Speech
//
//  Created by Alberto Pasca on 13/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APPanelController.h"
#import "APBackgroundView.h"
#import "APStatusItemView.h"


#define OPEN_DURATION           .15
#define CLOSE_DURATION          .1

#define SEARCH_INSET            17

#define POPUP_HEIGHT            145
#define PANEL_WIDTH             324
#define MENU_ANIMATION_DURATION .1

#define STATUS_ITEM_VIEW_WIDTH  24.0


@interface APPanelController ()
{
  BOOL _hasActivePanel;

  __unsafe_unretained APBackgroundView              *_backgroundView;
  __unsafe_unretained id<APPanelControllerDelegate> _delegate;
  __unsafe_unretained NSSearchField                 *_searchField;
  __unsafe_unretained NSScrollView                  *_tableView;
  IBOutlet __unsafe_unretained NSComboBox           *_languages;

  APSpeech *_speech;
}
@end


@implementation APPanelController

- (id)initWithDelegate:(id<APPanelControllerDelegate>)delegate
{
  self = [super initWithWindowNibName:@"APPanel"];
  if ( self )
  {
    _delegate = delegate;
    _speech   = [[APSpeech alloc] init];
  }
  return self;
}


- (void)awakeFromNib
{
  [super awakeFromNib];
  
  NSPanel *panel = (id)[self window];
  [panel setAcceptsMouseMovedEvents:YES];
  [panel setLevel:NSPopUpMenuWindowLevel];
  [panel setOpaque:NO];
  [panel setBackgroundColor:[NSColor clearColor]];

  NSRect panelRect      = [[self window] frame];
  panelRect.size.height = POPUP_HEIGHT;

  [self.window setFrame:panelRect display:NO];
}


#pragma mark - Public accessors


- (BOOL) hasActivePanel
{
  return _hasActivePanel;
}

- (void)setHasActivePanel:(BOOL)flag
{
  if (_hasActivePanel != flag)
  {
    _hasActivePanel = flag;
    if (_hasActivePanel)
      [self openPanel];
    else
      [self closePanel];
  }
}


#pragma mark - NSWindowDelegate


- (void) windowWillClose:(NSNotification *)notification
{
  self.hasActivePanel = NO;
}

- (void)windowDidResignKey:(NSNotification *)notification;
{
  if ([[self window] isVisible])
  {
    self.hasActivePanel = NO;
  }
}

- (void)windowDidResize:(NSNotification *)notification
{
  NSWindow *panel = [self window];
  NSRect statusRect = [self statusRectForWindow:panel];
  NSRect panelRect = [panel frame];
  
  CGFloat statusX = roundf(NSMidX(statusRect));
  CGFloat panelX = statusX - NSMinX(panelRect);
  
  self.backgroundView.arrowX = panelX;
}

#pragma mark - Keyboard

- (void)cancelOperation:(id)sender
{
  self.hasActivePanel = NO;
}

- (IBAction) searchAnswer:(id)sender
{
  _speech.language = _languages.indexOfSelectedItem;
  if ( _speech.language == -1 ) _speech.language = 0;

  [_speech SpeechThis:self.searchField.stringValue inLanguage:_speech.language];
}


#pragma mark - Public methods

- (NSRect)statusRectForWindow:(NSWindow *)window
{
  NSRect screenRect = [[[NSScreen screens] objectAtIndex:0] frame];
  NSRect statusRect = NSZeroRect;
  
  APStatusItemView *statusItemView = nil;
  if ([self.delegate respondsToSelector:@selector(statusItemViewForPanelController:)])
  {
    statusItemView = [self.delegate statusItemViewForPanelController:self];
  }
  
  if (statusItemView)
  {
    statusRect          = statusItemView.globalRect;
    statusRect.origin.y = NSMinY(statusRect) - NSHeight(statusRect);
  }
  else
  {
    statusRect.size     = NSMakeSize(STATUS_ITEM_VIEW_WIDTH, [[NSStatusBar systemStatusBar] thickness]);
    statusRect.origin.x = roundf((NSWidth(screenRect) - NSWidth(statusRect)) / 2);
    statusRect.origin.y = NSHeight(screenRect) - NSHeight(statusRect) * 2;
  }

  return statusRect;
}

- (void)openPanel
{
  NSWindow *panel      = [self window];

  NSRect screenRect    = [[[NSScreen screens] objectAtIndex:0] frame];
  NSRect statusRect    = [self statusRectForWindow:panel];

  NSRect panelRect     = [panel frame];
  panelRect.size.width = PANEL_WIDTH;
  panelRect.origin.x   = roundf(NSMidX(statusRect) - NSWidth(panelRect) / 2);
  panelRect.origin.y   = NSMaxY(statusRect) - NSHeight(panelRect);

  if (NSMaxX(panelRect) > (NSMaxX(screenRect) - ARROW_HEIGHT))
    panelRect.origin.x -= NSMaxX(panelRect) - (NSMaxX(screenRect) - ARROW_HEIGHT);
  
  [NSApp activateIgnoringOtherApps:NO];
  [panel setAlphaValue:0];
  [panel setFrame:statusRect display:YES];
  [panel makeKeyAndOrderFront:nil];
  
  NSTimeInterval openDuration = OPEN_DURATION;
  
  NSEvent *currentEvent = [NSApp currentEvent];
  if ([currentEvent type] == NSLeftMouseDown)
  {
    NSUInteger clearFlags = ([currentEvent modifierFlags] & NSDeviceIndependentModifierFlagsMask);
    BOOL shiftPressed = (clearFlags == NSShiftKeyMask);
    BOOL shiftOptionPressed = (clearFlags == (NSShiftKeyMask | NSAlternateKeyMask));
    if (shiftPressed || shiftOptionPressed)
    {
      openDuration *= 10;
      
      if (shiftOptionPressed)
        NSLog(@"Icon is at %@\n\tMenu is on screen %@\n\tWill be animated to %@",
              NSStringFromRect(statusRect), NSStringFromRect(screenRect), NSStringFromRect(panelRect));
    }
  }
  
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:openDuration];
  [[panel animator] setFrame:panelRect display:YES];
  [[panel animator] setAlphaValue:1];
  [NSAnimationContext endGrouping];
  
  [panel performSelector:@selector(makeFirstResponder:) withObject:self.searchField afterDelay:openDuration];
}

- (void)closePanel
{
  [NSAnimationContext beginGrouping];
  [[NSAnimationContext currentContext] setDuration:CLOSE_DURATION];
  [[[self window] animator] setAlphaValue:0];
  [NSAnimationContext endGrouping];
  
  dispatch_after(dispatch_walltime(NULL, NSEC_PER_SEC * CLOSE_DURATION * 2), dispatch_get_main_queue(), ^{
    
    [self.window orderOut:nil];
  });
}

- (IBAction)closeApplication:(id)sender
{
  [[NSApplication sharedApplication] terminate:nil];
}


@end



