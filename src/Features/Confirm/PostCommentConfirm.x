#import "../../Manager.h"
#import "../../Utils.h"

%hook IGCommentComposingController
- (void)_onSendButtonTapped:(id)arg1 {
    if ([BHIManager postCommentConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end