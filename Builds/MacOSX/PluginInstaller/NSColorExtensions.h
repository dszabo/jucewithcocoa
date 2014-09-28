#import <Cocoa/Cocoa.h>

@interface NSColor (NSColorExtensions)

- (NSString *)hexadecimalValue;
+ (NSColor *)colorFromHexadecimalValue:(NSString *)hex;

@end

