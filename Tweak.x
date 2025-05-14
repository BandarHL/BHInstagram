#import "InstagramHeaders.h"
#import <substrate.h>

static BOOL shouldBeSeen = false;
static JGProgressHUD *hud;
static NSString *fileExtension;
static BOOL seenButtonEnabled() {
    return [[NSUserDefaults standardUserDefaults] boolForKey:@"seenButtonEnabled"];
}

void createDirectoryIfNotExists(NSURL *URL) {
    if (![URL checkResourceIsReachableAndReturnError:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

static BOOL isNotch() {
    return [[[UIApplication sharedApplication] keyWindow] safeAreaInsets].bottom > 0;
}

static UIAlertController * _Nonnull showDownloadMediaAlert(IGMedia *media,
                                                           id<BHDownloadDelegate> delegate,
                                                           NSInteger currentMediaIndex) {
    hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta, Hi" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    if (media.items.count > 1) {
        if (currentMediaIndex >= 0 && currentMediaIndex < media.items.count) {
            id object = media.items[currentMediaIndex];
            if (![object isKindOfClass:%c(IGPostItem)]) return nil;
            IGPostItem *postItem = object;
            if (postItem.mediaType == 1) {
                IGPhoto *photo = postItem.photo;
                if (![photo valueForKey:@"_originalImageVersions"]) return nil;
                NSArray *originalImageVersions = [photo valueForKey:@"_originalImageVersions"];
                for (id imageVersion in originalImageVersions) {
                    if (![imageVersion isKindOfClass:%c(IGImageURL)]) return nil;
                    IGImageURL *imageURL = imageVersion;
                    fileExtension = @"png";
                    CGFloat width = imageURL.width;
                    CGFloat height = imageURL.height;
                    
                    [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download photo - %dx%d",
                                                                     (int)width,
                                                                     (int)height] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        BHDownload *dwManager = [[BHDownload alloc] init];
                        [dwManager downloadFileWithURL:imageURL.url];
                        [dwManager setDelegate:delegate];
                        hud.textLabel.text = @"Downloading";
                        [hud showInView:topMostController().view];
                    }]];
                }
            }
            if (postItem.mediaType == 2) {
                IGVideo *video = postItem.video;
                if (![video valueForKey:@"_videoVersionDictionaries"]) return nil;
                NSArray *videoVersionDictionaries = [video valueForKey:@"_videoVersionDictionaries"];
                for (NSDictionary *videoVersion in videoVersionDictionaries) {
                    fileExtension = @"mp4";
                    NSInteger width = [videoVersion[@"width"] integerValue];
                    NSInteger height = [videoVersion[@"height"] integerValue];
                    NSURL *url = [NSURL URLWithString:videoVersion[@"url"]];
                    
                    [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download video - %ldx%ld",
                                                                     (long)width,
                                                                     (long)height] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                        BHDownload *dwManager = [[BHDownload alloc] init];
                        [dwManager downloadFileWithURL:url];
                        [dwManager setDelegate:delegate];
                        hud.textLabel.text = @"Downloading";
                        [hud showInView:topMostController().view];
                    }]];
                }
            }
        }
    } else {
        if ([media isPhotoMedia]) {
            IGPhoto *photo = media.photo;
            if (![photo valueForKey:@"_originalImageVersions"]) return nil;
            NSArray *originalImageVersions = [photo valueForKey:@"_originalImageVersions"];
            for (id imageVersion in originalImageVersions) {
                if (![imageVersion isKindOfClass:%c(IGImageURL)]) return nil;
                IGImageURL *imageURL = imageVersion;
                fileExtension = @"png";
                CGFloat width = imageURL.width;
                CGFloat height = imageURL.height;
                
                [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download photo - %dx%d",
                                                                 (int)width,
                                                                 (int)height] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    BHDownload *dwManager = [[BHDownload alloc] init];
                    [dwManager downloadFileWithURL:imageURL.url];
                    [dwManager setDelegate:delegate];
                    hud.textLabel.text = @"Downloading";
                    [hud showInView:topMostController().view];
                }]];
            }
        } else {
            IGVideo *video = media.video;
            if (![video valueForKey:@"_videoVersionDictionaries"]) return nil;
            NSArray *videoVersionDictionaries = [video valueForKey:@"_videoVersionDictionaries"];
            for (NSDictionary *videoVersion in videoVersionDictionaries) {
                fileExtension = @"mp4";
                NSInteger width = [videoVersion[@"width"] integerValue];
                NSInteger height = [videoVersion[@"height"] integerValue];
                NSURL *url = [NSURL URLWithString:videoVersion[@"url"]];
                
                [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download video - %ldx%ld",
                                                                 (long)width,
                                                                 (long)height] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    BHDownload *dwManager = [[BHDownload alloc] init];
                    [dwManager downloadFileWithURL:url];
                    [dwManager setDelegate:delegate];
                    hud.textLabel.text = @"Downloading";
                    [hud showInView:topMostController().view];
                }]];
            }
        }
    }
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}

static UIAlertController * _Nonnull showDownloadProfilePictureImage(IGUser *user, id<BHDownloadDelegate> delegate) {
    hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta, Hi" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Download profile picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        NSURL *url = [user HDProfilePicURL];
        BHDownload *dwManager = [[BHDownload alloc] init];
        [dwManager downloadFileWithURL:url];
        [dwManager setDelegate:delegate];
        hud.textLabel.text = @"Downloading";
        [hud showInView:topMostController().view];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    return alert;
}
static void showConfirmation(void (^okHandler)(void)) {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        okHandler();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:nil]];
    
    [topMostController() presentViewController:alert animated:YES completion:nil];
}

static NSArray *removeAdsItemsInList(NSArray *list) {
    NSMutableArray *orig = [list mutableCopy];
    [orig enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj,
                                                                        NSUInteger idx,
                                                                        BOOL *stop) {
        
        if ([BHIManager removeSuggestedPost]) {
            if ([obj respondsToSelector:@selector(explorePostInFeed)] && [obj performSelector:@selector(explorePostInFeed)]) {
                [orig removeObjectAtIndex:idx];
            }
        }
        
        if (([obj isKindOfClass:%c(IGFeedItem)] && ([obj isSponsored] || [obj isSponsoredApp])) || [obj isKindOfClass:%c(IGAdItem)] || [obj isKindOfClass:%c(IGSundialViewerVideoCell)] || [obj isKindOfClass:%c(IGSundialAdsMultiAdsCell)] || [obj isKindOfClass:%c(IGSundialAdsVideoCell)]) {
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
%hook IGProfileNavigationItemsController
- (void)_onSideTrayButton:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"Which settings you want?" preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Instagram settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        %orig;
    }]];

    [alert addAction:[UIAlertAction actionWithTitle:@"BHInstagram settings" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
        [topMostController() presentViewController:navVC animated:YES completion:nil];
    }]];
    
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    [topMostController() presentViewController:alert animated:YES completion:nil];
}
%end

%hook IGTabBarController
- (void)_homeButtonLongPressed:(id)arg1 {
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
    [Vibration vibrateWithType:VibrationTypeSuccess];
    [self presentViewController:navVC animated:true completion:nil];
}
%end

%hook IGDirectMessageCell
- (void)configureWithViewModel:(id)viewModel ringViewSpecFactory:(id)specFactory launcherSet:(id)launcher {
    %orig(viewModel, specFactory, launcher);
    
    if (![viewModel conformsToProtocol:@protocol(IGDirectMessageViewModelProtocol)]) return;
    IGDirectUIMessageMetadata *metadata = [(id<IGDirectMessageViewModelProtocol>)viewModel messageMetadata];
    NSString *serverId = metadata.key.serverId;
    
    if ([[DeletedMessagesManager sharedManager] messageExistsWithID:serverId]) {
        UIButton *deletedButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [deletedButton setImage:[UIImage systemImageNamed:@"trash.circle"] forState:UIControlStateNormal];
        [deletedButton setTintColor:UIColor.systemRedColor];
        [deletedButton setTranslatesAutoresizingMaskIntoConstraints:false];
        [self.contentView addSubview:deletedButton];
        
        [NSLayoutConstraint activateConstraints:@[
            [deletedButton.centerYAnchor constraintEqualToAnchor:self.contentViewForVisualMessageViewerPresentation.centerYAnchor],
            [deletedButton.leadingAnchor constraintEqualToAnchor:self.contentViewForVisualMessageViewerPresentation.trailingAnchor constant:8],
            [deletedButton.widthAnchor constraintEqualToConstant:20],
            [deletedButton.heightAnchor constraintEqualToConstant:20],
        ]];
        
        [deletedButton addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
            NSString *deletedMessageDate = [[DeletedMessagesManager sharedManager] dateForDeletedMessageWithID:serverId];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta, Hi" message:[NSString stringWithFormat:@"Message deleted at: %@",
                                                                                                           deletedMessageDate] preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
            [topMostController() presentViewController:alert animated:YES completion:nil];
        }] forControlEvents:UIControlEventTouchUpInside];
    }
}
%end

%hook IGDirectCache
- (void)_applyThreadUpdates:(NSArray *)updates toThreadWithId:(NSString *)threadId mutationId:(NSString *)mutationId sequenceId:(NSString *)sequenceId {
    if (![BHIManager keepDeletedMessage]) return %orig(updates,
                                                       threadId,
                                                       mutationId,
                                                       sequenceId);
    
    for (id update in updates) {
        if (![update isKindOfClass:%c(IGDirectThreadUpdate)]) return %orig(updates,
                                                                           threadId,
                                                                           mutationId,
                                                                           sequenceId);
        IGDirectThreadUpdate *threadUpdate = update;
        
        if (![threadUpdate valueForKey:@"_messageUpdate"]) return %orig(updates,
                                                                        threadId,
                                                                        mutationId,
                                                                        sequenceId);
        IGDirectMessageUpdate *messageUpdate = [threadUpdate valueForKey:@"_messageUpdate"];
        
        if (![messageUpdate valueForKey:@"_removeMessages_messageKeys"]) return %orig(updates,
                                                                                      threadId,
                                                                                      mutationId,
                                                                                      sequenceId);
        NSArray *removeMessages_messageKeys = [messageUpdate valueForKey:@"_removeMessages_messageKeys"];
        
        if (removeMessages_messageKeys.count == 0) return %orig(updates,
                                                                threadId,
                                                                mutationId,
                                                                sequenceId);
        
        for (id messageKey in removeMessages_messageKeys) {
            if (![messageKey isKindOfClass:%c(IGDirectMessageUpdateMessageKey)]) return %orig(updates,
                                                                                              threadId,
                                                                                              mutationId,
                                                                                              sequenceId);
            IGDirectMessageUpdateMessageKey *updateKey = messageKey;
            
            if (![updateKey valueForKey:@"_messageServerId"]) return %orig(updates,
                                                                           threadId,
                                                                           mutationId,
                                                                           sequenceId);
            
            NSString *MsgKey = [updateKey valueForKey:@"_messageServerId"];
            [[DeletedMessagesManager sharedManager] saveDeletedMessageWithID:MsgKey];
            return %orig(NULL, threadId, mutationId, sequenceId);
        }
    }
    return %orig(updates, threadId, mutationId, sequenceId);
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
        if (!seenButtonEnabled()) {
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

// seen button
%hook IGTallNavigationBarView
- (void)setRightBarButtonItems:(NSArray <UIBarButtonItem *> *)items {
    NSMutableArray *new_items = [items mutableCopy];
    
    if ([BHIManager hideLastSeen]) {
        UIBarButtonItem *seenButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"eye.fill"] style:UIBarButtonItemStylePlain target:self action:@selector(seenButtonHandler:)];
        [new_items addObject:seenButton];
        
        if (seenButtonEnabled()) {
            [seenButton setImage:[UIImage systemImageNamed:@"eye.slash.fill"]];
        } else {
            [seenButton setImage:[UIImage systemImageNamed:@"eye.fill"]];
        }
    }
    
    %orig([new_items copy]);
}
%new - (void)seenButtonHandler:(UIBarButtonItem *)sender {
    if (seenButtonEnabled()) {
        [sender setImage:[UIImage systemImageNamed:@"eye.fill"]];
        [[NSUserDefaults standardUserDefaults] setBool:false forKey:@"seenButtonEnabled"];
    } else {
        [sender setImage:[UIImage systemImageNamed:@"eye.slash.fill"]];
        [[NSUserDefaults standardUserDefaults] setBool:true forKey:@"seenButtonEnabled"];
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
- (void)_handleLongPressOnBio:(UILongPressGestureRecognizer *)arg1 {
    %orig(arg1);
    if (arg1.state == UIGestureRecognizerStateBegan) {
        IGCoreTextView *bioTextView = [self valueForKey:@"_infoLabelView"];
        NSString *bioText = bioTextView.text;
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        [Vibration vibrateWithType:VibrationTypeSuccess];
        pasteboard.string = bioText;
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

%hook IGListAdapter
- (void)setRegisteredCellIdentifiers:(NSArray *)cellIdentifiers {
    NSArray *filteredIdentifiers = removeAdsItemsInList(cellIdentifiers);
    %orig(filteredIdentifiers);
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
%hook IGUFIInteractionCountsView
- (void)layoutSubviews {
    %orig;
    if ([BHIManager downloadVideos]) {
        [self setupBHInsta];
    }
}
%new - (void)setupBHInsta {
    // Prevent duplicate buttons by checking if it already exists
    if ([self viewWithTag:999] != nil) {
        return;
    }
    
    if (![self valueForKey:@"_sendView"]) return;
    UIView *sendView = [self valueForKey:@"_sendView"];
    
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    downloadButton.tag = 999;
    [downloadButton setTintColor:UIColor.labelColor];
    [downloadButton setImage:[UIImage systemImageNamed:@"arrow.down"] forState:UIControlStateNormal];
    downloadButton.layer.shadowColor = [UIColor blackColor].CGColor;
    downloadButton.layer.shadowOpacity = 0.4;
    downloadButton.layer.shadowOffset = CGSizeMake(-2, 0);
    downloadButton.layer.shadowRadius = 3;
    downloadButton.layer.masksToBounds = NO;
    [downloadButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    [downloadButton addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        if (![self.delegate isKindOfClass:%c(IGFeedItemUFICell)]) return;
        IGFeedItemUFICell *cell = self.delegate;
        if (![cell.delegate isKindOfClass:%c(IGFeedItemUFICellConfigurableDelegateImpl)]) return;
        IGFeedItemUFICellConfigurableDelegateImpl *delegateImpl = cell.delegate;
        if (![delegateImpl valueForKey:@"_media"]) return;
        IGMedia *currentMedia = [delegateImpl valueForKey:@"_media"];
        UIAlertController *alert = showDownloadMediaAlert(currentMedia, self, cell.pageControlCurrentPage);
        [topMostController() presentViewController:alert animated:YES completion:nil];
    }] forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:downloadButton];
    [NSLayoutConstraint activateConstraints:@[
        [downloadButton.topAnchor constraintEqualToAnchor:self.sendButton.topAnchor],
        [downloadButton.leadingAnchor constraintEqualToAnchor:sendView.trailingAnchor],
        [downloadButton.widthAnchor constraintEqualToConstant:40],
        [downloadButton.heightAnchor constraintEqualToConstant:40]
    ]];
}
%new - (void)downloadProgress:(float)progress {
    hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",
                                                                                       NSUUID.UUID.UUIDString,
                                                                                       fileExtension]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];
    
    [hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [hud dismiss];
    }
}
%end

%hook IGSundialViewerVerticalUFI
- (void)configureWithViewModel:(IGSundialViewerUFIViewModel *)viewModel {
    %orig;
    if ([BHIManager downloadVideos]) {
        [self setupBHInsta];
    }
}
%new - (void)setupBHInsta {
    // Prevent duplicate buttons by checking if it already exists
    if ([self viewWithTag:999] != nil) {
        return;
    }

    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    downloadButton.tag = 999;
    [downloadButton setTintColor:UIColor.labelColor];
    [downloadButton setImage:[UIImage systemImageNamed:@"arrow.down"] forState:UIControlStateNormal];
    [downloadButton setTranslatesAutoresizingMaskIntoConstraints:false];
    downloadButton.layer.shadowColor = [UIColor blackColor].CGColor;
    downloadButton.layer.shadowOpacity = 0.4;
    downloadButton.layer.shadowOffset = CGSizeMake(-2, 0);
    downloadButton.layer.shadowRadius = 3;
    downloadButton.layer.masksToBounds = NO;

    [downloadButton addAction:[UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        if ([self.delegate isKindOfClass:%c(IGSundialViewerControlsOverlayView)]) {
            IGSundialViewerControlsOverlayView *delegate = self.delegate;
            UIAlertController *alert = showDownloadMediaAlert(delegate.media, self, 0);
            [topMostController() presentViewController:alert animated:YES completion:nil];
        } else if ([self.delegate isKindOfClass:%c(_TtC30IGSundialViewerControlsOverlay40IGSundialViewerModernControlsOverlayView)]) {
            _TtC30IGSundialViewerControlsOverlay40IGSundialViewerModernControlsOverlayView *delegate = self.delegate;
            UIAlertController *alert = showDownloadMediaAlert(delegate.media, self, 0);
            [topMostController() presentViewController:alert animated:YES completion:nil];
        }
    }] forControlEvents:UIControlEventTouchUpInside];


        [self addSubview:downloadButton];
        [self addSubview:downloadButton];
        
    [self addSubview:downloadButton];
        
    [NSLayoutConstraint activateConstraints:@[
        [downloadButton.centerXAnchor constraintEqualToAnchor:self.centerXAnchor],
        [downloadButton.bottomAnchor constraintEqualToAnchor:self.ufiLikeButton.topAnchor],
        [downloadButton.widthAnchor constraintEqualToConstant:44],
        [downloadButton.heightAnchor constraintEqualToConstant:44],
    ]];
}
%new - (void)downloadProgress:(float)progress {
    hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",
                                                                                       NSUUID.UUID.UUIDString,
                                                                                       fileExtension]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];
    
    [hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [hud dismiss];
    }
}
%end


%hook IGStoryFullscreenSectionController
- (void)advanceToNextItemWithNavigationAction:(NSInteger)arg1 {
    if (arg1 == 5 && [BHIManager disableAutoAdvance]) {
        return;
    }
    
    return %orig;
}
%end

%hook IGStoryFullscreenCell
- (id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    [self setupBHInsta];
    return orig;
}
%new - (void)setupBHInsta {
    UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [downloadButton setTintColor:UIColor.labelColor];
    [downloadButton setImage:[UIImage systemImageNamed:@"arrow.down"] forState:UIControlStateNormal];
    downloadButton.layer.shadowColor = [UIColor blackColor].CGColor;
    downloadButton.layer.shadowOpacity = 0.4;
    downloadButton.layer.shadowOffset = CGSizeMake(-2, 0);
    downloadButton.layer.shadowRadius = 3;
    downloadButton.layer.masksToBounds = NO;
    [downloadButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    UIButton *seenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [seenButton addTarget:self action:@selector(seenButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
    [seenButton setTintColor:UIColor.labelColor];
    [seenButton setImage:[UIImage systemImageNamed:@"eye"] forState:UIControlStateNormal];
    seenButton.layer.shadowColor = [UIColor blackColor].CGColor;
    seenButton.layer.shadowOpacity = 0.4;
    seenButton.layer.shadowOffset = CGSizeMake(-2, 0);
    seenButton.layer.shadowRadius = 3;
    seenButton.layer.masksToBounds = NO;
    [seenButton setTranslatesAutoresizingMaskIntoConstraints:false];
    
    if ([BHIManager downloadVideos]) {
        [self addSubview:downloadButton];
        [NSLayoutConstraint activateConstraints:@[
            [downloadButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-105],
            [downloadButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor constant:-8],
            [downloadButton.widthAnchor constraintEqualToConstant:30],
            [downloadButton.heightAnchor constraintEqualToConstant:30]
        ]];
    }
    if ([BHIManager noSeenReceipt]) {
        [self addSubview:seenButton];
        [NSLayoutConstraint activateConstraints:@[
            [seenButton.bottomAnchor constraintEqualToAnchor:self.bottomAnchor constant:-105],
            [seenButton.trailingAnchor constraintEqualToAnchor:downloadButton.leadingAnchor constant:-20],
            [seenButton.widthAnchor constraintEqualToConstant:30],
            [seenButton.heightAnchor constraintEqualToConstant:30],
        ]];
    }
    
    UIAction *downloadAction = [UIAction actionWithHandler:^(__kindof UIAction * _Nonnull action) {
        if (![self.delegate isKindOfClass:%c(IGStoryFullscreenSectionController)]) return;
        IGStoryFullscreenSectionController *firstDelegate = self.delegate;
        [firstDelegate fullscreenOverlay:nil didLongPressWithGesture:nil];
        if (![firstDelegate.currentStoryItem isKindOfClass:%c(IGMedia)]) return;
        IGMedia *currentMedia = firstDelegate.currentStoryItem;
        
        UIAlertController *alert = showDownloadMediaAlert(currentMedia, self, 0);
        [topMostController() presentViewController:alert animated:YES completion:nil];
    }];
    [downloadButton addAction:downloadAction forControlEvents:UIControlEventTouchUpInside];
}

%new - (void)seenButtonPressed:(UIButton *)sender {
    if (![self.delegate isKindOfClass:%c(IGStoryFullscreenSectionController)]) return;
    IGStoryFullscreenSectionController *firstDelegate = self.delegate;
    if (![firstDelegate.delegate isKindOfClass:%c(IGStoryViewerViewController)]) return;
    IGStoryViewerViewController *secondDelegate = firstDelegate.delegate;
    
    [Vibration vibrateWithType:VibrationTypeSuccess];
    shouldBeSeen = true;
    [secondDelegate fullscreenSectionController:firstDelegate didMarkItemAsSeen:[firstDelegate currentStoryItem]];
    [firstDelegate fullscreenOverlayDidTapNextStoryButton:nil];
}

%new - (void)downloadProgress:(float)progress {
    hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                            NSUserDomainMask,
                                                            true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@",
                                                                                       NSUUID.UUID.UUIDString,
                                                                                       fileExtension]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];
    
    [hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [hud dismiss];
    }
}
%end

%hook IGStoryViewerViewController
- (void)fullscreenSectionController:(id)arg1 didMarkItemAsSeen:(id)arg2 {
    if (![BHIManager noSeenReceipt]) return %orig;
    if (shouldBeSeen) {
        shouldBeSeen = false;
        return %orig;
    }
    return;
}
%end

// Show Profile image
%hook IGProfilePictureImageView
- (id)initWithFrame:(CGRect)frame imagePriority:(NSInteger)imagePriority placeholderImage:(id)placeholderImage buttonDisabled:(BOOL)buttonDisabled loggingEnabled:(BOOL)loggingEnabled {
    self = %orig(frame, imagePriority, placeholderImage, buttonDisabled, loggingEnabled);
    if (self) {
        if (![BHIManager profileImageSave]) return self;
        
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
        longPress.minimumPressDuration = 0.3;
        [self addGestureRecognizer:longPress];
    }
    return self;
}
%new - (void)handleLongPress:(UILongPressGestureRecognizer *)sender {
    if (sender.state == UIGestureRecognizerStateBegan) {
        UIAlertController *alert = showDownloadProfilePictureImage(self.user, self);
        [topMostController() presentViewController:alert animated:YES completion:nil];
    }
}
%new - (void)downloadProgress:(float)progress {
    hud.detailTextLabel.text = [BHIManager getDownloadingPersent:progress];
}
%new - (void)downloadDidFinish:(NSURL *)filePath Filename:(NSString *)fileName {
    NSString *DocPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true).firstObject;
    NSFileManager *manager = [NSFileManager defaultManager];
    NSURL *newFilePath = [[NSURL fileURLWithPath:DocPath] URLByAppendingPathComponent:[NSString stringWithFormat:@"%@.png", NSUUID.UUID.UUIDString]];
    [manager moveItemAtURL:filePath toURL:newFilePath error:nil];
    
    [hud dismiss];
    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [hud dismiss];
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
        NSString *newArg2 = [NSString stringWithFormat:@"%@ (%@)",
                             arg2 ?: @"Liked:",
                             formatted];
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
//     NSDictionary* dummyItem = @{
//         (__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
//         (__bridge id)kSecAttrAccount : @"dummyItem",
//         (__bridge id)kSecAttrService : @"dummyService",
//         (__bridge id)kSecReturnAttributes : @YES,
//     };

//     CFTypeRef result;
//     OSStatus ret = SecItemCopyMatching((__bridge CFDictionaryRef)dummyItem, &result);
//     if (ret == -25300) {
//         ret = SecItemAdd((__bridge CFDictionaryRef)dummyItem, &result);
//     }

//     if (ret == 0 && result) {
//         NSDictionary* resultDict = (__bridge id)result;
//         keychainAccessGroup = resultDict[(__bridge id)kSecAttrAccessGroup];
//         NSLog(@"loaded keychainAccessGroup: %@", keychainAccessGroup);
//     }
// }

// %hook NSFileManager
// - (NSURL *)containerURLForSecurityApplicationGroupIdentifier:(NSString*)groupIdentifier {
//     NSURL *fakeURL = [fakeGroupContainerURL URLByAppendingPathComponent:groupIdentifier];
//     createDirectoryIfNotExists(fakeURL);
//     createDirectoryIfNotExists([fakeURL URLByAppendingPathComponent:@"Library"]);
//     createDirectoryIfNotExists([fakeURL URLByAppendingPathComponent:@"Library/Caches"]);

//     return fakeURL;
// }
// %end

// %hook FBSDKKeychainStore
// - (NSString*)accessGroup{
//     return keychainAccessGroup;
// }
// %end

// %hook FBKeychainItemController
// - (NSString*)accessGroup {
//     return keychainAccessGroup;
// }
// %end

// %hook UICKeyChainStore
// - (NSString*)accessGroup {
//     return keychainAccessGroup;
// }
// %end

%ctor {
    // fakeGroupContainerURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FakeGroupContainers"] isDirectory:YES];
    // loadKeychainAccessGroup();
    
    %init;
}