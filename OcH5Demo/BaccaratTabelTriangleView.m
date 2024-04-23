//
//  BaccaratTabelArchView.m
//  3PattiGalaxy-mobile
//
//  Reconfigured by Mewlan Musajan on 3/23/24.
//

#import "BaccaratTabelTriangleView.h"

@implementation BaccaratTabelTriangleView {
    BOOL isIPadOS;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    UIDevice *device = [UIDevice currentDevice];
    isIPadOS = NO;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {


        }
        else
        {
            //iphone 3.5 inch screen
        }
    }
    else
    {
           //[ipad]
        isIPadOS = YES;
    }
    
    if (isIPadOS) {
        
    } else {
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(self.bounds.size.width / 2 - 50, self.bounds.size.height - 294)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width / 2 - 150, self.bounds.size.height - 69)];

        [[UIColor colorWithRed:0.64 green:0.62 blue:0.43 alpha:1.0] setStroke];
        [path setLineWidth:3];
        [path stroke];
        
        [path moveToPoint:CGPointMake(self.bounds.size.width / 2 + 50, self.bounds.size.height - 294)];
        [path addLineToPoint:CGPointMake(self.bounds.size.width / 2 + 150, self.bounds.size.height - 69)];
        [path stroke];
    }


}

@end
