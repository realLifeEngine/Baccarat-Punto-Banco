//
//  card.h
//  Black Jack
//
//  Created by Khoa Nguyen on 1/13/14.
//  Copyright (c) 2014 Khoa Nguyen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface card : NSObject
@property (nonatomic, assign) int rank;
@property (nonatomic, strong) NSString *suite;
@property (nonatomic, strong) UIImage *image;

@end

