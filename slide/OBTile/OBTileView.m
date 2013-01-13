/*
 *
 *  OBTile/OBTileView.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBTileView.h"

@implementation OBTileView
@synthesize tileModel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    return self;
}

-(void)dealloc
{
    [super dealloc];
}

- (void)didSlideWithFrame:(CGRect)pFrame isAnimated:(BOOL)pAnimated;
{
    if (pAnimated) 
    {
        [UIView animateWithDuration: 0.1f
                              delay: 0.0f 
                            options: UIViewAnimationCurveLinear 
                         animations: ^(void){   [self setFrame:pFrame];    }
                         completion: nil 
         ];
    }
    else 
    {
        [self setFrame:pFrame];
    }
}

- (void)didChangeAlpha:(CGFloat)pAlpha
{
    [self setAlpha:pAlpha];
}


@end
