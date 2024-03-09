#import "../../InstagramHeaders.h"
#import "../../Manager.h"
#import "../../Tweak.h"
#import "../../Utils.h"

%hook IGStoryViewerContainerView
%property (nonatomic, strong) JGProgressHUD *hud;
%property (nonatomic, retain) UIButton *hDownloadButton;
%property (nonatomic, retain) NSString *fileextension;
- (id)initWithFrame:(CGRect)arg1 shouldCreateComposerBackgroundView:(BOOL)arg2 userSession:(id)arg3 bloksContext:(id)arg4 {
    self = %orig;
    if ([BHIManager downloadVideos]) {
        self.hDownloadButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [self.hDownloadButton addTarget:self action:@selector(hDownloadButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [self.hDownloadButton setImage:[UIImage systemImageNamed:@"arrow.down.to.line.circle.fill"] forState:UIControlStateNormal];
        [self.hDownloadButton setTranslatesAutoresizingMaskIntoConstraints:false];

        [self addSubview:self.hDownloadButton];
        [NSLayoutConstraint activateConstraints:@[
            [self.hDownloadButton.topAnchor constraintEqualToAnchor:self.topAnchor constant:(self.frame.size.height - ([BHIUtils isNotch] ? 120.0 : 90.0))],
            [self.hDownloadButton.trailingAnchor constraintEqualToAnchor:self.trailingAnchor],
            [self.hDownloadButton.widthAnchor constraintEqualToConstant:50],
            [self.hDownloadButton.heightAnchor constraintEqualToConstant:50],
        ]];
    }

    return self;
}
%new - (void)hDownloadButtonPressed:(UIButton *)sender {
     NSLog(@"[BHInsta] Save story: Preparing alert");
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

    // Currently not working (dunno why and im lazy too fix)
    /* if (self.delegate != nil) {
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
    } */
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

    NSLog(@"[BHInsta] Save story: Displaying alert");

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

    NSLog(@"[BHInsta] Save story: Displaying save dialog");

    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}
%end