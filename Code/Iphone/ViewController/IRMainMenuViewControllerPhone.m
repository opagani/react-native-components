//
//  IRMainMenuViewControllerPhone.m
//  Trulia Rent
//
//  Created by Daud Kabiri on 9/15/14.
//  Copyright (c) 2014 Trulia Inc. All rights reserved.
//

#import "IRMainMenuViewControllerPhone.h"
#import "IRBoardManagerViewController.h"
#import "IRMySavedHomesViewController.h"

@interface IRMainMenuViewControllerPhone ()

@end

@implementation IRMainMenuViewControllerPhone


#pragma mark Overridden Menu Items IndexPaths
-(NSIndexPath*)savesIndexPath{
    return [NSIndexPath indexPathForRow:([UIDevice isPhone] ? IRMainMenuViewControllerPhoneSaveTypeMySavesRental :
                                                              IRMainMenuViewControllerPhoneSaveTypeMySavesIpadRental)
                                                              inSection:1];
}


-(void)actionBoardsClicked:(id)sender{
    
    IRBoardManagerViewController * boardManager = [IRBoardManagerViewController new];
    [self closeMenuAndShowViewController:boardManager];
    
}

- (void)presentMySavedHomesViewController{
    IRMySavedHomesViewController * controller = [IRMySavedHomesViewController new];
    [self closeMenuAndShowViewController:controller];
}

@end
