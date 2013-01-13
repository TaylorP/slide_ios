/*
 *
 *  OBImage/OBImageCache.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBImageCache.h"
#import "OBImageCacheConfig.h"
#import "OBUserPreferences.h"

#import "NSString+Hash.h"

@implementation OBImageCache

static OBImageCache* gCache;

+ (OBImageCache*)globalCache
{
    if (gCache == nil) 
    {
        gCache = [[OBImageCache alloc] init];
        [gCache initCache];
    }
    
    return gCache;
}

- (void)initCache
{
    int currentVersion = [[OBUserPreferences sharedPreferences] getIntPreference:kOBPreferenceCacheVersion];
    if (currentVersion != kOBImageCacheVersion)
    {
        [[NSFileManager defaultManager] removeItemAtPath: [self getGlobalCachePath]
                                                   error: nil];
        
        [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceCacheVersion withInt:kOBImageCacheVersion];
    }
    
    if(![self fileExists: [self getCachePath]])
    {
        [[NSFileManager defaultManager] createDirectoryAtPath: [self getCachePath] 
                                  withIntermediateDirectories: YES
                                                   attributes: nil 
                                                        error: nil];
    }
    
    mLoadedImages = [[NSCache alloc] init];
}

-(void)dealloc
{
    [mLoadedImages release];
    
    [super dealloc];
}

- (NSString*)getGlobalCachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [NSString stringWithFormat: @"%@/image_cache",[paths objectAtIndex:0]];
}

- (NSString*)getCachePath
{ 
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    return [NSString stringWithFormat: @"%@/image_cache/v_%i",[paths objectAtIndex:0],kOBImageCacheVersion];
}

- (BOOL)fileExists:(NSString*)pFile
{
    return [[NSFileManager defaultManager] fileExistsAtPath: pFile];
}

- (NSString*)imagePathForName:(NSString*)pName
{
    return [NSString stringWithFormat: @"%@/%@.png",[self getCachePath], [pName hashString]];
}

- (UIImage*)getImage:(NSString*)pName
{
    if (kOBImageCacheDebug) 
    {
        return nil;
    }
    
    NSString* fileName = [self imagePathForName: pName];
    UIImage* image = (UIImage*) [mLoadedImages objectForKey: fileName];
    
    if ( image == nil) 
    {
        image = [UIImage imageWithContentsOfFile: fileName];
        
        if (image != nil)
        {
             [mLoadedImages setObject: image 
                               forKey: fileName];
        }
    }
    
    return image;
}


- (NSString*)storeImage:(UIImage*)pImage byName:(NSString*)pName
{
    NSData* imageData = UIImagePNGRepresentation(pImage);
    NSString* fileName = [self imagePathForName: pName];
    
    [[NSFileManager defaultManager] createFileAtPath: fileName
                                            contents: imageData
                                          attributes: nil];
    
    [mLoadedImages setObject: pImage
                      forKey: fileName];
    
    return fileName;
}

@end
