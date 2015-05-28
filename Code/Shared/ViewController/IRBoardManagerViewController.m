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

@interface IRBoardManagerViewController ()

@property (nonatomic, strong) ICDismissibleMessageView *messageView;

@end

@implementation IRBoardManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configureMessageView];
}

#define kMessageViewHeight          40
#define kMessageViewPadding         15

- (void)configureMessageView {
    self.messageView = [ICDismissibleMessageView new];
    
    self.boardsViewController.collectionView.topInset += [self messageViewHeightAndPadding];
    
    NSString *text = @"Only saved rentals shown";
    [self.messageView configureWithText:text color:[UIColor truliaGreen] target:self action:@selector(actionCloseMessage:)];
    [self.boardsViewController.view addSubview:self.messageView];
    
    [self.messageView ic_pinViewToLeftAndRightEdgesOfSuperViewWithPadding:15];
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[segment]-pad-[message(height)]" options:0 metrics:@{@"pad" : @kMessageViewPadding , @"height" : @kMessageViewHeight} views:@{@"message" : self.messageView, @"segment" : self.segmentedControl}]];
}

- (void)actionCloseMessage:(id)sender {
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

@end
