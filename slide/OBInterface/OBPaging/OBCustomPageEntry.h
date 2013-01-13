//
//  OBCustomPageEntry.h
//  slide
//
//  Created by Taylor Petrick on 2012-09-01.
//
//

#import <Foundation/Foundation.h>

@interface OBCustomPageEntry : NSObject

@property (nonatomic, retain) UIButton* imageButton;
@property (nonatomic, retain) UIButton* deleteButton;
@property (nonatomic, retain) UIImageView* border;
@property (nonatomic, retain) NSString* name;
-(void)deleteObject;

@end
