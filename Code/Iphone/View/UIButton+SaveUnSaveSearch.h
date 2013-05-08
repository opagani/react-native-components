//
//  UIButton+SaveUnSaveSearch.h
//  Trulia
//
//  Created by Fawad Haider on 3/4/13.
//  Copyright (c) 2013 Trulia Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ICListingSearchViewContainerController.h"


@interface UIButton (SaveUnSaveSearch)
-(void)actionSaveUnsaveSearchInViewController:(UIViewController*)viewController saveAnimationBlock:(void (^)(void))animationBlock unsaveAnimationBlock:(void (^)(void))unsaveBlock currentMode:(ICListingSearchViewController_iPhoneViewMode)currentMode;
-(void)toggleSearchSaveButtonState:(BOOL)isAlreadySaved;

- (id)getSearch;
- (void)setSearch:(id)search;

@end
