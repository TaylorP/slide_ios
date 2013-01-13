/*
 *
 *  OBImage/OBImageCropInfo.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>

///A utility class for containing the information needed to crop and store a tile image
@interface OBImageCropInfo : NSObject
{
}

///The source image name to crop
@property (nonatomic, retain) NSString* oSourceImageName;

///The CGRect representing the crop area
@property (nonatomic, assign) CGRect    oCropRect;

///The unique ID representing the tile's position
@property (nonatomic, assign) NSInteger oCropID;

@end
