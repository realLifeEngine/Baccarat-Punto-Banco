//
//  BaccaratCardDeck.m
//  CasinoGalaxy-mobile
//
//  Reconfigured by Mewlan Musajan on 3/29/24.
//  Created by chenran on 16/5/22.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "BaccaratCardDeck.h"
#import "NSMutableArray+Shuffle.h"

@implementation BaccaratCardDeck
- (instancetype)init {
    self = [super init];
    self.cards = [[NSMutableArray alloc] init];
    if (self) {
        for (int i = 0; i < 4; i++) {
            for (int j = 1; j <= 13; j++) {
                /// !!!: fix this PUNTO BANCO is deal from a shoe containing 6 or 8 decks of cards shuffled together; 
                ///  each allocation indicates one 52 card deck
                [self.cards addObject:[[BaccaratCard alloc] initWithPointsAndSuits:i tie:j]];
                [self.cards addObject:[[BaccaratCard alloc] initWithFacesAndSuits:i tie:j]];
                [self.cards addObject:[[BaccaratCard alloc] initWithPointsAndSuits:i tie:j]];
                [self.cards addObject:[[BaccaratCard alloc] initWithFacesAndSuits:i tie:j]];
                [self.cards addObject:[[BaccaratCard alloc] initWithPointsAndSuits:i tie:j]];
                [self.cards addObject:[[BaccaratCard alloc] initWithFacesAndSuits:i tie:j]];
                [self.cards addObject:[[BaccaratCard alloc] initWithFacesAndSuits:i tie:j]];
                [self.cards addObject:[[BaccaratCard alloc] initWithFacesAndSuits:i tie:j]];
            }

        }
    }

    return self;
}

- (NSString *)description {
    NSMutableArray *deckOfStrings = [[NSMutableArray alloc] initWithObjects:@"", nil];
    [self init];
    NSLog(@"117 %@", self.cards[0].description);
    for (BaccaratCard *card in self.cards) {
        [deckOfStrings addObject:card.description];
        NSLog(@"%@", card.description);
    }
    return [deckOfStrings componentsJoinedByString:@", "];
}

- (void)shuffle {
    [self.cards shuffle];
}

@end
