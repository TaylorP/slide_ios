//
//  OBViewController.m
//  slide
//
//  Created by Taylor Petrick on 12-06-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBViewController.h"
#import "OBTileGridView.h"
#import "UIImage+Crop.h"
#import "UIImage+WhiteBox.h"
#import "UIImage+RoundCorner.h"
#import "OBImageCache.h"
#import "OBImageManager.h"
#import "OBUserPreferences.h"
#import "UIImage+Gradient.h"
#import "OBGameModel.h"

@interface OBViewController ()
{
    OBTimerView* gameTimer;
    OBTileGridView* tileView;
    UIImageView* backView;
    
    BOOL previewOpen;
    BOOL settingsOpen;
    BOOL libraryOpen;
    BOOL isPlaying;
    
    int mGridSize;
}
@end

@implementation OBViewController

@synthesize gameView, settingsView, imagesView, statusLabel, tutorialView;
@synthesize gridSwitch, soundSwitch, gameSwitch;
@synthesize flipButton, backButton, libraryButton, gridButton;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    gameTimer = [[OBTimerView alloc] initWithFrame:CGRectMake(120, 1, 80, 40)];
    [gameTimer setHidden:YES];
    [self.view addSubview:gameTimer];
        
    gameView.layer.masksToBounds = NO;
    gameView.layer.shadowOffset = CGSizeMake(0, -2);
    gameView.layer.shadowRadius = 6;
    gameView.layer.shadowOpacity = 0.0;
    gameView.layer.shadowPath = [UIBezierPath bezierPathWithRect:gameView.bounds].CGPath;
    gameView.layer.shadowColor = [UIColor blackColor].CGColor;
    
    [gameView insertSubview: [[[UIImageView alloc] initWithImage: [OBImageManager orangeGradientForRect:CGRectMake(0, 0, 320, 460)]] autorelease] atIndex:0];
    isPlaying = NO;
    previewOpen = NO;
    settingsOpen = NO;
    mBlockLock = YES;
    
    streamView = [[OBPageStreamView alloc] initWithFrame:CGRectMake(0, 0, 320, 230)];
    [streamView initAsImages];
    [streamView setViewController:self];
    [imagesView addSubview:streamView];
    
    flipBackButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [flipBackButton setFrame:CGRectMake(0, 40, 320, 420)];
    [flipBackButton addTarget:self action:@selector(flipPreview:) forControlEvents:UIControlEventTouchUpInside];
    [flipBackButton setBackgroundColor:[UIColor clearColor]];
    
    slideBackButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
    [slideBackButton setFrame:CGRectMake(0, 210, 320, 250)];
    [slideBackButton addTarget:self action:@selector(toggleSettings:) forControlEvents:UIControlEventTouchUpInside];
    [slideBackButton setBackgroundColor:[UIColor clearColor]];

    mLockHUD = [[MBProgressHUD alloc] initWithView:self.view];
    mLockHUD.delegate = self;
    mLockHUD.mode = MBProgressHUDModeCustomView;
    mLockHUD.customView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"OBLock"]] autorelease];
    [self.view addSubview:mLockHUD];
    [mLockHUD release];
    
    mCompleteHUD = [[OBCompleteHUD alloc] initWithView:self.view];
    mCompleteHUD.cancelable = NO;
    [self.view addSubview:mCompleteHUD];
    [mCompleteHUD release];
    
    mShuffleHUD = [[MBProgressHUD alloc] initWithView:self.view];
    mShuffleHUD.delegate = self;
    mShuffleHUD.labelText = @"shuffling";
    [self.view addSubview:mShuffleHUD];
    [mShuffleHUD release];
    
    mLoadingHUD = [[MBProgressHUD alloc] initWithView:self.view];
    mLoadingHUD.labelText = @"loading";
    [self.view addSubview:mLoadingHUD];
    [mLoadingHUD release];
    
    gridSwitch.oOffString = @"3x4";
    gridSwitch.oOnString = @"3x3";
    
    gridSwitch.oSwitchValue = [[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGridSwitch];
    soundSwitch.oSwitchValue = [[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceSoundSwitch];
    gameSwitch.oSwitchValue = [[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGameSwitch];
    
    gridSwitch.oDelegate = self;
    soundSwitch.oDelegate = self;
    gameSwitch.oDelegate = self;
    
    [gridSwitch update];
    [soundSwitch update];
    [gameSwitch update];
    
    [libraryButton setButtonImage:[UIImage imageNamed:@"OBLibrary_n.png"] forState:UIControlStateNormal];
    [libraryButton setButtonImage:[UIImage imageNamed:@"OBLibrary_h.png"] forState:UIControlStateHighlighted];
    [libraryButton setButtonAction:self action:@selector(toggleLibrary:) forControlEvents:UIControlEventTouchUpInside];
    [libraryButton setButtonText:@"library"];
    
    
    if ([[OBGameModel sharedInstance] getGameImage] == nil)
    {
        [tutorialView setHidden:NO];
    }
    else
    {
        [self initGridForSize:[[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGridSwitch]];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changedImage) 
                                                 name:@"GameModel_ImageChanged"
                                               object:nil];
    

    
}

-(void)loginDelayed
{
    if ([[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGameSwitch] == 0 )
    {
        [[OBGameCenter sharedInstance] loginUser];
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    [self performSelector:@selector(loginDelayed) withObject:self afterDelay:1.5];
}

-(void)changedImage
{
    if ([[OBGameModel sharedInstance] getGameImage] != nil)
    {
        isPlaying = NO;
        [gameTimer clearTimer];
        [gameTimer stopTimer];
        [gameTimer setHidden:YES];
    
        [self initGridForSize:[[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGridSwitch]];

    }
}

-(void)initMainGrid
{
    float height = mGridSize == 0 ? 90 : 45;
    
    CGRect frame = CGRectMake(0, height, 320, 430);
    tileView = [[OBTileGridView alloc] initWithFrame:frame];
    [tileView initGridWithSize:mGridSize];
    tileView.delegate = self;
    tileView.gameTimer = gameTimer;
    [tileView setAlpha:0.0f];
     
    CGRect bFrame = CGRectMake(10, 0, 300, 300 + mGridSize*100);
    backView = [[UIImageView alloc] initWithFrame:bFrame];
    [backView setImage:[OBImageManager previewBackgroundImageForSize:bFrame.size]];
     
    CGRect iFrame = CGRectMake(2.0f, 2.0f, 296.0f, 296.0f + mGridSize*100);

    UIImage* sourceImage;
    if ([[OBGameModel sharedInstance] getIsCustomImage] == YES)
    {
        sourceImage = [[OBImageCache globalCache] getImage: [[OBGameModel sharedInstance] getGameImage]];
    }
    else
    {
        sourceImage = [UIImage imageNamed: [[OBGameModel sharedInstance] getGameImage]];
    }
    
    UIImage* test = [UIImage imageWithRoundCorner:[sourceImage crop:iFrame]
                                     andCornerSize:CGSizeMake(4.0f, 4.0f)];
     
    UIImageView* view = [[UIImageView alloc] initWithFrame:iFrame];
    [view setImage: test];
    [backView addSubview:view];
    [backView setAlpha:0.0f];
    [view release];
         
    [gameView addSubview:tileView];
    [tileView release];
    
    previewOpen = NO;
    
    [UIView animateWithDuration:0.35 animations:^(void)
     {             
      [tileView setAlpha:1.0f];
      [backView setAlpha:1.0f];
     }
      completion:^(BOOL complete)
     {
         [mLoadingHUD hide:YES];
         [mLockHUD hide:YES];
         mBlockLock = NO;
     }];
}

-(void)initGridForSize:(NSInteger)gridSize
{
    [mLockHUD hide:NO];
    mBlockLock = YES;
    [mLoadingHUD show:YES];
    [tutorialView setHidden:YES];
    
    mGridSize = gridSize;
    if (tileView != nil) 
    {
        [UIView animateWithDuration:0.35 animations:^(void)
         {
             [tileView setAlpha:0.0f];
             [backView setAlpha:0.0f];
         }
         completion:^(BOOL completion)
         {
             [tileView removeFromSuperview];
             
             if (previewOpen)
             {
                 [flipButton setImage:[UIImage imageNamed:@"OBGlass_n"] forState:UIControlStateNormal];
                 [flipButton setImage:[UIImage imageNamed:@"OBGlass_h"] forState:UIControlStateHighlighted];
                 [backView removeFromSuperview];
             }
             
             [backView release];
             
             [self performSelector:@selector(initMainGrid)];
         }
         ];
    }
    else 
    {
        [self performSelector:@selector(initMainGrid)];
    }
}

-(void)dealloc
{
    [mLockHUD removeFromSuperview];
    [mShuffleHUD removeFromSuperview];
    [mLoadingHUD removeFromSuperview];
    [mCompleteHUD removeFromSuperview];
    
    [streamView removeFromSuperview];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}


-(void)dropFront
{
    [self.view addSubview:slideBackButton];
    [flipBackButton setFrame:CGRectOffset(flipBackButton.frame, 0.0f, 200.0f)];
    BOOL on = [[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGameSwitch] == 0;
    [gameSwitch setOn:on withAnimation:YES];
    
    gameView.layer.shadowOpacity = 0.6;
    [tileView setInteractionEnabled:NO];
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         CGRect newFrame = gameView.frame;
         
         [self.gameView setFrame:CGRectOffset(newFrame, 0.0f, 200.0f)];
         [gameTimer setAlpha:0.0f];
         [gameTimer stopTimer];
         [statusLabel setAlpha:0.0f];
         [flipButton setAlpha:0.0f];
     }
     
     completion:^(BOOL finished)
     {
         [statusLabel setText:@"settings"];
         [statusLabel setHidden:NO];
         [flipButton setHidden:YES];
         
         [UIView animateWithDuration:0.3 animations:^(void)
          {
              [statusLabel setAlpha:0.75f];
          }];
     }];
}

-(void)raiseFront
{
    [streamView clearButton];
    [slideBackButton removeFromSuperview];
    [flipBackButton setFrame:CGRectOffset(flipBackButton.frame, 0.0f, -200.0f)];
    
    if (isPlaying) 
    {
        [tileView setInteractionEnabled:YES];
    }
    
    [flipButton setHidden:NO];
    
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         CGRect newFrame = gameView.frame;
         
         [self.gameView setFrame:CGRectOffset(newFrame, 0.0f, -200.0f)];
         [statusLabel setAlpha:0.0f];
         [backButton setAlpha:0.0f];
     }
    completion:^(BOOL finished)
     {
         [statusLabel setText:@"game"];
         [settingsView setFrame:CGRectMake(0, 0, 320, 230)];
         libraryOpen = NO;
         [backButton setHidden:YES];
         [backButton setAlpha:1.0f];
         [imagesView setFrame:CGRectMake(320, 0, 320, 230)];
         
         if (isPlaying) 
         {
             [gameTimer startTimer];
             [statusLabel setHidden:YES];
         }
         [flipButton setHidden:NO];
         
         [UIView animateWithDuration:0.3 animations:^(void)
          {
              [gameTimer setAlpha:1.0f];
              [statusLabel setAlpha:0.75f];
              [flipButton setAlpha:0.75f];
          } completion:^(BOOL completion)
          {
              [gameTimer setAlpha:1.0f];
              [statusLabel setAlpha:0.75f];
              [flipButton setAlpha:0.75f];
              
          }];
     }];
}


-(void)slideSettingsOut
{
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         CGRect newFrame = settingsView.frame;
         [settingsView setFrame:CGRectOffset(newFrame, -320, 0)];
         [statusLabel setAlpha:0.0f];
     }
    completion:^(BOOL finished)
     {
         [statusLabel setText:@"library"];
         [backButton setHidden:NO];
         [backButton setAlpha:0.0f];
         [UIView animateWithDuration:0.2 animations:^(void)
          {
              [statusLabel setAlpha:0.75f];
              [backButton setAlpha:1.0f];
              
          }];
     }];
}

-(void)slideSettingsIn
{
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         CGRect newFrame = settingsView.frame;
         [settingsView setFrame:CGRectOffset(newFrame, 320, 0)];
         [statusLabel setAlpha:0.0f];
         [backButton setAlpha:0.0f];
     }
    completion:^(BOOL finished)
     {
         [backButton setHidden:YES];
         [backButton setAlpha:1.0f];
         [statusLabel setText:@"settings"];
         [UIView animateWithDuration:0.2 animations:^(void)
          {
              [statusLabel setAlpha:0.75f];
          }];
     }];
}

-(void)slideImagesOut
{
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         CGRect newFrame = imagesView.frame;
         [imagesView setFrame:CGRectOffset(newFrame, -320, 0)];
     }];
}

-(void)slideImagesIn
{
    [UIView animateWithDuration:0.5 animations:^(void)
     {
         CGRect newFrame = imagesView.frame;
         [imagesView setFrame:CGRectOffset(newFrame, 320, 0)];
     }];
}


-(IBAction)toggleLibrary:(id)sender
{
    if (!settingsOpen)
    {
        return;
    }
    
    [tileView stabilize];
    
    if(libraryOpen)
    {
        [self slideImagesIn];
        [self slideSettingsIn];
        libraryOpen = NO;
    }
    else
    {
        [self slideSettingsOut];
        [self slideImagesOut];
        libraryOpen = YES;
    }
}
     

-(IBAction)toggleSettings:(id)sender
{
    [tileView stabilize];
    
    if(settingsOpen)
    {
        [self raiseFront];
        settingsOpen = NO;
        [[OBUserPreferences sharedPreferences] savePreferences];
    }
    else
    {
        [self dropFront];
        settingsOpen = YES;
    }
}

-(void)didStartShuffle
{
    [statusLabel setText:@"shuffling"];
    [mShuffleHUD show:YES];
}

-(void)didStopShuffle
{
    [statusLabel setHidden:YES];
    [gameTimer clearTimer];
    [gameTimer startTimer];
    [gameTimer setHidden:NO];
    isPlaying = YES;
    [mShuffleHUD hide:YES];
}

-(void)didComplete:(NSInteger)count
{
    [mCompleteHUD setMoveCount:count andTimeString:[gameTimer getTime]];
    [statusLabel setText:@"complete"];
    [statusLabel setAlpha:0.0];
    [statusLabel setHidden:NO];
    [gameTimer setHidden:YES];
    isPlaying = NO;
    
    if (!previewOpen)
    {
        [mCompleteHUD show:YES];
    }
    
    [UIView animateWithDuration:0.8 animations:^(void)
     {
         [statusLabel setAlpha:0.75];
         
     } completion:^(BOOL completion)
     {
         [mCompleteHUD setCancelable:YES];
         [self flipPreview:nil];
     }];
    
    if ([[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGameSwitch] == 0 ) 
    {
        [[OBGameCenter sharedInstance] logComplete];
        [[OBGameCenter sharedInstance] logSolveTime: [gameTimer getIntTime]
                                            andSize: ([[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGridSwitch] == 1)];
        
        [[OBGameCenter sharedInstance] logSolveMoves: count
                                             andSize: ([[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGridSwitch] == 1)];
    }
}

-(void)didStartLockSlide
{
    if (!mBlockLock)
    {
        [mLockHUD show:YES];
    }
    
}

-(void)didStopLockSlide
{
    [mLockHUD hide:YES];
}

-(IBAction)flipPreview:(id)sender
{
    
    if (settingsOpen) 
    {
        return;
    }
    
    [tileView stabilize];
    
    if(previewOpen)
    {
        [flipBackButton removeFromSuperview];
        
        [tileView setAlphas:1.0f];
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:tileView
                                 cache:YES];
        [backView removeFromSuperview];
        [UIView commitAnimations];
        
        previewOpen = NO;
        if (isPlaying)
        {
            [tileView setInteractionEnabled:YES];
        }
        else
        {
            [tileView setInteractionEnabled:NO];
        }
        
        [UIView animateWithDuration:0.5 animations:^(void)
         {
             [flipButton setAlpha:0.0];
         }
                         completion:^(BOOL completion)
         {
             [flipButton setImage:[UIImage imageNamed:@"OBGlass_n"] forState:UIControlStateNormal];
             [flipButton setImage:[UIImage imageNamed:@"OBGlass_h"] forState:UIControlStateHighlighted];
             
             [UIView animateWithDuration:0.5 animations:^(void)
              {
                  [flipButton setAlpha:1.0];
              }];
         }
         ];

    }
    else 
    {
        [self.view insertSubview:flipBackButton belowSubview:mCompleteHUD];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                               forView:tileView
                                 cache:YES];
        [tileView addSubview:backView];
        [UIView commitAnimations];
        [tileView setAlphas:0.0f];
        
        [UIView animateWithDuration:0.5 animations:^(void)
        {
            [flipButton setAlpha:0.0];
        }
         completion:^(BOOL completion)
         {
             [flipButton setImage:[UIImage imageNamed:@"OBGrid_n"] forState:UIControlStateNormal];
             [flipButton setImage:[UIImage imageNamed:@"OBGrid_h"] forState:UIControlStateHighlighted];
             
             [UIView animateWithDuration:0.5 animations:^(void)
              {
                  [flipButton setAlpha:1.0];
              }];
         }
         ];
        
        previewOpen = YES;
        [tileView setInteractionEnabled:NO];
    }
}

-(void)didSetState:(BOOL)isOn forSwitch:(OBSwitchView*)pSwitch
{
    NSInteger switchValue = isOn ? 0 : 1;
    
    if (pSwitch == gridSwitch)
    {
        if ([[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceGridSwitch] == switchValue)
        {
            return;
        }
        
        [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceGridSwitch
                                                     withInt:switchValue];
        
        if ([[OBGameModel sharedInstance] getGameImage] == nil)
        {
            return;
        }

        [gameTimer setHidden:YES];
        isPlaying = NO;
        
        [self initGridForSize:switchValue];
    }
    else if (pSwitch == soundSwitch)
    {
        [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceSoundSwitch 
                                                     withInt:switchValue];
    }
    else if(pSwitch == gameSwitch)
    {
        if (switchValue == 0) 
        {
            [[OBGameCenter sharedInstance] loginUser];
        }
        else 
        {

        }
        [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceGameSwitch 
                                                     withInt:switchValue];
    }
    else 
    {
        NSAssert(false, @"Invalid switch selected");
    }
}

@end
