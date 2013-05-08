//
//  HelpViewController_iPad.m
//  TruliaMap
//
//  Created by Michael Coutinho on 5/10/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//

#import "HelpViewController_iPad.h"
#import "MainViewController_iPad.h"
#import "ICMetricsController.h"
#import "ICGenericWebViewController.h"

@interface HelpViewController_iPad (Private)
- (void)refreshViewExceptTag:(NSUInteger)theTag;
- (void)didRotate:(NSNotification *)notification;
@end


@implementation HelpViewController_iPad
@synthesize isVisible, btnClose, viewHelp;


#pragma mark -
#pragma mark Utility methods

- (void)registerView:(UIView *)theView withName:(NSString *)name; {
}

- (void)presentInView:(UIView *)parentView showKeyboard:(BOOL)showKeyboard; {
	[viewHelp reset];
    [[ICMetricsController sharedInstance] trackPageView:[ICMetricsController PAGE_OPENHELP]];
    
	self.isVisible = YES;
	
	[self.view setNeedsLayout];
    [self.viewHelp setNeedsDisplay];
    
	[self viewWillAppear:NO];
	
	self.view.alpha = 0.0f;
	self.view.frame = CGRectMake(0.0f, 0.0f, parentView.bounds.size.width, parentView.bounds.size.height);
	
	[parentView insertSubview:self.view aboveSubview:[parentView viewWithTag:CONTROL_BAR]];
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.4];
	self.view.alpha = 1.0f;
	[UIView commitAnimations];	
	
	[self viewDidAppear:NO];
}

- (void)presentInView:(UIView *)parentView; {
	[self presentInView:parentView showKeyboard:NO];
}

- (void)dismissView; {
	self.isVisible = NO;
	
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.2];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationBeginsFromCurrentState:YES];
	[UIView setAnimationDidStopSelector:@selector(dismissViewEnd:finished:context:)];
	self.view.alpha = 0.0f;
	[UIView commitAnimations];	
}

- (void)dismissViewEnd:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context; {
	if (self.isVisible == NO) 
		[self.view removeFromSuperview];
}


#pragma mark -
#pragma mark User actions

- (IBAction)actionViewFeedback:(id)sender; {
	ICGenericWebViewController *viewController = [[ICGenericWebViewController alloc] init];
    viewController.isFeedback = YES;
	viewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:viewController];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	navController.navigationBar.tintColor = [UIColor blackColor];
	
	[[MainViewController_iPad sharedInstance] presentModalViewController:navController animated:YES];
}

- (IBAction)actionViewFaq:(id)sender; {
	WebViewController *viewController = [[WebViewController alloc] initWithNibName:@"WebViewController" bundle:nil];
	viewController.delegate = self;
	
	UINavigationController *navController = [[UINavigationController alloc]
											 initWithRootViewController:viewController];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	navController.navigationBar.tintColor = [UIColor blackColor];
	
	[[MainViewController_iPad sharedInstance] presentModalViewController:navController animated:YES];
}

- (IBAction)actionCloseHelp:(id)sender; {
	[self dismissView];
}



#pragma mark -
#pragma mark ModalViewControllerDelegate methods
- (void)didDismissModalView; {
	[[MainViewController_iPad sharedInstance] dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark View lifecycle

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)viewDidLoad; {
    [btnClose setBackgroundImage:[[UIImage imageNamed:@"redButton.png"] stretchableImageWithLeftCapWidth:8 topCapHeight:4] forState:UIControlStateNormal];
    
}

- (void)viewDidUnload {
	[super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated; {
	//[super viewWillAppear:animated]; -causing layout issues
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(didRotate:)
												 name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
}

- (void)viewWillDisappear:(BOOL)animated {
	[[NSNotificationCenter defaultCenter] removeObserver:self
													name:@"UIDeviceOrientationDidChangeNotification" object:nil];
	
	[super viewWillDisappear:NO];
}

- (void)didRotate:(NSNotification *)notification; {
	[self.viewHelp setNeedsDisplay];
	//[self.webView stringByEvaluatingJavaScriptFromString:@"handleOrientationChange()"];
}


#pragma mark -
#pragma mark Object management

- (void)didReceiveMemoryWarning; {
    [super didReceiveMemoryWarning];
}

+ (HelpViewController_iPad *)sharedInstance {
	static dispatch_once_t pred;
	static HelpViewController_iPad *sharedInstance = nil;
    
    //now that we are on 4.0+ we can use grand central dispatch
	dispatch_once(&pred, ^{ sharedInstance = [[self alloc] init]; });
	return sharedInstance;
}

@end
