/*
 *
 *  OBTile/OBTileDirection.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

///A general purpose enumeration for spacial relationships between tiles.
enum
{
    ///The tile to the left
    eTileLeft   = 0,
    
    ///The tile above
    eTileTop    = 1,
    
    ///The tile to the right
    eTileRight  = 2,
    
    ///The tile below
    eTileBottom = 3
};

///Utility type definition for storing tile direction
typedef NSInteger OBTileDirection;
