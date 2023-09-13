//
//  Jobs.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/13.
//

import Foundation

struct Response: Codable {
    let getJobOpnngInfo: JobOpnngInfo
}

struct JobOpnngInfo: Codable {
    let header: Header
    let body: Body
}

struct Header: Codable {
    let resultCode, resultMsg: String
}

struct Body: Codable {
    let items: Items
    let numOfRows, pageNo, totalCount: Int
}

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

