//
//  ViewControllerTests.m
//  Trulia
//
//  Created by Fawad Haider on 11/28/12.
//  Copyright (c) 2012 Trulia Inc. All rights reserved.
//

#import "ViewControllerTests.h"
#import "ICMoreViewController.h"
#import "OCMock.h"

@interface ViewControllerTests()

@property(nonatomic, retain) ICMoreViewController *moreViewController;
@property(nonatomic, retain) ICMoreViewController *viewController;
@property(nonatomic, retain) UIWindow *mockWindow;
@property(nonatomic, retain) id mockNavigationController;
@property(nonatomic, retain) id mockNavigationBar;
@property(nonatomic, retain) id mockNavigationItem;

@end

@implementation ViewControllerTests

- (void)setUp
{
    [super setUp];
    self.moreViewController = [[ICMoreViewController alloc] init] ;
    [self setupController];
}

- (void)tearDown
{
    // Tear-down code here.
    self.moreViewController = nil;
}

- (void)expectViewDidLoad {
    [[self.mockTableView expect] setBackgroundColor:OCMOCK_ANY];
    [[self.mockView expect] setBackgroundColor:OCMOCK_ANY];
}

- (void)performViewDidLoad {
    [self expectViewDidLoad];
    [self.moreViewController viewDidLoad];
    [self.mockView verify];
}

-(void)setupController{
    
    self.viewController = [OCMockObject partialMockForObject:self.moreViewController];
    self.mockWindow = [OCMockObject mockForClass:[UIWindow class]];
    self.mockView = [OCMockObject niceMockForClass:[UIView class]];
    self.mockTableView = [OCMockObject niceMockForClass:[UITableView class]];
    
    [[[self.mockView stub] andReturn:self.mockWindow] window];
    
    [[[(id)self.viewController stub] andDo:^(NSInvocation* inv) {
        UIView *currentMock = self.mockView;
        [inv setReturnValue:&currentMock];
    }] view];
    
    [[[(id)self.viewController stub] andDo:^(NSInvocation* inv) {
        UIView *currentMock = self.mockTableView;
        [inv setReturnValue:&currentMock];
    }] tableView];
    
    self.mockNavigationController = [OCMockObject niceMockForClass:[UINavigationController class]];
    [[[(id)self.viewController stub] andReturn:self.mockNavigationController] navigationController];
    
    self.mockNavigationBar = [OCMockObject niceMockForClass:[UINavigationBar class]];
    [[[self.mockNavigationController stub] andReturn:self.mockNavigationBar] navigationBar];
    
    self.mockNavigationItem = [OCMockObject niceMockForClass:[UINavigationItem class]];
    [[[(id)self.viewController stub] andReturn:self.mockNavigationItem] navigationItem];
    
    self.moreViewController = self.viewController;
    self.mockDelegate = [OCMockObject mockForProtocol:@protocol(UITableViewDelegate)];
}

- (void)testViewDidLoad {
    [self performViewDidLoad];
}
/*
-(void)testFooterView{
    [[self.mockTableView expect] setTableFooterView:OCMOCK_ANY];
    [self.moreViewController setupFooterView];
    [self.mockTableView  verify];
}
 */


@end
