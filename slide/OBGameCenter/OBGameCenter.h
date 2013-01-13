/*
 *
 *  OBGameCenter/OBGameCenter.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>
#import "OBGameCenterAchievements.h"
#import "OBGamerCenterLeaderboards.h"
#import "GameCenterManager.h"

///A singleton for interacting with the Game Center
@interface OBGameCenter : NSObject <GameCenterManagerDelegate>
{    
}

///Returns the singleton instance
+ (OBGameCenter*)sharedInstance;

///Logs the user into the game center
- (void)loginUser;

///Logs progress on solve count achievements
- (void)logProgress:(NSInteger)pSolveCount;

///Logs when a user completes a puzzle
- (void)logComplete;

///Logs a solving time for a given puzzle size
- (void)logSolveTime:(int)time andSize:(BOOL)size;

///Logs a solving move count for a given puzzle size
- (void)logSolveMoves:(int)time andSize:(BOOL)size;

///The game center manager instance
@property (nonatomic, retain) GameCenterManager* oGameCenter;

@end
