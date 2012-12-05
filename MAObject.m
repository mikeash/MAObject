
#import "MAObject.h"


@implementation MAObject

- (BOOL)isEqual:(id)object
{
    return NO;
}

- (NSUInteger)hash
{
    return 0;
}

- (Class)superclass
{
    return nil;
}

- (Class)class
{
    return nil;
}

- (id)self
{
    return nil;
}

- (id)performSelector:(SEL)aSelector
{
    return nil;
}

- (id)performSelector:(SEL)aSelector withObject:(id)object
{
    return nil;
}

- (id)performSelector:(SEL)aSelector withObject:(id)object1 withObject:(id)object2
{
    return nil;
}

- (BOOL)isProxy
{
    return NO;
}

- (BOOL)isKindOfClass:(Class)aClass
{
    return NO;
}

- (BOOL)isMemberOfClass:(Class)aClass
{
    return NO;
}

- (BOOL)conformsToProtocol:(Protocol *)aProtocol
{
    return NO;
}

- (BOOL)respondsToSelector:(SEL)aSelector
{
    return NO;
}

- (id)retain
{
    return nil;
}

- (oneway void)release
{
}

- (id)autorelease
{
    return nil;
}

- (NSUInteger)retainCount
{
    return 0;
}

- (NSString *)description
{
    return nil;
}

+ (void)load
{
}

+ (void)initialize
{
}

- (id)init
{
    return nil;
}

+ (id)new
{
    return nil;
}

+ (id)alloc
{
    return nil;
}

- (void)dealloc
{
}

- (void)finalize
{
}

- (id)copy
{
    return nil;
}

- (id)mutableCopy
{
    return nil;
}

+ (Class)superclass
{
    return nil;
}

+ (Class)class
{
    return nil;
}

+ (BOOL)instancesRespondToSelector:(SEL)aSelector
{
    return NO;
}

+ (BOOL)conformsToProtocol:(Protocol *)protocol
{
    return NO;
}

- (IMP)methodForSelector:(SEL)aSelector
{
    return NULL;
}

+ (IMP)instanceMethodForSelector:(SEL)aSelector
{
    return NULL;
}

- (void)doesNotRecognizeSelector:(SEL)aSelector
{
}

- (id)forwardingTargetForSelector:(SEL)aSelector
{
    return nil;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation
{
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector
{
    return nil;
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector:(SEL)aSelector
{
    return nil;
}

+ (NSString *)description
{
    return nil;
}

+ (BOOL)isSubclassOfClass:(Class)aClass
{
    return NO;
}

+ (BOOL)resolveClassMethod:(SEL)sel
{
    return NO;
}

+ (BOOL)resolveInstanceMethod:(SEL)sel
{
    return NO;
}

@end
