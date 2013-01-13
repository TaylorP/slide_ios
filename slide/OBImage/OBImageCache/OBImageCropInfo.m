/*
 *
 *  OBImage/OBImageCropInfo.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBImageCropInfo.h"

@implementation OBImageCropInfo
@synthesize oCropRect, oSourceImageName, oCropID;

-(void)dealloc
{
    [oSourceImageName release];    
    [super dealloc];
}

@end
