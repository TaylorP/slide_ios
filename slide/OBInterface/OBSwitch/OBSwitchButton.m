//
//  OBSwitchButton.m
//  slide
//
//  Created by Taylor Petrick on 12-07-03.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OBSwitchButton.h"
#import "OBImageManager.h"

@implementation OBSwitchButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [imageView setImage:[OBImageManager switchControlImageForSize:frame.size]];
        [self addSubview:imageView];
        [imageView release];
        
        textLabel = [[UILabel alloc] initWithFrame:CGRectMake(1, 1, frame.size.width-2, frame.size.height-2)];
        [textLabel setTextColor:[UIColor colorWithRed:48.0f/255.0f green:60.0f/255.0f blue:70.0f/255.0f alpha:1.0f]];
        [textLabel setTextAlignment: UITextAlignmentCenter];
        [textLabel setFont:[UIFont systemFontOfSize:14.0f]];
        [textLabel setBackgroundColor:[UIColor clearColor]];
        [self addSubview:textLabel];
        [textLabel release];
    }
    return self;
}

- (void)setTransistional:(BOOL)pTransistional
{
    if (pTransistional) 
    {
        [textLabel setHidden:YES];
    }
    else 
    {
        [textLabel setHidden:NO];
    }
}

-(void)setText:(NSString *)setText
{
    [textLabel setText:setText];
}

- (void)animateToFrame:(CGRect)frame
{
    [UIView animateWithDuration:0.2 
                     animations:^(void)
     {
         [self setFrame:frame];
     }
                     completion:^(BOOL complete)
     {
         [self setTransistional:NO];
     }
     ];
}

@end
