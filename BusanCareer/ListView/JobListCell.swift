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
            $0.top.equalToSuperview().offset(10) // 상단 여백 10
            $0.leading.trailing.equalToSuperview().inset(20) // 좌우 여백 20
        }

        AgencyNameLabel.snp.makeConstraints {
            $0.top.equalTo(TitleLabel.snp.bottom).offset(5) // TitleLabel 아래로 5 위치
            $0.leading.equalTo(TitleLabel) // 좌우는 TitleLable과 동일하게 설정
            $0.trailing.equalTo(EndLabel.snp.leading).offset(-10) // 오른쪽을 EndLabel로부터 10만큼 떨어뜨림
            $0.bottom.lessThanOrEqualToSuperview().offset(-10) // 하단 여백 최대 10 (내용에 따라 셀 크기가 유동적으로 변하도록)
        }

        EndLabel.snp.makeConstraints{
            $0.top.equalTo(AgencyNameLabel)
            $0.leading.equalTo(AgencyNameLabel.snp.trailing).offset(10)
            $0.trailing.equalToSuperview().inset(20) // 좌우 여백 20
            $0.bottom.lessThanOrEqualToSuperview().offset(-10) // 하단 여백 최대 10 (내용에 따라 셀 크기가 유동적으로 변하도록))
        }



    }
    
    func configure(with job: JobItem) {
        TitleLabel.text = job.title ?? "제목 없음"
        AgencyNameLabel.text = job.recruitAgencyName ?? "정보 없음"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd" // 사용자님의 날짜 형식에 맞게 변경해주세요.

        if let reqDateE = job.reqDateE, let endDate = dateFormatter.date(from: reqDateE), endDate < Date() {
            EndLabel.text = "마감된 공고"
        } else {
            EndLabel.text = ""
        }
    }


    
    
    
}
