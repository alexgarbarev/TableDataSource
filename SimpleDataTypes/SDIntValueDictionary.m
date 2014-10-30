//
//  IntValueDictionary.m
//  StartFX
//
//  Created by Aleksey Garbarev on 11.04.13.
//
//

#import "SDIntValueDictionary.h"

@implementation SDIntValueDictionary {
    CFMutableDictionaryRef dict;
}


- (void) commonInitWithCapacity:(NSUInteger)capacity
{

    CFDictionaryValueCallBacks valuesCallbacks;
    valuesCallbacks.version = 1.0f;
    valuesCallbacks.release = NULL;
    valuesCallbacks.retain = NULL;
    valuesCallbacks.equal = NULL;
    valuesCallbacks.copyDescription = NULL;
    dict = CFDictionaryCreateMutable(NULL, 0, &kCFTypeDictionaryKeyCallBacks, &valuesCallbacks);
    
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

- (void)dealloc
{
    CFRelease(dict);
}

- (void) setObject:(id)value forKey:(NSInteger)key
{
    if (value) {
        CFDictionarySetValue(dict, (const void *)key, (__bridge void *)value);
    } else {
        CFDictionaryRemoveValue(dict, (const void *)key);
    }
}

- (void) setNumber:(NSInteger)value forKey:(id)key
{
    CFDictionarySetValue(dict, (__bridge void *)key, (const void *)value);
}

- (NSInteger)numberForKey:(id)key
{
    return (NSInteger) CFDictionaryGetValue(dict, (__bridge void *)key);
}

- (NSUInteger) count
{
    return CFDictionaryGetCount(dict);
}

- (void) enumerateKeysAndNumbersUsingBlock:(void(^)(id key, NSUInteger number, BOOL *stop))enumerateBlock
{
    if (!enumerateBlock) return;
    
    NSUInteger count = [self count];
    
    void *keys[count];
    void *values[count];
    CFDictionaryGetKeysAndValues(dict, (const void **) keys, (const void **) values);
    
    for (int i = 0; i < count; i++ ){
        
        BOOL stop = NO;
        
        id key = (__bridge id)keys[i];
        NSInteger value = (NSInteger)values[i];
        
        enumerateBlock(key, value, &stop);
        
        if (stop) {
            break;
        }
        
    }
}


@end
