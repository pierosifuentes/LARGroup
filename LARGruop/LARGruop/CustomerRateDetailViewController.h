//
//  CustomerRateDetailViewController.h
//  LARGruop
//
//  Created by piero.sifuentes on 21/09/15.
//  Copyright (c) 2015 prsp.org. All rights reserved.
//

#import "BaseViewController.h"
#import "Rate.h"

@interface CustomerRateDetailViewController : BaseViewController <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) Rate* rate;

@end
