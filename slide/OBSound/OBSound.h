/*
 *
 *  OBSound/OBSound.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioToolbox.h>

///Singleton class for playing snippets of sliding sounds
@interface OBSound : NSObject
{
    ///The sounds to randomly play during sliding
    SystemSoundID mSlidingSounds[3];
}

///Returns a singleton instance
+ (OBSound*)sharedInstance;

///Plays a random sliding sound
- (void)playRandomSound;

@end
