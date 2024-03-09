#import "../../Manager.h"
#import "../../Utils.h"

// Liking posts
%hook IGUFIButtonBarView
- (void)_onLikeButtonPressed:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end
%hook IGFeedPhotoView
- (void)_onDoubleTap:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end
%hook IGVideoPlayerOverlayContainerView
- (void)_handleDoubleTapGesture:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// Liking reels
%hook IGSundialViewerVideoCell
- (void)controlsOverlayControllerDidTapLikeButton:(id)arg1 {
    if ([BHIManager reelsLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm reels like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)controlsOverlayControllerDidLongPressLikeButton:(id)arg1 gestureRecognizer:(id)arg2 {
    if ([BHIManager reelsLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm reels like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)controlsOverlayControllerDidTapLikedBySocialContextButton:(id)arg1 button:(id)arg2 {
    if ([BHIManager reelsLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm reels like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)gestureController:(id)arg1 didObserveDoubleTap:(id)arg2 {
    if ([BHIManager reelsLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm reels like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// Liking comments
%hook IGCommentCellController
- (void)commentCell:(id)arg1 didTapLikeButton:(id)arg2 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)commentCell:(id)arg1 didTapLikedByButtonForUser:(id)arg2 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)commentCellDidLongPressOnLikeButton:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)commentCellDidEndLongPressOnLikeButton:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)commentCellDidDoubleTap:(id)arg1 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");
        
        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// Liking stories
%hook IGStoryFullscreenDefaultFooterView
- (void)_likeTapped {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
- (void)inputView:(id)arg1 didTapLikeButton:(id)arg2 {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");
        
        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end

// DM like button (seems to be hidden)
%hook IGDirectThreadViewController
- (void)_didTapLikeButton {
    if ([BHIManager postLikeConfirmation]) {
        NSLog(@"[BHInsta] Confirm post like triggered");

        [BHIUtils showConfirmation:^(void) { %orig; }];
    } else {
        return %orig;
    }
}
%end