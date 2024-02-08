#import <substrate.h>
#import "InstagramHeaders.h"
#import "Utils.h"

#import "Manager.h"
#import "Download.h"
#import "Controllers/SecurityViewController.h"
#import "Controllers/SettingsViewController.h"

// Global state variables
static BOOL shouldBeSeen = false;
static BOOL seenButtonEnabled = false;
static BOOL dmStoriesViewedButtonEnabled = false;


// Tweak first-time setup
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

// Biometric/passcode authentication
static BOOL isAuthenticationShowed = FALSE;

- (void)applicationDidBecomeActive:(id)arg1 {
    %orig;

    // Show FLEX when application becomes active
    if ([BHIManager FLEX]) {
        [[objc_getClass("FLEXManager") sharedManager] showExplorer];
    }

    // Padlock (biometric auth)
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

    // Reset padlock status
    isAuthenticationShowed = FALSE;
}
%end

// Seen buttons (in DMs)
// Works for messages and the unlimited views of images
%hook IGTallNavigationBarView
- (void)setRightBarButtonItems:(NSArray <UIBarButtonItem *> *)items {
    NSMutableArray *new_items = [items mutableCopy];

    if ([BHIManager hideLastSeen]) {
        UIBarButtonItem *seenButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"checkmark.message"] style:UIBarButtonItemStylePlain target:self action:@selector(seenButtonHandler:)];
        [new_items addObject:seenButton];

        if (seenButtonEnabled) {
            [seenButton setTintColor:UIColor.blueColor];
        } else {
            [seenButton setTintColor:UIColor.labelColor];
        }
    }

    if ([BHIManager unlimitedReplay]) {
        UIBarButtonItem *dmStoriesViewedButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"photo.badge.checkmark"] style:UIBarButtonItemStylePlain target:self action:@selector(dmStoriesViewedButtonHandler:)];
        [new_items addObject:dmStoriesViewedButton];

        if (dmStoriesViewedButtonEnabled) {
            [dmStoriesViewedButton setTintColor:UIColor.blueColor];
        } else {
            [dmStoriesViewedButton setTintColor:UIColor.labelColor];
        }
    }

    %orig([new_items copy]);
}

// Seen button
%new - (void)seenButtonHandler:(UIBarButtonItem *)sender {
    if (seenButtonEnabled) {
        seenButtonEnabled = false;
        [sender setTintColor:UIColor.labelColor];
    } else {
        seenButtonEnabled = true;
        [sender setTintColor:UIColor.blueColor];
    }
}
// DM stories viewed button
%new - (void)dmStoriesViewedButtonHandler:(UIBarButtonItem *)sender {
    if (dmStoriesViewedButtonEnabled) {
        dmStoriesViewedButtonEnabled = false;
        [sender setTintColor:UIColor.labelColor];
    } else {
        dmStoriesViewedButtonEnabled = true;
        [sender setTintColor:UIColor.blueColor];
    }
}
%end

// Seen button
%hook IGDirectThreadViewListAdapterDataSource
- (BOOL)shouldUpdateLastSeenMessage {
    if ([BHIManager hideLastSeen]) {
        // Check if messages should be shown as seen
        if (seenButtonEnabled) {
            return %orig;
        }
        return false;
    }
    
    return %orig;
}
%end

// DM stories viewed button
%hook IGStoryPhotoView
- (void)progressImageView:(id)arg1 didLoadImage:(id)arg2 loadSource:(id)arg3 networkRequestSummary:(id)arg4 {
    if ([BHIManager unlimitedReplay]) {
        // Check if dm stories should be marked as viewed
        if (dmStoriesViewedButtonEnabled) {}
        else return;
    }

    return %orig;
}
%end

// No story seen
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

// Download stories
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
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta Downloader" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    if ([self.mediaView isKindOfClass:%c(IGStoryPhotoView)]) {
        NSURL *url = ((IGStoryPhotoView *)self.mediaView).photoView.imageSpecifier.url;
        self.fileextension = @"png";

        [alert addAction:[UIAlertAction actionWithTitle:@"Download Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            BHIDownload *dwManager = [[BHIDownload alloc] init];
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
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download Video: Link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                BHIDownload *dwManager = [[BHIDownload alloc] init];
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

//////

%hook HBForceCepheiPrefs
+ (BOOL)forceCepheiPrefsWhichIReallyNeedToAccessAndIKnowWhatImDoingISwear {
    return YES;
}
%end