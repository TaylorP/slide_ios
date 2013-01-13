//
//  OBPageStreamView.h
//  slide
//
//  Created by Taylor Petrick on 12-07-07.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OBPageStreamView : UIView <UIScrollViewDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    UIScrollView* pageStream;
    NSMutableArray* tileViews;
    NSMutableArray* customObjects;
    NSArray* tileNames;
    UILabel* titleText;
    
    int lastPage;
    
    int currentMax;
    
    BOOL flippedView;
    UIButton* addButton;
    UIView* flipButtonView;
}

-(void)initAsImages;

-(void)clearButton;
@property (nonatomic, retain) UIViewController* viewController;
@property (nonatomic, retain) UIImagePickerController *imgPicker;
@end
