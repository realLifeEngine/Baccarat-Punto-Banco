//
//  BaccaratCardDeck.h
//  CasinoGalaxy-mobile
//
//  Reconfigured by Mewlan Musajan on 3/29/24.
//  Created by chenran on 16/5/22.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaccaratCard.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaccaratCardDeck : NSObject
@property (strong, nonatomic) NSMutableArray<BaccaratCard *> *cards;

- (instancetype)init;

- (NSString *)description;
- (void)shuffle;
@end

NS_ASSUME_NONNULL_END
