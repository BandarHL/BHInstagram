#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGScreenshotObserver
+ (id)_onTakenScreenshot {
    if ([BHIManager noScreenShotAlert]) {
        return nil;
    }
    return %orig;
}
%end