#import <Foundation/Foundation.h>

void createDirectoryIfNotExists(NSURL *URL) {
    if (![URL checkResourceIsReachableAndReturnError:nil]) {
        [[NSFileManager defaultManager] createDirectoryAtURL:URL withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

// Make keychain accesses and application group accesses work on sideloaded Instagram
NSString *keychainAccessGroup;
NSURL *fakeGroupContainerURL;
void loadKeychainAccessGroup() {
	NSDictionary* dummyItem = @{
		(__bridge id)kSecClass : (__bridge id)kSecClassGenericPassword,
		(__bridge id)kSecAttrAccount : @"dummyItem",
		(__bridge id)kSecAttrService : @"dummyService",
		(__bridge id)kSecReturnAttributes : @YES,
	};
	CFTypeRef result;
	OSStatus ret = SecItemCopyMatching((__bridge CFDictionaryRef)dummyItem, &result);
    if (ret == -25300) {
		ret = SecItemAdd((__bridge CFDictionaryRef)dummyItem, &result);
	}
	if (ret == 0 && result) {
		NSDictionary* resultDict = (__bridge id)result;
		keychainAccessGroup = resultDict[(__bridge id)kSecAttrAccessGroup];
		NSLog(@"loaded keychainAccessGroup: %@", keychainAccessGroup);
	}
}
%hook NSFileManager
- (NSURL *)containerURLForSecurityApplicationGroupIdentifier:(NSString*)groupIdentifier {
    NSURL *fakeURL = [fakeGroupContainerURL URLByAppendingPathComponent:groupIdentifier];
    createDirectoryIfNotExists(fakeURL);
    createDirectoryIfNotExists([fakeURL URLByAppendingPathComponent:@"Library"]);
    createDirectoryIfNotExists([fakeURL URLByAppendingPathComponent:@"Library/Caches"]);
    return fakeURL;
}
%end
%hook FBSDKKeychainStore
- (NSString*)accessGroup{
	return keychainAccessGroup;
}
%end
%hook FBKeychainItemController
- (NSString*)accessGroup {
	return keychainAccessGroup;
}
%end
%hook UICKeyChainStore
- (NSString*)accessGroup {
	return keychainAccessGroup;
}
%end

%ctor {
	fakeGroupContainerURL = [NSURL fileURLWithPath:[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/FakeGroupContainers"] isDirectory:YES];
	loadKeychainAccessGroup();

    %init;
}