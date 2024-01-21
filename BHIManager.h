#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BHIManager : NSObject
+ (BOOL)hideAds;
+ (BOOL)downloadVideos;
+ (BOOL)profileImageSave;
+ (BOOL)removeSuggestedPost;
+ (BOOL)showLikeCount;
+ (BOOL)postLikeConfirmation;
+ (BOOL)reelsLikeConfirmation;
+ (BOOL)followConfirmation;
+ (BOOL)callConfirmation;
+ (BOOL)postCommentConfirmation;
+ (BOOL)copyDecription;
+ (BOOL)Padlock;
+ (BOOL)keepDeletedMessage;
+ (BOOL)hideLastSeen;
+ (BOOL)noScreenShotAlert;
+ (BOOL)unlimtedReply;
+ (BOOL)noSeenReceipt;
+ (BOOL)FLEX;
+ (void)showSaveVC:(id)item;
+ (void)cleanCache;
+ (BOOL)isEmpty:(NSURL *)url;
+ (NSString *)getDownloadingPersent:(float)per;
@end