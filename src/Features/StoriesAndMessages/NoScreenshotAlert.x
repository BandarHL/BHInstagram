#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// ! Note !
// Doesn't work for some reason, need to fix lol

%hook IGScreenshotObserver
+ (id)_onTakenScreenshot {
    if ([BHIManager noScreenShotAlert]) {
        return nil;
    }
    return %orig;
}
%end