//
//  Jobs.swift
//  SeoulCareer
//
//  Created by 김건호 on 2023/09/13.
//

import Foundation

struct JobOpnngInfoResponse : Codable {
      let getJobOpnngInfo : Body
}

struct JobInfo: Codable {
    let title: String
    let recruitAgencyName: String?
    let recruitAgencyType: String?
    let mngDept: String?
    let mngName: String?
    let bunya: String?
    let workDate_type: String?
    let workDate_nm: String?
    let workregiontxt: String?
    let reqDate_s: String?
    let reqDate_e: String?
    let reqType:String?
    let reqType_nm:String?
    let regDate:String?
    let modDate:String?
}

struct Item : Codable {
    var item : [JobInfo]
}

struct Items : Codable {
    let items : Item?
}

struct Body : Codable {
    var body : Items?
    var numOfRows:Int?
    var pageNo:Int?
    var totalCount:Int?
    
}

struct Header:Codable{
  var resultCode:String?
  var resultMsg:String?
}
  

