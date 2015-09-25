//
//  MapViewController.m
//  LARGruop
//
//  Created by piero.sifuentes on 8/09/15.
//  Copyright (c) 2015 prsp.org. All rights reserved.
//

#import "MapViewController.h"
#import "ProyectService.h"
#import "ProyectPointAnnotation.h"
#import "MapMarkDetailViewController.h"
#import "ProyectDetailViewController.h"
#import <Haneke/Haneke.h>

static NSString *MAP_ANNOTATION_IDENTIFIER = @"MAP_ANNOTATION_IDENTIFIER";
static NSString* const MAP_PROYECT_DETAIL_SEGUE = @"MAP_PROYECT_DETAIL_SEGUE";

@interface MapViewController ()

@property (weak, nonatomic) IBOutlet MKMapView *proyectsMapView;
@property CLLocationManager *locationManager;
@property NSMutableArray* proyects;
@property (nonatomic,strong) UIPopoverController* popover;
@end

@implementation MapViewController

#pragma mark -
#pragma mark - View Life Cycle
#pragma mark -

-(void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:TRUE];
    [self setupVars];
    [self setupViews];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)setupViews
{
    [self.navigationController setNavigationBarHidden:TRUE];
    [self loadPins];
}

-(void)setupVars
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.proyects = [[NSMutableArray alloc]initWithArray:[[ProyectService sharedService]getAllProyects]];
}

-(void)loadPins
{
    CLAuthorizationStatus authorizationStatus= [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusAuthorizedAlways ||
        authorizationStatus == kCLAuthorizationStatusAuthorizedWhenInUse) {
        self.locationManager.delegate =self;
        [self.locationManager startMonitoringSignificantLocationChanges];
        [self.locationManager startUpdatingLocation];
        
        for (Proyect* proyect in self.proyects) {
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake(proyect.latitud.doubleValue, proyect.longitude.doubleValue);
            ProyectPointAnnotation *annotation = [[ProyectPointAnnotation alloc] init];
            [annotation setCoordinate:location]; //Add cordinates
            annotation.proyectImage = proyect.mapImageURL;
            annotation.proyectUID = proyect.uid;
            annotation.leftDepartments = proyect.leftDepartaments;
            [self.proyectsMapView addAnnotation:annotation];
        }
    }
    [self displayCorrectZoom];
}

-(void)displayCorrectZoom
{
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.proyectsMapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }
    [self.proyectsMapView setVisibleMapRect:zoomRect animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)map viewForAnnotation:(id <MKAnnotation>)annotation
{
    AnnotationView *pinView = nil;
    if ([annotation isKindOfClass:[ProyectPointAnnotation class]])
    {
        
        pinView = (AnnotationView *)[self.proyectsMapView dequeueReusableAnnotationViewWithIdentifier:MAP_ANNOTATION_IDENTIFIER];
        if ( pinView == nil )
            pinView = [[AnnotationView alloc]
                       initWithAnnotation:annotation reuseIdentifier:MAP_ANNOTATION_IDENTIFIER];
        else
        {
            pinView.annotation = annotation;
        }
        
        pinView.enabled = YES;
        pinView.canShowCallout = NO;
        
        NSURL* url = [NSURL URLWithString:((ProyectPointAnnotation*)annotation).proyectImage];
        UIImage* image;
        NSData *data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
        image = [image resizedImage:CGSizeMake(70, 70) interpolationQuality:kCGInterpolationHigh ];
        image = [image roundedCornerImage:35 borderSize:2];
        CGRect frame = CGRectMake(0, 0,image.size.width,image.size.height);
        UIView* border = [[UIView alloc]initWithFrame:frame];
        border.layer.cornerRadius = border.bounds.size.width/2;
        border.layer.masksToBounds = YES;
        border.layer.borderWidth = 5.0;
        border.layer.borderColor = [UIColor colorForAvaibleDepartmentsCount:((ProyectPointAnnotation*)annotation).leftDepartments.integerValue].CGColor;
        [pinView addSubview:border];
        [pinView sendSubviewToBack:border];
        pinView.image = image;
        pinView.annotation = annotation;
    }
    return pinView;
    
    
    }


- (void)mapView:(MKMapView *)mapView1 didSelectAnnotationView:(MKAnnotationView *)mapView2
{
    if([mapView2 isKindOfClass:[AnnotationView class]])
    {
        NSString* uid = ((AnnotationView*)mapView2).proyectAnnotation.proyectUID;
        [mapView1 deselectAnnotation:mapView2.annotation animated:YES];
        MapMarkDetailViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MapMarkDetailViewController"];
        controller.proyectUID = uid;
        controller.delegate = self;
        CGSize temporalPopoverSize = CGSizeMake(300.0f, 200.0f);
        [controller setPopOverViewSize:temporalPopoverSize];
        self.popover = [[UIPopoverController alloc] initWithContentViewController:controller];
        [self.popover setPopoverContentSize:temporalPopoverSize animated:TRUE];
        self.popover.backgroundColor = controller.view.backgroundColor;
        self.popover.delegate = self;
        
        [self.popover presentPopoverFromRect:mapView2.frame
                                      inView:mapView2.superview
                    permittedArrowDirections:UIPopoverArrowDirectionAny
                                    animated:YES];
    }
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
//    UIView* subview = [self.view viewWithTag:1];
//    [subview removeFromSuperview];
//    subview = nil;
    
}

#pragma mark -
#pragma mark - Core Location Manager Methods
#pragma mark -

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"Error type: %@ \n", error.localizedDescription);
}

- (IBAction)displayProyectTouch:(UIButton *)sender {
}

#pragma mark -
#pragma mark - Proyect Annotation Delegate
#pragma mark -

-(void)showProyectDetailControllerWithProyecUID:(NSString *)proyectUID
{
    [self.popover dismissPopoverAnimated:TRUE];
    [self performSegueWithIdentifier:MAP_PROYECT_DETAIL_SEGUE sender:proyectUID];
}

#pragma mark -
#pragma mark - Navigation
#pragma mark -

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.destinationViewController isKindOfClass:[ProyectDetailViewController class]])
    {
        ProyectDetailViewController* destinationVC = segue.destinationViewController;
        destinationVC.selectedProyectID = sender;
    }
}
@end
