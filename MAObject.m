
#import "MAObject.h"

#import <libkern/OSAtomic.h>


@implementation MAObject {
    Class isa;
    volatile int32_t retainCount;
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
    return [isa isSubclassOfClass: aClass];
}

- (BOOL)isMemberOfClass: (Class)aClass
{
    return isa == aClass;
}

- (BOOL)conformsToProtocol: (Protocol *)aProtocol
{
    return class_conformsToProtocol(isa, aProtocol);
}

- (BOOL)respondsToSelector: (SEL)aSelector
{
    return class_respondsToSelector(isa, aSelector);
}

- (id)retain
{
    OSAtomicIncrement32(&retainCount);
    return self;
}

- (oneway void)release
{
    uint32_t newCount = OSAtomicDecrement32(&retainCount);
    if(newCount == 0)
        [self dealloc];
}

- (id)autorelease
{
    [NSAutoreleasePool addObject: self];
    return self;
}

- (NSUInteger)retainCount
{
    return retainCount;
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
    free(self);
}

- (void)finalize
{
}

- (id)copy
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

- (id)mutableCopy
{
    [self doesNotRecognizeSelector: _cmd];
    return nil;
}

+ (Class)superclass
{
    return class_getSuperclass(self);
}

+ (Class)class
{
    return self;
}

+ (BOOL)instancesRespondToSelector: (SEL)aSelector
{
    return class_respondsToSelector(self, aSelector);
}

+ (BOOL)conformsToProtocol: (Protocol *)protocol
{
    return class_conformsToProtocol(self, protocol);
}

- (IMP)methodForSelector: (SEL)aSelector
{
    return class_getMethodImplementation(isa, aSelector);
}

+ (IMP)instanceMethodForSelector: (SEL)aSelector
{
    return class_getMethodImplementation(self, aSelector);
}

- (void) doesNotRecognizeSelector: (SEL)aSelector
{
    char *methodTypeString = class_isMetaClass(isa) ? "+" : "-";
    [NSException raise: NSInvalidArgumentException format: @"%s[%@ %@]: unrecognized selector sent to instance %p", methodTypeString, [[self class] description], NSStringFromSelector(aSelector), self];
}

- (id)forwardingTargetForSelector: (SEL)aSelector
{
    return nil;
}

- (void)forwardInvocation: (NSInvocation *)anInvocation
{
    [self doesNotRecognizeSelector: [anInvocation selector]];
}

- (NSMethodSignature *)methodSignatureForSelector: (SEL)aSelector
{
    return [isa instanceMethodSignatureForSelector: aSelector];
}

+ (NSMethodSignature *)instanceMethodSignatureForSelector: (SEL)aSelector
{
    Method method = class_getInstanceMethod(self, aSelector);
    if(!method)
        return nil;
    
    const char *types = method_getTypeEncoding(method);
    return [NSMethodSignature signatureWithObjCTypes: types];
}

+ (NSString *)description
{
    return [NSString stringWithUTF8String: class_getName(self)];
}

+ (BOOL)isSubclassOfClass: (Class)aClass
{
    for(Class candidate = self; candidate != nil; candidate = [candidate superclass])
        if (candidate == aClass)
            return YES;
    
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
