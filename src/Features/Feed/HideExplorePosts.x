#import "../../InstagramHeaders.h"
#import "../../Manager.h"

/* %hook IGExploreGridViewController
- (id)initWithTopic:(id)
userSession:(id)
dataController:(id)
sessionTracker:(id)
layoutConfig:(IGGridLayoutConfiguration)
layoutStyle:(NSInteger)
loggingContext:(id)
feedStore:(id)
firstAppearanceCallback:(id)
layoutContext:(id)
delegate:(id)
useTransparentBackground:(BOOL)
{
    if ([BHIManager removeSuggestedAccounts]) { // make sure to replace with correct one lol
        return nil;
    }
    return %orig;
}
%end */


/* %hook IGExploreDataController
- (void)

%end */