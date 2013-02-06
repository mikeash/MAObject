
#import "MAObject.h"

#import <libkern/OSAtomic.h>
#import <objc/runtime.h>


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
    obj->retainCount = 1;
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

- (id)valueForKey: (NSString *)key
{
    SEL getterSEL = NSSelectorFromString(key);
    if([self respondsToSelector: getterSEL])
    {
        Method method = class_getInstanceMethod(isa, getterSEL);
        
        char type;
        method_getReturnType(method, &type, 1);
        IMP imp = method_getImplementation(method);
        
        if(type == @encode(id)[0] || type == @encode(Class)[0])
        {
            return ((id (*)(id, SEL))imp)(self, getterSEL);
        }
        else
        {
            #define CASE(ctype, selectorpart) \
                if(type == @encode(ctype)[0]) \
                    return [NSNumber numberWith ## selectorpart: ((ctype (*)(id, SEL))imp)(self, getterSEL)];
            
            CASE(char, Char);
            CASE(unsigned char, UnsignedChar);
            CASE(short, Short);
            CASE(unsigned short, UnsignedShort);
            CASE(int, Int);
            CASE(unsigned int, UnsignedInt);
            CASE(long, Long);
            CASE(unsigned long, UnsignedLong);
            CASE(long long, LongLong);
            CASE(unsigned long long, UnsignedLongLong);
            CASE(float, Float);
            CASE(double, Double);
            
            #undef CASE
            
            [NSException raise: NSInternalInconsistencyException format: @"Class %@ key %@ don't know how to interpret method return type from getter, type encoding string is %s", [isa description], key, method_getTypeEncoding(method)];
        }
    }
    
    Ivar ivar = class_getInstanceVariable(isa, [key UTF8String]);
    if(!ivar)
        ivar = class_getInstanceVariable(isa, [[@"_" stringByAppendingString: key] UTF8String]);
    
    if(ivar)
    {
        ptrdiff_t offset = ivar_getOffset(ivar);
        char *ptr = (char *)self;
        ptr += offset;
        
        const char *type = ivar_getTypeEncoding(ivar);
        if(type[0] == @encode(id)[0] || type[0] == @encode(Class)[0])
        {
            return *(id *)ptr;
        }
        else
        {
            #define CASE(ctype, selectorpart) \
                if(strcmp(type, @encode(ctype)) == 0) \
                    return [NSNumber numberWith ## selectorpart: *(ctype *)ptr];
            
            CASE(char, Char);
            CASE(unsigned char, UnsignedChar);
            CASE(short, Short);
            CASE(unsigned short, UnsignedShort);
            CASE(int, Int);
            CASE(unsigned int, UnsignedInt);
            CASE(long, Long);
            CASE(unsigned long, UnsignedLong);
            CASE(long long, LongLong);
            CASE(unsigned long long, UnsignedLongLong);
            CASE(float, Float);
            CASE(double, Double);
            
            #undef CASE
    
            return [NSValue valueWithBytes: ptr objCType: type];
        }
    }
    
    [NSException raise: NSInternalInconsistencyException format: @"Class %@ is not key-value compliant for key %@", [isa description], key];
    return nil;
}

- (void)setValue: (id)value forKey: (NSString *)key
{
    NSString *setterName = [NSString stringWithFormat: @"set%@:", [key capitalizedString]];
    SEL setterSEL = NSSelectorFromString(setterName);
    if([self respondsToSelector: setterSEL])
    {
        Method method = class_getInstanceMethod(isa, setterSEL);
        
        char type;
        method_getArgumentType(method, 2, &type, 1);
        IMP imp = method_getImplementation(method);
        
        if(type == @encode(id)[0] || type == @encode(Class)[0])
        {
            ((void (*)(id, SEL, id))imp)(self, setterSEL, value);
            return;
        }
        else
        {
            #define CASE(ctype, selectorpart) \
                if(type == @encode(ctype)[0]) { \
                    ((void (*)(id, SEL, ctype))imp)(self, setterSEL, [value selectorpart ## Value]); \
                    return; \
                }
                
            CASE(char, char);
            CASE(unsigned char, unsignedChar);
            CASE(short, short);
            CASE(unsigned short, unsignedShort);
            CASE(int, int);
            CASE(unsigned int, unsignedInt);
            CASE(long, long);
            CASE(unsigned long, unsignedLong);
            CASE(long long, longLong);
            CASE(unsigned long long, unsignedLongLong);
            CASE(float, float);
            CASE(double, double);
            
            #undef CASE
            
            [NSException raise: NSInternalInconsistencyException format: @"Class %@ key %@ set from incompatible object %@", [isa description], key, value];
        }
    }
    
    Ivar ivar = class_getInstanceVariable(isa, [key UTF8String]);
    if(!ivar)
        ivar = class_getInstanceVariable(isa, [[@"_" stringByAppendingString: key] UTF8String]);
    
    if(ivar)
    {
        ptrdiff_t offset = ivar_getOffset(ivar);
        char *ptr = (char *)self;
        ptr += offset;
        
        const char *type = ivar_getTypeEncoding(ivar);
        if(type[0] == @encode(id)[0] || type[0] == @encode(Class)[0])
        {
            [*(id *)ptr release];
            *(id *)ptr = [value retain];
            return;
        }
        else
        {
            if(strcmp([value objCType], type) == 0)
            {
                [value getValue: ptr];
                return;
            }
            else
            {
                #define CASE(ctype, selectorpart) \
                    if(strcmp(type, @encode(ctype)) == 0) { \
                        *(ctype *)ptr = [value selectorpart ## Value]; \
                        return; \
                    }
                
                CASE(char, char);
                CASE(unsigned char, unsignedChar);
                CASE(short, short);
                CASE(unsigned short, unsignedShort);
                CASE(int, int);
                CASE(unsigned int, unsignedInt);
                CASE(long, long);
                CASE(unsigned long, unsignedLong);
                CASE(long long, longLong);
                CASE(unsigned long long, unsignedLongLong);
                CASE(float, float);
                CASE(double, double);
                
                #undef CASE
                
                [NSException raise: NSInternalInconsistencyException format: @"Class %@ key %@ set from incompatible object %@", [isa description], key, value];
            }
        }
    }
    
    [NSException raise: NSInternalInconsistencyException format: @"Class %@ is not key-value compliant for key %@", [isa description], key];
}

- (id)valueForKeyPath: (NSString *)keyPath
{
    NSRange range = [keyPath rangeOfString: @"."];
    if(range.location == NSNotFound)
        return [self valueForKey: keyPath];
    
    NSString *key = [keyPath substringToIndex: range.location];
    NSString *rest = [keyPath substringFromIndex: NSMaxRange(range)];
    
    id next = [self valueForKey: key];
    return [next valueForKeyPath: rest];
}

- (void)setValue: (id)value forKeyPath: (NSString *)keyPath
{
    NSRange range = [keyPath rangeOfString: @"."];
    if(range.location == NSNotFound)
    {
        [self setValue: value forKey: keyPath];
        return;
    }
    
    NSString *key = [keyPath substringToIndex: range.location];
    NSString *rest = [keyPath substringFromIndex: NSMaxRange(range)];
    id next = [self valueForKey: key];
    [next setValue: value forKeyPath: rest];
}

@end
