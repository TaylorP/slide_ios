#import "OBPageStreamView.h"
#import "UIImage+RoundCorner.h"
#import "UIImage+WhiteBox.h"
#import "OBGameModel.h"
#import "OBUserPreferences.h"
#import "UIImage+Crop.h"
#import "OBImageCache.h"
#import "OBCustomPageEntry.h"

@implementation OBPageStreamView

@synthesize viewController, imgPicker;

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self != nil) 
    {
        pageStream = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [self addSubview:pageStream];
        [pageStream setBackgroundColor:[UIColor clearColor]];
        [pageStream setDelegate:self];
        
        tileNames = [[NSArray arrayWithObjects:@"the king", @"plains", @"orchard", 
                                              @"grill", @"birdie", @"origami", @"spikes", 
                     @"snow train", @"fruits", @"slide", nil] retain];
        
        tileViews = [[NSMutableArray alloc] initWithCapacity:20];
        customObjects = [[NSMutableArray alloc] initWithCapacity:20];
        
        titleText = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, frame.size.width, 30)];
        [titleText setBackgroundColor:[UIColor clearColor]];
        [titleText setTextAlignment:UITextAlignmentCenter];
        [titleText setText:[tileNames objectAtIndex:0]];
        [titleText setTextColor:[UIColor whiteColor]];
        [titleText setAlpha:0.85f];
        [titleText setFont:[UIFont boldSystemFontOfSize:14.0f]];
        
        flipButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 90)];
        [flipButtonView setBackgroundColor:[UIColor clearColor]];
        
        UIImage* border = [UIImage roundWhiteOutlineWithSize:CGSizeMake(90, 90) andThickness:2.0f andCornerSize:CGSizeMake(2.0f, 2.0)];
        UIImageView* bView = [[UIImageView alloc] initWithImage:border];
        [bView setFrame:CGRectMake(0, 0, 90, 90)];
        [flipButtonView addSubview:bView];
        [bView release];
        
        UIButton* camButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [camButton setImage:[UIImage imageNamed:@"OBAddCamera.png"] forState:UIControlStateNormal];
        [camButton setFrame:CGRectMake(5, 5, 80, 40)];
        [camButton setTag:0];
        [camButton addTarget:self action:@selector(addCustomPress:) forControlEvents:UIControlEventTouchUpInside];
        [flipButtonView addSubview:camButton];
        
        UIButton* libButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [libButton setImage:[UIImage imageNamed:@"OBAddLibrary.png"] forState:UIControlStateNormal];
        [libButton setFrame:CGRectMake(5, 45, 80, 40)];
        [libButton setTag:1];
        [libButton addTarget:self action:@selector(addCustomPress:) forControlEvents:UIControlEventTouchUpInside];
        [flipButtonView addSubview:libButton];
        
        flippedView = NO;
        [self addSubview:titleText];
        
        lastPage = -1;
        
        imgPicker = [[UIImagePickerController alloc] init];
        self.imgPicker.delegate = self;
     }
    
    return self;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)img editingInfo:(NSDictionary *)editInfo
{
    if (flippedView)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:addButton
                                 cache:YES];
        [flipButtonView removeFromSuperview];
        [addButton setImage:[UIImage imageNamed:@"OBCustomAdd.png"] forState:UIControlStateNormal];
        [UIView commitAnimations];
        
        flippedView = NO;
    }
    
    CGFloat screenScale = [[UIScreen mainScreen] scale];
    UIGraphicsBeginImageContext(CGSizeMake(300*screenScale, 400*screenScale));
    [img drawInRect:CGRectMake(0,0,300*screenScale, 400*screenScale)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    OBCustomPageEntry* entry = [[OBCustomPageEntry alloc] init];
    
    NSString *timestamp = [NSString stringWithFormat:@"%0.0f", [[NSDate date] timeIntervalSince1970]];
    [[OBImageCache globalCache] storeImage:newImage byName:timestamp];
    [[OBGameModel sharedInstance] setGameImage:timestamp andIsCustom:YES];
    
    [[OBGameModel sharedInstance] addCustomImage:timestamp];
    
    UIImage* image = [[OBImageCache globalCache] getImage:timestamp];
    image = [image crop:CGRectMake(0, 0, 300, 300)];
    
    UIGraphicsBeginImageContext(CGSizeMake(90*screenScale, 90*screenScale));
    [image drawInRect:CGRectMake(0,0,90*screenScale, 90*screenScale)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImage* border = [UIImage roundWhiteBoxWithSize:CGSizeMake(94, 94) andCornerSize:CGSizeMake(2.0f, 2.0)];
    UIImageView* bView = [[UIImageView alloc] initWithImage:border];
    [bView setFrame:CGRectMake(115 + 100*(currentMax), 73, 94, 94)];
    [pageStream addSubview:bView];
    [tileViews addObject:bView];
    entry.border = bView;
    [bView release];
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageWithRoundCorner:newImage andCornerSize:CGSizeMake(2, 2) andScaleUp:YES] forState:UIControlStateNormal];
    [button setFrame:CGRectMake(117 + 100*(currentMax), 75, 90, 90)];
    [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = currentMax-10+100;
    [pageStream addSubview:button];
    [tileViews addObject:button];
    entry.imageButton = button;
    
    UIButton* delete = [UIButton buttonWithType:UIButtonTypeCustom];
    [delete setFrame:CGRectMake(109 + 100*(currentMax), 65, 20, 20)];
    [delete setImage:[UIImage imageNamed:@"OBEx"] forState:UIControlStateNormal];
    [delete addTarget:self action:@selector(deletePress:) forControlEvents:UIControlEventTouchUpInside];
    delete.tag = currentMax-10;
    [pageStream addSubview:delete];
    entry.deleteButton = delete;
    entry.name = timestamp;
    
    [customObjects addObject:entry];
    [entry release];
    
    currentMax++;
    
    pageStream.contentSize = CGSizeMake(120+100*(currentMax+1), self.frame.size.height);
    [self scrollViewDidScroll:pageStream];

    [self.viewController dismissModalViewControllerAnimated:YES];
}

-(void)addCustomPress:(id)sender
{
    if (((UIButton*)sender).tag == 0)
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self.viewController presentModalViewController:imgPicker animated:YES];
}

-(void)deletePress:(id)sender
{
    int page = ((UIButton*)sender).tag;
    OBCustomPageEntry* entry = [customObjects objectAtIndex:page];
    [tileViews removeObject:entry.imageButton];
    [tileViews removeObject:entry.border];
    [entry deleteObject];
    
    [UIView animateWithDuration:0.3 animations:^(void)
    {
        for (int i = page+1; i<[customObjects count]; i++)
        {
            OBCustomPageEntry* entry = [customObjects objectAtIndex:i];
            [entry.deleteButton setFrame:CGRectOffset(entry.deleteButton.frame, -100, 0)];
            entry.deleteButton.tag--;
            [entry.imageButton  setFrame:CGRectOffset(entry.imageButton.frame, -100, 0)];
            entry.imageButton.tag--;
            [entry.border       setFrame:CGRectOffset(entry.border.frame, -100, 0)];
        }
        
        [customObjects removeObject:entry];
    }
     completion:^(BOOL completion)
     {
         pageStream.contentSize = CGSizeMake(120+100*(currentMax+1), self.frame.size.height);
         [self scrollViewDidScroll:pageStream];
     }];
    
    currentMax--;
    
    [[OBGameModel sharedInstance] deleteCustomImage:entry.name];
}

-(void)clearButton
{
    if(flippedView)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:addButton
                                 cache:YES];
        [flipButtonView removeFromSuperview];
        [addButton setImage:[UIImage imageNamed:@"OBCustomAdd.png"] forState:UIControlStateNormal];
        [UIView commitAnimations];
        
        flippedView = NO;
    }
}

-(void)buttonPress:(id)sender
{
    int page = ((UIButton*)sender).tag;
    if (page == -1)
    {
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                                   forView:addButton
                                     cache:YES];
            [addButton addSubview:flipButtonView];
            [addButton setImage:nil forState:UIControlStateNormal];
            [UIView commitAnimations];
            
            flippedView = YES;
        }
        else
        {
            imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self.viewController presentModalViewController:imgPicker animated:YES];
        }
    }
    else if (page == lastPage || page%100+10 == lastPage)
    {
        if(flippedView)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                   forView:addButton
                                     cache:YES];
            [flipButtonView removeFromSuperview];
            [addButton setImage:[UIImage imageNamed:@"OBCustomAdd.png"] forState:UIControlStateNormal];
            [UIView commitAnimations];
            
            flippedView = NO;
        }
        
        if(page >= 100)
        {
            int index = page%100;
            NSString* name = [[[OBGameModel sharedInstance] getCustomImages] objectAtIndex:index];
            [[OBGameModel sharedInstance] setGameImage:name andIsCustom:YES];
            [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceImageName
                                                      withString:name];
            [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceCustomImage
                                                      withBool:YES];
            [[OBUserPreferences sharedPreferences] savePreferences];
        }
        else
        {
            NSString* imageName = [NSString stringWithFormat:@"im0%i.png", page];
            [[OBGameModel sharedInstance] setGameImage:imageName];
            [[OBUserPreferences sharedPreferences] setPreference:kOBPreferenceImageName 
                                                      withString:imageName];
            [[OBUserPreferences sharedPreferences] savePreferences];
        }
    }
    else 
    {
        if(flippedView)
        {
            [UIView beginAnimations:nil context:nil];
            [UIView setAnimationDuration:1.0];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                                   forView:addButton
                                     cache:YES];
            [flipButtonView removeFromSuperview];
            [addButton setImage:[UIImage imageNamed:@"OBCustomAdd.png"] forState:UIControlStateNormal];
            [UIView commitAnimations];
            
            flippedView = NO;
        }
        
        if(page >= 100)
        {
            int index = page%100;
            [pageStream scrollRectToVisible:CGRectMake(102 + 100*(index+9), 0, 320, 230) animated:YES];
        }
        else
        {
            [pageStream scrollRectToVisible:CGRectMake(102 + 100*(page-1), 0, 320, 230) animated:YES];
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    if(flippedView)
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:1.0];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                               forView:addButton
                                 cache:YES];
        [flipButtonView removeFromSuperview];
        [addButton setImage:[UIImage imageNamed:@"OBCustomAdd.png"] forState:UIControlStateNormal];
        [UIView commitAnimations];
        
        flippedView = NO;
    }
    
    int page = (pageStream.contentOffset.x + 30) / 100;

    if (page < 0) 
    {
        page = 0;
    }
    
    if (page > currentMax-1)
    {
        page = currentMax-1;
    }
    
    if (page != lastPage) 
    {
        lastPage = page;
        if (page < 10)
        {
            [titleText setText:[tileNames objectAtIndex:page]];
        }
        else
        {
            [titleText setText:@"custom"];
        }
        
        for (int i =0; i<currentMax; i++)
        {
            [[tileViews objectAtIndex:i*2] setAlpha:0.7f];
            [[tileViews objectAtIndex:i*2 + 1] setAlpha:0.5f];
        }
    
        [[tileViews objectAtIndex:page*2] setAlpha:1.0f];
        [[tileViews objectAtIndex:page*2 + 1] setAlpha:1.0f];
    }
}

-(void)initAsImages
{
    addButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [addButton setImage:[UIImage imageNamed:@"OBCustomAdd.png"] forState:UIControlStateNormal];
    [addButton setFrame:CGRectMake(17, 75, 90, 90)];
    [addButton addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
    addButton.tag = -1;
    [pageStream addSubview:addButton];
    
    for (int i = 0; i<10; i++)
    {
        NSString* imStr = [NSString stringWithFormat:@"im0%i_thumb.png",i];
        UIImage* image = [UIImage imageNamed:imStr];
        
        UIImage* border = [UIImage roundWhiteBoxWithSize:CGSizeMake(94, 94) andCornerSize:CGSizeMake(2.0f, 2.0)];
        UIImageView* bView = [[UIImageView alloc] initWithImage:border];
        [bView setFrame:CGRectMake(115 + 100*i, 73, 94, 94)];
        [pageStream addSubview:bView];
        [tileViews addObject:bView];
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageWithRoundCorner:image andCornerSize:CGSizeMake(2, 2) andScaleUp:YES] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(117 + 100*i, 75, 90, 90)];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i;
        [pageStream addSubview:button];
        [tileViews addObject:button];
    }
    
    currentMax = 10;
    
    NSArray* customs = [[OBGameModel sharedInstance] getCustomImages];
    for (int i = 0; i<[customs count]; i++)
    {
        OBCustomPageEntry* entry = [[OBCustomPageEntry alloc] init];
        
        UIImage* image = [[OBImageCache globalCache] getImage: [customs objectAtIndex:i]];
        image = [image crop:CGRectMake(0, 0, 300, 300)];
        
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        UIGraphicsBeginImageContext(CGSizeMake(90*screenScale, 90*screenScale));
        [image drawInRect:CGRectMake(0,0,90*screenScale, 90*screenScale)];
        UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImage* border = [UIImage roundWhiteBoxWithSize:CGSizeMake(94, 94) andCornerSize:CGSizeMake(2.0f, 2.0)];
        UIImageView* bView = [[UIImageView alloc] initWithImage:border];
        [bView setFrame:CGRectMake(115 + 100*(i+10), 73, 94, 94)];
        [pageStream addSubview:bView];
        [tileViews addObject:bView];
        entry.border = bView;
        
        
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageWithRoundCorner:newImage andCornerSize:CGSizeMake(2, 2) andScaleUp:YES] forState:UIControlStateNormal];
        [button setFrame:CGRectMake(117 + 100*(i+10), 75, 90, 90)];
        [button addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = i+100;
        [pageStream addSubview:button];
        [tileViews addObject:button];
        entry.imageButton = button;
        
        UIButton* delete = [UIButton buttonWithType:UIButtonTypeCustom];
        [delete setFrame:CGRectMake(109 + 100*(i+10), 65, 20, 20)];
        [delete setImage:[UIImage imageNamed:@"OBEx"] forState:UIControlStateNormal];
        [delete addTarget:self action:@selector(deletePress:) forControlEvents:UIControlEventTouchUpInside];
        delete.tag = i;
        [pageStream addSubview:delete];
        entry.deleteButton = delete;
        
        [customObjects addObject:entry];
        
        entry.name = [customs objectAtIndex:i];
        
        currentMax++;
    }
    
    
    pageStream.contentSize = CGSizeMake(120+100*(currentMax+1), self.frame.size.height);
    [self scrollViewDidScroll:pageStream];

}


@end
