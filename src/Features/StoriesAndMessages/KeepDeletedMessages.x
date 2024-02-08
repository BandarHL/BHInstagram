#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGDirectRealtimeIrisThreadDelta
+ (id)removeItemWithMessageId:(id)arg1 {
    if ([BHIManager keepDeletedMessage]) {
        arg1 = NULL;
    }
    return %orig(arg1);
}
%end

%hook IGDirectMessageUpdate
+ (id)removeMessageWithMessageId:(id)arg1{
    if ([BHIManager keepDeletedMessage]) {
        arg1 = NULL;
    }
    return %orig(arg1);
}
%end