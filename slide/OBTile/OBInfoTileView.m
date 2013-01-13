/*
 *
 *  OBTile/OBInfoTileView.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBInfoTileView.h"

@implementation OBInfoTileView
@synthesize delegate;

- (id)initWithFrame: (CGRect)pFrame
{
    self = [super initWithFrame:pFrame];

    return self;
}

-(void)dealloc
{
    self.delegate = nil;
    
    [super dealloc];
}

- (void)setupAsCheck
{
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [checkButton setFrame: CGRectMake(0, 0, 98, 98)];
    [checkButton setImage:[UIImage imageNamed:@"OBComplete_n.png"] forState:UIControlStateNormal];
    [checkButton setImage:[UIImage imageNamed:@"OBComplete_h.png"] forState:UIControlStateHighlighted];
    
    [self addSubview:checkButton];
    
    [UIView animateWithDuration: 0.3 
                     animations: ^(void){   [self setAlpha:1.0f];  }
     ];
}

- (void)setupAsShuffle
{
    UIButton *shuffleButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [shuffleButton setFrame: CGRectMake(0, 0, 98, 98)]; 
    [shuffleButton setImage:[UIImage imageNamed:@"OBShuffle_n.png"] forState:UIControlStateNormal];
    [shuffleButton setImage:[UIImage imageNamed:@"OBShuffle_h.png"] forState:UIControlStateHighlighted];
    [shuffleButton addTarget:self action:@selector(shufflePressed:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shuffleButton];
}

- (void)clear
{
    for (int i =0; i<[self.subviews count]; i++) 
    {
        [[self.subviews objectAtIndex:i] removeFromSuperview];
    }
}

- (void)shufflePressed: (id)pSender
{
    [UIView animateWithDuration: 0.3 
                     animations: ^(void){   [self setAlpha:0.0f];   }
                     completion: ^(BOOL completion){    [delegate didShuffle];  }
     ];
    
}

@end
