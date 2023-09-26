//
//  ListViewContoroller.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/19.
//

import Foundation
import Alamofire

class ListViewController : UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.fetchJobOverview(completionHandler: {[weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(result):
                debugPrint("success \(result)")
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    
    
    
    
    func fetchJobOverview(
        completionHandler : @escaping (Result <Items, Error>) -> Void
    ){
        let url = "http://apis.data.go.kr/6260000/BusanJobOpnngInfoService/getJobOpnngInfo"
        let param = [
            "serviceKey" : "CjHhgoullv8N53RHncSTgoqKKrObdG2H6sAumzGW0VMNLMlqLeATBaiNO8OIjafRyAtUGBGEXTRs9kvJa9jZVA%3D%3D",
            "numOfRows" : "10",
            "pageNo" : "1",
            "resultType" : "json"
        ]
        
        AF.request(url,method: .get,parameters: param)
            .responseData( completionHandler: { response in
                switch response.result{
                case let .success(data) :
                    do {
                        let decoder = JSONDecoder()
                        let result = try decoder.decode(Items.self, from: data)
                        completionHandler(.success(result))
                    } catch{
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
    
}
