import UIKit
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

        if CLLocationManager.locationServicesEnabled() {
            print("위치 서비스 On")
            locationManager.startUpdatingLocation()
        } else {
            print("위치 서비스 Off 상태")
        }

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

        NSLayoutConstraint.activate([
            mapNaverView.topAnchor.constraint(equalTo: view.topAnchor),
            mapNaverView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            mapNaverView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapNaverView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
