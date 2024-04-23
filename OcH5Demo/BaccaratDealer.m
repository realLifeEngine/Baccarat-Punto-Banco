//
//  BaccaratDealer.m
//  CasinoGalaxy-mobile
//
//  Reconfigured by Mewlan Musajan on 3/30/24.
//  Created by chenran on 16/5/22.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "BaccaratDealer.h"

@implementation BaccaratDealer

- (instancetype)init {
    self = [super init];
    if (self) {
        self.deck = [[BaccaratCardDeck alloc] init];
        self.playerCards = [[NSMutableArray alloc] init];
        self.bankerCards = [[NSMutableArray alloc] init];
        self.playerCardCount = 0;
        self.playerCard3 = 0; // check
        self.playerScore = 0;
        self.bankerScore = 0;
//        self.canPlayerStartTheGame = NO;
    }
    return self;
}

- (void)bankerTurn {
    if (_deck.cards.count > 0) {
        [_bankerCards addObject:[_deck.cards lastObject]];
        [_deck.cards removeLastObject];
        [self getTotalPointsAsPlayer:NO];
    } else {
        return;
    }

}

//- (void)checkBankerBets:(int)betAmount {
//}

- (void)checkDraw { /// Check Draw means: check draw
    /// If neither hand has eight or nine, the drawing rules are applied to determine whether the player should receive a third card.
    if ((_playerCardCount < 3) && ((_playerScore == 8 || _bankerScore == 8) || (_playerScore == 9 || _bankerScore == 9))) {
        [self compareTotal];
    } else if (_playerScore == _bankerScore) {
        [self checkTie];
    } else if ((_playerScore == 6 || _playerScore == 7) && _bankerScore <= 5) { /// If the player has an initial total of 6 or 7, they stand.
        [self bankerTurn];
        [self compareTotal];
        /// TODO: GET BACK HERE 2
    } else if (_playerScore <= 5) {         /// If the player has an initial total of 5 or less
        [self playerTurn]; /// they draw a third card.
        if (_playerCardCount == 3) {
            /// !!!: potential bug
            /// if either the player or banker or both achieve a total of 8 or 9 at this stage, the coup is fanished and result is announced
            /// !!!:
            /// ???: Then, based on the value of any card drawn to the player, the drawing rules are applied to determine whether the banker should receive a third card. The coup is then finishedk, the outcome is announcd, and winning bets are paid out.
            ///
            /// TODO: get back here 3: Tableau of drawing rules may fix this problem

            _playerCard3 = _playerCards[_playerCardCount - 1].points;

        }

        if (_bankerScore == 7) {
            NSLog(@"banker total is 7, they stand.");
            [self compareTotal];
        }
        else {
            if (_bankerScore <= 2) {
                [self bankerTurn];
            } else {
                BOOL bankerHadThirdCard = NO;
                switch (_playerCard3) {
                    case 8:
                        if (_bankerScore == 3 && !bankerHadThirdCard) {
                            [self bankerTurn];
                        }
                        break;
                    case 2:
                    case 3:
                    case 4:
                        if (_bankerScore == 5 && !bankerHadThirdCard) {
                            [self bankerTurn];
                        }
                    case 5:
                    case 6:
                        if (_bankerScore == 6 && !bankerHadThirdCard) {
                            [self bankerTurn];
                        }
                    case 7:
                        if (_bankerScore == 4 && !bankerHadThirdCard) {
                            [self bankerTurn];
                        }
                        break;
                    default:
                        break;
                }
            }
        }
    }
    
}

//- (void)checkPlayerBets:(int)betAmount {
//}

- (void)checkTie {
    if (_playerScore < 5 && _playerCard3 < 3) {
        [self playerTurn];
        [self checkDraw];
    } else {
        [self compareTotal];
    }
}

//- (void)checkTieBets:(int)betAmount {
//}

- (void)compareTotal {
    if (_playerScore == _bankerScore) {
        self.baccaratPuntoBancoBetResultCase = kPuntoBanco;
        NSLog(@"THIS IS A TIE from selecter:(compareTotal)");
    } else if (_playerScore > _bankerScore) {
        self.baccaratPuntoBancoBetResultCase = kPuntoWin;
        NSLog(@"THIS IS A PLAYER WIN from selecter:(compareTotal)");
    } else if (_bankerScore > _playerScore) {
        self.baccaratPuntoBancoBetResultCase = kBancoWin;
        NSLog(@"THIS IS A BNAKER WIN from selecter:(compareTotal)");
    }
}

- (void)freshDeck {
    _deck = [[BaccaratCardDeck alloc] init];
}

- (void)playerTurn {
    if (_deck.cards.count > 0) {
        [_playerCards addObject:[_deck.cards lastObject]];
        [_deck.cards removeLastObject];
        _playerCardCount += 1;
        [self getTotalPointsAsPlayer:YES];
    } else {
        return;
    }
}

- (void)getTotalPointsAsPlayer: (BOOL)playerTurn {
    /// !!!: fix this 1
    if (playerTurn) {
        _playerScore = 0;
        for (int i = 0; i < _playerCards.count; i++) {
            _playerScore += _playerCards[i].points;
            _playerScore = _playerScore % 10;
        }
    } else {
        _bankerScore = 0;
        for (int i = 0; i < _bankerCards.count; i++) {
            _bankerScore += _bankerCards[i].points;
            _bankerScore = _bankerScore % 10;
        }
    }
}

//- (void)totalSet:(int)setChipTotal {
//}
//
//- (void)cashOut:(nonnull NSString *)outcome {
//}

@end
