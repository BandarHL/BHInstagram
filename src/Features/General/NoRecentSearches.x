#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Most in-app search bars
%hook IGRecentSearchStore
- (BOOL)addItem:(id)arg1 {
    if ([BHIManager noRecentSearches]) {
        return nil;
    } else {
        return %orig;
    }
}
%end

// Recent dm message recipients search bar
%hook IGDirectRecipientRecentSearchStorage
- (id)initWithDiskManager:(id)arg1 directCache:(id)arg2 userStore:(id)arg3 currentUser:(id)arg4 featureSets:(id)arg5 {
    if ([BHIManager noRecentSearches]) {
        return nil;
    } else {
        return %orig;
    }
}
%end