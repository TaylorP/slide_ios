//
//  OBCompleteHUD.h
//  slide
//
//  Created by Taylor Petrick on 2012-08-10.
//
//

#import "MBProgressHUD.h"

@interface OBCompleteHUD : MBProgressHUD
{
    UILabel* movesLabel;
    UILabel* timeLabel;
}
-(void)setMoveCount:(NSInteger)count andTimeString:(NSString*)time;

@property (nonatomic, assign) BOOL cancelable;
@end
