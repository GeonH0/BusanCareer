// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(Welcome.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseWelcome { response in
//     if let welcome = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

// MARK: - Welcome
struct Welcome: Codable {
    let getJobOpnngInfo: GetJobOpnngInfo?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseGetJobOpnngInfo { response in
//     if let getJobOpnngInfo = response.result.value {
//       ...
//     }
//   }

// MARK: - GetJobOpnngInfo
struct GetJobOpnngInfo: Codable {
    let header: Header?
    let body: Body?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseBody { response in
//     if let body = response.result.value {
//       ...
//     }
//   }

// MARK: - Body
struct Body: Codable {
    let items: Items?
    let numOfRows, pageNo, totalCount: Int?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseItems { response in
//     if let items = response.result.value {
//       ...
//     }
//   }

// MARK: - Items
struct Items: Codable {
    let item: [Item]?
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseItem { response in
//     if let item = response.result.value {
//       ...
//     }
//   }

// MARK: - Item
struct Item: Codable {
    let title, recruitAgencyName, recruitAgencyType, mngDept: String
    let mngName, bunya, workDateType, workDateNm: String?
    let workregiontxt, reqDateS, reqDateE, reqType: String?
    let reqTypeNm, regDate, modDate: String?

    enum CodingKeys: String, CodingKey {
        case title, recruitAgencyName, recruitAgencyType, mngDept, mngName, bunya
        case workDateType = "workDate_type"
        case workDateNm = "workDate_nm"
        case workregiontxt
        case reqDateS = "reqDate_s"
        case reqDateE = "reqDate_e"
        case reqType
        case reqTypeNm = "reqType_nm"
        case regDate, modDate
    }
}

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseHeader { response in
//     if let header = response.result.value {
//       ...
//     }
//   }

// MARK: - Header
struct Header: Codable {
    let resultCode, resultMsg: String?
}

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}
