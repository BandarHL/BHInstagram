#import "../../InstagramHeaders.h"
#import "../../Manager.h"
#import "../../Controllers/SettingsViewController.h"

// Show BHInsta tweak settings by holding on the settings icon for ~1 second
%hook IGBadgedNavigationButton
- (instancetype)initWithIcon:(UIImage *)icon target:(id)target action:(SEL)action buttonType:(NSUInteger)type {
    self = %orig;

    if ([[icon ig_imageName] isEqualToString:@"ig_icon_menu_pano_outline_24"]) {
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress)];
        [self addGestureRecognizer:longPress];
    }

    return self;
}

%new - (void)handleLongPress {
    NSLog(@"[BHInsta] Tweak settings gesture activated");

    UIViewController *rootController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[SettingsViewController new]];
    
    [rootController presentViewController:navigationController animated:YES completion:nil];
}
%end

// TODO: Possibly add BHInsta settings button to profile header navbar icons
/* %hook IGStackLayout
// Display Settings Modal
%new - (void)displaySettingsModal:(id)sender {
    // Display settings modal
    NSLog(@"[BHInsta] Displaying BHInsta settings modal");

    UIViewController *rootController = [[UIApplication sharedApplication] delegate].window.rootViewController;
    SettingsViewController *settingsViewController = [SettingsViewController new];
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:settingsViewController];
    
    [rootController presentViewController:navigationController animated:YES completion:nil];

    return;
}

// test to get icon info
- (id)initWithIcon:(id)arg1 target:(id)arg2 action:(SEL)arg3 buttonType:(NSUInteger)arg4 {
    NSLog(@"[BHInsta] Icon: %@", arg1);

    return %orig;
}

- (id)initWithChildren:(id)children {
    // Check if children contain badged icons (only used on profile page)
    BOOL containsClass = NO;

    for (id child in children) {
        if ([child isKindOfClass:%c(IGBadgedNavigationButton)]) {
            containsClass = YES;
            break;
        }
    }

    if (!containsClass) {
        return %orig;
    }

    NSMutableArray *newChildren = [children mutableCopy];

    // Add button to children array
    //UIBarButtonItem *bhSettingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage systemImageNamed:@"gear.circle"] style:UIBarButtonItemStylePlain target:self action:@selector(displaySettingsModal)];
    // IGBadgedNavigationButton *badgedNavButton = [IGBadgedNavigationButton new];

    //UIButton *newButton = [UIButton buttonWithType:UIButtonTypeSystem];
    //[badgedNavButton ]

    //[newChildren addObject:badgedNavButton];

    // Make children array immutable
    //NSArray *immutableNewChildren = [newChildren copy]; 
    NSLog(@"[BHInsta] Old Children: %@", children); 
    NSLog(@"[BHInsta] New Children: %@", newChildren);
    

    return %orig(newChildren);
}
%end */