#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// ! Note !
// Not sure if this works, have to test

%hook IGScreenshotObserver
+ (id)_onTakenScreenshot {
    if ([BHIManager noScreenShotAlert]) {
        return nil;
    }
    return %orig;
}
%end