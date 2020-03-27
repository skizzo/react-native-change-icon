#import "React/RCTLog.h"
#import "ChangeIcon.h"

@implementation ChangeIcon

RCT_EXPORT_MODULE()

RCT_REMAP_METHOD(changeIcon, iconName:(NSString *)iconName resolver:(RCTPromiseResolveBlock)resolve rejecter:(RCTPromiseRejectBlock)reject) {
    NSError *error = nil;
    
    // Not supported
    if ([[UIApplication sharedApplication] supportsAlternateIcons] == NO) {
        reject(@"Error", @"Alternate icon not supported", error);
        RCTLog(@"Alternate icons are not supported");
        return;
    }

    NSString *currentIcon = [[UIApplication sharedApplication] alternateIconName];

    // Already in use
    if ([iconName isEqualToString:currentIcon]) {
        reject(@"Error", @"Icon already in use", error);
        RCTLog(@"Icon already in use");
        return;
    }

    resolve(@(YES));

    // Custom icon

    // Shows Alert on Change
    /*
    [[UIApplication sharedApplication] setAlternateIconName:iconName completionHandler:^(NSError * _Nullable error) {
        RCTLog(@"%@", [error description]);
    }];
    */

    // Doesn't Show Alert but uses Private API
    NSMutableString *selectorString = [[NSMutableString alloc] initWithCapacity:40];
    [selectorString appendString:@"_setAlternate"];
    [selectorString appendString:@"IconName:"];
    [selectorString appendString:@"completionHandler:"];

    SEL selector = NSSelectorFromString(selectorString);
    IMP imp = [[UIApplication sharedApplication] methodForSelector:selector];
    void (*func)(id, SEL, id, id) = (void *)imp;
    if (func)
    {
        func([UIApplication sharedApplication], selector, iconName, ^(NSError * _Nullable error) {});
    }

}

@end
