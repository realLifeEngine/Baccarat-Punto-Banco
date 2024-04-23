//
//  BaccaratDealer.h
//  CasinoGalaxy-mobile
//
//  Reconfigured by Mewlan Musajan on 3/30/24.
//  Created by chenran on 16/5/22.
//  Copyright © 2016年 simon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaccaratCardDeck.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum {
    kPuntoBanco,
    kPuntoWin,
    kBancoWin
} BaccaratPuntoBancoBetResultCase;


@interface BaccaratDealer : NSObject
@property (strong, nonatomic) BaccaratCardDeck *deck;
@property (strong, nonatomic) NSMutableArray<BaccaratCard*> *playerCards;
@property (strong, nonatomic) NSMutableArray<BaccaratCard*> *bankerCards;
@property (assign, nonatomic) NSInteger playerCardCount;
@property (assign, nonatomic) NSInteger playerCard3;
@property (assign, nonatomic) NSInteger playerScore;
@property (assign, nonatomic) NSInteger bankerScore;
@property (assign, nonatomic) BaccaratPuntoBancoBetResultCase baccaratPuntoBancoBetResultCase;
//@property (assign, nonatomic) BOOL gameOn;
//@property (assign, nonatomic) BOOL canPlayerStartTheGame;

- (void)freshDeck;
- (void)playerTurn;
- (void)bankerTurn;
- (void)checkDraw;
- (void)checkTie;
- (void)compareTotal;
//- (void)cashOut: (NSString *) outcome;
//- (void)totalSet: (int) setChipTotal;
//- (void)clearBets;
//- (void)checkPlayerBets: (int) betAmount;
//- (void)checkBankerBets: (int) betAmount;
//- (void)checkTieBets: (int) betAmount;
@end

NS_ASSUME_NONNULL_END
