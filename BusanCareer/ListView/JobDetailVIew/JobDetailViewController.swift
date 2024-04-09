//
//  JobDetailViewController.swift
//  SeoulCareer
//
//  Created by 김건호 on 10/19/23.
//

import UIKit
import Foundation


class JobDetailViewController : UIViewController {
    
    var job: Item?
    let jobDetailView = JobDetailView()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(jobDetailView)
        configureUI()
    }
    
    
    func configureUI() {
        guard let detail = job else { return }
        jobDetailView.configure(with: detail)
    }
    

}
