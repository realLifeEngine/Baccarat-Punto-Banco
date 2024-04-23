//
//  BaccaratCard.h
//  CasinoGalaxy-mobile
//
//  Reconfigured by Mewlan Musajan on 3/29/24.
//  Created by chenran on 16/5/22.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Suit) {
    kClub,
    kSpades,
    kDimond,
    kHeart
};

typedef NS_ENUM(NSUInteger, Tie) {
    kAce = 1,
    kTwo,
    kThree,
    kFour,
    kFive,
    kSix,
    kSeven,
    kEight,
    kNine,
    kTen,
    kJack,
    kQueen,
    kKing
};

NS_ASSUME_NONNULL_BEGIN

@interface BaccaratCard : NSObject
@property (assign, nonatomic) int points;
@property (strong, nonatomic) NSString* suit;
@property (strong, nonatomic) NSString* tie;

- (instancetype)initWithPointsAndSuits:(Suit)suit tie:(Tie)points;
- (instancetype)initWithFacesAndSuits:(Suit)suit tie:(Tie)face;
- (NSString *)pointsDescription;
- (NSString *)facesDescription;
@end

NS_ASSUME_NONNULL_END
