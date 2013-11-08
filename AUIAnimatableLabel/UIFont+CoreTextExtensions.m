/**
 *   UIFont+CoreTextExtensions.h
 *   CoreTextWrapper
 *
 *   Created by Adrian on 4/24/10.
 *   Copyright 2010 akosma software. All rights reserved.
 */
#import "UIFont+CoreTextExtensions.h"

@implementation UIFont (CoreTextExtensions)

- (CTFontRef)CTFont
{
    return CTFontCreateWithName((__bridge CFStringRef)self.fontName, self.pointSize, NULL);
}

+ (UIFont *)fontWithCTFont:(CTFontRef) CTFont
{
    NSString *fontName = (NSString *)CFBridgingRelease(CTFontCopyName(CTFont, kCTFontPostScriptNameKey));
    CGFloat fontSize = CTFontGetSize(CTFont);
    
    return [UIFont fontWithName:fontName size:fontSize];
}

/**
 * Adapted from http://stackoverflow.com/questions/2703085/how-can-you-load-a-font-ttf-from-a-file-using-core-text
 */

+ (CTFontRef)bundledFontNamed:(NSString *)name size:(CGFloat)size
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"ttf"];
    
    CFURLRef url = CFURLCreateWithFileSystemPath(kCFAllocatorDefault, (CFStringRef)path, kCFURLPOSIXPathStyle, false);
    CGDataProviderRef dataProvider = CGDataProviderCreateWithURL(url);
    CGFontRef theCGFont = CGFontCreateWithDataProvider(dataProvider);
    CTFontRef result = CTFontCreateWithGraphicsFont(theCGFont, size, NULL, NULL);
    
    CFRelease(theCGFont);
    CFRelease(dataProvider);
    CFRelease(url);
    
    return result;
}

@end