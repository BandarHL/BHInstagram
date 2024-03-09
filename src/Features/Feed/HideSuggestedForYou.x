#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Remove suggested for you (accounts)
%hook IGHScrollAYMFSectionController
- (id)initWithUserSession:(id)arg1 sessionId:(id)arg2 analyticsModule:(id)arg3 format:(NSInteger)arg4 netEgoItemType:(NSUInteger)arg5 netegoImpressionStrategy:(id)arg6 isForcedDarkModeImmersive:(BOOL)arg7 {
    if ([BHIManager removeSuggestedAccounts]) {
        NSLog(@"[BHInsta] Hiding suggested for you");

        return nil;
    }
    return %orig;
}
%end