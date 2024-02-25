#import "../../InstagramHeaders.h"
#import "../../Manager.h"
#import "../../Tweak.h"
# import "../../Utils.h"

// Seen buttons (in DMs)
// - Enables no seen for messages
// - Enables unlimited views of DM visual messages
%hook IGTallNavigationBarView
- (void)setRightBarButtonItems:(NSArray <UIBarButtonItem *> *)items {
    NSMutableArray *new_items = [items mutableCopy];

    // Messages seen
    if ([BHIManager hideLastSeen]) {
        UIBarButtonItem *seenButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"checkmark.message"] style:UIBarButtonItemStylePlain target:self action:@selector(seenButtonHandler:)];
        [new_items addObject:seenButton];

        if (seenButtonEnabled) {
            [seenButton setTintColor:BHIUtils.BHIColour_Primary];
        } else {
            [seenButton setTintColor:UIColor.labelColor];
        }
    }

    // DM visual messages viewed
    if ([BHIManager unlimitedReplay]) {
        UIBarButtonItem *dmVisualMsgsViewedButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"photo.badge.checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(dmVisualMsgsViewedButtonHandler:)];
        [new_items addObject:dmVisualMsgsViewedButton];

        if (dmVisualMsgsViewedButtonEnabled) {
            [dmVisualMsgsViewedButton setTintColor:BHIUtils.BHIColour_Primary];
        } else {
            [dmVisualMsgsViewedButton setTintColor:UIColor.labelColor];
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
        [sender setTintColor:BHIUtils.BHIColour_Primary];
    }
}
// DM visual messages viewed button
%new - (void)dmVisualMsgsViewedButtonHandler:(UIBarButtonItem *)sender {
    if (dmVisualMsgsViewedButtonEnabled) {
        dmVisualMsgsViewedButtonEnabled = false;
        [sender setTintColor:UIColor.labelColor];
    } else {
        dmVisualMsgsViewedButtonEnabled = true;
        [sender setTintColor:BHIUtils.BHIColour_Primary];
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
        if (dmVisualMsgsViewedButtonEnabled) {}
        else return;
    }

    return %orig;
}
%end