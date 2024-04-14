//
//  HeaderView.swift
//  BusanCareer
//
//  Created by 김건호 on 12/20/23.
//

import UIKit

protocol HeaderViewDelegate : AnyObject {
    func sortButtonTapped()
    func latestButtonTapped()
    func sectionButtonTapped()
    func deadlineSwitchChanged(isOn: Bool)
}

class HeaderView : UIView {
    let switchLabel = UILabel()
    let deadlineSwitch = UISwitch()
    let searchBar = UISearchBar()
    let sortButton = UIButton()
    let latestButton = UIButton()
    let sectionButton = UIButton()
    
    weak var delegate : HeaderViewDelegate?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        switchLabel.translatesAutoresizingMaskIntoConstraints = false
        switchLabel.text = "마감일자 제외하기"
        switchLabel.textAlignment = .center
        self.addSubview(switchLabel)
        
        deadlineSwitch.translatesAutoresizingMaskIntoConstraints = false
        deadlineSwitch.addTarget(self, action: #selector(deadlineSwitchChanged), for: .valueChanged)
        self.addSubview(deadlineSwitch)
        
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "공고를 검색해 보세요!"
        self.addSubview(searchBar)
        
        sortButton.translatesAutoresizingMaskIntoConstraints = false
        sortButton.setTitle("마감일자순", for: .normal)
        sortButton.setTitleColor(UIColor.black, for: .normal)
        sortButton.addTarget(self, action: #selector(sortButtonTapped), for: .touchUpInside)
        self.addSubview(sortButton)
        
        latestButton.translatesAutoresizingMaskIntoConstraints = false
        latestButton.setTitle("최신순", for: .normal)
        latestButton.setTitleColor(UIColor.black, for: .normal)
        latestButton.addTarget(self, action: #selector(latestButtonTapped), for: .touchUpInside)
        self.addSubview(latestButton)
        
        sectionButton.translatesAutoresizingMaskIntoConstraints = false
        sectionButton.setTitle("구역별", for: .normal)
        sectionButton.setTitleColor(UIColor.black, for: .normal)
        sectionButton.addTarget(self, action: #selector(sectionButtonTapped), for: .touchUpInside)
        self.addSubview(sectionButton)
        
        NSLayoutConstraint.activate([
            switchLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            switchLabel.trailingAnchor.constraint(equalTo: deadlineSwitch.leadingAnchor, constant: -10),

            deadlineSwitch.centerYAnchor.constraint(equalTo: switchLabel.centerYAnchor),
            deadlineSwitch.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),

            searchBar.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: switchLabel.bottomAnchor, constant: 10),
            
            sortButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            sortButton.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            sortButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            
            latestButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            latestButton.leadingAnchor.constraint(equalTo: sortButton.trailingAnchor),
            latestButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
            
            sectionButton.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            sectionButton.leadingAnchor.constraint(equalTo: latestButton.trailingAnchor),
            sectionButton.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            sectionButton.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/3),
        ])
    }
    @objc private func sortButtonTapped() {
        delegate?.sortButtonTapped()
    }

    @objc private func latestButtonTapped() {
        delegate?.latestButtonTapped()
    }

    @objc private func sectionButtonTapped() {
        delegate?.sectionButtonTapped()
    }

    @objc private func deadlineSwitchChanged(_ sender: UISwitch) {
        delegate?.deadlineSwitchChanged(isOn: sender.isOn)
    }

    
}
