//
//  Tesla Speech
//
//  Created by Alberto Pasca on 13/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APMenubarController.h"
#import "APStatusItemView.h"


@interface APMenubarController ()
{
  APStatusItemView *_statusItemView;
}
@end


@implementation APMenubarController

- (id)init
{
  self = [super init];
  if ( self )
  {
    NSStatusItem *statusItem       = [[NSStatusBar systemStatusBar] statusItemWithLength:STATUS_ITEM_VIEW_WIDTH];
    _statusItemView                = [[APStatusItemView alloc] initWithStatusItem:statusItem];
    _statusItemView.image          = [NSImage imageNamed:@"ico"];
    _statusItemView.alternateImage = [NSImage imageNamed:@"StatusHighlighted"];
    _statusItemView.action         = @selector(togglePanel:);
  }

  return self;
}

- (void)dealloc
{
  [[NSStatusBar systemStatusBar] removeStatusItem:self.statusItem];
}

- (void) setNotification
{
  _statusItemView.image = [NSImage imageNamed:@"ico"];
}

- (void) removeNotification
{
  _statusItemView.image = [NSImage imageNamed:@"ico"];
}


#pragma mark -
#pragma mark Public accessors

- (NSStatusItem *)statusItem
{
  return self.statusItemView.statusItem;
}

#pragma mark -

- (BOOL)hasActiveIcon
{
  return self.statusItemView.isHighlighted;
}

- (void)setHasActiveIcon:(BOOL)flag
{
  self.statusItemView.isHighlighted = flag;
}

@end
