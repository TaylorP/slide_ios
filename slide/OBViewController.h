//
//  OBViewController.h
//  slide
//
//  Created by Taylor Petrick on 12-06-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "OBBorderedButton.h"
#import "OBTimerView.h"
#import "OBTileGridView.h"
#import "OBSwitchView.h"
#import "MBProgressHUD.h"
#import "OBCompleteHUD.h"
#import "OBGameCenter.h"
#import "OBPageStreamView.h"

@interface OBViewController : UIViewController<OBSwitchViewDelegate, OBTileGridViewDelegate, MBProgressHUDDelegate, GameCenterManagerDelegate>
{
    ///The progress hud for displaying lock notifications 
    MBProgressHUD *mLockHUD;

    ///The progress hud for displaying shuffle notifications 
    MBProgressHUD *mShuffleHUD;
    
    ///The progress hud for displaying loading notifications
    MBProgressHUD *mLoadingHUD;
    
    OBCompleteHUD *mCompleteHUD;
    
    OBPageStreamView* streamView;
    
    UIButton* flipBackButton;
    UIButton* slideBackButton;
    
    BOOL mBlockLock;
}
-(void)initMainGrid;
@property (nonatomic, retain) IBOutlet UIView* gameView;
@property (nonatomic, retain) IBOutlet UIImageView* tutorialView;
@property (nonatomic, retain) IBOutlet UIView* settingsView;
@property (nonatomic, retain) IBOutlet UIView* imagesView;

@property (nonatomic, retain) IBOutlet UILabel* statusLabel;
@property (nonatomic, retain) IBOutlet UIButton* flipButton;
@property (nonatomic, retain) IBOutlet UIButton* backButton;
@property (nonatomic, retain) IBOutlet UIButton* gridButton;
@property (nonatomic, retain) IBOutlet OBSwitchView* soundSwitch;
@property (nonatomic, retain) IBOutlet OBSwitchView* gridSwitch;
@property (nonatomic, retain) IBOutlet OBSwitchView* gameSwitch;
@property (nonatomic, retain) IBOutlet OBBorderedButton* libraryButton;


@end
