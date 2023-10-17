import Foundation
import Alamofire

class ListViewController : UITableViewController {
    
    var jobs: [JobInfo] = [] // JobOpnngInfoResponse 대신 JobInfo를 사용합니다.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TableView에 Cell을 등록합니다.
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        self.fetchJobOverview(completionHandler: {[weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(result):
                // 네트워크 요청이 끝나면 메인 스레드에서 UI를 업데이트합니다.
                DispatchQueue.main.async {
                    self.jobs = result
                    self.tableView.reloadData()
                }
                
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count // 셀 개수 설정
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let job = jobs[indexPath.row]
        
        // cell 설정 (job 객체 내부의 프로퍼티에 따라 달라집니다.)
        cell.textLabel?.text = job.title
        
        return cell
    }
    
    func fetchJobOverview(
       completionHandler : @escaping (Result <[JobInfo], Error>) -> Void  // [JobInfo] 배열을 반환하도록 변경합니다.
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
                       let resultResponse = try decoder.decode(JobOpnngInfoResponse.self, from: data)
                       if let jobInfosArray = resultResponse.getJobOpnngInfo.body?.items?.item{
                           completionHandler(.success(jobInfosArray))
                       } else {
                           throw NSError(domain:"", code:-1, userInfo:[ NSLocalizedDescriptionKey:"Parsing error"])
                       }
                   } catch{
                       completionHandler(.failure(error))
                   }
               case let .failure(error):
                   completionHandler(.failure(error))
               }
           })
   }
}
