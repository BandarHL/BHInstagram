#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGExploreGridViewController
- (id)view {
    if ([BHIManager hideExploreGrid]) {
        return nil;
    }

    return %orig;
}
%end