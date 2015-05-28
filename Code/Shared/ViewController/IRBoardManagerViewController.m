//
//  IRBoardManagerViewController.m
//  Trulia Rent
//
//  Created by Christopher Echanique on 5/27/15.
//  Copyright (c) 2015 Trulia Inc. All rights reserved.
//

#import "IRBoardManagerViewController.h"
#import "ICDismissibleMessageView.h"
#import "ICBoardsCoreDataCollectionViewController.h"
#import "ICSegmentedControl.h"
#import "UIView+ICAutoLayoutHelpers.h"
#import "IC+UIColor.h"
#import "UIScrollView+ICAdditions.h"
#import "ICPreference.h"


NSString * const kRentalsOnlyMessageDidShow = @"RentalsOnlyMessageDidShow";

@interface IRBoardManagerViewController ()

@property (nonatomic, strong) ICDismissibleMessageView *messageView;
@property (nonatomic, strong) NSTimer *messageDismissTimer;

@end

@implementation IRBoardManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMessageView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self startTimerIfNeeded];
}

- (void)dealloc {
    [self.messageDismissTimer invalidate];
    self.messageDismissTimer = nil;
}

#define kMessageViewHeight          40
#define kMessageViewPadding         15

- (void)configureMessageView {
    if (![self shouldShowMessage]) {
        return;
    }
    
    self.messageView = [ICDismissibleMessageView new];
    
    self.boardsViewController.collectionView.topInset += [self messageViewHeightAndPadding];
    
    NSString *text = @"Only saved rentals shown";
    [self.messageView configureWithText:text color:[UIColor truliaGreen] target:self action:@selector(actionCloseMessage:)];
    [self.boardsViewController.view addSubview:self.messageView];
    
    [self.messageView ic_pinViewToLeftAndRightEdgesOfSuperViewWithPadding:15];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[segment]-pad-[message(height)]" options:0 metrics:@{@"pad" : @kMessageViewPadding , @"height" : @kMessageViewHeight} views:@{@"message" : self.messageView, @"segment" : self.segmentedControl}]];
}

- (void)startTimerIfNeeded {
    if ([self shouldShowMessage]) {
        self.messageDismissTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(actionCloseMessage:) userInfo:nil repeats:NO];
    }
}

- (void)actionCloseMessage:(id)sender {
    if(!self.messageView.superview) {
        return;
    }
    
    [[ICPreference sharedInstance] setAppForKey:kRentalsOnlyMessageDidShow withAttribute:@YES];
    
    [UIView animateWithDuration:.3 animations:^{
        self.messageView.transform = CGAffineTransformMakeTranslation(0, -[self messageViewHeightAndPadding]);
        self.boardsViewController.collectionView.topInset -= [self messageViewHeightAndPadding];
        [self.boardsViewController.collectionView scrollRectToVisible:CGRectMake(0, 0, 320, 1) animated:YES];
    } completion:^(BOOL finished) {
        [self.messageView removeFromSuperview];
        self.messageView = nil;
    }];
}

- (CGFloat)messageViewHeightAndPadding {
    return kMessageViewHeight + kMessageViewPadding;
}

- (NSString *)segmentTitleForIndex:(NSUInteger)index {
    switch (index) {
        case 1:
            return ICLocalizedString(@"Saved Rentals");
        default:
            break;
    }
    return [super segmentTitleForIndex:index];
}

- (BOOL)shouldShowMessage {
    return ![[[ICPreference sharedInstance] getAppForKey:kRentalsOnlyMessageDidShow] boolValue];
}

@end
