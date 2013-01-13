/*
 *
 *  OBImage/OBImageManager.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>
#import "OBImageCropInfo.h"
#import "OBTileSize.h"

///A utility class for retrieving and producing image components
@interface OBImageManager : NSObject
{    
}

///Returns the white background image used for tile cells for a given tile size
+ (UIImage*)tileBackgroundImageForSize: (OBTileSize)pSize;

///Returns a tile content image for a given crop info description
+ (UIImage*)tileForegroundImageForCropInfo: (OBImageCropInfo*)pCropInfo;


///Returns the white background used for the flip/preview for a given size
+ (UIImage*)previewBackgroundImageForSize: (CGSize)pSize;


///Returns the white edge used on buttons for a given size
+ (UIImage*)buttonEdgeImageForSize: (CGSize)pSize;


///Returns the white edge used on switches for a given size
+ (UIImage*)switchEdgeImageForSize: (CGSize)pSize;

///Returns the white button used on switches for a given size
+ (UIImage*)switchControlImageForSize: (CGSize)pSize;


///Returns the main background gradient for a given rect region
+ (UIImage*)orangeGradientForRect: (CGRect)pRect;

@end
