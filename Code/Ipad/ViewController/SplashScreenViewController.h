//
//  SplashScreenViewController.h
//  TruliaMap
//
//  Created by Michael Coutinho on 3/9/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//


@protocol SplashViewDelegate <NSObject>
-(void)goingOutOfView:(UIViewController*)viewController;
@end

@interface SplashScreenViewController : UIViewController {

    BOOL shouldShowTMA;
}
@property(nonatomic,assign) BOOL shouldShowTMA;
@property (retain, nonatomic) IBOutlet UIImageView *splashImageView;
@property (retain, nonatomic) IBOutlet UIButton *splashButton;
@property(nonatomic,weak) id <SplashViewDelegate> delegate;

+ (BOOL)shouldShowMe;

-(void)updateVersion;

- (IBAction)actionForSale:(id)sender;
- (IBAction)actionForRent:(id)sender;
- (IBAction)actionSplashScreenTapped:(id)sender;

- (void)dismiss;

@end
