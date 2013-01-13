/*
 *
 *  OBImage/NSString+Hash.h
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import <Foundation/Foundation.h>

///Category for adding hashing functionality to NSString
@interface NSString (Hash)

///Generates an MD5 hash of the NSString
-(NSString*)hashString;

@end
