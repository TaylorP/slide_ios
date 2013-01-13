//
//  OBSwitchButton.h
//  slide
//
//  Created by Taylor Petrick on 12-07-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBSwitchButton : UIView
{
    UILabel* textLabel;
}
- (void)setTransistional:(BOOL)pTransistional;
- (void)setText:(NSString*)setText;
- (void)animateToFrame:(CGRect)frame;
@end
