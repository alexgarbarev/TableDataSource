//
//  IntKeyDictionary.m
//  StartFX
//
//  Created by Aleksey Garbarev on 10.04.13.
//
//

#import "SDIntKeyDictionary.h"

@implementation SDIntKeyDictionary {
    CFMutableDictionaryRef dict;
}

- (void) commonInitWithCapacity:(NSUInteger)capacity
{
    CFDictionaryKeyCallBacks keyCallbacks;
    keyCallbacks.version = 1.0f;
    keyCallbacks.release = NULL;
    keyCallbacks.retain = NULL;
    keyCallbacks.equal = NULL;
    keyCallbacks.hash = NULL;
    keyCallbacks.copyDescription = NULL;
    dict = CFDictionaryCreateMutable(NULL, 0, &keyCallbacks, &kCFTypeDictionaryValueCallBacks);
    
}

- (id)init
{
    self = [super init];
    if (self) {
        [self commonInitWithCapacity:0];
    }
    return self;
}

- (id) initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    if (self) {
        [self commonInitWithCapacity:capacity];
    }
    return self;
}

- (NSString *) description
{
    NSMutableString *description = [NSMutableString new];
    [description appendFormat:@"%@\n{",[super description]];
    [self enumerateObjectsAtKeys:[self allKeysSorted] usingBlock:^(NSInteger key, id object, BOOL *stop) {
        [description appendFormat:@"\n\t%d = %@,",(int)key, object];
    }];
    [description appendString:@"\n}"];
    return description;
}

- (void) dealloc
{
    CFRelease(dict);
}

- (void) setObject:(id)value forKey:(NSInteger)key
{
    if (value) {
        CFDictionarySetValue(dict, (const void *)key, (__bridge void *)value);
    } else {
        CFDictionaryRemoveValue(dict,(const void *) key);
    }
}
- (id) objectForKey:(NSInteger)key
{
    return CFDictionaryGetValue(dict, (const void *)key);
}

- (NSInteger) maxKey
{
    __block NSInteger max = NSIntegerMin;
    [self enumerateKeysAndObjectsUsingBlock:^(NSInteger key, id object, BOOL *stop) {
        if (key > max) {
            max = key;
        }
    }];
    if (self.count == 0) {
        max = 0;
    }
    return max;
}

- (NSInteger) minKey
{
    __block NSInteger min = NSIntegerMax;
    [self enumerateKeysAndObjectsUsingBlock:^(NSInteger key, id object, BOOL *stop) {
        if (key < min) {
            min = key;
        }
    }];
    if (self.count == 0) {
        min = 0;
    }
    return min;
}

- (NSUInteger) count
{
    return CFDictionaryGetCount(dict);
}

- (NSArray *) allValues
{
    NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:[self count]];
    [self enumerateKeysAndObjectsUsingBlock:^(NSInteger key, id object, BOOL *stop) {
        [array addObject:object];
    }];
    return array;
}

- (NSArray *) allKeys
{
    NSMutableArray *keys = [[NSMutableArray alloc] initWithCapacity:[self count]];
    [self enumerateKeysAndObjectsUsingBlock:^(NSInteger key, id object, BOOL *stop) {
        [keys addObject:@(key)];
    }];

    return keys;
}

- (NSArray *) allKeysSorted
{
    return [[self allKeys] sortedArrayUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj1 compare:obj2];
    }];
}

- (void) enumerateObjectsAtKeys:(NSArray *)keys usingBlock:(void(^)(NSInteger key, id object, BOOL *stop))enumerateBlock
{
    if (!enumerateBlock) {
        return;
    }
    
    for (NSNumber *keyNumber in keys) {
        
        NSInteger key = [keyNumber integerValue];
        BOOL stop = NO;

        enumerateBlock(key, self[key], &stop);
        
        if (stop) {
            break;
        }
        
    }
}

- (void) enumerateKeysAndObjectsUsingBlock:(void(^)(NSInteger key, id value, BOOL *stop))enumerateBlock
{
    if (!enumerateBlock) return;
    
    NSUInteger count = [self count];
    
    void *keys[count];
    void *values[count];
    
    CFDictionaryGetKeysAndValues(dict, (const void **) keys, (const void **) values);
    
    for (int i = 0; i < count; i++ ){
        
        BOOL stop = NO;
        
        NSInteger key = (NSInteger)keys[i];
        id value =(__bridge id)values[i];
        
        enumerateBlock(key, value, &stop);
        
        if (stop) {
            break;
        }
        
    }
}


- (void) encodeWithCoder:(NSCoder *)aCoder
{
    NSMutableDictionary *mutableDict = [[NSMutableDictionary alloc] initWithCapacity:[self count]];
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSInteger key, id object, BOOL *stop) {
        mutableDict[@(key)] = object;
    }];
    
    [aCoder encodeObject:mutableDict];
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    NSMutableDictionary *mutableDict = [aDecoder decodeObject];
    
    self = [self initWithCapacity:[mutableDict count]];
    if (self) {
        
        [mutableDict enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [self setObject:obj forKey:[key integerValue]];
        }];
        
    }
    return self;
}

- (id) copyWithZone:(NSZone *)zone
{
    SDIntKeyDictionary *copiedDict = [[[self class] allocWithZone:zone] initWithCapacity:[self count]];
    
    [self enumerateKeysAndObjectsUsingBlock:^(NSInteger key, id object, BOOL *stop) {
        [copiedDict setObject:object forKey:key];
    }];
    
    return copiedDict;
}

- (id) objectAtIndexedSubscript:(NSInteger)idx
{
    return [self objectForKey:idx];
}

- (void) setObject:(id)obj atIndexedSubscript:(NSInteger)idx
{
    [self setObject:obj forKey:idx];
}


@end
