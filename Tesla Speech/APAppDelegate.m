//
//  Tesla Speech
//
//  Created by Alberto Pasca on 13/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APAppDelegate.h"
#import "APPanelController.h"
#import "APMenubarController.h"

@interface APAppDelegate() <APPanelControllerDelegate>
{
  APPanelController   *_panelController;
  APMenubarController *_menubarController;
}

- (IBAction)togglePanel:(id)sender;

@end


@implementation APAppDelegate

void *kContextActivePanel = &kContextActivePanel;


- (void) applicationDidFinishLaunching:(NSNotification *)aNotification
{
  _menubarController = [[APMenubarController alloc] init];
  [self panelController];
}

- (NSApplicationTerminateReply) applicationShouldTerminate:(NSApplication *)sender
{
  [_panelController removeObserver:self forKeyPath:@"hasActivePanel"];
  return NSTerminateNow;
}

- (IBAction)togglePanel:(id)sender
{
  _menubarController.hasActiveIcon = !_menubarController.hasActiveIcon;
  _panelController.hasActivePanel  =  _menubarController.hasActiveIcon;
}

- (APPanelController *) panelController
{
  if (_panelController == nil) {
    _panelController = [[APPanelController alloc] initWithDelegate:self];

    [_panelController addObserver:self forKeyPath:@"hasActivePanel" options:0 context:kContextActivePanel];
  }
  return _panelController;
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
  if (context == kContextActivePanel)
  {
    _menubarController.hasActiveIcon = _panelController.hasActivePanel;
  }
  else
  {
    [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
  }
}

- (APStatusItemView *)statusItemViewForPanelController:(APPanelController *)controller
{
  return _menubarController.statusItemView;
}


@end

