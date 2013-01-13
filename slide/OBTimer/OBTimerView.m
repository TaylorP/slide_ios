//
//  OBTimerView.m
//  slide
//
//  Created by Taylor Petrick on 12-06-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBTimerView.h"

@implementation OBTimerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, frame.size.height)];
        [timeLabel setTextColor:[UIColor whiteColor]];
        [timeLabel setAlpha:0.75f];
        [timeLabel setText:@"0:00"];
        [timeLabel setBackgroundColor:[UIColor clearColor]];
        [timeLabel setFont:[UIFont boldSystemFontOfSize:18.0f]];
        [timeLabel setTextAlignment:UITextAlignmentCenter];
        [self addSubview:timeLabel];
        
        timer = [[OBTimer alloc] init];
        timer.delegate = self;
        
    }
    return self;
}

-(void)startTimer
{
    timer.paused = NO;
}

-(void)stopTimer
{
    timer.paused = YES;
}

-(void)clearTimer
{
    [timer clearTimer];
}

-(void)didTickTimer:(NSString *)clockString
{
    [timeLabel setText:clockString];
}
-(NSString*)getTime
{
    return [timeLabel text];
}

-(int)getIntTime
{
    return [timer getIntTime];
}

@end
