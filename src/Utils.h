#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/* @interface BHIUtils : NSObject
+ (BOOL)isNotch;
+ (void)showConfirmation:(void (^)(void))okHandler;
@end */

extern BOOL isNotch(void);

extern void showConfirmation(void (^okHandler)(void));