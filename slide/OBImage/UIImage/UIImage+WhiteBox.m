/*
 *
 *  OBImage/UIImage+WhiteBox.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "UIImage+WhiteBox.h"
#import "UIImage+RoundCorner.h"

@implementation UIImage (WhiteBox)

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage*)whiteOutlineWithSize:(CGSize)pSize andThickness:(CGFloat)pThickness;
{
    UIImage * newImage = nil;
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    float width  = pSize.width*screenScale;
    float height = pSize.height*screenScale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextSetLineWidth(context, pThickness*screenScale);
    CGContextStrokeRect(context, CGRectMake(0, 0, width, height));
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    newImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return newImage;
}

+ (UIImage*)roundWhiteOutlineWithSize:(CGSize)pSize andThickness:(CGFloat)pThickness andCornerSize:(CGSize)pCornerSize
{
    UIImage * newImage = nil;
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    int w = pSize.width * screenScale;
    int h = pSize.height * screenScale;
    pThickness *= screenScale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextBeginPath(context);
    CGRect rect = CGRectMake(pThickness, pThickness, w-2*pThickness, h-2*pThickness);
    addRoundedRectToPath(context, rect, pCornerSize.width * screenScale, pCornerSize.height * screenScale);
    
    CGContextClosePath(context);
    CGContextSetRGBStrokeColor(context, 1.0f, 1.0f, 1.0f, 1.0f);
    CGContextSetLineWidth(context, pThickness);
    CGContextStrokePath(context);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    newImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return newImage;
}

+ (UIImage *)whiteBoxWithSize:(CGSize)pSize
{
    UIImage * newImage = nil;
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    float width  = pSize.width * screenScale;
    float height = pSize.height * screenScale;
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8, 4 * width, colorSpace, kCGImageAlphaPremultipliedFirst);
    
    CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
    CGContextFillRect(context, CGRectMake(0, 0, width, height));
    
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    newImage = [UIImage imageWithCGImage:imageMasked];
    CGImageRelease(imageMasked);
    
    return newImage;
}

+ (UIImage*)roundWhiteBoxWithSize:(CGSize)pSize andCornerSize:(CGSize)pCornerSize;
{
    return [UIImage imageWithRoundCorner: [UIImage whiteBoxWithSize:pSize] 
                           andCornerSize: pCornerSize];
}

@end
