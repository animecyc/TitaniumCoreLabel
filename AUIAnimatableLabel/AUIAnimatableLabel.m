/**
 *   AnimatableLabel.m
 *   AUIAnimatedText
 *
 *   Created by Adam Siton on 8/29/11.
 *   Copyright 2011 Adam Siton. All rights reserved.
 *
 *   Modified work copyright (c) 2012 Kevin Zimmerman
 *   Modified work copyright (c) 2013 Seth Benjamin
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
#import "AUIAnimatableLabel.h"
#import <QuartzCore/QuartzCore.h>
#import "UIFont+CoreTextExtensions.h"

@implementation AUIAnimatableLabel

@synthesize textLayer;

- (id)init
{
    if (self = [super init])
    {
        [self _initializeTextLayer];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [self _initializeTextLayer];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        [self _initializeTextLayer];
    }
    
    return self;
}

- (void)_initializeTextLayer
{
    textLayer = [CATextLayer layer];
    
    [textLayer setFrame:self.bounds];
    [textLayer setContentsScale:[[UIScreen mainScreen] scale]];
    [textLayer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    [self setTextColor:[super textColor]];
    [self setFont:[super font]];
    [self setBackgroundColor:[super backgroundColor]];
    [self setText:[super text]];
    [self setTextAlignment:[super textAlignment]];
    [self setLineBreakMode:[super lineBreakMode]];
    [self setVerticalTextAlignment:AUITextVerticalAlignmentCenter];
    
    [super setText:nil];
    
    [self.layer addSublayer:textLayer];
}

- (UIColor *)textColor
{
    return [UIColor colorWithCGColor:textLayer.foregroundColor];
}

- (void)setTextColor:(UIColor *)textColor
{
    textLayer.foregroundColor = textColor.CGColor;
    
    [self setNeedsDisplay];
}

- (NSString *)text
{
    return [textLayer string];
}

- (void)setText:(NSString *)text
{
    [textLayer setString:text];
    
    [self setNeedsDisplay];
}

- (UIFont *)font
{
    return [UIFont fontWithCTFont:[textLayer font]];
}

- (void)setFont:(UIFont *)font
{
    CTFontRef fontRef = font.CTFont;
    
    [textLayer setFont:fontRef];
    [textLayer setFontSize:font.pointSize];
    
    CFRelease(fontRef);
    
    [self setNeedsDisplay];
}

- (void)setFrame:(CGRect)frame
{
    [textLayer setFrame:frame];

    [super setFrame:frame];
    
    [self setNeedsDisplay];
}

- (UIColor *)shadowColor
{
    return [UIColor colorWithCGColor:[textLayer shadowColor]];
}

- (void)setShadowColor:(UIColor *)shadowColor
{
    [textLayer setShadowColor:shadowColor.CGColor];
    
    [self setNeedsDisplay];
}

- (CGSize)shadowOffset
{
    return [textLayer shadowOffset];
}

- (void)setShadowOffset:(CGSize)shadowOffset
{
    [textLayer setShadowOffset:shadowOffset];
    
    [self setNeedsDisplay];
}

- (NSTextAlignment)textAlignment
{
    NSTextAlignment labelAlignment = NSTextAlignmentLeft;
    NSString *layerAlignmentMode = [textLayer alignmentMode];
    
    if ([layerAlignmentMode isEqualToString:kCAAlignmentLeft])
    {
        labelAlignment = NSTextAlignmentLeft;
    }
    else if ([layerAlignmentMode isEqualToString:kCAAlignmentRight])
    {
        labelAlignment = NSTextAlignmentRight;
    }
    else if ([layerAlignmentMode isEqualToString:kCAAlignmentCenter])
    {
        labelAlignment = NSTextAlignmentCenter;
    }
    
    return labelAlignment;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment
{
    switch (textAlignment)
    {
        case NSTextAlignmentLeft:
            [textLayer setAlignmentMode:kCAAlignmentLeft];
            break;
        case NSTextAlignmentRight:
            [textLayer setAlignmentMode:kCAAlignmentRight];
            break;
        case NSTextAlignmentCenter:
            [textLayer setAlignmentMode:kCAAlignmentCenter];
            break;
        default:
            [textLayer setAlignmentMode:kCAAlignmentNatural];
            break;
    }
    
    [self setNeedsDisplay];
}

- (NSLineBreakMode)lineBreakMode
{
    return [super lineBreakMode];
}

- (void)setLineBreakMode:(NSLineBreakMode)lineBreakMode
{
    switch (lineBreakMode)
    {
        case NSLineBreakByCharWrapping:
        case NSLineBreakByWordWrapping:
            [textLayer setWrapped:YES];
            break;
        case NSLineBreakByClipping:
            [textLayer setWrapped:NO];
            break;
        case NSLineBreakByTruncatingHead:
            [textLayer setTruncationMode:kCATruncationStart];
            break;
        case NSLineBreakByTruncatingTail:
            [textLayer setTruncationMode:kCATruncationEnd];
            break;
        case NSLineBreakByTruncatingMiddle:
            [textLayer setTruncationMode:kCATruncationMiddle];
            break;
    }
    
    [self setNeedsDisplay];
}

- (void)setVerticalTextAlignment:(AUITextVerticalAlignment)newVerticalTextAlignment
{
    _verticalTextAlignment = newVerticalTextAlignment;
    
    [self setNeedsLayout];
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
- (CGSize)textSize:(CGSize)constraintSize
{
    if (self.textLayer.wrapped)
    {
        return [self.text sizeWithFont:[self font]
                     constrainedToSize:CGSizeEqualToSize(constraintSize, CGSizeZero) ? self.bounds.size : constraintSize
                         lineBreakMode:[self lineBreakMode]];
    }
    
    return [self.text sizeWithFont:[self font]];
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.adjustsFontSizeToFitWidth)
    {
        CGFloat newFontSize;
        float minimumFontSize;
        
        #pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        minimumFontSize = [self respondsToSelector:@selector(minimumScaleFactor)] ? [self minimumScaleFactor] : [self minimumFontSize];
        #pragma GCC diagnostic warning "-Wdeprecated-declarations"
        
        [textLayer.string sizeWithFont:self.font
                           minFontSize:minimumFontSize
                        actualFontSize:&newFontSize
                              forWidth:self.bounds.size.width
                         lineBreakMode:self.lineBreakMode];
        
        [self setFont:[UIFont fontWithName:self.font.fontName size:newFontSize]];
    }
    
    CGSize stringSize = [self textSize:CGSizeZero];
    CGRect newLayerFrame = [self.layer bounds];
    
    newLayerFrame.size.height = stringSize.height;
    
    switch ([self verticalTextAlignment])
    {
        case AUITextVerticalAlignmentCenter:
            newLayerFrame.origin.y = (self.bounds.size.height - stringSize.height) / 2;
            break;
        case AUITextVerticalAlignmentTop:
            newLayerFrame.origin.y = 0;
            break;
        case AUITextVerticalAlignmentBottom:
            newLayerFrame.origin.y = (self.bounds.size.height - stringSize.height);
            break;
    }
    
    [textLayer setFrame:newLayerFrame];
    
    [self setNeedsDisplay];
}

- (CGSize)sizeThatFits:(CGSize)size
{
    return [self textSize:CGSizeZero];
}

- (void)sizeToFit
{
    CGRect fittedFrame = self.frame;
    
    fittedFrame.size = [self textSize:CGSizeZero];
    
    [self setFrame:fittedFrame];
    [self setNeedsLayout];
}

@end