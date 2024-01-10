//
//  LocationManager.swift
//  SeoulCareer
//
//  Created by 김건호 on 11/14/23.
//

import Foundation


class LocationManager {
    
    static let shared = LocationManager()
    
    let locations = [
        BusanLocation(name: "부산광역시청", latitude: 35.1797239714629, longitude: 129.0750674877053),
        BusanLocation(name: "중구청", latitude: 35.106811187787, longitude: 129.03267283356),
        BusanLocation(name: "서구청", latitude: 35.097925901195715, longitude: 129.0242908237811),
        BusanLocation(name: "동구청", latitude: 35.129269520989915, longitude: 129.04530474152244),
        
        BusanLocation(name: "영도구청", latitude: 35.09122788695318, longitude: 129.06793235534957),
        BusanLocation(name: "부산진구청", latitude: 35.16291044581287, longitude: 129.05313719748938),
        BusanLocation(name: "동래구청", latitude: 35.195985705984, longitude: 129.09348730275),
        BusanLocation(name: "남구청", latitude: 35.136393960597, longitude: 129.08440079619),
        BusanLocation(name: "북구청", latitude: 35.196851969951, longitude: 128.99018922007),
        
        BusanLocation(name: "해운대구청", latitude: 35.16305771043729, longitude: 129.16359310330444),
        BusanLocation(name: "사하구청", latitude: 35.104420075687976, longitude: 128.97492626790526),
        BusanLocation(name: "금정구청", latitude: 35.24275693524796, longitude: 129.09209477174923),
        BusanLocation(name: "강서구청", latitude: 35.21217025889064, longitude: 128.9805281585466),
        BusanLocation(name: "연제구청", latitude: 35.17620830555359, longitude: 129.07973048207495),
        BusanLocation(name: "수영구청", latitude: 35.14550287452813, longitude: 129.11309410007303),
        BusanLocation(name: "사상구청", latitude: 35.15250482872145, longitude: 128.99144118721986),
        BusanLocation(name: "기장군청", latitude: 35.24442021501693, longitude: 129.22242980337498),
    ]
    
    var sections: [Section] = []
    
    private init() {}
    
}
