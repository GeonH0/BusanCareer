//
//  MapViewController.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/12.
//

import UIKit
import NMapsMap
import CoreLocation

class MapViewController: UIViewController,CLLocationManagerDelegate {
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mapNaverView = NMFNaverMapView()
        mapNaverView.showZoomControls = false
        mapNaverView.showLocationButton = true
        mapNaverView.mapView.isScrollGestureEnabled = true
        mapNaverView.mapView.isTiltGestureEnabled = true
        mapNaverView.mapView.isRotateGestureEnabled = true
        mapNaverView.mapView.isStopGestureEnabled = true
        
        // Auto Layout 사용을 위해 필요함.
        mapNaverView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(mapNaverView)
        
//        if CLLocationManager.locationServicesEnabled() {
//            printContent("위치 서비스 On")
//            locationManager.startUpdatingLocation()
//            
//            print(locationManager.location?.coordinate)
//                } else {
//                        print("위치 서비스 Off 상태")
//                    }
        
        
        
       NSLayoutConstraint.activate([
        mapNaverView.topAnchor.constraint(equalTo: view.topAnchor),
        mapNaverView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        mapNaverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        mapNaverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
       ])
    }
    
    
    
}
