import UIKit
import SwiftUI
import NMapsMap
import CoreLocation


class MapViewController: UIViewController, CLLocationManagerDelegate {
    var mapView: MapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMapView()
        setupLocationManager()
    }
    
    private func setupMapView() {
        mapView = MapView()
        mapView.onMarkerTapped = { [weak self] position in
            self?.displayCustomView(for: position)
        }
        view.addSubview(mapView)
        
        mapView.translatesAutoresizingMaskIntoConstraints = false // 오토레이아웃 설정을 위해 추가
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        mapView.setupMapView()
        mapView.setupMarkers(locations: LocationManager.shared.locations)
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func displayCustomView(for position: NMGLatLng) {
        let sectionView = SectionView(latitude: position.lat, longitude: position.lng)
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
