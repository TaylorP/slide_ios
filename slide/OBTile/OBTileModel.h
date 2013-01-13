/*
 *
 *  OBTile/OBTileModel.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>
#import "OBTileDirection.h"

///A delegate protocol for the the tile model to handle callbacks. 
@protocol OBTileModelDelegate

///Called when a tile should "slide" by changing it's frame
- (void)didSlideWithFrame:(CGRect)pFrame isAnimated:(BOOL)pAnimated;

///Called when a tile should change it's alpha
- (void)didChangeAlpha:(CGFloat)pAlpha;

@end


///A model for storing tile state and handling interactions between tiles
@interface OBTileModel : NSObject
{
    ///The neighbouring tiles to this tile
    OBTileModel* mNeighbourTiles[4];
    
    ///The frame of the tile as it is being slid
    CGRect      mSlideFrame;
    ///The last point recorded during the slide
    CGPoint     mSlidePoint;
    ///The total distance the tile has slid as a scalar
    CGFloat     mSlideAmount;
    
    ///The direction the tile is sliding in
    OBTileDirection   mSlideDirection;
}

///Called from the View when a tile should begin sliding, with initial point and frame
- (void)beginSlideWithPoint: (CGPoint)point andFrame: (CGRect)frame;

///Called from the View when a tile has slid to a new point
- (void)moveSlideWithPoint: (CGPoint)point;

///Called from the View when a tile has stopped sliding
- (void)endSlide;
- (void)endSlide: (BOOL)skipTap;


///Gets the neighbour tile at a given index
- (OBTileModel*)getTileAtIndex: (OBTileDirection)pIndex;

///Sets the neighbour tile at a given index
- (void)setTile:(OBTileModel*)pTile atIndex:(OBTileDirection)pIndex;


///Determines whether or not the tile can slide in a given direction
- (BOOL)canSlideInDirection: (OBTileDirection)pDirection;

///Swaps the tile with its neighbouring tile in the given direction
- (void)swapInDirection: (OBTileDirection)pDirection;

///Slides the tile in the given direction by a delta
- (void)slideInDirection: (OBTileDirection)pDirection withDelta: (CGPoint)pDelta;

///Slides the tile back to it's initial position before sliding commenced
- (void)unslideInDirection: (OBTileDirection)pDirection;


///Sets the alpha of this tile
- (void)setAlpha:(CGFloat)pAlpha;


///The frame for the View of this tile before it began sliding
@property (nonatomic) CGRect lastFrame;

///The View delegate for this tile
@property (nonatomic, assign) id<OBTileModelDelegate> delegate;

///Boolean representing whether or not this tile shows up as an empty cell
@property (nonatomic, assign, getter = isEmptyCell) BOOL emptyCell;

///Boolean representing whether or no this tile is enabled for interaction
@property (nonatomic, assign, getter = isEnabled)   BOOL enabled;

@end
