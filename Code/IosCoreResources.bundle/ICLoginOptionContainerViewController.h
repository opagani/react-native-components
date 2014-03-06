//
//  ICLoginOptionContainerViewController.h
//  IosCore
//
//  Created by Garrett Richards on 7/22/13.
//  Copyright (c) 2013 Trulia. All rights reserved.
//

#import "ICBaseViewController.h"
#import "UIViewController+ICTransitions.h"
#import "ICPostLoginProtocol.h"
#import "ICAttributedLabelButton.h"
#import "UIControl+ICBlockAdditions.h"



typedef enum {
    ICLOGIN_FORCE,
    ICLOGIN_OPTIONAL

} ICLoginBehavior;

@interface ICLoginOptionContainerViewController : ICBaseViewController<ICPostLoginProtocol> 

@property (copy) void (^dismissViewBlock)(BOOL animated);
@property (copy) ICPostLoginProtocolPerformPostAttemptActionBlock performPostAttemptActionBlock;
@property(nonatomic, assign) PostLoginActionType postLoginActionType;
- (instancetype)initWithOption:(ICLoginBehavior)behavior;


-(void) slideInLoginOptions;// making it overridable
@property(nonatomic, strong) UIView * vwLoginOptions;
-(ICAttributedLabelButton*)createButtonWithTop:(NSInteger)top left:(NSInteger)left size:(CGSize)size text:(NSString*)text
                                 boldRangeText:(NSString*)boldRangeText image:(UIImage*)image handler:(ICControlEventHandler)handler;
- (void)actionCreate:(id)sender;
- (void)actionLogin:(id)sender;
@end
