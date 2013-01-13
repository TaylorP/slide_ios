/*
 *
 *  OBTile/OBTileView.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>
#import "OBTileModel.h"
#import "OBTileSize.h"

///A generic view for displaying tiles described by the tile model
@interface OBTileView : UIView <OBTileModelDelegate>
{
    
}

///The tile model corresponding to this view
@property (nonatomic, retain) OBTileModel* tileModel;

@end
