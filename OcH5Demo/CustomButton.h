//
//  CustomButton.h
//  3PattiGalaxy-mobile
//
//  Created by Mewlan Musajan on 3/21/24.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface CustomButton : UIButton
@property (nonatomic,assign) BOOL faceUp;//your property
- (void)makeButtonDisable:(BOOL)disable;//method to handle disable and enable
@end


NS_ASSUME_NONNULL_END
