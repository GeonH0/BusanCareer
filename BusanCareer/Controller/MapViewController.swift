import UIKit
import SwiftUI
import NMapsMap
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate, NMFMapViewTouchDelegate {
    var locationManager: CLLocationManager!
    var infoWindow = NMFInfoWindow()
    var mapNaverView: NMFNaverMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        mapNaverView = NMFNaverMapView() // 클래스 레벨 변수를 직접 사용
        mapNaverView.showZoomControls = true
        mapNaverView.showLocationButton = true
        mapNaverView.mapView.isScrollGestureEnabled = true
        mapNaverView.mapView.isTiltGestureEnabled = true
        mapNaverView.mapView.isRotateGestureEnabled = true
        mapNaverView.mapView.isStopGestureEnabled = true
        mapNaverView.translatesAutoresizingMaskIntoConstraints = false
        mapNaverView.mapView.touchDelegate = self // touchDelegate 설정
        
        view.addSubview(mapNaverView)
        
        NSLayoutConstraint.activate([
            mapNaverView.topAnchor.constraint(equalTo: view.topAnchor),
            mapNaverView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapNaverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapNaverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        setupMarkers()
    }
    
    func setupMarkers() {
        for location in LocationManager.shared.locations {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            marker.captionText = location.name
            marker.mapView = mapNaverView.mapView

            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                guard let self = self, let marker = overlay as? NMFMarker else { return true }

                self.displayCustomView(for: marker)
                return true
            }
        }
    }
    private func displayCustomView(for marker: NMFMarker) {
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
        customView.backgroundColor = .white
        customView.center = self.view.center
        self.view.addSubview(customView)

        // 추가적인 뷰 설정, 예를 들어 레이블 추가 등
    }

    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        infoWindow.close()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            print("위치 서비스 On")
            locationManager.startUpdatingLocation()
        case .notDetermined, .restricted, .denied:
            print("위치 서비스 Off 상태")
        default:
            print("위치 권한 상태 알 수 없음")
            break
        }
    }
}
