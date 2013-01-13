/*
 *
 *  OBImage/UIImage+Crop.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>

///Category that adds cropping functionality to UIImage
@interface UIImage (Crop)

///Crops an image based on the input rectangle
- (UIImage *)crop:(CGRect)pRect;

///Scales an image to a given size
- (UIImage *)resize:(CGSize)pSize;

@end
