/*
 *
 *  OBTile/OBTileSize.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>

///An enumeration for determing the tile size
enum
{
    ///Small tiles, for the 4x4 and 4x5 size grids
    eTileSizeSmall  = 75,
    
    ///Large tiles, for the 3x3 and 3x4 size grids
    eTileSizeLarge  = 98
};

///A utility type definition for storing tile size
typedef NSInteger OBTileSize;
