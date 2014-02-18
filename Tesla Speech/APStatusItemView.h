//
//  Tesla Speech
//
//  Created by Alberto Pasca on 13/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

@interface APStatusItemView : NSView

- (id)initWithStatusItem:(NSStatusItem *)statusItem;

@property (nonatomic, strong, readonly)         NSStatusItem *statusItem;
@property (nonatomic, strong)                   NSImage *image;
@property (nonatomic, strong)                   NSImage *alternateImage;
@property (nonatomic, setter = setHighlighted:) BOOL isHighlighted;
@property (nonatomic, readonly)                 NSRect globalRect;
@property (nonatomic)                           SEL action;
@property (nonatomic, unsafe_unretained)        id target;

@end
