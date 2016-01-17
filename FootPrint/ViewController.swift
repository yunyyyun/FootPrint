//
//  ViewController.swift
//  FootPrint
//
//  Created by mengyun on 16/1/14.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate{
    
    var mapView:MKMapView!
    var points:NSMutableArray!
    var routeLine:MKPolyline!
    var locationManager:CLLocationManager!
    var currentLocation:CLLocation!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        mInit()
    }

    func mInit(){
        mapView=MKMapView(frame: view.frame)
        mapView.delegate=self
        mapView.showsUserLocation=true
        mapView.userInteractionEnabled=true
        view.addSubview(mapView)
        
        locationManager=CLLocationManager()
        locationManager.delegate=self
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy=kCLLocationAccuracyBest
        locationManager.distanceFilter=kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        configureRoutes()
    }
    
    //设置路线
    func configureRoutes(){
        if (points != nil){
            let pointsArray = UnsafeMutablePointer<MKMapPoint>.alloc(sizeof(CLLocationCoordinate2D) * points.count)
            for idx in 0...points.count-1{
                let location: CLLocation = points[idx] as! CLLocation
                let latitude: CLLocationDegrees = location.coordinate.latitude
                let longitude: CLLocationDegrees = location.coordinate.longitude
                let coordinate: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
                let point: MKMapPoint = MKMapPointForCoordinate(coordinate)
                pointsArray[idx] = point
                if (routeLine != nil){
                    mapView.removeOverlay(routeLine)
                }
                //print("configureRoutes..points: ", points.count);
                routeLine = MKPolyline(points: pointsArray, count: points.count)
                if (routeLine != nil){
                    //print("...........routeLine != nil %@",routeLine)
                    mapView.addOverlay(routeLine)
                }
            }
        }
    }
    //代理方法，这是折线颜色、宽度
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        //print("rendererForOverlay..points: %@", points);
        let render = MKPolylineRenderer(overlay: overlay)
        render.lineWidth=3;    //设置颜色    
        render.strokeColor = UIColor.redColor()
        return render;
    }
    //位置更新时调用
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if  (userLocation.coordinate.latitude==0.0||userLocation.coordinate.longitude==0.0){
            return;
        }
        let location = CLLocation.init(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        if (points != nil){
        if points.count>0{
            let distance = location.distanceFromLocation(currentLocation)
            if distance<5{
                //return;
            }
        }
        }
        if points==nil{
            points = NSMutableArray()
        }
        points.addObject(location)
        currentLocation = location
        //print("didUpdateUserLocation..points: %@", points);
        configureRoutes()
        let coordinate = CLLocationCoordinate2DMake(userLocation.coordinate.latitude, userLocation.coordinate.longitude)
        mapView.setCenterCoordinate(coordinate, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}