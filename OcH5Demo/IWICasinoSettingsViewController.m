//
//  IWICasinoSettingsViewController.m
//  CasinoGalaxy-mobile
//
//  Created by Mewlan Musajan on 4/9/24.
//

#import "IWICasinoSettingsViewController.h"
#import "GameSelectionViewController.h"

#define LUCKY_NUMBER 6
#define CatWomenColor UIColor
@interface IWICasinoSettingsViewController () <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UIViewController *homeViewController;
@property (strong, nonatomic) UIButton *homeButton;

@property (strong,nonatomic) UITableView *table;
@property (strong,nonatomic) NSArray     *content;

@property (strong, nonatomic) UITextView *aboutTextView;
@property (strong, nonatomic) UITextView *softwareLicenseAgreementTextView;
@property (strong, nonatomic) UITextView *privacyPolicyTextView;
@property (strong, nonatomic) UITextView *licenseTextView;
@property (strong, nonatomic) UITextView *personManualTextView;
@property (strong, nonatomic) UITextView *legalNoticesTextView;

@end

@implementation IWICasinoSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

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



    self.content = @[@"About", @"Software License Agreement", @"Privacy Policy",@"License",@"Person Manual",@"Legal Notices"];
    self.table = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.table.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [self.table.layer setCornerRadius:16];
    self.table.translatesAutoresizingMaskIntoConstraints = NO;
    self.table.delegate = self;
    self.table.dataSource = self;
    [self.view addSubview:self.table];

    _aboutTextView = [[UITextView alloc] init];
    [_aboutTextView.layer setCornerRadius:16];
    _aboutTextView.hidden = YES;
    _aboutTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [_aboutTextView setTextAlignment:NSTextAlignmentCenter];
    [_aboutTextView setText:@"About\n\nCasino Real\n™ and ©️2024 Willook Foundation.\nAll Rights Reserved.\n\n\n\n\n\n\n\n\n\nCreated by Fantini Versace on 4/9/24."];
    [self.view addSubview:_aboutTextView];

    _softwareLicenseAgreementTextView = [[UITextView alloc] init];
    [_softwareLicenseAgreementTextView.layer setCornerRadius:16];
    _softwareLicenseAgreementTextView.hidden = YES;
    _softwareLicenseAgreementTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [_softwareLicenseAgreementTextView setText:@"ENGLISH\nWillook Foundation.\nSOFTWARE LICENSE AGREEMENT FOR Casino Real Classic\nFor use on WILLOOK-branded Applications\nPLEASE READ THIS SOFTWARE LICENSE AGREEMENT (“LICENSE”) CAREFULLY BEFORE USING THE WILLOOK SOFTWARE. BY USING THE Willook SOFTWARE, YOU ARE AGREEING TO BE BOUND BY THE TERMS OF THIS LICENSE. IF YOU DO NOT AGREE TO THE TERMS OF THIS LICENSE, DO NOT INSTALL AND/OR USE THE WILLOOK SOFTWARE AND, IF PRESENTED WITH THE OPTION TO “AGREE” OR “DISAGREE” TO THE TERMS, CLICK “DISAGREE."];
    [self.view addSubview:_softwareLicenseAgreementTextView];

    _privacyPolicyTextView = [[UITextView alloc] init];
    [_privacyPolicyTextView.layer setCornerRadius:16];
    _privacyPolicyTextView .hidden = YES;
    _privacyPolicyTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [_privacyPolicyTextView setText:@"Privacy Policy\nWelcome\nSecurity and privacy are at the heart of what we do. Accordingly, we think it’s important to be transparent about what we do with your information and how we handle it.  This Privacy Policy describes how we process and handle data provided to us in connection with your use of our products, services, apps, and websites that link to this policy (we refer to these collectively as our “services”).\nThis policy uses the term “personal data” to refer to information that is related to an identified or identifiable natural person and is protected as personal data under applicable data protection law.\n1. What information do we collect about you?\n☞Language & Region information. Some services require to use your language & region information before you can access them.\nContact Us\nWe expect this Privacy Policy to evolve over time and welcome feedback from our users about our privacy practices. If you have any questions or complaints about our privacy practices, you can contact us using the following details:\n\tic/o Willook Foundation.\n\tAttn: Legal Department\n\tiliq@me.com\n\thttps://www.Willook.com"];
    [self.view addSubview:_privacyPolicyTextView];

    _personManualTextView = [[UITextView alloc] init];
    [_personManualTextView.layer setCornerRadius:16];
    _personManualTextView.hidden = YES;
    _personManualTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [_personManualTextView setText:@"At a blackjack table, the dealer faces five to nine playing positions from behind a semicircular table. Between one and eight standard 52-card decks are shuffled together. To start each round, players place bets in the 'betting box' at each position. In jurisdictions allowing back betting, up to three players can be at each position. The player whose bet is at the front of the betting box controls the position, and the dealer consults the controlling player for playing decisions; the other bettors 'play behind'. A player can usually control or bet in as many boxes as desired at a single table, but an individual cannot play on more than one table at a time or place multiple bets within a single box. In many U.S. casinos, players are limited to playing one to three positions at a table.\nThe dealer deals from their left ('first base') to their far right ('third base'). Each box gets an initial hand of two cards visible to the people playing on it. The dealer's hand gets its first card face-up and, in 'hole card' games, immediately gets a second card face-down (the hole card), which the dealer peeks at but only reveals when it makes the dealer's hand a blackjack. Hole card games are sometimes played on tables with a small mirror or electronic sensor used to peek securely at the hole card. In European casinos, 'no hole card' games are prevalent; the dealer's second card is not drawn until the players have played their hands.\nDealers deal the cards from one or two handheld decks, from a dealer's shoe or from a shuffling machine. Single cards are dealt to each wagered-on position clockwise from the dealer's left, followed by a single card to the dealer, followed by an additional card to each of the positions in play. The players' initial cards may be dealt face-up or face-down (more common in single-deck games).\nThe object of the game is to win money by creating card totals higher than those of the dealer's hand but not exceeding 21, or by stopping at a total in the hope that the dealer will bust. On their turn, players choose to 'hit' (take a card), 'stand' (end their turn and stop without taking a card), 'double' (double their wager, take a single card, and finish), 'split' (if the two cards have the same value, separate them to make two hands), or 'surrender' (give up a half-bet and retire from the game). Number cards count as their number, the jack, queen, and king ('face cards' or 'pictures') count as 10, and aces count as either 1 or 11 according to the player's choice. If the total exceeds 21 points, it busts, and all bets on it immediately lose.\nAfter the boxes have finished playing, the dealer's hand is resolved by drawing cards until the hand achieves a total of 17 or higher. If the dealer has a total of 17 including an ace valued as 11 (a 'soft 17'), some games require the dealer to stand while other games require another draw. The dealer never doubles, splits, or surrenders. If the dealer busts, all remaining player hands win. If the dealer does not bust, each remaining bet wins if its hand is higher than the dealer's and loses if it is lower.\nA player total of 21 on the first two cards is a 'natural' or 'blackjack', and the player wins immediately unless the dealer also has one, in which case the hand ties. In the case of a tie ('push' or 'standoff'), bets are returned without adjustment. A blackjack beats any hand that is not a blackjack, even one with a value of 21.\nWins are paid out at even money, except for player blackjacks, which are traditionally paid out at 3 to 2 odds. Many casinos today pay blackjacks at less than 3:2. This is common in single-deck blackjack games.[11]\nBlackjack games usually offer a side bet called insurance, which may be placed when the dealer's face-up card is an ace. Additional side bets, such as 'Dealer Match' which pays when the player's cards match the dealer's up card, are also sometimes available.\n\n\nPunto banco\nPunto banco is the most played version of baccarat.[6]: 231  In punto banco, the casino banks the game at all times, and commits to playing out both hands according to fixed drawing rules, known as the 'tableau' (French: 'board'), in contrast to more historic baccarat games where each hand is associated with an individual who makes drawing choices. The player (punto) and banker (banco) are simply designations for the two hands dealt out in each coup, two outcomes which the bettor can back; the player hand has no particular association with the gambler, nor the banker hand with the house.\nPunto banco is dealt from a shoe containing 6 or 8 decks of cards shuffled together; a cut-card is placed in front of the seventh from last card, and the drawing of the cut-card indicates the last coup of the shoe. The dealer burns the first card face up and then based on its respective numerical value, with aces worth 1 and face cards worth 10, the dealer burns that many cards face down. For each coup, two cards are dealt face up to each hand, starting from 'player' and alternating between the hands. The croupier may call the total (e.g., 'five player, three banker'). If either the player or banker or both achieve a total of 8 or 9 at this stage, the coup is finished and the result is announced: a player win, a banker win, or tie. If neither hand has eight or nine, the drawing rules are applied to determine whether the player should receive a third card. Then, based on the value of any card drawn to the player, the drawing rules are applied to determine whether the banker should receive a third card. The coup is then finished, the outcome is announced, and winning bets are paid out.\nPunto banco is a pure game of chance and therefore it is not possible for a gambler's bets to be rationally motivated.[6]: 230\nTableau of drawing rules\nIf neither the player nor the banker is dealt a total of 8 or 9 in the first two cards (known as a 'natural'), the tableau is consulted, first for the player's rules, then the banker's.\nPlayer's rule\nIf the player has an initial total of 5 or less, they draw a third card. If the player has an initial total of 6 or 7, they stand.\nBanker's rule\nIf the player stood pat (i.e. has only two cards), the banker regards only their own hand and acts according to the same rule as the player, i.e. the banker draws a third card with hands 5 or less and stands with 6 or 7.\nIf the player drew a third card, the banker acts according to the following more complex rules:\nIf the banker total is 2 or less, they draw a third card regardless of what the player's third card is.\nIf the banker total is 3, they draw a third card unless the player's third card is an 8.\nIf the banker total is 4, they draw a third card if the player's third card is 2, 3, 4, 5, 6, or 7.\nIf the banker total is 5, they draw a third card if the player's third card is 4, 5, 6, or 7.\nIf the banker total is 6, they draw a third card if the player's third card is a 6 or 7.\nIf the banker total is 7, they stand.\n\n\nBank Craps\nEach casino may set which bets are offered and different payouts for them, though a core set of bets and payouts is typical. Players take turns rolling two dice and whoever is throwing the dice is called the 'shooter'. Players can bet on the various options by placing chips directly on the appropriately-marked sections of the layout, or asking the base dealer or stickman to do so, depending on which bet is being made.\nWhile acting as the shooter, a player must have a bet on the 'Pass' line and/or the 'Don't Pass' line. 'Pass' and 'Don't Pass' are sometimes called 'Win' and 'Don't Win' or 'Right' and 'Wrong' bets. The game is played in rounds and these 'Pass' and 'Don't Pass' bets are betting on the outcome of a round. The shooter is presented with multiple dice (typically five) by the 'stickman', and must choose two for the round. The remaining dice are returned to the stickman's bowl and are not used.\nEach round has two phases: 'come-out' and 'point'. Dice are passed to the left. To start a round, the shooter makes one or more 'come-out' rolls. The shooter must shoot toward the farther back wall and is generally required to hit the farther back wall with both dice. Casinos may allow a few warnings before enforcing the dice to hit the back wall and are generally lenient if at least one die hits the back wall. Both dice must be tossed in one throw. If only one die is thrown the shot is invalid. A come-out roll of 2, 3, or 12 is called 'craps' or 'crapping out', and anyone betting the Pass line loses. On the other hand, anyone betting the Don't Pass line on come out wins with a roll of 2 or 3 and ties (pushes) if a 12 is rolled. Shooters may keep rolling after crapping out; the dice are only required to be passed if a shooter sevens out (rolls a seven after a point has been established). A come-out roll of 7 or 11 is a 'natural'; the Pass line wins and Don't Pass loses. The other possible numbers are the point numbers: 4, 5, 6, 8, 9, and 10. If the shooter rolls one of these numbers on the come-out roll, this establishes the 'point' – to 'pass' or 'win', the point number must be rolled again before a seven.\nThe dealer flips a button to the 'On' side and moves it to the point number signifying the second phase of the round. If the shooter 'hits' the point value again (any value of the dice that sum to the point will do; the shooter does not have to exactly repeat the exact combination of the come-out roll) before rolling a seven, the Pass line wins and a new round starts. If the shooter rolls any seven before repeating the point number (a 'seven-out'), the Pass line loses, the Don't Pass line wins, and the dice pass clockwise to the next new shooter for the next round. Once a point has been established any multi-roll bet (including Pass and/or Don't Pass line bets and odds) are unaffected by the 2, 3, 11, or 12; the only numbers which affect the round are the established point, any specific bet on a number, or any 7. Any single roll bet is always affected (win or lose) by the outcome of any roll.\nWhile the come-out roll may specifically refer to the first roll of a new shooter, any roll where no point is established may be referred to as a come-out. By this definition the start of any new round regardless if it is the shooter's first toss can be referred to as a come-out roll.\nAny player can make a bet on Pass or Don't Pass as long as a point has not been established, or Come or Don't Come as long as a point is established. All other bets, including an increase in odds behind the Pass and Don't Pass lines, may be made at any time. All bets other than Pass line and Come may be removed or reduced any time before the bet loses. This is known as 'taking it down' in craps.\nThe maximum bet for Place, Buy, Lay, Pass, and Come bets are generally equal to table maximum. Lay bet maximum are equal to the table maximum win, so players wishing to lay the 4 or 10 may bet twice at amount of the table maximum for the win to be table maximum. Odds behind Pass, Come, Don't Pass, and Don't Come may be however larger than the odds offered allows and can be greater than the table maximum in some casinos. Don't odds are capped on the maximum allowed win some casino allow the odds bet itself to be larger than the maximum bet allowed as long as the win is capped at maximum odds. Single rolls bets can be lower than the table minimum, but the maximum bet allowed is also lower than the table maximum. The maximum allowed single roll bet is based on the maximum allowed win from a single roll.\nIn all the above scenarios, whenever the Pass line wins, the Don't Pass line loses, and vice versa, with one exception: on the come-out roll, a roll of 12 will cause Pass Line bets to lose, but Don't Pass bets are pushed (or 'barred'), neither winning nor losing. (The same applies to 'Come' and 'Don't Come' bets, discussed below.)"];
    [self.view addSubview:_personManualTextView];
    
    _licenseTextView = [[UITextView alloc] init];
    [_licenseTextView.layer setCornerRadius:16];
    _licenseTextView.hidden = YES;
    _licenseTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [_licenseTextView setText:@" The WI License (Willook)\nCopyright © 2024 Willook Foundation\nPermission is hereby granted, The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."];
    [self.view addSubview:_licenseTextView];

    _legalNoticesTextView = [[UITextView alloc] init];
    [_legalNoticesTextView.layer setCornerRadius:16];
    _legalNoticesTextView.hidden = YES;
    _legalNoticesTextView.translatesAutoresizingMaskIntoConstraints = NO;
    [_legalNoticesTextView setText:@"Legal Notices:\n\nCopyright ©️ 2024 Willook Foundation. All rights reserved.\n--------------------------------\nCoreTextArcView.m\nCreated by David Marioni on 27.12.11.\nCopyright (c) 2011 David Marioni. All rights reserved.\n--------------------------------\nBlack Jack 2\nCreated by Khoa Nguyen on 1/13/14.\nCopyright (c) 2014 Khoa Nguyen. All rights reserved.\n--------------------------------\nBaccarat\nCopyright © 2016 simon. All rights reserved."];
    [self.view addSubview:_legalNoticesTextView];

//    @property (strong, nonatomic) UITextView *aboutTextView;
//    @property (strong, nonatomic) UITextView *softwareLicenseAgreementTextView;
//    @property (strong, nonatomic) UITextView *privacyPolicyTextView;
//    @property (strong, nonatomic) UITextView *licenseTextView;
//    @property (strong, nonatomic) UITextView *personManualTextView;
//    @property (strong, nonatomic) UITextView *legalNoticesTextView;

    [_aboutTextView setEditable:NO];
    [_softwareLicenseAgreementTextView setEditable:NO];
    [_privacyPolicyTextView setEditable:NO];
    [_licenseTextView setEditable:NO];
    [_personManualTextView setEditable:NO];
    [_legalNoticesTextView setEditable:NO];

    _homeButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_homeButton setBackgroundImage:[UIImage imageNamed:@"house.a49f6d"] forState:UIControlStateNormal];
    _homeButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_homeButton addTarget:self action:@selector(homeButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_homeButton];

    UILayoutGuide *safeAreaLayoutGuide = self.view.safeAreaLayoutGuide;
    [self.view addConstraints:@[
        // Table View
        [NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_homeButton attribute:NSLayoutAttributeLeading multiplier:1 constant:77],
        [NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height - 111],
        [NSLayoutConstraint constraintWithItem:_table attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2 / 2 + 100],

        // About Text View
        [NSLayoutConstraint constraintWithItem:_aboutTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_table attribute:NSLayoutAttributeLeading multiplier:1 constant:bounds.size.width / 2 / 2 + 100 + 33],
        [NSLayoutConstraint constraintWithItem:_aboutTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_aboutTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height - 111],
        [NSLayoutConstraint constraintWithItem:_aboutTextView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2 / 2 + 115],

        // Software License Agreement Text View
        [NSLayoutConstraint constraintWithItem:_softwareLicenseAgreementTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_table attribute:NSLayoutAttributeLeading multiplier:1 constant:bounds.size.width / 2 / 2 + 100 + 33],
        [NSLayoutConstraint constraintWithItem:_softwareLicenseAgreementTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_softwareLicenseAgreementTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height - 111],
        [NSLayoutConstraint constraintWithItem:_softwareLicenseAgreementTextView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2 / 2 + 115],

        // Privacy Policy Text View
        [NSLayoutConstraint constraintWithItem:_privacyPolicyTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_table attribute:NSLayoutAttributeLeading multiplier:1 constant:bounds.size.width / 2 / 2 + 100 + 33],
        [NSLayoutConstraint constraintWithItem:_privacyPolicyTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_privacyPolicyTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height - 111],
        [NSLayoutConstraint constraintWithItem:_privacyPolicyTextView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2 / 2 + 115],

        // Person Manual Text View
        [NSLayoutConstraint constraintWithItem:_personManualTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_table attribute:NSLayoutAttributeLeading multiplier:1 constant:bounds.size.width / 2 / 2 + 100 + 33],
        [NSLayoutConstraint constraintWithItem:_personManualTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_personManualTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height - 111],
        [NSLayoutConstraint constraintWithItem:_personManualTextView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2 / 2 + 115],

        // Legal Notices Text View
        [NSLayoutConstraint constraintWithItem:_legalNoticesTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_table attribute:NSLayoutAttributeLeading multiplier:1 constant:bounds.size.width / 2 / 2 + 100 + 33],
        [NSLayoutConstraint constraintWithItem:_legalNoticesTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_legalNoticesTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height - 111],
        [NSLayoutConstraint constraintWithItem:_legalNoticesTextView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2 / 2 + 115],

        // License Text View
       [NSLayoutConstraint constraintWithItem:_licenseTextView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:_table attribute:NSLayoutAttributeLeading multiplier:1 constant:bounds.size.width / 2 / 2 + 100 + 33],
       [NSLayoutConstraint constraintWithItem:_licenseTextView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
       [NSLayoutConstraint constraintWithItem:_licenseTextView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.height - 111],
       [NSLayoutConstraint constraintWithItem:_licenseTextView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:bounds.size.width / 2 / 2 + 115],

        // Home Button
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeTop multiplier:1 constant:22],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:safeAreaLayoutGuide attribute:NSLayoutAttributeLeading multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
        [NSLayoutConstraint constraintWithItem:_homeButton attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:44],
    ]];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _content.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [self.table dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
    }
    cell.textLabel.text =  [_content objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;
{
    NSLog(@"title of cell %@, %ld", [_content objectAtIndex:indexPath.row], indexPath.row);
    if (indexPath.row == 0) {
        [_licenseTextView setHidden:YES];
        [_softwareLicenseAgreementTextView setHidden:YES];
        [_privacyPolicyTextView setHidden:YES];
        [_licenseTextView setHidden:YES];
        [_personManualTextView setHidden:YES];
        [_legalNoticesTextView setHidden:YES];
        [_aboutTextView setHidden:NO];
        [self.view setNeedsDisplay];
    }
    if (indexPath.row == 1) {
        [_licenseTextView setHidden:YES];
        [_softwareLicenseAgreementTextView setHidden:NO];
        [_privacyPolicyTextView setHidden:YES];
        [_licenseTextView setHidden:YES];
        [_personManualTextView setHidden:YES];
        [_legalNoticesTextView setHidden:YES];
        [_aboutTextView setHidden:YES];
        [self.view setNeedsDisplay];
    }
    if (indexPath.row == 2) {
        [_licenseTextView setHidden:YES];
        [_softwareLicenseAgreementTextView setHidden:YES];
        [_privacyPolicyTextView setHidden:NO];
        [_licenseTextView setHidden:YES];
        [_personManualTextView setHidden:YES];
        [_legalNoticesTextView setHidden:YES];
        [_aboutTextView setHidden:YES];
        [self.view setNeedsDisplay];
    }
    if (indexPath.row == 3) {
        [_licenseTextView setHidden:YES];
        [_softwareLicenseAgreementTextView setHidden:YES];
        [_privacyPolicyTextView setHidden:YES];
        [_licenseTextView setHidden:NO];
        [_personManualTextView setHidden:YES];
        [_legalNoticesTextView setHidden:YES];
        [_aboutTextView setHidden:YES];
        [self.view setNeedsDisplay];
    }
    if (indexPath.row == 4) {
        [_licenseTextView setHidden:YES];
        [_softwareLicenseAgreementTextView setHidden:YES];
        [_privacyPolicyTextView setHidden:YES];
        [_licenseTextView setHidden:YES];
        [_personManualTextView setHidden:NO];
        [_legalNoticesTextView setHidden:YES];
        [_aboutTextView setHidden:YES];
        [self.view setNeedsDisplay];
    }
    if (indexPath.row == 5) {
        [_licenseTextView setHidden:YES];
        [_softwareLicenseAgreementTextView setHidden:NO];
        [_privacyPolicyTextView setHidden:YES];
        [_licenseTextView setHidden:YES];
        [_personManualTextView setHidden:YES];
        [_legalNoticesTextView setHidden:NO];
        [_aboutTextView setHidden:YES];
        [self.view setNeedsDisplay];
    }

}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
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
