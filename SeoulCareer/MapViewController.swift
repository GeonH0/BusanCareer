//
//  MapViewController.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/12.
//

import UIKit
import NMapsMap

class MapViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        var mapView = NMFNaverMapView(frame: view.frame)
        view.addSubview(mapView)
        mapView.showLocationButton = true
        mapView.mapView.zoomLevel = 14

        //줌 기능 가능
//        mapView.allowsZooming  = true
//
//        mapView.minZoomLevel = 5.0
//        mapView.maxZoomLevel = 10.0
//
//
//
//        //실내 지도 활성화
//        mapView.isIndoorMapEnabled = true
        
    }
}
