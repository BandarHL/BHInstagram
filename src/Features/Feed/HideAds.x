#import "../../InstagramHeaders.h"
#import "../../Manager.h"

static NSArray *removeAdsItemsInList(NSArray *list) {
    NSMutableArray *orig = [list mutableCopy];
    [orig enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        // Remove suggested posts
        if ([BHIManager removeSuggestedPost]) {
            if ([obj respondsToSelector:@selector(explorePostInFeed)] && [obj performSelector:@selector(explorePostInFeed)]) {
                [orig removeObjectAtIndex:idx];
            }
        }

        if (([obj isKindOfClass:%c(IGFeedItem)] && ([obj isSponsored] || [obj isSponsoredApp])) || [obj isKindOfClass:%c(IGAdItem)]) {
            [orig removeObjectAtIndex:idx];
        }
    }];
    return [orig copy];
}

// Suggested posts
%hook IGMainFeedListAdapterDataSource
- (NSArray *)objectsForListAdapter:(id)arg1 {
    if ([BHIManager hideAds]) {
        return removeAdsItemsInList(%orig);
    }
    return %orig;
}
%end
%hook IGVideoFeedViewController
- (NSArray *)objectsForListAdapter:(id)arg1 {
    if ([BHIManager hideAds]) {
        return removeAdsItemsInList(%orig);
    }
    return %orig;
}
%end
%hook IGChainingFeedViewController
- (NSArray *)objectsForListAdapter:(id)arg1 {
    if ([BHIManager hideAds]) {
        return removeAdsItemsInList(%orig);
    }
    return %orig;
}
%end
%hook IGStoryAdPool
- (id)initWithUserSession:(id)arg1 {
    if ([BHIManager hideAds]) {
        return nil;
    }
    return %orig;
}
%end
%hook IGStoryAdsManager
- (id)initWithUserSession:(id)arg1 storyViewerLoggingContext:(id)arg2 storyFullscreenSectionLoggingContext:(id)arg3 viewController:(id)arg4 {
    if ([BHIManager hideAds]) {
        return nil;
    }
    return %orig;
}
%end
%hook IGStoryAdsFetcher
- (id)initWithUserSession:(id)arg1 delegate:(id)arg2 {
    if ([BHIManager hideAds]) {
        return nil;
    }
    return %orig;
}
%end
// IG 148.0
%hook IGStoryAdsResponseParser
- (id)parsedObjectFromResponse:(id)arg1 {
    if ([BHIManager hideAds]) {
        return nil;
    }
    return %orig;
}
- (id)initWithReelStore:(id)arg1 {
    if ([BHIManager hideAds]) {
        return nil;
    }
    return %orig;
}
%end
%hook IGStoryAdsOptInTextView
- (id)initWithBrandedContentStyledString:(id)arg1 sponsoredPostLabel:(id)arg2 {
    if ([BHIManager hideAds]) {
        return nil;
    }
    return %orig;
}
%end
%hook IGSundialAdsResponseParser
- (id)parsedObjectFromResponse:(id)arg1 {
    if ([BHIManager hideAds]) {
        return nil;
    }
    return %orig;
}
- (id)initWithMediaStore:(id)arg1 userStore:(id)arg2 {
    if ([BHIManager hideAds]) {
        return nil;
    }
    return %orig;
}
%end