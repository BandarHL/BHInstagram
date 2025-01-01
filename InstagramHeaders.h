#import <Foundation/Foundation.h>
#include <objc/NSObject.h>
#import <UIKit/UIKit.h>
#import "BHIManager.h"
#import "SettingsViewController.h"
#import "SecurityViewController.h"
#import "BHDownload.h"
#import "JGProgressHUD/JGProgressHUD.h"
#include "RemoteLog.h" // For debugging purposes : https://github.com/Muirey03/RemoteLog -- Remove If Not Needed

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
}
@property(readonly, nonatomic) NSSet *allVideoURLs;
@end

@interface IGMedia : NSObject
@property(readonly) IGVideo *video;
@property long long likeCount;
@end

@interface IGPhoto: NSObject
@end

@interface IGPostItem: NSObject
@property(readonly) IGVideo *video;
@property(readonly) IGPhoto *photo;
@end

@interface IGPageMediaView: UIView
@property(readonly) NSMutableArray <IGPostItem *> *items;
- (IGPostItem *)currentMediaItem;
@end

@interface IGFeedItem : NSObject
@property long long likeCount;
@property(readonly) IGVideo *video;
- (BOOL)isSponsored;
- (BOOL)isSponsoredApp;
@end

@interface IGImageView : UIImageView
@property(retain, nonatomic) IGImageSpecifier *imageSpecifier;
@end

@interface IGFeedItemPagePhotoCell: UICollectionViewCell
@property (nonatomic, strong) id post;
@end

@interface IGProfilePicturePreviewViewController: UIViewController
{
  IGImageView *_profilePictureView;
}
@property (nonatomic, strong) JGProgressHUD *hud;
- (void)addHandleLongPress; // new
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender; // new
@end
@interface IGProfilePicturePreviewViewController () <BHDownloadDelegate>
@end

@interface IGFeedItemMediaCell : UICollectionViewCell
@property(retain, nonatomic) IGMedia *post;
- (UIImage *)mediaCellCurrentlyDisplayedImage;
@end

@interface IGFeedItemPhotoCell: IGFeedItemMediaCell
@end

@interface IGFeedPhotoView: UIView
@property (nonatomic, strong) id delegate;
@property (nonatomic, strong) JGProgressHUD *hud;
@end
@interface IGFeedPhotoView () <BHDownloadDelegate>
@end

@interface IGSundialViewerVideoCell: UIView
- (void)addHandleLongPress; // new
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender; // new
@property (nonatomic, strong) JGProgressHUD *hud;
@property(readonly, nonatomic) IGMedia *video;
@end
@interface IGSundialViewerVideoCell () <BHDownloadDelegate>
@end

@interface IGModernFeedVideoCell : IGFeedItemMediaCell
- (void)addHandleLongPress; // new
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender; // new
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, strong) id delegate;
@end
@interface IGModernFeedVideoCell () <BHDownloadDelegate>
@end

@interface IGVideoPlayer : NSObject {
  IGVideo *_video;
}
@end


/**
 * For download story photo/video
 */
@protocol IGStoryPlayerMediaViewType
@end

@interface IGImageProgressView : UIView
@property(retain, nonatomic) IGImageSpecifier *imageSpecifier;
@end

@interface IGStoryPhotoView : UIView<IGStoryPlayerMediaViewType>
@property(retain, nonatomic) IGImageSpecifier *mediaViewLastLoadedImageSpecifier;
@property(readonly, nonatomic) IGImageProgressView *photoView;
@end

// @protocol IGFNFVideoPlayable
// @property (readonly, nonatomic) IGFNFVideoPlayer *videoPlayer;
// @end

@protocol IGVideoURLProvider
@end

@interface IGFNFVideoPlayer : NSObject
@property id<IGVideoURLProvider> video;
@end

@interface IGStatefulVideoPlayer : NSObject
@property IGFNFVideoPlayer *video;
@end
@protocol IGFNFVideoPlayable
@property (readonly, nonatomic) IGFNFVideoPlayer *videoPlayer;
@end
@interface IGStoryVideoView : UIView<IGStoryPlayerMediaViewType>
@property(nonatomic, strong, readwrite) id<IGFNFVideoPlayable> videoPlayer;
@end

@interface IGStoryFullscreenDefaultFooterView: UIView
@end

@interface IGStoryFullscreenFooterContainerView: UIView
@property(nonatomic) IGStoryFullscreenDefaultFooterView *defaultFooterView;
@end

@interface IGStoryFullscreenOverlayView: UIView
@property(retain, nonatomic) IGStoryFullscreenFooterContainerView *footerContainerView;
@end

@interface IGStoryFullscreenCell: UICollectionViewCell
@end
@protocol IGStoryItemType
@end
@protocol IGUnitltemInformationProviding
@end
@interface IGStoryViewerViewModel: NSObject
@end
@interface IGStoryViewerViewController : UIViewController
{
  // id <IGStoryItemType><IGUnitItemInformationProviding> _focusStoryItemOnEntry;
  IGStoryViewerViewModel *_focusedModelItem;
}
- (id)_getMostVisibleSectionController;
- (void)fullscreenSectionController:(id)arg1 didMarkItemAsSeen:(id)arg2;
- (id)currentStoryItem;
@property (nonatomic) UIView *contentViewForSnapshot;
@end

@protocol IGStoryFullScreenControllerTypeDelegate
@end
@interface IGStoryFullscreenSectionController: NSObject
@property (nonatomic, weak, readwrite) id<IGStoryFullScreenControllerTypeDelegate> delegate;
@end


@protocol IGStoryViewerContainerViewDelegate
@end

@interface IGStoryViewerContainerView: UIView
@property UIView *superview;
@property(retain, nonatomic) UIView<IGStoryPlayerMediaViewType> *mediaView;
@property(nonatomic) IGStoryFullscreenOverlayView *overlayView;
@property (nonatomic, weak, readwrite) id<IGStoryViewerContainerViewDelegate> delegate;
@property(nonatomic, retain) UIButton *hDownloadButton; // new property
@property(nonatomic, retain) UIButton *hSeenButton;
@property (nonatomic, strong) JGProgressHUD *hud;
@property (nonatomic, retain) NSString *fileextension;
- (void)hDownloadButtonPressed:(UIButton *)sender;
@end
@interface IGStoryViewerContainerView () <BHDownloadDelegate>
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

@end

@interface IGFollowController : NSObject 
@property IGUser *user;
@end

@interface IGCoreTextView: UIView
@property(nonatomic, strong) NSString *text;
- (void)addHandleLongPress; // new
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender; // new
@end

/**
 * Determine If User Is Following You
 */
@interface IGProfileBioModel
@property(readonly, copy, nonatomic) IGUser *user;
@end

@interface IGProfileViewController : UIViewController {
  IGProfileBioModel *_bioModel;
}
@end

@interface IGProfileSimpleAvatarStatsCell : UICollectionViewCell
@property(nonatomic, retain) UIView *isFollowingYouBadge; // new property
@property(nonatomic, retain) UILabel *isFollowingYouLabel; // new property
- (void)addIsFollowingYouBadgeView; // new
@end

@interface IGUserSession : NSObject
@property(readonly, nonatomic) IGUser *user;
@end

@interface IGWindow : UIWindow
@property(nonatomic) __weak IGUserSession *userSession;
@end

@interface IGShakeWindow : UIWindow
@property(nonatomic) __weak IGUserSession *userSession;
@end

@interface IGStyledString : NSObject
@property(retain, nonatomic) NSMutableAttributedString *attributedString;
- (void)appendString:(id)arg1;
@end

@interface IGInstagramAppDelegate : NSObject <UIApplicationDelegate>
@end

//
@interface IGProfileBioView : UIView {
  IGCoreTextView *_infoLabelView;
}
- (void)addHandleLongPress; // new
- (void)handleLongPress:(UILongPressGestureRecognizer *)sender; // new
@end

@interface IGTabBarController : UIViewController
- (void)_superPresentViewController:(UIViewController *)viewController animated:(BOOL)animated completion:(id)completion;
@end

@interface IGUFIInteractionCountsView : UIView 
@end

@interface IGStoryViewerCollectionView : UIView
@end
//

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