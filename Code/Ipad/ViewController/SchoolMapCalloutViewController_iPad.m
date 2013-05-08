//
//  SchoolMapCalloutViewController_iPad.m
//  TruliaMap
//
//  Created by Jack Kwok on 5/21/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "SchoolMapCalloutViewController_iPad.h"

@interface SchoolMapCalloutViewController_iPad ()

@end

@implementation SchoolMapCalloutViewController_iPad
@synthesize name;
@synthesize address;
@synthesize gradeLevels;
@synthesize phone;
@synthesize numberOfStudents;
@synthesize ratings;
@synthesize type;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)setSchoolName:(NSString *)schoolName
{
    [name setText:schoolName];
}

- (void)setSchoolType:(NSString *)schoolType 
{
    [type setText:schoolType];
}

- (void)setSchoolGrades:(NSString *)schoolGrades
{
    [gradeLevels setText:schoolGrades];
}

- (void)setSchoolPhoneNumber:(NSString *)schoolPhoneNumber
{
    [phone setText:schoolPhoneNumber];
}

- (void)setSchoolAddress:(NSString *)schoolAddress
{
    [address setText:schoolAddress];
}

-(void)setSchoolRatings:(NSString *)schoolRatings
{
    [ratings setText:schoolRatings];
}

- (void)setSchoolStudentCount:(NSString *)schoolStudentCount;
{
    [numberOfStudents setText:schoolStudentCount];
}

@end
