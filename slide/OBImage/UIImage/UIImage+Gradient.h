/*
 *
 *  OBImage/UIImage+Gradient.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>

///Category that adds gradient generation functionality to UIImage
@interface UIImage (Gradient)

///Produces a linear gradient with a start and end color, in a given region
+ (UIImage*)gradientImageWithStartColor:(CGColorRef)pStartColor andEndColor:(CGColorRef)pEndColor andRect:(CGRect)pRect;

@end
