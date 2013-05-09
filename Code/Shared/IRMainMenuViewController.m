//
//  IRMainMenuViewController.m
//  IosRentalUniversal
//
//  Created by John Zorko on 5/9/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import "IRMainMenuViewController.h"
#import "ICFindAgentViewController.h"
#import "ICMoreViewController.h"
#import "ICMainMenuViewControllerPhone.h"
#import "ICMyAccountViewControllerPhone.h"

#define MENU_FIND_AN_AGENT_STRING @"Find an Agent"
#define MENU_OPEN_HOUSES_STRING   @"Open Houses"
#define MENU_RENT_STRING          @"Homes For Rent"
#define MENU_SALE_STRING          @"Homes For Sale"
#define MENU_MY_SAVES_STRING      @"My Saves"
#define MENU_SETTINGS_STRING      @"Settings & More"

@interface IRMainMenuViewController ()

@end

@implementation IRMainMenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSArray*)getOptionListForIdiom:(UIUserInterfaceIdiom)idiom{
    return [[NSArray alloc] initWithObjects:
            [NSDictionary dictionaryWithObjectsAndKeys:MENU_MY_SAVES_STRING, @"title", [NSNumber numberWithInt:My_Saves], @"search",[[ICMyAccountViewControllerPhone alloc] initWithNibName:@"ICMyAccountViewControllerPhone" bundle:[NSBundle coreResourcesBundle]], @"target", @"IconMenuMySaves", @"image",@"my-saves", @"track", nil],
            [NSDictionary dictionaryWithObjectsAndKeys:MENU_RENT_STRING, @"title",[NSNumber numberWithInt:For_Rent], @"search" , @"IconMenuForRent", @"image",@"search-for-rent", @"track", nil],
            [NSDictionary dictionaryWithObjectsAndKeys:MENU_SETTINGS_STRING, @"title",[[ICMoreViewController alloc] initWithStyle:UITableViewStylePlain],@"target", @"IconMenuSettings", @"image",@"more", @"track", nil],
            nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
