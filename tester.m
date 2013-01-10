// clang -framework Foundation MAObject.m tester.m

#import "MAObject.h"

//#import <Foundation/Foundation.h>


@interface TestObject : MAObject
@end

@implementation TestObject {
    int a;
    char b;
    float c;
    double d;
    id e;
    long long f;
    NSMutableDictionary *g;
}

- (void)dealloc
{
    NSLog(@"Dealloc!");
    [super dealloc];
}

- (void)setFoo: (id)value
{
    NSLog(@"setFoo: %@", value);
}

- (void)setBar: (int)value
{
    NSLog(@"setBar: %d", value);
}

- (void)setBaz: (double)value
{
    NSLog(@"setBaz: %f", value);
}

- (id)foo
{
    return @"foovalue";
}

- (int)bar
{
    return 42;
}

- (double)baz
{
    return 99.99;
}

@end

int main(int argc, char **argv)
{
    @autoreleasepool
    {
//        Method *methods = class_copyMethodList([NSObject class], NULL);
//        while(*methods++)
//            NSLog(@"%s", sel_getName(method_getName(methods[-1])));
        TestObject *obj = [[TestObject alloc] init];
        NSLog(@"%@", obj);
        
        [obj setValue: @1 forKey: @"a"];
        [obj setValue: @2 forKey: @"b"];
        [obj setValue: @3 forKey: @"c"];
        [obj setValue: @4 forKey: @"d"];
        [obj setValue: @"five" forKey: @"e"];
        [obj setValue: @6 forKey: @"f"];
        
        NSLog(@"%@ %@ %@ %@ %@ %@ %@", [obj valueForKey: @"isa"], [obj valueForKey: @"a"], [obj valueForKey: @"b"], [obj valueForKey: @"c"], [obj valueForKey: @"d"], [obj valueForKey: @"e"], [obj valueForKey: @"f"]);
        
        [obj setValue: @"something" forKey: @"foo"];
        [obj setValue: @1000 forKey: @"bar"];
        [obj setValue: @82.8 forKey: @"baz"];
        
        NSLog(@"%@ %@ %@", [obj valueForKey: @"foo"], [obj valueForKey: @"bar"], [obj valueForKey: @"baz"]);
        
        [obj setValue: [NSMutableDictionary dictionary] forKeyPath: @"g"];
        [obj setValue: @2 forKeyPath: @"g.foo"];
        [obj setValue: @3 forKeyPath: @"g.bar"];
        NSLog(@"%@ %@ %@ %@", [obj valueForKeyPath: @"g"], [obj valueForKeyPath: @"g.foo"], [obj valueForKeyPath: @"g.bar"], [obj valueForKeyPath: @"g.baz"]);
        
        [obj valueForKey: @"blahblah"];
        
        [obj release];
        
//        [[[MAObject alloc] init] copy];
    }
}
