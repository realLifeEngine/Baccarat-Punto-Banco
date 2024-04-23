//
//  SideAViewController.m
//  3PattiGalaxy-mobile
//
//  Created by Mewlan Musajan on 3/14/24.
//

#import "IWICasinoSettingsViewController.h"
#import "SideAViewController.h"
#import "SideAView.h"

@interface SideAViewController ()
@property (strong, nonatomic) SideAView *sideAView;
@end

@implementation SideAViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)loadView {
    self.sideAView = [[SideAView alloc] init];
    self.view = self.sideAView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
