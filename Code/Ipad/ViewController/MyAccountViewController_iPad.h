//
//  MyAccountViewController_iPad.h
//  TruliaMap
//
//  Created by Daniel Lowrie on 7/25/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyAccountViewController_iPad : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, strong) NSMutableArray *optionNameArray;
@property (nonatomic, strong) NSMutableArray *optionActionArray;
@property (nonatomic, strong) IBOutlet UITableView *moreInformationTableView;

@property (nonatomic, strong) IBOutlet UIView *notLoggedInView;
@property (nonatomic, strong) IBOutlet UIButton *loginButton;
@property (nonatomic, strong) IBOutlet UIButton *getAccountButton;

@property (nonatomic, strong) IBOutlet UIView *loggedInView;
@property (nonatomic, strong) IBOutlet UIButton *syncButton;
@property (nonatomic, strong) IBOutlet UILabel *lastSyncedLabel;
@property (nonatomic, strong) IBOutlet UILabel *syncingLabel;
@property (nonatomic, strong) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (nonatomic, strong) IBOutlet UILabel *greetingLabel;
@property (nonatomic, strong) IBOutlet UILabel *versionLabel;


-(IBAction)actionLogout:(id)sender;
-(IBAction)actionLogin:(id)sender;
-(IBAction)actionGetAccount:(id)sender;
-(IBAction)actionSync:(id)sender;

@end
