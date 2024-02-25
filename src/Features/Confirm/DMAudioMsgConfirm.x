#import "../../Manager.h"
#import "../../Utils.h"

%hook IGDirectThreadViewController
- (void)voiceRecordViewController:(id)arg1 didRecordAudioClipWithURL:(id)arg2 waveform:(id)arg3 duration:(CGFloat)arg4 entryPoint:(NSInteger)arg5 {
    if ([BHIManager voiceMessageConfirmation]) {
        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end