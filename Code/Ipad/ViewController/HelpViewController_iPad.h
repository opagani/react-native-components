//
//  HelpViewController_iPad.h
//  TruliaMap
//
//  Created by Michael Coutinho on 5/10/11.
//  Copyright 2011 Trulia Inc. All rights reserved.
//

#import "GRViewController.h"
#import "HelpView_iPad.h"

@interface HelpViewController_iPad : GRViewController  {
	BOOL isVisible;
    IBOutlet UIButton *btnClose;
    IBOutlet HelpView_iPad *viewHelp;
}

@property(nonatomic,assign) BOOL isVisible;
@property(nonatomic,strong) IBOutlet UIButton *btnClose;
@property(nonatomic,strong) IBOutlet HelpView_iPad *viewHelp;

+ (HelpViewController_iPad *)sharedInstance;

- (void)presentInView:(UIView *)parentView;
- (void)presentInView:(UIView *)parentView showKeyboard:(BOOL)showKeyboard;
- (void)dismissView;

- (void)registerView:(UIView *)theView withName:(NSString *)name;

- (IBAction)actionCloseHelp:(id)sender;
- (IBAction)actionViewFeedback:(id)sender;
- (IBAction)actionViewFaq:(id)sender;


@end
