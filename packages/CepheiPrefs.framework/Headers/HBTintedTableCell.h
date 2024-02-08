#import <Preferences/PSTableCell.h>

/// The HBTintedTableCell class in CepheiPrefs ensures that a tint set with `HBAppearanceSettings`
/// will also be applied to the title label of a of a cell intended to be used as a button.
///
/// ### Specifier Parameters
/// HBListController extends specifiers with the following parameters:
///
/// <table class="graybox">
/// <tr>
/// <td>tintColor</td> <td>Optional. The color to use for the label of the cell. The default is no
/// value, which means the tint color will be inherited from the -[HBAppearanceSettings tintColor];
/// if neither value is set, the default iOS blue tint color is used.</td>
/// </tr>
/// </table>
///
/// ### Example Usage
/// ```xml
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSButtonCell</string>
/// 	<key>cellClass</key>
/// 	<string>HBTintedTableCell</string>
/// 	<key>label</key>
/// 	<string>Do Something</string>
/// </dict>
///
/// <!-- Or with a custom tint color: -->
/// <dict>
/// 	<key>cell</key>
/// 	<string>PSButtonCell</string>
/// 	<key>cellClass</key>
/// 	<string>HBTintedTableCell</string>
/// 	<key>label</key>
/// 	<string>Do Something</string>
/// 	<key>tintColor</key>
/// 	<string>#33b5e5</string>
/// </dict>
/// ```

@interface HBTintedTableCell : PSTableCell

@end
