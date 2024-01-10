import Foundation
import Alamofire

class ListViewController: UITableViewController {
    var jobs: [Item] = []
    var originalJobs: [Item] = [] // 검색을 위해 모든 페이지의 데이터를 저장하는 배열
    var dataFetcher = JobDataFetcher()
    var currentPage = 1
    var recruitAgencyNames: Set<String> = []
    var activityIndicator = UIActivityIndicatorView()
    var sections: [Section] = []
    
    
    enum SortType {
        case deadline
        case latest
        case bySection
    }
    
    
    var sortType: SortType = .deadline // 초기 정렬 유형 설정
    
    var deadlineSwitch = UISwitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 커스텀 헤더 뷰 생성
        let headerView = HeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 130))
        headerView.delegate = self
                

        // 테이블 뷰 헤더에 커스텀 헤더 뷰 설정
        tableView.tableHeaderView = headerView
        
        tableView.register(JobListCell.self, forCellReuseIdentifier: "JobListCell")
        
        // 액티비티 인디케이터 설정
        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
        
        dataFetcher.fetchJobOverview(page: currentPage) { [weak self] fetchedJobs in
            guard let self = self else { return }
            
            
            
            
            let filteredJobs = fetchedJobs.filter { job in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let deadline = dateFormatter.date(from: job.reqDateE ?? "") {
                    return deadline > Date()
                } else {
                    return false
                }
            }
            
            self.jobs.append(contentsOf: self.deadlineSwitch.isOn ? filteredJobs : fetchedJobs)
            self.originalJobs.append(contentsOf: fetchedJobs)
            self.createSections(from:self.jobs )
            self.updateSections()
            
            switch self.sortType {
            case .deadline:
                self.jobs = self.sortJobsByDeadline()
            case .latest:
                self.jobs = self.sortJobsByLatest()
            case .bySection:
                self.sections = self.createSections(from: self.jobs)
            }
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        headerView.searchBar.delegate = self
        
    }


        
    
    func scrollToTopIfNeeded() {
        let indexPath = IndexPath(row: 0, section: 0) // 상단 셀의 IndexPath
        if jobs.count > 0 {
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sortType == .bySection ? sections.count : 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortType == .bySection ? sections[section].items.count : jobs.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortType == .bySection ? sections[section].sectionTitle : nil
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "JobListCell", for: indexPath) as! JobListCell
        let job = sortType == .bySection ? sections[indexPath.section].items[indexPath.row] : jobs[indexPath.row]
        cell.configure(with: job)
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let detailViewController = storyboard.instantiateViewController(identifier: "JobDetailViewController") as? JobDetailViewController else { return }
        detailViewController.Job = jobs[indexPath.row]
        show(detailViewController, sender: nil)
    }
    
    
    
    func sortJobsByDeadline() -> [Item] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        return jobs.sorted { (item1, item2) in
            if let date1 = dateFormatter.date(from: item1.reqDateE ?? ""),
               let date2 = dateFormatter.date(from: item2.reqDateE ?? "") {
                return date1 < date2
            } else {
                return false
            }
        }
    }
    
    
    
    func sortJobsByLatest() -> [Item] {
        return jobs.sorted { ($0.regDate ?? "") > ($1.regDate ?? "") }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            currentPage += 1
            dataFetcher.fetchJobOverview(page: currentPage) { [weak self] fetchedJobs in
                guard let self = self else { return }
                var newJobs = fetchedJobs

                // deadlineSwitch가 켜져 있을 경우, 마감일자가 지난 데이터를 제외
                if self.deadlineSwitch.isOn {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    newJobs = newJobs.filter { job in
                        if let deadline = dateFormatter.date(from: job.reqDateE ?? "") {
                            return deadline > Date()
                        } else {
                            return false
                        }
                    }
                }

                // 더 이상 불러올 데이터가 없으면 무한 스크롤을 멈춤
                if newJobs.isEmpty {
                    return
                }

                self.jobs += newJobs
                self.originalJobs += newJobs

                if self.sortType == .bySection {
                    self.sections = self.createSections(from: self.jobs)
                }

                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    
    
    func createSections(from jobs: [Item]) -> [Section] {
        var sections: [Section] = []
        
        for location in LocationManager.shared.locations {
            let filteredJobs = jobs.filter { $0.recruitAgencyName.contains(location.name) }
            if !filteredJobs.isEmpty {
                sections.append(Section(sectionTitle: location.name, items: filteredJobs, latitude: location.latitude, longitude: location.longitude))
            }
        }

        // '기타' 섹션 처리
        let otherJobs = jobs.filter { job in
            !LocationManager.shared.locations.contains(where: { job.recruitAgencyName.contains($0.name) })
        }
        if !otherJobs.isEmpty {
            let defaultLocation = BusanLocation(name: "기타", latitude: 35.0, longitude: 129.0) // 기본 위치 설정
            sections.append(Section(sectionTitle: "기타", items: otherJobs, latitude: defaultLocation.latitude, longitude: defaultLocation.longitude))
        }

        return sections
    }
    
    func updateSections() {
        sections = createSections(from: jobs)
        LocationManager.shared.sections = sections
    }

}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            // 검색창의 텍스트가 비어있을 때는 원본 데이터를 복원
            jobs = originalJobs
        } else {
            // 검색창의 텍스트가 있을 때는 해당 텍스트를 포함하는 데이터만 필터링
            jobs = originalJobs.filter { $0.title.contains(searchText) }
        }

        // deadlineSwitch의 상태에 따라 검색 결과를 필터링
        if deadlineSwitch.isOn {
            jobs = jobs.filter { job in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let deadline = dateFormatter.date(from: job.reqDateE ?? "") {
                    return deadline > Date()
                } else {
                    return false
                }
            }
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.resignFirstResponder() // 키보드 내리기
        }
        
        if sortType == .bySection {
                sections = createSections(from: jobs)
            }

        tableView.reloadData()
    }
}


