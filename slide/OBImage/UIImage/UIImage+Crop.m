/*
 *
 *  OBImage/UIImage+Crop.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "UIImage+Crop.h"

@implementation UIImage (Crop)

- (UIImage *)crop:(CGRect)pRect 
{
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    
    if (screenScale>1.0) 
    {        
        pRect = CGRectMake(
                           pRect.origin.x * screenScale, 
                           pRect.origin.y * screenScale, 
                           pRect.size.width * screenScale, 
                           pRect.size.height * screenScale
                           );        
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self CGImage], pRect);
    UIImage *result = [UIImage imageWithCGImage: imageRef]; 
    CGImageRelease(imageRef);
    
    return result;
}

static inline double radians (double degrees) {return degrees * M_PI/180;}


- (UIImage*)resize:(CGSize)targetSize
{
    UIImage* sourceImage = self;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    
    CGImageRef imageRef = [sourceImage CGImage];
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
    
    if (bitmapInfo == kCGImageAlphaNone) {
        bitmapInfo = kCGImageAlphaNoneSkipLast;
    }
    
    CGContextRef bitmap;
    
    if (sourceImage.imageOrientation == UIImageOrientationUp || sourceImage.imageOrientation == UIImageOrientationDown) {
        bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    } else {
        bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
        
    }
    
    if (sourceImage.imageOrientation == UIImageOrientationLeft) {
        CGContextRotateCTM (bitmap, radians(90));
        CGContextTranslateCTM (bitmap, 0, -targetHeight);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationRight) {
        CGContextRotateCTM (bitmap, radians(-90));
        CGContextTranslateCTM (bitmap, -targetWidth, 0);
        
    } else if (sourceImage.imageOrientation == UIImageOrientationUp) {
        // NOTHING
    } else if (sourceImage.imageOrientation == UIImageOrientationDown) {
        CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
        CGContextRotateCTM (bitmap, radians(-180.));
    }
    
    CGContextDrawImage(bitmap, CGRectMake(0, 0, targetWidth, targetHeight), imageRef);
    CGImageRef ref = CGBitmapContextCreateImage(bitmap);
    UIImage* newImage = [UIImage imageWithCGImage:ref];
    CGImageRelease(ref);
    CGContextRelease(bitmap);
    
    return newImage; 
}

@end