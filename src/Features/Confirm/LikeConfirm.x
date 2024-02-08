#import "../../Manager.h"
#import "../../Utils.h"

// Liking posts
%hook IGUFIButtonBarView
- (void)_onLikeButtonPressed:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end
%hook IGFeedPhotoView
- (void)_onDoubleTap:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end
// No longer works on latest app version
%hook IGFeedItemVideoView
- (void)_handleOverlayDoubleTap {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end
%hook IGModernFeedVideoCell
- (void)videoPlayerOverlayControllerDidDoubleTap:(id)arg1 locationInfo:(id)arg2 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end

// Liking reels
%hook IGSundialViewerVideoCell
- (void)controlsOverlayControllerDidTapLikeButton:(id)arg1 {
    if ([BHIManager reelsLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)controlsOverlayControllerDidLongPressLikeButton:(id)arg1 gestureRecognizer:(id)arg2 {
    if ([BHIManager reelsLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)controlsOverlayControllerDidTapLikedBySocialContextButton:(id)arg1 button:(id)arg2 {
    if ([BHIManager reelsLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)gestureController:(id)arg1 didObserveDoubleTap:(id)arg2 {
    if ([BHIManager reelsLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end

// Liking comments
%hook IGCommentCellController
- (void)commentCell:(id)arg1 didTapLikeButton:(id)arg2 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)commentCell:(id)arg1 didTapLikedByButtonForUser:(id)arg2 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)commentCellDidLongPressOnLikeButton:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)commentCellDidEndLongPressOnLikeButton:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)commentCellDidDoubleTap:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end

// Liking stories
%hook IGStoryFullscreenDefaultFooterView
- (void)_likeTapped {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
- (void)inputView:(id)arg1 didTapLikeButton:(id)arg2 {
    if ([BHIManager postLikeConfirmation]) {
        showConfirmation(^(void) { %orig; });
    } else {
        return %orig;
    }
}
%end