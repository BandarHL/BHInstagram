#import "HBTintedTableCell.h"

/// The HBLinkTableCell class in CepheiPrefs displays a button that, when tapped, opens the
/// specified URL. A typical icon can be used, or the initials key can be set to one or two
/// characters to show as the icon.
///
/// This cell can either be used without setting any cell type, or by setting it to `PSButtonCell`
/// to get a tinted button.
///
/// ### Specifier Parameters
/// <table class="graybox">
/// <tr>
/// <td>url</td> <td>Required. The URL to open.</td>
/// </tr>
/// <tr>
/// <td>subtitle</td> <td>Optional. A subtitle to display below the label. The default is an empty
/// string, hiding the subtitle.</td>
/// </tr>
/// <tr>
/// <td>initials</td> <td>Optional. One or two characters to show as the icon.</td>
/// </tr>
/// <tr>
/// <td>iconURL</td> <td>Optional. The URL to an image to display. The default is no value,
/// hiding the image.</td>
/// </tr>
/// <tr>
/// <td>iconCircular</td> <td>Optional. Whether the icon should be displayed as a circle. The
/// default is NO when an iconURL is set, otherwise this property is unused.</td>
/// </tr>
/// <tr>
/// <td>iconCornerRadius</td> <td>Optional. A custom corner radius to use for the icon. Ignored
/// if iconCircular is set to true. If set to -1, the operating system’s default icon corner radius
/// is used. The default is -1.</td>
/// </tr>
/// </table>
///
/// ### Example Usage
/// ```xml
/// <!-- With icon: -->
/// <dict>
/// 	<key>cellClass</key>
/// 	<string>HBLinkTableCell</string>
/// 	<key>icon</key>
/// 	<string>example.png</string>
/// 	<key>label</key>
/// 	<string>Example</string>
/// 	<key>url</key>
/// 	<string>http://example.com/</string>
/// </dict>
///
/// <!-- With initials: -->
/// <dict>
/// 	<key>cellClass</key>
/// 	<string>HBLinkTableCell</string>
/// 	<key>initials</key>
/// 	<string>XX</string>
/// 	<key>label</key>
/// 	<string>Example</string>
/// 	<key>url</key>
/// 	<string>http://example.com/</string>
/// </dict>
///
/// <!-- With a subtitle: -->
/// <dict>
/// 	<key>cellClass</key>
/// 	<string>HBLinkTableCell</string>
/// 	<key>label</key>
/// 	<string>Example</string>
/// 	<key>subtitle</key>
/// 	<string>Visit our amazing website</string>
/// 	<key>url</key>
/// 	<string>http://example.com/</string>
/// </dict>
///
/// <!-- With a subtitle, in big mode: -->
/// <dict>
/// 	<key>big</key>
/// 	<true/>
/// 	<key>cellClass</key>
/// 	<string>HBLinkTableCell</string>
/// 	<key>height</key>
/// 	<integer>64</integer>
/// 	<key>label</key>
/// 	<string>Example</string>
/// 	<key>subtitle</key>
/// 	<string>Visit our amazing website</string>
/// 	<key>url</key>
/// 	<string>http://example.com/</string>
/// </dict>
/// ```

@interface HBLinkTableCell : HBTintedTableCell

/// Whether the cell is 64 pixels or more in height.
///
/// This is not set automatically; the specifier for the cell must set the `big` property to true
/// (see examples above).
@property (nonatomic, readonly) BOOL isBig;

/// The view containing the icon image view.
@property (nonatomic, retain, readonly) UIView *iconView;

/// The icon image view.
@property (nonatomic, retain, readonly) UIImageView *iconImageView;

/// The image to display as the icon, if enabled.
@property (nonatomic, retain) UIImage *iconImage;

/// A URL to load into iconImage to display as the icon, if enabled.
@property (nonatomic, retain) NSURL *iconURL;

/// Whether the image displays as a circle.
///
/// The default is YES if an iconURL is set in the specifier, otherwise NO.
@property (nonatomic, readonly) BOOL isIconCircular;

/// Load and display the icon.
///
/// You don’t need to call this unless subclassing.
- (void)loadIconIfNeeded;

/// Handle failure to load the icon.
///
/// You don’t need to call this unless subclassing. The default implementation replaces the image
/// with the operating system’s generic “no icon” placeholder if `iconCornerRadius` is set to -1,
/// and `isIconCircular` is set to NO.
- (void)iconLoadDidFailWithResponse:(NSURLResponse *)response error:(NSError *)error;

@end
