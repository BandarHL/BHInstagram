#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^HBPreferencesChangeCallback)(void);

typedef void (^HBPreferencesValueChangeCallback)(NSString *key, id<NSCopying> _Nullable value);

/// The HBPreferences class in Cephei provides an interface for managing user-defined
/// preferences of a tweak, and the default values used when the user has not yet changed a value.
///
/// `HBPreferences` is very similar to `NSUserDefaults`, however it is specifically tailored to iOS
/// tweak development, since tweaks may be loaded into a sandboxed process (most obviously, App
/// Store apps, but also system apps like Safari), or one that runs as the `root` user (for
/// instance, iFile, although these apps are slowly changing their model so they now run as mobile).
/// In both of these cases, using `NSUserDefaults` will result in reading from preferences inside
/// the sandbox, or inside `root`’s home directory; both of which are not what is expected.
///
/// Advantages `HBPreferences` has over `NSUserDefaults` are:
///
/// - Directly reading the property list from the `mobile` user’s home directory, to support
/// sandboxed apps and apps running as `root`.
/// - Intuitive method of setting a default preference value.
/// - Updating of the app/tweak’s variables when preferences are changed.
/// - Keyed subscripting is allowed, which enables simple array syntax.
/// - Values in the preferences plist are called preferences, not defaults, to avoid ambiguity -
/// `NSUserDefaults` uses “defaults” to refer to both preferences themselves and the fallback values
/// if a key doesn’t exist.
///
/// Ensure you read the discussion for `-registerObject:default:forKey:` before using the automatic
/// updating mechanism. `-objectForKey:` does not update as another process updates the preferences
/// on iOS 7 or older; if you need to support older iOS versions, use the registration methods
/// instead.
///
/// As of Cephei 1.17, HBPreferences supports Key-Value Observation. As such, you may subscribe to
/// changes made to preferences through observer callbacks. The `-registerPreferenceChangeBlock:`
/// and `-registerPreferenceChangeBlockForKey:block:` methods are provided to subscribe to
/// preference changes via a callback block since Cephei 1.3, and you can additionally observe
/// `HBPreferencesDidChangeNotification`.
///
/// ### Example usage
/// In Objective-C/Logos:
///
/// ```logos
/// HBPreferences *preferences;
/// BOOL doThing;
///
/// %ctor {
/// 	preferences = [[HBPreferences alloc] initWithIdentifier:@"ws.hbang.common.demo"];
/// 	[preferences registerDefaults:@{
/// 		@"Enabled": @YES,
/// 		@"AnotherSetting": @1.f
/// 	}];
///
/// 	[preferences registerBool:&doThing default:NO forKey:@"DoThing"];
///
/// 	NSLog(@"Am I enabled? %i", [preferences boolForKey:@"Enabled"]);
/// 	NSLog(@"Can I do thing? %i", doThing);
/// }
/// ```
///
/// In Swift:
///
/// ```swift
/// class Preferences {
/// 
/// 	private let preferences = HBPreferences(identifier: "ws.hbang.common.demo")
///
/// 	// Example using registration method
/// 	private(set) var canDoThing: ObjCBool = false
///
/// 	// Example using custom getter and setter
/// 	var anotherSetting: Int {
/// 		get { preferences["AnotherSetting"] as? Int ?? -1 }
/// 		set { preferences["AnotherSetting"] = newValue }
/// 	}
///
/// 	// Example using KVO observation
/// 	private var doThingObserver: NSKeyValueObserving?
///
/// 	init() {
/// 		preferences.register(defaults: [
/// 			"Enabled": true,
/// 			"AnotherSetting": 1
/// 		])
///
/// 		preferences.register(&canDoThing, default: false, forKey: "DoThing")
///
/// 		print("Am I enabled? \(preferences["Enabled"] as? Bool ?? false)")
/// 		print("Can I do thing? \(canDoThing)")
/// 	}
///
/// }
/// ```
///
/// ### References
/// * [NSUserDefaults in Practice](http://dscoder.com/defaults.html)
///
/// ### Security
/// As of Cephei 1.12, HBPreferences restricts most Apple preferences (identifiers starting with
/// `com.apple.…`) from being read/written from a sandboxed process. This protects against a
/// malicious app using HBPreferences as a way to gather sensitive information or change system 
/// preferences without the user’s knowledge. For instance, an App Store app could
/// [phish for the user’s Apple ID login](https://krausefx.com/blog/ios-privacy-stealpassword-easily-get-the-users-apple-id-password-just-by-asking),
/// creating a very real-looking login prompt by pre-filling their email address in the username box,
/// or gain access to the numbers/email addresses of people the user has recently contacted.
///
/// There is currently no way to avoid this restriction while still using HBPreferences. If you need
/// access to Apple preferences, design your code to not need to do this from within the sandbox.
/// This could be done [using IPC](http://iphonedevwiki.net/index.php/IPC) from an unsandboxed
/// process such as SpringBoard. Avoid sending sensitive information via IPC to sandboxed apps, as
/// they can still get access to data you send through various ways.
@interface HBPreferences : NSObject

/// @name Initializing an HBPreferences Object

/// Creates an instance of the class for the specified identifier.
///
/// @param identifier The identifier to be used. This is usually the same as the package identifier
/// of the tweak.
/// @return An autoreleased instance of HBPreferences for the specified identifier.
+ (instancetype)preferencesForIdentifier:(NSString *)identifier NS_SWIFT_UNAVAILABLE("");

/// Initializes an instance of the class for the specified identifier.
///
/// @param identifier The identifier to be used. This is usually the same as the package identifier
/// of the tweak.
/// @return An autoreleased instance of HBPreferences for the specified identifier.
- (instancetype)initWithIdentifier:(NSString *)identifier NS_DESIGNATED_INITIALIZER;

/// The preferences identifier provided at initialisation.
@property (nonatomic, retain, readonly) NSString *identifier;

/// @name Synchronizing Preferences

/// Synchronizes preferences data to prevent race conditions.
///
/// On iOS 8.0 and later, waits until all communications between the `cfprefsd` daemon and the
/// current process have completed, preventing race conditions and guaranteeing no data will be
/// lost. Prior to iOS 8.0, writes all pending changes to disk, and reads latest preferences from
/// disk.
///
/// Deprecated. On iOS 12.0 and later, synchronization is
/// [no longer required](https://developer.apple.com/documentation/ios-ipados-release-notes/foundation-release-notes#UserDefaults).
/// The underlying CFPreferencesSynchronize() function simply returns `YES`.
///
/// For earlier iOS releases, do not use this method directly unless you have a specific need.
/// HBPreferences will synchronize automatically when needed. For further information on what this
/// method does and when to use it, refer to
/// [NSUserDefaults in Practice](http://dscoder.com/defaults.html) § “Sharing Defaults Between
/// Programs”.
///
/// @return `YES` if synchronization was successful, `NO` if an error occurred.
- (BOOL)synchronize API_DEPRECATED("Synchronization is no longer required as of iOS 12", ios(5.0, 12.0));

/// @name Registering Default Preference Values

/// The default preferences to be used when no value has been set by the user.
///
/// You may modify the values of this dictionary directly.
@property (nonatomic, copy, readonly) NSMutableDictionary <NSString *, id> *defaults;

/// Adds the contents of the specified dictionary to the defaults property.
///
/// Merges the provided dictionary with the mutable dictionary found on the defaults property.
///
/// @param defaultValues The dictionary of keys and values you want to register.
/// @see `defaults`
- (void)registerDefaults:(NSDictionary <NSString *, id> *)defaultValues NS_SWIFT_NAME(register(defaults:));

/// @name Getting Preference Values

/// Returns a dictionary that contains all preferences that are set.
///
/// This does not include default values.
///
/// @return A dictionary containing all keys and values.
- (NSDictionary <NSString *, id> *)dictionaryRepresentation;

/// Returns the object associated with the specified key.
///
/// If the preference is not yet set, returns the default. If no default is set, returns `nil`.
///
/// @param key The key for which to return the corresponding value.
/// @return The object associated with the specified key.
/// @warning You must manually synchronize preferences or use `-registerObject:default:forKey:` for
/// this value to be updated when running on iOS 7 or older.
- (id)objectForKey:(NSString *)key;

/// Returns the integer value associated with the specified key.
///
/// If the preference is not yet set, returns the default. If no default is set, returns `nil`.
///
/// @param key The key for which to return the corresponding value.
/// @return The integer value associated with the specified key.
/// @see `-objectForKey:`
- (NSInteger)integerForKey:(NSString *)key;

/// Returns the unsigned integer value associated with the specified key.
///
/// If the preference is not yet set, returns the default. If no default is set, returns `nil`.
///
/// @param key The key for which to return the corresponding value.
/// @return The unsigned integer value associated with the specified key.
/// @see `-objectForKey:`
- (NSUInteger)unsignedIntegerForKey:(NSString *)key;

/// Returns the floating-point value associated with the specified key.
///
/// If the preference is not yet set, returns the default. If no default is set, returns `nil`.
///
/// @param key The key for which to return the corresponding value.
/// @return The floating-point value associated with the specified key.
/// @see `-objectForKey:`
- (CGFloat)floatForKey:(NSString *)key;

/// Returns the double value associated with the specified key.
///
/// If the preference is not yet set, returns the default. If no default is set, returns `nil`.
///
/// @param key The key for which to return the corresponding value.
/// @return The double value associated with the specified key.
/// @see `-objectForKey:`
- (double)doubleForKey:(NSString *)key;

/// Returns the Boolean value associated with the specified key.
///
/// If the preference is not yet set, returns the default. If no default is set, returns `nil`.
///
/// @param key The key for which to return the corresponding value.
/// @return The Boolean value associated with the specified key.
/// @see `-objectForKey:`
- (BOOL)boolForKey:(NSString *)key;

/// Returns the value associated with a given key.
///
/// This method behaves the same as `-objectForKey:`, and enables the preferences object to be used
/// with a subscript (square brackets). For example:
///
/// Objective-C:
///
/// ```objc
/// NSString *fooBar = preferences[@"FooBar"];
/// preferences[@"Awesome"] = @YES;
/// ```
///
/// Swift:
///
/// ```swift
/// let fooBar = preferences["FooBar"] as? String
/// preferences["Awesome"] = true
/// ```
///
/// @param key The key for which to return the corresponding value.
/// @return The value associated with the specified key.
/// @see `-objectForKey:`
- (id)objectForKeyedSubscript:(id)key;

/// Returns the object associated with the specified key, or if no user preference is set, the
/// provided default.
///
/// @param key The key for which to return the corresponding value.
/// @param defaultValue The default value to use when no user preference is set.
/// @return The object associated with the specified key, or the default value.
- (id)objectForKey:(NSString *)key default:(nullable id)defaultValue;

/// Returns the integer value associated with the specified key, or if no user preference is set,
/// the provided default.
///
/// @param key The key for which to return the corresponding value.
/// @param defaultValue The default value to use when no user preference is set.
/// @return The integer value associated with the specified key, or the default value.
/// @see `-objectForKey:default:`
- (NSInteger)integerForKey:(NSString *)key default:(NSInteger)defaultValue;

/// Returns the unsigned integer value associated with the specified key, or if no user preference
/// is set, the provided default.
///
/// @param key The key for which to return the corresponding value.
/// @param defaultValue The default value to use when no user preference is set.
/// @return The unsigned integer value associated with the specified key, or the default value.
/// @see `-objectForKey:default:`
- (NSUInteger)unsignedIntegerForKey:(NSString *)key default:(NSUInteger)defaultValue;

/// Returns the floating-point value associated with the specified key, or if no user preference is
/// set, the provided default.
///
/// @param key The key for which to return the corresponding value.
/// @param defaultValue The default value to use when no user preference is set.
/// @return The floating-point value associated with the specified key, or the default value.
/// @see `-objectForKey:default:`
- (CGFloat)floatForKey:(NSString *)key default:(CGFloat)defaultValue;

/// Returns the double value associated with the specified key, or if no user preference is set,
/// the provided default.
///
/// @param key The key for which to return the corresponding value.
/// @param defaultValue The default value to use when no user preference is set.
/// @return The double value associated with the specified key, or the default value.
/// @see `-objectForKey:default:`
- (double)doubleForKey:(NSString *)key default:(double)defaultValue;

/// Returns the Boolean value associated with the specified key, or if no user preference is set,
/// the provided default.
///
/// @param key The key for which to return the corresponding value.
/// @param defaultValue The default value to use when no user preference is set.
/// @return The Boolean value associated with the specified key, or the default value.
/// @see `-objectForKey:default:`
- (BOOL)boolForKey:(NSString *)key default:(BOOL)defaultValue;

/// @name Setting Preference Values

/// Sets the value of the specified key.
///
/// You should only call these methods if you are certain that the process is running as the
/// `mobile` user.
///
/// @param value The object to store in the preferences.
/// @param key The key with which to associate with the value.
/// @exception HBPreferencesNotMobileException Thrown when the method is called by a process not
/// running as the `mobile` user.
- (void)setObject:(nullable id)value forKey:(NSString *)key NS_SWIFT_NAME(set(_:forKey:));

/// Sets the value of the specified key to the specified integer value.
///
/// This is a convenience method that calls `-setObject:forKey:`. See the discussion of that method
/// for more details.
///
/// @param value The integer value to store in the preferences.
/// @param key The key with which to associate with the value.
/// @see `-setObject:forKey:`
- (void)setInteger:(NSInteger)value forKey:(NSString *)key NS_SWIFT_NAME(set(_:forKey:));

/// Sets the value of the specified key to the specified unsigned integer value.
///
/// This is a convenience method that calls `-setObject:forKey:`. See the discussion of that method
/// for more details.
///
/// @param value The unsigned integer value to store in the preferences.
/// @param key The key with which to associate with the value.
/// @see `-setObject:forKey:`
- (void)setUnsignedInteger:(NSUInteger)value forKey:(NSString *)key NS_SWIFT_NAME(set(_:forKey:));

/// Sets the value of the specified key to the specified floating-point value.
///
/// This is a convenience method that calls `-setObject:forKey:`. See the discussion of that method
/// for more details.
///
/// @param value The floating-point value to store in the preferences.
/// @param key The key with which to associate with the value.
/// @see `-setObject:forKey:`
- (void)setFloat:(CGFloat)value forKey:(NSString *)key NS_SWIFT_NAME(set(_:forKey:));

/// Sets the value of the specified key to the specified double value.
///
/// This is a convenience method that calls `-setObject:forKey:`. See the discussion of that method
/// for more details.
///
/// @param value The double value to store in the preferences.
/// @param key The key with which to associate with the value.
/// @see `-setObject:forKey:`
- (void)setDouble:(double)value forKey:(NSString *)key NS_SWIFT_NAME(set(_:forKey:));

/// Sets the value of the specified key to the specified Boolean value.
///
/// This is a convenience method that calls `-setObject:forKey:`. See the discussion of that method
/// for more details.
///
/// @param value The Boolean value to store in the preferences.
/// @param key The key with which to associate with the value.
/// @see `-setObject:forKey:`
- (void)setBool:(BOOL)value forKey:(NSString *)key NS_SWIFT_NAME(set(_:forKey:));

/// Sets the value of the specified key to the specified value.
///
/// This method behaves the same as `-setObject:forKey:`, and enables the preferences object to be
/// used with a subscript (square brackets). For example:
///
/// ```objc
/// NSString *fooBar = preferences[@"FooBar"];
/// preferences[@"Awesome"] = @YES;
/// ```
///
/// @param object The value to store in the preferences.
/// @param key The key with which to associate with the value.
- (void)setObject:(nullable id)object forKeyedSubscript:(id)key;

/// @name Removing Preference Values

/// Removes a given key and its associated value from the dictionary.
///
/// @param key The key to remove.
- (void)removeObjectForKey:(NSString *)key NS_SWIFT_NAME(removeValue(forKey:));

/// Removes all stored preferences.
///
/// This method acts in the same way as discussed in `-removeObjectForKey:`.
- (void)removeAllObjects NS_SWIFT_NAME(removeAll());

/// @name Registering Variables

/// Register an object to be automatically set to the user’s preference.
///
/// If the preference is not yet set, the object will be set to the provided default.
///
/// You must post a Darwin notification after updating preferences for this to work. In particular,
/// it must be set to the value of identifier, followed by `/ReloadPrefs` - for instance,
/// `ws.hbang.common.demo/ReloadPrefs`. In a Preferences specifier property list, you can use the
/// `PostNotification` key on your specifiers to achieve this:
///
/// ```xml
/// <dict>
/// 	…
/// 	<key>PostNotification</key>
/// 	<string>ws.hbang.common.demo/ReloadPrefs</string>
/// </dict>
/// ```
///
/// @param object The pointer to the object.
/// @param defaultValue The default value to be used if no user preference is set.
/// @param key The key in the preferences property list.
/// @see `-registerObject:default:forKey:`
- (void)registerObject:(_Nullable id __strong * _Nonnull)object default:(nullable id)defaultValue forKey:(NSString *)key NS_SWIFT_NAME(register(_:default:forKey:));

/// Register an integer value to be automatically set to the user’s preference.
///
/// If the preference is not yet set, the object will be set to the provided default.
///
/// @param object The pointer to the integer.
/// @param defaultValue The default value to be used if no user preference is set.
/// @param key The key in the preferences property list.
/// @see `-registerObject:default:forKey:`
- (void)registerInteger:(NSInteger *)object default:(NSInteger)defaultValue forKey:(NSString *)key NS_SWIFT_NAME(register(_:default:forKey:));

/// Register an unsigned integer value to be automatically set to the user’s preference.
///
/// If the preference is not yet set, the object will be set to the provided default.
///
/// @param object The pointer to the unsigned integer.
/// @param defaultValue The default value to be used if no user preference is set.
/// @param key The key in the preferences property list.
/// @see `-registerObject:default:forKey:`
- (void)registerUnsignedInteger:(NSUInteger *)object default:(NSUInteger)defaultValue forKey:(NSString *)key NS_SWIFT_NAME(register(_:default:forKey:));

/// Register a floating-point value to be automatically set to the user’s preference.
///
/// If the preference is not yet set, the object will be set to the provided default.
///
/// @param object The pointer to the integer.
/// @param defaultValue The default value to be used if no user preference is set.
/// @param key The key in the preferences property list.
/// @see `-registerObject:default:forKey:`
- (void)registerFloat:(CGFloat *)object default:(CGFloat)defaultValue forKey:(NSString *)key NS_SWIFT_NAME(register(_:default:forKey:));

/// Register a double value to be automatically set to the user’s preference.
///
/// If the preference is not yet set, the object will be set to the provided default.
///
/// @param object The pointer to the double.
/// @param defaultValue The default value to be used if no user preference is set.
/// @param key The key in the preferences property list.
/// @see `-registerObject:default:forKey:`
- (void)registerDouble:(double *)object default:(double)defaultValue forKey:(NSString *)key NS_SWIFT_NAME(register(_:default:forKey:));

/// Register a Boolean value to be automatically set to the user’s preference.
///
/// If the preference is not yet set, the object will be set to the provided default.
///
/// @param object The pointer to the Boolean.
/// @param defaultValue The default value to be used if no user preference is set.
/// @param key The key in the preferences property list.
/// @see `-registerObject:default:forKey:`
- (void)registerBool:(BOOL *)object default:(BOOL)defaultValue forKey:(NSString *)key NS_SWIFT_NAME(register(_:default:forKey:));

/// @name Preference Change Callbacks

/// Register a block to be called when a preference change is detected.
///
/// Blocks are called after HBPreferences’ cache of values is updated. The block will also be called
/// immediately after calling this method. See `registerObject:default:forKey:` for details on how
/// to set up callbacks.
///
/// @param callback A block object called when the specified key’s value changes. The block object
/// takes no parameters and returns no value.
/// @see `-registerObject:default:forKey:`
- (void)registerPreferenceChangeBlock:(HBPreferencesChangeCallback)callback;

/// Register a block to be called when a specific preference is changed.
///
/// Blocks are called after HBPreferences’ cache of values is updated. The block will also be called
/// immediately after calling this method. See `registerObject:default:forKey:` for details on how
/// to set up callbacks.
///
/// @param key The key to listen for.
/// @param callback A block object called when the specified key’s value changes. The block object’s
/// parameters are the key and its new value.
/// @see `-registerObject:default:forKey:`
- (void)registerPreferenceChangeBlockForKey:(NSString *)key block:(HBPreferencesValueChangeCallback)callback;

/// Register a block to be called when a specific preference is changed.
///
/// Blocks are called after HBPreferences’ cache of values is updated. The block will also be called
/// immediately after calling this method. See `-registerObject:default:forKey:` for details on how
/// to set up callbacks.
///
/// Deprecated. This method signature changed in Cephei 1.17 to better support the order of
/// arguments preferred by Swift closure syntax. Use `-registerPreferenceChangeBlockForKey:block:`
/// instead.
///
/// @param callback A block object called when the specified key’s value changes. The block object’s
/// parameters are the key and its new value.
/// @param key The key to listen for.
/// @see `-registerPreferenceChangeBlockForKey:block:`
/// @see `-registerObject:default:forKey:`
- (void)registerPreferenceChangeBlock:(HBPreferencesValueChangeCallback)callback forKey:(NSString *)key __attribute((deprecated("Use registerPreferenceChangeBlockForKey:block: instead.")));

@end

/// Name of an exception that occurs when attempting to set preferences from a process not running
/// as the `mobile` user.
extern NSExceptionName const HBPreferencesNotMobileException NS_SWIFT_NAME(HBPreferences.notMobileException);

/// This notification is posted when a change is made to a registered preferences identifier. The
/// notification object is the associated HBPreferences object.
extern NSNotificationName const HBPreferencesDidChangeNotification NS_SWIFT_NAME(HBPreferences.didChangeNotification);

NS_ASSUME_NONNULL_END
