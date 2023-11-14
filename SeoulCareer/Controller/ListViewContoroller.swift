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
    
    struct Section {
        var sectionTitle: String
        var items: [Item]
    }
    
    var sortType: SortType = .deadline // 초기 정렬 유형 설정
    
    var deadlineSwitch = UISwitch()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 커스텀 헤더 뷰 생성
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 130))
        
        // 레이블 인스턴스 생성
        let switchLabel = UILabel()
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.text = "마감일자 제외하기"
        switchLabel.textAlignment = .center
        headerView.addSubview(switchLabel)

        
        // UISwitch 인스턴스 생성
        deadlineSwitch = UISwitch()
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        deadlineSwitch.addTarget(self, action: #selector(deadlineSwitchChanged), for: .valueChanged)
        headerView.addSubview(deadlineSwitch)

        // UISearchBar 인스턴스 생성
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "공고를 검색해 보세요!"
        headerView.addSubview(searchBar)

        // 버튼 생성
        let sortButton = ButtonFactory.createButton(title: "마감일자순", target: self, action: #selector(sortButtonTapped))
        let latestButton = ButtonFactory.createButton(title: "최신순", target: self, action: #selector(latestButtonTapped))
        let sectionButton = ButtonFactory.createButton(title: "구역별", target: self, action: #selector(sectionButtonTapped))
        
        // Add buttons to headerView
        headerView.addSubview(sortButton)
        headerView.addSubview(latestButton)
        headerView.addSubview(sectionButton)

        // Auto Layout 설정
        NSLayoutConstraint.activate([
            switchLabel.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 10),
            switchLabel.trailingAnchor.constraint(equalTo: deadlineSwitch.leadingAnchor, constant: -10),

            deadlineSwitch.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),
            deadlineSwitch.trailingAnchor.constraint(equalTo: headerView.trailingAnchor, constant: -20),

            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: 10),
            
            sortButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            sortButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            sortButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1/3),
            
            latestButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            latestButton.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor),
            latestButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1/3),
            
            sectionButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            sectionButton.leadingAnchor.constraint(equalTo: latestButton.trailingAnchor),
            sectionButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            sectionButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1/3),
        ])

        // 테이블 뷰 헤더에 커스텀 헤더 뷰 설정
        tableView.tableHeaderView = headerView
        
        tableView.register(JobListCell.self, forCellReuseIdentifier: "JobListCell")
        
        // 액티비티 인디케이터 설정
        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
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

        
        searchBar.delegate = self
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
    @objc func deadlineSwitchChanged(_ sender: UISwitch) {
        if sender.isOn {
            // 스위치가 켜져 있으면, 마감일자가 지나지 않은 셀만 보여줍니다.
            jobs = originalJobs.filter { job in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                if let deadline = dateFormatter.date(from: job.reqDateE ?? "") {
                    return deadline > Date()
                } else {
                    return false
                }
            }
        } else {
            // 스위치가 꺼져 있으면, 모든 셀을 보여줍니다.
            jobs = originalJobs
        }

        // 현재 정렬 상태에 따라 다시 정렬합니다.
        switch sortType {
        case .deadline:
            jobs = sortJobsByDeadline()
        case .latest:
            jobs = sortJobsByLatest()
        case .bySection:
            sections = createSections(from: jobs)
        }

        tableView.reloadData()
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
                self.jobs += fetchedJobs
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    
    
    func createSections(from jobs: [Item]) -> [Section] {
        let targetAreas = [
            "시청",
            "중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구",
            "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장"
        ]
        
        var sections: [Section] = targetAreas.map { Section(sectionTitle: $0, items: []) }
        var otherSection = Section(sectionTitle: "기타", items: [])
        
        for job in jobs {
            if let targetArea = targetAreas.first(where: { job.recruitAgencyName.contains($0) }) {
                if let sectionIndex = sections.firstIndex(where: { $0.sectionTitle == targetArea }) {
                    sections[sectionIndex].items.append(job)
                    
                }
            } else {
                otherSection.items.append(job)
                print("Job with recruitAgencyName '\(job.recruitAgencyName )' goes to '기타' section.")
            }
        }
        
        sections = sections.filter { !$0.items.isEmpty }
        if !otherSection.items.isEmpty {
            sections.append(otherSection)
        }
        
        
        return sections
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

        tableView.reloadData()
    }
}


