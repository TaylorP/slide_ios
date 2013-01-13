/*
 *
 *  OBImage/UIImage+Gradient.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "UIImage+Gradient.h"

@implementation UIImage (Gradient)

+ (UIImage*)gradientImageWithStartColor:(CGColorRef)startColor andEndColor:(CGColorRef)endColor andRect:(CGRect)rect
{
    UIImage * newImage = nil;
        
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,  rect.size.width, 
                                                        rect.size.height, 
                                                        8, 4 * rect.size.width, 
                                                        colorSpace, 
                                                        kCGImageAlphaPremultipliedFirst
                                                 );

    CGFloat locations[] = { 0.0, 1.0 };
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];
    
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, 
                                                        (CFArrayRef) colors, locations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextSaveGState(context);
    CGContextAddRect(context, rect);
    CGContextClip(context);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGContextRestoreGState(context);
    
    CGGradientRelease(gradient);
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    newImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return newImage;
}

@end
