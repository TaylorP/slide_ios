/*
 *
 *  OBGameCenter/OBGameCenter.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBGameCenter.h"
#import "OBUserPreferences.h"

@implementation OBGameCenter
@synthesize oGameCenter;

static OBGameCenter* sharedInstance;

+(OBGameCenter*)sharedInstance
{
    if(sharedInstance == nil)
    {
        sharedInstance = [[OBGameCenter alloc] init];
    }
    
    return sharedInstance;
}

-(id)init
{
    self = [super init];
    
    if(self != nil)
    {
        oGameCenter = [[[GameCenterManager alloc] init] autorelease];
        [oGameCenter setDelegate:self];
    }
    
    return self;
}

- (void) processGameCenterAuth: (NSError*) error
{
    if (error == nil)
    {
        [self.oGameCenter submitAchievement: kOBAchievementProUserBonus
                            percentComplete: 100.0f];
    }
    else
    {
        [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceGameSwitch withInt:1];
        [[OBUserPreferences sharedPreferences] savePreferences];
    }
}

- (void) scoreReported: (NSError*) error
{
    
}

- (void) reloadScoresComplete: (GKLeaderboard*) leaderBoard error: (NSError*) error
{
    
}

- (void) achievementSubmitted: (GKAchievement*) ach error:(NSError*) error
{
    
}

- (void) achievementResetResult: (NSError*) error
{
    
}

- (void) mappedPlayerIDToPlayer: (GKPlayer*) player error: (NSError*) error
{
    
}

- (void)loginUser
{
    if([GameCenterManager isGameCenterAvailable])
    {
        [self.oGameCenter authenticateLocalUser];
    }
}

- (void)logComplete
{
    NSInteger count = [[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceScoreCount];
    count++;
    
    [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceScoreCount 
                                                 withInt:count];
    
    [[OBUserPreferences sharedPreferences] savePreferences];
    
    [self logProgress:count];
}

- (void)logProgress:(NSInteger)pSolveCount
{
    [self.oGameCenter submitAchievement: kOBAchievementFirstSolve 
                        percentComplete: 100.0f];
    
    if (pSolveCount <= 20) 
    {
        double twentyComplete = pSolveCount * 5.0f;
        [self.oGameCenter submitAchievement: kOBAchievementTwentySolve 
                            percentComplete: twentyComplete];
    }
    
    if (pSolveCount <= 100) 
    {
        double hundredComplete = pSolveCount * 1.0f;
        [self.oGameCenter submitAchievement: kOBAchievementHundredSolve 
                            percentComplete: hundredComplete];
    }
}

- (void)logSolveTime:(int)time andSize:(BOOL)size
{
    if (size)
    {
        [self.oGameCenter reportScore:time forCategory:kOBLeaderboardTimes34];
    }
    else
    {
        [self.oGameCenter reportScore:time forCategory:kOBLeaderboardTimes33];
    }
}

- (void)logSolveMoves:(int)moves andSize:(BOOL)size
{
    if (size)
    {
        [self.oGameCenter reportScore:moves forCategory:kOBLeaderboardMoves34];
    }
    else
    {
        [self.oGameCenter reportScore:moves forCategory:kOBLeaderboardMoves33];
    }
}

@end
