//
//  IntValueDictionary.h
//  StartFX
//
//  Created by Aleksey Garbarev on 11.04.13.
//
//

#import <Foundation/Foundation.h>

@interface SDIntValueDictionary : NSObject

- (id) initWithCapacity:(NSUInteger)capacity;

- (void) setNumber:(NSInteger)value forKey:(id)key;
- (NSInteger) numberForKey:(id)key;

- (NSUInteger) count;

- (void) enumerateKeysAndNumbersUsingBlock:(void(^)(id key, NSUInteger number, BOOL *stop))enumerateBlock;


@end
