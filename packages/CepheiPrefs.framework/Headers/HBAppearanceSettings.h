#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// Constants indicating how to size the title of this item.
typedef NS_ENUM(NSUInteger, HBAppearanceSettingsLargeTitleStyle) {
	/// Display a large title only when the current view controller is a subclass of
	/// `HBRootListController`.
	///
	/// This is the default mode.
	HBAppearanceSettingsLargeTitleStyleRootOnly,

	/// Always display a large title.
	HBAppearanceSettingsLargeTitleStyleAlways,

	/// Never display a large title.
	HBAppearanceSettingsLargeTitleStyleNever
} NS_SWIFT_NAME(HBAppearanceSettings.LargeTitleStyle);

/// The HBAppearanceSettings class in CepheiPrefs provides a model object read by other components
/// of Cephei to determine colors and other appearence settings to use in the user interface.
///
/// Appearance settings are typically set on a view controller, via the
/// `-[PSListController(HBTintAdditions) hb_appearanceSettings]` property. This is automatically
/// managed by Cephei and provided to view controllers as they are pushed onto the stack.
///
/// Most commonly, the API will be used by setting the `hb_appearanceSettings` property from the
/// init method. The following example sets the tint color, table view background color, and
/// customises the navigation bar with a background, title, and status bar color:
///
/// ```objc
/// - (instancetype)init {
/// 	self = [super init];
///
/// 	if (self) {
/// 		HBAppearanceSettings *appearanceSettings = [[HBAppearanceSettings alloc] init];
/// 		appearanceSettings.tintColor = [UIColor colorWithRed:66.f / 255.f green:105.f / 255.f blue:154.f / 255.f alpha:1];
/// 		appearanceSettings.barTintColor = [UIColor systemRedColor];
/// 		appearanceSettings.navigationBarTitleColor = [UIColor whiteColor];
/// 		appearanceSettings.tableViewBackgroundColor = [UIColor colorWithWhite:242.f / 255.f alpha:1];
/// 		appearanceSettings.statusBarStyle = UIStatusBarStyleLightContent;
/// 		self.hb_appearanceSettings = appearanceSettings;
/// 	}
///
/// 	return self;
/// }
/// ```

@interface HBAppearanceSettings : NSObject

/// @name General

/// The tint color to use for interactable elements within the list controller. Set this property to
/// a UIColor to use.
///
/// A nil value will cause no modification of the tint to occur.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *tintColor;

#ifdef __IPHONE_13_0
/// The user interface style to use. Set this property to a UIUserInterfaceStyle to use.
///
/// @return By default, UIUserInterfaceStyleUnspecified.
@property (nonatomic, assign) UIUserInterfaceStyle userInterfaceStyle API_AVAILABLE(ios(13.0));
#endif

/// @name Navigation Bar

/// The tint color to use for the navigation bar buttons, or, if invertedNavigationBar is set, the
/// background of the navigation bar. Set this property to a UIColor to use, if you don’t want to
/// use the same color as tintColor.
///
/// A nil value will cause no modification of the navigation bar tint to occur.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *navigationBarTintColor;

/// The color to use for the navigation bar title label. Set this property to a UIColor to use.
///
/// A nil value will cause no modification of the navigation bar title color to occur.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *navigationBarTitleColor;

/// The background color to use for the navigation bar. Set this property to a UIColor to use.
///
/// A nil value will cause no modification of the navigation bar background to occur.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *navigationBarBackgroundColor;

/// The status bar style to use. Set this property to a UIStatusBarStyle to use.
///
/// @return By default, UIStatusBarStyleDefault.
@property (nonatomic, assign) UIStatusBarStyle statusBarStyle;

/// The color to use for the status bar icons. Set this property to a UIColor to use.
///
/// A nil value will cause no modification of the status bar color to occur.
///
/// @return By default, nil.
/// @warning Setting the status bar to a custom color is no longer possible as of iOS 13. Set
/// statusBarStyle instead.
@property (nonatomic, copy, nullable) UIColor *statusBarTintColor __attribute((deprecated("Set statusBarStyle instead.")));

/// Whether to use an inverted navigation bar.
///
/// An inverted navigation bar has a tinted background, rather than the buttons being tinted. All
/// other interface elements will be tinted the same.
///
/// @return By default, NO.
@property (nonatomic, assign) BOOL invertedNavigationBar __attribute((deprecated("Set navigationBarBackgroundColor and navigationBarTitleColor instead.")));

/// Whether to use a translucent navigation bar. Set this property to YES if you want this behavior.
///
/// @return By default, YES.
@property (nonatomic, assign) BOOL translucentNavigationBar;

/// Whether to show the shadow (separator line) at the bottom of the navigation bar.
///
/// Requires iOS 13 or later.
///
/// @return By default, YES.
@property (nonatomic, assign) BOOL showsNavigationBarShadow;

/// Whether to use a large title on iOS 11 and newer. Set this property to a value from
/// HBAppearanceSettingsLargeTitleStyle.
///
/// @return By default, HBAppearanceSettingsLargeTitleStyleRootOnly.
@property (nonatomic, assign) HBAppearanceSettingsLargeTitleStyle largeTitleStyle;

/// @name Table View

/// The color to be used for the overall background of the table view. Set this property to a
/// UIColor to use.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *tableViewBackgroundColor;

/// The color to be used for the text color of table view cells. Set this property to a UIColor to
/// use.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *tableViewCellTextColor;

/// The color to be used for the background color of table view cells. Set this property to a
/// UIColor to use.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *tableViewCellBackgroundColor;

/// The color to be used for the separator between table view cells. Set this property to a UIColor
/// to use.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *tableViewCellSeparatorColor;

/// The color to be used when a table view cell is selected. This color will be shown when the cell
/// is in the highlighted state.
///
/// @return By default, nil.
@property (nonatomic, copy, nullable) UIColor *tableViewCellSelectionColor;

@end

NS_ASSUME_NONNULL_END
