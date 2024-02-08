#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// UIColor (HBAdditions) is a class category in Cephei that provides some convenience methods.
@interface UIColor (HBAdditions)

/// Creates and returns a color object using data from the specified object.
///
/// The value is expected to be one of the types specified in hb_initWithPropertyListValue:.
///
/// @param value The object to retrieve data from. See the discussion for the supported object
/// types.
/// @return The color object. The color information represented by this object is in the device RGB
/// colorspace.
/// @see `-hb_initWithPropertyListValue:`
+ (instancetype)hb_colorWithPropertyListValue:(id)value NS_SWIFT_NAME(init(propertyListValue:));

/// Initializes and returns a color object using data from the specified object.
///
/// The value is expected to be one of:
///
/// * An array of 3 or 4 integer RGB or RGBA color components, with values between 0 and 255 (e.g.
///   `@[ 218, 192, 222 ]`)
/// * A CSS-style hex string, with an optional alpha component (e.g. `#DAC0DE` or `#DACODE55`)
/// * A short CSS-style hex string, with an optional alpha component (e.g. `#DC0` or `#DC05`)
///
/// @param value The object to retrieve data from. See the discussion for the supported object
/// types.
/// @return An initialized color object. The color information represented by this object is in the
/// device RGB colorspace.
- (instancetype)hb_initWithPropertyListValue:(id)value NS_SWIFT_UNAVAILABLE("Use init(propertyListValue:)");

/// Initializes and returns a dynamic color object using the provided interface style variants.
///
/// This color dynamically changes based on the interface style on iOS 13 and newer. If dynamic
/// colors are not supported by the operating system, the value for UIUserInterfaceStyleLight or
/// UIUserInterfaceStyleUnspecified is returned.
///
/// Example:
///
/// ```objc
/// UIColor *myColor = [UIColor hb_colorWithInterfaceStyleVariants:@{
/// 	@(UIUserInterfaceStyleLight): [UIColor systemRedColor],
/// 	@(UIUserInterfaceStyleDark): [UIColor systemOrangeColor]
/// }];
/// ```
///
/// @param variants A dictionary of interface style keys and UIColor values.
/// @return An initialized dynamic color object, or the receiver if dynamic colors are unsupported
/// by the current operating system.
+ (instancetype)hb_colorWithInterfaceStyleVariants:(NSDictionary <NSNumber *, UIColor *> *)variants;

/// Initializes and returns a dynamic color object, with saturation decreased by 4% in the dark
/// interface style.
///
/// @return If the color is already a dynamic color, returns the receiver. Otherwise, a new dynamic
/// color object.
/// @see `+hb_colorWithInterfaceStyleVariants:`
- (instancetype)hb_colorWithDarkInterfaceVariant NS_SWIFT_NAME(withDarkInterfaceVariant());

/// Initializes and returns a dynamic color object, with the specified variant color for the dark
/// interface style.
///
/// Example:
///
/// ```objc
/// UIColor *myColor = [[UIColor systemRedColor] hb_colorWithDarkInterfaceVariant:[UIColor systemOrangeColor]];
/// ```
///
/// @param darkColor The color to use in the dark interface style.
/// @return A new dynamic color object.
/// @see `-hb_colorWithInterfaceStyleVariants:`
- (instancetype)hb_colorWithDarkInterfaceVariant:(UIColor *)darkColor NS_SWIFT_NAME(withDarkInterfaceVariant(_:));

@end

NS_ASSUME_NONNULL_END
