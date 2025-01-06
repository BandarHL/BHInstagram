#import <Foundation/Foundation.h>
#include <objc/NSObject.h>
#import <UIKit/UIKit.h>
#import "BHIManager.h"
#import "SettingsViewController.h"
#import "SecurityViewController.h"
#import "BHDownload.h"
#import "JGProgressHUD/JGProgressHUD.h"
#import "DeletedMessagesManager.h"
#import "Vibration.h"

@interface IGViewController: UIViewController
- (void)_superPresentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(id)completion;
@end

@interface IGProfileMenuSheetViewController: IGViewController
@end

@interface IGTableViewCell: UITableViewCell
- (id)initWithReuseIdentifier:(NSString *)identifier;
@end

@interface IGProfileSheetTableViewCell: IGTableViewCell
@end

@interface IGTallNavigationBarView: UIView
@end

@interface UIView (RCTViewUnmounting)
@property(retain, nonatomic) UIViewController *viewController;
- (UIView *)_rootView;
@end

@interface IGImageSpecifier : NSObject
@property(readonly, nonatomic) NSURL *url;
@end

@interface IGVideo : NSObject {
  NSSet *_allVideoURLs;
  NSArray *_videoVersionDictionaries;
}
@property(readonly, nonatomic) NSSet *allVideoURLs;
@end

@interface IGImageURL: NSObject
@property (nonatomic, assign, readonly) NSURL *url;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
@end

@interface IGPhoto: NSObject
{
  NSArray *_originalImageVersions; // [IGImageURL]
}
@end

@interface IGPostItem: NSObject
@property(atomic, assign, readonly) IGVideo *video;
@property (atomic, assign, readonly) IGPhoto *photo;
@property (nonatomic, assign, readonly) NSInteger mediaType; // 1: photo, 2: video
@end

@interface IGMedia : NSObject
@property(atomic, assign, readonly) IGVideo *video;
@property (atomic, assign, readonly) IGPhoto *photo;
@property (atomic, strong, readwrite) NSArray *items; // [IGPostItem]
@property long long likeCount;
- (BOOL)isPhotoMedia;
@end

@interface IGSundialViewerUFIViewModel: NSObject
@property (nonatomic, copy, readonly) IGMedia *media;
@end

@interface IGSundialViewerVerticalUFI: UIView
@property (nonatomic, assign, readonly) UIButton *ufiLikeButton;
 - (void)downloadProgress:(float)progress;
 - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName;
 - (void)downloadDidFailureWithError:(NSError *)error;
@end
@interface IGSundialViewerVerticalUFI () <BHDownloadDelegate>
@end

@interface IGFeedItemUFICellConfigurableDelegateImpl: NSObject
@end

@interface IGFeedItemUFICell: UICollectionViewCell
@property (nonatomic, weak, readwrite) id delegate; // IGFeedItemUFICellConfigurableDelegateImpl
@property (nonatomic, assign, readonly) NSInteger pageControlCurrentPage;
@end

@interface IGUFIInteractionCountsView: UIView
@property (nonatomic, assign, readonly) UIButton *sendButton;
@property (nonatomic, weak, readwrite) id delegate; // IGFeedItemUFICell
- (void)setupBHInsta;
- (void)downloadProgress:(float)progress;
- (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName;
- (void)downloadDidFailureWithError:(NSError *)error;
@end
@interface IGUFIInteractionCountsView () <BHDownloadDelegate>
@end

@interface IGFeedItem : NSObject
@property long long likeCount;
@property(readonly) IGVideo *video;
- (BOOL)isSponsored;
- (BOOL)isSponsoredApp;
@end

@interface IGSundialViewerVideoCell: UIView
- (void)addHandleLongPress; // new
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender; // new
@property (nonatomic, strong) JGProgressHUD *hud;
@property(readonly, nonatomic) IGMedia *video;
@end
@interface IGSundialViewerVideoCell () <BHDownloadDelegate>
@end


/**
 * For download story photo/video
 */
@interface IGStoryViewerViewModel: NSObject
@end

@interface IGStoryViewerViewController : UIViewController
- (void)fullscreenSectionController:(id)arg1 didMarkItemAsSeen:(id)arg2;
@property (nonatomic, assign, readonly) IGStoryViewerViewModel *currentViewModel;
@end

@interface IGStoryFullscreenSectionController: NSObject
@property (nonatomic, strong, readwrite) IGStoryViewerViewModel *viewModel;
@property (nonatomic, strong, readwrite) id currentStoryItem;
@property (nonatomic, readwrite) id delegate; // <IGStoryViewerViewController: 0x10c321e00>
- (void)fullscreenOverlayDidTapNextStoryButton:(id)arg1;
- (void)fullscreenOverlay:(id)arg1 didLongPressWithGesture:(id)arg2;
- (void)fullscreenOverlayDidEndPressing:(id)arg1;
@end

@interface IGStoryFullscreenCell: UICollectionViewCell
@property (nonatomic, readwrite) id delegate; // <IGStoryFullscreenSectionController: 0x10c321e00>
- (void)setupBHInsta; // new
- (void)seenButtonPressed:(UIButton *)sender; // new
 - (void)downloadProgress:(float)progress;
 - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName;
 - (void)downloadDidFailureWithError:(NSError *)error;
@end
@interface IGStoryFullscreenCell () <BHDownloadDelegate>
@end

@interface IGDirectMessageKey: NSObject
@property (nonatomic, copy, readonly) NSString *serverId;
@end

@interface IGDirectUIMessageMetadata: NSObject
@property (nonatomic, assign, readonly) IGDirectMessageKey *key;
@end

@protocol IGDirectMessageViewModelProtocol <NSObject>
@property (nonatomic, readonly) IGDirectUIMessageMetadata *messageMetadata;
@end

@interface IGDirectMessageCell: UICollectionViewCell
@property (nonatomic, assign, readonly) UIView *contentViewForVisualMessageViewerPresentation;
@property (nonatomic, assign, readonly) id<IGDirectMessageViewModelProtocol> viewModel;
@end

@interface IGDirectMessageUpdateMessageKey: NSObject
@end

@interface IGDirectMessageUpdate: NSObject
@end

@interface IGDirectThreadUpdate: NSObject
@end


/**
 * For HD profile picture
 */
@interface IGUser : NSObject
@property NSInteger followStatus;
@property(copy) NSString *username;
@property BOOL followsCurrentUser;
@property NSString *biography;
- (NSURL *)HDProfilePicURL;
- (BOOL)isUser;
- (NSURL *)coverImageURL;
@end

@interface IGProfilePictureImageView : UIImageView
@property (nonatomic, assign, readonly) IGUser *user;
 - (void)downloadProgress:(float)progress;
 - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName;
 - (void)downloadDidFailureWithError:(NSError *)error;
 - (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end
@interface IGProfilePictureImageView () <BHDownloadDelegate>
@end

@interface IGFollowController : NSObject 
@property IGUser *user;
@end

@interface IGCoreTextView: UIView
@property(nonatomic, strong) NSString *text;
- (void)addHandleLongPress;
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender;
@end

@interface IGStyledString : NSObject
@property(retain, nonatomic) NSMutableAttributedString *attributedString;
- (void)appendString:(id)arg1;
@end

@interface IGInstagramAppDelegate : NSObject <UIApplicationDelegate>
@end

@interface IGProfileBioView : UIView {
  IGCoreTextView *_infoLabelView;
}
@end

@interface IGTabBarController : UIViewController
- (void)_superPresentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(id)completion;
@end

static BOOL is_iPad() {
    if ([(NSString *)[UIDevice currentDevice].model hasPrefix:@"iPad"]) {
        return YES;
    }
    return NO;
}

static UIViewController * _Nullable _topMostController(UIViewController * _Nonnull cont) {
    UIViewController *topController = cont;
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    if ([topController isKindOfClass:[UINavigationController class]]) {
        UIViewController *visible = ((UINavigationController *)topController).visibleViewController;
        if (visible) {
            topController = visible;
        }
    }
    return (topController != cont ? topController : nil);
}
static UIViewController * _Nonnull topMostController() {
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *next = nil;
    while ((next = _topMostController(topController)) != nil) {
        topController = next;
    }
    return topController;
}