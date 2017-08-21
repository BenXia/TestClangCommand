//
//  main.m
//  TestProject
//
//  Created by Ben on 2017/8/21.
//  Copyright © 2017年 iOSStudio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseTest : NSObject

@end

@implementation BaseTest

/**
 *  打断点后使用 dis -fm 可以看汇编代码，查下堆栈情况
 */

- (void)print {
    NSLog(@"0");
}

- (void)print:(NSString *)s1 {
    NSLog(@"1 %@", s1);
}

- (void)print:(NSString *)s1 s2:(NSString *)s2 {
    NSLog(@"2 %@ %@", s1, s2);
}

- (void)print:(NSString *)s1 s2:(NSString *)s2 s3:(NSString *)s3 {
    NSLog(@"3 %@ %@ %@", s1, s2, s3);
}

- (void)print:(NSString *)s1 s2:(NSString *)s2 s3:(NSString *)s3 s4:(NSString *)s4 s5:(NSString *)s5 s6:(NSString *)s6 s7:(NSString *)s7 s8:(NSString *)s8 s9:(NSString *)s9 s10:(NSString *)s10 s11:(NSString *)s11 s12:(NSString *)s12 {
    NSLog(@"12 %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@ %@", s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12);
}

@end


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        BaseTest *obj = [BaseTest new];
        
        //[obj print:nil s2:nil s3:nil];
        
        [obj print:nil s2:nil s3:nil s4:nil s5:nil s6:nil s7:nil s8:nil s9:nil s10:nil s11:nil s12:nil];
    }
    return 0;
}
