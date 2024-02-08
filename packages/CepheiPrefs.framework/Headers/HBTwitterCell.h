#import "HBLinkTableCell.h"

/// The HBTwitterCell class in CepheiPrefs displays a button containing a person’s name, along
/// with their Twitter username and avatar. When tapped, a Twitter client installed on the user’s
/// device or the Twitter website is opened to the person’s profile.
///
/// ### Specifier Parameters
/// <table class="graybox">
/// <tr>
/// <td>big</td> <td>Optional. Whether to display the username below the name (true) or to the right
/// of it (false). The default is false. If you set this to true, you should also set the cell’s
/// height to 56pt.</td>
/// </tr>
/// <tr>
/// <td>initials</td> <td>Optional. One or two characters to show instead of an avatar.</td>
/// </tr>
/// <tr>
/// <td>label</td> <td>Required. The name of the person.</td>
/// </tr>
/// <tr>
/// <td>user</td> <td>Required. The Twitter username of the person.</td>
/// </tr>
/// <tr>
/// <td>userID</td> <td>Optional. The Twitter user identifier number of the person. You can find
/// the user ID using <a href="https://www.google.com/search?q=find+twitter+user+id">online tools</a>.
/// </td>
/// </tr>
/// <tr>
/// <td>showAvatar</td> <td>Optional. Whether to show the avatar of the user. The default is
/// true.</td>
/// </tr>
/// <tr>
/// <td>iconURL</td> <td>Optional. The URL to an image to display. The default is no value, meaning
/// meaning to retrieve the avatar for the Twitter username specified in the user property.</td>
/// </tr>
/// <tr>
/// <td>iconCircular</td> <td>Optional. Whether the icon should be displayed as a circle. The
/// default is YES.</td>
/// </tr>
/// </table>
///
/// ### Example Usage
/// ```xml
/// <!-- Standard size: -->
/// <dict>
/// 	<key>cellClass</key>
/// 	<string>HBTwitterCell</string>
/// 	<key>label</key>
/// 	<string>HASHBANG Productions</string>
/// 	<key>user</key>
/// 	<string>hashbang</string>
/// </dict>
///
/// <!-- Big size: -->
/// <dict>
/// 	<key>big</key>
/// 	<true/>
/// 	<key>cellClass</key>
/// 	<string>HBTwitterCell</string>
/// 	<key>height</key>
/// 	<integer>56</integer>
/// 	<key>label</key>
/// 	<string>HASHBANG Productions</string>
/// 	<key>user</key>
/// 	<string>hashbang</string>
/// </dict>
///
/// <!-- Without an avatar: -->
/// <dict>
/// 	<key>cellClass</key>
/// 	<string>HBTwitterCell</string>
/// 	<key>label</key>
/// 	<string>HASHBANG Productions</string>
/// 	<key>showAvatar</key>
/// 	<false/>
/// 	<key>user</key>
/// 	<string>hashbang</string>
/// </dict>
/// ```

@interface HBTwitterCell : HBLinkTableCell

@end
