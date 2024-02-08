#import "../../InstagramHeaders.h"
#import "../../Manager.h"

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
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"BHInsta Downloader" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        IGImageView *profilePictureView = [self valueForKey:@"_profilePictureView"];
        NSURL *url = profilePictureView.imageSpecifier.url;

        [alert addAction:[UIAlertAction actionWithTitle:@"Download HD Profile Picture" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            BHIDownload *dwManager = [[BHIDownload alloc] init];
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