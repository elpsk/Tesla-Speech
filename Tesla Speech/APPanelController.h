//
//  Tesla Speech
//
//  Created by Alberto Pasca on 13/02/14.
//  Copyright (c) 2014 albertopasca.it. All rights reserved.
//

#import "APBackgroundView.h"
#import "APStatusItemView.h"
#import "APSpeech.h"


@class APPanelController;

@protocol APPanelControllerDelegate <NSObject>
@optional
- (APStatusItemView *)statusItemViewForPanelController:(APPanelController *)controller;
@end


@interface APPanelController : NSWindowController <NSWindowDelegate>

@property (nonatomic, unsafe_unretained) IBOutlet APBackgroundView *backgroundView;
@property (nonatomic, unsafe_unretained) IBOutlet NSSearchField *searchField;
@property (nonatomic, unsafe_unretained) IBOutlet NSButton *button;

@property (nonatomic) BOOL hasActivePanel;
@property (nonatomic, unsafe_unretained, readonly) id<APPanelControllerDelegate> delegate;


- (id)initWithDelegate:(id<APPanelControllerDelegate>)delegate;

- (void)openPanel;
- (void)closePanel;

- (IBAction)searchAnswer:(id)sender;
- (IBAction)closeApplication:(id)sender;

@end

