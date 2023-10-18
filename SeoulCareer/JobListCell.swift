//
//  JobListCell.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/19.
//

import UIKit

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
    }
    
    TitleLabel.snp.makeConstraints {
        $0.leading.equalTo(beerImageView.snp.trailing).offset(10)
        $0.bottom.equalTo(beerImageView.snp.centerY)
        $0.trailing.equalToSuperview().inset(20)
    }
    AgencyNameLabel.snp.makeConstraints {
        $0.leading.trailing.equalTo(nameLabel)
        $0.top.equalTo(nameLabel.snp.bottom).offset(5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    func configure(with job: Item ){
        
        
        
        
        TitleLabel.text = job.title ?? "제목 없음"
        AgencyNameLabel.text = job.recruitAgencyName ?? "정보 없음"
        
        
        accessoryType = .disclosureIndicator //cell에 꺽새모양 추가
        selectionStyle = .none //탭할경우 음영이 발생 하지 않는다.
    }
    
}
