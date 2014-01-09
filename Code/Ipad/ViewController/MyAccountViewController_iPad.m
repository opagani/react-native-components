//
//  MyAccountViewController_iPad.m
//  TruliaMap
//
//  Created by Daniel Lowrie on 7/25/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//

#import "MyAccountViewController_iPad.h"
#import "ICAccountController.h"
#import "ICSyncController.h"
#import "ICManagedMembership.h"
#import "ICMainViewControllerPad.h"
#import "ICUtility.h"

@implementation MyAccountViewController_iPad
@synthesize optionNameArray = _optionNameArray;
@synthesize optionActionArray = _optionActionArray;
@synthesize moreInformationTableView = _moreInformationTableView;
@synthesize notLoggedInView = _notLoggedInView;
@synthesize loginButton = _loginButton;
@synthesize getAccountButton = _getAccountButton;
@synthesize loggedInView = _loggedInView;
@synthesize syncButton = _syncButton;
@synthesize lastSyncedLabel = _lastSyncedLabel;
@synthesize syncingLabel = _syncingLabel;
@synthesize greetingLabel = _greetingLabel;
@synthesize activityIndicator = _activityIndicator;


#pragma mark -
#pragma mark user actions

-(IBAction)actionLogin:(id)sender; {
    
    [[[ICMainViewControllerPad sharedInstance] myAccountPopoverController] dismissPopoverAnimated:NO];
    
    [[ICMetricsController sharedInstance] trackClick:@"general|login"];
}

-(IBAction)actionGetAccount:(id)sender; {
    
    [[[ICMainViewControllerPad sharedInstance] myAccountPopoverController] dismissPopoverAnimated:NO];
    [[ICMetricsController sharedInstance] trackClick:@"general|register"];
}

-(IBAction)actionSync:(id)sender; {
    
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:NO];
    [_syncingLabel setHidden:NO];
    [_lastSyncedLabel setHidden:YES];
    [[ICMetricsController sharedInstance] trackClick:@"general|sync"];
    
    [[ICSyncController sharedInstance] sync];
    
}

-(IBAction)actionLogout:(id)sender; {
    
    [[ICAccountController sharedInstance] logout];
    [[ICMetricsController sharedInstance] trackClick:@"general|logout"];
    
}

#pragma mark -
#pragma mark UITableViewDelegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
    NSString *action = [_optionActionArray objectAtIndex:indexPath.row];
    
    if ([action isEqualToString:@"debug"]) {
#ifdef DEBUG
        //launch hockey
        //        BWHockeyViewController *hockeyViewController = [[BWHockeyManager sharedHockeyManager] hockeyViewController:NO];
        //        [hockeyViewController setContentSizeForViewInPopover:self.view.frame.size];
        //        [self.navigationController pushViewController:hockeyViewController animated:YES];
#endif
    }
    else {
        
        UIViewController *viewController = [[UIViewController alloc] init];
        UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
        [viewController setView:webView];
        [viewController setTitle:[_optionNameArray objectAtIndex:indexPath.row]];
        [viewController setContentSizeForViewInPopover:self.view.frame.size];
        [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@?config=viewportWidth-320&chrome=none",IC_URL_MOBILESITE,action]]]];            
        [self.navigationController pushViewController:viewController animated:YES];            
    }   
}


#pragma mark -
#pragma mark UITableViewDataSource methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_optionNameArray count];
	
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    
    static NSString *cellIdentifier = @"MY_ACCOUNT_CELL";    
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setBackgroundColor:[UIColor colorWithRed:228.0/255.0 green:228.0/255.0 blue:228.0/255.0 alpha:1.0]];
    }
    
    UILabel *celltextLabel = cell.textLabel;
    [celltextLabel setTextColor:[UIColor blackColor]];
    [celltextLabel setText:[_optionNameArray objectAtIndex:indexPath.row]];
    
    return cell;
}

#pragma mark -
#pragma mark lifecycle methods

- (void)userDidLogin:(NSNotification *) notification; {
    
    [_loggedInView setHidden:NO];
    [_notLoggedInView setHidden:YES];
    
    NSDate *lastSyncDate = nil;
    
    if (lastSyncDate != nil) {
        NSString *dateString = [NSDateFormatter localizedStringFromDate:lastSyncDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle];
        [_lastSyncedLabel setText:[NSString stringWithFormat:@"Last Sync: %@", dateString]];
    }
    
    if ([[ICAccountController sharedInstance] userName] != nil) {
        [_greetingLabel setText:[NSString stringWithFormat:@"Hello, %@!", [[ICAccountController sharedInstance] userName]]];
    }
    
    UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(actionLogout:)];
    [[self navigationItem] setRightBarButtonItem:bbItem];
}

- (void)userDidLogout:(NSNotification *) notification; {
    
    [_loggedInView setHidden:YES];
    [_notLoggedInView setHidden:NO];
    
    [[self navigationItem] setRightBarButtonItem:nil];
}

- (void)fullSyncDidComplete:(NSNotification *)notification; {
    
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:YES];
    [_syncingLabel setHidden:YES];
    [_lastSyncedLabel setHidden:NO];
    
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)init {
    
    self = [super initWithNibName:@"MyAccountViewController_iPad" bundle:nil];
    if (self) {
        
        [self setContentSizeForViewInPopover:CGSizeMake(320, 400)];
        [self setTitle:@"My Account"];
        
        if ([[ICAccountController sharedInstance] isLoggedIn]) {
            UIBarButtonItem *bbItem = [[UIBarButtonItem alloc] initWithTitle:@"Logout" style:UIBarButtonItemStylePlain target:self action:@selector(actionLogout:)];
            [[self navigationItem] setRightBarButtonItem:bbItem];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogin:) name:@"ICAccountControllerDidLogInNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidLogout:) name:@"ICAccountControllerDidLogOutNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(fullSyncDidComplete:) name:@"ICSyncControllerForcedSyncEndNotification" object:nil];
        
        self.optionNameArray = [NSMutableArray arrayWithObjects:@"About Trulia", @"Feedback", @"Terms of Use", @"Privacy Policy", nil];
        
        self.optionActionArray = [NSMutableArray arrayWithObjects:@"/about/", @"/leave_feedback/", @"/terms/", @"/privacy/", nil];
        
    }
    
    return self;
    
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated; {
    [super viewDidAppear:animated];
    
    [[ICMetricsController sharedInstance] trackPageView:[ICMetricsController PAGE_SETTING]];
}

- (void)viewDidLoad
{
    //    NSLog(@"%@: viewDidLoad", [self class]);
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [_activityIndicator startAnimating];
    [_activityIndicator setHidden:YES];
    [_syncingLabel setHidden:YES];
    [_lastSyncedLabel setHidden:NO];
    
    [_moreInformationTableView setScrollEnabled:NO];
    
#ifdef DEBUG
    
    //    [_optionNameArray addObject:@"Debug Info"];
    //    [_optionActionArray addObject:@"debug"];
    //    
    //    [_moreInformationTableView setScrollEnabled:YES];
    
#endif

    [_versionLabel setText:[ICUtility applicationVersionNumber]];

    [_loginButton setBackgroundImage:[[UIImage imageNamed:@"greenButtonTall"] stretchableImageWithLeftCapWidth:8 topCapHeight:4] forState:UIControlStateNormal];
    [_getAccountButton setBackgroundImage:[[UIImage imageNamed:@"grayButtonTall"] stretchableImageWithLeftCapWidth:8 topCapHeight:4] forState:UIControlStateNormal];
    [_syncButton setBackgroundImage:[[UIImage imageNamed:@"greenButtonTall"] stretchableImageWithLeftCapWidth:8 topCapHeight:4] forState:UIControlStateNormal];
    
    [_moreInformationTableView setBackgroundView:nil];
    [_moreInformationTableView setBackgroundColor:[UIColor clearColor]];
    
    if ([[ICAccountController sharedInstance] isLoggedIn]) {
        [_loggedInView setHidden:NO];
        [_notLoggedInView setHidden:YES];
        
        NSDate *lastSyncDate = nil;
        
        //format this date....
        
        if (lastSyncDate != nil) {
            NSString *dateString = [NSDateFormatter localizedStringFromDate:lastSyncDate dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]; //[dateFormatter stringFromDate:lastSyncDate];
            [_lastSyncedLabel setText:[NSString stringWithFormat:@"Last Sync: %@", dateString]];
        }
        
        if ([[ICAccountController sharedInstance] userName] != nil) {
            [_greetingLabel setText:[NSString stringWithFormat:@"Hello %@!", [[ICAccountController sharedInstance] userName]]];
        }
        
    }
    else {
        [_loggedInView setHidden:YES];
        [_notLoggedInView setHidden:NO];
    }
    
    
}

#pragma mark -
#pragma mark ICPostLoginProtocol Methods

- (void)loginViewController:(UIViewController *)loginViewController dismissViewAnimated:(BOOL)animated{
    
    [[ICMainViewControllerPad sharedInstance] dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return YES; // (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
