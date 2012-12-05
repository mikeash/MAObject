
#import "MAObject.h"


@implementation MAObject {
    Class isa;
}

- (BOOL)isEqual: (id)object
{
    return self == object;
}

- (NSUInteger)hash
{
    return (NSUInteger)self;
}

- (Class)superclass
{
    return [[self class] superclass];
}

- (Class)class
{
    return isa;
}

- (id)self
{
    return self;
}

- (id)performSelector: (SEL)aSelector
{
    IMP imp = [self methodForSelector: aSelector];
    return ((id (*)(id, SEL))imp)(self, aSelector);
}

- (id)performSelector: (SEL)aSelector withObject: (id)object
{
    IMP imp = [self methodForSelector: aSelector];
    return ((id (*)(id, SEL, id))imp)(self, aSelector, object);
}

- (id)performSelector: (SEL)aSelector withObject: (id)object1 withObject: (id)object2
{
    IMP imp = [self methodForSelector: aSelector];
    return ((id (*)(id, SEL, id, id))imp)(self, aSelector, object1, object2);
}

- (BOOL)isProxy
{
    return NO;
}

- (BOOL)isKindOfClass: (Class)aClass
{
    for(Class candidate = [self class]; candidate != nil; candidate = [candidate superclass])
        if (candidate == aClass)
            return YES;
    
    return NO;
}

- (BOOL)isMemberOfClass: (Class)aClass
{
    return [self class] == aClass;
}

- (BOOL)conformsToProtocol: (Protocol *)aProtocol
{
    return class_conformsToProtocol([self class], aProtocol);
}

- (BOOL)respondsToSelector: (SEL)aSelector
{
    return class_respondsToSelector([self class], aSelector);
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
    return self;
}

- (NSUInteger)retainCount
{
    return 0;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"<%@: %p>", [self class], self];
}

+ (void)load
{
}

+ (void)initialize
{
}

- (id)init
{
    return self;
}

+ (id)new
{
    return [[self alloc] init];
}

+ (id)alloc
{
    MAObject *obj = calloc(1, class_getInstanceSize(self));
    obj->isa = self;
    return obj;
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
    return [NSString stringWithUTF8String: class_getName(self)];
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
