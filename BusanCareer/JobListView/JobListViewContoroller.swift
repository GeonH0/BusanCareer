import Alamofire

class JobListViewController: UITableViewController {
    
    private let activityIndicator = UIActivityIndicatorView()
    private let deadlineSwitch = UISwitch()
    
    var currentPage = 1
    var jobs: [JobItem] = []
    var originalJobs: [JobItem] = []
    var sections: [Section] = []
    var sortType: SortType = .deadline
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let headerView = JobListHeaderView(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 130))
        headerView.delegate = self
        
        tableView.tableHeaderView = headerView
        tableView.register(JobListCell.self, forCellReuseIdentifier: "JobListCell")
        
        activityIndicator.style = .large
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        view.addSubview(activityIndicator)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tap)
                
        JobDataFetcher.fetchJobOverview(page: currentPage) { [weak self] fetchedJobs in
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
        let indexPath = IndexPath(row: 0, section: 0)
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
        let detailViewController = JobDetailViewController()
           detailViewController.job = jobs[indexPath.row]
           navigationController?.pushViewController(detailViewController, animated: true)
    }
    
    func sortJobsByDeadline() -> [JobItem] {
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
    
    func sortJobsByLatest() -> [JobItem] {
        return jobs.sorted { ($0.regDate ?? "") > ($1.regDate ?? "") }
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        if offsetY > contentHeight - scrollView.frame.size.height {
            currentPage += 1
            JobDataFetcher.fetchJobOverview(page: currentPage) { [weak self] fetchedJobs in
                guard let self = self else { return }
                var newJobs = fetchedJobs
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

    
    
    
    func createSections(from jobs: [JobItem]) -> [Section] {
        var sections: [Section] = []
        
        for location in LocationManager.shared.locations {
            let filteredJobs = jobs.filter { $0.recruitAgencyName.contains(location.name) }
            if !filteredJobs.isEmpty {
                sections.append(Section(sectionTitle: location.name, items: filteredJobs, latitude: location.latitude, longitude: location.longitude))
            }
        }
        
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

extension JobListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            jobs = originalJobs
        } else {
            jobs = originalJobs.filter { $0.title.contains(searchText) }
        }

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
            searchBar.resignFirstResponder() 
        }
        
        if sortType == .bySection {
                sections = createSections(from: jobs)
            }

        tableView.reloadData()
    }
}


