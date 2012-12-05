// clang -framework Foundation MAObject.m tester.m

#import "MAObject.h"


int main(int argc, char **argv)
{
    @autoreleasepool
    {
        MAObject *obj = [[MAObject alloc] init];
        NSLog(@"%@", obj);
        [obj release];
        
        [[[MAObject alloc] init] copy];
    }
}
