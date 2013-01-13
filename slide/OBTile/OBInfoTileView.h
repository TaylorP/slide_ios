/*
 *
 *  OBTile/OBInfoTileView.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>
#import "OBTileView.h"

///Delegate for sending events back to the parent view
@protocol OBInfoTileViewDelegate 

///Posted when the shuffle button is pressed
-(void)didShuffle;

@end


///A view implemententation for displaying puzzle controls and information. This tile sits in the empty tile slot.
@interface OBInfoTileView : OBTileView

///Clears the tile and sets it up to display the shuffle control
- (void)setupAsShuffle;

///Clears the tile and sets it up to display the checkmark control
- (void)setupAsCheck;

///Clears the tile
- (void)clear;

///The delegate for this tile
@property (nonatomic, assign) id<OBInfoTileViewDelegate> delegate;

@end
