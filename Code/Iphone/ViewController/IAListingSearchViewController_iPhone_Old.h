//
//  IAListingSearchViewController_iPhone.h
//  Trulia
//
//  Created by Daniel Lowrie on 1/24/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "IAListingCalloutView_iPhone.h"
#import "IAListingDetailViewController_iPhone.h"
#import "IAListingTabbedViewController_iPhone.h"
#import "ICListingSearchViewController_iPhone.h"
#import "IAListingRefineViewController_iPhone.h"
#import "IAListingSearchGalleryViewController_iPhone.h"
#import "IAFilterViewController_iPhone.h"
#import "CustomBadge.h"

@class IATMAdViewController_iPhone;
@interface IAListingSearchViewController_iPhone_Old : ICListingSearchViewController_iPhone <UIActionSheetDelegate, UITextFieldDelegate, IAListingCalloutView_iPhoneDelegate, IAListingSearchGalleryViewControllerDelegate, ICFilterViewController_iPhoneDelegate, IAListingRefineViewController_iPhoneDelegate, ICPostLoginProtocol> {
    
    BOOL mapLoaded, resetOldMapRegion, isRotating;
    CLLocationManager *locManager;
    
    BOOL isFrozen;
    BOOL isTMAListViewReady;
    BOOL isFilterViewVisible;
    
    
    //TMA
    IATMAdViewController_iPhone *mapTmaAdController;
    IATMAdViewController_iPhone *listTmaAdController;
}

@property (nonatomic, assign) MKCoordinateRegion oldMapRegion;
@property (nonatomic, strong) IAListingCalloutView_iPhone *listingCalloutView;
@property (nonatomic, strong) IAListingDetailViewController_iPhone *listingDetailViewController;

@property (nonatomic, strong) IBOutlet UIButton *btnRefine;
@property (nonatomic, strong) IBOutlet UIButton *btnMapListToggle;
@property (nonatomic, strong) IBOutlet UIButton *btnSaveUnsaveToggle;
@property (nonatomic, strong) IBOutlet UIButton *btnFlexPosition;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbarSourceItems;

@property (nonatomic, strong) UIButton *mapTypeToggleButton;

@property (nonatomic, strong) IAListingSearchGalleryViewController_iPhone *galleryViewController;
@property (nonatomic, assign) BOOL showingGalleryView;
@property (nonatomic, strong) UIView *animatedView;

@property (nonatomic, assign) BOOL isFrozen;

@property (nonatomic, strong) CustomBadge *notificationBadge;

//TMA
@property (nonatomic, strong) IATMAdViewController_iPhone *mapTmaAdController;
@property (nonatomic, strong) IATMAdViewController_iPhone *listTmaAdController;
@property (nonatomic, assign) BOOL isTMAListViewReady;
@property (nonatomic, assign) BOOL isFilterViewVisible;


- (void)trackPageView;
- (void)actionRedoSearch:(id)sender;
- (void)actionMapTypeToggle:(id)sender;
- (IBAction)actionShowRefine:(id)sender;
- (IBAction)actionToggleSaveUnsave:(id)sender;
- (IBAction)actionFlexPosition:(id)sender;
- (IBAction)actionChooseLayer:(id)sender;
- (IBAction)actionShowSort:(id)sender;
- (IBAction)actionToggleMapListView:(id)sender;
- (IBAction)actionSearchNearby:(id)sender;
- (IBAction)actionShowMyAccount:(id)sender;
- (IBAction)actionCancelModal:(id)sender;

- (void)startLoading;
//-(void)setSearchCriteria:(NSTimer *)_timer;
- (void)setMapType:(MKMapType)theType;

- (void)animateStarToMyAccountButton;
- (void)currentLocationSelected;

@end
