#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGDSSegmentedPillControl
+ (id)newWithStyle:(id)arg1 {
    if ([BHIManager hideTrendingSearches]) {
        return nil;
    }
    
    return %orig;
}
%end