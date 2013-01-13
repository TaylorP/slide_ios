//
//  OBTimer.m
//  slide
//
//  Created by Taylor Petrick on 12-06-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBTimer.h"

@implementation OBTimer

@synthesize delegate;
@synthesize paused;

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerTick) userInfo:nil repeats:YES];
        totalTime = 0;
        paused = YES;
    }
    
    return self;
}
                 
-(void)timerTick
{
    if (paused) 
    {
        return;
    }
    
    totalTime += 1;
    if (totalTime > 3599)
    {
        totalTime = 3599;
    }
    
    [delegate didTickTimer:[self stringForSeconds:totalTime]];
}

-(int)getIntTime
{
    return totalTime;
}

-(void)clearTimer
{
    totalTime = 0;
    [delegate didTickTimer:[self stringForSeconds:totalTime]];
}

-(NSString*)stringForSeconds:(int)time
{
    NSString* ret;
    
    if(time < 10)
    {
        ret = [NSString stringWithFormat:@"0:0%i",time];
    }
    else if(time < 60)
    {
        ret = [NSString stringWithFormat:@"0:%i",time];
    }
    else 
    {
        int min = time/60;
        if(time%60 < 10)
        {
            ret = [NSString stringWithFormat:@"%i:0%i",min,time%60];
        }
        else 
        {
            ret = [NSString stringWithFormat:@"%i:%i",min,time%60];
        }
    }
    
    return ret;
}


@end
