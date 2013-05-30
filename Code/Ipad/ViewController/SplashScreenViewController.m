//
//  SplashScreenViewController.m
//  TruliaMap
//
//  Created by Michael Coutinho on 3/9/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//

#import "SplashScreenViewController.h"
#import "ICListingSearchController.h"
#import "ICListingParameters.h"
#import "ICPreference.h"
#import "ICMainViewControllerPad.h"

static NSString *WHATSNEW_MARKER = @"WHATSNEW_MARKER";

@implementation SplashScreenViewController
@synthesize shouldShowTMA, delegate;

#pragma mark -
#pragma mark Utility methods

- (void)initializeView {
    [self updateImageViewForOrientation:[UIApplication sharedApplication].statusBarOrientation];
    self.shouldShowTMA = NO;
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [[ICPreference sharedInstance] setAppForKey:WHATSNEW_MARKER withAttribute:currentVersion andSaveToDisk:YES];
}

-(void)updateVersion{
    
    self.shouldShowTMA = NO;
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	[[ICPreference sharedInstance] setAppForKey:WHATSNEW_MARKER withAttribute:currentVersion];
}

- (void)dismiss{
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(goingOutOfView:)]){
        [self.delegate goingOutOfView:self];
    }
}

+ (BOOL)isNewInstall {
    BOOL ret = NO;
    NSString *check = [[ICPreference sharedInstance] getAppForKey:@"HasBeenRunOnce"];
    
    if (!check) {
        ret = YES;
    }
    
    return ret;
}

+ (BOOL)shouldShowMe{
    
    NSString *lastVersionForWhichWhatsNewWasShown = (NSString *)[[ICPreference sharedInstance] getAppForKey:WHATSNEW_MARKER];
	
    if (!lastVersionForWhichWhatsNewWasShown) {
        lastVersionForWhichWhatsNewWasShown = @"0";
    }
	
	//users downloading 1.1 should not get this screen unless this is their first version...
    NSString *currentVersion = @"1.0"; //[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	
    return ([currentVersion compare:lastVersionForWhichWhatsNewWasShown options:NSNumericSearch] == NSOrderedDescending);
}

#pragma mark -
#pragma mark User actions

- (IBAction)actionForSale:(id)sender{
	[self dismiss];
}

- (IBAction)actionForRent:(id)sender{
	ICListingParameters *theParams = [[ICListingParameters alloc] init];
	theParams.indexType = [NSMutableArray arrayWithObject:@"for rent"];
	
	[theParams setLocationToCurrent];
	[[ICListingSearchController sharedInstance] searchWithParameters:theParams];
	
	[self dismiss];
}

- (IBAction)actionSplashScreenTapped:(id)sender {
    [self dismiss];
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad{

    [super viewDidLoad];
    
    [self initializeView];
}

- (void)viewWillDisappear:(BOOL)animated{
    
    self.shouldShowTMA = YES;
    
    
    [ICMainViewControllerPad sharedInstance].controlBarView.hidden = NO;

   
    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
    
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self updateImageViewForOrientation:toInterfaceOrientation];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (BOOL)shouldAutorotate{

    return YES;
}

- (void)viewWillLayoutSubviews{
    
}
- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation; {
	NSLog(@"rotation complete");
    
}

- (void)updateImageViewForOrientation:(UIInterfaceOrientation)inOrientation{
    
    self.splashImageView.image = UIInterfaceOrientationIsLandscape(inOrientation) ? [UIImage imageNamed:@"Splash-Landscape.png"] : [UIImage imageNamed:@"Splash-Portrait.png"];
    
    CGRect imageViewFrame = self.view.frame;
    imageViewFrame.origin.x = 0.0f;
    imageViewFrame.origin.y = 0.0f;
    imageViewFrame.size = self.splashImageView.image.size;
    self.view.frame = imageViewFrame;
    self.splashButton.frame = self.splashImageView.frame;
}


#if defined(__IPHONE_6_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_6_0
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
#endif

#pragma mark -
#pragma mark Object management

- (void)viewDidUnload {
    [super viewDidUnload];
}
       
@end
