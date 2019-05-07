//
//  NetworkRequest.swift
//  Reciplease
//
//  Created by David Dubez on 07/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Alamofire

protocol NetworkRequest {
    func get<Model: Codable>(url: String,
                             parameters: [String: Any],
                             completionHandler: @escaping (Model?, Error?) -> Void)
}

struct AlamofireNetworkRequest: NetworkRequest {
    func get<Model>(url: String,
                    parameters: Parameters,
                    completionHandler: @escaping (Model?, Error?) -> Void) where Model: Decodable, Model: Encodable {

        AF.request(url,
                   parameters: parameters)
            .responseDecodable {(response: DataResponse<Model>) in

                if let error = response.error {
                    return completionHandler(nil, error)
                }
                guard let decodedResponse = response.value else {
                    return completionHandler(nil, "error in decoding JSON response" as? Error)
                }

                completionHandler(decodedResponse, nil)
        }
    }
}
