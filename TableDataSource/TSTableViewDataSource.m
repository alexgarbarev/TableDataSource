//
//  TSTableViewDataSource.m
//  Zoomby
//
//  Created by Aleksey Garbarev on 03.04.13.
//  Copyright (c) 2013 Vospitaniye Robota OOO. All rights reserved.
//

#import "TSTableViewDataSource.h"

#import "SDIntKeyDictionary.h"
#import "TSTableViewSimpleCell.h"
#import "NSArray+RangeCheck.h"

@implementation TSTableViewDataSource {
    id _forwardingDelegate;
    SDIntKeyDictionary *items;
    SDIntKeyDictionary *sections;
    
    struct {
        BOOL numberOfRows:1;
        BOOL numberOfSections:1;
        BOOL heightForRow:1;
        BOOL titleForHeader:1;
        BOOL titleForFooter:1;
        BOOL viewForHeader:1;
        BOOL viewForFooter:1;
        BOOL indentationLevel:1;
        BOOL didSelectRow:1;
        BOOL cellForRow:1;
        BOOL heightForHeader:1;
        BOOL heightForFooter:1;
    } delegateResponds;
}

@dynamic forwardingDelegate;

- (void)commonInit
{
    sections = [[SDIntKeyDictionary alloc] init];
    items = [[SDIntKeyDictionary alloc] init];
    
    self.cellStyle = UITableViewCellStyleDefault;
    self.cellClass = [TSTableViewSimpleCell class];
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithForwardingDelegate:(id)forwardingDelegate
{
    self = [super init];
    if (self) {
        [self commonInit];
        _forwardingDelegate = forwardingDelegate;
        
        if ([_forwardingDelegate isKindOfClass:[UITableViewController class]]) {
            _forwardOnlyUnimplemented = YES;
        }
        
        delegateResponds.numberOfRows = [_forwardingDelegate respondsToSelector:@selector(tableView:numberOfRowsInSection:)];
        delegateResponds.numberOfSections = [_forwardingDelegate respondsToSelector:@selector(numberOfSectionsInTableView:)];
        delegateResponds.heightForRow = [_forwardingDelegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)];
        delegateResponds.titleForHeader = [_forwardingDelegate respondsToSelector:@selector(tableView:titleForHeaderInSection:)];
        delegateResponds.titleForFooter = [_forwardingDelegate respondsToSelector:@selector(tableView:titleForFooterInSection:)];
        delegateResponds.indentationLevel = [_forwardingDelegate respondsToSelector:@selector(tableView:indentationLevelForRowAtIndexPath:)];
        delegateResponds.didSelectRow = [_forwardingDelegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)];
        delegateResponds.viewForFooter = [_forwardingDelegate respondsToSelector:@selector(tableView:viewForFooterInSection:)];
        delegateResponds.viewForHeader = [_forwardingDelegate respondsToSelector:@selector(tableView:viewForHeaderInSection:)];
        delegateResponds.cellForRow = [_forwardingDelegate respondsToSelector:@selector(tableView:cellForRowAtIndexPath:)];
        delegateResponds.heightForHeader = [_forwardingDelegate respondsToSelector:@selector(tableView:heightForHeaderInSection:)];
        delegateResponds.heightForFooter = [_forwardingDelegate respondsToSelector:@selector(tableView:heightForFooterInSection:)];

        self.shouldHideEmptySections = YES;
    }
    return self;
}

#pragma mark - Forwarding unimplemented methods to _forwardingDelegate

- (id<UITableViewDataSource,UITableViewDelegate>)forwardingDelegate
{
    return _forwardingDelegate;
}

- (BOOL) respondsToSelector:(SEL)selector
{
    if ([super respondsToSelector:selector]) {
        return YES;
    } else {
        return [_forwardingDelegate respondsToSelector:selector];
    }
}

- (void) forwardInvocation:(NSInvocation *)invocation
{
    if ([super respondsToSelector:[invocation selector]]) {
        [super forwardInvocation:invocation];
    } else if ([_forwardingDelegate respondsToSelector:[invocation selector]]) {
        [invocation invokeWithTarget:_forwardingDelegate];
    } else {
		[self doesNotRecognizeSelector:[invocation selector]];
    }
}

- (NSMethodSignature *) methodSignatureForSelector:(SEL)selector
{
	NSMethodSignature *signature = [super methodSignatureForSelector:selector];
    if (signature) {
        return signature;
    } else {
        return [_forwardingDelegate methodSignatureForSelector:selector];
	}
}

#pragma mark -

- (void) setItems:(NSArray *)_items forSection:(TSTableViewSection *)section
{
    if ([sections objectForKey:section.index]) {
        [items setObject:nil forKey:section.index];
        [sections setObject:nil forKey:section.index];
    }
    if (_items) {
        NSAssert(section.index <= [sections count]+1, @"Wrong index in section (%d out of bounds [0..%d])",(int)section.index, (int)[sections count]+1);
        [items setObject:_items forKey:section.index];
        [sections setObject:section forKey:section.index];
    }
}

- (void) setItems:(NSArray *)_items
{
    TSTableViewSection *section = [TSTableViewSection sectionWithHeaderTitle:nil index:0];
    [self setItems:_items forSection:section];
}

- (NSArray *) items
{
    return [items objectForKey:0];
}

- (NSArray *) itemsForSection:(TSTableViewSection *)section
{
    return [items objectForKey:section.index];
}

- (NSArray *) itemsForSectionAtIndex:(NSUInteger)index
{
    return [items objectForKey:index];
}

- (TSTableViewItem *) itemForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *itemsArray = [items objectForKey:indexPath.section];
    
    if ([itemsArray containsIndex:indexPath.row]) {
        return itemsArray[indexPath.row];
    } else {
        return nil;
    }
}

- (TSTableViewSection *) sectionForIndexPath:(NSIndexPath *)indexPath
{
    return [self sectionAtIndex:indexPath.section];
}

- (TSTableViewSection *) sectionAtIndex:(NSUInteger)index
{
    return [sections objectForKey:index];
}

- (NSUInteger) sectionsCount
{
    return [sections count];
}

- (void) enumerateItemsWithOptions:(TSEnumerationOptions)options usingBlock:(void(^)(id item, NSInteger index, NSInteger sectionIndex, BOOL*stop))block
{
    BOOL allowMutate = options & TSEnumerationOptionAllowMutate;

    SDIntKeyDictionary *itemsDict = allowMutate ? [items copy] : items;
    
    [itemsDict enumerateKeysAndObjectsUsingBlock:^(NSInteger sectionIndex, NSArray *itemsArray, BOOL *_stop) {
      
        NSArray *array = allowMutate ? [itemsArray copy] : itemsArray;
        [array enumerateObjectsUsingBlock:^(id item, NSUInteger itemIndex, BOOL *stop) {
            block(item, itemIndex, sectionIndex, stop);
            *_stop = *stop;
        }];
        
    }];
}

- (void) enumerateItemsUsingBlock:(void(^)(id item, NSInteger index, NSInteger sectionIndex, BOOL*stop))block
{
    [self enumerateItemsWithOptions:0 usingBlock:block];
}

- (NSIndexPath *) indexPathForItem:(TSTableViewItem *)item
{
    __block NSIndexPath * indexPath = nil;
    
    [items enumerateKeysAndObjectsUsingBlock:^(NSInteger section, NSArray *objects, BOOL *stop) {
        
        NSUInteger index = [objects indexOfObject:item];
        if (index != NSNotFound){
            indexPath = [NSIndexPath indexPathForRow:index inSection:section];
            *stop = YES;
        }
        
    }];
    
    return indexPath;
}

#pragma mark - TableView delegation

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (delegateResponds.numberOfRows && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView numberOfRowsInSection:section];
    } else {
        return [[items objectForKey:section] count];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (delegateResponds.numberOfSections && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate numberOfSectionsInTableView:tableView];
    } else {
        return [sections count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegateResponds.heightForRow && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView heightForRowAtIndexPath:indexPath];
    } else {
        return [[self itemForIndexPath:indexPath] height];
    }
}

#pragma mark - Header

- (BOOL)shouldShowSection:(TSTableViewSection *)section
{
    BOOL shouldShow = YES;

    if (self.shouldHideEmptySections) {
        shouldShow = [[items objectForKey:section.index] count] > 0;
    }

    return shouldShow;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)_section
{
    if (delegateResponds.titleForHeader && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView titleForHeaderInSection:_section];
    } else {
        TSTableViewSection *section = [sections objectForKey:_section];
        return section.headerTitle;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)_section
{
    if (delegateResponds.heightForHeader && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView heightForHeaderInSection:_section];
    } else {
        TSTableViewSection *section = [sections objectForKey:_section];
        if (section.headerView && [self shouldShowSection:section]) {
            return section.headerView.bounds.size.height;
        } else {
            return -1;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)_section
{
    if (delegateResponds.viewForHeader && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView viewForHeaderInSection:_section];
    } else {
        TSTableViewSection *section = [sections objectForKey:_section];
        return section.headerView;
    }
}

#pragma mark - Footer

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)_section
{
    if (delegateResponds.titleForFooter && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView titleForFooterInSection:_section];
    } else {
        TSTableViewSection *section = [sections objectForKey:_section];
        return section.footerTitle;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)_section
{
    if (delegateResponds.heightForFooter && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView heightForFooterInSection:_section];
    } else {
        TSTableViewSection *section = [sections objectForKey:_section];
        if (section.footerView && [self shouldShowSection:section]) {
            return section.footerView.bounds.size.height;
        } else {
            return -1;
        }
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)_section
{
    if (delegateResponds.viewForFooter && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView viewForFooterInSection:_section];
    } else {
        TSTableViewSection *section = [sections objectForKey:_section];
        return section.footerView;
    }
}

#pragma mark - Identation

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (delegateResponds.indentationLevel && !_forwardOnlyUnimplemented) {
        return [_forwardingDelegate tableView:tableView indentationLevelForRowAtIndexPath:indexPath];
    } else {
        return [[self itemForIndexPath:indexPath] indentationLevel];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_shouldDeselectCells) {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    if (delegateResponds.didSelectRow && !_forwardOnlyUnimplemented) {
        [_forwardingDelegate tableView:tableView didSelectRowAtIndexPath:indexPath];
    }

    TSTableViewItem *item = [self itemForIndexPath:indexPath];
    if (item.didSelectAction) {
        if (item.didSelectAction) {
            item.didSelectAction(indexPath);
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((delegateResponds.cellForRow && !_forwardOnlyUnimplemented) || self.forceForwardCellForRow) {
        return [_forwardingDelegate tableView:tableView cellForRowAtIndexPath:indexPath];
        
    } else {

        TSTableViewItem *item = [self itemForIndexPath:indexPath];

        Class cellClass = item.cellClass ?: self.cellClass;

        NSString *reuseIdentifier = [NSString stringWithFormat:@"%@-%@",NSStringFromClass([_forwardingDelegate class]), cellClass];
        
        TSTableViewSimpleCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
        
        if (!cell) {
            cell = [[cellClass alloc] initWithStyle:self.cellStyle reuseIdentifier:reuseIdentifier];
            if (self.cellPostprocessorBlock) {
                self.cellPostprocessorBlock(cell);
            }
        }

        [cell reuseForIndexPath:indexPath withTableView:tableView];

        if (item) {
            if (item.attributedTitle) {
                [cell setAttributedTitle:item.attributedTitle];
            } else {
                [cell setTitle:item.title];
            }
            if (item.attributedSubtitle) {
                [cell setAttributedSubtitle:item.attributedSubtitle];
            } else {
                [cell setSubtitle:item.subtitle];
            }
            [cell setItem:item];
            cell.selectionStyle = item.selectionStyle;
            cell.notSelectedAccessoryType = item.accessoryType;
            [cell setSelectedTitleColor:item.selectedColor];
        }
        
        cell.selectedAccessoryType = self.selectedAccessoryType;

        return cell;
    }
}

#pragma mark - Animation

- (void) animateChanges:(TSTableViewDataSourceChanges *)changesResult onTableView:(UITableView *)tableView withOptions:(UITableViewUpdateOptions)options completion:(dispatch_block_t)completion
{
    NSParameterAssert(tableView);
    
    /* Fix iOS7 bug when deleted cell moved above staying cells */
    [tableView.visibleCells enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.superview bringSubviewToFront:cell];
    }];

    
    if (completion) {
        [CATransaction setCompletionBlock:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
        }];
    }
    
    [CATransaction begin];
    
    [tableView beginUpdates];
    
    /* Sections */
    [tableView insertSections:changesResult.insertedSections withRowAnimation:options.insertAnimation];
    [tableView deleteSections:changesResult.deletedSections withRowAnimation:options.deleteAnimation];
    [tableView reloadSections:changesResult.updatedSections withRowAnimation:options.reloadAnimation];
    
    /* Rows */
    [tableView insertRowsAtIndexPaths:changesResult.insertedRows withRowAnimation:options.insertAnimation];
    [tableView deleteRowsAtIndexPaths:changesResult.deletedRows withRowAnimation:options.deleteAnimation];
    [tableView reloadRowsAtIndexPaths:changesResult.updatedRows withRowAnimation:options.reloadAnimation];
    
    [tableView endUpdates];
    
    [CATransaction commit];

    /* Fix iOS7 bug when deleted cell moved above staying cells */
    [tableView.visibleCells enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UITableViewCell *cell, NSUInteger idx, BOOL *stop) {
        [cell.superview bringSubviewToFront:cell];
    }];

}

- (TSTableViewDataSourceChanges *) changesInBlock:(dispatch_block_t)block
{
    NSParameterAssert(block);
    
    SDIntKeyDictionary *sectionsBeforeUpdate = [sections copy];
    SDIntKeyDictionary *itemsBeforeUpdate = [items copy];
    
    block();
    
    return [self calculateChangesWithSectionsBeforeUpdate:sectionsBeforeUpdate itemsBeforeUpdate:itemsBeforeUpdate];
}

- (TSTableViewDataSourceChanges *) calculateChangesWithSectionsBeforeUpdate:(SDIntKeyDictionary *)oldSections itemsBeforeUpdate:(SDIntKeyDictionary *)oldItems
{
    __block NSIndexSet *sectionsToInsert = nil;
    __block NSIndexSet *sectionsToReload = nil;
    __block NSIndexSet *sectionsToDelete = nil;
    
    NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToReload = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
    NSMutableArray *indexPathsToUpdateBackground = [[NSMutableArray alloc] init];

    
    /* Calc sections */
    [self calculateSectionsUpdateWithOld:oldSections new:sections completion:^(NSIndexSet *insert, NSIndexSet *reload, NSIndexSet *delete) {
        sectionsToInsert = insert;
        sectionsToReload = reload;
        sectionsToDelete = delete;
    }];
    NSMutableIndexSet *changedVisibilitySection = [self calulateChangedVisibilitySectionsWithOldItems:oldItems];
    [changedVisibilitySection addIndexes:sectionsToReload];
    sectionsToReload = changedVisibilitySection;

    /* Update old items and section */
    [sectionsToDelete enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop) {
        oldItems[idx] = nil;
        oldSections[idx] = nil;
    }];
    [self shiftSectionsIndecies:oldSections withItems:oldItems];
    
    /* Calc rows */
    [oldItems enumerateKeysAndObjectsUsingBlock:^(NSInteger sectionIndex, NSArray *itemsArray, BOOL *stop) {
        if (![itemsArray isEqualToArray:items[sectionIndex]]) {
            [self calculateRowsUpdateWithOld:itemsArray new:items[sectionIndex] completion:^(NSIndexSet *insert, NSIndexSet *reload, NSIndexSet *delete, NSIndexSet *updateBackground) {
                [indexPathsToInsert addObjectsFromArray:[self indexPathsFromIndecies:insert andSectionIndex:sectionIndex]];
                [indexPathsToReload addObjectsFromArray:[self indexPathsFromIndecies:reload andSectionIndex:sectionIndex]];
                [indexPathsToDelete addObjectsFromArray:[self indexPathsFromIndecies:delete andSectionIndex:sectionIndex]];
                [indexPathsToUpdateBackground addObjectsFromArray:[self indexPathsFromIndecies:updateBackground andSectionIndex:sectionIndex]];
            }];
        }
    }];
    
    TSTableViewDataSourceChanges *changes = [TSTableViewDataSourceChanges new];
    changes.rowsToUpdateBackground = indexPathsToUpdateBackground;
    changes.insertedRows = indexPathsToInsert;
    changes.updatedRows = indexPathsToReload;
    changes.deletedRows = indexPathsToDelete;
    changes.insertedSections = sectionsToInsert;
    changes.deletedSections = sectionsToDelete;
    changes.updatedSections = sectionsToReload;
    
    return changes;
}

- (NSMutableIndexSet *)calulateChangedVisibilitySectionsWithOldItems:(SDIntKeyDictionary *)oldItems
{
    NSMutableIndexSet *indecies = [NSMutableIndexSet new];

    if (self.shouldHideEmptySections) {
        [oldItems enumerateKeysAndObjectsUsingBlock:^(NSInteger sectionIndex, NSArray *oldItems, BOOL *stop) {
            BOOL wasEmpty = [oldItems count] == 0;
            BOOL becomeEmpty = [[self itemsForSectionAtIndex:sectionIndex] count] == 0;
            if (wasEmpty || becomeEmpty) {
                [indecies addIndex:sectionIndex];
            }
        }];
    }

    return indecies;
}

- (void) calculateSectionsUpdateWithOld:(SDIntKeyDictionary *)oldSections new:(SDIntKeyDictionary *)newSections completion:(void(^)(NSIndexSet *insert, NSIndexSet *reload, NSIndexSet *delete))completion
{
    NSMutableIndexSet *sectionsToInsert = [NSMutableIndexSet new];
    NSMutableIndexSet *sectionsToReload = [NSMutableIndexSet new];
    NSMutableIndexSet *sectionsToDelete = [NSMutableIndexSet new];
    
    [oldSections enumerateKeysAndObjectsUsingBlock:^(NSInteger key, id object, BOOL *stop) {
        if (newSections[key] && ![newSections[key] isEqual:object]) {
            [sectionsToReload addIndex:key];
        }
        if (newSections[key] == nil) {
            [sectionsToDelete addIndex:key];
        }
    }];
    [newSections enumerateKeysAndObjectsUsingBlock:^(NSInteger key, id object, BOOL *stop) {
        if (oldSections[key] == nil) {
            [sectionsToInsert addIndex:key];
        }
    }];
    
    completion(sectionsToInsert, sectionsToReload, sectionsToDelete);
}

- (void) calculateRowsUpdateWithOld:(NSArray *)oldRows new:(NSArray *)newRows completion:(void(^)(NSIndexSet *insert, NSIndexSet *reload, NSIndexSet *delete, NSIndexSet *backgroundUpdated))completion
{
    NSMutableIndexSet *indeciesToInsert = [NSMutableIndexSet new];
    NSMutableIndexSet *indeciesToReload = [NSMutableIndexSet new];
    NSMutableIndexSet *indeciesToDelete = [NSMutableIndexSet new];
    NSMutableIndexSet *indeciesToUpdateBackground = [NSMutableIndexSet new];
    
    [oldRows enumerateObjectsUsingBlock:^(TSTableViewItem *item, NSUInteger index, BOOL *stop)
    {
        NSUInteger foundIndex = [self indexOfObjectWithSamePointer:item inArray:newRows];

        BOOL hasSameObjectPointer = (foundIndex != NSNotFound);
        BOOL hasSameObject = [newRows containsObject:item];
        
        if (!hasSameObject && !hasSameObjectPointer) {
             [indeciesToDelete addIndex:index];
        }
        else if (hasSameObject) {
            
            BOOL isFirstAndMoved = (index == 0) && ![[newRows firstObject] isEqual:item];
            BOOL isLastAndMoved = (index == [oldRows count] - 1) && ![[newRows lastObject] isEqual:item];
            BOOL isBecomeFirst = (index != 0) && [[newRows firstObject] isEqual:item];
            BOOL isBecomeLast  = (index != [oldRows count] - 1) && [[newRows lastObject] isEqual:item];
            BOOL backgroundMayBeChanged = (isFirstAndMoved || isLastAndMoved || isBecomeFirst || isBecomeLast);
            
            if (backgroundMayBeChanged) {
                [indeciesToUpdateBackground addIndex:[newRows indexOfObject:item]];
            }
        }
        else if (hasSameObjectPointer) {
            BOOL hasDifferentObjectAtSamePointer = ![item isEqual:newRows[foundIndex]];
            if (hasDifferentObjectAtSamePointer) {
                [indeciesToReload addIndex:index];
            }
        }
       
    }];
    
    [newRows enumerateObjectsUsingBlock:^(TSTableViewItem *item, NSUInteger index, BOOL *stop) {
        NSUInteger foundIndex = [oldRows indexOfObject:item];
        if (foundIndex == NSNotFound) {
            [indeciesToInsert addIndex:index];
        }
    }];
    
    completion(indeciesToInsert, indeciesToReload, indeciesToDelete, indeciesToUpdateBackground);
}

- (void) shiftSectionsIndecies:(SDIntKeyDictionary *)_sections withItems:(SDIntKeyDictionary *)_items
{
    NSInteger counter = 0;
    for (NSNumber *key in [_sections allKeysSorted]) {
        TSTableViewSection *section = _sections[[key intValue]];
        NSArray *itemsArray = _items[[key intValue]];
        section.index = counter;
        _sections[counter] = section;
        _items[counter] = itemsArray;
        counter++;
    }
}

- (NSUInteger) indexOfObjectWithSamePointer:(id)object inArray:(NSArray *)array
{
    __block NSUInteger result = NSNotFound;

    [array enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        if (obj == object) {
            result = idx;
            *stop = YES;
        }
    }];
    
    return result;
}

- (NSArray *) indexPathsFromIndecies:(NSIndexSet *)indexSet andSectionIndex:(NSInteger)sectionIndex
{
    NSMutableArray *paths = [[NSMutableArray alloc] initWithCapacity:[indexSet count]];
    
    [indexSet enumerateIndexesUsingBlock:^(NSUInteger row, BOOL *stop) {
        [paths addObject:[NSIndexPath indexPathForRow:row inSection:sectionIndex]];
    }];
    
    return paths;
}

@end
