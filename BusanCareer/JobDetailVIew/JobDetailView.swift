//
//  JobDetailView.swift
//  BusanCareer
//
//  Created by 김건호 on 4/9/24.
//


import UIKit

class JobDetailView: UIView {
    
    private let jobTitleLabel = UILabel()
    private let stackView = UIStackView()
    private let agencyNameLabel = UILabel()
    private let bunyaLabel = UILabel()
    private let endDateLabel = UILabel()
    private let reqTypeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupLabels()
        setupStackView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupLabels() {
        jobTitleLabel.text = "Job Title"
        agencyNameLabel.text = "Agency Name"
        bunyaLabel.text = "Field"
        endDateLabel.text = "End Date"
        reqTypeLabel.text = "Requirement Type"

        [jobTitleLabel, agencyNameLabel, bunyaLabel, endDateLabel, reqTypeLabel].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.textAlignment = .center
        }
        
        jobTitleLabel.numberOfLines = 2
        
    }


    private func setupStackView() {
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.alignment = .leading
        stackView.spacing = 5
        
        [agencyNameLabel, reqTypeLabel, endDateLabel, bunyaLabel].forEach {
            stackView.addArrangedSubview($0)
            $0.heightAnchor.constraint(equalToConstant: 40).isActive = true
        }

        addSubview(jobTitleLabel)
        addSubview(stackView)
        
        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            jobTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 40),
            jobTitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            jobTitleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: self.leadingAnchor, constant: 20),
            jobTitleLabel.trailingAnchor.constraint(lessThanOrEqualTo: self.trailingAnchor, constant: -20),
            jobTitleLabel.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -20),
            
            stackView.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            stackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -150)
        ])
    }
    
    func configure(with job: JobItem) {
        jobTitleLabel.text = "공고: " + job.title
        agencyNameLabel.text = "모집기관: " + job.recruitAgencyName
        reqTypeLabel.text = "접수 방법: " + (job.reqTypeNm ?? "정보 없음")
        endDateLabel.text = "마감일: " + (job.reqDateE ?? "정보 없음")
        bunyaLabel.text = "모집 분야: " + ((job.bunya?.isEmpty ?? true ? "분야 없음" : job.bunya) ?? "정보 없음")
    }
}
