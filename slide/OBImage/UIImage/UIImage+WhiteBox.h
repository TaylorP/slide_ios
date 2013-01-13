/*
 *
 *  OBImage/UIImage+WhiteBox.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>

///Category for creating white UIImages with rounded corners
@interface UIImage (WhiteBox)

///Creates an white outline shaped UIImage with the given size and line thickness
+ (UIImage*)whiteOutlineWithSize:(CGSize)pSize andThickness:(CGFloat)pThickness;

///Creates an white outline shaped UIImage with round corner of a given size and line thickness
+ (UIImage*)roundWhiteOutlineWithSize:(CGSize)pSize andThickness:(CGFloat)pThickness andCornerSize:(CGSize)pCornerSize;

///Creates a solid white UIImage with the given size
+ (UIImage*)whiteBoxWithSize:(CGSize)pSize;

///Creates a solid white UIImage with rounded corners of a given size
+ (UIImage*)roundWhiteBoxWithSize:(CGSize)pSize andCornerSize:(CGSize)pCornerSize;

@end
