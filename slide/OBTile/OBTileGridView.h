/*
 *
 *  OBTile/OBTileGridView.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>
#import "OBInfoTileView.h"
#import "OBGameTileView.h"
#import "MBProgressHUD.h"
#import "OBTimerView.h"

///Delegate to pass information to the parent view
@protocol OBTileGridViewDelegate <NSObject>

-(void)didStartLockSlide;
-(void)didStopLockSlide;
///Posted when tile shuffling beginss
-(void)didStartShuffle;

///Posted when this shuffling finishes
-(void)didStopShuffle;

///Posted when the puzzle is completed
-(void)didComplete:(NSInteger)count;
@end



///The view for displaying the tile puzzle
@interface OBTileGridView : UIView<OBInfoTileViewDelegate, OBGameTileViewDelegate, MBProgressHUDDelegate>
{
    ///The cells in the grid
    OBTileModel* mCells[12];
    
    ///A reference to the info tile view
    OBInfoTileView* mInfoView;
    
    ///A reference to the current active tile
    OBGameTileView* mActiveTile;
    
    ///The last direction move for the shuffling process
    OBTileDirection mLastDirection;
    
    ///The total nummber of shuffling steps
    NSInteger mMixCount;
    
    ///The grid size
    NSInteger    mGridSize;
    
    NSInteger    mMoveCount;
}

///Sets up the grid with a given size
-(void)initGridWithSize: (NSInteger)gridSize;

///Sets interaction with the tiles to be enabled or disabled
-(void)setInteractionEnabled:(BOOL)pEnabled;

///SEts the alpha of the tiles
-(void)setAlphas:(CGFloat)pAlpha;

///Stabilize the playing field
-(void)stabilize;

///The delegate for this view
@property (nonatomic, assign) id<OBTileGridViewDelegate> delegate;

///The game timer
@property (nonatomic, retain) OBTimerView* gameTimer;

@end
