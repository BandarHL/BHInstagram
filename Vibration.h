#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 Enum representing different vibration types.
 */
typedef NS_ENUM(NSInteger, VibrationType) {
    VibrationTypeError,
    VibrationTypeSuccess,
    VibrationTypeWarning,
    VibrationTypeLight,
    VibrationTypeMedium,
    VibrationTypeHeavy,
    VibrationTypeSoft,    // iOS 13.0+
    VibrationTypeRigid,   // iOS 13.0+
    VibrationTypeSelection,
    VibrationTypeOldSchool
};

/**
 This class provides a method to generate different types of haptic/vibration feedback.
 */
@interface Vibration : NSObject

/**
 Generates a haptic/vibration feedback based on the provided type.

 @param type A value from the VibrationType enum indicating the desired feedback.
 */
+ (void)vibrateWithType:(VibrationType)type;

@end