//
//  JobDetailViewController.swift
//  SeoulCareer
//
//  Created by 김건호 on 10/19/23.
//

import UIKit
import Foundation

class JobDetailViewController: UIViewController {
    
    var job: JobItem?
    let jobDetailView = JobDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(jobDetailView)
        
        // Auto Layout 설정
        jobDetailView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            jobDetailView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            jobDetailView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            jobDetailView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            jobDetailView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
        
        
        configureUI()
        
        
    }
    
    func configureUI() {
        guard let detail = job else { return }
        jobDetailView.configure(with: detail)
    }
}

