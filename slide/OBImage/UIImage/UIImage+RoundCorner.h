/*
 *
 *  OBImage/UIImage+RoundCorner.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>

///Category that adds corner rounding functionality to UIImage
@interface UIImage (RoundCorner)

///Rounds a UIImage with a given corner size
+ (UIImage *)imageWithRoundCorner:(UIImage*)pImage andCornerSize:(CGSize)pSize;

///Rounds a UIImage with a given corner size
+ (UIImage *)imageWithRoundCorner:(UIImage*)pImage andCornerSize:(CGSize)pSize andScaleUp:(BOOL)pScale;
@end
