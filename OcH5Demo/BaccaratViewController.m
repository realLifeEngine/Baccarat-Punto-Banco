//
//  BaccaratViewController.m
//  3PattiGalaxy-mobile
//
//  Reconfigured by Mewlan Musajan on 3/23/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "IWICasinoSettingsViewController.h"
#import "BaccaratViewController.h"
#import "GameSelectionViewController.h"
#import "CoreTextArcView.h"
#import "BaccaratTabelTriangleView.h"

#import "BaccaratCard.h"
#import "BaccaratCardDeck.h"
#import "BaccaratDealer.h"
#import "NSMutableArray+Shuffle.h"
#import <AVFoundation/AVFoundation.h>

#import "IWICasinoSettingsViewController.h"
#import "NSMutableArray+Shuffle.h"

#import <CoreText/CoreText.h>

#define LUCKY_NUMBER 6



typedef enum {
    kTie,
    kBanker,
    kPlayer
} BetPlacementCase;

typedef enum {
    k5,
    k25,
    k100,
    kAllIn
} ChipCase;

@interface BaccaratViewController ()
@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) UIViewController *iWICasinoTableViewController;

@property (nonatomic) int initFlag;

@property (assign, nonatomic) BOOL isGameOver;

@property (strong, nonatomic) UIViewController *homeViewController;

@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UILabel *headlineLabel;

@property (strong, nonatomic) CoreTextArcView *tieLabel;
@property (strong, nonatomic) CoreTextArcView *bankerLabel;
@property (strong, nonatomic) CoreTextArcView *playerLabel;
@property (strong, nonatomic) CoreTextArcView *arch1;
@property (strong, nonatomic) CoreTextArcView *arch2;

@property (strong, nonatomic) UIButton *tieLabelButton;
@property (strong, nonatomic) UIButton *bankerLabelButton;
@property (strong, nonatomic) UIButton *playerLabelButton;

@property (assign, nonatomic) BOOL isAudioMuted;
@property (assign, nonatomic) BOOL isBetView;
@property (assign, nonatomic) BOOL allIn;

@property (assign, nonatomic) BOOL shouldBlink;
@property (assign, nonatomic) int loopCount;
@property (strong, nonatomic) NSTimer *blinkTimer;

@property (strong, nonatomic) UIButton *settingsButton;
@property (strong, nonatomic) UIButton *speakerButton;
@property (strong, nonatomic) UIButton *questionButton;
@property (strong, nonatomic) UIButton *dollarsignButton;
@property (strong, nonatomic) UIButton *homeButton;
@property (strong, nonatomic) UIButton *resetButton;
@property (strong, nonatomic) UIButton *dealButton;

@property (strong, nonatomic) UILabel *dealLabel;

@property (strong, nonatomic) UIButton *casinoChip5Button;
@property (strong, nonatomic) UIButton *casinoChip25Button;
@property (strong, nonatomic) UIButton *casinoChip100Button;
@property (strong, nonatomic) UIButton *casinoChipAllInButton;

@property (assign, nonatomic) NSInteger casinoChip5Counter;
@property (assign, nonatomic) NSInteger casinoChip25Counter;
@property (assign, nonatomic) NSInteger casinoChip100Counter;

@property (assign, nonatomic) NSInteger initMoney;
@property (assign, nonatomic) NSInteger money;
@property (assign, nonatomic) NSInteger currentRoundBetAmount;
@property (strong, nonatomic) NSString *moneyString;

@property (strong, nonatomic) UILabel *currentRoundBetAmountLabel;
@property (strong, nonatomic) UILabel *moneyLabel;

/// Enter Baccarat View
@property (strong, nonatomic) UIImageView *bankerCard0;
@property (strong, nonatomic) UIImageView *bankerCard1;
@property (strong, nonatomic) UIImageView *bankerCard2;
@property (strong, nonatomic) UIImage *bankerCardImage0;
@property (strong, nonatomic) UIImage *bankerCardImage1;
@property (strong, nonatomic) UIImage *bankerCardImage2;

@property (strong, nonatomic) UIImageView *playerCard0;
@property (strong, nonatomic) UIImageView *playerCard1;
@property (strong, nonatomic) UIImageView *playerCard2;
@property (strong, nonatomic) UIImage *playerCardImage0;
@property (strong, nonatomic) UIImage *playerCardImage1;
@property (strong, nonatomic) UIImage *playerCardImage2;

@property (strong, nonatomic) UILabel *bankerPointsLabel;
@property (strong, nonatomic) UILabel *playerPointsLabel;

@property (strong, nonatomic) UILabel *playerDealLabel;
@property (strong, nonatomic) UILabel *bankerDealLabel;

/// Baccarat Game Model
@property (strong, nonatomic) BaccaratCardDeck *deck;
@property (strong, nonatomic) BaccaratDealer *dealer;

@end

@implementation BaccaratViewController {
    BetPlacementCase betPlacementCase;
    ChipCase chipCase;
    NSInteger bankerPoints;
    NSInteger playerPoints;
    AVAudioPlayer *dealCardSound;
}

-(void)playDealCardSound
{
    if (self->_isAudioMuted) {
        
    } else {
        dispatch_async(dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
            //Background Thread
            [self->dealCardSound play];

            dispatch_async(dispatch_get_main_queue(), ^(void){
                //Run UI Updates
                [self.view setNeedsDisplay];
            });
        });

    }
}

- (void)newGame {
    if (_isBetView) {
        if (_currentRoundBetAmount == 0) {
            [self complainMakeABet];
        } else {
            [self enterBaccarat];
        }
    } else {
        /// TODO: get back here after 7
        [self newRound];
        [self viewDidLoad];
    }
}

- (void)newRound{
    _currentRoundBetAmount = 0;
    _playerPointsLabel.text = 0;
    _bankerPointsLabel.text = 0;
    
    _playerCard0 = nil;
    _playerCard1 = nil;
    _playerCard2 = nil;
    _playerCardImage0 = nil;
    _playerCardImage1 = nil;
    _playerCardImage2 = nil;
    _bankerCard0 = nil;
    _bankerCard1 = nil;
    _bankerCard2 = nil;
    _bankerCardImage0 = nil;
    _bankerCardImage1 = nil;
    _bankerCardImage2 = nil;

    
    [_dealer freshDeck];
    _isBetView = YES;
    _isGameOver = NO;
//    _sixthChip = [[CustomButton alloc] init];
    
    [self.view setNeedsDisplay];
}

- (NSString *)formatNumberForCurrencyToString:(NSInteger *)money {
    /// known bug: incorrect format after overdraft
    NSNumber *someNumber = [NSNumber numberWithInteger:*money];

    NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
    [nf setNumberStyle:NSNumberFormatterCurrencyAccountingStyle];
    NSString *returnString = [nf stringFromNumber:someNumber];
    returnString = [returnString substringWithRange:NSMakeRange(0, returnString.length - 3)];
    return [returnString substringFromIndex:1];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURL* musicFile = [NSURL fileURLWithPath:[[NSBundle mainBundle]
                                               pathForResource:@"TurnCard"
                                               ofType:@"caf"]];
    self->dealCardSound = [[AVAudioPlayer alloc] initWithContentsOfURL:musicFile error:nil];
    self->dealCardSound.volume = 1.0f;

    _audioSession = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;
    [_audioSession setCategory:AVAudioSessionCategoryAmbient error:&sessionError];
    [_audioSession setActive:_isAudioMuted error:&sessionError];

    _deck = [[BaccaratCardDeck alloc] init];

    // Do any additional setup after loading the view.
    if (_initFlag != -1) {
        _isBetView = YES;
        _initFlag = -1;
        if (_money == 0) {
            _money += 10000;
        }
    }
    _isGameOver = YES;

    _moneyString = [self formatNumberForCurrencyToString:&(_money)];
    
    _initMoney = _money;
    _allIn = NO;
    betPlacementCase = -1;
    chipCase = -1;
    _shouldBlink = NO;
    _casinoChip5Counter = 0;
    _casinoChip25Counter = 0;
    _casinoChip100Counter = 0;
    
    
    // Drawing code
    CGRect bounds = self.view.bounds;
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"green_felt"];
    
    for (int i = 0; i < LUCKY_NUMBER; i++) {
        for (int j = 0; j < LUCKY_NUMBER; j++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i * bounds.size.width / LUCKY_NUMBER, 0 + j * bounds.size.height / LUCKY_NUMBER, backgroundImage.size.width, backgroundImage.size.height)];
            [self.view addSubview:imageView];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:backgroundImage];
            
        }
    }
    
    _themeColor = [UIColor colorWithRed:0.64 green:0.62 blue:0.43 alpha:1.0];
    
    _headlineLabel = [[UILabel alloc] init];
    [_headlineLabel setText:@"BACCARAT PUNTO BANCO"];
    _headlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_headlineLabel setFont:[UIFont fontWithName:@"Charter Bold" size:32]];
    [_headlineLabel setTextColor:_themeColor];
    [self.view addSubview:_headlineLabel];
    
//    UILabel *headlineSubLabel = [[UILabel alloc] init];
//    [headlineSubLabel setText:@"TIE PAYS 9 TO 1"];
//    headlineSubLabel.translatesAutoresizingMaskIntoConstraints = NO;
//    [headlineSubLabel setFont:[UIFont fontWithName:@"Charter" size:17]];
//    [headlineSubLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0]];
//    [self.view addSubview:headlineSubLabel];
    _tieLabel = [[CoreTextArcView alloc]
                                     initWithFrame:CGRectMake(bounds.size.width / 6, -195, bounds.size.width / 1.5, bounds.size.height)
                                     font:[UIFont fontWithName:@"Charter" size:24]
                                     text:@"TIE"
                                     radius:-((bounds.size.width / 1.5) / 2)
                                     arcSize: -11
                                   color: _themeColor];
    [_tieLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_tieLabel];
    
    
    CoreTextArcView *numberLabel = [[CoreTextArcView alloc]
                                    initWithFrame:CGRectMake(bounds.size.width / 6, - 195 + 54, bounds.size.width / 1.5, bounds.size.height)
                                    font:[UIFont fontWithName:@"Charter" size:20]
                                    text:@"TIE PAYS 9 TO 1"
                                    radius:-((bounds.size.width / 1.5) / 2)
                                    arcSize: -30
                                  color: [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.88]];
    [numberLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:numberLabel];
    
    _bankerLabel = [[CoreTextArcView alloc]
                                     initWithFrame:CGRectMake(bounds.size.width / 6, - 195 + 54 * 2, bounds.size.width / 1.5, bounds.size.height)
                                     font:[UIFont fontWithName:@"Charter" size:24]
                                     text:@"BANKER"
                                     radius:-((bounds.size.width / 1.5) / 2)
                                     arcSize: -22
                                   color: _themeColor];
    [_bankerLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_bankerLabel];
    
    _playerLabel = [[CoreTextArcView alloc]
                                    initWithFrame:CGRectMake(bounds.size.width / 6, - 195 + 54 * 3, bounds.size.width / 1.5, bounds.size.height)
                                    font:[UIFont fontWithName:@"Charter" size:24]
                                    text:@"PLAYER"
                                    radius:-((bounds.size.width / 1.5) / 2)
                                    arcSize: -22
                                  color: _themeColor];
    [_playerLabel setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_playerLabel];
    



    
    
    /// TODO: get back here after you done whatever you thought you might need to do......
    /// !!!: I'm nothing without you
    
    

    CoreTextArcView *arch0 = [[CoreTextArcView alloc]
                              initWithFrame:CGRectMake(bounds.size.width / 6, -2, bounds.size.width / 1.5, bounds.size.height)
                              font:[UIFont systemFontOfSize:44 weight:UIFontWeightHeavy]
                              text:@"⎯⎯⎯⎯⎯⎯"
                              radius:-((bounds.size.width / 1.5) / 2)
                              arcSize: -55
                            color: _themeColor];
    [arch0 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:arch0];
    
    /// medium rosted
    _arch1 = [[CoreTextArcView alloc]
                                     initWithFrame:CGRectMake(bounds.size.width / 6, -57, bounds.size.width / 1.5, bounds.size.height)
                                     font:[UIFont systemFontOfSize:44 weight:UIFontWeightHeavy]
                                     text:@"⎯⎯⎯⎯⎯⎯"
                                     radius:-((bounds.size.width / 1.5) / 2)
                                     arcSize: -44
                                   color: _themeColor];
    [_arch1 setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_arch1];
    
    _arch2 = [[CoreTextArcView alloc]
                                     initWithFrame:CGRectMake(bounds.size.width / 6, -112, bounds.size.width / 1.5, bounds.size.height)
                                     font:[UIFont systemFontOfSize:44 weight:UIFontWeightHeavy]
                                     text:@"⎯⎯⎯⎯"
                                     radius:-((bounds.size.width / 1.5) / 2)
                                     arcSize: -33
                                   color: _themeColor];
    [_arch2 setBackgroundColor:[UIColor clearColor]];
    
    [self.view addSubview:_arch2];
    
    CoreTextArcView *arch3 = [[CoreTextArcView alloc]
                                     initWithFrame:CGRectMake(bounds.size.width / 6, -167, bounds.size.width / 1.5, bounds.size.height)
                                     font:[UIFont systemFontOfSize:44 weight:UIFontWeightHeavy]
                                     text:@"⎯⎯⎯⎯⎯"
                                     radius:-((bounds.size.width / 1.5) / 2)
                                     arcSize: -22
                                   color: _themeColor];
    [arch3 setBackgroundColor:[UIColor clearColor]];
    
    
    [self.view addSubview:arch3];
    
    CoreTextArcView *arch4 = [[CoreTextArcView alloc]
                              initWithFrame:CGRectMake(bounds.size.width / 6, -222, bounds.size.width / 1.5, bounds.size.height)
                              font:[UIFont systemFontOfSize:44 weight:UIFontWeightHeavy]
                              text:@"⎯⎯⎯⎯⎯⎯"
                              radius:-((bounds.size.width / 1.5) / 2)
                              arcSize: -11
                            color: _themeColor];
    [arch4 setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:arch4];
    
    BaccaratTabelTriangleView *tabelTriangle = [[BaccaratTabelTriangleView alloc] initWithFrame:bounds];
    [tabelTriangle setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:tabelTriangle];
    
    _settingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_settingsButton setBackgroundImage:[UIImage imageNamed:@"gear.a49f6d"] forState:UIControlStateNormal];
    _settingsButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_settingsButton];
    
    /// TODO: and here is speaker
    _speakerButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_speakerButton setBackgroundImage:[UIImage imageNamed:_isAudioMuted ? @"speaker.slash.a49f6d" : @"speaker.wave.2.a49f6d"] forState:UIControlStateNormal];
    _speakerButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_speakerButton addTarget:self action:@selector(speakerButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_speakerButton];
    
    _questionButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_questionButton setBackgroundImage:[UIImage imageNamed:@"questionmark.a49f6d"] forState:UIControlStateNormal];
    _questionButton.translatesAutoresizingMaskIntoConstraints = NO;
    _questionButton.hidden = YES;
    
    [_questionButton addTarget:self action:@selector(questionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_questionButton];
    
    _dollarsignButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dollarsignButton setBackgroundImage:[UIImage imageNamed:@"dollarsign.a49f6d"] forState:UIControlStateNormal];
    _dollarsignButton.translatesAutoresizingMaskIntoConstraints = NO;
//    _dollarsignButton.hidden = YES;
    
    [_dollarsignButton addTarget:self action:@selector(dollarsignButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dollarsignButton];
    
    /// TODO: PLACE THE CHIPS

    _casinoChip5Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_casinoChip5Button setBackgroundImage:[UIImage imageNamed:@"CasinoChip5"] forState:UIControlStateNormal];
    _casinoChip5Button.translatesAutoresizingMaskIntoConstraints = NO;
    [_casinoChip5Button addTarget:self action:@selector(casinoChip5ButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _casinoChip25Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_casinoChip25Button setBackgroundImage:[UIImage imageNamed:@"CasinoChip25"] forState:UIControlStateNormal];
    _casinoChip25Button.translatesAutoresizingMaskIntoConstraints = NO;
    [_casinoChip25Button addTarget:self action:@selector(casinoChip25ButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _casinoChip100Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_casinoChip100Button setBackgroundImage:[UIImage imageNamed:@"CasinoChip100"] forState:UIControlStateNormal];
    _casinoChip100Button.translatesAutoresizingMaskIntoConstraints = NO;
    [_casinoChip100Button addTarget:self action:@selector(casinoChip100ButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _casinoChipAllInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *casinoChipAllInButtonString = [[NSAttributedString alloc] initWithString:@"ALL IN" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [_casinoChipAllInButton setAttributedTitle:casinoChipAllInButtonString forState:UIControlStateNormal];
    _casinoChipAllInButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_casinoChipAllInButton addTarget:self action:@selector(casinoChipAllInButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    if (_isBetView) {
        [self.view addSubview:_casinoChip5Button];
        [self.view addSubview:_casinoChipAllInButton];
        [self.view addSubview:_casinoChip100Button];
        [self.view addSubview:_casinoChip25Button];
    }



    
    _homeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_homeButton setBackgroundImage:[UIImage imageNamed:@"house.a49f6d"] forState:UIControlStateNormal];
    _homeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_homeButton addTarget:self action:@selector(homeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_homeButton];
    
    /// !!!: Reset button setup
    _resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    
    NSAttributedString *resetButtonString = [[NSAttributedString alloc] initWithString:@"RESET" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17 weight:UIFontWeightBold], NSForegroundColorAttributeName: _themeColor}];

    [_resetButton setAttributedTitle:resetButtonString forState:UIControlStateNormal];
    _resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_resetButton addTarget:self action:@selector(resetButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_resetButton];
    
    _dealButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dealButton setBackgroundImage:[UIImage imageNamed:@"icons8-bet-62"] forState:UIControlStateNormal];
    [_dealButton addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
    _dealButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_dealButton];
    
    _dealLabel = [[UILabel alloc] init];
    [_dealLabel setText:@"Deal"];

    _dealLabel.translatesAutoresizingMaskIntoConstraints = NO;
    
    /// TODO: Deal Label
    [_dealLabel setFont:[UIFont systemFontOfSize:17 weight:UIFontWeightBold]];
    [_dealLabel setTextColor:_themeColor];
    [_dealLabel setTextAlignment:NSTextAlignmentRight];

    [self.view addSubview:_dealLabel];
    _dealLabel.hidden = NO;
    
    _currentRoundBetAmountLabel = [[UILabel alloc] init];
    _currentRoundBetAmountLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_currentRoundBetAmountLabel setFont:[UIFont fontWithName:@"Charter Black" size:24]];
    [_currentRoundBetAmountLabel setTextColor:[UIColor whiteColor]];
    [_currentRoundBetAmountLabel setTextAlignment:NSTextAlignmentCenter];
    
    [self.view addSubview:_currentRoundBetAmountLabel];
    
    _moneyLabel = [[UILabel alloc] init];
    _moneyLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_moneyLabel setFont:[UIFont fontWithName:@"Charter Black" size:44]];
    [_moneyLabel setTextColor:[UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.88]];
    [_moneyLabel setTextAlignment:NSTextAlignmentLeft];
    [_moneyLabel setText:_moneyString];
    
    [self.view addSubview:_moneyLabel];
    
    /// TODO: here now time
    _bankerCard0 = [[UIImageView alloc] initWithImage:_bankerCardImage0];
    _bankerCard0.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bankerCard0];
    _bankerCard1 = [[UIImageView alloc] initWithImage:_bankerCardImage1];
    _bankerCard1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bankerCard1];
    _bankerCard2 = [[UIImageView alloc] initWithImage:_bankerCardImage2];
    _bankerCard2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_bankerCard2];
    
    _playerCard0 = [[UIImageView alloc] initWithImage:_playerCardImage0];
    _playerCard0.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_playerCard0];
    _playerCard1 = [[UIImageView alloc] initWithImage:_playerCardImage1];
    _playerCard1.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_playerCard1];
    _playerCard2 = [[UIImageView alloc] initWithImage:_playerCardImage2];
    _playerCard2.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_playerCard2];

    _bankerPointsLabel = [[UILabel alloc] init];
    _bankerPointsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_bankerPointsLabel setFont:[UIFont fontWithName:@"Charter Bold" size:32]];
    [_bankerPointsLabel setTextColor:[UIColor blackColor]];
//    [_bankerPointsLabel setText:[NSString stringWithFormat:@""]];
    [_bankerPointsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_bankerPointsLabel];
    
    _bankerPointsLabel.hidden = YES;
    
    _playerPointsLabel = [[UILabel alloc] init];
    _playerPointsLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_playerPointsLabel setFont:[UIFont fontWithName:@"Charter Bold" size:32]];
    [_playerPointsLabel setTextColor:[UIColor whiteColor]];
//    [_playerPointsLabel setText:[NSString stringWithFormat:@"%ld Points", (long)playerPoints]];
    [_playerPointsLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_playerPointsLabel];
    
    _playerPointsLabel.hidden = YES;
    
    _playerDealLabel = [[UILabel alloc] init];
    _playerDealLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_playerDealLabel setFont:[UIFont fontWithName:@"Charter Black" size:32]];
    [_playerDealLabel setTextColor:[UIColor whiteColor]];
    [_playerDealLabel setText:[NSString stringWithFormat:@"PLAYER"]];
    [_playerDealLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_playerDealLabel];
    _playerDealLabel.hidden = YES;
    
    _bankerDealLabel = [[UILabel alloc] init];
    _bankerDealLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_bankerDealLabel setFont:[UIFont fontWithName:@"Charter Black" size:32]];
    [_bankerDealLabel setTextColor:[UIColor blackColor]];
    [_bankerDealLabel setText:[NSString stringWithFormat:@"BANKER"]];
    [_bankerDealLabel setTextAlignment:NSTextAlignmentCenter];
    [self.view addSubview:_bankerDealLabel];
    _bankerDealLabel.hidden = YES;

    
    // Get a reference to the safe area layout guide for the view
    UILayoutGuide *safeAreaLayoutGuide = self.view.safeAreaLayoutGuide;
    
    NSLog(@"device width: %f\ndevice height: %f", bounds.size.width, bounds.size.height);

    if (_isBetView) {
        [self.view addConstraints:@[
            // Casino Chip 5 Button
            [NSLayoutConstraint constraintWithItem:_casinoChip5Button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:_casinoChip5Button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTrailing multiplier:1 constant:-44],
            [NSLayoutConstraint constraintWithItem:_casinoChip5Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_casinoChip5Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            
            // Casino Chip 25 Button
            [NSLayoutConstraint constraintWithItem:_casinoChip25Button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:_casinoChip25Button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_casinoChip5Button attribute:NSLayoutAttributeTrailing multiplier:1 constant:-99],
            [NSLayoutConstraint constraintWithItem:_casinoChip25Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_casinoChip25Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            
            // Casino Chip 100 Button
            [NSLayoutConstraint constraintWithItem:_casinoChip100Button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:_casinoChip100Button attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_casinoChip25Button attribute:NSLayoutAttributeTrailing multiplier:1 constant:-99],
            [NSLayoutConstraint constraintWithItem:_casinoChip100Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_casinoChip100Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            
            // Casino Chip All In Button
            [NSLayoutConstraint constraintWithItem:_casinoChipAllInButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_casinoChip5Button attribute:NSLayoutAttributeBottom multiplier:1 constant:-88],
            [NSLayoutConstraint constraintWithItem:_casinoChipAllInButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
            [NSLayoutConstraint constraintWithItem:_casinoChipAllInButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            [NSLayoutConstraint constraintWithItem:_casinoChipAllInButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
            
            // Home Button
            [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_speakerButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
            [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem: safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:11],
            [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
            [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],

        ]];
    }
    
    [self.view addConstraints:@[
        
        // Banker Deal Label
        [NSLayoutConstraint constraintWithItem:_bankerDealLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:-(bounds.size.height / 2 / 2)], // -203
        [NSLayoutConstraint constraintWithItem:_bankerDealLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:bounds.size.width / 2 / 2],
        [NSLayoutConstraint constraintWithItem:_bankerDealLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_bankerDealLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:227],
        
        // Player Deal Label
        [NSLayoutConstraint constraintWithItem:_playerDealLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:-(bounds.size.height / 2 / 2)], // -203
        [NSLayoutConstraint constraintWithItem:_playerDealLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:-(bounds.size.width / 2 / 2)],
        [NSLayoutConstraint constraintWithItem:_playerDealLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_playerDealLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:227],
        
        // Player Points Label
        [NSLayoutConstraint constraintWithItem:_playerPointsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:bounds.size.height / 2 / 2],
        [NSLayoutConstraint constraintWithItem:_playerPointsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:-(bounds.size.width / 2 / 2)],
        [NSLayoutConstraint constraintWithItem:_playerPointsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_playerPointsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:227],
        
        // Banker Points Label
        [NSLayoutConstraint constraintWithItem:_bankerPointsLabel attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:bounds.size.height / 2 / 2],
        [NSLayoutConstraint constraintWithItem:_bankerPointsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:bounds.size.width / 2 / 2],
        [NSLayoutConstraint constraintWithItem:_bankerPointsLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_bankerPointsLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:227],
        
        // Banker Card 1
        [NSLayoutConstraint constraintWithItem:_bankerCard1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bankerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_bankerCard1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:(bounds.size.width / 2 / 2)],
        [NSLayoutConstraint constraintWithItem:_bankerCard1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_bankerCard1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        // Banker Card 2
        [NSLayoutConstraint constraintWithItem:_bankerCard2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bankerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_bankerCard2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_bankerCard1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:-80],
        [NSLayoutConstraint constraintWithItem:_bankerCard2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_bankerCard2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        // Banker Card 0
        [NSLayoutConstraint constraintWithItem:_bankerCard0 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_bankerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_bankerCard0 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_bankerCard1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:+80],
        [NSLayoutConstraint constraintWithItem:_bankerCard0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_bankerCard0 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // Player Card 1
        [NSLayoutConstraint constraintWithItem:_playerCard1 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_playerCard1 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:-(bounds.size.width / 2 / 2)],
        [NSLayoutConstraint constraintWithItem:_playerCard1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_playerCard1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // Player Card 2
        [NSLayoutConstraint constraintWithItem:_playerCard2 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_playerCard2 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_playerCard1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:80],
        [NSLayoutConstraint constraintWithItem:_playerCard2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_playerCard2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // Player Card 0
        [NSLayoutConstraint constraintWithItem:_playerCard0 attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_playerPointsLabel attribute:NSLayoutAttributeBottom multiplier:1 constant:-55],
        [NSLayoutConstraint constraintWithItem:_playerCard0 attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_playerCard1 attribute:NSLayoutAttributeTrailing multiplier:1 constant:-80],
        [NSLayoutConstraint constraintWithItem:_playerCard0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100],
        [NSLayoutConstraint constraintWithItem:_playerCard0 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:80],
        
        // Headline Label
        [NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:11],
        [NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2],
        
        // Settings Button
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:11],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        
        // Speaker Button
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_settingsButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:11],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Questionmark Button
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTrailing multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Dollarsign Button
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        
        // Money Label
        [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_dollarsignButton attribute:NSLayoutAttributeLeading multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_moneyLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width],
        
        // Reset Button
        [NSLayoutConstraint constraintWithItem:_resetButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_homeButton attribute:NSLayoutAttributeTop multiplier:1 constant:_isBetView ? 66 : -9999],
        [NSLayoutConstraint constraintWithItem:_resetButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_settingsButton attribute:NSLayoutAttributeLeading multiplier:1 constant:_isBetView ? -16 : -9999],
        [NSLayoutConstraint constraintWithItem:_resetButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_resetButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:66],

        // Deal Button
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTrailing multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        
        // Deal Label
        [NSLayoutConstraint constraintWithItem:_dealLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dealButton attribute:NSLayoutAttributeTop multiplier:1 constant:33],
        [NSLayoutConstraint constraintWithItem:_dealLabel attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_dealButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:-22],
        [NSLayoutConstraint constraintWithItem:_dealLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dealLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:117],
    ]];
    
    
    _tieLabelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_tieLabelButton setTitle:@"" forState:UIControlStateNormal];
//    _tieLabelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_tieLabelButton setFrame:CGRectMake(bounds.size.width / 6, -195, bounds.size.width / 1.5, bounds.size.height)];
    [_tieLabelButton addTarget:self action:@selector(tieLabelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_tieLabelButton];
    
    /// TODO: implement bet placement buttons
    _bankerLabelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_bankerLabelButton setTitle:@"" forState:UIControlStateNormal];
//    _bankerLabelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_bankerLabelButton setFrame:CGRectMake(bounds.size.width / 6, - 195 + 54 * 2, bounds.size.width / 1.5, bounds.size.height)];
    [_bankerLabelButton addTarget:self action:@selector(bankerLabelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_bankerLabelButton];
    
    _playerLabelButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_playerLabelButton setTitle:@"" forState:UIControlStateNormal];
//    _playerLabelButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_playerLabelButton setFrame:CGRectMake(bounds.size.width / 6, - 195 + 54 * 3, bounds.size.width / 1.5, bounds.size.height)];
    [_playerLabelButton addTarget:self action:@selector(playerLabelButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_playerLabelButton];

}

- (void)settingsButtonTapped {
    _iWICasinoTableViewController = [[IWICasinoSettingsViewController alloc]init];
    _iWICasinoTableViewController.extendedLayoutIncludesOpaqueBars = NO;
    _iWICasinoTableViewController.edgesForExtendedLayout = UIRectEdgeAll;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = _iWICasinoTableViewController;
    [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];
}


- (void)questionButtonTapped {
    
}

- (void)speakerButtonTapped {
    NSLog(@"Speaker tapped");
    
    /// TODO: Here
    if (_isAudioMuted) {
        _isAudioMuted = NO;
    } else {
        _isAudioMuted = YES;
    }
    [_speakerButton setBackgroundImage:[UIImage imageNamed:_isAudioMuted ? @"speaker.slash.a49f6d" : @"speaker.wave.2.a49f6d"] forState:UIControlStateNormal];
    [self.view setNeedsDisplay];
    
}

- (void)homeButtonTapped {
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
    _moneyLabel.text = [self formatNumberForCurrencyToString:&(_money)];
    [self.view setNeedsDisplay];
}

/// TODO: Chip buttons implementations

- (void)chipHandel {
    if (!_allIn && _currentRoundBetAmount != 0) {
        if (betPlacementCase != -1 && !_allIn) {
            [self placeTheChip];
        } else if (!_allIn) {
            [self setupForBlink];
        } else {
            switch (chipCase) {
                case k5:
                    [self shakeView:_casinoChip5Button];
                    break;
                case k25:
                    [self shakeView:_casinoChip25Button];
                    break;
                case k100:
                    [self shakeView:_casinoChip100Button];
                    break;
                case kAllIn:
                    [self shakeView:_casinoChipAllInButton];
                    break;
                default:
                    break;
            }
        }
    } else {
        if (_money > 0) {
            if (betPlacementCase != -1) {
                [self placeTheChip];
            } else {
                [self setupForBlink];
            }
        } else {
            [self setupForBlink];
            _allIn = YES;
        }
    }
}


- (void)casinoChip5ButtonTapped {
    chipCase = k5;
    [self chipHandel];
}

- (void)casinoChip25ButtonTapped {
    chipCase = k25;
    [self chipHandel];
}

- (void)casinoChip100ButtonTapped {
    chipCase = k100;
    [self chipHandel];
}

- (void)casinoChipAllInButtonTapped {
    _allIn = YES;
    chipCase = kAllIn;
    [self chipHandel];
}

- (void)setupForBlink {
    if (_blinkTimer != nil) {
        [_blinkTimer invalidate];
        _blinkTimer = nil;
    }
    
    _loopCount = 0;
    _shouldBlink = YES;
    
    _blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(blink) userInfo:nil repeats:YES];
}

- (void)resetButtonTapped {
    [self.view setFrame:self.view.bounds];
    [self viewDidLoad];
}

- (void)blink {
    _loopCount++;
    if (_loopCount > 7) {
        [_blinkTimer invalidate];
        _blinkTimer = nil;
    } else {
        NSLog(@"blink %d", _loopCount);
        if (_shouldBlink) {
            _shouldBlink = NO;
        } else {
            _shouldBlink = YES;
        }
        [_tieLabel setAlpha:_shouldBlink ? 0 : 1];
        [_bankerLabel setAlpha:_shouldBlink ? 0 : 1];
        [_playerLabel setAlpha:_shouldBlink ? 0 : 1];
    }
}

-(void)betHandel:(BetPlacementCase)betCase {
    if (_money > 0) {
        if (chipCase != -1) {
            if (betPlacementCase == -1) {
                betPlacementCase = betCase;
                switch (chipCase) {
                    case k5:
                        if (_money - 5 >= 0) {
                            [self moveDaChip];
                        } else {
                            switch (betCase) {
                                case kTie:
                                    [self shakeView:_tieLabel];
                                    break;
                                case kBanker:
                                    [self shakeView:_bankerLabel];
                                    break;
                                case kPlayer:
                                    [self shakeView:_playerLabel];
                                    break;
                                default:
                                    break;
                            }
                        }
                        break;
                    case k25:
                        if (_money - 25 >= 0) {
                            [self moveDaChip];
                        } else {
                            switch (betCase) {
                                case kTie:
                                    [self shakeView:_tieLabel];
                                    break;
                                case kBanker:
                                    [self shakeView:_bankerLabel];
                                    break;
                                case kPlayer:
                                    [self shakeView:_playerLabel];
                                    break;
                                default:
                                    break;
                            }
                        }
                        break;
                    case k100:
                        if (_money - 100 >= 0) {
                            [self moveDaChip];
                        } else {
                            switch (betCase) {
                                case kTie:
                                    [self shakeView:_tieLabel];
                                    break;
                                case kBanker:
                                    [self shakeView:_bankerLabel];
                                    break;
                                case kPlayer:
                                    [self shakeView:_playerLabel];
                                    break;
                                default:
                                    break;
                            }
                        }
                        break;
                    case kAllIn:
                        if (_money > 0) {
                            [self moveDaChip];
                        } else {
                            switch (betCase) {
                                case kTie:
                                    [self shakeView:_tieLabel];
                                    break;
                                case kBanker:
                                    [self shakeView:_bankerLabel];
                                    break;
                                case kPlayer:
                                    [self shakeView:_playerLabel];
                                    break;
                                default:
                                    break;
                            }
                        }
                        break;
                    default:
                        break;
                }
            } else if (betPlacementCase != betCase) {
                switch (betCase) {
                    case kTie:
                        [self shakeView:_tieLabel];
                        break;
                    case kBanker:
                        [self shakeView:_bankerLabel];
                        break;
                    case kPlayer:
                        [self shakeView:_playerLabel];
                        break;
                    default:
                        break;
                }
            } else {
                [self moveDaChip];
            }
        } else {
            switch (betCase) {
                case kTie:
                    [self shakeView:_tieLabel];
                    break;
                case kBanker:
                    [self shakeView:_bankerLabel];
                    break;
                case kPlayer:
                    [self shakeView:_playerLabel];
                    break;
                default:
                    break;
            }
        }
    } else {
        switch (betCase) {
            case kTie:
                [self shakeView:_tieLabel];
                break;
            case kBanker:
                [self shakeView:_bankerLabel];
                break;
            case kPlayer:
                [self shakeView:_playerLabel];
                break;
            default:
                break;
        }
    }
}

-(void)tieLabelButtonTapped {
    [self betHandel:kTie];
}

-(void)bankerLabelButtonTapped {
    [self betHandel:kBanker];
}

-(void)playerLabelButtonTapped {
    [self betHandel:kPlayer];
}

-(void)placeTheChip {
    switch (betPlacementCase) {
        case kTie:
            [self tieLabelButtonTapped];
            break;
        case kBanker:
            [self bankerLabelButtonTapped];
            break;
        case kPlayer:
            [self playerLabelButtonTapped];
            break;
        default:
            break;
    }
}

-(void)moveDaChip {
    static CGFloat tieOffset = 80.75;
    static CGFloat bankerOffset = 180.75;
    static CGFloat playerOffset = 230.75;
    if (chipCase == k5) {
        _money -= 5;
        _currentRoundBetAmount += 5;
        /// TODO: chips update
        NSLog(@"k5");
        UIButton *casinoChip5ButtonCopy = [UIButton buttonWithType:UIButtonTypeCustom];
        [casinoChip5ButtonCopy setBackgroundImage:[UIImage imageNamed:@"CasinoChip5"] forState:UIControlStateNormal];
        [casinoChip5ButtonCopy setFrame:_casinoChip5Button.frame];
        [casinoChip5ButtonCopy setUserInteractionEnabled:NO];
        [self.view addSubview:casinoChip5ButtonCopy];

        int maxValue = 21; // maximum value of the random number
        int randomNumber = arc4random() % (maxValue + 1);
        
        CGFloat originXOffset = _casinoChip5Counter * 9;

        [UIView animateWithDuration:0.3
            delay:0.1
            options: UIViewAnimationOptionCurveLinear
            animations:^ {
                /// TODO: Switch here with betPlacementCase
            switch (self->betPlacementCase) {
                    case kTie:
                        [casinoChip5ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip5ButtonCopy.frame.size.width / 2 + originXOffset, tieOffset + randomNumber, casinoChip5ButtonCopy.frame.size.width * 0.747, casinoChip5ButtonCopy.frame.size.height * 0.747)];
                        break;
                    case kBanker:
                        [casinoChip5ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip5ButtonCopy.frame.size.width / 2 + originXOffset, bankerOffset + randomNumber, casinoChip5ButtonCopy.frame.size.width * 0.747, casinoChip5ButtonCopy.frame.size.height * 0.747)];
                        break;
                    case kPlayer:
                        [casinoChip5ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip5ButtonCopy.frame.size.width / 2 + originXOffset, playerOffset + randomNumber, casinoChip5ButtonCopy.frame.size.width * 0.747, casinoChip5ButtonCopy.frame.size.height * 0.747)];
                        break;
                    default:
                        break;
                }
                
            }
            completion:^(BOOL finished) {
            self->_casinoChip5Counter += 1;
                NSLog(@"Completed");
            [self.view bringSubviewToFront:self->_playerLabelButton];
                [self.view bringSubviewToFront:self->_tieLabelButton];
                [self.view bringSubviewToFront:self->_bankerLabelButton];


        }];
    } else if (chipCase == k25) {
        _money -= 25;
        _currentRoundBetAmount += 25;
        NSLog(@"k25");
        UIButton *casinoChip25ButtonCopy = [UIButton buttonWithType:UIButtonTypeCustom];
        [casinoChip25ButtonCopy setBackgroundImage:[UIImage imageNamed:@"CasinoChip25"] forState:UIControlStateNormal];
        [casinoChip25ButtonCopy setFrame:_casinoChip25Button.frame];
        [casinoChip25ButtonCopy setUserInteractionEnabled:NO];
        [self.view addSubview:casinoChip25ButtonCopy];

        int maxValue25 = 21; // maximum value of the random number
        int randomNumber25 = arc4random() % (maxValue25 + 1);
        
        CGFloat origin25XOffset = _casinoChip25Counter * 9;

        [UIView animateWithDuration:0.3
            delay:0.1
            options: UIViewAnimationOptionCurveLinear
            animations:^ {
                /// TODO: Switch here with betPlacementCase
                switch (self->betPlacementCase) {
                    case kTie:
                        [casinoChip25ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip25ButtonCopy.frame.size.width / 2 + origin25XOffset, tieOffset + randomNumber25, casinoChip25ButtonCopy.frame.size.width * 0.747, casinoChip25ButtonCopy.frame.size.height * 0.747)];
                        break;
                    case kBanker:
                        [casinoChip25ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip25ButtonCopy.frame.size.width / 2 + origin25XOffset, bankerOffset + randomNumber25, casinoChip25ButtonCopy.frame.size.width * 0.747, casinoChip25ButtonCopy.frame.size.height * 0.747)];
                        break;
                    case kPlayer:
                        [casinoChip25ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip25ButtonCopy.frame.size.width / 2 + origin25XOffset, playerOffset + randomNumber25, casinoChip25ButtonCopy.frame.size.width * 0.747, casinoChip25ButtonCopy.frame.size.height * 0.747)];
                        break;
                    default:
                        break;
                }
            }
            completion:^(BOOL finished) {
            self->_casinoChip25Counter += 1;
                NSLog(@"Completed");
                [self.view bringSubviewToFront:self->_playerLabelButton];
                [self.view bringSubviewToFront:self->_tieLabelButton];
                [self.view bringSubviewToFront:self->_bankerLabelButton];


        }];
    } else if (chipCase == k100) {
        _money -= 100;
        _currentRoundBetAmount += 100;
        NSLog(@"k100");
        UIButton *casinoChip100ButtonCopy = [UIButton buttonWithType:UIButtonTypeCustom];
        [casinoChip100ButtonCopy setBackgroundImage:[UIImage imageNamed:@"CasinoChip100"] forState:UIControlStateNormal];
        /// !!!: crash 0
        [casinoChip100ButtonCopy setFrame:_casinoChip100Button.frame];
        [casinoChip100ButtonCopy setUserInteractionEnabled:NO];
        [self.view addSubview:casinoChip100ButtonCopy];

        int maxValue100 = 21; // maximum value of the random number
        int randomNumber100 = arc4random() % (maxValue100 + 1);
        
        CGFloat origin100XOffset = _casinoChip100Counter * 9;

        [UIView animateWithDuration:0.3
            delay:0.1
            options: UIViewAnimationOptionCurveLinear
            animations:^ {
                /// TODO: Switch here with betPlacementCase
                switch (self->betPlacementCase) {
                    case kTie:
                        [casinoChip100ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip100ButtonCopy.frame.size.width / 2 + origin100XOffset, tieOffset + randomNumber100, casinoChip100ButtonCopy.frame.size.width * 0.747, casinoChip100ButtonCopy.frame.size.height * 0.747)];
                        break;
                    case kBanker:
                        [casinoChip100ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip100ButtonCopy.frame.size.width / 2 + origin100XOffset, bankerOffset + randomNumber100, casinoChip100ButtonCopy.frame.size.width * 0.747, casinoChip100ButtonCopy.frame.size.height * 0.747)];
                        break;
                    case kPlayer:
                        [casinoChip100ButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChip100ButtonCopy.frame.size.width / 2 + origin100XOffset, playerOffset + randomNumber100, casinoChip100ButtonCopy.frame.size.width * 0.747, casinoChip100ButtonCopy.frame.size.height * 0.747)];
                        break;
                    default:
                        break;
                }
            }
            completion:^(BOOL finished) {
            self->_casinoChip100Counter += 1;
                NSLog(@"Completed");
                [self.view bringSubviewToFront:self->_playerLabelButton];
                [self.view bringSubviewToFront:self->_tieLabelButton];
                [self.view bringSubviewToFront:self->_bankerLabelButton];


        }];
    } else if (chipCase == kAllIn) {
        _currentRoundBetAmount += _money;
        _money = 0;
        NSLog(@"kAllIn");
        UIButton *casinoChipAllInButtonCopy = [UIButton buttonWithType:UIButtonTypeCustom];
        [casinoChipAllInButtonCopy setBackgroundImage:[UIImage imageNamed:@"CasinoChip25"] forState:UIControlStateNormal];
        [casinoChipAllInButtonCopy setFrame:_casinoChipAllInButton.frame];
        [casinoChipAllInButtonCopy setUserInteractionEnabled:NO];
        [self.view addSubview:casinoChipAllInButtonCopy];
        
        UIButton *casinoChipAllInButtonCopy5 = [UIButton buttonWithType:UIButtonTypeCustom];
        [casinoChipAllInButtonCopy5 setBackgroundImage:[UIImage imageNamed:@"CasinoChip5"] forState:UIControlStateNormal];
        [casinoChipAllInButtonCopy5 setFrame:_casinoChipAllInButton.frame];
        [casinoChipAllInButtonCopy5 setUserInteractionEnabled:NO];
        [self.view addSubview:casinoChipAllInButtonCopy5];
        
        UIButton *casinoChipAllInButtonCopy100 = [UIButton buttonWithType:UIButtonTypeCustom];
        [casinoChipAllInButtonCopy100 setBackgroundImage:[UIImage imageNamed:@"CasinoChip100"] forState:UIControlStateNormal];
        [casinoChipAllInButtonCopy100 setFrame:_casinoChipAllInButton.frame];
        [casinoChipAllInButtonCopy100 setUserInteractionEnabled:NO];
        [self.view addSubview:casinoChipAllInButtonCopy100];

        int maxValueAllIn = 21; // maximum value of the random number
        int randomNumberAllIn = arc4random() % (maxValueAllIn + 1);
        

        [UIView animateWithDuration:0.3
            delay:0.1
            options: UIViewAnimationOptionCurveLinear
            animations:^ {
                /// TODO: Switch here with betPlacementCase
                switch (betPlacementCase) {
                    case kTie:
                        [casinoChipAllInButtonCopy5 setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy5.frame.size.width / 2 + randomNumberAllIn, tieOffset - 24 + randomNumberAllIn, casinoChipAllInButtonCopy5.frame.size.width * 0.7, casinoChipAllInButtonCopy5.frame.size.height * 0.7)];
                        [casinoChipAllInButtonCopy100 setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy100.frame.size.width / 2 + randomNumberAllIn, tieOffset + 24 + randomNumberAllIn, casinoChipAllInButtonCopy100.frame.size.width * 0.7, casinoChipAllInButtonCopy100.frame.size.height * 0.7)];
                        [casinoChipAllInButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy.frame.size.width / 2 + 44, tieOffset + randomNumberAllIn, casinoChipAllInButtonCopy.frame.size.width * 0.7, casinoChipAllInButtonCopy.frame.size.height * 0.7)];
                        break;
                    case kBanker:
                        [casinoChipAllInButtonCopy5 setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy5.frame.size.width / 2 + randomNumberAllIn, bankerOffset - 24 + randomNumberAllIn, casinoChipAllInButtonCopy5.frame.size.width * 0.7, casinoChipAllInButtonCopy5.frame.size.height * 0.7)];
                        [casinoChipAllInButtonCopy100 setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy100.frame.size.width / 2 + randomNumberAllIn, bankerOffset + 24 + randomNumberAllIn, casinoChipAllInButtonCopy100.frame.size.width * 0.7, casinoChipAllInButtonCopy100.frame.size.height * 0.7)];
                        [casinoChipAllInButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy.frame.size.width / 2 + 44, bankerOffset + randomNumberAllIn, casinoChipAllInButtonCopy.frame.size.width * 0.7, casinoChipAllInButtonCopy.frame.size.height * 0.7)];
                        break;
                    case kPlayer:
                        [casinoChipAllInButtonCopy5 setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy5.frame.size.width / 2 + randomNumberAllIn, playerOffset - 24 + randomNumberAllIn, casinoChipAllInButtonCopy5.frame.size.width * 0.7, casinoChipAllInButtonCopy5.frame.size.height * 0.7)];
                        [casinoChipAllInButtonCopy100 setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy100.frame.size.width / 2 + randomNumberAllIn, playerOffset + 24 + randomNumberAllIn, casinoChipAllInButtonCopy100.frame.size.width * 0.7, casinoChipAllInButtonCopy100.frame.size.height * 0.7)];
                        [casinoChipAllInButtonCopy setFrame:CGRectMake(self.view.bounds.size.width / 2 - casinoChipAllInButtonCopy.frame.size.width / 2 + 44, playerOffset + randomNumberAllIn, casinoChipAllInButtonCopy.frame.size.width * 0.7, casinoChipAllInButtonCopy.frame.size.height * 0.7)];
                        break;

                    default:
                        break;
                }
            }
            completion:^(BOOL finished) {
                NSLog(@"Completed");
            [self.view bringSubviewToFront:self->_playerLabelButton];
                [self.view bringSubviewToFront:self->_tieLabelButton];
                [self.view bringSubviewToFront:self->_bankerLabelButton];


        }];
    }

    _moneyLabel.text = [self formatNumberForCurrencyToString:&(_money)];
}

-(void)shakeView:(__kindof UIView *)view {
    CABasicAnimation *animation =
                             [CABasicAnimation animationWithKeyPath:@"position"];
    [animation setDuration:0.05];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                   CGPointMake([view center].x - 20.0f, [view center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                   CGPointMake([view center].x + 20.0f, [view center].y)]];
    [[view layer] addAnimation:animation forKey:@"position"];
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

/// TODO: get back
- (void)enterBaccarat {
    _isGameOver = NO;
    [self gameSetup];
    if (!_isBetView) {
        [self removeChipsFromSuperview];
    }
    [self.view setNeedsDisplay];
}

- (void)removeChipsFromSuperview {
    [_casinoChip5Button removeFromSuperview];
    [_casinoChip25Button removeFromSuperview];
    [_casinoChip100Button removeFromSuperview];
    [_casinoChipAllInButton removeFromSuperview];
    [self.view setNeedsDisplay];
}

- (void)gameSetup {
    if (_isBetView) {
        [self removeChipsFromSuperview];
        _isBetView = NO;
        [self.view setNeedsDisplay];
        /// TODO: EAT AFTER THIS
        [_dealButton setBackgroundImage:[UIImage imageNamed:@"arrow.counterclockwise.a49f6d"] forState:UIControlStateNormal];
        [_dealButton addTarget:self action:@selector(newGame) forControlEvents:UIControlEventTouchUpInside];
        [_dealLabel setText:@"Start Over"];
        [_resetButton removeFromSuperview];
        _bankerPointsLabel.hidden = NO;
        _playerPointsLabel.hidden = NO;
//        [_bankerCard0 setImage:[UIImage imageNamed:@"8009b"]];
//        [_bankerCard1 setImage:[UIImage imageNamed:@"8009b"]];
//        [_bankerCard2 setImage:[UIImage imageNamed:@"8009b"]];
//        [_playerCard0 setImage:[UIImage imageNamed:@"8009b"]];
//        [_playerCard1 setImage:[UIImage imageNamed:@"8009b"]];
//        [_playerCard2 setImage:[UIImage imageNamed:@"8009b"]];
        
        [self.view bringSubviewToFront:_bankerCard0];
        [self.view bringSubviewToFront:_bankerCard1];
        [self.view bringSubviewToFront:_bankerCard2];
        
        [self.view bringSubviewToFront:_playerCard0];
        [self.view bringSubviewToFront:_playerCard1];
        [self.view bringSubviewToFront:_playerCard2];
        
        _bankerDealLabel.hidden = NO;
        _playerDealLabel.hidden = NO;
        
        _dealLabel.hidden = YES;
        /// TODO: You are cureently here
        [UIView animateWithDuration:0.3
                            delay:0.1
                            options: UIViewAnimationOptionCurveLinear
                            animations:^ {
                                _homeButton.translatesAutoresizingMaskIntoConstraints = YES;
                                [_homeButton setFrame:CGRectMake(_homeButton.frame.origin.x + 66, _homeButton.frame.origin.y - 132, 44, 44)];
                            }
                            completion:^(BOOL finished) {
                                NSLog(@"home button moved.");
//                                [self.view setNeedsDisplay];
                        }];
        

        /// HARD CORE
        /// TODO: Place Model here
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
//        dispatch_get_main_queue(), ^{
//            [_playerCard0 setImage:[UIImage imageNamed:@"13S"]];
//            [_playerPointsLabel setText:@"0 Points"];
//            [self.view setNeedsDisplay];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)),
//        dispatch_get_main_queue(), ^{
//            [_playerCard1 setImage:[UIImage imageNamed:@"9H"]];
//            [_playerPointsLabel setText:@"9 Points"];
//            [self.view setNeedsDisplay];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)),
//        dispatch_get_main_queue(), ^{
//            [_bankerCard0 setImage:[UIImage imageNamed:@"13S"]];
//            [_bankerPointsLabel setText:@"0 Points"];
//            [self.view setNeedsDisplay];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)),
//        dispatch_get_main_queue(), ^{
//            [_bankerCard1 setImage:[UIImage imageNamed:@"11C"]];
//            [_bankerPointsLabel setText:@"0 Points"];
//            [self.view setNeedsDisplay];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
//        dispatch_get_main_queue(), ^{
//            [_bankerCard2 setImage:[UIImage imageNamed:@"1C"]];
//            [_bankerPointsLabel setText:@"1 Points"];
//            [self setupForMoneyBlink];
//            [self.view setNeedsDisplay];
//        });
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.3 * NSEC_PER_SEC)),
//        dispatch_get_main_queue(), ^{
//            [_playerDealLabel setTextColor:[UIColor redColor]];
//            [_playerDealLabel setText:@"PLAYER WON"];
//            _money += 25;
//            _moneyLabel.text = [self formatNumberForCurrencyToString:&(_money)];
//            [self.view setNeedsDisplay];
//        });

        
        
        
        /// TODO: Real work and I don't know about it: then learn about it
        _dealer = [[BaccaratDealer alloc] init];
        
        _dealer.playerCards = [[NSMutableArray alloc] init];
        _dealer.bankerCards = [[NSMutableArray alloc] init];
        [_dealer freshDeck];
        [_dealer.deck shuffle]; // calculation complete ;/
        
        /// lazy alloc of dem images
        _playerCardImage0 = [[UIImage alloc] init];
        _playerCardImage1 = [[UIImage alloc] init];
        _playerCardImage2 = [[UIImage alloc] init];
        _bankerCardImage0 = [[UIImage alloc] init];
        _bankerCardImage1 = [[UIImage alloc] init];
        _bankerCardImage2 = [[UIImage alloc] init];
        

        BOOL bankerHasThirdCard = NO;
        BOOL playerHasThirdCard = NO;
        if (_dealer.bankerCards.count == 3) {
            bankerHasThirdCard = YES;
        }
        if (_dealer.playerCards.count == 3) {
            playerHasThirdCard = YES;
        }

        /// let's build from here
        /// Player Card 0
        [_dealer playerTurn];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            self->_playerCardImage0 = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self->_dealer.playerCards[0].tie, self->_dealer.playerCards[0].suit]];
            [self->_playerCard0 setImage:self->_playerCardImage0];
            [self playDealCardSound];
        });


        /// Banker Card 0
        [_dealer bankerTurn];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            self->_bankerCardImage0 = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self->_dealer.bankerCards[0].tie, self->_dealer.bankerCards[0].suit]];
            [self->_bankerCard0 setImage:self->_bankerCardImage0];
            [self playDealCardSound];
        });

        /// Player Card 1
        [_dealer playerTurn];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            self->_playerCardImage1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self->_dealer.playerCards[1].tie, self->_dealer.playerCards[1].suit]];
            [self->_playerCard1 setImage:self->_playerCardImage1];
            [self playDealCardSound];
        });

        
        /// Banker Card 1
        [_dealer bankerTurn];

        dispatch_after(dispatch_time( DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            self->_bankerCardImage1 = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self->_dealer.bankerCards[1].tie, self->_dealer.bankerCards[1].suit]];
            [self->_bankerCard1 setImage:self->_bankerCardImage1];
            [self playDealCardSound];
        });


        /// !!!: fix array out of bounds above 5 (DONE)

        [self->_dealer checkDraw];
        if (self->_dealer.bankerCards.count != 3 && self->_dealer.playerCardCount != 3) {
            /// !!!: this is where Punto Banco Points are announced by croupier according to tableau if _dealer.bankerCards.count != 3 and _dealer.playerCardCount != 3
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
                [self->_bankerPointsLabel setText:[NSString stringWithFormat:@"%ld", self->_dealer.bankerScore]];
                [self->_playerPointsLabel setText:[NSString stringWithFormat:@"%ld", self->_dealer.playerScore]];
            });
        }

        if (_dealer.playerCardCount == 3) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
                self->_playerCardImage2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self->_dealer.playerCards[2].tie, self->_dealer.playerCards[2].suit]];
                [self->_playerCard2 setImage:self->_playerCardImage2];
                [self playDealCardSound];
            });
        }
        
        if (_dealer.bankerCards.count == 3) {

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.8 * NSEC_PER_SEC)),
            dispatch_get_main_queue(), ^{
                self->_bankerCardImage2 = [UIImage imageNamed:[NSString stringWithFormat:@"%@%@", self->_dealer.bankerCards[2].tie, self->_dealer.bankerCards[2].suit]];
                [self->_bankerCard2 setImage:self->_bankerCardImage2];
                /// !!!: this is where Punto Banco Points are announced by croupier according to tableau if banker had third card
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self->_bankerPointsLabel setText:[NSString stringWithFormat:@"%ld", self->_dealer.bankerScore]];
                    [self->_playerPointsLabel setText:[NSString stringWithFormat:@"%ld", self->_dealer.playerScore]];
                });
                [self playDealCardSound];
            });
        }

        [_dealer compareTotal];
        
        /// NUTTERTOOLS LEAVEMEALONE URKQSRK
//        _dealer.baccaratPuntoBancoBetResultCase = kPuntoBanco;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.1 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            /// ???: debug and refreshble on my table
//            betPlacementCase = kTie;
//            _dealer.baccaratPuntoBancoBetResultCase = kPuntoBanco;
            if (self->_dealer.baccaratPuntoBancoBetResultCase == kPuntoBanco) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.8 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });





                [self->_playerDealLabel setText:@"TIE"];
                [self->_bankerDealLabel setText:@"TIE"];
                /// TODO: get back here after ... nevermind
                if (self->betPlacementCase == kTie) { /// we most go deeper ha dad?
                    self->_money += self->_currentRoundBetAmount * 10;
                    [self->_moneyLabel setText:[NSString stringWithFormat:@"%ld", self->_money]]; /// cure \:
                } else {
//                        _money -= _currentRoundBetAmount;
                    [self->_moneyLabel setText:[NSString stringWithFormat:@"%ld", self->_money]]; /// cure \:

                }
            } else if (self->_dealer.baccaratPuntoBancoBetResultCase == kBancoWin) {
                [self->_bankerDealLabel setText:@"BANKER WIN"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });

                if (self->betPlacementCase == kBanker) { /// we most go deeper ha dad?
                    self->_money += self->_currentRoundBetAmount * 2;
                    [self->_moneyLabel setText:[NSString stringWithFormat:@"%ld", self->_money]]; /// cure \:
                } else {
//                        _money -= _currentRoundBetAmount;
                    [self->_moneyLabel setText:[NSString stringWithFormat:@"%ld", self->_money]]; /// cure \:

                }
            } else if (self->_dealer.baccaratPuntoBancoBetResultCase == kPuntoWin) {
                [self->_playerDealLabel setText:@"PLAYER WIN"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)),
                dispatch_get_main_queue(), ^{
                    [self playDealCardSound];
                });

                if (self->betPlacementCase == kPlayer) { /// we most go deeper ha dad?
                    NSLog(@"%d", self->chipCase);
                    self->_money += self->_currentRoundBetAmount * 2;
                    [self->_moneyLabel setText:[NSString stringWithFormat:@"%ld", self->_money]]; /// cure \:
                } else {
//                        _money -= _currentRoundBetAmount;
                    [self->_moneyLabel setText:[NSString stringWithFormat:@"%ld", self->_money]]; /// cure \:

                }
                [self.view setNeedsDisplay];
            }

        });

    } else {
        [self viewDidLoad];
    }
}

- (void)setupForMoneyBlink {
    if (_blinkTimer != nil) {
        [_blinkTimer invalidate];
        _blinkTimer = nil;
    }
    
    _loopCount = 0;
    _shouldBlink = YES;
    
    _blinkTimer = [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(blinkMoneyLabel) userInfo:nil repeats:YES];
}

- (void)blinkMoneyLabel {
    _loopCount++;
    if (_loopCount > 7) {
        [_blinkTimer invalidate];
        _blinkTimer = nil;
    } else {
        NSLog(@"blink %d", _loopCount);
        if (_shouldBlink) {
            _shouldBlink = NO;
        } else {
            _shouldBlink = YES;
        }
        [_moneyLabel setTextColor:_shouldBlink ? [UIColor redColor] : [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.88]];
//        [_moneyLabel setAlpha:_shouldBlink ? 0 : 1];
    }
}

@end
