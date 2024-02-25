#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BHIUtils : NSObject

// Colours
+ (UIColor *)BHIColour_Primary;

// Functions
+ (BOOL)isNotch;
+ (BOOL)showConfirmation:(void(^)(void))okHandler;

@end