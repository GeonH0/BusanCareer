import Foundation
import Alamofire



class ListViewController : UITableViewController {
    
    var jobs: [Item] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(JobListCell.self, forCellReuseIdentifier: "JobListCell")
        
        self.fetchJobOverview(completionHandler: {[weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(result):
                DispatchQueue.main.async {
                    if let items = result {
                        self.jobs = items
                        self.tableView.reloadData()
                    }
                }
                
            case let .failure(error):
                debugPrint("error \(error)")
            }
        })
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return jobs.count
    }
    
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobListCell", for: indexPath) as! JobListCell
        
            let job = jobs[indexPath.row]
        
            cell.configure(with: job)
         return cell
     }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "JobDetailViewController") as? JobDetailViewController else { return }
        
        detailViewController.Job = jobs[indexPath.row]
        self.show(detailViewController,sender: nil)
        
        
        
        
        
    }

     func fetchJobOverview(
          completionHandler : @escaping (Result <[Item]?, Error>) -> Void
      ){
          let url = "http://apis.data.go.kr/6260000/BusanJobOpnngInfoService/getJobOpnngInfo"
          
          var serviceKey = "CjHhgoullv8N53RHncSTgoqKKrObdG2H6sAumzGW0VMNLMlqLeATBaiNO8OIjafRyAtUGBGEXTRs9kvJa9jZVA%3D%3D"
          if let decodedServiceKey = serviceKey.removingPercentEncoding {
              serviceKey = decodedServiceKey
          }

          let param : [String : Any]  =
              ["serviceKey" : serviceKey,
               "numOfRows" : "30",
               "pageNo" : "1",
               "resultType" : "json"]
          
          
          AF.request(url ,method:.get ,parameters:param ).responseJSON{ response in
              switch response.result {
              case .success(let value):
                  do {
                      let data = try JSONSerialization.data(withJSONObject:value, options:.prettyPrinted)
                      let welcome = try newJSONDecoder().decode(Welcome.self, from: data)
                      completionHandler(.success(welcome.getJobOpnngInfo?.body?.items?.item))
                  } catch {
                      completionHandler(.failure(error))
                  }
              case .failure(let error):
                  print("Request failed with error: \(error)")

                  if let underlyingError = error.underlyingError {
                      print("Underlying error: \(underlyingError)")
                  }

                  if let data = response.data, let str = String(data: data, encoding: .utf8) {
                      print("Server responded with string: \(str)")
                  }
              }
          }



      }
}
