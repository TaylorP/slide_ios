/*
 *
 *  OBSound/OBSound.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBSound.h"
#import "OBUserPreferences.h"

@implementation OBSound

static OBSound* sharedInstance;

+ (OBSound*)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[OBSound alloc] init];
    }
    
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    
    if (self) 
    {
        [self createSounds];
    }
    
    return self;
}

- (void)createSounds
{
    for(int i =0; i<3; i++)
    {
        NSString *path  = [[NSBundle mainBundle] pathForResource: [NSString stringWithFormat:@"0%i",i] 
                                                          ofType: @"wav"];
        if ([[NSFileManager defaultManager] fileExistsAtPath : path])
        {
            NSURL *pathURL = [NSURL fileURLWithPath : path];
            AudioServicesCreateSystemSoundID((CFURLRef) pathURL, &mSlidingSounds[i]);
        }
        else
        {
            NSLog(@"error, file not found: %@", path);
        }
    }
}

-(void)playRandomSound
{
    BOOL play = [[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceSoundSwitch] == 0;
    
    if(play)
    {
        int sound = arc4random()%3;
        AudioServicesPlaySystemSound(mSlidingSounds[sound]);
    }
}

@end
