#import "../../Manager.h"
#import "../../Utils.h"

%hook IGDirectThreadCallButtonsCoordinator
// Voice Call
- (void)_didTapAudioButton:(id)arg1 {
    if ([BHIManager callConfirmation]) {
        NSLog(@"[BHInsta] Call confirm triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}

// Video Call
- (void)_didTapVideoButton:(id)arg1 {
    if ([BHIManager callConfirmation]) {
        NSLog(@"[BHInsta] Call confirm triggered");
        
        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end