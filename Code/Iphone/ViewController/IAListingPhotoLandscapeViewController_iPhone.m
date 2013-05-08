//
//  IAListingPhotoLandscapeViewController_iPhone.m
//  Trulia
//
//  Created by Dan Lowrie on 2/29/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IAListingPhotoLandscapeViewController_iPhone.h"
#import "ICToolbarView.h"

@interface IAListingPhotoLandscapeViewController_iPhone (PrivateInherited)
- (void)showCaptions:(BOOL)show;
- (void)trackPageView;
- (void)moveToPhotoAtIndex:(NSInteger)index withDelay:(BOOL)isDelayed;
@end

@interface IAListingPhotoLandscapeViewController_iPhone (Private)
- (void)viewFadeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context;
@end

@implementation IAListingPhotoLandscapeViewController_iPhone
@synthesize parentPhotoViewController = _parentPhotoViewController;
@synthesize startingCenterPhotoIndex = _startingCenterPhotoIndex;

- (void)setStartingCenterPhotoIndex:(NSInteger)newCenterPhotoIndex; {
    _startingCenterPhotoIndex = newCenterPhotoIndex;
    _centerPhotoIndex = newCenterPhotoIndex;
}

- (void)showLandscapePhotos; {
    // Do nothing.
}

- (void)hideLandscapePhotos; {
    [UIView beginAnimations:@"TruliaPropertyLandscapePhotoViewFadeOutAnimation" context:nil];
    [UIView setAnimationDuration:(TRULIA_PROPERTY_LANDSCAPE_PHOTO_VIEW_ANIMATION_DURATION / 2.0f)];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(viewFadeAnimationDidStop:finished:context:)];
    [self showBars:NO animated:NO changeStatusBar:NO];
    [UIView commitAnimations];    
}

- (void)overlayShowAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context; {
    // Do nothing
}

- (void)overlayHideAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context; {
    // Do nothing
}



- (void)viewFadeAnimationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context; {
    [self dismissModalViewControllerAnimated:NO];
}

- (void)trackPageView; {
    if (self.listing) {
        
        [[ICMetricsController sharedInstance] trackPageView:[GR_TRACKER_PDP_PHOTOS_LANDSCAPE_PREFIX stringByAppendingString:[self.listing getListingData:ListingDataIndexType]]];
        
    }
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)viewDidLoad; {
    
    _innerView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;    
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    [super viewDidLoad];
    
    // No status label for this view.
    self.statusLabel.hidden = YES;
    
    // Reset the toolbar's frame to fit onscreen
    self.fadingToolbar.frame = CGRectMake(0, (_innerView.bounds.size.height - 44.0f), _innerView.bounds.size.width, 44.0f);
    
    // Hide the toolbar since the original request was to not show the toolbar
    self.fadingToolbar.hidden = YES;
    
    [self showBars:NO animated:NO changeStatusBar:NO];
    
}

- (void)viewWillAppear:(BOOL)animated; {
    [super viewWillAppear:animated];
    
    NSInteger indexToJumpTo = self.startingCenterPhotoIndex != TT_NULL_PHOTO_INDEX ? self.startingCenterPhotoIndex : _centerPhotoIndex;
    
    self.centerPhoto = [_photoSource photoAtIndex:indexToJumpTo];
    
}

- (void)viewDidAppear:(BOOL)animated; {
    [super viewDidAppear:animated];
    [self showBars:self.startingChromeVisible animated:YES changeStatusBar:NO]; 
}

- (void)viewWillDisappear:(BOOL)animated; {
    [super viewWillDisappear:animated];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil; {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        self.parentPhotoViewController = nil;
        self.startingCenterPhotoIndex = TT_NULL_PHOTO_INDEX;
        self.showingLandscapePhotos = NO;
        self.wantsStatusBar = NO;
        self.startingChromeVisible = YES;
    }
    return self;
}

- (void)dealloc {
    self.parentPhotoViewController = nil;
    [super dealloc];
}

- (void)updateChrome {
    
    if (_photoSource.numberOfPhotos < 2) {
        self.title = _photoSource.title;
    } else {
        self.title = [NSString stringWithFormat:
                      TTLocalizedString(@"%d of %d", @"Current page in photo browser (1 of 10)"),
                      _centerPhotoIndex+1, _photoSource.numberOfPhotos];
    }    
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(hideLandscapePhotos)] autorelease];
}

- (void)showBarsAnimationDidStop {
    //    self.navigationController.navigationBarHidden = NO;
}

- (void)hideBarsAnimationDidStop {
    //    self.navigationController.navigationBarHidden = YES;
}

- (void)scrollView:(TTScrollView*)scrollView didMoveToPageAtIndex:(NSInteger)pageIndex; {
    [super scrollView:scrollView didMoveToPageAtIndex:pageIndex];
    if (self.parentPhotoViewController) {
        self.parentPhotoViewController.centerPhoto = self.centerPhoto;
    }
}

- (void)thumbsViewController:(TTThumbsViewController*)controller didSelectPhoto:(id<TTPhoto>)photo; {
    
    // Don't use the setter, since that will reset the _centerPhotoIndex as well
    _startingCenterPhotoIndex = TT_NULL_PHOTO_INDEX;
    
    [super thumbsViewController:controller didSelectPhoto:photo];
}

- (void)showBars:(BOOL)show animated:(BOOL)animated changeStatusBar:(BOOL)changeStatus; {
    
    CGFloat alpha = show ? 1.0f : 0.0f;
    
    id animationDelegate = self;
    SEL postAnimationSelector = show ? @selector(showBarsAnimationDidStop) : @selector(hideBarsAnimationDidStop);
    
    if (animated) {
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:TT_TRANSITION_DURATION];
        [UIView setAnimationDelegate:animationDelegate];
        
        if ([animationDelegate respondsToSelector:postAnimationSelector]) {
            [UIView setAnimationDidStopSelector:postAnimationSelector];
        }
        
    } else {
        if ([animationDelegate respondsToSelector:postAnimationSelector]) {
            [animationDelegate performSelector:postAnimationSelector];
        }
    }
    
    [self.navigationController setNavigationBarHidden:!show animated:NO];
    self.fadingToolbar.alpha = alpha;
    
    if (animated) {
        [UIView commitAnimations];
    }
    
    self.isShowingChrome = show;
}

@end
