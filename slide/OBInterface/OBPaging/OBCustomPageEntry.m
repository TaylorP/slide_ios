//
//  OBCustomPageEntry.m
//  slide
//
//  Created by Taylor Petrick on 2012-09-01.
//
//

#import "OBCustomPageEntry.h"

@implementation OBCustomPageEntry
@synthesize deleteButton, imageButton, border;
@synthesize  name;

-(void)deleteObject
{
    [UIView animateWithDuration:0.3 animations:^(void)
        {
            [deleteButton setAlpha:0.0f];
            [imageButton setAlpha:0.0f];
            [border setAlpha:0.0f];
        }
     completion:^(BOOL completion)
        {
            [deleteButton removeFromSuperview];
            [imageButton removeFromSuperview];
            [border removeFromSuperview];
        }
     ];
}

@end
