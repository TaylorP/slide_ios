/*
 *
 *  OBTile/OBGameTileView.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBGameTileView.h"
#import "OBImageManager.h"
#import "UIImage+WhiteBox.h"

@interface OBGameTileView ()
{
    UIImageView* tileBackground;
    UIImageView* tileContents;
    
    BOOL hasLockSlid;
}

- (BOOL)shouldProcessTouch;

@end

@implementation OBGameTileView
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        tileBackground = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [tileBackground setAlpha:0.85f];
        [self addSubview:tileBackground];
        
        tileContents   = [[UIImageView alloc] initWithFrame:CGRectMake(2, 2, 94, 94)];
        [self addSubview:tileContents];
    }
    return self;
}

-(void)dealloc
{
    [tileBackground release];
    [tileContents release];
    
    self.delegate = nil;
    
    [super dealloc];
}

- (void)setBackgroundImage:(OBImageCropInfo*)pCropInfo withTileSize:(OBTileSize)pTileSize
{    
    [tileBackground setImage:[OBImageManager tileBackgroundImageForSize:pTileSize]];
    [tileContents setImage:[OBImageManager tileForegroundImageForCropInfo:pCropInfo]];
}

-(BOOL)shouldProcessTouch
{
    if ([delegate getActiveTile] != nil) 
    {
        if([delegate getActiveTile] != self)
        {
            return NO;
        }
    }
    else 
    {
        [delegate setActiveTile:self];
    }
    
    if (![self.tileModel isEnabled] || [self.tileModel isEmptyCell]) 
    {
        return NO;
    }
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self shouldProcessTouch]) 
    {
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    [self.tileModel beginSlideWithPoint:touchPoint andFrame:self.frame];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self shouldProcessTouch]) 
    {
        if(!hasLockSlid)
        {
            if ([delegate getActiveTile] == self) 
            {
                [self.delegate didLockedSlideStart];
                hasLockSlid = YES;
            }

        }
        return;
    }
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.superview];
    
    [self.tileModel moveSlideWithPoint:touchPoint];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (![self shouldProcessTouch]) 
    {
        if ([delegate getActiveTile] == self) 
        {
            hasLockSlid = NO;
            [self.delegate didLockedSlideEnd];
            [delegate setActiveTile:nil];
        }
        
        return;
    }
    
    [self.tileModel endSlide];
    [self.delegate didSlide];
    [delegate setActiveTile:nil];
}



@end
