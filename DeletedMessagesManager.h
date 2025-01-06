#import <Foundation/Foundation.h>

@interface DeletedMessagesManager : NSObject

/// Singleton instance
+ (instancetype)sharedManager;

/// Save a message ID with the current date
- (void)saveDeletedMessageWithID:(NSString *)messageID;

/// Check if a message ID exists
- (BOOL)messageExistsWithID:(NSString *)messageID;

- (NSString *)dateForDeletedMessageWithID:(NSString *)messageID;
@end