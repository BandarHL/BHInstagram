#import "InstagramHeaders.h"
#import <substrate.h>

static BOOL shouldBeSeen = false;
static BOOL seenButtonEnabled = false;

void createDirectoryIfNotExists(NSURL *URL) {
    if (![URL checkResourceIsReachableAndReturnError:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

static BOOL isNotch() {
  return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].bottom > 0;
}

static void showConfirmation(void (^okHandler)(void)) {
  UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
  [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    okHandler();
  }]];
  [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil]];

  [topMostController() presentViewController:alert animated:YES completion:nil];
}

static NSArray *removeAdsItemsInList(NSArray *list) {
  NSMutableArray *orig = [list mutableCopy];
  [orig enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {

    if ([BHIManager removeSuggestedPost]) {
      if ([obj respondsToSelector:@selector(explorePostInFeed)] && [obj performSelector:@selector(explorePostInFeed)]) {
        [orig removeObjectAtIndex:idx];
      }
    }

    if (([obj isKindOfClass:%c(IGFeedItem)] && ([obj isSponsored] || [obj isSponsoredApp])) || [obj isKindOfClass:%c(IGAdItem)]) {
      [orig removeObjectAtIndex:idx];
    }
  }];
  return [orig copy];
}

// App setup
%hook IGInstagramAppDelegate
- (_Bool)application:(UIApplication *)application didFinishLaunchingWithOptions:(id)arg2 {
    %orig;
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"BHInstaFirstRun"]) {
        [[NSUserDefaults standardUserDefaults] setValue:@"BHInstaFirstRun" forKey:@"BHInstaFirstRun"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"hide_ads"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"dw_videos"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"save_profile"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"remove_screenshot_alert"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"show_like_count"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"copy_description"];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"keep_deleted_message"];
    }
    [BHIManager cleanCache];
    return true;
}

static BOOL isAuthenticationShowed = FALSE;
- (void)applicationDidBecomeActive:(id)arg1 {
  %orig;

  if ([BHIManager Padlock] && !isAuthenticationShowed) {
    UIViewController *rootController = [[self window] rootViewController];
    SecurityViewController *securityViewController = [SecurityViewController new];
    securityViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
    [rootController presentViewController:securityViewController animated:YES completion:nil];
    isAuthenticationShowed = TRUE;
  }
}

- (void)applicationWillEnterForeground:(id)arg1 {
  %orig;
  isAuthenticationShowed = FALSE;
}
%end

// tweak settings

%hook IGTabBarController

-(void)_homeButtonLongPressed:(id)arg1 {
  UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
  [self presentViewController:navVC animated:true completion:nil];
}

%end




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
%hook IGDirectThreadViewListAdapterDataSource
- (BOOL)shouldUpdateLastSeenMessage {
  if ([BHIManager hideLastSeen]) {
    if (seenButtonEnabled) {
      return %orig;
    }
    return false;
  }
  return %orig;
}
%end
%hook IGDirectMessageMarkType
+ (id)visualItemScreenshotted {
  if ([BHIManager noScreenShotAlert]) {
    return nil;
  }
  return %orig;
}
%end
%hook IGStoryPhotoView
- (void)progressImageView:(id)arg1 didLoadImage:(id)arg2 loadSource:(id)arg3 networkRequestSummary:(id)arg4 {
  if ([BHIManager unlimtedReply]) {} else {
    return %orig;
  }
}
%end
%hook IGStoryViewerViewController
- (void)fullscreenSectionController:(id)arg1 didMarkItemAsSeen:(id)arg2 {
  if ([BHIManager noSeenReceipt]) {
    if (shouldBeSeen) {
      %orig;
      shouldBeSeen = false;
    }
  } else {
    return %orig;
  }
}
%end

// seen button
%hook IGTallNavigationBarView
- (void)setRightBarButtonItems:(NSArray <UIBarButtonItem *> *)items {
  NSMutableArray *new_items = [items mutableCopy];

  if ([BHIManager hideLastSeen]) {
    UIBarButtonItem *seenButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(seenButtonHandler:)];
    [new_items addObject:seenButton];

    if (seenButtonEnabled) {
      [seenButton setTintColor:UIColor.blueColor];
    } else {
      [seenButton setTintColor:UIColor.labelColor];
    }
  }

  %orig([new_items copy]);
}
%new - (void)seenButtonHandler:(UIBarButtonItem *)sender {
  if (seenButtonEnabled) {
    seenButtonEnabled = false;
    [sender setTintColor:UIColor.labelColor];
  } else {
    seenButtonEnabled = true;
    [sender setTintColor:UIColor.blueColor];
  }
}
%end

// copy text
%hook IGCoreTextView
- (id)initWithWidth:(CGFloat)width {
  self = %orig;
  if ([BHIManager copyDecription]) {
    [self addHandleLongPress];
  }
  return self;
}
%new - (void)addHandleLongPress {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  longPress.minimumPressDuration = 0.3;
  [self addGestureRecognizer:longPress];
}

%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;

  }
}
%end


// Copy Bio
%hook IGProfileBioView

- (id)initWithFrame:(CGRect)arg1 {
  self = %orig;
  if ([BHIManager copyBio]) {
    [self addHandleLongPress];
    
  }
  return self;
}

%new - (void)addHandleLongPress {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  longPress.minimumPressDuration = 0.3;
  [self addGestureRecognizer:longPress];
}

%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    IGCoreTextView* bioTextView = [self valueForKey:@"_infoLabelView"];
    NSString* bioText = bioTextView.text;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"BHInsta" preferredStyle:UIAlertControllerStyleAlert];
	  UIAlertAction* copyButton = [UIAlertAction actionWithTitle:@"Copy Bio" style:UIAlertActionStyleDefault
    handler:^(UIAlertAction * action) {

      UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
      pasteboard.string = bioText;
    }];
	  [alert addAction:copyButton];
    [topMostController() presentViewController:alert animated:YES completion:nil];
    

  }
}

%end

// Follow Confirm 

%hook IGFollowController
-(void)_didPressFollowButton {
	NSInteger UserFollowStatus = self.user.followStatus;
  if ([BHIManager followConfirmation]) {
      if (UserFollowStatus == 2){
        showConfirmation(^(void) { %orig; });
    }else {
        %orig;
      
    }
  }else {
    return %orig;
  }
	
}	
%end

// like confirm
%hook IGUFIInteractionCountsView
- (void)_onLikeButtonPressed:(id)arg1 {
  if ([BHIManager likeConfirmation]) {
    showConfirmation(^(void) { %orig; });
  } else {
    return %orig;
  }
}
%end
%hook IGFeedPhotoView
- (void)_onDoubleTap:(id)arg1 {
  if ([BHIManager likeConfirmation]) {
    showConfirmation(^(void) { %orig; });
  } else {
    return %orig;
  }
}
%end
%hook IGFeedItemVideoView
- (void)_handleOverlayDoubleTap {
  if ([BHIManager likeConfirmation]) {
    showConfirmation(^(void) { %orig; });
  } else {
    return %orig;
  }
}
%end
%hook IGSundialViewerVideoCell
- (void)_handleDoubleTap:(id)arg1 {
  if ([BHIManager likeConfirmation]) {
    showConfirmation(^(void) { %orig; });
  } else {
    return %orig;
  }
}
%end
%hook IGSundialViewerLikeButton
- (void)touchDetector:(id)arg1 touchesEnded:(id)arg2 withEvent:(id)arg3 {
  if ([BHIManager likeConfirmation]) {
    showConfirmation(^(void) { %orig; });
  } else {
    return %orig;
  }
}
%end
%hook IGCommentCell
- (void)_didDoubleTap:(id)arg1 {
  if ([BHIManager likeConfirmation]) {
    showConfirmation(^(void) { %orig; });
  } else {
    return %orig;
  }
}
- (void)contentView:(id)arg1 didTapOnLikeButton:(id)arg2 {
  if ([BHIManager likeConfirmation]) {
    showConfirmation(^(void) { %orig; });
  } else {
    return %orig;
  }
}
%end

// Like Confirm For Reels 
%hook IGSundialViewerVerticalUFI 
-(void)_didTapLikeButton:(id)arg1 {
	if ([BHIManager likeConfirmation]) {
    showConfirmation(^(void) { %orig; });
  } else {
    return %orig;
  }
}
%end



// Hide Ads
%hook IGMainFeedListAdapterDataSource
- (NSArray *)objectsForListAdapter:(id)arg1 {
  if ([BHIManager hideAds]) {
    return removeAdsItemsInList(%orig);
  }
  return %orig;
}
%end

%hook IGVideoFeedViewController
- (NSArray *)objectsForListAdapter:(id)arg1 {
  if ([BHIManager hideAds]) {
    return removeAdsItemsInList(%orig);
  }
  return %orig;
}
%end

%hook IGChainingFeedViewController
- (NSArray *)objectsForListAdapter:(id)arg1 {
  if ([BHIManager hideAds]) {
    return removeAdsItemsInList(%orig);
  }
  return %orig;
}
%end

%hook IGStoryAdPool
- (id)initWithUserSession:(id)arg1 {
  if ([BHIManager hideAds]) {
    return nil;
  }
  return %orig;
}
%end

%hook IGStoryAdsManager
- (id)initWithUserSession:(id)arg1 storyViewerLoggingContext:(id)arg2 storyFullscreenSectionLoggingContext:(id)arg3 viewController:(id)arg4 {
  if ([BHIManager hideAds]) {
    return nil;
  }
  return %orig;
}
%end

%hook IGStoryAdsFetcher
- (id)initWithUserSession:(id)arg1 delegate:(id)arg2 {
  if ([BHIManager hideAds]) {
    return nil;
  }
  return %orig;
}
%end

// IG 148.0
%hook IGStoryAdsResponseParser
- (id)parsedObjectFromResponse:(id)arg1 {
  if ([BHIManager hideAds]) {
    return nil;
  }
  return %orig;
}

- (id)initWithReelStore:(id)arg1 {
  if ([BHIManager hideAds]) {
    return nil;
  }
  return %orig;
}
%end

%hook IGStoryAdsOptInTextView
- (id)initWithBrandedContentStyledString:(id)arg1 sponsoredPostLabel:(id)arg2 {
  if ([BHIManager hideAds]) {
    return nil;
  }
  return %orig;
}
%end

%hook IGSundialAdsResponseParser
- (id)parsedObjectFromResponse:(id)arg1 {
  if ([BHIManager hideAds]) {
    return nil;
  }
  return %orig;
}

- (id)initWithMediaStore:(id)arg1 userStore:(id)arg2 {
  if ([BHIManager hideAds]) {
    return nil;
  }
  return %orig;
}
%end

// Save Media
%hook IGFeedPhotoView
%property (nonatomic, strong) JGProgressHUD *hud;
- (id)initWithFrame:(CGRect)arg1 {
  id orig = %orig;
  if ([BHIManager downloadVideos]) {
    [orig addHandleLongPress];
  }
  return orig;
}
%new - (void)addHandleLongPress {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  longPress.minimumPressDuration = 0.3;
  [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    if  ([self.delegate isKindOfClass:%c(IGFeedItemPhotoCell)]) {
      IGFeedItemPhotoCell *currentCell = self.delegate;
      UIImage *currentImage = [currentCell mediaCellCurrentlyDisplayedImage];
      [BHIManager showSaveVC:currentImage];
    } else if ([self.delegate isKindOfClass:%c(IGFeedItemPagePhotoCell)]) {
      IGFeedItemPagePhotoCell *currentCell = self.delegate;
      IGPostItem *currentPost = [currentCell post];

      NSSet <NSString *> *knownImageURLIdentifiers = [currentPost.photo valueForKey:@"_knownImageURLIdentifiers"];
      NSArray *knownImageURLIdentifiersArray = [knownImageURLIdentifiers allObjects];

      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta, Hi" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

      for (int i = 0; i < [knownImageURLIdentifiersArray count]; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download Image - link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          BHDownload *dwManager = [[BHDownload alloc] init];
          [dwManager downloadFileWithURL:[NSURL URLWithString:[knownImageURLIdentifiersArray objectAtIndex:i]]];
          [dwManager setDelegate:self];
          self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
          self.hud.textLabel.text = @"Downloading";
          [self.hud showInView:topMostController().view];
        }]];
      }

      [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
      [self.viewController presentViewController:alert animated:YES completion:nil];
    }
  }
}

%new - (void)downloadProgress:(float)progress {
    self.hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", NSUUID.UUID.UUIDString]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];

    [self.hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}
%end

%hook IGModernFeedVideoCell
%property (nonatomic, strong) JGProgressHUD *hud;
- (id)initWithFrame:(CGRect)arg1 {
  id orig = %orig;
  if ([BHIManager downloadVideos]) {
    [orig addHandleLongPress];
  }
  return orig;
}
%new - (void)addHandleLongPress {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  longPress.minimumPressDuration = 0.3;
  [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta, Hi" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
      if ([self.delegate isKindOfClass:%c(IGPageMediaView)]) {
        IGPageMediaView *mediaDelegate = self.delegate;
        IGPostItem *currentPost = [mediaDelegate currentMediaItem];
        NSArray *videoURLArray = [currentPost.video.allVideoURLs allObjects];
        
        for (int i = 0; i < [videoURLArray count]; i++) {
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download video - link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // [[[HDownloadMediaWithProgress alloc] init] checkPermissionToPhotosAndDownloadURL:[videoURLArray objectAtIndex:i] appendExtension:nil mediaType:Video toAlbum:@"Instagram" view:self];
                BHDownload *dwManager = [[BHDownload alloc] init];
                [dwManager downloadFileWithURL:[videoURLArray objectAtIndex:i]];
                [dwManager setDelegate:self];
                self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                self.hud.textLabel.text = @"Downloading";
                [self.hud showInView:topMostController().view];
            }]];
        }

        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self.viewController presentViewController:alert animated:YES completion:nil];
      } else if ([self.delegate isKindOfClass:%c(IGFeedSectionController)]) {
        NSArray *videoURLArray = [self.post.video.allVideoURLs allObjects];
        
        for (int i = 0; i < [videoURLArray count]; i++) {
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download video - link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // [[[HDownloadMediaWithProgress alloc] init] checkPermissionToPhotosAndDownloadURL:[videoURLArray objectAtIndex:i] appendExtension:nil mediaType:Video toAlbum:@"Instagram" view:self];
                BHDownload *dwManager = [[BHDownload alloc] init];
                [dwManager downloadFileWithURL:[videoURLArray objectAtIndex:i]];
                [dwManager setDelegate:self];
                self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                self.hud.textLabel.text = @"Downloading";
                [self.hud showInView:topMostController().view];
            }]];
        }

        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self.viewController presentViewController:alert animated:YES completion:nil];
      }
  }
}

%new - (void)downloadProgress:(float)progress {
    self.hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", NSUUID.UUID.UUIDString]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];

    [self.hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}
%end

%hook IGSundialViewerVideoCell
%property (nonatomic, strong) JGProgressHUD *hud;
- (id)initWithFrame:(CGRect)arg1 {
  id orig = %orig;
  if ([BHIManager downloadVideos]) {
    [orig addHandleLongPress];
  }
  return orig;
}
%new - (void)addHandleLongPress {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  longPress.minimumPressDuration = 0.3;
  [self addGestureRecognizer:longPress];
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
      UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta, Hi" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
      NSArray *videoURLArray = [self.video.video.allVideoURLs allObjects];
      
      for (int i = 0; i < [videoURLArray count]; i++) {
          [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download video - link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
              // [[[HDownloadMediaWithProgress alloc] init] checkPermissionToPhotosAndDownloadURL:[videoURLArray objectAtIndex:i] appendExtension:nil mediaType:Video toAlbum:@"Instagram" view:self];
              BHDownload *dwManager = [[BHDownload alloc] init];
              [dwManager downloadFileWithURL:[videoURLArray objectAtIndex:i]];
              [dwManager setDelegate:self];
              self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
              self.hud.textLabel.text = @"Downloading";
              [self.hud showInView:topMostController().view];
          }]];
      }

      [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
      [self.viewController presentViewController:alert animated:YES completion:nil];
  }
}

%new - (void)downloadProgress:(float)progress {
    self.hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.mp4", NSUUID.UUID.UUIDString]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];

    [self.hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}
%end

%hook IGStoryViewerContainerView
%property (nonatomic, strong) JGProgressHUD *hud;
%property (nonatomic, retain) UIButton *hDownloadButton;
%property (nonatomic, retain) NSString *fileextension;
- (id)initWithFrame:(CGRect)arg1 shouldCreateComposerBackgroundView:(BOOL)arg2 userSession:(id)arg3 bloksContext:(id)arg4 {
  self = %orig;
  if ([BHIManager downloadVideos]) {
    self.hDownloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.hDownloadButton addTarget:self action:@selector(hDownloadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.hDownloadButton setImage:[UIImage systemImageNamed:@"arrow.down"] forState:UIControlStateNormal];
    [self.hDownloadButton setTranslatesAutoresizingMaskIntoConstraints:false];

    [self addSubview:self.hDownloadButton];
    [NSLayoutConstraint activateConstraints:@[
      [self.hDownloadButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:(self.frame.size.height - (isNotch() ? 120.0 : 90.0))],
      [self.hDownloadButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
      [self.hDownloadButton.widthAnchor constraintEqualToConstant:50],
      [self.hDownloadButton.heightAnchor constraintEqualToConstant:50],
    ]];
  }

  return self;
}
%new - (void)hDownloadButtonPressed:(UIButton *)sender {
  UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta, Hi" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

  if ([self.mediaView isKindOfClass:%c(IGStoryPhotoView)]) {
    NSURL *url = ((IGStoryPhotoView *)self.mediaView).photoView.imageSpecifier.url;
    self.fileextension = @"png";

    [alert addAction:[UIAlertAction actionWithTitle:@"Download Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      BHDownload *dwManager = [[BHDownload alloc] init];
      [dwManager downloadFileWithURL:url];
      [dwManager setDelegate:self];

      self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
      self.hud.textLabel.text = @"Downloading";
      [self.hud showInView:topMostController().view];
    }]];
  } else if ([self.mediaView isKindOfClass:%c(IGStoryVideoView)]) {
      IGVideo *_video = [((IGStoryVideoView *)self.mediaView).videoPlayer valueForKey:@"_video"];
      self.fileextension = @"mp4";
      NSArray *videoURLArray = [_video.allVideoURLs allObjects];

      for (int i = 0; i < [videoURLArray count]; i++) {
        [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download video - link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
          BHDownload *dwManager = [[BHDownload alloc] init];
          [dwManager downloadFileWithURL:[videoURLArray objectAtIndex:i]];
          [dwManager setDelegate:self];
          self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
          self.hud.textLabel.text = @"Downloading";
          [self.hud showInView:topMostController().view];
        }]];
    }
  }

  if (self.delegate != nil) {
    [alert addAction:[UIAlertAction actionWithTitle:@"Mark as Seen" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      shouldBeSeen = true;
      if ([self.delegate isKindOfClass:%c(IGStoryFullscreenSectionController)]) {
        IGStoryFullscreenSectionController *storyController = self.delegate;
        if ([storyController.delegate isKindOfClass:%c(IGStoryViewerViewController)]) {
          IGStoryViewerViewController *storyViewController = storyController.delegate;
          id currentItem = [storyViewController valueForKey:@"_focusStoryItemOnEntry"];
          [storyViewController fullscreenSectionController:[storyViewController _getMostVisibleSectionController] didMarkItemAsSeen:currentItem];
        }
      }
    }]];
  }
  [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
  [self.viewController presentViewController:alert animated:YES completion:nil];
}
%new - (void)downloadProgress:(float)progress {
    self.hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", NSUUID.UUID.UUIDString, self.fileextension]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];

    [self.hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}
%end

// Show Profile image
%hook IGProfilePicturePreviewViewController
%property (nonatomic, strong) JGProgressHUD *hud;
- (void)viewDidLoad {
  %orig;
  if ([BHIManager profileImageSave]) {
    [self addHandleLongPress];
  }
}
%new - (void)addHandleLongPress {
  UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
  longPress.minimumPressDuration = 0.3;
  [self.view addGestureRecognizer:longPress];
}

%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
  if (sender.state == UIGestureRecognizerStateBegan) {
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"BHInsta, Hi" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    IGImageView *profilePictureView = [self valueForKey:@"_profilePictureView"];
    NSURL *url = profilePictureView.imageSpecifier.url;

    [alert addAction:[UIAlertAction actionWithTitle:@"Download HD Profile Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      BHDownload *dwManager = [[BHDownload alloc] init];
      [dwManager downloadFileWithURL:url];
      [dwManager setDelegate:self];

      self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
      self.hud.textLabel.text = @"Downloading";
      [self.hud showInView:topMostController().view];
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
  }
}

%new - (void)downloadProgress:(float)progress {
    self.hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", NSUUID.UUID.UUIDString]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];

    [self.hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}
%end

// show like count
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

// for instagram v178.0
%hook IGFeedItemLikeCountCell
+ (IGStyledString *)buildStyledStringWithMedia:(IGMedia *)arg1 feedItemRow:(id)arg2 pageCellState:(id)arg3 configuration:(id)arg4 feedConfiguration:(id)arg5 contentWidth:(double)arg6 textWidth:(double)arg7 combinedContextOptions:(long long)arg8 userSession:(id)arg9 {
  IGStyledString *orig = %orig;
  if ([BHIManager showLikeCount]) {
      if (orig != nil
      && orig.attributedString != nil
      && orig.attributedString.string != nil
      && ![orig.attributedString.string containsString:@"("]
      && ![orig.attributedString.string containsString:@")"]) {
        NSNumberFormatter *formatter = [NSNumberFormatter new];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        NSString *formatted = [formatter stringFromNumber:[NSNumber numberWithInteger:arg1.likeCount]];
        [orig appendString:[NSString stringWithFormat:@" (%@)", formatted]];
    }
  }

  return orig;
}
%end

%hook HBForceCepheiPrefs
+ (BOOL)forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear {
    return YES;
}
%end


// Enable all these lines of code if you want to compile for sideload
// NSString *keychainAccessGroup;
// NSURL *fakeGroupContainerURL;

// void loadKeychainAccessGroup() {
// 	NSDictionary* dummyItem = @{
// 		(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
// 		(__bridge id)kSecAttrAccount : @"dummyItem",
// 		(__bridge id)kSecAttrService : @"dummyService",
// 		(__bridge id)kSecReturnAttributes : @YES,
// 	};

// 	CFTypeRef result;
// 	OSStatus ret = SecItemCopyMatching((__bridge CFDictionaryRef)dummyItem, &result);
//     if (ret == -25300) {
// 		ret = SecItemAdd((__bridge CFDictionaryRef)dummyItem, &result);
// 	}

// 	if (ret == 0 && result) {
// 		NSDictionary* resultDict = (__bridge id)result;
// 		keychainAccessGroup = resultDict[(__bridge id)kSecAttrAccessGroup];
// 		NSLog(@"loaded keychainAccessGroup: %@", keychainAccessGroup);
// 	}
// }

// %hook NSFileManager
// - (NSURL *)containerURLForSecurityApplicationGroupIdentifier:(NSString*)groupIdentifier {
// 	NSURL *fakeURL = [fakeGroupContainerURL URLByAppendingPathComponent:groupIdentifier];
// 	createDirectoryIfNotExists(fakeURL);
// 	createDirectoryIfNotExists([fakeURL URLByAppendingPathComponent:@"Library"]);
// 	createDirectoryIfNotExists([fakeURL URLByAppendingPathComponent:@"Library/Caches"]);

// 	return fakeURL;
// }
// %end

// %hook FBSDKKeychainStore
// - (NSString*)accessGroup{
// 	return keychainAccessGroup;
// }
// %end

// %hook FBKeychainItemController
// - (NSString*)accessGroup {
// 	return keychainAccessGroup;
// }
// %end

// %hook UICKeyChainStore
// - (NSString*)accessGroup {
// 	return keychainAccessGroup;
// }
// %end

%ctor {
	// fakeGroupContainerURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FakeGroupContainers"] isDirectory:YES];
	// loadKeychainAccessGroup();

  %init;
}