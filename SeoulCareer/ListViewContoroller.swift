import Foundation
import Alamofire

class ListViewController: UITableViewController {
    var jobs: [Item] = []
    var currentPage = 1
    var recruitAgencyNames: Set<String> = []
    var activityIndicator = UIActivityIndicatorView()
    var sections: [Section] = []

    
    enum SortType {
        case deadline
        case latest
        case bySection
    }
    
    struct Section {
        var sectionTitle: String
        var items: [Item]
    }

    var sortType: SortType = .deadline // 초기 정렬 유형 설정

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(JobListCell.self, forCellReuseIdentifier: "JobListCell")
        // 액티비티 인디케이터 설정
        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)

        fetchJobOverview()
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].sectionTitle
    }
    

    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.size.width, height: 44))
        headerView.backgroundColor = UIColor.white

        let buttonWidth: CGFloat = 100 // 버튼의 폭
        let buttonHeight: CGFloat = 30 // 버튼의 높이
        let buttonSpacing: CGFloat = 10 // 버튼 간격

        let totalButtonWidth = (buttonWidth * 3) + (buttonSpacing * 2) // 버튼 3개와 간격의 총 폭

        // 첫 번째 버튼
        let sortButton = UIButton(type: .system)
        sortButton.setTitle("마감일자순", for: .normal)
        sortButton.frame = CGRect(x: (tableView.frame.size.width - totalButtonWidth) / 2, y: 7, width: buttonWidth, height: buttonHeight)
        sortButton.layer.cornerRadius = 15
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        headerView.addSubview(sortButton)

        // 두 번째 버튼
        let latestButton = UIButton(type: .system)
        latestButton.setTitle("최신순", for: .normal)
        latestButton.frame = CGRect(x: sortButton.frame.maxX + buttonSpacing, y: 7, width: buttonWidth, height: buttonHeight)
        latestButton.layer.cornerRadius = 15
        latestButton.addTarget(self, action: #selector(latestButtonTapped), for: .touchUpInside)
        headerView.addSubview(latestButton)

        // 세 번째 버튼
        let sectionButton = UIButton(type: .system)
        sectionButton.setTitle("구역별", for: .normal)
        sectionButton.frame = CGRect(x: latestButton.frame.maxX + buttonSpacing, y: 7, width: buttonWidth, height: buttonHeight)
        sectionButton.addTarget(self, action: #selector(sectionButtonTapped), for: .touchUpInside)
        sectionButton.layer.cornerRadius = 15
        headerView.addSubview(sectionButton)

        return headerView
    }


    
        override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 44.0
        }



    @objc func sortButtonTapped() {
        if sortType != .deadline {
            sortType = .deadline
            // Reload the table view with the sorting criteria
            jobs = sortJobsByDeadline()
            tableView.reloadData()
            scrollToTopIfNeeded()
        } else {
            scrollToTopIfNeeded()
        }
    }

    @objc func latestButtonTapped() {
        if sortType != .latest {
            sortType = .latest
            // Reload the table view with the sorting criteria
            jobs = sortJobsByLatest()
            tableView.reloadData()
            scrollToTopIfNeeded()
        } else {
            scrollToTopIfNeeded()
        }
    }
    
    @objc func sectionButtonTapped() {
        if sortType != .bySection {
            sortType = .bySection
            sections = createSections(from: jobs) // 데이터를 구역별로 정렬하고 sections 배열에 할당
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
        
        // 데이터 가져오기 시작 전에 액티비티 인디케이터 시작
        activityIndicator.startAnimating()


        AF.request(url, method: .get, parameters: param).responseJSON { response in
            
            
            self.activityIndicator.stopAnimating() // 데이터 가져오기 후 액티비티 인디케이터 중지
            switch response.result {
            case .success(let value):
                do {
                    let data = try JSONSerialization.data(withJSONObject: value, options: .prettyPrinted)
                    let welcome = try newJSONDecoder().decode(Welcome.self, from: data)
                    if let newItems = welcome.getJobOpnngInfo?.body?.items?.item {
                        // 새로운 페이지의 데이터를 기존 데이터에 추가
                        self.jobs += newItems
                        self.sections = self.createSections(from: self.jobs)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            
                            // Extract recruitAgencyName values and add them to the recruitAgencyNames array
                            let recruitAgencyNameSet: Set<String> = Set(newItems.compactMap { $0.recruitAgencyName })
                            self.recruitAgencyNames.formUnion(recruitAgencyNameSet)

                                                        
                                                        // You can print or use recruitAgencyNames as needed
                            /*print(self.recruitAgencyNames)*/                       }
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
    
    func createSections(from jobs: [Item]) -> [Section] {
           // Define the list of target areas
           let targetAreas = [
               "중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구",
               "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장군"
           ]
       
           var sections: [Section] = []
           var otherSection: Section?
       
           // Initialize otherSection for jobs not in the target areas
           otherSection = Section(sectionTitle: "기타", items: [])
       
        for job in jobs {
            if targetAreas.contains(job.recruitAgencyName ?? "") {
                // Find the matching section and add the job to it
                if let sectionIndex = sections.firstIndex(where: { $0.sectionTitle == job.recruitAgencyName }) {
                    sections[sectionIndex].items.append(job)
                    
                } else {
                    sections.append(Section(sectionTitle: job.recruitAgencyName, items: [job]))
                }
            } else {
                // Add the job to the "기타" section
                otherSection?.items.append(job)
                print("Job with recruitAgencyName '\(job.recruitAgencyName ?? "nil")' goes to '기타' section.")
            }
        }


       
           // Filter out empty sections and add the "기타" section if it contains items
           sections = sections.filter { !$0.items.isEmpty }
           if let otherSection = otherSection, !otherSection.items.isEmpty {
               sections.append(otherSection)
           }
       
           return sections
       }
}
