#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Remove suggested reels (carousel, under suggested posts in feed)
%hook IGMainFeedStoryTrayActionDelegate
- (id)initWithMainFeedContext:(id)arg1 {
    if ([BHIManager removeSuggestedReels]) {
        NSLog(@"[BHInsta] Hiding suggested reels");

        return nil;
    }
    return %orig;
}
%end