//
//  OBAppDelegate.h
//  slide
//
//  Created by Taylor Petrick on 12-06-23.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OBViewController;

@interface OBAppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) OBViewController *viewController;

@end
