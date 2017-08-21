//
//  main.m
//  testLink
//
//  Created by Ben on 2017/8/21.
//  Copyright © 2017年 QQingiOSTeam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MyCategory)

- (void)sayHelloWorld;

@end

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        [[NSObject new] sayHelloWorld];
    }
    return 0;
}
