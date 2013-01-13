/*
 *
 *  OBGame/OBGameModel.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBGameModel.h"
#import "OBUserPreferences.h"

@implementation OBGameModel

static OBGameModel* gameModel;

+ (OBGameModel*)sharedInstance
{
    if(gameModel == nil)
    {
        gameModel = [[OBGameModel alloc] init];
        [gameModel setGameImage: [[OBUserPreferences sharedPreferences] getStringPreference:kOBPreferenceImageName]
                    andIsCustom: [[OBUserPreferences sharedPreferences] getBoolPreference:kOBPreferenceCustomImage]];
    }
    
    return gameModel;
}


-(id)init
{
    self = [super init];
    if (self)
    {
        customImages = [[NSMutableArray alloc] initWithCapacity:10];
        
        NSArray* customArray = [[OBUserPreferences sharedPreferences] getArrayPreference:kOBPreferenceCustomArray];
        [customImages addObjectsFromArray:customArray];
    }
    
    return self;
}

-(void)addCustomImage: (NSString*)imageName
{
    [customImages addObject:imageName];
    
    [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceCustomArray
                                               withArray:customImages];
    
    [[OBUserPreferences sharedPreferences] savePreferences];
}

-(void)deleteCustomImage:(NSString *)imageName
{
    [customImages removeObject:imageName];
    [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceCustomArray
                                               withArray:customImages];
    
    [[OBUserPreferences sharedPreferences] savePreferences];
}

- (NSArray*)getCustomImages
{
    return customImages;
}

- (void)setGameImage:(NSString*)pGameImage
{
    [self setGameImage:pGameImage andIsCustom:NO];
}

- (void)setGameImage:(NSString *)pGameImage andIsCustom:(BOOL)isCustom
{
    mGameImage = [pGameImage retain];
    mIsCustomImage = isCustom;
    
    [[NSNotificationCenter defaultCenter] postNotificationName: @"GameModel_ImageChanged"
                                                        object: self];
}

- (NSString*)getGameImage
{
    return mGameImage;
}

- (BOOL)getIsCustomImage
{
    return mIsCustomImage;
}

@end
