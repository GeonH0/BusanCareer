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
    func displayCustomView(for marker: NMFMarker) {
        let sectionView = SectionView(latitude: marker.position.lat, longitude: marker.position.lng)
        
        // SwiftUI 뷰를 포함하는 UIHostingController를 생성합니다.
        let customViewController = UIHostingController(rootView: sectionView)
        
        if let sheet = customViewController.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 20
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
        }
        self.present(customViewController, animated: true)
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
