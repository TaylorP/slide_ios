/*
 *
 *  OBInterface/OBButton/OBBorderedButton.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <UIKit/UIKit.h>

///A simple bordered button class that contains a single image button and line of text
@interface OBBorderedButton : UIView
{
    ///The main interactable region of the button, supporting a single image
    UIButton* mMainButton;
    
    ///The text region of the button
    UILabel*  mMainText;
}

///Sets the action for the button
- (void)setButtonAction:(id)pTarget action:(SEL)pAction forControlEvents:(UIControlEvents)pControlEvents;

///Sets the button image
- (void)setButtonImage:(UIImage*)pImage forState:(UIControlState)state;

///Sets the button text
- (void)setButtonText:(NSString*)pText;

@end
