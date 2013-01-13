//
//  OBCompleteHUD.m
//  slide
//
//  Created by Taylor Petrick on 2012-08-10.
//
//

#import "OBCompleteHUD.h"

@implementation OBCompleteHUD
@synthesize cancelable;

- (id)initWithView:(UIView *)view
{
    self = [super initWithView:view];
    
    if (self)
    {
        self.mode = MBProgressHUDModeCustomView;
        
        UIView* lCustomView = [[UIView alloc] initWithFrame:CGRectMake(0,0,110,130)];
        UIImageView* comImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OBCheck.png"]];
        [lCustomView addSubview:comImage];
        [comImage setFrame:CGRectMake(21, 5, 68, 67)];
        [comImage release];
        
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 90, 110, 20)];
        [timeLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setText:@"time: 00:00"];
        [timeLabel setTextColor:[UIColor whiteColor]];
        [timeLabel setTextAlignment:UITextAlignmentCenter];
        [lCustomView addSubview:timeLabel];
        
        movesLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 110, 110, 20)];
        [movesLabel setFont:[UIFont boldSystemFontOfSize:14.0f]];
        [movesLabel setBackgroundColor:[UIColor clearColor]];
        [movesLabel setText:@"moves: 0"];
        [movesLabel setTextColor:[UIColor whiteColor]];
        [movesLabel setTextAlignment:UITextAlignmentCenter];
        [lCustomView addSubview:movesLabel];
        
        self.customView = lCustomView;
        [lCustomView release];
    }
    
    return self;
}

-(void)dealloc
{
    [movesLabel release];
    [timeLabel release];
    
    [super dealloc];
}

-(void)setMoveCount:(NSInteger)count andTimeString:(NSString*)time
{
    [movesLabel setText:[NSString stringWithFormat:@"moves: %i",count]];
    [timeLabel setText:[NSString stringWithFormat:@"time: %@",time]];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (cancelable)
    {
        [self hide:YES];
        cancelable = NO;
    }
}

@end
