#import "../../InstagramHeaders.h"
#import "../../Manager.h"
#import "../../Tweak.h"

%hook IGStoryViewerViewController
- (void)fullscreenSectionController:(id)arg1 didMarkItemAsSeen:(id)arg2 {
    if ([BHIManager noSeenReceipt]) {
        %orig;

        // Currently not working (dunno why and im lazy too fix)
        /* if (shouldBeSeen) {
            shouldBeSeen = false;
        } */
    } else {
        return %orig;
    }
}
%end