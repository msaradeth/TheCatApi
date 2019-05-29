//
//  HttpHelper.swift
//  CatApi
//
//  Created by Mike Saradeth on 3/16/19.
//  Copyright © 2019 Mike Saradeth. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift




enum ApiConstant {
    static let apiKey = "21a25674-3630-4395-8a64-9057ee4edd6d"
    static let baseURLPath = "https://api.thecatapi.com/v1/images/search?"
    static let userId = "tldnpr"
    static var authenticationToken: String?
    static let headers = ["x-api-key":ApiConstant.apiKey]
}

final class HttpHelper: NSObject {

    class func request(_ url: URLConvertible, method: HTTPMethod, params: Parameters?, success: @escaping (DataResponse<Any>) -> Void, failure:@escaping (Error) -> Void) {
        Alamofire.request(url, method: method, parameters: params, headers: ApiConstant.headers).responseJSON { response in
            switch response.result {
            case .success:
                success(response)
            case .failure(let error):
                failure(error)
            }
        }
    }
}
