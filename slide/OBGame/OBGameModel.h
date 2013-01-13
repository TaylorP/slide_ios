/*
 *
 *  OBGame/OBGameModel.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>

///A singleton class for maintain current game state across the app
@interface OBGameModel : NSObject
{
    ///The current loaded image
    NSString* mGameImage;
    
    ///Flag for determining if the image is a custom one.
    BOOL mIsCustomImage;
    
    NSMutableArray* customImages;
}

///Singleton instance getter
+ (OBGameModel*)sharedInstance;

///Sets the current game image
- (void)setGameImage:(NSString*)pGameImage;
- (void)setGameImage:(NSString*)pGameImage andIsCustom:(BOOL)isCustom;

///Gets the current game image
- (NSString*)getGameImage;

///Gets the custom image state
- (BOOL)getIsCustomImage;

///Adds a custom image
- (void)addCustomImage: (NSString*)imageName;

///Deletes a custom image
- (void)deleteCustomImage: (NSString*)imageName;

///Returns the custom images
- (NSArray*)getCustomImages;

@end
