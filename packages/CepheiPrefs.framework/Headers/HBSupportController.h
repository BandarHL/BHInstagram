@import UIKit;

NS_ASSUME_NONNULL_BEGIN

/// The HBSupportController class in CepheiPrefs provides a factory that configures an email
/// composer for package support.
///
/// The resulting view controller should be presented modally; it should not be pushed on a
/// navigation controller stack.

@interface HBSupportController : NSObject

/// Initialises a Mail composer by using information provided by a bundle and preferences identifier.
///
/// Either a bundle or preferences identifier is required. If both are nil, an exception will be
/// thrown. The email address is derived from the `Author` field of the package’s control file.
/// `HBSupportController` implicitly adds the user’s package listing (output of `dpkg -l`) and the
/// preferences plist as attachments.
///
/// @param bundle A bundle included with the package.
/// @param preferencesIdentifier A preferences identifier that is used by the package.
/// @return A pre-configured email composer.
/// @see `+supportViewControllerForBundle:preferencesIdentifier:sendToEmail:`
+ (UIViewController *)supportViewControllerForBundle:(nullable NSBundle *)bundle preferencesIdentifier:(nullable NSString *)preferencesIdentifier;

/// Initialises a Mail composer by using information provided by a bundle, preferences identifier,
/// and optional email address.
///
/// Either a bundle or preferences identifier is required. If both are nil, an exception will be
/// thrown. If sendToEmail is nil, the email address is derived from the `Author` field of the
/// package’s control file. `HBSupportController` implicitly adds the user’s package listing (output
/// of `dpkg -l`) and the preferences plist as attachments.
///
/// @param bundle A bundle included with the package.
/// @param preferencesIdentifier A preferences identifier that is used by the package.
/// @param sendToEmail The email address to prefill in the To field. Pass nil to use the email
/// address from the package.
/// @return A pre-configured email composer.
+ (UIViewController *)supportViewControllerForBundle:(nullable NSBundle *)bundle preferencesIdentifier:(nullable NSString *)preferencesIdentifier sendToEmail:(nullable NSString *)sendToEmail;

/// @name Deprecated

/// No longer supported. Returns nil.
///
/// @return nil.
+ (id)linkInstructionForEmailAddress:(NSString *)emailAddress __attribute((deprecated("TechSupport is no longer supported.")));

/// Initialises a Mail composer by using information provided by a bundle.
///
/// Refer to `+supportViewControllerForBundle:preferencesIdentifier:linkInstruction:supportInstructions:`
/// for information on how the bundle is used.
///
/// @param bundle A bundle included with the package.
/// @return A pre-configured email composer.
/// @see `+supportViewControllerForBundle:preferencesIdentifier:sendToEmail:`
+ (UIViewController *)supportViewControllerForBundle:(NSBundle *)bundle __attribute((deprecated("TechSupport is no longer supported.")));

/// Initialises a Mail composer by using information provided by either a bundle or a preferences
/// identifier, and providing it a custom link instruction and support instructions.
///
/// The bundle may set the key `HBPackageIdentifier` in its Info.plist, containing the package
/// identifier to gather information from. Otherwise, the dpkg file lists are searched to find the
/// package that contains the bundle. The package’s name, identifier, and author will be used to
/// fill out fields in the information that the user will submit.
///
/// @param bundle A bundle included with the package.
/// @param preferencesIdentifier The preferences identifier of the package, if it’s different from
/// the package identifier that contains the bundle.
/// @param linkInstruction Ignored.
/// @param supportInstructions Ignored.
/// @return A pre-configured email composer.
/// @see `+supportViewControllerForBundle:preferencesIdentifier:`
+ (UIViewController *)supportViewControllerForBundle:(nullable NSBundle *)bundle preferencesIdentifier:(nullable NSString *)preferencesIdentifier linkInstruction:(nullable id)linkInstruction supportInstructions:(nullable NSArray *)supportInstructions __attribute((deprecated("Use +[HBSupportController supportViewControllerForBundle:preferencesIdentifier:].")));

@end

NS_ASSUME_NONNULL_END
