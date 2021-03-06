//
//  MapKitVC.h
//  BookMyShowTask
//
//  Created by Jagadeeshwar on 06/11/15.
//  Copyright (c) 2015 Gopi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@class Place;
@interface MapKitVC : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
     CLLocationManager *locationManager;
}

@property (weak, nonatomic) IBOutlet MKMapView *MapView;

@property (strong, nonatomic) Place *selectedPlace;


@end
