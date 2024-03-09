#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGDSSegmentedPillControl
+ (id)newWithStyle:(id)arg1 {
    if ([BHIManager hideTrendingSearches]) {
        NSLog(@"[BHInsta] Hiding trending searches");

        return nil;
    }
    
    return %orig;
}
%end