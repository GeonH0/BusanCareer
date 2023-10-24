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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        [TitleLabel,AgencyNameLabel].forEach{
            contentView.addSubview($0)
        }
        
        
        TitleLabel.font = .systemFont(ofSize: 18,weight: .bold)
        TitleLabel.numberOfLines = 2
        
        AgencyNameLabel.font = .systemFont(ofSize: 14, weight: .light)
        AgencyNameLabel.textColor  = .systemBlue
        AgencyNameLabel.numberOfLines = 0
        
        
        TitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10) // 상단 여백 10
            $0.leading.trailing.equalToSuperview().inset(20) // 좌우 여백 20
        }

        AgencyNameLabel.snp.makeConstraints {
            $0.top.equalTo(TitleLabel.snp.bottom).offset(5) // TitleLabel 아래로 5 위치
            $0.leading.trailing.equalTo(TitleLabel) // 좌우는 TitleLable과 동일하게 설정
            $0.bottom.lessThanOrEqualToSuperview().offset(-10) // 하단 여백 최대 10 (내용에 따라 셀 크기가 유동적으로 변하도록)
        }


    }
    

    
    
    func configure(with job: Item ){
        
        
        
        
        TitleLabel.text = job.title ?? "제목 없음"
        AgencyNameLabel.text = job.recruitAgencyName ?? "정보 없음"
        
        
        accessoryType = .disclosureIndicator //cell에 꺽새모양 추가
        selectionStyle = .none //탭할경우 음영이 발생 하지 않는다.
    }
    
    
    
}
