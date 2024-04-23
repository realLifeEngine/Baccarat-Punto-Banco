//
//  IWIBankCrapsViewController.m
//  3PattiGalaxy-mobile
//  Created by Mewlan Musajan on 4/4/2024
//

#import "IWICasinoSettingsViewController.h"
#import "IWIBankCrapsViewController.h"
#import "GameSelectionViewController.h"
#import "CoreTextArcView.h"
#import <AVFoundation/AVFoundation.h>
#define LUCKY_NUMBER 6
#define CatWomenColor UIColor

typedef enum {
    k7,
    k3and3,
    k4and4,
    k2and2,
    k5and5,
    k1and1,
    k6and6,
    k1and2,
    k5and6,
    kAnyCraps,
} BankCrapsBetCase;

@interface IWIBankCrapsViewController ()<AVAudioPlayerDelegate>
@property (strong, nonatomic) UIViewController *iWICasinoTableViewController;
@property (strong, nonatomic) UIViewController *homeViewController;
@property (strong, nonatomic) CoreTextArcView *blackjackLabel;
@property (strong, nonatomic) CoreTextArcView *blackjackSubLabel;

@property (assign, nonatomic) BOOL isAudioMuted;
@property (assign, nonatomic) BOOL isBetView;

@property (strong, nonatomic) UIButton *settingsButton;
@property (strong, nonatomic) UIButton *speakerButton;
@property (strong, nonatomic) UIButton *questionButton;
@property (strong, nonatomic) UIButton *dollarsignButton;
@property (strong, nonatomic) UIButton *homeButton;
@property (strong, nonatomic) UIButton *dealButton;

@property (assign, nonatomic) NSInteger freedomUnit;
@property (assign, nonatomic) NSInteger currentRoundBetAmount;

@property (strong, nonatomic) UIImageView *motherFuckingImageView0;
@property (strong, nonatomic) UIImageView *motherFuckingImageView1;
@property (strong, nonatomic) UIImageView *motherFuckingImageView2;

@property (strong, nonatomic) UIImageView *curtainImageView;

@property (strong, nonatomic) UIButton *casinoChip5Button;
@property (strong, nonatomic) UIButton *casinoChip25Button;
@property (strong, nonatomic) UIButton *casinoChip100Button;
@property (strong, nonatomic) UIButton *casinoChipAllInButton;

@property (strong, nonatomic) UIButton *motherFuckingButton;
@property (assign, nonatomic) BOOL motherFuckingFlag;

@property (strong, nonatomic) UIColor *themeColor;
@property (strong, nonatomic) UILabel *headlineLabel;

@property (strong, nonatomic) UILabel *motherFuckingLabel;
@property (strong, nonatomic) UILabel *resultLabel;
@property (strong, nonatomic) UILabel *freedomUnitLabel;
@property (strong, nonatomic) UILabel *homeTheAlbumTheAlbumHomeLabel;

@property (strong, nonatomic) CatWomenColor *aRealColorWannaBe;
@property (assign, nonatomic) int result;

@property (strong, nonatomic) UIPickerView *pickerView;


@end

@implementation IWIBankCrapsViewController {
    BankCrapsBetCase bankCrapsBetCase;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // Drawing code
    _freedomUnit += 500;
    _isBetView = YES;
    _motherFuckingFlag = NO;
    CGRect bounds = self.view.bounds;
    
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    UIImage *backgroundImage = [UIImage imageNamed:@"green_green_felt"];
    
    for (int i = 0; i < LUCKY_NUMBER; i++) {
        for (int j = 0; j < LUCKY_NUMBER; j++) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0 + i * bounds.size.width / LUCKY_NUMBER, 0 + j * bounds.size.height / LUCKY_NUMBER, backgroundImage.size.width, backgroundImage.size.height)];
            [self.view addSubview:imageView];
            [imageView setContentMode:UIViewContentModeScaleAspectFit];
            [imageView setImage:backgroundImage];
            
        }
    }

//    _motherFuckingButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    _motherFuckingButton.translatesAutoresizingMaskIntoConstraints = NO;
//    [_motherFuckingButton setBackgroundImage:[UIImage imageNamed:@"Craps"] forState:UIControlStateNormal];
//    [_motherFuckingButton addTarget:self action:@selector(motherFuckingButtonTapped) forControlEvents:UIControlStateNormal];
//    _motherFuckingButton.hidden = YES;
//    [self.view addSubview:_motherFuckingButton];


    _settingsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_settingsButton setBackgroundImage:[UIImage imageNamed:@"gear.a49f6d"] forState:UIControlStateNormal];
//    [_settingsButton setTitle:@"🛸" forState:UIControlStateNormal];
//    [_settingsButton setFont:[UIFont systemFontOfSize:44]];
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
    
    [_questionButton addTarget:self action:@selector(questionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_questionButton];
    
    _dollarsignButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dollarsignButton setBackgroundImage:[UIImage imageNamed:@"dollarsign.a49f6d"] forState:UIControlStateNormal];
    _dollarsignButton.translatesAutoresizingMaskIntoConstraints = NO;
    _dollarsignButton.hidden = YES;
    
    [_dollarsignButton addTarget:self action:@selector(dollarsignButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dollarsignButton];
    
    _homeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_homeButton setBackgroundImage:[UIImage imageNamed:@"house.a49f6d"] forState:UIControlStateNormal];
    _homeButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_homeButton addTarget:self action:@selector(homeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_homeButton];
    
    
    /// TODO: PLACE THE CHIPS

    _casinoChip5Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_casinoChip5Button setBackgroundImage:[UIImage imageNamed:@"CasinoChip5"] forState:UIControlStateNormal];
    _casinoChip5Button.translatesAutoresizingMaskIntoConstraints = NO;
    [_casinoChip5Button addTarget:self action:@selector(casinoChip5ButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _casinoChip25Button = [UIButton buttonWithType:UIButtonTypeCustom];
    [_casinoChip25Button setBackgroundImage:[UIImage imageNamed:@"CasinoChip25"] forState:UIControlStateNormal];
    _casinoChip25Button.translatesAutoresizingMaskIntoConstraints = NO;
    [_casinoChip25Button addTarget:self action:@selector(casinoChip25ButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    _casinoChipAllInButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSAttributedString *casinoChipAllInButtonString = [[NSAttributedString alloc] initWithString:@"ALL IN" attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:24 weight:UIFontWeightBold], NSForegroundColorAttributeName: [UIColor blackColor]}];
    [_casinoChipAllInButton setAttributedTitle:casinoChipAllInButtonString forState:UIControlStateNormal];
    _casinoChipAllInButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_casinoChipAllInButton addTarget:self action:@selector(casinoChipAllInButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_casinoChip5Button];
    [self.view addSubview:_casinoChipAllInButton];
    [self.view addSubview:_casinoChip25Button];

    _themeColor = [UIColor colorWithRed:0.64 green:0.62 blue:0.43 alpha:1.0];
    
    _headlineLabel = [[UILabel alloc] init];
    [_headlineLabel setText:@"Engine Casino Real™"];
    _headlineLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_headlineLabel setFont:[UIFont fontWithName:@"Charter" size:32]];
    [_headlineLabel setTextColor:_themeColor];
    [self.view addSubview:_headlineLabel];
    
    /// ghost here 'eski tamliqqa ket, ket ket. süh süh süh'
    _motherFuckingImageView0 = [[UIImageView alloc] init];
    _motherFuckingImageView0.translatesAutoresizingMaskIntoConstraints = NO;
    [_motherFuckingImageView0 setImage:[UIImage imageNamed:@"motherFuckingImage0"]];
    [self.view addSubview:_motherFuckingImageView0];
    
    _motherFuckingImageView1 = [[UIImageView alloc] init];
    _motherFuckingImageView1.translatesAutoresizingMaskIntoConstraints = NO;
    [_motherFuckingImageView1 setImage:[UIImage imageNamed:@"motherFuckingImage1"]];
    [self.view addSubview:_motherFuckingImageView1];

    _motherFuckingImageView2 = [[UIImageView alloc] init];
    _motherFuckingImageView2.translatesAutoresizingMaskIntoConstraints = NO;
    [_motherFuckingImageView2 setImage:[UIImage imageNamed:@"motherFuckingImage6"]];
    [self.view addSubview:_motherFuckingImageView2];

    _curtainImageView = [[UIImageView alloc] init];
    _curtainImageView.translatesAutoresizingMaskIntoConstraints = NO;
    [_curtainImageView setImage:[UIImage imageNamed:@"green_green_felt"]];
    [_curtainImageView setHidden:YES];
    [self.view addSubview:_curtainImageView];


    _dealButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_dealButton setBackgroundImage:[UIImage imageNamed:@"icons8-bet-62"] forState:UIControlStateNormal];
    [_dealButton addTarget:self action:@selector(dealButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    _dealButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_dealButton];

    _motherFuckingLabel = [[UILabel alloc] init];
    _motherFuckingLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_motherFuckingLabel setText:@"COME"];
    [_motherFuckingLabel setFont:[UIFont fontWithName:@"Charter Black" size:32]];
    _aRealColorWannaBe = [UIColor colorWithRed:1.0 green:40 / 255 blue:145 / 255 alpha:1.0];
    [_motherFuckingLabel setTextColor:_aRealColorWannaBe]; /// watching in the back been
    [self.view addSubview:_motherFuckingLabel];

    _resultLabel = [[UILabel alloc] init];
    _resultLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_resultLabel setText:@"PASS LINE"];
    [_resultLabel setFont:[UIFont fontWithName:@"Charter Black" size:24]];
    _aRealColorWannaBe = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [_resultLabel setTextColor:_aRealColorWannaBe]; /// watching in the back been
    [self.view addSubview:_resultLabel];

    _freedomUnitLabel = [[UILabel alloc] init];
    _freedomUnitLabel.translatesAutoresizingMaskIntoConstraints = NO;
    NSString *freedomUnitString = [[NSString alloc] initWithFormat:@"$%ld", _currentRoundBetAmount];
    [_freedomUnitLabel setText:freedomUnitString];
    [_freedomUnitLabel setFont:[UIFont fontWithName:@"Charter Black" size:24]];
    _aRealColorWannaBe = _themeColor;
    [_freedomUnitLabel setTextColor:_aRealColorWannaBe]; /// watching in the back been
    [self.view addSubview:_freedomUnitLabel];

    _homeTheAlbumTheAlbumHomeLabel = [[UILabel alloc] init];
    _homeTheAlbumTheAlbumHomeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [_homeTheAlbumTheAlbumHomeLabel setFont:[UIFont fontWithName:@"Charter Black" size:24]];
    [_homeTheAlbumTheAlbumHomeLabel setText:[NSString stringWithFormat:@"$%ld", _freedomUnit]];
    _aRealColorWannaBe = [UIColor whiteColor];
    [_homeTheAlbumTheAlbumHomeLabel setTextColor:_aRealColorWannaBe]; /// watching in the back been
    [self.view addSubview:_homeTheAlbumTheAlbumHomeLabel];

    // Create a picker view
    _pickerView = [[UIPickerView alloc] init];
    _pickerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    // Set the delegate and data source to the view controller
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    // Add the picker view to the view hierarchy
    [self.view addSubview:_pickerView];

    // Get a reference to the safe area layout guide for the view
    UILayoutGuide *safeAreaLayoutGuide = self.view.safeAreaLayoutGuide;

    NSLog(@"device width: %f\ndevice height: %f", bounds.size.width, bounds.size.height);

    
    [self.view addConstraints:@[
        // Curtain Image View
        [NSLayoutConstraint constraintWithItem:_curtainImageView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_curtainImageView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_curtainImageView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height],
        [NSLayoutConstraint constraintWithItem:_curtainImageView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width],

        // Deal Button
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTrailing multiplier:1 constant:-5],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50],
        [NSLayoutConstraint constraintWithItem:_dealButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50],

        // Mother Fucking Image View 0
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView0 attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView0 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView0 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView0 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50],

        // Mother Fucking Image View 1
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView1 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_motherFuckingImageView0 attribute:NSLayoutAttributeCenterX multiplier:1 constant:70],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView1 attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:1],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView1 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:51],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView1 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:51],

        // Mother Fucking Image View 2
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView2 attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_dealButton attribute:NSLayoutAttributeLeading multiplier:1 constant:-115],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView2 attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_dealButton attribute:NSLayoutAttributeTop multiplier:1 constant:33],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView2 attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:250],
        [NSLayoutConstraint constraintWithItem:_motherFuckingImageView2 attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:112.1052631579],

        // Mother Fucking Button
//        [NSLayoutConstraint constraintWithItem:_motherFuckingButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
//        [NSLayoutConstraint constraintWithItem:_motherFuckingButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
//        [NSLayoutConstraint constraintWithItem:_motherFuckingButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:550 / 1.5],
//        [NSLayoutConstraint constraintWithItem:_motherFuckingButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:850 / 1.5],

        // Casino Chip 5 Button
        [NSLayoutConstraint constraintWithItem:_casinoChip5Button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_casinoChip5Button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_casinoChip5Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50],
        [NSLayoutConstraint constraintWithItem:_casinoChip5Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:50],
        
        // Casino Chip 25 Button
        [NSLayoutConstraint constraintWithItem:_casinoChip25Button attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:_casinoChip5Button attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_casinoChip25Button attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_casinoChip5Button attribute:NSLayoutAttributeLeading multiplier:1 constant:60.6666666671],
        [NSLayoutConstraint constraintWithItem:_casinoChip25Button attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:51],
        [NSLayoutConstraint constraintWithItem:_casinoChip25Button attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:51],

        // Casino Chip All In Button
        [NSLayoutConstraint constraintWithItem:_casinoChipAllInButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_casinoChipAllInButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_casinoChip25Button attribute:NSLayoutAttributeLeading multiplier:1 constant:60.6666666671],
        [NSLayoutConstraint constraintWithItem:_casinoChipAllInButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:51],
        [NSLayoutConstraint constraintWithItem:_casinoChipAllInButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:77],
        
        // Settings Button
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:11],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44], /// commit
        // Speaker Button
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_settingsButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:11],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Questionmark Button
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_dealButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:0], /// cure
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Dollarsign Button
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Home Button
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_speakerButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_settingsButton attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],

        // Headline Label
        [NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_headlineLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2], // :)
        
        // Mother Fucking Label
        [NSLayoutConstraint constraintWithItem:_motherFuckingLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_headlineLabel attribute:NSLayoutAttributeTop multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_motherFuckingLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_motherFuckingLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_motherFuckingLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2],
        
        // Home The Album The Album Home
        [NSLayoutConstraint constraintWithItem:_homeTheAlbumTheAlbumHomeLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_motherFuckingLabel attribute:NSLayoutAttributeTop multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_homeTheAlbumTheAlbumHomeLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_homeTheAlbumTheAlbumHomeLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_homeTheAlbumTheAlbumHomeLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2],

        // Result Lable
        [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_motherFuckingImageView0 attribute:NSLayoutAttributeTop multiplier:1 constant:55],
        [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_resultLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2],

        // Freedom Unit Label
        [NSLayoutConstraint constraintWithItem:_freedomUnitLabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_resultLabel attribute:NSLayoutAttributeTop multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_freedomUnitLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_freedomUnitLabel attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_freedomUnitLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2],


        // Picker View
        [NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_motherFuckingImageView1 attribute:NSLayoutAttributeTop multiplier:1 constant:45],
        [NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_motherFuckingImageView1 attribute:NSLayoutAttributeLeading multiplier:1 constant:-200],
        [NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height / 1.572],
        [NSLayoutConstraint constraintWithItem:_pickerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2],
    ]];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
inComponent:(NSInteger)component {
    // Handle selection of row
    bankCrapsBetCase = (BankCrapsBetCase)row;
    NSLog(@"%d", bankCrapsBetCase);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 10;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString * title = nil;
    /// A come-out roll of 2, 3, or 12 is called "craps" or "crapping out"
//    kSeven,
//    k3and3,
//    k4and4,
//    k2and2,
//    k5and5,
//    k1and1,
//    k6and6,
//    k1and2,
//    k5and6,
//    kAnyCraps,
    switch(row) {
            case 0:
                title = @"Seven 4 to 1";
                break;
            case 1:
                title = @"Three & Three 10 to 1";
                break;
            case 2:
                title = @"Four & Four 10 to 1";
                break;
            case 3:
                title = @"Two & Two 8 to 1";
                break;
            case 4:
                title = @"Five & Five 8 to 1";
                break;
            case 5:
                title = @"One & One 30 to 1";
                break;
            case 6:
                title = @"Six & Six 30 to 1";
                break;
            case 7:
                title = @"One & Two 15 to 1";
                break;
            case 8:
                title = @"Five & Six 15 to 1";
                break;
            case 9:
                title = @"Any Craps 7 to 1";
                break;
    }
    return title;
}

/// pre-paid or post-paid
- (void)dealButtonTapped {
/**
 int escape = 0; /// batman took this escape, get it done before his come back, hurry up and help me plese
 NSString *resultString = [NSString stringWithFormat:@"%d x2", randomNumber0 + 1];
 self->_freedomUnit += 2 * self->_currentRoundBetAmount;

 **/
    
    _freedomUnit -= _currentRoundBetAmount;
    [_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", _freedomUnit]];
    [self.view setNeedsDisplay];

    for (int i = 0; i < 14; i++) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.11 * i * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            int randomNumber0 = arc4random() % 6;
            int randomNumber1 = arc4random() % 6;
            NSString *motherFukcingString0 = [[NSString alloc] initWithFormat:@"motherFuckingImage%d", randomNumber0];
            [self->_motherFuckingImageView0 setImage:[UIImage imageNamed:motherFukcingString0]];
            NSString *motherFukcingString1 = [[NSString alloc] initWithFormat:@"motherFuckingImage%d", randomNumber1];
            [self->_motherFuckingImageView1 setImage:[UIImage imageNamed:motherFukcingString1]];
            
            //            k7,
            //            k3and3,
            //            k4and4,
            //            k2and2,
            //            k5and5,
            //            k1and1,
            //            k6and6,
            //            k1and2,
            //            k5and6,
            //            kAnyCraps,
            if (i == 13) {
                /// TODO: fix this and report key lost
                /// compare to the bet case
                self->_result = randomNumber0 + randomNumber1 + 2; /// pico math
                int breakFlag = -1;
                if (self->_result == 7 && self->bankCrapsBetCase == k7) {
                    self->_freedomUnit += 5 * self->_currentRoundBetAmount;
                    [self->_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", (long)self->_freedomUnit]];
                    breakFlag = 1;
                } else if (((randomNumber0 == 2 && randomNumber1 == 2) || (randomNumber0 == 3 && randomNumber1 == 3)) && (self->bankCrapsBetCase == k3and3 || self->bankCrapsBetCase == k4and4)) {
                    self->_freedomUnit += 11 * self->_currentRoundBetAmount;
                    [self->_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", (long)self->_freedomUnit]];
                    breakFlag = 1;
                } else if (((randomNumber0 == 1 && randomNumber1 == 1) || (randomNumber0 == 4 && randomNumber1 == 4)) && (self->bankCrapsBetCase == k2and2 || self->bankCrapsBetCase == k3and3)) {
                    self->_freedomUnit += 9 * self->_currentRoundBetAmount;
                    [self->_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", (long)self->_freedomUnit]];
                    breakFlag = 1;
                } else if (((randomNumber0 == 0 && randomNumber1 == 0) || (randomNumber0 == 5 && randomNumber1 == 5)) && (self->bankCrapsBetCase == k1and1 || self->bankCrapsBetCase == k4and4)) {
                    self->_freedomUnit += 31 * self->_currentRoundBetAmount;
                    [self->_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", (long)self->_freedomUnit]];
                    breakFlag = 1;
                } else if (((randomNumber0 == 0 && randomNumber1 == 1) || (randomNumber0 == 4 && randomNumber1 == 5)) && (self->bankCrapsBetCase == k1and2 || self->bankCrapsBetCase == k5and6)) {
                    self->_freedomUnit += 16 * self->_currentRoundBetAmount;
                    [self->_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", (long)self->_freedomUnit]];
                    breakFlag = 1;
                } else if ((self->_result == 2 || self->_result == 3 || self->_result == 12)) {
                    self->_freedomUnit += 8 * self->_currentRoundBetAmount;
                    [self->_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", (long)self->_freedomUnit]];

                }
                
                [self->_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", self->_freedomUnit]];
                [self->_homeTheAlbumTheAlbumHomeLabel setText:[NSString stringWithFormat:@"$%ld", self->_currentRoundBetAmount]];
            }

            [self.view setNeedsDisplay];
        });
    }
}
/// depricated
//- (void)bonusFreedomDetermination:(int)result {
//    if (result == 12) {
//        _freedomUnit += 31 * _currentRoundBetAmount;
//        [_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", (long)_freedomUnit]];
//    }
//}

- (void)casinoChipAllInButtonTapped {
    if (_freedomUnit == 0) {
        [self complain];
    } else {
        _currentRoundBetAmount += _freedomUnit;
//        _freedomUnit = 0;
        [_homeTheAlbumTheAlbumHomeLabel setText:[NSString stringWithFormat:@"$%ld", _currentRoundBetAmount]];
        [_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", _freedomUnit]];
        [self.view setNeedsDisplay];
    }
    /// we all know less is more moris less more?
}

- (void)casinoChip5ButtonTapped {
    if (_freedomUnit - 5 >= 0) {
//        _freedomUnit -= 5;
        _currentRoundBetAmount += 5;
        [_homeTheAlbumTheAlbumHomeLabel setText:[NSString stringWithFormat:@"$%ld", _currentRoundBetAmount]];
        [_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", _freedomUnit]];
        [self.view setNeedsDisplay];
    } else {
        [self complain];
    }
}

- (void)casinoChip25ButtonTapped {
    if (_freedomUnit - 25 >= 0) {
//        _freedomUnit -= 25;
        _currentRoundBetAmount += 25;
        [_homeTheAlbumTheAlbumHomeLabel setText:[NSString stringWithFormat:@"$%ld", _currentRoundBetAmount]];
        [_freedomUnitLabel setText:[NSString stringWithFormat:@"$%ld", _freedomUnit]];
        [self.view setNeedsDisplay];
    } else {
        [self complain];
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


- (void)motherFuckingButtonTapped {
    [self questionButtonTapped]; /// we must go deeper ha dad?
}

- (void)questionButtonTapped {
    /// sudo: maybe a wiki page or maybe definitly never know
    /// TODO: here
    NSLog(@"%d", _motherFuckingFlag);
    if (_motherFuckingFlag == NO) {
        _motherFuckingFlag = YES;
        _motherFuckingButton = [UIButton buttonWithType:UIButtonTypeSystem];
        CGRect bounds = self.view.bounds;
        [_motherFuckingButton setFrame:CGRectMake(119, 11, 850 / 1.5, 550 / 1.5)]; /// spooky mathmatics needed
        [_motherFuckingButton setBackgroundImage:[UIImage imageNamed:@"Craps"] forState:UIControlStateNormal];
        [_motherFuckingButton addTarget:self action:@selector(motherFuckingButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_motherFuckingButton];
    } else {
        _motherFuckingFlag = NO;
        [_motherFuckingButton removeFromSuperview];
    }
    [self.view setNeedsDisplay];
}

- (void)complain {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Insufficient Balance" message:@"Select a Lower Bet" preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        }];
    [alert addAction:ok];

    [self presentViewController:alert animated:YES completion:nil];
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

- (void)dollarsignButtonTapped {
    NSLog(@"Dollarsign tapped");
    _freedomUnit += 50;
    [self viewDidLoad];
}

- (void)homeButtonTapped {
    _homeViewController = [[GameSelectionViewController alloc]init];
    _homeViewController.extendedLayoutIncludesOpaqueBars = NO;
    _homeViewController.edgesForExtendedLayout = UIRectEdgeAll;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = _homeViewController;
    [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionFlipFromTop animations:nil completion:nil];
}

@end
