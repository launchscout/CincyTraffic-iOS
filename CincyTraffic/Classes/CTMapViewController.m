//
//  CTMapViewController.m
//  CincyTraffic
//
//  Created by Chris Moore on 8/10/12.
//  Copyright (c) 2012 26Webs LLC. All rights reserved.
//

#import "CTCamerasViewController.h"
#import "CTCameraViewController.h"
#import "CTMapViewController.h"
#import "CTCameraAnnotation.h"
#import "CTCameraSiteAnnotationView.h"

@implementation CTMapViewController
@synthesize mapView, cameras, mappedCameras;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.initialLocation = nil;

    UINavigationController *navController = [self.tabBarController.viewControllers objectAtIndex:0];
    CTCamerasViewController *camerasController = [navController.viewControllers objectAtIndex:0];

    self.cameras = camerasController.cameras;
    self.mappedCameras = [NSMutableArray array];
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;

    navController = nil;
    camerasController = nil;
}

- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setCameras:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    if (self.initialLocation != nil) return;
    self.initialLocation = userLocation.location;
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(self.mapView.userLocation.coordinate, 6500, 6500) animated:YES];
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (self.initialLocation == nil) return;

    NSMutableArray *newAnnotations = [NSMutableArray array];
    
    for (CameraSite *camera in self.cameras) {
        if (MKMapRectContainsPoint(self.mapView.visibleMapRect, MKMapPointForCoordinate(camera.coordinate))) {
            if (![self.mappedCameras containsObject:camera]) {
                CTCameraAnnotation* annotation = [[CTCameraAnnotation alloc] initWithCameraSite:camera];
                [newAnnotations addObject:annotation];
                [self.mappedCameras addObject:camera];
            }
        }
    }

    [self.mapView addAnnotations:newAnnotations];
    [self.annotations addObjectsFromArray:newAnnotations];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *AnnotationViewID = @"annotationViewID";

    if (annotation == mapView.userLocation)
        return nil;
    
    CTCameraSiteAnnotationView *annotationView = (CTCameraSiteAnnotationView *)[self.mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
    if (annotationView == nil)
    {
        annotationView = [[CTCameraSiteAnnotationView alloc] initWithAnnotation:annotation
                                                                reuseIdentifier:AnnotationViewID];
        annotationView.animatesDrop = YES;
        annotationView.canShowCallout = YES;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.rightCalloutAccessoryView = button;
    }

    annotationView.annotation = annotation;
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    CTCameraAnnotation *annotation = (CTCameraAnnotation *)view.annotation;
    [self performSegueWithIdentifier:@"mapCameraDetail" sender:[annotation cameraSite]];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"mapCameraDetail"]) {
        [[segue destinationViewController] setCamera:sender];
    }
}

@end
