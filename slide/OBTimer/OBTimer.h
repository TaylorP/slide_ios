//
//  OBTimer.h
//  slide
//
//  Created by Taylor Petrick on 12-06-24.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OBTimerDelegate <NSObject>
-(void)didTickTimer:(NSString*)clockString;
@end

@interface OBTimer : NSObject
{
    NSInteger totalTime;
    NSTimer*  timer;
}

-(void)clearTimer;
-(int)getIntTime;
@property (nonatomic) BOOL paused;
@property (nonatomic, retain) id<OBTimerDelegate> delegate;
@end
