//
//  SchoolMapCalloutViewController_iPad.h
//  
//
//  Created by Jack Kwok on 5/21/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SchoolMapCalloutViewController_iPad : UIViewController {
    UILabel *name;
    UILabel *address;
    UILabel *phone;
    UILabel *numberOfStudents;
    UILabel *ratings;
    UILabel *gradeLevels;
    UILabel *type;
}

@property(nonatomic,strong) IBOutlet UILabel *name;
@property(nonatomic,strong) IBOutlet UILabel *address;
@property(nonatomic,strong) IBOutlet UILabel *phone;
@property(nonatomic,strong) IBOutlet UILabel *numberOfStudents;
@property(nonatomic,strong) IBOutlet UILabel *ratings;
@property(nonatomic,strong) IBOutlet UILabel *gradeLevels;
@property(nonatomic,strong) IBOutlet UILabel *type;

- (void)setSchoolName:(NSString *)schoolName;
- (void)setSchoolType:(NSString *)schoolType;
- (void)setSchoolGrades:(NSString *)schoolGrades;
- (void)setSchoolPhoneNumber:(NSString *)schoolPhoneNumber;
- (void)setSchoolAddress:(NSString *)schoolAddress;
- (void)setSchoolRatings:(NSString *)schoolRatings;
- (void)setSchoolStudentCount:(NSString *)schoolStudentCount;
@end
