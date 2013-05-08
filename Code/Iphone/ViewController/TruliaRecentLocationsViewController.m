    //
//  TruliaRecentLocationsViewController.m
//  Trulia
//
//  Created by Bill Kunz on 6/28/10.
//  Copyright 2010 Trulia, Inc. All rights reserved.
//

#import "TruliaRecentLocationsViewController.h"
#import "ICListingSearchController.h"
#import "IC+UIColor.h"
#import "MCSegmentedControl.h"
#import "IASavedObjectsTableViewController_iPhone.h"

@implementation NSArray(FunctionalStyle) 

- (NSArray*)filter:(BOOL(^)(id elt))filterBlock { // 
    //Create a new array 
    id filteredArray = [NSMutableArray array]; 
    // Collect elements matching the block condition 
    for (id elt in self) 
        if (filterBlock(elt))	
            [filteredArray addObject:elt]; 
    return	filteredArray; 
} 

@end 



@implementation ICManagedSearch(gettitle)

- (NSString *)describeMe{
    NSString* description = self.searchLabel;
    
    if (description == nil || [description isEqualToString:@""]) {
        
        description = [NSString stringWithFormat:@"%@ | %@", [self locationString], [[self title] capitalizedString]];
        
    }
    
    return description;
}
@end

@interface TruliaRecentLocationsViewController()

@property (retain, nonatomic) NSArray*                                  currentDataArray;
@property (retain, nonatomic) NSArray*                                  savedSearches;
@property (retain, nonatomic) ICLocationAutoCompleteRequest*            autoCompleteRequest;
@property (retain, nonatomic) NSArray*                                  autoCompleteLocations;
@property (assign, nonatomic) BOOL                                      currentLocationShown;
@property (assign, nonatomic) MCSegmentedControl*                       segmentedControl;

- (NSString *)locationStringFromShortcut:(NSString *)possibleShortcutString;
- (void)addLocation:(NSString *)newLocation;
- (void)removeLocation:(NSString *)location;

@end

@implementation TruliaRecentLocationsViewController
@synthesize autoCompleteRequest = _autoCompleteRequest, 
            autoCompleteLocations = _autoCompleteLocations, 
            currentLocationShown = _currentLocationShown,
            segmentedControl = _segmentedControl,
            currentDataArray = _currentDataArray,
            savedSearches = _savedSearches;

- (id)initWithSearchParameters:(ICListingParameters *)pSearchParameters{
    
    if ((self = [super initWithNibName:nil bundle:nil])) {
        
        _autoCompleteRequest = [[ICLocationAutoCompleteRequest alloc] init];
        _autoCompleteRequest.delegate = self;
        _currentLocationShown = YES;
        

        self.searchParameters = pSearchParameters;
        self.recentSearchHistoryFilename = IC_TRULIA_RECENT_LOCATIONS_FILENAME;
        self.recentSearchHistory = [self restoreHistory];
    }
    
    return self;
}

-(void)dealloc{
    
    _autoCompleteRequest.delegate = nil;
    [_autoCompleteRequest release] , _autoCompleteRequest = nil;
    [super dealloc];

}

#define HEIGHT_SEGMENTED_CONTROL 27
#define VERTICAL_PADDING_SEGEMENTED_CONTROL 10

#define CGAdjustYSetPos( r, x, y ) CGRectMake( x, y, r.size.width, r.size.height - y )

- (MCSegmentedControl *)segmentedControlWithItems:(NSArray *)items andFrame:(CGRect)frame{
    
    MCSegmentedControl *segmentedControl = [[[MCSegmentedControl alloc] initWithItems:items] autorelease];
	segmentedControl.frame = frame;//CGRectMake(6.0f, 10.0f, 310.0f, 27.0f);
	segmentedControl.tintColor = [UIColor colorFromHexString:@"5EAB1F"];
	
    segmentedControl.font = [UIFont boldSystemFontOfSize:12.0f];
	segmentedControl.selectedItemColor   = [UIColor whiteColor];
	segmentedControl.unselectedItemColor = [UIColor blackColor];
    segmentedControl.cornerRadius = 6.0f;
    segmentedControl.dontDrawGradient = YES;
    segmentedControl.unSelectedItemBackgroundGradientColors = [NSArray arrayWithObjects:
                                                               [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1.0],nil];
    return segmentedControl;
}

-(void)addSegmentedControlAndAdjustTableView{
    
    NSArray* items = [NSArray arrayWithObjects:@"Suggestions", @"Saved", @"Recent",nil];
    _segmentedControl = [self segmentedControlWithItems:items andFrame:CGRectMake(5.0f, 3 + VERTICAL_PADDING_SEGEMENTED_CONTROL + self.searchTextField.frame.origin.x + self.searchTextField.frame.size.height, 310.0f,  HEIGHT_SEGMENTED_CONTROL)];
    
    self.tableView.frame = CGRectMake(0, _segmentedControl.frame.origin.y + HEIGHT_SEGMENTED_CONTROL + (VERTICAL_PADDING_SEGEMENTED_CONTROL/2), self.tableView.frame.size.width, self.tableView.frame.size.height - VERTICAL_PADDING_SEGEMENTED_CONTROL - HEIGHT_SEGMENTED_CONTROL);
    
    [self.view addSubview:_segmentedControl];
    self.view.backgroundColor = [UIColor colorFromHexString:@"e9e9e9"];
    [self.segmentedControl addTarget:self action:@selector(segmentedControlDidChange:) forControlEvents:UIControlEventValueChanged];
    
}

- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    [self addSegmentedControlAndAdjustTableView];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.searchTextField.delegate = self;
    
    [self.searchTextField addTarget:self action:@selector(textFieldTextDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    self.segmentedControl.selectedSegmentIndex = 0;
    self.currentDataArray = self.autoCompleteLocations;
}

- (void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    if([self class].shouldClearTxtField){
        self.searchTextField.placeholder = ICLocalizedString(@"SearchFieldPlaceholder");
        [self class].shouldClearTxtField = NO;
    }
    else
        self.searchTextField.text = self.searchParameters.srch;
}

#pragma mark -
#pragma mark Override methods

- (void)savedSearchSelected:(ICManagedSearch*)search{
        
    if ([self.delegate respondsToSelector:@selector(recentSearchHistoryController:didChangeParams:)]) {
        [self.delegate recentSearchHistoryController:self didChangeParams:search];
    }
}

- (void)searchTermDidChange:(NSString *)searchTerm{
    
    [self addLocation:searchTerm];
    
    if ([self.delegate respondsToSelector:@selector(recentSearchHistoryController:didChangeSearchText:)]) {
        [self.delegate recentSearchHistoryController:self didChangeSearchText:searchTerm];
    }
    
}

- (void)cancelButtonTapped:(id)sender; {
    if ([self.delegate respondsToSelector:@selector(recentSearchHistoryControllerCancelledInput:)]) {
        [self.delegate performSelector:@selector(recentSearchHistoryControllerCancelledInput:) withObject:self];
    }
}


#pragma mark -
#pragma mark Location management

- (void)addLocation:(NSString *)newLocation{

    if ([newLocation isEqualToString:IC_SEARCH_DEFAULT_NEARBY] || [newLocation isEqualToString:IC_SEARCH_DEFAULT_MAPAREA]) {
        return;
    }else{
        [self addItemToHistory:newLocation];
    }
}

- (void)removeLocation:(NSString *)location{

    [self removeItemFromHistory:location];
}

- (NSString *)locationStringFromShortcut:(NSString *)possibleShortcutString; {
    
    NSDictionary *shortcutList = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"Atlanta, GA", @"atl",
                                  @"Atlanta, GA", @"atlanta",
                                  @"Austin, TX", @"austin",
                                  @"Baltimore, MD", @"baltimore",
                                  @"Boston, MA", @"boston",
                                  @"Chicago, IL", @"chicago",
                                  @"Columbus, OH", @"columbus",
                                  @"Denver, CO", @"denver",
                                  @"Dallas, TX", @"dallas",
                                  @"Detroit, MI", @"detroit",
                                  @"El Paso, TX", @"el paso",
                                  @"Los Angeles, CA", @"la",
                                  @"Los Angeles, CA", @"los angeles",
                                  @"Houston, TX", @"houston",
                                  @"Indianapolis, IN", @"indianapolis",
                                  @"Miami, FL", @"mia",
                                  @"Miami, FL", @"miami",
                                  @"New Orleans, LA", @"nola",
                                  @"New Orleans, LA", @"new orleans",
                                  @"Jacksonville, FL", @"jacksonville",
                                  @"Las Vegas, NV", @"vegas",
                                  @"Las Vegas, NV", @"las vegas",
                                  @"Las Vegas, NV", @"lv",
                                  @"Memphis, TN", @"memphis",
                                  @"New York, NY", @"nyc",
                                  @"New York, NY", @"ny",
                                  @"New York, NY", @"new york",
                                  @"Omaha, NE", @"omaha",
                                  @"Phoenix, AZ", @"phoenix",
                                  @"San Antonio, TX", @"san antonio",
                                  @"San Diego, CA", @"sd",
                                  @"San Francisco, CA", @"sf",
                                  @"San Francisco, CA", @"san francisco",
                                  @"San Jose, CA", @"san jose",
                                  @"San Jose, CA", @"sj",
                                  @"Seattle, WA", @"seattle",
                                  @"Trenton, NJ", @"trenton",
                                  @"Tucson, AZ", @"tucson",
                                  @"Washington, DC", @"washington",
                                  nil];
    
    NSString *translatedShortcut = [shortcutList valueForKey:[possibleShortcutString lowercaseString]];
    [shortcutList release];
    
    if (translatedShortcut) {
        return translatedShortcut;
    } else {
        return possibleShortcutString;
    }
}



#pragma mark -
#pragma mark UITableViewDataSource
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView; {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    
        if (self.currentLocationShown)
            return [self.currentDataArray count] + 1;
        else 
            return [self.currentDataArray count];
}

-(NSString*)getElementTextForIndexPath:(NSInteger)row{
    
    SegmentType segmentType = self.segmentedControl.selectedSegmentIndex;

    if (segmentType == SegmentTypeSuggestions) 
        return [[self.currentDataArray objectAtIndex:row] objectForKey:@"name"] ;
    else if(segmentType == SegmentTypeSavedSearches) 
        return  [[self.currentDataArray objectAtIndex:row] searchLabel];
    else 
        return [self.currentDataArray objectAtIndex:row];
}

-(NSString*)getElementSubTextForIndexPath:(NSInteger)row{
    SegmentType segmentType = self.segmentedControl.selectedSegmentIndex;
    if(segmentType == SegmentTypeSavedSearches) 
        return  [[self.currentDataArray objectAtIndex:row] title];
    return nil;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath; {
    
    UITableViewCell * cell;
    if (self.segmentedControl.selectedSegmentIndex != SegmentTypeSavedSearches){
        // for auto complete and recent searches
        static NSString *recentCellIdentifier = @"TruliaRecentLocationsViewCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:recentCellIdentifier];
        
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recentCellIdentifier] autorelease];
        }
        if (self.currentLocationShown){

            // "Current Location" is always hardcoded
            if (indexPath.row == 0) {
                cell.textLabel.text = IC_SEARCH_DEFAULT_NEARBY;
            } else {
                cell.textLabel.text = [self getElementTextForIndexPath:indexPath.row - 1]; 
            }
            
        }
        else {
            cell.textLabel.text = [self getElementTextForIndexPath:indexPath.row];;
        }
        
        if ([cell.textLabel.text isEqualToString:IC_SEARCH_DEFAULT_NEARBY]) {
            cell.textLabel.textColor = [UIColor blueColor];
        } else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
    }
    else {
        // for saved saerches
        static NSString *savedCellIdentifier = @"TruliaSavedSearchTableViewCell";
        cell = [self.tableView dequeueReusableCellWithIdentifier:savedCellIdentifier];
        
        if (!cell) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:savedCellIdentifier] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.backgroundView =  [[[UIView alloc] initWithFrame:CGRectZero] autorelease];

        }
        cell.textLabel.text = [self getElementTextForIndexPath:indexPath.row];
        
        [cell.detailTextLabel setFont:[UIFont systemFontOfSize:11.0f]];
        [cell.detailTextLabel setTextColor:[UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1.0f]];
        [cell.detailTextLabel setText:[self getElementSubTextForIndexPath:indexPath.row]];
 
        
    }
    return cell;
}


#pragma mark -
#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath; {

    UITableViewCell *cell = [aTableView cellForRowAtIndexPath:indexPath];
    [self.searchTextField resignFirstResponder];
    
    if (self.segmentedControl.selectedSegmentIndex == SegmentTypeSavedSearches){
        [self savedSearchSelected:[self.currentDataArray objectAtIndex:indexPath.row]];
        return;
    }
    [self searchTermDidChange:cell.textLabel.text];
}

#pragma mark -

#pragma mark ICAutoComplete Delegate

- (void)ICLocationAutoCompleteRequest:(ICLocationAutoCompleteRequest *)pICLocationAutoCompleteRequest gotResult:(NSArray *)resultList withSearchInfo:(NSDictionary *)searchInfo{
    
    self.autoCompleteLocations = resultList;

    SearchSegmentType segmentType = self.segmentedControl.selectedSegmentIndex;
    if (segmentType == SegmentTypeSuggestions) 
        self.currentDataArray = self.autoCompleteLocations;

    GRLog5(@"resnultList  %@", resultList);
    [tableView reloadData];
}

- (void)ICLocationAutoCompleteRequest:(ICLocationAutoCompleteRequest *)pICLocationAutoCompleteRequest gotError:(NSString *)error{
    GRLog5(@"error  %@", error);
}

#pragma mark -
#pragma mark UITextView Delegate Methods

- (BOOL)textFieldShouldClear:(UITextField *)textField{
    
    self.searchTextField.placeholder = ICLocalizedString(@"SearchFieldPlaceHolder");
    
    return YES;
}

-(void)textFieldTextDidChange:(UITextField*)textField{
    
    // figure out if we want to show current location or not.
    SearchSegmentType segmentType = self.segmentedControl.selectedSegmentIndex;
    
    if (segmentType == SegmentTypeSuggestions){

        if ([textField.text length] == 0 && (!self.currentLocationShown)){
            self.currentLocationShown = YES;
            self.autoCompleteLocations = nil;
            self.currentDataArray = nil;

            [self.tableView reloadData];
        }
        else if ([textField.text length] && self.currentLocationShown){
            self.currentLocationShown = NO;
            [self.tableView reloadData];
        }
        
        
        NSMutableDictionary* autoCompleteRequestOptions =  [[[NSMutableDictionary alloc] initWithCapacity:3] autorelease];
        [autoCompleteRequestOptions setValue:textField.text forKey:@"srch"];
        // cancel existing request
        [self.autoCompleteRequest.theRequest cancel];
        //make the new request
        [self.autoCompleteRequest requestWithOptions:autoCompleteRequestOptions];
        
    }
    else if (segmentType == SegmentTypeSavedSearches) {
        self.currentLocationShown = NO;
        self.currentDataArray = [self.savedSearches filter:^(id elt)	{ 
            NSString* title = [elt describeMe];
            BOOL returnBool;
            if ([textField.text length] > 0)
                returnBool = [title  rangeOfString:textField.text options:NSCaseInsensitiveSearch| NSAnchoredSearch].length > 0 ? YES: NO;
            else 
                returnBool = YES;
            return  returnBool; 
        }];
        
        [self.tableView reloadData];
    }
    else if (segmentType == SegmentTypeRecentSearches) {
        self.currentLocationShown = NO;
        self.currentDataArray = [self.recentSearchHistory filter:^(id elt)	{ 
            NSString* title = elt ;
            BOOL returnBool;
            if ([textField.text length] > 0)
                returnBool = [title  rangeOfString:textField.text options:NSCaseInsensitiveSearch| NSAnchoredSearch].length > 0 ? YES: NO;
            else
                returnBool = YES;
            return  returnBool; 
        }];
        
        [self.tableView reloadData];
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField; {
        
    NSString *textToProcess = [self locationStringFromShortcut:textField.text];
	
	[textField resignFirstResponder];
	
	if([self.oldSearchBarText isEqualToString:textToProcess] && [textToProcess caseInsensitiveCompare:IC_SEARCH_DEFAULT_NEARBY] != NSOrderedSame) {
		return YES;
		
    }
	
	if(![self.oldSearchBarText isEqualToString:@""] && ([textToProcess isEqualToString:@""] || [textToProcess isEqualToString:@" "])) {
		textField.text = self.oldSearchBarText;
		return YES;
	}
    
	self.oldSearchBarText = textToProcess;
    
    [self searchTermDidChange:textToProcess];
    [self.previousSearchFieldDelegate textFieldShouldReturn:textField];
    
	return YES;
}

- (void)segmentedControlDidChange:(MCSegmentedControl *)sender{
    
    SearchSegmentType segmentType = sender.selectedSegmentIndex;
    
    if(segmentType == SegmentTypeSavedSearches) {
        
        if ([self.searchParameters.indexType count] > 0)
            self.savedSearches = [ICManagedSearch managedSearchesWithCategoryName:MANAGED_CATEGORY_FAVORITES andIndexType:[self.searchParameters.indexType objectAtIndex:0]];
        else
            self.savedSearches = [ICManagedSearch managedSearchesWithCategoryName:MANAGED_CATEGORY_FAVORITES andIndexType:IC_INDEXTYPE_FORSALE];
        
    }
    [self textFieldTextDidChange:self.searchTextField];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
	if(string == nil || [string length] == 0) {
		return YES;
	} else if(![[self class] isSearchTermValid:string]) {
		return NO;
	}
    
	return YES;
}

@end
