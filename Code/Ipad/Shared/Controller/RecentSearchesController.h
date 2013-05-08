#import <UIKit/UIKit.h>


extern NSString *RecentSearchesKey;

@class RecentSearchesController;


@protocol RecentSearchesDelegate
// Sent when the user selects a row in the recent searches list.
- (void)recentSearchesController:(RecentSearchesController *)controller didSelectString:(NSString *)searchString;
@end


@interface RecentSearchesController : UITableViewController <UIActionSheetDelegate> {
    id <RecentSearchesDelegate> __unsafe_unretained delegate;
    
    NSArray *recentSearches;
    NSArray *displayedRecentSearches;
    UIBarButtonItem *clearButtonItem;
	
}

@property (nonatomic, unsafe_unretained) id <RecentSearchesDelegate> delegate;
@property (nonatomic, strong) NSArray *recentSearches;
@property (nonatomic, strong) NSArray *displayedRecentSearches;

@property (nonatomic, strong) UIBarButtonItem *clearButtonItem;

- (void)addToRecentSearches:(NSString *)searchString;
- (void)filterResultsUsingString:(NSString *)filterString;

@end
