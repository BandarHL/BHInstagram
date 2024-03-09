#import "../../InstagramHeaders.h"
#import "../../Manager.h"

// Download photos
%hook IGFeedPhotoView
%property (nonatomic, strong) JGProgressHUD *hud;
- (id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    if ([BHIManager downloadMedia]) {
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

            NSLog(@"[BHInsta] Save media: Displaying save dialog");

            [BHIManager showSaveVC:currentImage];
        } else if ([self.delegate isKindOfClass:%c(IGFeedItemPagePhotoCell)]) {
            NSLog(@"[BHInsta] Save media: Preparing alert");

            IGFeedItemPagePhotoCell *currentCell = self.delegate;
            IGPostItem *currentPost = [currentCell post];

            NSSet <NSString *> *knownImageURLIdentifiers = [currentPost.photo valueForKey:@"_knownImageURLIdentifiers"];
            NSArray *knownImageURLIdentifiersArray = [knownImageURLIdentifiers allObjects];

            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta Downloader" message:nil preferredStyle:UIAlertControllerStyleActionSheet];

            for (int i = 0; i < [knownImageURLIdentifiersArray count]; i++) {
                [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download Image: Link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    BHIDownload *dwManager = [[BHIDownload alloc] init];
                    [dwManager downloadFileWithURL:[NSURL URLWithString:[knownImageURLIdentifiersArray objectAtIndex:i]]];
                    [dwManager setDelegate:self];

                    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                    self.hud.textLabel.text = @"Downloading";

                    [self.hud showInView:topMostController().view];
                }]];
            }
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

            NSLog(@"[BHInsta] Save media: Displaying alert");

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

    NSLog(@"[BHInsta] Save media: Displaying save dialog");

    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}
%end


// Download videos
%hook IGModernFeedVideoCell
%property (nonatomic, strong) JGProgressHUD *hud;
- (id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    if ([BHIManager downloadMedia]) {
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta Downloader" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        if ([self.delegate isKindOfClass:%c(IGPageMediaView)]) {
            NSLog(@"[BHInsta] Save media: Preparing alert");
            
            IGPageMediaView *mediaDelegate = self.delegate;
            IGPostItem *currentPost = [mediaDelegate currentMediaItem];
            NSArray *videoURLArray = [currentPost.video.allVideoURLs allObjects];
            
            for (int i = 0; i < [videoURLArray count]; i++) {
                [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download Video: Link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // [[[HDownloadMediaWithProgress alloc] init] checkPermissionToPhotosAndDownloadURL:[videoURLArray objectAtIndex:i] appendExtension:nil mediaType:Video toAlbum:@"Instagram" view:self];
                    BHIDownload *dwManager = [[BHIDownload alloc] init];
                    [dwManager downloadFileWithURL:[videoURLArray objectAtIndex:i]];
                    [dwManager setDelegate:self];

                    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                    self.hud.textLabel.text = @"Downloading";

                    [self.hud showInView:topMostController().view];
                }]];
            }
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

            NSLog(@"[BHInsta] Save media: Displaying alert");

            [self.viewController presentViewController:alert animated:YES completion:nil];
        }
        else if ([self.delegate isKindOfClass:%c(IGFeedSectionController)]) {
            NSLog(@"[BHInsta] Save media: Preparing alert");

            NSArray *videoURLArray = [self.post.video.allVideoURLs allObjects];
            
            for (int i = 0; i < [videoURLArray count]; i++) {
                [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download Video: Link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    // [[[HDownloadMediaWithProgress alloc] init] checkPermissionToPhotosAndDownloadURL:[videoURLArray objectAtIndex:i] appendExtension:nil mediaType:Video toAlbum:@"Instagram" view:self];
                    BHIDownload *dwManager = [[BHIDownload alloc] init];
                    [dwManager downloadFileWithURL:[videoURLArray objectAtIndex:i]];
                    [dwManager setDelegate:self];

                    self.hud = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
                    self.hud.textLabel.text = @"Downloading";
                    
                    [self.hud showInView:topMostController().view];
                }]];
            }
            [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];

            NSLog(@"[BHInsta] Save media: Displaying alert");

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
    
    NSLog(@"[BHInsta] Save media: Displaying save dialog");

    [BHIManager showSaveVC:newFilePath];
}
%new - (void)downloadDidFailureWithError:(NSError *)error {
    if (error) {
        [self.hud dismiss];
    }
}
%end


// Download reels
%hook IGSundialViewerVideoCell
%property (nonatomic, strong) JGProgressHUD *hud;
- (id)initWithFrame:(CGRect)arg1 {
    id orig = %orig;
    if ([BHIManager downloadMedia]) {
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"BHInsta Downloader" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        NSArray *videoURLArray = [self.video.video.allVideoURLs allObjects];
        
        for (int i = 0; i < [videoURLArray count]; i++) {
            [alert addAction:[UIAlertAction actionWithTitle:[NSString stringWithFormat:@"Download Video: Link %d (%@)", i + 1, i == 0 ? @"HD" : @"SD"] style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                // [[[HDownloadMediaWithProgress alloc] init] checkPermissionToPhotosAndDownloadURL:[videoURLArray objectAtIndex:i] appendExtension:nil mediaType:Video toAlbum:@"Instagram" view:self];
                BHIDownload *dwManager = [[BHIDownload alloc] init];
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