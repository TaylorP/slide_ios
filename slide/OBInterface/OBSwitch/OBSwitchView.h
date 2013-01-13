/*
 *
 *  OBInterface/OBSwitch/OBSwitchView.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>
#import "OBSwitchButton.h"

@class OBSwitchView;

///Delegate method for returning changes in the switch's state
@protocol OBSwitchViewDelegate <NSObject>

///Called when a given switch changes states to the state isOn
-(void)didSetState:(BOOL)pIsOn forSwitch:(OBSwitchView*)pSwitch;

@end


///A simple switch view with custom graphics
@interface OBSwitchView : UIView
{    
    ///The switch slider/button control
    OBSwitchButton* mSwitchButton;
    
    ///The frame for the button to take in the On state
    CGRect  mOnFrame;
    
    ///The frame for the button to take in the Off state
    CGRect  mOffFrame;
    

    ///The move delta during sliding
    CGPoint mDelta;
    
    ///The original position before sliding
    CGPoint mOriginalPos;
    
    ///The last moved position
    CGPoint mLastPoint;
    
    ///The last switch state
    BOOL    mLastState;
}

///Sets the state of the switch
- (void)setOn:(BOOL)pIsOn withAnimation:(BOOL)pIsAnimated;

///Forces the switch to update it's state
- (void)update;


///The delegate object for this switch
@property (nonatomic, assign) id<OBSwitchViewDelegate> oDelegate;

///The value of this switch
@property (nonatomic, assign) NSInteger oSwitchValue; 

///The string to display for the On state
@property (nonatomic, retain) NSString* oOnString;

///The string to display for the Off state
@property (nonatomic, retain) NSString* oOffString;

@end
