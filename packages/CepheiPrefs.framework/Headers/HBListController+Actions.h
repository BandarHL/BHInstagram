#import "HBListController.h"

@class PSSpecifier;

NS_ASSUME_NONNULL_BEGIN

/// The HBListController (Actions) class category in CepheiPrefs implements action methods you can
/// use with link and button specifiers.
@interface HBListController (Actions)

/// Specifier action to perform a restart of the system app (respring).
///
/// You should prefer to have preferences immediately take effect, rather than using this method.
///
/// @see `-hb_respringAndReturn:`
- (void)hb_respring:(PSSpecifier *)specifier;

/// Specifier action to perform a restart of the system app (respring), and return to the current
/// preferences screen.
///
/// You should prefer to have preferences immediately take effect, rather than using this method.
///
/// @see `-hb_respring:`
- (void)hb_respringAndReturn:(PSSpecifier *)specifier;

/// Specifier action to open the URL specified by the specifier.
///
/// This is intended to be used with `HBLinkTableCell`.
///
/// @see `HBLinkTableCell`
- (void)hb_openURL:(PSSpecifier *)specifier;

/// Specifier action to open the package specified by the specifier.
///
/// This is intended to be used with `HBPackageTableCell`.
///
/// @see `HBPackageTableCell`
- (void)hb_openPackage:(PSSpecifier *)specifier;

@end

NS_ASSUME_NONNULL_END
