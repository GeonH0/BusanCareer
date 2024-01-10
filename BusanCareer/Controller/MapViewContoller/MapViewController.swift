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
        mapView.sections = LocationManager.shared.sections
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
        mapView.setupMarkers()
    }
    
    private func setupLocationManager() {
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    func displayCustomView(for position: NMGLatLng) {
        guard let section = LocationManager.shared.sections.first(where: { $0.latitude == position.lat && $0.longitude == position.lng }) else { return }
        
        let sectionView = SectionView(section: section)
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
