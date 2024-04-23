//
//  BaccaratCard.m
//  CasinoGalaxy-mobile
//
//  Reconfigured by Mewlan Musajan on 3/29/24.
//  Created by chenran on 16/5/22.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "BaccaratCard.h"

@implementation BaccaratCard
-(instancetype)initWithPointsAndSuits:(Suit)suit tie:(Tie)points {
    
    self = [super init];

    if (self) {

        switch (suit) {
            case kSpades:
                self.suit = @"S";
                break;
            case kClub:
                self.suit = @"C";
                break;
            case kDimond:
                self.suit = @"D";
                break;
            default:
                self.suit = @"H";
                break;
        }
        
        switch (points) {
            case kAce:
                self.points = 1;
                break;
            case kTwo:
                self.points = 2;
                break;
            case kThree:
                self.points = 3;
                break;
            case kFour:
                self.points = 4;
                break;
            case kFive:
                self.points = 5;
                break;
            case kSix:
                self.points = 6;
                break;
            case kSeven:
                self.points = 7;
                break;
            case kEight:
                self.points = 8;
                break;
            case kNine:
                self.points = 9;
                break;
            default:
                self.points = 0;
                break;
        }
        
        switch (points) {
        // thx again Unity 3D
            case kAce:
                self.tie = @"1";
                break;
            case kTwo:
                self.tie = @"2";
                break;
            case kThree:
                self.tie = @"3";
                break;
            case kFour:
                self.tie = @"4";
                break;
            case kFive:
                self.tie = @"5";
                break;
            case kSix:
                self.tie = @"6";
                break;
            case kSeven:
                self.tie = @"7";
                break;
            case kEight:
                self.tie = @"8";
                break;
            case kNine:
                self.tie = @"9";
                break;
            case kTen:
                self.tie = @"10";
                break;
            case kJack:
                self.tie = @"J";
                break;
            case kQueen:
                self.tie = @"Q";
                break;
            case kKing:
                self.tie = @"K";
                break;
            default:
                self.tie = @"0";
                break;
        }
        
    }

    return self;
}

-(instancetype)initWithFacesAndSuits:(Suit)suit tie:(Tie)face {
    
    self = [super init];

    if (self) {

        switch (suit) {
            case kSpades:
                self.suit = @"S";
                break;
            case kClub:
                self.suit = @"C";
                break;
            case kDimond:
                self.suit = @"D";
                break;
            default:
                self.suit = @"H";
                break;
        }
        
        switch (face) {
            case kAce:
                self.tie = @"1";
                break;
            case kTwo:
                self.tie = @"2";
                break;
            case kThree:
                self.tie = @"3";
                break;
            case kFour:
                self.tie = @"4";
                break;
            case kFive:
                self.tie = @"5";
                break;
            case kSix:
                self.tie = @"6";
                break;
            case kSeven:
                self.tie = @"7";
                break;
            case kEight:
                self.tie = @"8";
                break;
            case kNine:
                self.tie = @"9";
                break;
            case kTen:
                self.tie = @"10";
                break;
            case kJack:
                self.tie = @"J";
                break;
            case kQueen:
                self.tie = @"Q";
                break;
            case kKing:
                self.tie = @"K";
                break;
            default:
                self.tie = @"0";
                break;
        }
        
        switch (face) {
            case kAce:
                self.points = 1;
                break;
            case kTwo:
                self.points = 2;
                break;
            case kThree:
                self.points = 3;
                break;
            case kFour:
                self.points = 4;
                break;
            case kFive:
                self.points = 5;
                break;
            case kSix:
                self.points = 6;
                break;
            case kSeven:
                self.points = 7;
                break;
            case kEight:
                self.points = 8;
                break;
            case kNine:
                self.points = 9;
                break;
            default:
                self.points = 0;
                break;
        }
    }

    return self;
}

- (NSString *)pointsDescription {
    
    return [[NSString alloc] initWithFormat:@"%d", self.points];
}

- (NSString *)facesDescription {
    
    return [[NSString alloc] initWithFormat:@"%@", self.tie];
}




@end
