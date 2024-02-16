#import "../../InstagramHeaders.h"
#import "../../Manager.h"

%hook IGProfileMenuSheetViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 8) {
        IGProfileSheetTableViewCell *bhinstacell = [[%c(IGProfileSheetTableViewCell) alloc] initWithReuseIdentifier:@"bhinsta_settings"];

        UIImageSymbolConfiguration *configuration = [UIImageSymbolConfiguration configurationWithWeight:UIImageSymbolWeightBold];
        UIImage *gear = [UIImage systemImageNamed:@"gearshape.fill" withConfiguration:configuration];

        [bhinstacell.imageView setImage:gear];
        [bhinstacell.imageView setTintColor:[UIColor labelColor]];
        [bhinstacell.textLabel setText:@" BHInsta Settings"];

        return bhinstacell;
    }

    return %orig;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 8) {
        UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:[[SettingsViewController alloc] init]];
        [self _superPresentViewController:navVC animated:true completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    } else {
        return %orig;
    }
}
%end