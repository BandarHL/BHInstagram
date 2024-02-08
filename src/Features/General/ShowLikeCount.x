#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGFeedItem
- (id)buildLikeCellStyledStringWithIcon:(id)arg1 andText:(id)arg2 style:(id)arg3 {
    if ([BHIManager showLikeCount]) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:self.likeCount]];
        NSString *newArg2 = [NSString stringWithFormat:@"%@ (%@)", arg2 ?: @"Liked:", formatted];
        return %orig(arg1, newArg2, arg3);
    }

    return %orig(arg1, arg2, arg3);
}
%end

// For instagram v178.0
%hook IGFeedItemLikeCountCell
+ (IGStyledString *)buildStyledStringWithMedia:(IGMedia *)arg1 feedItemRow:(id)arg2 pageCellState:(id)arg3 configuration:(id)arg4 feedConfiguration:(id)arg5 contentWidth:(double)arg6 textWidth:(double)arg7 combinedContextOptions:(long long)arg8 userSession:(id)arg9 {
    IGStyledString *orig = %orig;
    if ([BHIManager showLikeCount]) {
        if (
            orig != nil
            && orig.attributedString != nil
            && orig.attributedString.string != nil
            && ![orig.attributedString.string containsString:@"("]
            && ![orig.attributedString.string containsString:@")"]
        ) {
            NSNumberFormatter *formatter = [NSNumberFormatter new];
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:arg1.likeCount]];
            [orig appendString:[NSString stringWithFormat:@" (%@)", formatted]];
      }
    }

    return orig;
}
%end