//
//  AppDelegate_Shared.h
//  TruliaMap
//
//  Created by Michael Coutinho on 8/27/10.
//  Copyright Trulia Inc. 2010. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "ICAppDelegate.h"

@interface AppDelegate_Shared : ICAppDelegate {
    UIWindow *window;
    
@private
    NSManagedObjectContext *managedObjectContext_;
    //    NSManagedObjectModel *managedObjectModel_;
    //    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}

@property(nonatomic,strong) IBOutlet UIWindow *window;

- (NSString *)applicationDocumentsDirectory;

@end
