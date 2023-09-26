//
//  Jobs.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/13.
//

import Foundation



struct Items: Codable {
    let item: [Item]
}

struct Item: Codable {
    let title, recruitAgencyName, recruitAgencyType, mngDept,
        mngName, bunya,
        workDate_type,
        workDate_nm,
        workregiontxt,
        reqDate_s,
        reqDate_e,
        reqType,
        reqType_nm,
        regDate,
        modDate : String
}

