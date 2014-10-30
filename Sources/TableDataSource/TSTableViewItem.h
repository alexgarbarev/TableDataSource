//
//  ZBTableViewItem.h
//  Zoomby
//
//  Created by Aleksey Garbarev on 03.04.13.
//  Copyright (c) 2013 Vospitaniye Robota OOO. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SelectAction)(NSIndexPath *indexPath);

@interface TSTableViewItem : NSObject

@property (nonatomic) CGFloat height;
@property (nonatomic) NSUInteger indentationLevel;

@property (nonatomic, strong) id context;

/// Must be inherited from TSTableViewSimpleCell. Default: nil (then means use cellClass from TSTableDataSource)
@property (nonatomic, strong) Class cellClass;

@property (nonatomic, strong) SelectAction didSelectAction;


/* TMP: */
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSAttributedString *attributedTitle;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) NSAttributedString *attributedSubtitle;
@property (nonatomic) UITableViewCellAccessoryType accessoryType;
@property (nonatomic) UITableViewCellSelectionStyle selectionStyle;
@property (nonatomic) UIColor *selectedColor;

@end
