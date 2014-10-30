//
//  TSTableViewSimpleCell.h
//  StartFX
//
//  Created by Aleksey Garbarev on 20.05.13.
//
//

#import <UIKit/UIKit.h>

@interface TSTableViewSimpleCell : UITableViewCell

@property (nonatomic) UITableViewCellAccessoryType selectedAccessoryType;
@property (nonatomic) UITableViewCellAccessoryType notSelectedAccessoryType;

- (void) reuseForIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView;

- (void) setTitle:(NSString *)title;
- (void) setAttributedTitle:(NSAttributedString *)attributedTitle;

- (void) setSubtitle:(NSString *)subtitle;
- (void) setAttributedSubtitle:(NSAttributedString *)attributedSubtitle;

- (void) setSelectedTitleColor:(UIColor *)color;

- (void) setItem:(id)item;

@end
