//
//  JobDataFetch.swift
//  SeoulCareer
//
//  Created by 김건호 on 11/10/23.
//

import Foundation
import Alamofire

class JobDataFetcher {

    func fetchJobOverview(page: Int, completion: @escaping ([Item]) -> Void) {
        let url = "http://apis.data.go.kr/6260000/BusanJobOpnngInfoService/getJobOpnngInfo"
        var serviceKey = "CjHhgoullv8N53RHncSTgoqKKrObdG2H6sAumzGW0VMNLMlqLeATBaiNO8OIjafRyAtUGBGEXTRs9kvJa9jZVA%3D%3D"

        if let decodedServiceKey = serviceKey.removingPercentEncoding {
            serviceKey = decodedServiceKey
        }

        let param: [String: Any] = [
            "serviceKey": serviceKey,
            "numOfRows": "20",
            "pageNo": "\(page)", // 페이지 번호를 인자로 받아 사용
            "resultType": "json"
        ]

        AF.request(url, method: .get, parameters: param).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let welcome = try newJSONDecoder().decode(Welcome.self, from: data)
                    if let newItems = welcome.getJobOpnngInfo?.body?.items?.item {
                        completion(newItems) // 새로운 데이터만 반환
                    }
                } catch {
                    print("Error decoding response: \(error)")
                }
            case .failure(let error):
                print("Request failed with error: \(error)")
            }
        }
    }
}



//func fetchJobOverview() {
//    let url = "http://apis.data.go.kr/6260000/BusanJobOpnngInfoService/getJobOpnngInfo"
//    var serviceKey = "CjHhgoullv8N53RHncSTgoqKKrObdG2H6sAumzGW0VMNLMlqLeATBaiNO8OIjafRyAtUGBGEXTRs9kvJa9jZVA%3D%3D"
//
//    if let decodedServiceKey = serviceKey.removingPercentEncoding {
//        serviceKey = decodedServiceKey
//    }
//
//    let param: [String: Any] = [
//        "serviceKey": serviceKey,
//        "numOfRows": "20",
//        "pageNo": "\(currentPage)", // 현재 페이지 번호 사용
//        "resultType": "json"
//    ]
//    
//    // 데이터 가져오기 시작 전에 액티비티 인디케이터 시작
//    activityIndicator.startAnimating()
//
//
//    AF.request(url, method: .get, parameters: param).responseJSON { response in
//        
//        
//        self.activityIndicator.stopAnimating() // 데이터 가져오기 후 액티비티 인디케이터 중지
//        switch response.result {
//        case .success(let value):
//            do {
//                let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
//                let welcome = try newJSONDecoder().decode(Welcome.self, from: data)
//                if let newItems = welcome.getJobOpnngInfo?.body?.items?.item {
//                    // 새로운 페이지의 데이터를 기존 데이터에 추가
//                    self.jobs += newItems
//                    self.sections = self.createSections(from: self.jobs)
//                    
//                    DispatchQueue.main.async {
//                        self.tableView.reloadData()
//                        
//                        // Extract recruitAgencyName values and add them to the recruitAgencyNames array
//                        let recruitAgencyNameSet: Set<String> = Set(newItems.compactMap { $0.recruitAgencyName })
//                        self.recruitAgencyNames.formUnion(recruitAgencyNameSet)
//
//                                                    
//                                                    // You can print or use recruitAgencyNames as needed
//                        /*print(self.recruitAgencyNames)*/                       }
//                }
//            } catch {
//                print("Error decoding response: \(error)")
//            }
//        case .failure(let error):
//            print("Request failed with error: \(error)")
//
//            if let underlyingError = error.underlyingError {
//                print("Underlying error: \(underlyingError)")
//            }
//
//            if let data = response.data, let str = String(data: data, encoding: .utf8) {
//                print("Server responded with string: \(str)")
//            }
//        }
//    }
//}
