//
//  ZBTableViewSection.m
//  Zoomby
//
//  Created by Aleksey Garbarev on 04.04.13.
//  Copyright (c) 2013 Vospitaniye Robota OOO. All rights reserved.
//

#import "TSTableViewSection.h"

@implementation TSTableViewSection

+ (id) sectionWithHeaderTitle:(NSString *)title index:(NSUInteger)index
{
    TSTableViewSection *section = [[TSTableViewSection alloc] init];
    if (section) {
        section.headerTitle = title;
        section.index = index;
    }
    return section;
}

+ (id)sectionWithIndex:(NSUInteger)index
{
    TSTableViewSection *section = [[TSTableViewSection alloc] init];
    section.index = index;
    return section;
}

- (BOOL) isEqual:(id)object
{
    if ([object isKindOfClass:[self class]]) {
        
        if (self == object)
            return YES;
        
        TSTableViewSection *anotherSection = object;
        
        BOOL isEqual = YES;
        
        isEqual &= !self.headerTitle || [self.headerTitle isEqualToString:anotherSection.headerTitle];
        isEqual &= !self.footerTitle || [self.footerTitle isEqualToString:anotherSection.footerTitle];
        isEqual &= self.headerView == anotherSection.headerView;
        isEqual &= self.footerTitle == anotherSection.footerTitle;
        
        return isEqual;
    }
    
    return NO;
}

@end
