//
//  JobDetailView.swift
//  BusanCareer
//
//  Created by 김건호 on 4/9/24.
//

import Foundation
import UIKit

class JobDetailView : UIView {
    
    
    
    let jobTitleLabel = UILabel()
    let agencyNameLabel = UILabel()
    let bunyaLabel = UILabel()
    let endDateLabel = UILabel()
    let reqTypeLabel = UILabel()
    
    
    
    func configure(with job: Item) {
        jobTitleLabel.text = job.title
        agencyNameLabel.text = job.recruitAgencyName
        reqTypeLabel.text = job.reqTypeNm
        endDateLabel.text = job.reqDateE
        bunyaLabel.text = job.bunya?.isEmpty ?? true ? "분야 없음" : job.bunya
    }

    
}
