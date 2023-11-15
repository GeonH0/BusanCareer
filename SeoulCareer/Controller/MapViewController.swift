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
        
        
        for location in LocationManager.shared.locations {
            let marker = NMFMarker()
            marker.position = NMGLatLng(lat: location.latitude, lng: location.longitude)
            marker.captionText = location.name
            marker.mapView = mapNaverView.mapView

            // 마커 클릭시 동작 설정
            marker.touchHandler = { [weak self] (overlay: NMFOverlay) -> Bool in
                if let marker = overlay as? NMFMarker {
                    // 알림창 생성
                    let alertController = UIAlertController(title: marker.captionText, message: "위도: \(marker.position.lat), 경도: \(marker.position.lng)", preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                    alertController.addAction(okAction)

                    // 알림창 표시
                    self?.present(alertController, animated: true, completion: nil)
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
