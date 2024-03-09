#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGExploreGridViewController
- (id)view {
    if ([BHIManager hideExploreGrid]) {
        NSLog(@"[BHInsta] Hiding explore grid");

        return nil;
    }

    return %orig;
}
%end