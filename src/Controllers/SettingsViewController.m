#import "SettingsViewController.h"

@interface SettingsViewController ()
@property (nonatomic, assign) BOOL hasDynamicSpecifiers;
@property (nonatomic, retain) NSMutableDictionary *dynamicSpecifiers;
@end

@implementation SettingsViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"BHInsta";
        [self.navigationController.navigationBar setPrefersLargeTitles:false];
    }
    return self;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleInsetGrouped;
}

- (PSSpecifier *)newSectionWithTitle:(NSString *)header footer:(NSString *)footer {
    PSSpecifier *section = [PSSpecifier preferenceSpecifierNamed:header target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
    if (footer != nil) {
        [section setProperty:footer forKey:@"footerText"];
    }
    return section;
}
- (PSSpecifier *)newSwitchCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText key:(NSString *)keyText defaultValue:(BOOL)defValue changeAction:(SEL)changeAction {
    PSSpecifier *switchCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
    
    [switchCell setProperty:keyText forKey:@"key"];
    [switchCell setProperty:keyText forKey:@"id"];
    [switchCell setProperty:@YES forKey:@"big"];
    [switchCell setProperty:BHSwitchTableCell.class forKey:@"cellClass"];
    [switchCell setProperty:NSBundle.mainBundle.bundleIdentifier forKey:@"defaults"];
    [switchCell setProperty:@(defValue) forKey:@"default"];
    [switchCell setProperty:NSStringFromSelector(changeAction) forKey:@"switchAction"];
    if (detailText != nil) {
        [switchCell setProperty:detailText forKey:@"subtitle"];
    }
    return switchCell;
}
- (PSSpecifier *)newButtonCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText dynamicRule:(NSString *)rule action:(SEL)action {
    PSSpecifier *buttonCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];
    
    [buttonCell setButtonAction:action];
    [buttonCell setProperty:@YES forKey:@"big"];
    [buttonCell setProperty:BHButtonTableViewCell.class forKey:@"cellClass"];
    if (detailText != nil ){
        [buttonCell setProperty:detailText forKey:@"subtitle"];
    }
    if (rule != nil) {
        [buttonCell setProperty:@44 forKey:@"height"];
        [buttonCell setProperty:rule forKey:@"dynamicRule"];
    }
    return buttonCell;
}
- (PSSpecifier *)newHBLinkCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText url:(NSString *)url {
    PSSpecifier *HBLinkCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];
    
    [HBLinkCell setButtonAction:@selector(hb_openURL:)];
    [HBLinkCell setProperty:HBLinkTableCell.class forKey:@"cellClass"];
    [HBLinkCell setProperty:url forKey:@"url"];
    if (detailText != nil) {
        [HBLinkCell setProperty:detailText forKey:@"subtitle"];
    }
    return HBLinkCell;
}
- (PSSpecifier *)newHBButtonCellWithTitle:(NSString *)titleText action:(SEL)action {
    PSSpecifier *HBButtonCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];
    
    [HBButtonCell setButtonAction:@selector(action:)];
    [HBButtonCell setProperty:HBTintedTableCell.class forKey:@"cellClass"];
    return HBButtonCell;
}
- (PSSpecifier *)newHBTwitterCellWithTitle:(NSString *)titleText twitterUsername:(NSString *)user customAvatarURL:(NSString *)avatarURL {
    PSSpecifier *TwitterCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:1 edit:nil];
    
    [TwitterCell setButtonAction:@selector(hb_openURL:)];
    [TwitterCell setProperty:HBTwitterCell.class forKey:@"cellClass"];
    [TwitterCell setProperty:user forKey:@"user"];
    [TwitterCell setProperty:@YES forKey:@"big"];
    [TwitterCell setProperty:@56 forKey:@"height"];
    [TwitterCell setProperty:avatarURL forKey:@"iconURL"];
    return TwitterCell;
}

- (NSArray *)specifiers {
    if (!_specifiers) {        
        _specifiers = [NSMutableArray arrayWithArray:@[
            // Section 1: General
            [self newSectionWithTitle:@"General" footer:nil],
            [self newSwitchCellWithTitle:@"Show like count" detailTitle:@"Show like count in the post" key:@"show_like_count" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"Copy description" detailTitle:@"Copy the post description with a long press" key:@"copy_description" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"Do not save recent searches" detailTitle:@"Search bars will no longer save your recent searches" key:@"no_recent_searches" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"Hide trending searches" detailTitle:@"Hides the trending searches under the explore search bar" key:@"hide_trending_searches" defaultValue:false changeAction:nil],

            // Section 2: Feed
            [self newSectionWithTitle:@"Feed" footer:nil],
            [self newSwitchCellWithTitle:@"Hide Ads" detailTitle:@"Remove all ads from the Instagram app" key:@"hide_ads" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"No suggested posts" detailTitle:@"Remove suggested posts from your feed" key:@"no_suggested_post" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"No suggested for you" detailTitle:@"Hide suggested accounts for you to follow" key:@"no_suggested_account" defaultValue:false changeAction:nil],
            //[self newSwitchCellWithTitle:@"No suggested reels" detailTitle:@"Hide suggested reels to watch" key:@"no_suggested_reels" defaultValue:false changeAction:nil],
            
            // Section 3: Confirm actions
            [self newSectionWithTitle:@"Confirm actions" footer:nil],
            [self newSwitchCellWithTitle:@"Confirm like: Posts" detailTitle:@"Shows an alert when you click the like button on posts to confirm the like" key:@"like_confirm" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Confirm like: Reels" detailTitle:@"Shows an alert when you click the like button on reels to confirm the like" key:@"like_confirm_reels" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Confirm follow" detailTitle:@"Shows an alert when you click the follow button to confirm the follow" key:@"follow_confirm" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Confirm call" detailTitle:@"Shows an alert when you click the audio/video call button to confirm before calling" key:@"call_confirm" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"Confirm voice messages" detailTitle:@"Shows an alert to confirm before sending a voice message" key:@"voice_message_confirm" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"Confirm sticker interaction" detailTitle:@"Shows an alert when you click a sticker on someone's story to confirm the action" key:@"sticker_interact_confirm" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Confirm posting comment" detailTitle:@"Shows an alert when you click the post comment button to confirm" key:@"post_comment_confirm" defaultValue:false changeAction:nil],

            // Section 4: Save media
            [self newSectionWithTitle:@"Save media" footer:nil],
            [self newSwitchCellWithTitle:@"Download videos" detailTitle:@"Download videos by long press" key:@"dw_videos" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"Save profile image" detailTitle:@"Save profile image by long press" key:@"save_profile" defaultValue:true changeAction:nil],

            // Section 5: Stories and Messages
            [self newSectionWithTitle:@"Story and Messages" footer:nil],
            [self newSwitchCellWithTitle:@"Keep deleted message" detailTitle:@"Keep deleted direct messages in the chat" key:@"keep_deleted_message" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"Unlimited replay of direct stories" detailTitle:@"Replay direct messages normal/once stories unlimited times" key:@"unlimited_replay" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Disable sending read receipts" detailTitle:@"Removes the seen text for others when you view a message" key:@"remove_lastseen" defaultValue:false changeAction:nil],
            [self newSwitchCellWithTitle:@"Remove screenshot alert" detailTitle:@"Removes the alert notifying others that you screenshotted a direct story" key:@"remove_screenshot_alert" defaultValue:true changeAction:nil],
            [self newSwitchCellWithTitle:@"Disable story seen receipt" detailTitle:@"Hides the notification for others when you view their story" key:@"no_seen_receipt" defaultValue:false changeAction:nil],

            // Section 6: Security
            [self newSectionWithTitle:@"Security" footer:nil],
            [self newSwitchCellWithTitle:@"Padlock" detailTitle:@"Lock Instagram with biometrics/password" key:@"padlock" defaultValue:false changeAction:nil],

            // Section 7: Debugging
            [self newSectionWithTitle:@"Debugging" footer:nil],
            [self newSwitchCellWithTitle:@"Enable FLEX" detailTitle:@"Show FLEX on instagram app." key:@"flex_instagram" defaultValue:false changeAction:@selector(FLEXAction:)],

            // Section 8: Credits
            [self newSectionWithTitle:@"Credits" footer:nil],
            [self newHBTwitterCellWithTitle:@"Maintainer" twitterUsername:@"SoVeryCuul" customAvatarURL:@"https://unavatar.io/twitter/SoVeryCuul"],
            [self newHBTwitterCellWithTitle:@"Original Author" twitterUsername:@"BandarHL" customAvatarURL:@"https://unavatar.io/twitter/BandarHL"],
            [self newHBLinkCellWithTitle:@"View Repo" detailTitle:@"View the tweak's source code on GitHub" url:@"https://github.com/SoCuul/BHInsta"]
        ]];
        
        [self collectDynamicSpecifiersFromArray:_specifiers];
    }
    
    return _specifiers;
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];
    
    [self collectDynamicSpecifiersFromArray:self.specifiers];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasDynamicSpecifiers) {
        PSSpecifier *dynamicSpecifier = [self specifierAtIndexPath:indexPath];
        BOOL __block shouldHide = false;
        
        [self.dynamicSpecifiers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray *specifiers = obj;
            if ([specifiers containsObject:dynamicSpecifier]) {
                shouldHide = [self shouldHideSpecifier:dynamicSpecifier];
                
                UITableViewCell *specifierCell = [dynamicSpecifier propertyForKey:PSTableCellKey];
                specifierCell.clipsToBounds = shouldHide;
            }
        }];
        if (shouldHide) {
            return 0;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (void)collectDynamicSpecifiersFromArray:(NSArray *)array {
    if (!self.dynamicSpecifiers) {
        self.dynamicSpecifiers = [NSMutableDictionary new];
        
    } else {
        [self.dynamicSpecifiers removeAllObjects];
    }
    
    for (PSSpecifier *specifier in array) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        
        if (dynamicSpecifierRule.length > 0) {
            NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];
            
            if (ruleComponents.count == 3) {
                NSString *opposingSpecifierID = [ruleComponents objectAtIndex:0];
                if ([self.dynamicSpecifiers objectForKey:opposingSpecifierID]) {
                    NSMutableArray *specifiers = [[self.dynamicSpecifiers objectForKey:opposingSpecifierID] mutableCopy];
                    [specifiers addObject:specifier];
                    
                    
                    [self.dynamicSpecifiers removeObjectForKey:opposingSpecifierID];
                    [self.dynamicSpecifiers setObject:specifiers forKey:opposingSpecifierID];
                } else {
                    [self.dynamicSpecifiers setObject:[NSMutableArray arrayWithArray:@[specifier]] forKey:opposingSpecifierID];
                }
                
            } else {
                [NSException raise:NSInternalInconsistencyException format:@"dynamicRule key requires three components (Specifier ID, Comparator, Value To Compare To). You have %ld of 3 (%@) for specifier '%@'.", ruleComponents.count, dynamicSpecifierRule, [specifier propertyForKey:PSTitleKey]];
            }
        }
    }
    
    self.hasDynamicSpecifiers = (self.dynamicSpecifiers.count > 0);
}
- (DynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string {
    NSDictionary *operatorValues = @{ @"==" : @(EqualToOperatorType), @"!=" : @(NotEqualToOperatorType), @">" : @(GreaterThanOperatorType), @"<" : @(LessThanOperatorType) };
    return [operatorValues[string] intValue];
}
- (BOOL)shouldHideSpecifier:(PSSpecifier *)specifier {
    if (specifier) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];
        
        PSSpecifier *opposingSpecifier = [self specifierForID:[ruleComponents objectAtIndex:0]];
        id opposingValue = [self readPreferenceValue:opposingSpecifier];
        id requiredValue = [ruleComponents objectAtIndex:2];
        
        if ([opposingValue isKindOfClass:NSNumber.class]) {
            DynamicSpecifierOperatorType operatorType = [self operatorTypeForString:[ruleComponents objectAtIndex:1]];
            
            switch (operatorType) {
                case EqualToOperatorType:
                    return ([opposingValue intValue] == [requiredValue intValue]);
                    break;
                    
                case NotEqualToOperatorType:
                    return ([opposingValue intValue] != [requiredValue intValue]);
                    break;
                    
                case GreaterThanOperatorType:
                    return ([opposingValue intValue] > [requiredValue intValue]);
                    break;
                    
                case LessThanOperatorType:
                    return ([opposingValue intValue] < [requiredValue intValue]);
                    break;
            }
        }
        
        if ([opposingValue isKindOfClass:NSString.class]) {
            return [opposingValue isEqualToString:requiredValue];
        }
        
        if ([opposingValue isKindOfClass:NSArray.class]) {
            return [opposingValue containsObject:requiredValue];
        }
    }
    
    return NO;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    [Prefs setValue:value forKey:[specifier identifier]];
    
    if (self.hasDynamicSpecifiers) {
        NSString *specifierID = [specifier propertyForKey:PSIDKey];
        PSSpecifier *dynamicSpecifier = [self.dynamicSpecifiers objectForKey:specifierID];
        
        if (dynamicSpecifier) {
            [self.table beginUpdates];
            [self.table endUpdates];
        }
    }
}
- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    return [Prefs valueForKey:[specifier identifier]]?:[specifier properties][@"default"];
}

- (void)FLEXAction:(UISwitch *)sender {
    if (sender.isOn) {
        [[objc_getClass("FLEXManager") sharedManager] showExplorer];
    } else {
        [[objc_getClass("FLEXManager") sharedManager] hideExplorer];
    }
}
@end

@implementation BHButtonTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier];
    if (self) {
        NSString *subTitle = [specifier.properties[@"subtitle"] copy];
        BOOL isBig = specifier.properties[@"big"] ? ((NSNumber *)specifier.properties[@"big"]).boolValue : NO;
        self.detailTextLabel.text = subTitle;
        self.detailTextLabel.numberOfLines = isBig ? 0 : 1;
        self.detailTextLabel.textColor = [UIColor secondaryLabelColor];
    }
    return self;
}

@end

@implementation BHSwitchTableCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier specifier:(PSSpecifier *)specifier {
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseIdentifier specifier:specifier])) {
        NSString *subTitle = [specifier.properties[@"subtitle"] copy];
        BOOL isBig = specifier.properties[@"big"] ? ((NSNumber *)specifier.properties[@"big"]).boolValue : NO;
        self.detailTextLabel.text = subTitle;
        self.detailTextLabel.numberOfLines = isBig ? 0 : 1;
        self.detailTextLabel.textColor = [UIColor secondaryLabelColor];
        
        if (specifier.properties[@"switchAction"]) {
            UISwitch *targetSwitch = ((UISwitch *)[self control]);
            NSString *strAction = [specifier.properties[@"switchAction"] copy];
            [targetSwitch addTarget:[self cellTarget] action:NSSelectorFromString(strAction) forControlEvents:UIControlEventValueChanged];
        }
    }
    return self;
}
@end