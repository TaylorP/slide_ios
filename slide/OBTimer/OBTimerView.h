//
//  OBTimerView.h
//  slide
//
//  Created by Taylor Petrick on 12-06-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OBTimer.h"

@interface OBTimerView : UIView <OBTimerDelegate>
{
    OBTimer* timer;
    UILabel* timeLabel;
}

-(void)startTimer;
-(void)stopTimer;
-(void)clearTimer;
-(NSString*)getTime;
-(int)getIntTime;
@end
