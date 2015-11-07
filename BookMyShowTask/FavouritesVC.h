//
//  FavouritesVC.h
//  BookMyShowTask
//
//  Created by Jagadeeshwar on 06/11/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouritesVC : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *FavouritesTableView;

@end
