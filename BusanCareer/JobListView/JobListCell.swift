//
//  JobListCell.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/19.
//

import UIKit
import SnapKit

class JobListCell: UITableViewCell {

    let TitleLabel = UILabel()
    let AgencyNameLabel = UILabel()
    let EndLabel = UILabel()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        [TitleLabel,AgencyNameLabel,EndLabel].forEach{
            contentView.addSubview($0)
        }
        
        
        TitleLabel.font = .systemFont(ofSize: 18,weight: .bold)
        TitleLabel.numberOfLines = 2
        
        AgencyNameLabel.font = .systemFont(ofSize: 14, weight: .light)
        AgencyNameLabel.textColor  = .systemBlue
        AgencyNameLabel.numberOfLines = 0
        
        EndLabel.font = .systemFont(ofSize: 14, weight: .light)
        EndLabel.textColor  = .systemRed
        EndLabel.numberOfLines = 0
                
        TitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.leading.trailing.equalToSuperview().inset(20)
        }

        AgencyNameLabel.snp.makeConstraints {
            $0.top.equalTo(TitleLabel.snp.bottom).offset(5)
            $0.leading.equalTo(TitleLabel)
            $0.trailing.equalTo(EndLabel.snp.leading).offset(-10)
            $0.bottom.lessThanOrEqualToSuperview().offset(-10)
        }

        EndLabel.snp.makeConstraints{
            $0.top.equalTo(AgencyNameLabel)
            $0.leading.equalTo(AgencyNameLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20)
            $0.bottom.lessThanOrEqualToSuperview().offset(-10)
        }
    }
    
    func configure(with job: JobItem) {
        TitleLabel.text = job.title ?? "제목 없음"
        AgencyNameLabel.text = job.recruitAgencyName ?? "정보 없음"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"

        if let reqDateE = job.reqDateE, let endDate = dateFormatter.date(from: reqDateE), endDate < Date() {
            EndLabel.text = "마감된 공고"
        } else {
            EndLabel.text = ""
        }
    }


    
    
    
}
