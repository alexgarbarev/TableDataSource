//
//  ZBTableViewSection.h
//  Zoomby
//
//  Created by Aleksey Garbarev on 04.04.13.
//  Copyright (c) 2013 Vospitaniye Robota OOO. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TSTableViewSection : NSObject

@property (nonatomic, strong) NSString *headerTitle;
@property (nonatomic, strong) NSString *footerTitle;

@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *footerView;

@property (nonatomic) NSUInteger index;

/* Index started from Zero! */
+ (id) sectionWithHeaderTitle:(NSString *)title index:(NSUInteger)index;
+ (id) sectionWithIndex:(NSUInteger)index;


@end
