//
//  Jobs.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/13.
//

import Foundation

//
//struct getJobOpnngInfo: Codable {
//    struct Header: Codable {
//        let resultCode: String
//        let resultMsg: String
//    }
//
//    struct JobOpening: Codable {
//        let title: String
//        let recruitAgencyName: String
//        let recruitAgencyType : String
//        let mngDept : String
//        let mngName : String
//        let bunya: String
//        let workDateType: String
//        let workDate_nm : String
//        let workregiontxt : String
//        let reqDate_s: String
//        let reqDate_e: String
//        let reqType: String
//        let reqType_nm: String
//        let regDate: String
//        let modDate: String
//    }
//
//    struct Body: Codable {
//        let items: Items
//        let numOfRows: Int
//        let pageNo: Int
//        let totalCount: Int
//    }
//
//    struct Items: Codable {
//        let item: [JobOpening]
//    }
//
//    let header: Header
//    let body: Body
//}


struct JobInfo: Codable {
    let title: String
    let recruitAgencyName: String
    let recruitAgencyType : String
    let mngDept : String
    let mngName : String
    let bunya: String
    let workDateType: String
    let workDate_nm : String
    let workregiontxt : String
    let reqDate_s: String
    let reqDate_e: String
    let reqType: String
    let reqType_nm: String
    let regDate: String
    let modDate: String
}

struct Item: Codable {
    let item: [JobInfo]
}

struct Items: Codable {
    let items: Item
}

struct Body: Codable {
    let body: Items
}

struct JobOpnngInfoResponse : Codable {
   let getJobOpnngInfo : Body
}
