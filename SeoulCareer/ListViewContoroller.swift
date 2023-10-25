import Foundation
import Alamofire

class ListViewController: UITableViewController {
    var jobs: [Item] = []
    var currentPage = 1
    var recruitAgencyNames: Set<String> = []
    var sortByDeadline = true

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(JobListCell.self, forCellReuseIdentifier: "JobListCell")
        fetchJobOverview()
    }
    
        override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
            headerView.backgroundColor = UIColor.white

            let sortButton = UIButton(type: .system)
            sortButton.setTitle("마감일자순", for: .normal)
            sortButton.frame = CGRect(x: 20, y: 7, width: 120, height: 30)
            sortButton.layer.cornerRadius = 15
            sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
            headerView.addSubview(sortButton)

            let latestButton = UIButton(type: .system)
            latestButton.setTitle("최신순", for: .normal)
            latestButton.frame = CGRect(x: 160, y: 7, width: 100, height: 30)
            latestButton.addTarget(self, action: #selector(latestButtonTapped), for: .touchUpInside)
            latestButton.layer.cornerRadius = 15
            headerView.addSubview(latestButton)
    
            return headerView
        }
    
        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44.0
        }



    @objc func sortButtonTapped() {
        if !sortByDeadline {
            sortByDeadline = true
            // Reload the table view with the sorting criteria
            jobs = sortJobsByDeadline()
            tableView.reloadData()
            scrollToTopIfNeeded()
        } else {
            scrollToTopIfNeeded()
        }
    }

    @objc func latestButtonTapped() {
        if sortByDeadline {
            sortByDeadline = false
            // Reload the table view with the sorting criteria
            jobs = sortJobsByLatest()
            tableView.reloadData()
            scrollToTopIfNeeded()
        } else {
            scrollToTopIfNeeded()
        }
    }
    
    func scrollToTopIfNeeded() {
        let indexPath = IndexPath(row: 0, section: 0) // 상단 셀의 IndexPath
        if jobs.count > 0 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
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
        show(detailViewController, sender: nil)
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
                            
                            // Extract recruitAgencyName values and add them to the recruitAgencyNames array
                            let recruitAgencyNameSet: Set<String> = Set(newItems.compactMap { $0.recruitAgencyName })
                            self.recruitAgencyNames.formUnion(recruitAgencyNameSet)

                                                        
                                                        // You can print or use recruitAgencyNames as needed
                            print(self.recruitAgencyNames)                       }
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

    func sortJobsByDeadline() -> [Item] {
        return jobs.sorted { ($0.reqDateS ?? "") < ($1.reqDateS ?? "") }
    }

    func sortJobsByLatest() -> [Item] {
        return jobs.sorted { ($0.regDate ?? "") > ($1.regDate ?? "") }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            currentPage += 1
            fetchJobOverview()
        }
    }
}
