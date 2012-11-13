//
//  CTMapViewController.h
//  CincyTraffic
//
//  Created by Chris Moore on 8/10/12.
//  Copyright (c) 2012 26Webs LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "ADClusterMapView.h"

@interface CTMapViewController : UIViewController <ADClusterMapViewDelegate>
@property (nonatomic, retain) CLLocation *initialLocation;
@property (strong, nonatomic) NSMutableArray *annotations;
@property (strong, nonatomic) NSMutableArray *mappedCameras;
@property (strong, nonatomic) IBOutlet ADClusterMapView *mapView;
@property (strong, nonatomic) NSMutableArray *cameras;
@end
