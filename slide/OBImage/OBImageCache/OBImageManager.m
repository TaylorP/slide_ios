/*
 *
 *  OBImage/OBImageManager.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBImageManager.h"
#import "OBImageCache.h"
#import "OBImageCacheConfig.h"
#import "OBGameModel.h"

#import "UIImage+RoundCorner.h"
#import "UIImage+WhiteBox.h"
#import "UIImage+Gradient.h"
#import "UIImage+Crop.h"

@implementation OBImageManager

+ (UIImage*)tileBackgroundImageForSize:(OBTileSize)pSize
{
    NSString* imageName = [NSString stringWithFormat: kOBTileImageNameFormat,pSize];
    UIImage* image = [[OBImageCache globalCache] getImage: imageName];
    
    if(image == nil)
    {
        if (pSize == eTileSizeLarge) 
        {
            image = [UIImage roundWhiteBoxWithSize: CGSizeMake(pSize, pSize) 
                                     andCornerSize: CGSizeMake(kOBLargeTileCornerSize, kOBLargeTileCornerSize)];
        }
        else if(pSize == eTileSizeSmall)
        {
            image = [UIImage roundWhiteBoxWithSize: CGSizeMake(pSize, pSize) 
                                     andCornerSize: CGSizeMake(kOBSmallTileCornerSize, kOBSmallTileCornerSize)];
        }
        
        [[OBImageCache globalCache] storeImage: image byName: imageName];
    }
    
    return image;
}

+ (UIImage*)tileForegroundImageForCropInfo: (OBImageCropInfo*)pCropInfo
{
   NSNumber* xWidth = [NSNumber numberWithFloat: pCropInfo.oCropRect.size.width];
   NSNumber* yWidth = [NSNumber numberWithFloat: pCropInfo.oCropRect.size.height];

   
    NSString* imageName = [NSString stringWithFormat: kOBTileContentNameFormat,
                                                                    pCropInfo.oSourceImageName,
                                                                    [xWidth intValue],
                                                                    [yWidth intValue],
                                                                    pCropInfo.oCropID];
    
    UIImage* image = [[OBImageCache globalCache] getImage: imageName];
    
    if (image == nil) 
    {
        UIImage* sourceImage = nil;
        if ([[OBGameModel sharedInstance] getIsCustomImage] == YES)
        {
            sourceImage = [[OBImageCache globalCache] getImage: pCropInfo.oSourceImageName];
        }
        else
        {
            sourceImage = [UIImage imageNamed: pCropInfo.oSourceImageName];
        }
        
        image = [UIImage imageWithRoundCorner: [sourceImage crop:pCropInfo.oCropRect]
                                andCornerSize: CGSizeMake(4.0f, 4.0f)];
        
        [[OBImageCache globalCache] storeImage: image byName: imageName];
    }
    
    return image;
}

+ (UIImage*)previewBackgroundImageForSize:(CGSize)pSize;
{
    NSString* imageName = [NSString stringWithFormat: kOBPreviewImageNameFormat,pSize.width,pSize.height];
    UIImage* image = [[OBImageCache globalCache] getImage: imageName];
    
    if (image == nil) 
    {
        image = [UIImage roundWhiteBoxWithSize: pSize 
                                 andCornerSize: CGSizeMake(kOBPreviewCornerSize, kOBPreviewCornerSize)];
        
        [[OBImageCache globalCache] storeImage: image 
                                        byName: imageName];
    }
    
    return image;
}

+ (UIImage*)buttonEdgeImageForSize: (CGSize)pSize
{
    NSString* imageName = [NSString stringWithFormat: kOBButtonEdgeImageNameFormat,pSize.width,pSize.height];
    UIImage* image = [[OBImageCache globalCache] getImage: imageName];
    
    if(image == nil)
    {
        image = [UIImage roundWhiteOutlineWithSize: pSize
                                      andThickness: kOBButtonEdgeThickness 
                                     andCornerSize: CGSizeMake(kOBButtonCornerSize, kOBButtonCornerSize)];
        
        [[OBImageCache globalCache] storeImage: image 
                                        byName: imageName];
    }
    
    return image;
}

+ (UIImage*)switchEdgeImageForSize:(CGSize)pSize
{
    NSString* imageName = [NSString stringWithFormat: kOBSwitchEdgeImageNameFormat,pSize.width,pSize.height];
    UIImage* image = [[OBImageCache globalCache] getImage: imageName];
    
    if(image == nil)
    {
        image = [UIImage roundWhiteOutlineWithSize: pSize
                                      andThickness: kOBSwitchEdgeThickness 
                                     andCornerSize: CGSizeMake(kOBSwitchCornerSize, kOBSwitchCornerSize)];
        
        [[OBImageCache globalCache] storeImage: image 
                                        byName: imageName];
    }
    
    return image;
}

+ (UIImage *)switchControlImageForSize:(CGSize)pSize
{
    NSString* imageName = [NSString stringWithFormat: kOBSwitchControlImageNameFormat,pSize.width,pSize.height];
    UIImage* image = [[OBImageCache globalCache] getImage: imageName];
    
    if(image == nil)
    {
        image = [UIImage roundWhiteBoxWithSize: pSize 
                                 andCornerSize: CGSizeMake(kOBSwitchCornerSize, kOBSwitchCornerSize)];
        
        [[OBImageCache globalCache] storeImage: image 
                                        byName: imageName];
    }
    
    return image;
}

+ (UIImage*)orangeGradientForRect:(CGRect)pRect
{
    NSString* imageName = [NSString stringWithFormat: kOBOrangeGradientImageNameFormat,pRect.size.width,pRect.size.height];
    UIImage* image = [[OBImageCache globalCache] getImage: imageName];
    
    if(image == nil)
    {
        CGColorRef topColor = [UIColor colorWithRed: 1.0f 
                                              green: 188.0f/255.0f 
                                               blue:  44.0f/255.0f 
                                              alpha: 1.0f].CGColor; 
        
        CGColorRef bottomColor = [UIColor colorWithRed: 225.0f/255.0f 
                                                 green: 125.0f/255.0f 
                                                  blue: 0.0f 
                                                 alpha: 1.0f].CGColor;
        
        image = [UIImage gradientImageWithStartColor: bottomColor 
                                         andEndColor: topColor 
                                             andRect: pRect];
        
        [[OBImageCache globalCache] storeImage: image 
                                        byName: imageName];
    }
    
    return image;
}

@end
