#import "../../InstagramHeaders.h"
#import "../../Manager.h"
#import "../../Tweak.h"

// Seen buttons (in DMs)
// - Enables no seen for messages
// - Enables unlimited views of DM stories
%hook IGTallNavigationBarView
- (void)setRightBarButtonItems:(NSArray <UIBarButtonItem *> *)items {
    NSMutableArray *new_items = [items mutableCopy];

    // Messages seen
    if ([BHIManager hideLastSeen]) {
        UIBarButtonItem *seenButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"checkmark.message"] style:UIBarButtonItemStylePlain target:self action:@selector(seenButtonHandler:)];
        [new_items addObject:seenButton];

        if (seenButtonEnabled) {
            [seenButton setTintColor:UIColor.blueColor];
        } else {
            [seenButton setTintColor:UIColor.labelColor];
        }
    }

    // DM stories viewed
    if ([BHIManager unlimitedReplay]) {
        UIBarButtonItem *dmStoriesViewedButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"photo.badge.checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(dmStoriesViewedButtonHandler:)];
        [new_items addObject:dmStoriesViewedButton];

        if (dmStoriesViewedButtonEnabled) {
            [dmStoriesViewedButton setTintColor:UIColor.blueColor];
        } else {
            [dmStoriesViewedButton setTintColor:UIColor.labelColor];
        }
    }

    %orig([new_items copy]);
}

// Messages seen button
%new - (void)seenButtonHandler:(UIBarButtonItem *)sender {
    if (seenButtonEnabled) {
        seenButtonEnabled = false;
        [sender setTintColor:UIColor.labelColor];
    } else {
        seenButtonEnabled = true;
        [sender setTintColor:UIColor.blueColor];
    }
}
// DM stories viewed button
%new - (void)dmStoriesViewedButtonHandler:(UIBarButtonItem *)sender {
    if (dmStoriesViewedButtonEnabled) {
        dmStoriesViewedButtonEnabled = false;
        [sender setTintColor:UIColor.labelColor];
    } else {
        dmStoriesViewedButtonEnabled = true;
        [sender setTintColor:UIColor.blueColor];
    }
}
%end

// Messages seen logic
%hook IGDirectThreadViewListAdapterDataSource
- (BOOL)shouldUpdateLastSeenMessage {
    if ([BHIManager hideLastSeen]) {
        // Check if messages should be shown as seen
        if (seenButtonEnabled) {
            return %orig;
        }
        return false;
    }
    
    return %orig;
}
%end

// DM stories viewed logic
%hook IGStoryPhotoView
- (void)progressImageView:(id)arg1 didLoadImage:(id)arg2 loadSource:(id)arg3 networkRequestSummary:(id)arg4 {
    if ([BHIManager unlimitedReplay]) {
        // Check if dm stories should be marked as viewed
        if (dmStoriesViewedButtonEnabled) {}
        else return;
    }

    return %orig;
}
%end