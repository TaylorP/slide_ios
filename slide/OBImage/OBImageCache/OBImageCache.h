/*
 *
 *  OBImage/OBImageCache.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>

///Image caching utility for managing and creating png images in the file system.
@interface OBImageCache : NSObject
{
    ///An in-RAM cache of images to further speed up loading and swapping of images
    NSCache* mLoadedImages;
}

///Returns the global image cache instance
+ (OBImageCache*)globalCache;

///Returns the path to global image cache folder
- (NSString*)getGlobalCachePath;

///Returns the path to the current version's image cache
- (NSString*)getCachePath;

///Checks if a file path is valid
- (BOOL)fileExists:(NSString*)pFile;

///Returns the hashed path for a given file name
- (NSString*)imagePathForName:(NSString*)pName;

///Returns the UIImage corresponding to a file name, or nil if the file does not exist
- (UIImage*)getImage:(NSString*)pName;

///Stores a UIImage under the given name and returns the file name
- (NSString*)storeImage:(UIImage*)pImage byName:(NSString*)pName;

@end
