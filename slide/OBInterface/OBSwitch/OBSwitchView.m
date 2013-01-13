/*
 *
 *  OBInterface/OBSwitch/OBSwitchView.m
 *
 *  Taylor Petrick
 *  Orange Bytes
 *
 */

#import "OBSwitchView.h"
#import "UIImage+WhiteBox.h"
#import "OBImageManager.h"

@implementation OBSwitchView

@synthesize oDelegate;
@synthesize oOnString, oOffString;
@synthesize oSwitchValue;

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self != nil) 
    {
        [self initSwitch];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame
{    
    self = [super initWithFrame:frame];
    if (self) 
    {
        [self initSwitch];
    }
    return self;
}

-(void)initSwitch
{
    self.oOnString = @"on";
    self.oOffString = @"off";
    self.oSwitchValue = 0;
    
    mLastState = YES;

    UIImageView* background = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [background setImage: [OBImageManager switchEdgeImageForSize:self.frame.size]];
    [self addSubview:background];
    [background release];

    mSwitchButton = [[OBSwitchButton alloc] initWithFrame:CGRectMake(4, 4, 32, 20)];
    [mSwitchButton setText: self.oOnString];
    [self addSubview:mSwitchButton];
    
    mOnFrame = mSwitchButton.frame;
    mOffFrame = CGRectMake(38, 4, 32, 18);
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [mSwitchButton setTransistional:YES];
    
    mDelta = CGPointMake(0.0f, 0.0f);
    mOriginalPos = mSwitchButton.frame.origin;
    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    mLastPoint = touchPoint;
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{    
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    
    mDelta.x += touchPoint.x - mLastPoint.x;
    mDelta.y += 0;
    
    
    float xPos = mOriginalPos.x + mDelta.x;
    if (xPos < 4.0 ) 
    {
        xPos = 4.0;
    }
    else if (xPos > 38)
    {
        xPos = 38.0f;
    }
    
    CGRect newFrame = CGRectMake(xPos, mOriginalPos.y + mDelta.y, mSwitchButton.frame.size.width, mSwitchButton.frame.size.height);
    
    [mSwitchButton setFrame:newFrame];
    mLastPoint = touchPoint;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{    
    if(mDelta.x >= 17.0f || (fabs(mDelta.x) <= 1 && self.oSwitchValue == 0) )
    {
        [self setOn:NO withAnimation:YES];
    }
    else if (mDelta.x <= -17.0f || (fabs(mDelta.x) <= 1 && self.oSwitchValue == 1))
    {
        [self setOn:YES withAnimation:YES];
    }
    else 
    {
        if (self.oSwitchValue == 0) 
        {
            [self setOn:YES withAnimation:YES];
        }
        else if (self.oSwitchValue == 1)
        {
            [self setOn:NO withAnimation:YES];
        }
    }
}

- (void)update
{
    if (self.oSwitchValue == 0) 
    {
        [mSwitchButton setText: self.oOnString];
        [mSwitchButton setFrame: mOnFrame];
        [mSwitchButton setTransistional:NO];
    }
    else 
    {
        [mSwitchButton setText: self.oOffString];
        [mSwitchButton setFrame: mOffFrame];
        [mSwitchButton setTransistional:NO];
    }
}

- (void)setOn:(BOOL)pIsOn withAnimation:(BOOL)pIsAnimated
{
    [self.oDelegate didSetState:pIsOn forSwitch:self];
    
    if (pIsOn) 
    {
        self.oSwitchValue = 0;
        [mSwitchButton setText:self.oOnString];
        
        if (pIsAnimated) 
        {
            [mSwitchButton animateToFrame:mOnFrame];
        }
        else 
        {
            [mSwitchButton setFrame:mOnFrame];
            [mSwitchButton setTransistional:NO];
        }
    }
    else 
    {
        self.oSwitchValue = 1;
        [mSwitchButton setText:self.oOffString];
        
        if (pIsAnimated) 
        {
            [mSwitchButton animateToFrame:mOffFrame];
        }
        else 
        {
            [mSwitchButton setFrame:mOffFrame];
            [mSwitchButton setTransistional:NO];
        }
    }
}

@end
