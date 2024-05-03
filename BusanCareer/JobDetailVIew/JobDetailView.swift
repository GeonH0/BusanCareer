//
//  JobDetailView.swift
//  BusanCareer
//
//  Created by 김건호 on 4/9/24.
//


import UIKit

class JobDetailView: UIView {
    
    private let jobTitleLabel = UILabel()
    private let agencyNameLabel = UILabel()
    private let bunyaLabel = UILabel()
    private let endDateLabel = UILabel()
    private let reqTypeLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        addSubview(jobTitleLabel)
        addSubview(agencyNameLabel)
        addSubview(bunyaLabel)
        addSubview(endDateLabel)
        addSubview(reqTypeLabel)

        jobTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        agencyNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bunyaLabel.translatesAutoresizingMaskIntoConstraints = false
        endDateLabel.translatesAutoresizingMaskIntoConstraints = false
        reqTypeLabel.translatesAutoresizingMaskIntoConstraints = false

        setupLayout()
    }

    private func setupLayout() {
        NSLayoutConstraint.activate([
            jobTitleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            jobTitleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            jobTitleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            agencyNameLabel.topAnchor.constraint(equalTo: jobTitleLabel.bottomAnchor, constant: 10),
            agencyNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            agencyNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            reqTypeLabel.topAnchor.constraint(equalTo: agencyNameLabel.bottomAnchor, constant: 10),
            reqTypeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            reqTypeLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            endDateLabel.topAnchor.constraint(equalTo: reqTypeLabel.bottomAnchor, constant: 10),
            endDateLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            endDateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            bunyaLabel.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 10),
            bunyaLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            bunyaLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
            bunyaLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20)
        ])
    }
    
    func configure(with job: JobItem) {
        jobTitleLabel.text = job.title
        agencyNameLabel.text = job.recruitAgencyName
        reqTypeLabel.text = job.reqTypeNm
        endDateLabel.text = job.reqDateE
        bunyaLabel.text = job.bunya?.isEmpty ?? true ? "분야 없음" : job.bunya
    }
}

