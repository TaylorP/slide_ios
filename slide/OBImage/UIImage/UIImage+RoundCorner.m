/*
 *
 *  OBImage/UIImage+RoundCorner.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "UIImage+RoundCorner.h"

@implementation UIImage (RoundCorner)

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

+ (UIImage *)imageWithRoundCorner:(UIImage*)pImage andCornerSize:(CGSize)pSize andScaleUp:(BOOL)pScale;
{
    UIImage * newImage = nil;
    CGFloat screenScale = 1.0;
    
    if(pScale)
        screenScale = [[UIScreen mainScreen] scale];
    
    if( nil != pImage)
    {
        int w = pImage.size.width * screenScale;
        int h = pImage.size.height * screenScale;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
        
        CGContextBeginPath(context);
        CGRect rect = CGRectMake(0, 0, w, h);
        addRoundedRectToPath(context, rect, pSize.width * screenScale, pSize.height * screenScale);
        
        CGContextClosePath(context);
        CGContextClip(context);
        
        CGContextDrawImage(context, CGRectMake(0, 0, w, h), pImage.CGImage);
        CGImageRef imageMasked = CGBitmapContextCreateImage(context);
        CGContextRelease(context);
        CGColorSpaceRelease(colorSpace);
        
        newImage = [UIImage imageWithCGImage:imageMasked];
        CGImageRelease(imageMasked);
        
    }
    
    return newImage;

}

+ (UIImage *)imageWithRoundCorner:(UIImage*)pImage andCornerSize:(CGSize)pSize
{
    return [UIImage imageWithRoundCorner: pImage 
                           andCornerSize: pSize 
                              andScaleUp: NO];
}

@end
