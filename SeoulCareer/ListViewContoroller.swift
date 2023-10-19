import Foundation
import Alamofire

class ListViewController: UITableViewController {
    var jobs: [Item] = []
    var currentPage = 1 // 현재 페이지 번호

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.register(JobListCell.self, forCellReuseIdentifier: "JobListCell")
        self.fetchJobOverview() // 초기 페이지 로딩
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
        self.show(detailViewController, sender: nil)
    }

    func fetchJobOverview() {
        let url = "http://apis.data.go.kr/6260000/BusanJobOpnngInfoService/getJobOpnngInfo"
        var serviceKey = "CjHhgoullv8N53RHncSTgoqKKrObdG2H6sAumzGW0VMNLMlqLeATBaiNO8OIjafRyAtUGBGEXTRs9kvJa9jZVA%3D%3D"

        if let decodedServiceKey = serviceKey.removingPercentEncoding {
            serviceKey = decodedServiceKey
        }

        let param: [String: Any] = [
            "serviceKey": serviceKey,
            "numOfRows": "20",
            "pageNo": "\(currentPage)", // 현재 페이지 번호 사용
            "resultType": "json"
        ]

        AF.request(url, method: .get, parameters: param).responseJSON { response in
            switch response.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let welcome = try newJSONDecoder().decode(Welcome.self, from: data)
                    if let newItems = welcome.getJobOpnngInfo?.body?.items?.item {
                        // 새로운 페이지의 데이터를 기존 데이터에 추가
                        self.jobs += newItems
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                } catch {
                    print("Error decoding response: \(error)")
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

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            // 사용자가 스크롤을 마지막까지 내린 경우
            currentPage += 1
            fetchJobOverview() // 다음 페이지를 요청
        }
    }
}
