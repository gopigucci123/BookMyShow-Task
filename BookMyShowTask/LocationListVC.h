//
//  LocationListVC.h
//  BookMyShowTask
//
//  Created by Jagadeeshwar on 06/11/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreLocation/CoreLocation.h>



@interface LocationListVC : UIViewController<UITableViewDataSource,UITableViewDelegate, CLLocationManagerDelegate>

@property(nonatomic, strong)NSString *CarryCategoryStr;
@property (weak, nonatomic) IBOutlet UITableView *LocationListTableView;

@end
