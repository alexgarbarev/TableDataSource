//
//  IntKeyDictionary.h
//  StartFX
//
//  Created by Aleksey Garbarev on 10.04.13.
//
//

#import <Foundation/Foundation.h>

@interface SDIntKeyDictionary : NSObject<NSCoding, NSCopying>

- (id) initWithCapacity:(NSUInteger)capacity;

- (void) setObject:(id)value forKey:(NSInteger)key;
- (id) objectForKey:(NSInteger)key;
- (NSArray *) allValues;
- (NSArray *) allKeys;
- (NSArray *) allKeysSorted;

- (NSUInteger) count;

- (void) enumerateKeysAndObjectsUsingBlock:(void(^)(NSInteger key, id object, BOOL *stop))enumerateBlock;

- (void) enumerateObjectsAtKeys:(NSArray *)keys usingBlock:(void(^)(NSInteger key, id object, BOOL *stop))enumerateBlock;

- (NSInteger) maxKey;
- (NSInteger) minKey;

/* Object Subscription is implemented! */
- (id)objectAtIndexedSubscript:(NSInteger)idx;
- (void)setObject:(id)obj atIndexedSubscript:(NSInteger)idx;

@end