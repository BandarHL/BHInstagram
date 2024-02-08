#import <Preferences/PSListController.h>
#import "PSListController+HBTintAdditions.h"

NS_ASSUME_NONNULL_BEGIN

/// The HBListController class in CepheiPrefs provides a list controller with various
/// conveniences such as a unique tint color for the list controllers within a preference bundle,
/// and bug fixes for common issues within the Settings app and Preferences framework. In
/// particular, a bug with the list controller’s content disappearing after closing the Settings
/// app and opening it again is worked around, as well as an issue on iOS 7 where in some cases a
/// cell may stay highlighted after being tapped.
///
/// It includes two class methods you can override to return the name of a Preferences specifier
/// property list, and various methods to control appearance of the interface.
///
/// If you use `HBLinkTableCell` or subclasses such as `HBTwitterCell` and `HBPackageTableCell`, it
/// is recommended to subclass from HBListController on the view controller classes containing these
/// cells to use CepheiPrefs’s built-in callback actions. If you do not subclass from
/// HBListController, you will need to implement action methods yourself.
///
/// ### Specifier Parameters
/// HBListController extends specifiers with the following parameters:
///
/// <table class="graybox">
/// <tr>
/// <td>pl_filter</td> <td>Optional. Supports additional filters that decide whether a specifier
/// should be displayed, as specified below.</td>
/// </tr>
/// <tr>
/// <td>iconImageSystem</td> <td>Optional. Supports displaying a system image as the cell icon, as
/// specified below.</td>
/// </tr>
/// <tr>
/// <td>leftImageSystem</td> <td>Optional. Supports displaying a system image as the icon to the
/// left of a PSSliderCell’s slider control, as specified below.</td>
/// </tr>
/// <tr>
/// <td>rightImageSystem</td> <td>Optional. Supports displaying a system image as the icon to the
/// right of a PSSliderCell’s slider control, as specified below.</td>
/// </tr>
/// </table>
///
/// #### PreferenceLoader Filter Parameters
/// The `pl_filter` key is inherited from PreferenceLoader’s libprefs, and can be used to specify
/// [CoreFoundation version](https://iphonedev.wiki/index.php/CoreFoundation.framework) criteria
/// for a specifier. Specifiers that do not meet the `pl_filter` criteria will be discarded.
///
/// The version number of CoreFoundation is often used as a stable method of checking the operating
/// system version in use. It has the benefit of increasing in predictable amounts (to the next
/// hundred or more) for each major revision of Apple’s OS platforms, and it is typically roughly
/// the same between all Apple OS platforms at any point in time.
///
/// <table class="graybox">
/// <tr>
/// <td>CoreFoundationVersion</td> <td>Optional. An array of one or two CoreFoundation version
/// numbers in decimal (&lt;real&gt;). If one number is present, this is a minimum bound. The
/// current device’s CoreFoundation version must be greater than or equal to this number. If two
/// numbers are present, the first number is the lower bound, and the second number is one more than
/// the upper bound. The current device’s CoreFoundation version must be greater than or equal to
/// the first number, and less than (but not equal to) the second number.</td>
/// </tr>
/// </table>
///
/// ##### Example Usage
/// ```xml
/// <!-- Will only display on iOS 12.0 (CF 1556.0) or newer: -->
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSSwitchCell</string>
/// 	<key>label</key>
/// 	<string>My iOS 12+ Only Feature</string>
/// 	<key>pl_filter</key>
/// 	<dict>
/// 		<key>CoreFoundationVersion</key>
/// 		<array>
/// 			<real>1556.00</real>
/// 		</array>
/// 	</dict>
/// </dict>
///
/// <!-- Will only display between iOS 7.0 (CF 847.20) and 12.0 (CF 1556.00): -->
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSSwitchCell</string>
/// 	<key>label</key>
/// 	<string>My iOS 7-11 Only Feature</string>
/// 	<key>pl_filter</key>
/// 	<dict>
/// 		<key>CoreFoundationVersion</key>
/// 		<array>
/// 			<real>847.20</real>
/// 			<real>1556.00</real>
/// 		</array>
/// 	</dict>
/// </dict>
///
/// <!-- Will only display on versions earlier than iOS 12.0 (CF 1556.00): -->
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSSwitchCell</string>
/// 	<key>label</key>
/// 	<string>My iOS &lt;12 Only Feature</string>
/// 	<key>pl_filter</key>
/// 	<dict>
/// 		<key>CoreFoundationVersion</key>
/// 		<array>
/// 			<real>0.0</real>
/// 			<real>1556.00</real>
/// 		</array>
/// 	</dict>
/// </dict>
/// ```
///
/// #### System Icon Parameters
/// On iOS 13.0 and newer, you can specify a system icon
/// ([SF Symbols](https://developer.apple.com/sf-symbols/) glyph) to be displayed in a cell. Use the
/// SF Symbols app to find symbol names.
///
/// When running on iOS versions earlier than 13.0, icons will not be rendered. This also applies
/// when a symbol name is specified that was added in a later iOS version than is currently in use.
/// In this case, you can supply a PNG icon through the usual means as a fallback.
///
/// <table class="graybox">
/// <tr>
/// <td>name</td> <td>Required. The symbol name to use.</td>
/// </tr>
/// <tr>
/// <td>weight</td> <td>Optional. The weight to render the symbol at. The supported values are:
/// ultraLight, thin, light, regular, medium, semibold, bold, heavy, black. The default is
/// regular.</td>
/// </tr>
/// <tr>
/// <td>scale</td> <td>Optional. The scale to render the symbol at. The supported values are: small,
/// medium, large. The default is medium.</td>
/// </tr>
/// <tr>
/// <td>pointSize</td> <td>Optional. The equivalent font size to render the symbol at. The default
/// is 20.0.</td>
/// </tr>
/// <tr>
/// <td>tintColor</td> <td>Optional. The color to render the icon in. The default is no value, which
/// means the tint color will be inherited from the -[HBAppearanceSettings tintColor]; if neither
/// value is set, the default iOS blue tint color is used. When backgroundColor is set, no value
/// means white (#ffffff) will be used.</td>
/// </tr>
/// <tr>
/// <td>backgroundColor</td> <td>Optional. The background color to use for the symbol. When
/// specified, the symbol will be rendered inside an icon shape of the specified background color.
/// The symbol will be scaled down by 20% to appropriately fit the icon shape. The default is no
/// value, which means no icon shape will be rendered.</td>
/// </tr>
/// </table>
///
/// ##### Example Usage
///
/// ```xml
/// <!-- A switch with a two switches symbol as its icon -->
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSSwitchCell</string>
/// 	<key>label</key>
/// 	<string>Awesome</string>
/// 	<key>iconImageSystem</key>
/// 	<dict>
/// 		<key>name</key>
/// 		<string>switch.2</string>
/// 	</dict>
/// </dict>
///
/// <!-- A link cell with an information symbol as its icon -->
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSLinkCell</string>
/// 	<key>detail</key>
/// 	<string>HBDemoAboutListController</string>
/// 	<key>isController</key>
/// 	<true/>
/// 	<key>label</key>
/// 	<string>ABOUT</string>
/// 	<key>iconImageSystem</key>
/// 	<dict>
/// 		<key>name</key>
/// 		<string>info.circle</string>
/// 	</dict>
/// </dict>
///
/// <!-- A slider cell with brightness sun symbols on the left and right -->
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSSliderCell</string>
/// 	<key>min</key>
/// 	<real>1</real>
/// 	<key>max</key>
/// 	<real>15</real>
/// 	<key>leftImageSystem</key>
/// 	<dict>
/// 		<key>name</key>
/// 		<string>sun.min</string>
/// 	</dict>
/// 	<key>rightImageSystem</key>
/// 	<dict>
/// 		<key>name</key>
/// 		<string>sun.max</string>
/// 	</dict>
/// </dict>
///
/// <!-- A link cell with white heart symbol in a red icon shape -->
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSButtonCell</string>
/// 	<key>cellClass</key>
/// 	<string>HBLinkTableCell</string>
/// 	<key>label</key>
/// 	<string>DONATE</string>
/// 	<key>url</key>
/// 	<string>https://hashbang.productions/</string>
/// 	<key>iconImageSystem</key>
/// 	<dict>
/// 		<key>name</key>
/// 		<string>heart</string>
/// 		<key>backgroundColor</key>
/// 		<string>#ff3b30</string>
/// 	</dict>
/// </dict>
/// ```
@interface HBListController : PSListController

/// @name Specifiers

/// The property list that contains Preference framework specifiers to display as the content of the
/// list controller. Override this method to return the file name of a property list inside your
/// preference bundle, omitting the file extension.
///
/// Example:
/// ```objc
/// + (NSString *)hb_specifierPlist {
/// 	return @"Root";
/// }
/// ```
///
/// If you use this method and override the `specifiers` method, ensure you call the super method
/// with `[super specifiers];` first in your `specifiers` implementation.
///
/// @return By default, nil.
@property (nonatomic, strong, readonly, class, nullable) NSString *hb_specifierPlist NS_SWIFT_NAME(specifierPlist);

/// @name Related View Controllers

/// Returns the “real” navigation controller for this view controller.
///
/// As of iOS 8.0, the navigation controller that owns the navigation bar and other responsibilities
/// is actually a parent of `self.navigationController` on iPhone, due to the larger Plus models.
/// The realNavigationController method returns the correct navigation controller.
///
/// @return The real navigation controller.
- (UINavigationController *)realNavigationController;

@end

NS_ASSUME_NONNULL_END
