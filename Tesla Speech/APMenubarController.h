//
//  Tesla Speech
//
//  Created by Alberto Pasca on 13/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#define STATUS_ITEM_VIEW_WIDTH 24.0

#pragma mark -

@class APStatusItemView;

@interface APMenubarController : NSObject

@property (nonatomic                  ) BOOL             hasActiveIcon;
@property (nonatomic, strong, readonly) NSStatusItem     *statusItem;
@property (nonatomic, strong, readonly) APStatusItemView *statusItemView;

- (void) setNotification;
- (void) removeNotification;

@end
