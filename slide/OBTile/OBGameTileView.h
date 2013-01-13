/*
 *
 *  OBTile/OBGameTileView.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>
#import "OBImageCropInfo.h"
#import "OBTileView.h"

@class OBGameTileView;

///Delegate for sending events back to the parent view
@protocol OBGameTileViewDelegate 

///Posted when a tile is successfully slid
-(void)didSlide;

///Posted when a tile triggers a locked state move
-(void)didLockedSlideStart;

///Posted when a tile completes a locked state move
-(void)didLockedSlideEnd;

///Requests the delegate to provide the current active tile, if any
-(OBGameTileView*)getActiveTile;

///Sets the active tile in the delegate
-(void)setActiveTile:(OBGameTileView*)tile;

@end



///A view implementation for displaying a picture tile controlled by a tile model
@interface OBGameTileView : OBTileView

///Sets the tile's image contents and tile size
- (void)setBackgroundImage:(OBImageCropInfo*)pCropInfo withTileSize:(OBTileSize)pTileSize;

///The tile's delegate
@property (nonatomic, assign) id<OBGameTileViewDelegate> delegate;

@end
