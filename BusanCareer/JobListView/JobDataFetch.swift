//
//  JobDataFetch.swift
//  SeoulCareer
//
//  Created by 김건호 on 11/10/23.
//


import Alamofire

class JobDataFetcher {

    static func fetchJobOverview(page: Int, completion: @escaping ([JobItem]) -> Void) {
        let url = "http://apis.data.go.kr/6260000/BusanJobOpnngInfoService/getJobOpnngInfo"
        guard let key = Bundle.main.object(forInfoDictionaryKey: "serviceKey") as? String else { return }
        var serviceKey = key
        
        if let decodedServiceKey = serviceKey.removingPercentEncoding {
            serviceKey = decodedServiceKey
        }

        let param: [String: Any] = [
            "serviceKey": serviceKey,
            "numOfRows": "20",
            "pageNo": "\(page)",
            "resultType": "json"
        ]

        AF.request(url, method: .get, parameters: param).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let welcome = try newJSONDecoder().decode(Welcome.self, from: data)
                    if let newItems = welcome.getJobOpnngInfo?.body?.items?.item {
                        completion(newItems)
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
