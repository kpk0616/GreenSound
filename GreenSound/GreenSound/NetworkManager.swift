//
//  NetworkManager.swift
//  GreenSound
//
//  Created by hyunho lee on 2023/08/01.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    let baseURL = "https://t-data.seoul.go.kr/apig/apiman-gateway/tapi/v2xSignalPhaseTimingInformation/1.0"
    let key = "7312e7df-6752-4123-ad23-75b093bdce21"
    


    private init() {}

    func getRepositories(for repositoryName: String = "", completed: @escaping (Result<[WelcomeElement], GRError>) -> Void) {
        let endpoint = baseURL + "?apiKey=\(key)"
        
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidRepositoryname))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in

            if let _ = error {
                completed(.failure(.unableToComplete))
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let followers = try decoder.decode([WelcomeElement].self, from: data)
                completed(.success(followers))
            } catch {
                completed(.failure(.invalidData))
            }
        }
        
        task.resume()
    }
    
}


// MARK: - WelcomeElement
struct WelcomeElement: Codable {
    let dataID: String
    let trsmDy, trsmUTCTime: Int
    let trsmYear, trsmMT, trsmTm, trsmMS: String
    let itstID, eqmnID: String
    let msgCreatMin, msgCreatDs: Int
    let ntBssgRmdrCS, ntBcsgRmdrCS, ntLtsgRmdrCS, ntPdsgRmdrCS: Int?
    let ntStsgRmdrCS: Int?
    let ntUtsgRmdrCS: JSONNull?
    let etBssgRmdrCS: Int?
    let etBcsgRmdrCS: JSONNull?
    let etLtsgRmdrCS, etPdsgRmdrCS, etStsgRmdrCS: Int?
    let etUtsgRmdrCS: JSONNull?
    let stBssgRmdrCS: Int?
    let stBcsgRmdrCS: JSONNull?
    let stLtsgRmdrCS, stPdsgRmdrCS, stStsgRmdrCS: Int?
    let stUtsgRmdrCS: JSONNull?
    let wtBssgRmdrCS: Int?
    let wtBcsgRmdrCS: JSONNull?
    let wtLtsgRmdrCS, wtPdsgRmdrCS, wtStsgRmdrCS, wtUtsgRmdrCS: Int?
    let neBssgRmdrCS, neBcsgRmdrCS, neLtsgRmdrCS, nePdsgRmdrCS: Int?
    let neStsgRmdrCS: Int?
    let neUtsgRmdrCS: JSONNull?
    let seBssgRmdrCS, seBcsgRmdrCS, seLtsgRmdrCS, sePdsgRmdrCS: Int?
    let seStsgRmdrCS: Int?
    let seUtsgRmdrCS: JSONNull?
    let swBssgRmdrCS, swBcsgRmdrCS, swLtsgRmdrCS, swPdsgRmdrCS: Int?
    let swStsgRmdrCS: Int?
    let swUtsgRmdrCS: JSONNull?
    let nwBssgRmdrCS, nwBcsgRmdrCS, nwLtsgRmdrCS, nwPdsgRmdrCS: Int?
    let nwStsgRmdrCS: Int?
    let nwUtsgRmdrCS: JSONNull?
    let rgtrID: RgtrID
    let regDt: RegDt

    enum CodingKeys: String, CodingKey {
        case dataID = "dataId"
        case trsmDy
        case trsmUTCTime = "trsmUtcTime"
        case trsmYear
        case trsmMT = "trsmMt"
        case trsmTm
        case trsmMS = "trsmMs"
        case itstID = "itstId"
        case eqmnID = "eqmnId"
        case msgCreatMin, msgCreatDs
        case ntBssgRmdrCS = "ntBssgRmdrCs"
        case ntBcsgRmdrCS = "ntBcsgRmdrCs"
        case ntLtsgRmdrCS = "ntLtsgRmdrCs"
        case ntPdsgRmdrCS = "ntPdsgRmdrCs"
        case ntStsgRmdrCS = "ntStsgRmdrCs"
        case ntUtsgRmdrCS = "ntUtsgRmdrCs"
        case etBssgRmdrCS = "etBssgRmdrCs"
        case etBcsgRmdrCS = "etBcsgRmdrCs"
        case etLtsgRmdrCS = "etLtsgRmdrCs"
        case etPdsgRmdrCS = "etPdsgRmdrCs"
        case etStsgRmdrCS = "etStsgRmdrCs"
        case etUtsgRmdrCS = "etUtsgRmdrCs"
        case stBssgRmdrCS = "stBssgRmdrCs"
        case stBcsgRmdrCS = "stBcsgRmdrCs"
        case stLtsgRmdrCS = "stLtsgRmdrCs"
        case stPdsgRmdrCS = "stPdsgRmdrCs"
        case stStsgRmdrCS = "stStsgRmdrCs"
        case stUtsgRmdrCS = "stUtsgRmdrCs"
        case wtBssgRmdrCS = "wtBssgRmdrCs"
        case wtBcsgRmdrCS = "wtBcsgRmdrCs"
        case wtLtsgRmdrCS = "wtLtsgRmdrCs"
        case wtPdsgRmdrCS = "wtPdsgRmdrCs"
        case wtStsgRmdrCS = "wtStsgRmdrCs"
        case wtUtsgRmdrCS = "wtUtsgRmdrCs"
        case neBssgRmdrCS = "neBssgRmdrCs"
        case neBcsgRmdrCS = "neBcsgRmdrCs"
        case neLtsgRmdrCS = "neLtsgRmdrCs"
        case nePdsgRmdrCS = "nePdsgRmdrCs"
        case neStsgRmdrCS = "neStsgRmdrCs"
        case neUtsgRmdrCS = "neUtsgRmdrCs"
        case seBssgRmdrCS = "seBssgRmdrCs"
        case seBcsgRmdrCS = "seBcsgRmdrCs"
        case seLtsgRmdrCS = "seLtsgRmdrCs"
        case sePdsgRmdrCS = "sePdsgRmdrCs"
        case seStsgRmdrCS = "seStsgRmdrCs"
        case seUtsgRmdrCS = "seUtsgRmdrCs"
        case swBssgRmdrCS = "swBssgRmdrCs"
        case swBcsgRmdrCS = "swBcsgRmdrCs"
        case swLtsgRmdrCS = "swLtsgRmdrCs"
        case swPdsgRmdrCS = "swPdsgRmdrCs"
        case swStsgRmdrCS = "swStsgRmdrCs"
        case swUtsgRmdrCS = "swUtsgRmdrCs"
        case nwBssgRmdrCS = "nwBssgRmdrCs"
        case nwBcsgRmdrCS = "nwBcsgRmdrCs"
        case nwLtsgRmdrCS = "nwLtsgRmdrCs"
        case nwPdsgRmdrCS = "nwPdsgRmdrCs"
        case nwStsgRmdrCS = "nwStsgRmdrCs"
        case nwUtsgRmdrCS = "nwUtsgRmdrCs"
        case rgtrID = "rgtrId"
        case regDt
    }
}

enum RegDt: String, Codable {
    case the20230801T1500000000000 = "2023-08-01T15:00:00.000+00:00"
    case the20230801T1500010000000 = "2023-08-01T15:00:01.000+00:00"
    case the20230801T1500020000000 = "2023-08-01T15:00:02.000+00:00"
}

enum RgtrID: String, Codable {
    case v2X = "v2x"
}

typealias Welcome = [WelcomeElement]

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}


enum GRError: String, Error {
    case invalidRepositoryname = "이 레파지토리 이름은 잘못된 요청입니다. 다시 요청해주세요."
    case unableToComplete = "요청을 완료할 수 없습니다. 네트워크 연결을 확인해주세요."
    case invalidResponse = "유효하지 않은 서버로 부터의 응답입니다. 다시 요청해주세요."
    case invalidData = "서버로 받은 데이터가 유효하지 않습니다. 다시 요청해주세요."
    case emptyTextField = "검색창이 비어있습니다 검색어를 입력해주세요."
    case noResult = "검색 결과가 없습니다. 다른 검색어를 입력해주세요."
}
