#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Executes a shell command and returns its output.
///
/// @param command The shell command to run.
/// @param returnCode A pointer to an integer that will contain the return code of the command.
/// @return The output of the provided command.
FOUNDATION_EXPORT NSString * _Nullable HBOutputForShellCommandWithReturnCode(NSString *command, int *returnCode);

/// Executes a shell command and returns its output.
///
/// @param command The shell command to run.
/// @return The output of the provided command, or nil if the command returned with a code other
/// than 0.
FOUNDATION_EXPORT NSString * _Nullable HBOutputForShellCommand(NSString *command);

NS_ASSUME_NONNULL_END
