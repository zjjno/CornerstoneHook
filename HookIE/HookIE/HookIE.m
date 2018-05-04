//  HookIE.m
//  HookIE
//
//  Created by in8 on 2018/3/22.
//  Copyright © 2018年 in8. All rights reserved.
//

#import "CTBlockDescription.h"
#import "HookIE.h"
#import <objc/runtime.h>
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

void exchangeInstanceMethod(Class class, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method newMethod = class_getInstanceMethod(class, newSelector);
    method_exchangeImplementations(originalMethod, newMethod);
}

void exchangeClassMethod(Class class, SEL originalSelector, SEL newSelector) {
    Method originalMethod = class_getClassMethod(class, originalSelector);
    Method newMethod = class_getClassMethod(class, newSelector);
    method_exchangeImplementations(originalMethod, newMethod);
}

static void __attribute__((constructor)) initialize(void) {
    @autoreleasepool {

        exchangeInstanceMethod(NSClassFromString(@"NSBundle"), NSSelectorFromString(@"preReleaseExpiryDate"), NSSelectorFromString(@"zjpreReleaseExpiryDate"));

        exchangeInstanceMethod(NSClassFromString(@"ZLicenseWindowController"), NSSelectorFromString(@"isRegistered"), NSSelectorFromString(@"zjisRegistered"));

        exchangeInstanceMethod(NSClassFromString(@"ZLicenseWindowController"), NSSelectorFromString(@"reset:"), NSSelectorFromString(@"zjreset:"));

        exchangeInstanceMethod(NSClassFromString(@"ZLicenseCredential"), NSSelectorFromString(@"authenticateWithPublicKey:"), NSSelectorFromString(@"zjauthenticateWithPublicKey:"));
    }
}

@implementation NSObject (some)

- (BOOL)zjisRegistered {
    return YES;
}

- (NSDate *)zjpreReleaseExpiryDate {
    return [NSDate dateWithTimeIntervalSinceNow:60*60*24*100];
}

- (void)zjreset:(id)arg1 {
    [self performSelector:NSSelectorFromString(@"close:") withObject:nil];
}

- (id)zjauthenticateWithPublicKey:(id)arg1 {
    return nil;
}

@end

