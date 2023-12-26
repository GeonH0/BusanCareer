//
//  ListViewControllerAction.swift
//  SeoulCareer
//
//  Created by 김건호 on 11/15/23.
//

import Foundation
import UIKit

extension ListViewController : HeaderViewDelegate {
    

    
    
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
    
    
    
    
    
    func deadlineSwitchChanged(isOn: Bool) {
            if isOn {
                // 스위치가 켜져 있으면, 마감일자가 지나지 않은 셀만 보여줍니다.
                jobs = originalJobs.filter { job in
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "yyyy-MM-dd"
                    return dateFormatter.date(from: job.reqDateE ?? "") ?? Date() > Date()
                }
            } else {
                // 스위치가 꺼져 있으면, 모든 셀을 보여줍니다.
                jobs = originalJobs
            }

            // 정렬 상태에 따라 재정렬
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
