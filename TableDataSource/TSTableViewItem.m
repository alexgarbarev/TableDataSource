//
//  ZBTableViewItem.m
//  Zoomby
//
//  Created by Aleksey Garbarev on 03.04.13.
//  Copyright (c) 2013 Vospitaniye Robota OOO. All rights reserved.
//

#import "TSTableViewItem.h"
#import "TSTableViewSimpleCell.h"

@implementation TSTableViewItem

AUTO_DESCRIPTION

- (id)init
{
    self = [super init];
    if (self) {
        _height = 44;
        _indentationLevel = 0;
        _selectionStyle = UITableViewCellSelectionStyleGray;
    }
    return self;
}

@end
