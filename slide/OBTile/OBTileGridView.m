/*
 *
 *  OBTile/OBTileGridView.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBTileGridView.h"
#import "OBTileModel.h"
#import "OBGameTileView.h"
#import "OBInfoTileView.h"
#import "OBImageCropInfo.h"
#import "UIImage+Crop.h"
#import "UIImage+RoundCorner.h"
#import "OBGameModel.h"

@implementation OBTileGridView
@synthesize delegate, gameTimer;

- (id)initWithFrame: (CGRect)pFrame
{
    self = [super initWithFrame: pFrame];
    
    if (self) 
    {
    }
    
    return self;
}

-(void)initGridWithSize: (NSInteger)gridSize
{
    mGridSize = gridSize;
    mActiveTile = nil;
    mMoveCount = 0;
    
    int height = gridSize == 0 ? 3 : 4;
    
    for(int i =0; i<height; i++)
    {
        for(int j =0; j<3; j++)
        {
            CGRect frame = CGRectMake(102*j+9, 102*i, 98, 98);
            NSInteger index = j+i*3;
            mCells[index] = [[OBTileModel alloc] init];
            
            if (index == height * 3 - 1) 
            {
                mInfoView = [[OBInfoTileView alloc] initWithFrame:frame];
                
                [mCells[index] setEmptyCell:YES];
                mCells[index].delegate = mInfoView;
                mCells[index].lastFrame = frame;
                
                mInfoView.delegate = self;
                [self addSubview:mInfoView];
                [mInfoView setupAsShuffle];
                [mInfoView release];
                
            }
            else
            {
                OBGameTileView* view = [[OBGameTileView alloc] initWithFrame:frame];
                
                view.tileModel = mCells[index];
                view.delegate = self;
                
                OBImageCropInfo* cropInfo = [[OBImageCropInfo alloc] init];
                cropInfo.oCropRect = CGRectMake(100*j + 9, 100*i, 94, 94);
                cropInfo.oSourceImageName = [[OBGameModel sharedInstance] getGameImage];
                cropInfo.oCropID = i*10 + j;
                
                [view setBackgroundImage:cropInfo withTileSize:eTileSizeLarge];
                [cropInfo release];
                
                mCells[index].delegate = view;
                mCells[index].lastFrame = frame;
                [self addSubview:view];
                [view release];
            }
        }
    }
    
    for(int i =0; i< height; i++)
    {
        for(int j =0; j<3; j++)
        {
            int index = i*3 + j;
            if(j > 0)
            {
                [mCells[index] setTile:mCells[index - 1] atIndex:eTileLeft];
            }
            
            if(j<2)
            {
                [mCells[index] setTile:mCells[index + 1] atIndex:eTileRight];
            }
            
            if(i > 0)
            {
                [mCells[index] setTile:mCells[index - 3] atIndex:eTileTop];
            }
            if(i<height-1)
            {
                [mCells[index] setTile:mCells[index + 3] atIndex:eTileBottom];
            }
        }
    }

}

-(void)dealloc
{    
    self.delegate = nil;

    [super dealloc];
}

-(OBGameTileView*)getActiveTile
{
    return mActiveTile;
}

-(void)setActiveTile:(OBGameTileView*)tile
{
    mActiveTile = tile;
}

-(void)didLockedSlideStart
{
    [delegate didStartLockSlide];
}

-(void)didLockedSlideEnd
{
    [delegate didStopLockSlide];
}

-(void)stabilize
{
    int height =  mGridSize == 0 ? 9 : 12;
    
    for(int i =0; i<height; i++)
    {
        [mCells[i] endSlide:YES];
    }
    
    [self setInteractionEnabled:NO];
}

-(void)didSlide
{
    mMoveCount++;
    NSLog(@"%i",mMoveCount);
    if ([self isSolved])
    {
        [self setInteractionEnabled:NO];
        [gameTimer stopTimer];
        [mInfoView clear];
        [mInfoView setupAsCheck];
        [self.delegate didComplete:mMoveCount];
        [UIView animateWithDuration:1.5 animations:^(void)
         {
             [mInfoView setAlpha:0.0f];
         }
         completion:^(BOOL finished)
         {
             [mInfoView clear];
             [mInfoView setupAsShuffle];
             
             [UIView animateWithDuration:1.0 animations:^(void)
              {
                  [mInfoView setAlpha:1.0f];
                  [gameTimer clearTimer];
              }
              ];
         }
         ];
    }
}

-(void)didShuffle
{
    mLastDirection = 0;
    mMixCount = 0;
    mMoveCount = 0;
    [self mixPuzzle];
    
    [delegate didStartShuffle];
}

-(void)setInteractionEnabled:(BOOL)pEnabled
{
    int cellCount = mGridSize == 0 ? 9 : 12;
    
    for (int i =0; i<cellCount; i++) 
    {
        [mCells[i] setEnabled:pEnabled];
    }
}

-(void)mixPuzzle
{
    int cellCount = mGridSize == 0 ? 9 : 12;
    
    int cell = arc4random()%(cellCount-1);
    int dir = arc4random()%4;
    
    while(dir%2 == mLastDirection%2 && arc4random()%100 < 80) 
    {
        dir = arc4random()%4;
    }
    
    if ([mCells[cell] canSlideInDirection:dir]) 
    {
        mLastDirection = dir;
        mMixCount++;
        if(mMixCount >= 50)
        {
            [self setInteractionEnabled:YES];
            [delegate didStopShuffle];
            return;
        }
        
        [mCells[cell] swapInDirection:dir];
        [self performSelector:@selector(mixPuzzle) withObject:nil afterDelay:0.12];
    }
    else
    {
        [self mixPuzzle];
    }
}

-(void)setAlphas:(CGFloat)pAlpha
{
    int cellCount = mGridSize == 0 ? 9 : 12;
    
    for (int i =0; i<cellCount-1; i++) 
    {
        [mCells[i] setAlpha:pAlpha];
    }
}

-(BOOL)isSolved
{    
    int height = mGridSize == 0 ? 3 : 4;
    
    for(int i =0; i<height; i++)
    {
        for(int j =0; j<3; j++)
        {
            int index = i*3 + j;
            if(j > 0)
            {
                if ([mCells[index] getTileAtIndex:eTileLeft] != mCells[index -1]) 
                {
                    return NO;
                }
            }
            
            if(j<2)
            {
                if ([mCells[index] getTileAtIndex:eTileRight] != mCells[index + 1]) 
                {
                    return NO;
                }
            }
            
            if(i > 0)
            {
                if ([mCells[index] getTileAtIndex:eTileTop] != mCells[index - 3]) 
                {
                    return NO;
                }
            }
            if(i<height-1)
            {
                if ([mCells[index] getTileAtIndex:eTileBottom] != mCells[index + 3]) 
                {
                    return NO;
                }
            }
        }
    }
    
    return YES;
}


@end
