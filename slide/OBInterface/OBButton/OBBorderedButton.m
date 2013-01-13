/*
 *
 *  OBInterface/OBButton/OBBorderedButton.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBBorderedButton.h"
#import "OBImageManager.h"

@implementation OBBorderedButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) 
    {
        [self initButton];
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self) 
    {
        [self initButton];
    }
    
    return self;
}

-(void)initButton
{
    CGSize buttonSize = self.frame.size;
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, buttonSize.width, buttonSize.height)];
    [imageView setImage: [OBImageManager buttonEdgeImageForSize: buttonSize]];
    [self addSubview:imageView];
    
    mMainButton = [UIButton buttonWithType: UIButtonTypeCustom];
    [mMainButton setFrame:imageView.frame];
    [self addSubview:mMainButton];

    [imageView release];
}

- (void)setButtonAction:(id)pTarget action:(SEL)pAction forControlEvents:(UIControlEvents)pControlEvents;
{
    [mMainButton addTarget: pTarget
                    action: pAction
          forControlEvents: pControlEvents];
}

- (void)setButtonImage:(UIImage*)pImage forState:(UIControlState)pState;
{
    [mMainButton setBackgroundImage: pImage
                           forState: pState];
}

- (void)setButtonText:(NSString *)pText
{
    if (mMainText == nil)
    {
        mMainText = [[UILabel alloc] initWithFrame:CGRectMake(0, self.frame.size.height-35.0f, self.frame.size.width, 35.0f)];
        
        [mMainText setFont:[UIFont boldSystemFontOfSize:15.0f]];
        [mMainText setBackgroundColor:[UIColor clearColor]];
        [mMainText setTextColor:[UIColor whiteColor]];
        [mMainText setTextAlignment:UITextAlignmentCenter];
        [mMainText setAlpha:0.75f];
        
        [self addSubview:mMainText];
    }
    
    [mMainText setText: pText];
}

@end
