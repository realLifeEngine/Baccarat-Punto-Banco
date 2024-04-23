//
//  SideAView.m
//  3PattiGalaxy-mobile
//
/// !!!:  Created by SUCCUBUS and do not modify by any means
//  Reconfigured by Mewlan Musajan on 3/13/24.
//

#import "SideAView.h"
#import "card.h"
#import "GameSelectionViewController.h"
#import "IWICasinoSettingsViewController.h"

#define LUCKY_NUMBER 7

typedef enum {
    kLostBusted,
    kWonLucky5,
    kLostLuckyDealer5,
    kWonBustedDealer,
    kLostShort,
    kWonBig,
    kDraw
} GameResultCase;


@interface SideAView ()
@property (strong, nonatomic) UIViewController *homeViewController;
@property (strong, nonatomic) UIViewController *iWICasinoTableViewController;

@property (strong, nonatomic) AVAudioSession *audioSession;

@property (assign, nonatomic) BOOL isBetView;
@property (assign, nonatomic) BOOL isGameOver;
@property (assign, nonatomic) BOOL isDoubleDown;
@property (assign, nonatomic) BOOL isAudioMuted;

@property (strong, nonatomic) UIButton *settingsButton;
@property (strong, nonatomic) UIButton *speakerButton;
@property (strong, nonatomic) UIButton *homeButton;
@property (strong, nonatomic) UIButton *questionButton;
@property (strong, nonatomic) UIButton *dollarsignButton;
@property (strong, nonatomic) UIButton *dealButton;

@property (strong, nonatomic) UIButton *hitButton;
@property (strong, nonatomic) UIButton *standButton;
@property (strong, nonatomic) UIButton *doubleDownButton;

@property (strong, nonatomic) UILabel *headlineLabel;
@property (strong, nonatomic) UILabel *moneyLabel;
@property (strong, nonatomic) UILabel *totalChipsLabel;
@property (strong, nonatomic) UILabel *dealLabel;

@property (strong, nonatomic) UIImageView *totalChipsImage;

@property (strong, nonatomic) CoreTextArcView *blackjackLabel;
@property (strong, nonatomic) CoreTextArcView *blackjackSubLabel;

@property (strong, nonatomic) UIColor *themeColor;

@property (strong, nonatomic) CustomButton *firstChip;
@property (strong, nonatomic) CustomButton *secondChip;
@property (strong, nonatomic) CustomButton *thirdChip;
@property (strong, nonatomic) CustomButton *fourthChip;
@property (strong, nonatomic) CustomButton *theFifthChip;
@property (strong, nonatomic) CustomButton *sixthChip;

@property (strong, nonatomic) UIImageView *aiCard0;
@property (strong, nonatomic) UIImageView *aiCard1;
@property (strong, nonatomic) UIImageView *aiCard2;
@property (strong, nonatomic) UIImageView *aiCard3;
@property (strong, nonatomic) UIImageView *aiCard4;

@property (strong, nonatomic) UIImage *aiCardImage0;
@property (strong, nonatomic) UIImage *aiCardImage1;
@property (strong, nonatomic) UIImage *aiCardImage2;
@property (strong, nonatomic) UIImage *aiCardImage3;
@property (strong, nonatomic) UIImage *aiCardImage4;

@property (strong, nonatomic) UIImageView *playerCard0;
@property (strong, nonatomic) UIImageView *playerCard1;
@property (strong, nonatomic) UIImageView *playerCard2;
@property (strong, nonatomic) UIImageView *playerCard3;
@property (strong, nonatomic) UIImageView *playerCard4;

@property (strong, nonatomic) UIImage *playerCardImage0;
@property (strong, nonatomic) UIImage *playerCardImage1;
@property (strong, nonatomic) UIImage *playerCardImage2;
@property (strong, nonatomic) UIImage *playerCardImage3;
@property (strong, nonatomic) UIImage *playerCardImage4;

@property (strong, nonatomic) UIImage *backSideImage;

@property (strong, nonatomic) UILabel *aiPointsLabel;
@property (strong, nonatomic) UILabel *playerPointsLabel;

@property (strong, nonatomic) UILabel *resultLabel;
@property (strong, nonatomic) UILabel *hintLabel;

// BlackJack
@property (assign, nonatomic) NSInteger money;
@property (assign, nonatomic) NSInteger currentRoundBetAmount;


@property (nonatomic, strong) NSTimer *aiHitTimer;

@end

@implementation SideAView {
    CALayer *disableLayer;

    NSInteger playerPoints, aiPoints, hitButtonCounter, numberOfRemainingCards, aiHitCounter, round;
    //all integers are initialize to 0 as default
    
    NSMutableArray *remainingCards;
    AVAudioPlayer *dealCardSound;
    AVAudioPlayer *LoseSound;
    AVAudioPlayer *WinSound;
    int playerNumberOfAce;
    int aiNumberOfAce;
    NSString *losingMessage;
    NSString *winningMessage;
    GameResultCase gameResultCase;
}

- (void) saveMostMoney{
    if (self.money > [self getMostMoney]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(self.money) forKey:@"mostMoney"];
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM, YYYY' at 'hh:mm a"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        NSString *dateOfMostMoney = resultString;
        [[NSUserDefaults standardUserDefaults] setObject:dateOfMostMoney forKey:@"dateOfMostMoney"];
    }
}

-(NSInteger)getMostMoney
{
    NSInteger currentScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"mostMoney"];
    return currentScore;
}

- (void) saveMostConsecutiveRounds{
    if (round > [self getMostConsecutiveRounds]) {
        [[NSUserDefaults standardUserDefaults] setObject:@(round) forKey:@"mostConsecutiveRounds"];
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM, YYYY' at 'hh:mm a"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        NSString *dateOfMostConsecutiveRounds = resultString;
        [[NSUserDefaults standardUserDefaults] setObject:dateOfMostConsecutiveRounds forKey:@"dateOfMostConsecutiveRounds"];
    }
}

-(NSInteger) getMostConsecutiveRounds
{
    NSInteger currentRoundNumber = [[NSUserDefaults standardUserDefaults] integerForKey:@"mostConsecutiveRounds"];
    return currentRoundNumber;
}

- (void)saveLargestBet {
    if (_currentRoundBetAmount > [self getLargestBet]) {
        [[NSUserDefaults standardUserDefaults] setInteger:_currentRoundBetAmount forKey:@"largestBet"];
        NSDate *currentTime = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"dd MMMM, YYYY' at 'hh:mm a"];
        NSString *resultString = [dateFormatter stringFromDate: currentTime];
        NSString *dateOfLargestBet = resultString;
        [[NSUserDefaults standardUserDefaults] setObject:dateOfLargestBet forKey:@"dateOfLargestBet"];
    }
}

-(NSInteger) getLargestBet
{
    NSInteger currentLargestBet = [[NSUserDefaults standardUserDefaults] integerForKey:@"largestBet"];
    return currentLargestBet;
}

- (void) resetMoneyBet {
    self.money = 500;
    _moneyLabel.text = [NSString stringWithFormat:@"%ld", (long)_money];
    _currentRoundBetAmount = 0;
}

-(void) resetCardDeck
{
    playerNumberOfAce = 0;
    aiNumberOfAce = 0;
    numberOfRemainingCards = 52; //start counting at 0
    
    for (int i = 1; i<=13; i++)
    {
        for (int j=0 ; j<=3; j++)
        {
            card *currentCard = [[card alloc] init];
            currentCard.rank = i;
            
            if (j==0){
                currentCard.suite = [NSString stringWithFormat:@"S"];
            }
            else if (j==1){
                currentCard.suite = [NSString stringWithFormat:@"C"];
            }
            else if (j==2){
                currentCard.suite = [NSString stringWithFormat:@"D"];
            }
            else if (j==3){
                currentCard.suite = [NSString stringWithFormat:@"H"];
            }
            
            NSString *cardName = [NSString stringWithFormat:@"%d%@", currentCard.rank, currentCard.suite];
            currentCard.image = [UIImage imageNamed:cardName];
            NSLog(@"%@", cardName);
            
            /*Fix the rank of the cards to match Black Jack rules. The default rank of an Ace is 11 */
            if (i==1){
                currentCard.rank = 11;
            }
            else if (i>=2 && i <= 10){
                currentCard.rank = i;}
            else {
                currentCard.rank = 10;
            }
            
            [remainingCards addObject:currentCard];
        }
    }
}


-(void)playDealCardSound
{
    if (_isAudioMuted) {
        [self doNothing];
    } else {
        NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                                   pathForResource:@"TurnCard"
                                                   ofType:@"caf"]];
        dealCardSound = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
        dealCardSound.volume=1.0f;
        [dealCardSound play];

    }
}

-(void)drawCardAtBeginning{
    [self aiHit];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
    dispatch_get_main_queue(), ^{
        [self hitButtonTapped];
        [self playDealCardSound];
    });
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.3 * NSEC_PER_SEC)),
    dispatch_get_main_queue(), ^{
        [self hitButtonTapped];
        [self playDealCardSound];
    });

}


- (void)gameSetup {
    round = [[NSUserDefaults standardUserDefaults] integerForKey:@"round"];
    NSLog(@"%ld", (long)round);
    if (round != 0) {
        // 👇🏼 this line of code is a bug
//        _currentRoundBetAmount = [[NSUserDefaults standardUserDefaults] integerForKey:@"currentRoundBetAmount"];
        _totalChipsLabel.text = [NSString stringWithFormat:@"$%ld", (long)_currentRoundBetAmount];
        
//        self.money = [[NSUserDefaults standardUserDefaults] integerForKey:@"money"];
        _moneyLabel.text = [NSString stringWithFormat:@"%ld", (long)_money];
        
        _isBetView = NO;
        [self setNeedsDisplay];
    } else {
        round++;
        [self resetMoneyBet];
        _isBetView = YES;
    }
    
    remainingCards = [[NSMutableArray alloc] initWithCapacity:51];
    [self resetCardDeck];
    [self playDealCardSound];
    [self drawCardAtBeginning];
}

- (card*) drawCard{
    int cardIndex = arc4random()%(numberOfRemainingCards);
    card *drawedCard = [remainingCards objectAtIndex:cardIndex];
    
    [remainingCards removeObjectAtIndex:cardIndex];
    numberOfRemainingCards--;
    return drawedCard;
}

-(void)aiHit{
    aiHitCounter ++;
    card *drawedCard = [self drawCard];
    if (drawedCard.rank==11) {
        aiNumberOfAce++;
    }
    if (aiHitCounter < 3) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * self->aiHitCounter * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            if(self->aiHitCounter == 1){
                self->_aiCardImage0 = drawedCard.image;
                self->aiPoints += drawedCard.rank;
                self->_aiPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)self->aiPoints];
            }
            else if(self->aiHitCounter == 2){
                self->_aiCardImage1 =drawedCard.image;
                self->aiPoints += drawedCard.rank;
                self->_aiPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)self->aiPoints];
            }
            [self playDealCardSound];
            [self setNeedsDisplay];
        });
    }



}

-(void)playLosingSound
{
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Losing Sound"
                                               ofType:@"wav"]];
    LoseSound = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    [LoseSound play];
    LoseSound.volume = 0.7f;
}

-(void)playWinningSound
{
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"Winning Sound"
                                               ofType:@"caf"]];
    WinSound = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    [WinSound play];
}

- (void)drawRect:(CGRect)rect {
    
    // Drawing code
    CGRect bounds = self.bounds;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"green_felt"];
    
    for (int i = 0; i < LUCKY_NUMBER; i++) {
        for (int j = 0; j < LUCKY_NUMBER; j++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i * bounds.size.width / LUCKY_NUMBER, 0 + j * bounds.size.height / LUCKY_NUMBER, backgroundImage.size.width, backgroundImage.size.height)];
            [self addSubview:imageView];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:backgroundImage];
            
        }
    }
    
    /// TODO: Copy from here
    
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    
    _settingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_settingsButton setBackgroundImage:[UIImage imageNamed:@"gear.a49f6d"] forState:UIControlStateNormal];
    _settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_settingsButton];
    
    /// TODO: and here is the speaker
    _speakerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_speakerButton setBackgroundImage:[UIImage imageNamed:_isAudioMuted ? @"speaker.slash.a49f6d" : @"speaker.wave.2.a49f6d"] forState:UIControlStateNormal];
    _speakerButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_speakerButton addTarget:self action:@selector(speakerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_speakerButton];
    
    _homeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_homeButton setBackgroundImage:[UIImage imageNamed:@"house.a49f6d"] forState:UIControlStateNormal];
    _homeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_homeButton addTarget:self action:@selector(homeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_homeButton];
    
    _questionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_questionButton setBackgroundImage:[UIImage imageNamed:@"questionmark.a49f6d"] forState:UIControlStateNormal];
    _questionButton.translatesAutoresizingMaskIntoConstraints = NO;
    _questionButton.hidden = YES;
    
    [_questionButton addTarget:self action:@selector(questionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_questionButton];
    
    _dollarsignButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dollarsignButton setBackgroundImage:[UIImage imageNamed:@"dollarsign.a49f6d"] forState:UIControlStateNormal];
    _dollarsignButton.translatesAutoresizingMaskIntoConstraints = NO;
    _dollarsignButton.hidden = YES;
    
    [_dollarsignButton addTarget:self action:@selector(dollarsignButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_dollarsignButton];
    
    _dealButton = [UIButton buttonWithType:UIButtonTypeSystem];
    if (_isBetView) {
        [_dealButton setBackgroundImage:[UIImage imageNamed:@"icons8-bet-62"] forState:UIControlStateNormal];
        [_dealButton addTarget:self action:@selector(dealButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [_dealButton setBackgroundImage:[UIImage imageNamed:@"arrow.counterclockwise.a49f6d"] forState:UIControlStateNormal];
        [_dealButton addTarget:self action:@selector(newRound) forControlEvents:UIControlEventTouchUpInside];
    }
    _dealButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_dealButton];
    
    _dealLabel = [[UILabel alloc] init];
    if (_isBetView) {
        [_dealLabel setText:@"BET"];
    } else {
        [_dealLabel setText:@"Start Over"];
    }
    _dealLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_dealLabel setFont:[UIFont fontWithName:@"Charter Black" size:21]];
    [_dealLabel setTextColor:[UIColor blackColor]];
    [_dealLabel setTextAlignment:NSTextAlignmentRight];

    [self addSubview:_dealLabel];
    
    _themeColor = [UIColor colorWithRed:0.64 green:0.62 blue:0.43 alpha:1.0];
    
    _headlineLabel = [[UILabel alloc] init];
    [_headlineLabel setText:@"iWillook Casino Real™"];
    _headlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_headlineLabel setFont:[UIFont fontWithName:@"Charter" size:32]];
    [_headlineLabel setTextColor:_themeColor];
    [self addSubview:_headlineLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    [_moneyLabel setText:[NSString stringWithFormat:@"%ld", (long)_money]];
    _moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_moneyLabel setFont:[UIFont fontWithName:@"Charter" size:32]];
    [_moneyLabel setTextColor:_themeColor];
    [_moneyLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_moneyLabel];
    
    _blackjackLabel = [[CoreTextArcView alloc]
                                     initWithFrame:CGRectMake(bounds.size.width / 6, -117, bounds.size.width / 1.5, bounds.size.height)
                                     font:[UIFont fontWithName:@"Charter" size:32]
                                     text:@"BLACKJACK PAYS 3 TO 2"
                                     radius:-((bounds.size.width / 1.5) / 2)
                                     arcSize: -90
                                   color: _themeColor];
    [_blackjackLabel setBackgroundColor:[UIColor clearColor]];
    
    [self addSubview:_blackjackLabel];
    
    _blackjackSubLabel = [[CoreTextArcView alloc]
                                     initWithFrame:CGRectMake(0, 27, bounds.size.width / 1.5, bounds.size.height)
                                     font:[UIFont systemFontOfSize:21]
                                     text:@"Dealer must stand on all 17s"
                                     radius:-((bounds.size.width / 1.5) / 2)
                                     arcSize: -67
                                   color: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
    [_blackjackSubLabel setBackgroundColor:[UIColor clearColor]];
    
    [_blackjackLabel addSubview:_blackjackSubLabel];
    
    _totalChipsImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icons8-casino-chip-64"]];
    _totalChipsImage.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_totalChipsImage];
    
    
    _totalChipsLabel = [[UILabel alloc] init];
    [_totalChipsLabel setText:[NSString stringWithFormat:@"$%ld", (long)_currentRoundBetAmount]];
    _totalChipsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_totalChipsLabel setFont:[UIFont fontWithName:@"Charter" size:32]];
    [_totalChipsLabel setTextColor:[UIColor whiteColor]];
    [_totalChipsLabel setTextAlignment:NSTextAlignmentCenter];
    [self addSubview:_totalChipsLabel];
    
    [_firstChip setBackgroundImage:[UIImage imageNamed:@"icons8-chip-80"] forState:UIControlStateNormal];
    _firstChip.translatesAutoresizingMaskIntoConstraints = NO;
    NSAttributedString *firstChipString = [[NSAttributedString alloc] initWithString:@"1" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
    [_firstChip setAttributedTitle:firstChipString forState:UIControlStateNormal];
    [_firstChip addTarget:self action:@selector(firstChipButtonTapped) forControlEvents:UIControlEventTouchUpInside];

    [_secondChip setBackgroundImage:[UIImage imageNamed:@"icons8-chip-80(1)"] forState:UIControlStateNormal];
    _secondChip.translatesAutoresizingMaskIntoConstraints = NO;
    [_secondChip addTarget:self action:@selector(secondChipButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *secondChipString = [[NSAttributedString alloc] initWithString:@"5" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
    [_secondChip setAttributedTitle:secondChipString forState:UIControlStateNormal];
    
    [_thirdChip setBackgroundImage:[UIImage imageNamed:@"icons8-chip-80(2)"] forState:UIControlStateNormal];
    _thirdChip.translatesAutoresizingMaskIntoConstraints = NO;
    [_thirdChip addTarget:self action:@selector(thirdChipButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *thirdChipString = [[NSAttributedString alloc] initWithString:@"25" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
    [_thirdChip setAttributedTitle:thirdChipString forState:UIControlStateNormal];
   
    [_fourthChip setBackgroundImage:[UIImage imageNamed:@"icons8-chip-80(3)"] forState:UIControlStateNormal];
    _fourthChip.translatesAutoresizingMaskIntoConstraints = NO;
    [_fourthChip addTarget:self action:@selector(fourthChipButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *fourthChipString = [[NSAttributedString alloc] initWithString:@"100" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
    [_fourthChip setAttributedTitle:fourthChipString forState:UIControlStateNormal];

    [_theFifthChip setBackgroundImage:[UIImage imageNamed:@"icons8-chip-80(4)"] forState:UIControlStateNormal];
    _theFifthChip.translatesAutoresizingMaskIntoConstraints = NO;
    [_theFifthChip addTarget:self action:@selector(theFifthChipButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *theFifthChipString = [[NSAttributedString alloc] initWithString:@"500" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
    [_theFifthChip setAttributedTitle:theFifthChipString forState:UIControlStateNormal];
    
    [_sixthChip setBackgroundImage:[UIImage imageNamed:@"icons8-chip-80(5)"] forState:UIControlStateNormal];
    _sixthChip.translatesAutoresizingMaskIntoConstraints = NO;
    [_sixthChip addTarget:self action:@selector(sixthChipButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    NSAttributedString *sixthChipString = [[NSAttributedString alloc] initWithString:@"1,000" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
    [_sixthChip setAttributedTitle:sixthChipString forState:UIControlStateNormal];
    
    if (_isBetView) {
        [self addSubview:_firstChip];
        [self addSubview:_secondChip];
        [self addSubview:_thirdChip];
        [self addSubview:_fourthChip];
        [self addSubview:_theFifthChip];
        [self addSubview:_sixthChip];
    }

    _aiCard0 = [[UIImageView alloc] initWithImage:_aiCardImage0];
    _aiCard0.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_aiCard0];
    if (!_isBetView && aiHitCounter == 1) {
        _backSideImage = [UIImage imageNamed:@"8009b"];
        _aiCard1 = [[UIImageView alloc] initWithImage:_backSideImage];
    } else {
        _aiCard1 = [[UIImageView alloc] initWithImage:_aiCardImage1];
    }
    _aiCard1.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_aiCard1];

    
    _aiCard2 = [[UIImageView alloc] initWithImage:_aiCardImage2];
    _aiCard2.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_aiCard2];

    
    _aiCard3 = [[UIImageView alloc] initWithImage:_aiCardImage3];
    _aiCard3.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_aiCard3];

    
    _aiCard4 = [[UIImageView alloc] initWithImage:_aiCardImage4];
    _aiCard4.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_aiCard4];
    
    _playerCard0 = [[UIImageView alloc] initWithImage:_playerCardImage0];
    _playerCard0.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_playerCard0];
    
    _playerCard1 = [[UIImageView alloc] initWithImage:_playerCardImage1];
    _playerCard1.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_playerCard1];

    
    _playerCard2 = [[UIImageView alloc] initWithImage:_playerCardImage2];
    _playerCard2.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_playerCard2];

    
    _playerCard3 = [[UIImageView alloc] initWithImage:_playerCardImage3];
    _playerCard3.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_playerCard3];

    
    _playerCard4 = [[UIImageView alloc] initWithImage:_playerCardImage4];
    _playerCard4.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_playerCard4];
    
    if (_isBetView) {
        _aiCard0.hidden = YES;
        _aiCard1.hidden = YES;
        _aiCard2.hidden = YES;
        _aiCard3.hidden = YES;
        _aiCard4.hidden = YES;
        
        _playerCard0.hidden = YES;
        _playerCard1.hidden = YES;
        _playerCard2.hidden = YES;
        _playerCard3.hidden = YES;
        _playerCard4.hidden = YES;
    } else {
        _aiCard0.hidden = NO;
        _aiCard1.hidden = NO;
        _aiCard2.hidden = NO;
        _aiCard3.hidden = NO;
        _aiCard4.hidden = NO;
        
        _playerCard0.hidden = NO;
        _playerCard1.hidden = NO;
        _playerCard2.hidden = NO;
        _playerCard3.hidden = NO;
        _playerCard4.hidden = NO;
    }
    
    if (!_isGameOver && !_isBetView) {
        _standButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _hitButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _doubleDownButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        _standButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_standButton addTarget:self action:@selector(standButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString *standButtonString = [[NSAttributedString alloc] initWithString:@"Stand" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
        [_standButton setAttributedTitle:standButtonString forState:UIControlStateNormal];
        [_standButton.layer setBorderColor:_themeColor.CGColor];
        [_standButton.layer setBorderWidth:1.5f];
        [self addSubview:_standButton];
        
        
        _hitButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_hitButton addTarget:self action:@selector(hitButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString *hitButtonString = [[NSAttributedString alloc] initWithString:@"Hit" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
        [_hitButton setAttributedTitle:hitButtonString forState:UIControlStateNormal];
        [_hitButton.layer setBorderColor:_themeColor.CGColor];
        [_hitButton.layer setBorderWidth:1.5f];
        [self addSubview:_hitButton];

        
        _doubleDownButton.translatesAutoresizingMaskIntoConstraints = NO;
        [_doubleDownButton addTarget:self action:@selector(doubleDownButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        NSAttributedString *doubleDownButtonString = [[NSAttributedString alloc] initWithString:@"Double Down" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24 weight:UIFontWeightBold], NSForegroundColorAttributeName: UIColor.whiteColor}];
        [_doubleDownButton setAttributedTitle:doubleDownButtonString forState:UIControlStateNormal];
        [_doubleDownButton.layer setBorderColor:_themeColor.CGColor];
        [_doubleDownButton.layer setBorderWidth:1.5f];
        [self addSubview:_doubleDownButton];
    }

    
    _resultLabel = [[UILabel alloc] init];
    _resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_resultLabel setFont:[UIFont fontWithName:@"Charter Bold" size:32]];
    [_resultLabel setTextColor:_themeColor];

    
    
    _hintLabel = [[UILabel alloc] init];
    _hintLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_hintLabel setFont:[UIFont fontWithName:@"Charter" size:17]];
    [_hintLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
    
    NSLog(@"%u", gameResultCase);
    
    losingMessage = [NSString stringWithFormat:@"You've lost $%ld", (long)_currentRoundBetAmount];
    winningMessage = [NSString stringWithFormat:@"You've won $%ld", (long)_currentRoundBetAmount];
    
    if (_isGameOver) {
        /// !!!: game buttons handel
        [_hitButton setHidden:YES];
        [_standButton setHidden:YES];
        [_doubleDownButton setHidden:YES];
        
        losingMessage = [NSString stringWithFormat:@"You've lost $%ld", _isDoubleDown ? (long)_currentRoundBetAmount * 2
                                                  : (long)_currentRoundBetAmount];
        winningMessage = [NSString stringWithFormat:@"You've won $%ld", _isDoubleDown ? (long)_currentRoundBetAmount * 2 : (long)_currentRoundBetAmount];
        
        switch (gameResultCase) {
            case kLostBusted:
                [_resultLabel setText:losingMessage];
                [_hintLabel setText:@"You're busted. Better luck next time"];
                break;
            case kWonLucky5:
                [_resultLabel setText:winningMessage];
                [_hintLabel setText:@"Your total points after drawing 5 cards don't go over 21"];
                break;
            case kLostLuckyDealer5:
                [_resultLabel setText:losingMessage];
                [_hintLabel setText:@"The dealer draws 5 cards without getting over 21"];
                break;
            case kWonBustedDealer:
                [_resultLabel setText:winningMessage];
                [_hintLabel setText:@"The dealer is busted"];
                break;
            case kLostShort:
                [_resultLabel setText:losingMessage];
                [_hintLabel setText:@"The dealer gets closer to 21 than you. Better luck next time"];
                break;
            case kWonBig:
                [_resultLabel setText:winningMessage];
                [_hintLabel setText:@"You get closer to 21 than the dealer. Congratulations"];
                break;
            case kDraw:
                [_resultLabel setText:@"It's a draw."];
                [_hintLabel setText:@"Win win"];
                break;
            default:
                [_resultLabel setText:@""];
                [_hintLabel setText:@""];
                break;
        }
    }
    
    if (_isGameOver && !_isBetView) {
        _resultLabel.hidden = NO;
    } else if (_isBetView) {
        _resultLabel.hidden = YES;
    }
    
    if (_isGameOver && !_isBetView) {
        _hintLabel.hidden = NO;
    } else if (_isBetView) {
        _hintLabel.hidden = YES;
    }
    
    [self addSubview:_resultLabel];
    [self addSubview:_hintLabel];

    
    _aiPointsLabel = [[UILabel alloc] init];
    _aiPointsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_aiPointsLabel setFont:[UIFont fontWithName:@"Charter Bold" size:32]];
    [_aiPointsLabel setTextColor:[UIColor blackColor]];
    [_aiPointsLabel setText:[NSString stringWithFormat:@"%ld Points", (long)aiPoints]];
    [_aiPointsLabel setTextAlignment:NSTextAlignmentRight];
    [self addSubview:_aiPointsLabel];
    if (_isBetView) {
        _aiPointsLabel.hidden = YES;
    } else {
        _aiPointsLabel.hidden = NO;
    }
    
    _playerPointsLabel = [[UILabel alloc] init];
    _playerPointsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_playerPointsLabel setFont:[UIFont fontWithName:@"Charter Bold" size:32]];
    [_playerPointsLabel setTextColor:[UIColor whiteColor]];
    [_playerPointsLabel setText:[NSString stringWithFormat:@"%ld Points", (long)playerPoints]];
    [_playerPointsLabel setTextAlignment:NSTextAlignmentLeft];
    [self addSubview:_playerPointsLabel];

    if (_isBetView) {
        _playerPointsLabel.hidden = YES;
    } else {
        _playerPointsLabel.hidden = NO;
    }
    

    // Get a reference to the safe area layout guide for the view
    UILayoutGuide *safeAreaLayoutGuide = self.safeAreaLayoutGuide;
    
    if (_isBetView) {
        [self addConstraints:@[
            // First Chip Button
            [NSLayoutConstraint constraintWithItem:_firstChip attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_firstChip attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_speakerButton attribute:NSLayoutAttributeLeading multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_firstChip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_firstChip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            // Second Chip Button
            [NSLayoutConstraint constraintWithItem:_secondChip attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_secondChip attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_firstChip attribute:NSLayoutAttributeLeading multiplier:1 constant:99],
            [NSLayoutConstraint constraintWithItem:_secondChip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_secondChip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            // Third Chip Button
            [NSLayoutConstraint constraintWithItem:_thirdChip attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_thirdChip attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_secondChip attribute:NSLayoutAttributeLeading multiplier:1 constant:99],
            [NSLayoutConstraint constraintWithItem:_thirdChip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_thirdChip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            // Fourth Chip Button
            [NSLayoutConstraint constraintWithItem:_fourthChip attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_fourthChip attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_thirdChip attribute:NSLayoutAttributeLeading multiplier:1 constant:99],
            [NSLayoutConstraint constraintWithItem:_fourthChip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_fourthChip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            // The Fifth Chip Button
            [NSLayoutConstraint constraintWithItem:_theFifthChip attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_theFifthChip attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_fourthChip attribute:NSLayoutAttributeLeading multiplier:1 constant:99],
            [NSLayoutConstraint constraintWithItem:_theFifthChip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_theFifthChip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            // Sixth Chip Button
            [NSLayoutConstraint constraintWithItem:_sixthChip attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_sixthChip attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_theFifthChip attribute:NSLayoutAttributeLeading multiplier:1 constant:99],
            [NSLayoutConstraint constraintWithItem:_sixthChip attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_sixthChip attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77]
        ]];
    } else if (!_isGameOver) {
        [self addConstraints:@[
            // Stand Button
            [NSLayoutConstraint constraintWithItem:_standButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_standButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:_standButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
            [NSLayoutConstraint constraintWithItem:_standButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:87],
            // Hit Button
            [NSLayoutConstraint constraintWithItem:_hitButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_hitButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_standButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:-111],
            [NSLayoutConstraint constraintWithItem:_hitButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
            [NSLayoutConstraint constraintWithItem:_hitButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:87],
            // Double Down Button
            [NSLayoutConstraint constraintWithItem:_doubleDownButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
            [NSLayoutConstraint constraintWithItem:_doubleDownButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_standButton attribute:NSLayoutAttributeLeading multiplier:1 constant:111],
            [NSLayoutConstraint constraintWithItem:_doubleDownButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
            [NSLayoutConstraint constraintWithItem:_doubleDownButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:197],
        ]];
    }

    [self addConstraints:@[
        
        // AI Points Label
        [NSLayoutConstraint constraintWithItem:_aiPointsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_aiCard0 attribute:NSLayoutAttributeTop multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_aiPointsLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_dollarsignButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:-58],
        [NSLayoutConstraint constraintWithItem:_aiPointsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_aiPointsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:227],
        
        // Player Points Label
        [NSLayoutConstraint constraintWithItem:_playerPointsLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-22],
        [NSLayoutConstraint constraintWithItem:_playerPointsLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_speakerButton attribute:NSLayoutAttributeLeading multiplier:1 constant:33],
        [NSLayoutConstraint constraintWithItem:_playerPointsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_playerPointsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:227],
        
        // Result Label
        [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:-33],
        [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:227],
        [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width],
        
        // Hint Label
        [NSLayoutConstraint constraintWithItem:_hintLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_hintLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_resultLabel attribute:NSLayoutAttributeLeading multiplier:1 constant:-44],
        [NSLayoutConstraint constraintWithItem:_hintLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_hintLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width],

        
        ///*************
        
        // Settings Button
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Speaker Button
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_settingsButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Home Button
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_isBetView ? _speakerButton : safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:_isBetView ? 66 : 22],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_isBetView ? _settingsButton : safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:_isBetView ? 0 : 66],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Questionmark Button
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:-22],
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Dollarsign Button
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTrailing multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        
        // Money Label
        [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dollarsignButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTrailing multiplier:1 constant:-22],
        [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width],
        // Deal Button
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_moneyLabel attribute:NSLayoutAttributeTop multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_moneyLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Deal Label
        [NSLayoutConstraint constraintWithItem:_dealLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dealButton attribute:NSLayoutAttributeTop multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dealLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_moneyLabel attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dealLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dealLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:227],
        // Headline Label
        [NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2],
        // Total Chips Image
        [NSLayoutConstraint constraintWithItem:_totalChipsImage attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headlineLabel attribute:NSLayoutAttributeTop multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_totalChipsImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_totalChipsImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64],
        [NSLayoutConstraint constraintWithItem:_totalChipsImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:64],
        // Total Chips Label
        [NSLayoutConstraint constraintWithItem:_totalChipsLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_totalChipsImage attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_totalChipsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_totalChipsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_totalChipsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width],
        

        
        // Player Card 0
        [NSLayoutConstraint constraintWithItem:_playerCard0 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_playerCard0 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_speakerButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:77],
        [NSLayoutConstraint constraintWithItem:_playerCard0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_playerCard0 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // Player Card 1
        [NSLayoutConstraint constraintWithItem:_playerCard1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_playerCard1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_playerCard0 attribute:NSLayoutAttributeTrailing multiplier:1 constant:80],
        [NSLayoutConstraint constraintWithItem:_playerCard1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_playerCard1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // Player Card 2
        [NSLayoutConstraint constraintWithItem:_playerCard2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_playerCard2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_playerCard1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:80],
        [NSLayoutConstraint constraintWithItem:_playerCard2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_playerCard2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // Player Card 3
        [NSLayoutConstraint constraintWithItem:_playerCard3 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_playerCard3 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_playerCard2 attribute:NSLayoutAttributeTrailing multiplier:1 constant:80],
        [NSLayoutConstraint constraintWithItem:_playerCard3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_playerCard3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // Player Card 4
        [NSLayoutConstraint constraintWithItem:_playerCard4 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_playerCard4 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_playerCard3 attribute:NSLayoutAttributeTrailing multiplier:1 constant:80],
        [NSLayoutConstraint constraintWithItem:_playerCard4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_playerCard4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // AI Card 0
        [NSLayoutConstraint constraintWithItem:_aiCard0 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:42],
        [NSLayoutConstraint constraintWithItem:_aiCard0 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_dollarsignButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:-58],
        [NSLayoutConstraint constraintWithItem:_aiCard0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_aiCard0 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        // AI Card 1
        [NSLayoutConstraint constraintWithItem:_aiCard1 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:42],
        [NSLayoutConstraint constraintWithItem:_aiCard1 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_aiCard0 attribute:NSLayoutAttributeTrailing multiplier:1 constant:-80],
        [NSLayoutConstraint constraintWithItem:_aiCard1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_aiCard1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        // AI Card 2
        [NSLayoutConstraint constraintWithItem:_aiCard2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:42],
        [NSLayoutConstraint constraintWithItem:_aiCard2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_aiCard1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:-80],
        [NSLayoutConstraint constraintWithItem:_aiCard2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_aiCard2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        // AI Card 3
        [NSLayoutConstraint constraintWithItem:_aiCard3 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:42],
        [NSLayoutConstraint constraintWithItem:_aiCard3 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_aiCard2 attribute:NSLayoutAttributeTrailing multiplier:1 constant:-80],
        [NSLayoutConstraint constraintWithItem:_aiCard3 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_aiCard3 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        // AI Card 4
        [NSLayoutConstraint constraintWithItem:_aiCard4 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:42],
        [NSLayoutConstraint constraintWithItem:_aiCard4 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_aiCard3 attribute:NSLayoutAttributeTrailing multiplier:1 constant:-80],
        [NSLayoutConstraint constraintWithItem:_aiCard4 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_aiCard4 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
    ]];
}

//- (void)questionButtonTapped {
//    // Use RootViewController to manage CCEAGLView
//    _viewController = [[RootViewController alloc]init];
//    _viewController.automaticallyAdjustsScrollViewInsets = NO;
//    _viewController.extendedLayoutIncludesOpaqueBars = NO;
//    _viewController.edgesForExtendedLayout = UIRectEdgeAll;
//    [[UIApplication sharedApplication].keyWindow setRootViewController:_viewController];
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
//}

- (void)doubleDownButtonTapped {
    
    /// !!!: handel this bug
    _isDoubleDown = YES;
    
    if (!_isGameOver) {
        _currentRoundBetAmount = _currentRoundBetAmount * 2;
        [self hitButtonTapped];
        
        if (playerPoints <=21){
            [self aiDrawCard];
        }
        _currentRoundBetAmount = _currentRoundBetAmount / 2;

    }
}

- (void)hitButtonTapped {

    if (!_isGameOver) {

        hitButtonCounter ++;
        card *drawedCard = [self drawCard];
        if (drawedCard.rank==11){
            playerNumberOfAce++;
        }
        
        if(hitButtonCounter == 1){
            _playerCardImage0 =drawedCard.image;
            playerPoints += drawedCard.rank;
            _playerPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)playerPoints];
        }
        else if(hitButtonCounter == 2){
            _playerCardImage1 =drawedCard.image;
            playerPoints += drawedCard.rank;
            _playerPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)playerPoints];
        }
        else if(hitButtonCounter == 3){
            _playerCardImage2 =drawedCard.image;
            playerPoints += drawedCard.rank;
            _playerPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)playerPoints];
        }
        else if(hitButtonCounter == 4){
            _playerCardImage3 =drawedCard.image;
            playerPoints += drawedCard.rank;
            _playerPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)playerPoints];
        }
        else if(hitButtonCounter == 5){
            _playerCardImage4 =drawedCard.image;
            playerPoints += drawedCard.rank;
            _playerPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)playerPoints];
        }
        
        //Automatically "stand" when the player's point is 21
        if (playerPoints == 21)
        {
            [self standButtonTapped];
        }
        

        
        /*Cases when the player automatically win or lose no matter what the dealer does*/
        if (playerPoints > 21 && playerNumberOfAce > 0){
            playerPoints -= 10; //An Ace could be 11 or 1. The difference between 11 and 1 is 10.
            self.playerPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)playerPoints];
            playerNumberOfAce--;
        }
        
        if (playerPoints > 21) {
            _isGameOver = YES;
            gameResultCase = kLostBusted;
            
            self.money = self.money - _currentRoundBetAmount;
            self.moneyLabel.text = [NSString stringWithFormat:@"Total money: $%ld", (long)self.money];
        }
        
        if (hitButtonCounter == 5 && playerPoints <=21)
        {
            _isGameOver = YES;
            
            gameResultCase = kWonLucky5;
    //        [self playWinningSound];
            self.money = self.money + _currentRoundBetAmount;
            self.moneyLabel.text = [NSString stringWithFormat:@"Total money: $%ld", (long)self.money];
        }
        
        [self saveMostMoney];
    }
    [self setNeedsDisplay];
}

- (void)determineWinner{


    
    if (aiHitCounter == 5 && aiPoints <= 21){
        gameResultCase = kLostLuckyDealer5;
        
        self.money = self.money - _currentRoundBetAmount;
        self.moneyLabel.text = [NSString stringWithFormat:@"Total money: $%ld", (long)self.money];
        
        _isGameOver = YES;
        [self setNeedsDisplay];

    }
    else if (aiPoints > 21) {
        gameResultCase = kWonBustedDealer;
        
//        [self playWinningSound];
        self.money = self.money + _currentRoundBetAmount;
        self.moneyLabel.text = [NSString stringWithFormat:@"Total money: $%ld", (long)self.money];
        
        _isGameOver = YES;
        [self setNeedsDisplay];
    }
    else if (aiPoints > playerPoints) {
        gameResultCase = kLostShort;
        self.money = self.money - _currentRoundBetAmount;
        self.moneyLabel.text = [NSString stringWithFormat:@"Total money: $%ld", (long)self.money];
        
        _isGameOver = YES;
        [self setNeedsDisplay];
    }
    
    else if (aiPoints < playerPoints){
        gameResultCase = kWonBig;
//        [self playWinningSound];
        self.money = self.money + _currentRoundBetAmount;
        self.moneyLabel.text = [NSString stringWithFormat:@"Total money: $%ld", (long)self.money];
        
        _isGameOver = YES;
        [self setNeedsDisplay];
    }
    else {
        gameResultCase = kDraw;
        
        _isGameOver = YES;
        [self setNeedsDisplay];
    }
    [self saveMostMoney];
}

- (void)startOver {
    [self newRound];
}

- (void)newRound{
    _currentRoundBetAmount = 0;
    round++;
    
    [self saveMostConsecutiveRounds];
    [self saveLargestBet];
    
    playerPoints = 0;
    aiPoints = 0;
    hitButtonCounter = 0;
    aiHitCounter = 0;
    
    _aiCardImage0 = nil;
    _aiCardImage1 = nil;
    _aiCardImage2 = nil;
    _aiCardImage3 = nil;
    _aiCardImage4 = nil;
    _playerCardImage0 = nil;
    _playerCardImage1 = nil;
    _playerCardImage2 = nil;
    _playerCardImage3 = nil;
    _playerCardImage4 = nil;
    
    [self resetCardDeck];
    _isBetView = YES;
    _isGameOver = NO;
    [self saveProgress];
    
    /// TODO: NOW
    _firstChip = [[CustomButton alloc] init];
    _secondChip = [[CustomButton alloc] init];
    _thirdChip = [[CustomButton alloc] init];
    _fourthChip = [[CustomButton alloc] init];
    _theFifthChip = [[CustomButton alloc] init];
    _sixthChip = [[CustomButton alloc] init];
    
    [self setNeedsDisplay];
}

- (void) saveProgress{
    [[NSUserDefaults standardUserDefaults] setInteger:round forKey:@"round"];
    [[NSUserDefaults standardUserDefaults] setInteger:_currentRoundBetAmount forKey:@"currentRoundBetAmount"];
    [[NSUserDefaults standardUserDefaults] setInteger:self.money forKey:@"money"];
}


- (void)aiDrawCard
{
    while (aiPoints < 17) {
//        [self aiHit];
        aiHitCounter ++;
        if(self->aiHitCounter == 3){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * self->aiHitCounter - 2 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
                card *drawedCard = [self drawCard];
                if (drawedCard.rank==11) {
                    self->aiNumberOfAce++;
                }
                self->_aiCardImage2 = drawedCard.image;
                self->aiPoints += drawedCard.rank;
                self->_aiPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)self->aiPoints];
            });
            [self playDealCardSound];
            [self setNeedsDisplay];
        }
        else if(self->aiHitCounter == 4){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * self->aiHitCounter - 2 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
                card *drawedCard = [self drawCard];
                if (drawedCard.rank==11) {
                    self->aiNumberOfAce++;
                }

                self->_aiCardImage3 =drawedCard.image;
                self->aiPoints += drawedCard.rank;
                self->_aiPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)self->aiPoints];
            });
            [self playDealCardSound];
            [self setNeedsDisplay];
        }
        else if(self->aiHitCounter == 5){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * self->aiHitCounter - 2 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
                card *drawedCard = [self drawCard];
                if (drawedCard.rank==11) {
                    self->aiNumberOfAce++;
                }

                self->_aiCardImage4 =drawedCard.image;
                self->aiPoints += drawedCard.rank;
                self->_aiPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)self->aiPoints];
            });
            [self playDealCardSound];
            [self setNeedsDisplay];
        }
        
        if (self->aiPoints > 21 && self->aiNumberOfAce > 0) {
            self->aiPoints -= 10; // An Ace could be 11 or 1. The difference between 11 and 1 is 10.
            self->_aiPointsLabel.text = [NSString stringWithFormat:@"%ld Points", (long)self->aiPoints];
            self->aiNumberOfAce--;
        }
        [self playDealCardSound];
        [self setNeedsDisplay];
    }
    [self determineWinner];
}

- (void)standButtonTapped {
    if (!_isGameOver) {
        [self aiDrawCard];
    }
}

- (void)dealButtonTapped {
    NSLog(@"BET");
    if (_currentRoundBetAmount == 0) {
        [self complainMakeABet];
    } else {
        [self enterBlackJack];
    }
}

- (void)settingsButtonTapped {
    _iWICasinoTableViewController = [[IWICasinoSettingsViewController alloc]init];
    _iWICasinoTableViewController.extendedLayoutIncludesOpaqueBars = NO;
    _iWICasinoTableViewController.edgesForExtendedLayout = UIRectEdgeAll;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = _iWICasinoTableViewController;
    [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];
}


- (void)speakerButtonTapped {
    NSLog(@"Speaker tapped");
    
    /// TODO: Here
    if (_isAudioMuted) {
        _isAudioMuted = NO;
    } else {
        _isAudioMuted = YES;
    }

    [self setNeedsDisplay];
    
}

- (void)homeButtonTapped {
    /// TODO: implement home
    _homeViewController = [[GameSelectionViewController alloc]init];
    _homeViewController.extendedLayoutIncludesOpaqueBars = NO;
    _homeViewController.edgesForExtendedLayout = UIRectEdgeAll;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = _homeViewController;
    [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionFlipFromTop animations:nil completion:nil];
}

- (void)dollarsignButtonTapped {
    NSLog(@"Dollarsign tapped");
    _money += 50;
    [self setNeedsDisplay];
}

- (void)firstChipButtonTapped {
    NSLog(@"first chip tapped");
    if (_money - 1 >= 0 && _currentRoundBetAmount <= _money) {
        _currentRoundBetAmount += 1;
        [self setNeedsDisplay];
    } else {
        [self complain];
    }
}

- (void)secondChipButtonTapped {
    NSLog(@"second chip tapped");
    if (_money - 5 >= 0 && _currentRoundBetAmount <= _money) {
        _currentRoundBetAmount += 5;
        [self setNeedsDisplay];
    } else {
        [self complain];
    }
}

- (void)thirdChipButtonTapped {
    NSLog(@"third chip tapped");
    if (_money - 25 >= 0 && _currentRoundBetAmount <= _money) {
        _currentRoundBetAmount += 25;
        [self setNeedsDisplay];
    } else {
        [self complain];
    }
}

- (void)fourthChipButtonTapped {
    NSLog(@"fourth chip tapped");
    if (_money - 100 >= 0 && _currentRoundBetAmount <= _money) {
        _currentRoundBetAmount += 100;
        [self setNeedsDisplay];
    } else {
        [self complain];
    }
}

- (void)theFifthChipButtonTapped {
    NSLog(@"fifth chip tapped");
    if (_money - 500 >= 0 && _currentRoundBetAmount <= _money) {
        _currentRoundBetAmount += 500;
        [self setNeedsDisplay];
    } else {
        [self complain];
    }
}

- (void)sixthChipButtonTapped {
    NSLog(@"sixth chip tapped");
    if (_money - 1000 >= 0 && _currentRoundBetAmount <= _money) {
        _currentRoundBetAmount += 1000;
        [self setNeedsDisplay];
    } else {
        [self complain];
    }
}

- (void)complain {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insufficient Balance" message:@"Select a Lower Bet" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
    [alert addAction:ok];
    
    
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    // Present the alert controller
    [topVC presentViewController:alert animated:YES completion:nil];
}

- (void)complainMakeABet {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Make a Bet" message:@"Select a Bet Amount from Below" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
    [alert addAction:ok];
    
    
    UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
    // Present the alert controller
    [topVC presentViewController:alert animated:YES completion:nil];
}

- (void)enterBlackJack {
    [self removeChipsFromSuperview];
    
    _isGameOver = NO;
    
    round++;
    [[NSUserDefaults standardUserDefaults] setInteger:round forKey:@"round"];
    [self gameSetup];
    [self setNeedsDisplay];
}

- (void)doNothing {
    NSLog(@"I'm doing nothing. And it's all good with me.");
}

- (void)removeChipsFromSuperview {
    [_firstChip removeFromSuperview];
    [_secondChip removeFromSuperview];
    [_thirdChip removeFromSuperview];
    [_fourthChip removeFromSuperview];
    [_theFifthChip removeFromSuperview];
    [_sixthChip removeFromSuperview];
}

- (void)removeGameButtonsFromSuperview {
    [_hitButton removeFromSuperview];
    [_standButton removeFromSuperview];
    [_doubleDownButton removeFromSuperview];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _isAudioMuted = NO;
            
        _firstChip = [[CustomButton alloc] init];
        _secondChip = [[CustomButton alloc] init];
        _thirdChip = [[CustomButton alloc] init];
        _fourthChip = [[CustomButton alloc] init];
        _theFifthChip = [[CustomButton alloc] init];
        _sixthChip = [[CustomButton alloc] init];

        // Set AudioSession
        _audioSession = [AVAudioSession sharedInstance];
        NSError *sessionError = nil;
        [_audioSession setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
        [_audioSession setActive:_isAudioMuted error:&sessionError];

        _money = 900;
        _isBetView = YES;
        _aiCardImage0 = nil;
        _aiCardImage1 = nil;
        _aiCardImage2 = nil;
        _aiCardImage3 = nil;
        _aiCardImage4 = nil;
        _playerCardImage0 = nil;
        _playerCardImage1 = nil;
        _playerCardImage2 = nil;
        _playerCardImage3 = nil;
        _playerCardImage4 = nil;;
    }
    return self;
}

@end

//        UIAlertController *alert = [UIAlertController alertControllerWithTitle:losingMessage message:@"The dealer draws 5 cards without getting over 21" preferredStyle:UIAlertControllerStyleAlert];
//
//        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                                //button click event
//            _isGameOver = YES;
//            [self setNeedsDisplay];
//            if (self.money > 0){
//                [self newRound];
//            }
//            else {
//                [self startOver];
//                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"You're out of money!" message:@"The game now restarts." preferredStyle:UIAlertControllerStyleAlert];
//
//                UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                    /// ???
//                }];
//                [alert addAction:ok];
//
//
//                UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//                // Present the alert controller
//                [topVC presentViewController:alert animated:YES completion:nil];
//            }
             
//        }];
//        [alert addAction:ok];
//
//
//        UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//        // Present the alert controller
//        [topVC presentViewController:alert animated:YES completion:nil];
