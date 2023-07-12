#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BHIManager: NSObject
+ (BOOL)hideAds;
+ (BOOL)downloadVideos;
+ (BOOL)profileImageSave;
+ (BOOL)removeSuggestedPost;
+ (BOOL)showLikeCount;
+ (BOOL)likeConfirmation;
+ (BOOL)copyDecription;
+ (BOOL)Padlock;
+ (BOOL)keepDeletedMessage;
+ (BOOL)hideLastSeen;
+ (BOOL)noScreenShotAlert;
+ (BOOL)unlimtedReply;
+ (BOOL)noSeenReceipt;
+ (void)showSaveVC:(id)item;
+ (void)cleanCache;
+ (BOOL)isEmpty:(NSURL *)url;
+ (NSString *)getDownloadingPersent:(float)per;
@end