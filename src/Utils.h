#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// Colours
static NSDictionary *bhColours;

// Functions
extern BOOL isNotch(void);
extern void showConfirmation(void (^okHandler)(void));