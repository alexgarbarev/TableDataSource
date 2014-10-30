//
//  ZBTableViewDataSource.h
//
//  Created by Aleksey Garbarev on 03.04.13.
//



#import <Foundation/Foundation.h>

#import "TSTableViewItem.h"
#import "TSTableViewSection.h"
#import "TSTableViewSimpleCell.h"
#import "TSTableViewDataSourceChanges.h"

typedef enum {
    TSEnumerationOptionAllowMutate = 1 << 0 /* Usefull to mutate enumeration */
} TSEnumerationOptions;

typedef struct {
    UITableViewRowAnimation insertAnimation;
    UITableViewRowAnimation deleteAnimation;
    UITableViewRowAnimation reloadAnimation;
} UITableViewUpdateOptions;

@interface TSTableViewDataSource : NSObject <UITableViewDataSource, UITableViewDelegate>

/* You can override any UITableViewDataSource/UITableViewDelegate methods in forwardingDelegate object */

@property (nonatomic, readonly) id<UITableViewDataSource, UITableViewDelegate> forwardingDelegate;
@property (nonatomic) BOOL shouldDeselectCells;
/* Forward dataSource and Delegate methods which are not implmeneted in TSTableViewDataSource only. Usefull for UITableViewController */
@property (nonatomic) BOOL forwardOnlyUnimplemented; /* Default: NO. YES for UITableViewController */
@property (nonatomic) BOOL forceForwardCellForRow;

@property (nonatomic) UITableViewCellStyle cellStyle;
@property (nonatomic) Class cellClass; /* Default: TSTableViewSimpleCell. Must inherit from TSTableViewSimpleCell */

@property (nonatomic) BOOL shouldAdjustAccessoryType; /* Default: NO */
@property (nonatomic) UITableViewCellAccessoryType selectedAccessoryType;
@property (nonatomic) UIColor *selectedTitleColor; /* Default: nil */

@property (nonatomic) BOOL shouldHideEmptySections; /** Default: YES */

@property (nonatomic, copy) void(^cellPostprocessorBlock)(id cell);

- (id) initWithForwardingDelegate:(id)forwardingDelegate;

- (void) setItems:(NSArray *)items forSection:(TSTableViewSection *)section;
- (void) setItems:(NSArray *)items; // Section is autocreated

- (NSArray *) items; // items for first section
- (NSArray *) itemsForSection:(TSTableViewSection *)section;
- (NSArray *) itemsForSectionAtIndex:(NSUInteger)index;

- (TSTableViewItem *) itemForIndexPath:(NSIndexPath *)indexPath;
- (TSTableViewSection *) sectionForIndexPath:(NSIndexPath *)indexPath;
- (TSTableViewSection *) sectionAtIndex:(NSUInteger)index;

- (void) enumerateItemsWithOptions:(TSEnumerationOptions)options usingBlock:(void(^)(id item, NSInteger index, NSInteger sectionIndex, BOOL*stop))block;
- (void) enumerateItemsUsingBlock:(void(^)(id item, NSInteger index, NSInteger sectionIndex, BOOL*stop))block;

- (NSIndexPath *) indexPathForItem:(TSTableViewItem *)item;

- (TSTableViewDataSourceChanges *) changesInBlock:(dispatch_block_t)block;
- (void) animateChanges:(TSTableViewDataSourceChanges *)changes onTableView:(UITableView *)tableView withOptions:(UITableViewUpdateOptions)options completion:(dispatch_block_t)completion;

@end
