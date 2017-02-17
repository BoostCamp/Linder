//
//  AccessTokenAdapter.swift
//  Lindar
//
//  Created by 박종훈 on 2017. 2. 3..
//  Copyright © 2017년 Hidden Track. All rights reserved.
//

import Foundation
import Alamofire

let baseURL = "http://10.16.19.113:8080/"

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String
    
    init(accessToken: String) {
        self.accessToken = accessToken
    }
    
    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        
        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(baseURL) {
            urlRequest.setValue("Bearer " + accessToken, forHTTPHeaderField: "Authorization")
        }
        
        return urlRequest
    }
}
