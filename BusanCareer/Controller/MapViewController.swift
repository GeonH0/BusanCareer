import UIKit
import SwiftUI
import NMapsMap
import CoreLocation

class MapViewController: UIViewController, CLLocationManagerDelegate {
    var locationManager: CLLocationManager!

    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        // 요청하는 위치 서비스 권한을 선택합니다.
        locationManager.requestWhenInUseAuthorization() // 또는 locationManager.requestAlwaysAuthorization()

        let mapNaverView = NMFNaverMapView()
        mapNaverView.showZoomControls = true
        mapNaverView.showLocationButton = true
        mapNaverView.mapView.isScrollGestureEnabled = true
        mapNaverView.mapView.isTiltGestureEnabled = true
        mapNaverView.mapView.isRotateGestureEnabled = true
        mapNaverView.mapView.isStopGestureEnabled = true

        // Auto Layout 사용을 위해 필요함.
        mapNaverView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(mapNaverView)

        NSLayoutConstraint.activate([
            mapNaverView.topAnchor.constraint(equalTo: view.topAnchor),
            mapNaverView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapNaverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapNaverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        
        for location in LocationManager.shared.locations {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            marker.captionText = location.name
            marker.mapView = mapNaverView.mapView

            // 마커 클릭시 동작 설정
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                if let marker = overlay as? NMFMarker {
                    let detailView = SectionView(latitude: marker.position.lat, longitude: marker.position.lng)
                    let detailVC = UIHostingController(rootView: detailView)                    
                    if let sheet = detailVC.sheetPresentationController {
                        sheet.detents = [.medium(), .large()]
                        sheet.prefersGrabberVisible = true
                        sheet.preferredCornerRadius = 20
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false

                    }
                    self?.present(detailVC, animated: true, completion: nil)
                }
                return true
            }
        }


        
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
