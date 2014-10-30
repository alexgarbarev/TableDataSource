//
//  TSTableViewSimpleCell.m
//  StartFX
//
//  Created by Aleksey Garbarev on 20.05.13.
//
//

#import "TSTableViewSimpleCell.h"

@implementation TSTableViewSimpleCell {
    UIColor *titleSelectedColor;
    UIColor *titleOriginalColor;
}

- (void) setSelectedTitleColor:(UIColor *)color
{
    if (color) {
        titleSelectedColor = color;
        titleOriginalColor = self.textLabel.textColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.accessoryType = self.selectedAccessoryType;
        if (titleSelectedColor) {
            self.textLabel.textColor = titleSelectedColor;
        }
    } else {
        self.accessoryType = self.notSelectedAccessoryType;
        if (titleSelectedColor) {
            self.textLabel.textColor = titleOriginalColor;
        }
    }
}

- (void) reuseForIndexPath:(NSIndexPath *)indexPath withTableView:(UITableView *)tableView
{
    //override me!
}

- (void) setTitle:(NSString *)title
{
    self.textLabel.text = title;
}
- (void) setAttributedTitle:(NSAttributedString *)attributedTitle
{
    self.textLabel.attributedText = attributedTitle;
}

- (void) setSubtitle:(NSString *)subtitle
{
    self.detailTextLabel.text = subtitle;
}

- (void) setAttributedSubtitle:(NSAttributedString *)attributedSubtitle
{
    self.detailTextLabel.attributedText = attributedSubtitle;
}

- (void) setItem:(id)item
{
    
}

@end
