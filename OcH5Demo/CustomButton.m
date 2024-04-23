//
//  CustomButton.m
//  3PattiGalaxy-mobile
//
//  Created by Mewlan Musajan on 3/21/24.
//

#import "CustomButton.h"

@implementation CustomButton
{
    CALayer *grayLayer;//layer to handle disable and enable
}
@synthesize faceUp;

//  in initilization method
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        grayLayer = [CALayer layer];
        grayLayer.frame = frame;
        [self.layer addSublayer:grayLayer]; //add the grayLayer during initialisation
    }
    return self;
}

//add this method
- (void)makeButtonDisable:(BOOL)disable
{
    if(disable)
    {
        grayLayer.backgroundColor = [UIColor colorWithRed:201.0f/255.0f green:201.0f/255.0f blue:201.0f/255.0f alpha:5.0f].CGColor;
        self.userInteractionEnabled = NO;
        grayLayer.opacity = 0.5f;
        self.alpha = 0.5f;
    }
    else
    {
        grayLayer.backgroundColor = [UIColor clearColor].CGColor;
        self.userInteractionEnabled = YES;
        grayLayer.opacity = 0.0f;
        self.alpha = 1.0f;
    }
    
}

@end
