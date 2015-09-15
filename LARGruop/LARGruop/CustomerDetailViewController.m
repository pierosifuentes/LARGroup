//
//  CustomerDetailViewController.m
//  LARGruop
//
//  Created by piero.sifuentes on 9/09/15.
//  Copyright (c) 2015 prsp.org. All rights reserved.
//

#import "CustomerDetailViewController.h"
#import "CustomerInfoViewController.h"
#import "CustomerMarketRateViewController.h"

@interface CustomerDetailViewController ()
@property (weak, nonatomic) IBOutlet UIView *selectedSecondFilterView;

@end

@implementation CustomerDetailViewController

#pragma mark -
#pragma mark - View Life Cycle
#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView {
    // Update the user interface for the detail item.
    if (self.detailItem) {
    }
}

#pragma mark -
#pragma mark - IBActions
#pragma mark -

- (IBAction)customerInfoSementedValueChanged:(UISegmentedControl *)sender {
    
    UIViewController* destinationVC;
    UIViewController* currentVC = [self getCurrentViewController];
    switch (sender.selectedSegmentIndex) {
        case 0:
            destinationVC = (CustomerInfoViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerInfoViewController"];
            break;
        case 1:
            destinationVC = (CustomerMarketRateViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerMarketRateViewController"];
            break;
            
        default:
            destinationVC = (CustomerInfoViewController*)[self.storyboard instantiateViewControllerWithIdentifier:@"CustomerInfoViewController"];
            break;
    }
    [self setViewControllerChildWith:destinationVC from:currentVC];
}

- (IBAction)allTouch:(UIButton *)sender {
}

- (IBAction)todayTouch:(id)sender {
}

#pragma mark -
#pragma mark - Actions
#pragma mark -

-(void)setViewControllerChildWith:(UIViewController*)newChildViewController from:(UIViewController*)fromViewController
{
    [fromViewController willMoveToParentViewController:nil];
    [self addChildViewController:newChildViewController];
    [self transitionFromViewController:fromViewController toViewController:newChildViewController duration:0.3 options:UIViewAnimationOptionTransitionCrossDissolve animations:^
     {
         [fromViewController removeFromParentViewController];
         [newChildViewController didMoveToParentViewController:self];
     } completion:nil];
}

-(UIViewController*)getCurrentViewController
{
    UIViewController* fromVC;
    for (UIViewController*  vc in self.childViewControllers)
    {
        if([vc isKindOfClass:[CustomerMarketRateViewController class]] || [vc isKindOfClass:[CustomerInfoViewController class]])
            fromVC =vc;
        
    }
    return fromVC;
}

-(void)reloadTable
{
     UIViewController* currentVC = [self getCurrentViewController];
    if([currentVC isKindOfClass:[CustomerInfoViewController class]])
    {
        [((CustomerInfoViewController*)currentVC).customerInfoTableView reloadData];
    }
    else if([currentVC isKindOfClass:[CustomerMarketRateViewController class]])
    {
        [((CustomerMarketRateViewController*)currentVC).customerMarketRatesTableView reloadData];
    }
}
#pragma mark -
#pragma mark - Navigation
#pragma mark -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.destinationViewController isKindOfClass:[CustomerInfoViewController class]])
    {
        CustomerInfoViewController* destinationVC = segue.destinationViewController;
        destinationVC.customerSelected = self.detailItem;
    }
}

@end
