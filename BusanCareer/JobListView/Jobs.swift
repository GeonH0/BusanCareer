import Alamofire


struct Welcome: Codable {
    let getJobOpnngInfo: GetJobOpnngInfo?
}

struct GetJobOpnngInfo: Codable {
    let header: Header?
    let body: Body?
}

struct Body: Codable {
    let items: Items?
    let numOfRows, pageNo, totalCount: Int?
}

struct Items: Codable {
    let item: [JobItem]?
}

struct JobItem: Codable {
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
