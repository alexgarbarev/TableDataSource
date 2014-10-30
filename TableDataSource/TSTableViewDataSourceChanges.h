//
//  TSTableViewDataSourceChanges.h
//  StartFX
//
//  Created by Aleksey Garbarev on 05.03.14.
//
//

#import <Foundation/Foundation.h>

@interface TSTableViewDataSourceChanges : NSObject

@property (nonatomic, strong) NSIndexSet *insertedSections;
@property (nonatomic, strong) NSIndexSet *deletedSections;
@property (nonatomic, strong) NSIndexSet *updatedSections;

@property (nonatomic, strong) NSArray *insertedRows;
@property (nonatomic, strong) NSArray *deletedRows;
@property (nonatomic, strong) NSArray *updatedRows;

@property (nonatomic, strong) NSArray *rowsToUpdateBackground;

@end
