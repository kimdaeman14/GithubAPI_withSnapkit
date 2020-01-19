//
//  API.swift
//  SVmiOS
//
//  Created by Jaycee on 2020/01/19.
//  Copyright © 2020 Jaycee. All rights reserved.
//

import Alamofire
import SwiftyJSON


//https://api.github.com/users?since=100
//https://api.github.com/users/kimdaeman14
//https://api.github.com/users/kimdaeman14/repos?per_page=10
//https://api.github.com/users/kimdaeman14/repos?page=1
//https://api.github.com/users/mojombo/repos?page=1


protocol APIProtocol {
    static func allUsers(_ since:Int) -> DataRequest
    static func profileInfo(_ name:String) -> DataRequest
    static func reposList(_ page:Int, _ name:String) -> DataRequest
}

struct API: APIProtocol {
    // MARK: - API Addresses
    fileprivate enum Address: String {
        case users = "users"
        
        private var baseURL: String { return "https://api.github.com/" }
        
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    // MARK: - API Endpoint Requests
    static func allUsers(_ since: Int) -> DataRequest {
        let url = URL(string: API.Address.users.url.absoluteString + "?since=\(since)") ?? URL.init(fileURLWithPath: "")
        return request(url: url, method: .get, parameters: [:])
    }
    
    static func profileInfo(_ name: String) -> DataRequest {
        let url = URL(string: API.Address.users.url.absoluteString + "/\(name)") ?? URL.init(fileURLWithPath: "")
        print(url,"url11")
        return request(url: url, method: .get, parameters: [:])
    }
    
    static func reposList(_ page: Int,_ name: String) -> DataRequest {
        let url = URL(string: API.Address.users.url.absoluteString + "/\(name)/repos?page=\(page)") ?? URL.init(fileURLWithPath: "")
        print(url,"url3333")
        return request(url: url, method: .get, parameters: [:])
    }
    
    // MARK: - Generic Request
    static private func request(url: URLConvertible, method:HTTPMethod, parameters: [String: Any] = [:]) -> DataRequest {
        return Alamofire.request(url,
                                 method: .get,
                                 parameters: Parameters(),
                                 encoding: URLEncoding.httpBody)
    }
    
}

