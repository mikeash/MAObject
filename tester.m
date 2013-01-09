// clang -framework Foundation MAObject.m tester.m

#import "MAObject.h"


@interface TestObject : MAObject
@end

@implementation TestObject

- (void)dealloc
{
    NSLog(@"Dealloc!");
    [super dealloc];
}

@end

int main(int argc, char **argv)
{
    @autoreleasepool
    {
        TestObject *obj = [[TestObject alloc] init];
        NSLog(@"%@", obj);
        [obj release];
        
        [[[MAObject alloc] init] copy];
    }
}
