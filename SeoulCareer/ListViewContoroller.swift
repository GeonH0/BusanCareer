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

    override func viewDidLoad() {
        super.viewDidLoad()

        // 커스텀 헤더 뷰 생성
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 88))
        

        // UISearchBar 인스턴스 생성
        let searchBar = UISearchBar()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "공고를 검색해 보세요!"
        headerView.addSubview(searchBar)

        // 검색창 Auto Layout 설정
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: headerView.topAnchor)
        ])

        // 첫 번째 버튼 생성
        let sortButton = UIButton(type: .system)
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.setTitle("마감일자순", for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        headerView.addSubview(sortButton)

        // 두 번째 버튼 생성
        let latestButton = UIButton(type: .system)
        latestButton.translatesAutoresizingMaskIntoConstraints = false
        latestButton.setTitle("최신순", for: .normal)
        latestButton.addTarget(self, action: #selector(latestButtonTapped), for: .touchUpInside)
        headerView.addSubview(latestButton)

        // 세 번째 버튼 생성
        let sectionButton = UIButton(type: .system)
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        sectionButton.setTitle("구역별", for: .normal)
        sectionButton.addTarget(self, action: #selector(sectionButtonTapped), for: .touchUpInside)
        headerView.addSubview(sectionButton)

        
        // 버튼 Auto Layout 설정
        NSLayoutConstraint.activate([
            sortButton.leadingAnchor.constraint(equalTo: headerView.leadingAnchor),
            sortButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            sortButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1/3),

            latestButton.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor),
            latestButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            latestButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1/3),

            sectionButton.leadingAnchor.constraint(equalTo: latestButton.trailingAnchor),
            sectionButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            sectionButton.widthAnchor.constraint(equalTo: headerView.widthAnchor, multiplier: 1/3),
            sectionButton.trailingAnchor.constraint(equalTo: headerView.trailingAnchor),
            sectionButton.bottomAnchor.constraint(equalTo: headerView.bottomAnchor)
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
            self.jobs = fetchedJobs
            self.originalJobs = fetchedJobs
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
           // Define the list of target areas
           let targetAreas = [
               "중구", "서구", "동구", "영도구", "부산진구", "동래구", "남구", "북구",
               "해운대구", "사하구", "금정구", "강서구", "연제구", "수영구", "사상구", "기장"
           ]
       
           var sections: [Section] = []
           var otherSection: Section?
       

        // Initialize otherSection for jobs not in the target areas
        otherSection = Section(sectionTitle: "기타", items: [])

       
        for job in jobs {
            if targetAreas.contains(where: { job.recruitAgencyName.range(of: $0, options: .caseInsensitive) != nil }) {
                // Find the matching section and add the job to it
                if let sectionIndex = sections.firstIndex(where: { $0.sectionTitle == job.recruitAgencyName }) {
                    sections[sectionIndex].items.append(job)
                    
                } else {
                    sections.append(Section(sectionTitle: job.recruitAgencyName ?? "", items: [job]))
                    
                }
            } else {
                // Add the job to the "기타" section
                otherSection?.items.append(job)
                print("Job with recruitAgencyName '\(job.recruitAgencyName ?? "nil")' goes to '기타' section.")
            }
        }


       
           
           sections = sections.filter { !$0.items.isEmpty }
           if let otherSection = otherSection, !otherSection.items.isEmpty {
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
        tableView.reloadData()
    }
}

