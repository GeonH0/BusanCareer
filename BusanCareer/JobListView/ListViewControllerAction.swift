//
//  ListViewControllerAction.swift
//  SeoulCareer
//
//  Created by 김건호 on 11/15/23.
//
import UIKit


extension JobListViewController: JobListHeaderViewDelegate {
    
    func sortButtonTapped() {
        if sortType != .deadline {
            sortType = .deadline
            jobs = sortJobsByDeadline()
            tableView.reloadData()
            scrollToTopIfNeeded()
        } else {
            scrollToTopIfNeeded()
        }
    }
    
    func latestButtonTapped() {
        if sortType != .latest {
            sortType = .latest
            jobs = sortJobsByLatest()
            tableView.reloadData()
            scrollToTopIfNeeded()
        } else {
            scrollToTopIfNeeded()
        }
    }
    
    func sectionButtonTapped() {
        if sortType != .bySection {
            sortType = .bySection
            sections = createSections(from: jobs)
            tableView.reloadData()
            scrollToTopIfNeeded()
        } else {
            scrollToTopIfNeeded()
        }
    }
    
    func deadlineSwitchChanged(isOn: Bool) {
        if isOn {
            jobs = originalJobs.filter { job in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd"
                return dateFormatter.date(from: job.reqDateE ?? "") ?? Date() > Date()
            }
        } else {
            jobs = originalJobs
        }
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
    
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
}
