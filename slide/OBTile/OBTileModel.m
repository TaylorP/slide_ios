/*
 *
 *  OBTile/OBTileModel.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBTileModel.h"
#import "OBSound.h"

@implementation OBTileModel
@synthesize delegate;
@synthesize enabled, emptyCell;
@synthesize lastFrame;

- (id)init
{
    self = [super init];
    
    if (self != nil) 
    {
        self.emptyCell = NO;
        self.enabled   = NO;
    }
    
    return self;
}

- (void)dealloc
{    
    self.delegate = nil;
    
    [super dealloc];
}

- (OBTileModel*)getTileAtIndex: (OBTileDirection)pIndex
{
    NSAssert( (pIndex >= 0 && pIndex <= 3) , @"Invalid tile index - %i", pIndex);
    
    return mNeighbourTiles[pIndex];
}

- (void)setTile:(OBTileModel*)pTile atIndex:(OBTileDirection)pIndex
{
    NSAssert( (pIndex >= 0 && pIndex <= 3) , @"Invalid tile index - %i", pIndex);
    
    mNeighbourTiles[pIndex] = [pTile retain];
}

- (BOOL)canSlideInDirection: (OBTileDirection)pDirection
{
    NSAssert( (pDirection >= 0 && pDirection <= 3) , @"Invalid tile direction - %i", pDirection);
    
    if ( [self isEmptyCell] ) 
    {
        return YES;
    }
    
    if( mNeighbourTiles[pDirection] != nil && [mNeighbourTiles[pDirection] canSlideInDirection:pDirection])
    {
        return YES;
    }
    
    return NO;
}

- (void)slideInDirection: (OBTileDirection)pDirection withDelta: (CGPoint)pDelta
{
    NSAssert( (pDirection >= 0 && pDirection <= 3) , @"Invalid tile direction - %i", pDirection);
    
    if([self isEmptyCell])
    {
        return;
    }
    else 
    {        
        if( fabs(mSlideAmount) <= 0 )
        {
            mSlideFrame = self.lastFrame;
        }
        
        mSlideDirection = pDirection;
        mSlideAmount += pDelta.x + pDelta.y;
        
        if(mNeighbourTiles[pDirection] != nil)
        {
            [mNeighbourTiles[pDirection] slideInDirection:pDirection withDelta:pDelta];
        }
        
        if (fabs(mSlideAmount) > 104) 
        {
            return;
        }
        
        mSlideFrame = CGRectOffset(mSlideFrame, pDelta.x, pDelta.y);
        [self.delegate didSlideWithFrame:mSlideFrame isAnimated:NO];
    }
}

-(void)unslideInDirection: (OBTileDirection)pDirection
{
    NSAssert( (pDirection >= 0 && pDirection <= 3) , @"Invalid tile direction - %i", pDirection);
    
    if([self isEmptyCell])
    {
        return;
    }
    else 
    {
        if(mNeighbourTiles[pDirection] != nil)
            [mNeighbourTiles[pDirection] unslideInDirection:pDirection];
        
        [self.delegate didSlideWithFrame:self.lastFrame isAnimated:YES];
        
        mSlideAmount = 0;
    }
}

-(void)swapInDirection: (OBTileDirection)pDirection
{
    NSAssert( (pDirection >= 0 && pDirection <= 3) , @"Invalid tile direction - %i", pDirection);
    
    if( [self isEmptyCell])
        return;
    
    [[OBSound sharedInstance] playRandomSound];
    if(mNeighbourTiles[pDirection] != nil)
        [mNeighbourTiles[pDirection] swapInDirection:pDirection];
    
    OBTileModel* swapDest = mNeighbourTiles[pDirection];
    OBTileModel* dstCells[4];
    OBTileModel* srcCells[4];
    
    for(int i =0; i<4; i++)
    {
        dstCells[i] = [swapDest getTileAtIndex:i];
        srcCells[i] = [self getTileAtIndex:i];
    }
    
    for(int i =0; i<4; i++)
    {
        if (dstCells[i] == self) 
        {
            [self setTile:swapDest atIndex:i];
        }
        else 
        {
            [self setTile:dstCells[i] atIndex:i];
            [dstCells[i] setTile:self atIndex:((i+2)%4)];
        }
        
        if(srcCells[i] == swapDest)
        {
            [swapDest setTile:self atIndex:i];
        }
        else 
        {
            [swapDest setTile:srcCells[i] atIndex:i];
            [srcCells[i] setTile:swapDest atIndex:((i+2)%4)];
        }
    }
    
    
    CGRect swapFrame = swapDest.lastFrame;
    CGRect selfFrame = self.lastFrame;
    
    [self.delegate didSlideWithFrame:swapFrame isAnimated:YES];
    [swapDest.delegate didSlideWithFrame:selfFrame isAnimated:YES];
    
    [self setLastFrame:swapFrame];
    [swapDest setLastFrame:selfFrame];
    
    mSlideAmount = 0;
}


- (void)beginSlideWithPoint:(CGPoint)pPoint andFrame:(CGRect)pFrame
{
    self.lastFrame   = pFrame;
    
    mSlideFrame      = lastFrame;
    mSlidePoint      = pPoint;
    mSlideAmount     = 0.0f;
    mSlideDirection  = -1;
}

- (void)moveSlideWithPoint:(CGPoint)pPoint
{
    CGPoint delta = CGPointMake(pPoint.x - mSlidePoint.x, pPoint.y - mSlidePoint.y);
    OBTileDirection direction = -1;
     
    if (fabs(delta.x) > fabs(delta.y)) 
    {
        delta.y = 0;
        
        if(delta.x < 0)
        {
            direction = eTileLeft;
        }
        else 
        {
            direction = eTileRight;
        }
    }
    else 
    {
        delta.x = 0;
        
        if(delta.y < 0)
        {
            direction = eTileTop;
        }
        else 
        {
            direction = eTileBottom;
        }
    }
     
    if ([self canSlideInDirection:direction]) 
    {
        [self slideInDirection:direction withDelta:delta];
    }
    
    mSlidePoint = pPoint;
}

-(void)endSlide
{
    [self endSlide:NO];
}

- (void)endSlide: (BOOL)skipTap
{
    if (mSlideDirection >= 0) 
    {
        if (fabs(mSlideAmount) > 50)
        {
            [self swapInDirection:mSlideDirection];
        }
        else
        {
            [self unslideInDirection:mSlideDirection];
        }
    }
    else if (!skipTap)
    {
        for(int i =0; i<4; i++)
        {
            if ([self canSlideInDirection:i])
            {
                [self swapInDirection:i];
                break;
            }
        }
    }
    
    
    mSlideDirection = -1;
    mSlideAmount = 0;
}

- (void)setAlpha:(CGFloat)pAlpha
{
    [self.delegate didChangeAlpha:pAlpha];
}

@end
