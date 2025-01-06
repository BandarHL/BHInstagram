#import "Vibration.h"
#import <AudioToolbox/AudioToolbox.h>  // Needed for AudioServicesPlaySystemSound

@implementation Vibration

+ (void)vibrateWithType:(VibrationType)type {
    switch (type) {
        case VibrationTypeError: {
            if (@available(iOS 10.0, *)) {
                UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
                [generator notificationOccurred:UINotificationFeedbackTypeError];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeSuccess: {
            if (@available(iOS 10.0, *)) {
                UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
                [generator notificationOccurred:UINotificationFeedbackTypeSuccess];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeWarning: {
            if (@available(iOS 10.0, *)) {
                UINotificationFeedbackGenerator *generator = [[UINotificationFeedbackGenerator alloc] init];
                [generator notificationOccurred:UINotificationFeedbackTypeWarning];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeLight: {
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleLight];
                [generator impactOccurred];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeMedium: {
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleMedium];
                [generator impactOccurred];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeHeavy: {
            if (@available(iOS 10.0, *)) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleHeavy];
                [generator impactOccurred];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeSoft: {
            if (@available(iOS 13.0, *)) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleSoft];
                [generator impactOccurred];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeRigid: {
            if (@available(iOS 13.0, *)) {
                UIImpactFeedbackGenerator *generator = [[UIImpactFeedbackGenerator alloc] initWithStyle:UIImpactFeedbackStyleRigid];
                [generator impactOccurred];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeSelection: {
            if (@available(iOS 10.0, *)) {
                UISelectionFeedbackGenerator *generator = [[UISelectionFeedbackGenerator alloc] init];
                [generator selectionChanged];
            } else {
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            }
            break;
        }
        case VibrationTypeOldSchool: {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
            break;
        }
    }
}

@end