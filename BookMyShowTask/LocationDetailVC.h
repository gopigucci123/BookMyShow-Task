//
//  LocationDetailVC.h
//  BookMyShowTask
//
//  Created by Jagadeeshwar on 06/11/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Place;

@interface LocationDetailVC : UITableViewController
@property (strong, nonatomic) Place *selectedPlace;

- (IBAction)FavAction:(id)sender;
@end
