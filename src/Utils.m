#import <UIKit/UIKit.h>
#import "Utils.h"
#import "InstagramHeaders.h"

// Colours
static NSDictionary *bhColours = @{
    @"primary" : [UIColor colorWithRed:66/255.0 green:79/255.0 blue:91/255.0 alpha:1]
}

// Functions
BOOL isNotch() {
    return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].bottom > 0;
}

void showConfirmation(void (^okHandler)(void)) {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okHandler();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"No!" style:UIAlertActionStyleCancel handler:nil]];

    [topMostController() presentViewController:alert animated:YES completion:nil];
};