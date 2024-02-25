#import <UIKit/UIKit.h>
#import "Utils.h"
#import "InstagramHeaders.h"

@implementation BHIUtils

// Colours
+ (UIColor *)BHIColour_Primary {
    return [UIColor colorWithRed:0/255.0 green:152/255.0 blue:254/255.0 alpha:1];
};

// Functions
+ (BOOL)isNotch {
    return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].bottom > 0;
};
+ (BOOL)showConfirmation:(void(^)(void))okHandler {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okHandler();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No!" style:UIAlertActionStyleCancel handler:nil]];

    [topMostController() presentViewController:alert animated:YES completion:nil];

    return nil;
};

@end