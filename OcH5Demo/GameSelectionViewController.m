//
//  GameSelectionViewController.m
//  3PattiGalaxy-mobile
//  Created by Mewlan Musajan on 3/22/24.
//

#import "IWICasinoSettingsViewController.h"
#import "GameSelectionViewController.h"
#import "SideAViewController.h"
#import "BaccaratViewController.h"
#import "IWIBankCrapsViewController.h"
#define LUCKY_NUMBER 6

@interface GameSelectionViewController ()

@property (strong, nonatomic) UIViewController *blackJackViewController;
@property (strong, nonatomic) UIViewController *baccaratViewController;
@property (strong, nonatomic) UIViewController *bankCrapsViewController;
@property (strong, nonatomic) UIViewController *iWICasinoTableViewController;

@property (assign, nonatomic) BOOL isAudioMuted;

@property (strong, nonatomic) UIButton *settingsButton;
@property (strong, nonatomic) UIButton *speakerButton;
@property (strong, nonatomic) UIButton *questionButton;
@property (strong, nonatomic) UIButton *dollarsignButton;

@property (strong, nonatomic) UIButton *blackjackButton;
@property (strong, nonatomic) UIButton *baccaratButton;
@property (strong, nonatomic) UIButton *bankCrapsButton;

@property (assign, nonatomic) NSInteger money;
@property (assign, nonatomic) NSInteger currentRoundBetAmount;

@property (assign, nonatomic) BOOL isIPadOS;
@end

@implementation GameSelectionViewController

- (void)userAgreementOnce {
    BOOL hasLuanchedBefore = [[NSUserDefaults standardUserDefaults] boolForKey:@"zz"];
    if (!hasLuanchedBefore) {
        // App has not been launched before, do something special on first launch
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"zz"];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"SOFTWARE LICENSE AGREEMENT FOR Casino Real Classic" message:@"For use on WILLOOK-branded Applications\nPLEASE READ THIS SOFTWARE LICENSE AGREEMENT (“LICENSE”) CAREFULLY BEFORE USING THE WILLOOK SOFTWARE. BY USING THE Willook SOFTWARE, YOU ARE AGREEING TO BE BOUND BY THE TERMS OF THIS LICENSE. IF YOU DO NOT AGREE TO THE TERMS OF THIS LICENSE, DO NOT INSTALL AND/OR USE THE WILLOOK SOFTWARE AND, IF PRESENTED WITH THE OPTION TO “AGREE” OR “DISAGREE” TO THE TERMS, CLICK “DISAGREE.\nThe WI License (Willook)\nCopyright © 2024 Willook Foundation\nPermission is hereby granted, The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE." preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction *agree = [UIAlertAction actionWithTitle:@"AGREE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
        }];

        [alert addAction:agree];

        UIAlertAction *dissagree = [UIAlertAction actionWithTitle:@"DISAGREE" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            @throw NSInternalInconsistencyException;
        }];

        [alert addAction:dissagree];

//        UIViewController *topVC = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
//        // Present the alert controller
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSTimer *myTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
    selector:@selector(userAgreementOnce) userInfo:nil repeats:NO];

    _isIPadOS = NO;
    if([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone)
    {
        if ([[UIScreen mainScreen] bounds].size.height == 568)
        {


        }
        else
        {
            //iphone 3.5 inch screen
        }
    }
    else
    {
           //[ipad]
        _isIPadOS = YES;
    }

    // Do any additional setup after loading the view.
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
    
//    _questionButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_questionButton setBackgroundImage:[UIImage imageNamed:@"questionmark.a49f6d"] forState:UIControlStateNormal];
//    _questionButton.translatesAutoresizingMaskIntoConstraints = NO;
//    
//    [_questionButton addTarget:self action:@selector(questionButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_questionButton];
    
//    _dollarsignButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [_dollarsignButton setBackgroundImage:[UIImage imageNamed:@"dollarsign.a49f6d"] forState:UIControlStateNormal];
//    _dollarsignButton.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [_dollarsignButton addTarget:self action:@selector(dollarsignButtonTapped) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:_dollarsignButton];
    
    
    _blackjackButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_blackjackButton setBackgroundImage:[UIImage imageNamed:@"blackjack-1600x891-1"] forState:UIControlStateNormal];
    _blackjackButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_blackjackButton addTarget:self action:@selector(blackjackButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [_blackjackButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [_blackjackButton.layer setShadowOffset:CGSizeMake(0, 2)];
    [_blackjackButton.layer setShadowOpacity:0.5f];
    [_blackjackButton.layer setCornerRadius:12];

    [self.view addSubview:_blackjackButton];
    
    _baccaratButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_baccaratButton setBackgroundImage:[UIImage imageNamed:@"baccarat"] forState:UIControlStateNormal];
    _baccaratButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_baccaratButton addTarget:self action:@selector(baccaratButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [_baccaratButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [_baccaratButton.layer setShadowOffset:CGSizeMake(0, 2)];
    [_baccaratButton.layer setShadowOpacity:0.5f];
    [_baccaratButton.layer setCornerRadius:12];
    if (_isIPadOS) {
        _baccaratButton.hidden = YES;
    }

    [self.view addSubview:_baccaratButton];

    _bankCrapsButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_bankCrapsButton setBackgroundImage:[UIImage imageNamed:@"89432"] forState:UIControlStateNormal];
    _bankCrapsButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    [_bankCrapsButton addTarget:self action:@selector(bankCrapsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    
    [_bankCrapsButton.layer setShadowColor:[UIColor blackColor].CGColor];
    [_bankCrapsButton.layer setShadowOffset:CGSizeMake(0, 2)];
    [_bankCrapsButton.layer setShadowOpacity:0.5f];
    [_bankCrapsButton.layer setCornerRadius:12];
    
    [self.view addSubview:_bankCrapsButton];

    
    // Get a reference to the safe area layout guide for the view
    UILayoutGuide *safeAreaLayoutGuide = self.view.safeAreaLayoutGuide;
    
    NSLog(@"device width: %f\ndevice height: %f", bounds.size.width, bounds.size.height);


    
    [self.view addConstraints:@[
        
        // Blackjack Button
        [NSLayoutConstraint constraintWithItem:_blackjackButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:_isIPadOS ? 0 : 88],
        [NSLayoutConstraint constraintWithItem:_blackjackButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:_isIPadOS ? -222 : -136],
        [NSLayoutConstraint constraintWithItem:_blackjackButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_isIPadOS ? 250 : 162],
        [NSLayoutConstraint constraintWithItem:_blackjackButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_isIPadOS ? 448.933782275 : 290.9090909091],

        // Bank Craps Button
        [NSLayoutConstraint constraintWithItem:_bankCrapsButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_bankCrapsButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:_isIPadOS ? 200 : 169],
        [NSLayoutConstraint constraintWithItem:_bankCrapsButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:_isIPadOS ? 250 : bounds.size.height / 1.7198965977],
        [NSLayoutConstraint constraintWithItem:_bankCrapsButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant: _isIPadOS ? 333.5557038025 : 290.9090909091],

        
        // Baccarat Button
        [NSLayoutConstraint constraintWithItem:_baccaratButton attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:-88],
        [NSLayoutConstraint constraintWithItem:_baccaratButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterX multiplier:1 constant:-136],
        [NSLayoutConstraint constraintWithItem:_baccaratButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:162],
        [NSLayoutConstraint constraintWithItem:_baccaratButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:290.9090909091],
        
        // Settings Button
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTrailing multiplier:1 constant:-11],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_settingsButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        // Speaker Button
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_settingsButton attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:_settingsButton attribute:NSLayoutAttributeTrailing multiplier:1 constant:-66],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_speakerButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
//        // Questionmark Button
//        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
//        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-22],
//        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
//        [NSLayoutConstraint constraintWithItem:_questionButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
//        // Dollarsign Button
//        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:_questionButton attribute:NSLayoutAttributeTop multiplier:1 constant:66],
//        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:-22],
//        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
//        [NSLayoutConstraint constraintWithItem:_dollarsignButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
    ]];
  
}

- (void)bankCrapsButtonTapped {
    _bankCrapsViewController = [[IWIBankCrapsViewController alloc]init];
    _bankCrapsViewController.extendedLayoutIncludesOpaqueBars = NO;
    _bankCrapsViewController.edgesForExtendedLayout = UIRectEdgeAll;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = _bankCrapsViewController;
    [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];
}

- (void)baccaratButtonTapped {
    _baccaratViewController = [[BaccaratViewController alloc]init];
    _baccaratViewController.extendedLayoutIncludesOpaqueBars = NO;
    _baccaratViewController.edgesForExtendedLayout = UIRectEdgeAll;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = _baccaratViewController;
    [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];
}

- (void)blackjackButtonTapped {
    _blackJackViewController = [[SideAViewController alloc]init];
    _blackJackViewController.extendedLayoutIncludesOpaqueBars = NO;
    _blackJackViewController.edgesForExtendedLayout = UIRectEdgeAll;
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    window.rootViewController = _blackJackViewController;
    [UIView transitionWithView:window duration:0.3 options:UIViewAnimationOptionTransitionFlipFromBottom animations:nil completion:nil];

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

    [self viewDidLoad];
}

- (void)questionButtonTapped {
    // Use RootViewController to manage CCEAGLView
//    _viewController = [[RootViewController alloc]init];
//    _viewController.automaticallyAdjustsScrollViewInsets = NO;
//    _viewController.extendedLayoutIncludesOpaqueBars = NO;
//    _viewController.edgesForExtendedLayout = UIRectEdgeAll;
//    [[UIApplication sharedApplication].keyWindow setRootViewController:_viewController];
//    [[UIApplication sharedApplication].keyWindow makeKeyAndVisible];
}

- (void)dollarsignButtonTapped {
    NSLog(@"Dollarsign tapped");
    _money += 50;
    [self.view setNeedsDisplay];
}

@end
