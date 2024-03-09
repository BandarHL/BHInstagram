#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Remove suggested threads posts (carousel, under suggested posts in feed)
%hook BKBloksViewHelper
- (id)initWithObjectSet:(id)arg1 bloksData:(id)arg2 delegate:(id)arg3 {
    if ([BHIManager removeSuggestedThreads]) {
        NSLog(@"[BHInsta] Hiding threads posts");

        return nil;
    }
    return %orig;
}
%end