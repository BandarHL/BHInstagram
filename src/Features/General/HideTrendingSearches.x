#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// !! Bug: Currently hides all pill icons within the Instagram app. Instead, only hide "topic" pills.
%hook IGDSSegmentedPillControl
+ (id)newWithStyle:(id)arg1 {
    if ([BHIManager hideTrendingSearches]) {
        NSLog(@"[BHInsta] Hiding trending searches");

        return nil;
    }
    
    return %orig;
}
%end