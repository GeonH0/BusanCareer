//
//  JobDetailViewController.swift
//  SeoulCareer
//
//  Created by 김건호 on 10/19/23.
//

import UIKit
import Foundation


class JobDetailViewController : UIViewController {
    
    var Job: Item?
    
    @IBOutlet weak var JobTitleLabel: UILabel!
    
    @IBOutlet weak var AgencyName: UILabel!
    
    @IBOutlet weak var bunya: UILabel!
    
    @IBOutlet weak var endDate: UILabel!
    @IBOutlet weak var reqType: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        
        guard let detail = Job else { return}
        JobTitleLabel.lineBreakMode = .byTruncatingTail
        
        JobTitleLabel.text = "\(String(describing: detail.title))"
        
        AgencyName.text = "\(String(describing: detail.recruitAgencyName))"
        
        reqType.text = "\(String(describing: detail.reqTypeNm!))"
        
        endDate.text = "\(String(describing: detail.reqDateE!))"
        
        if let bunyaText = detail.bunya, !bunyaText.isEmpty {
            bunya.text = bunyaText
        } else {
            bunya.text = "분야 없음"
        }

        
        
        
    }
}
