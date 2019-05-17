//
//  NetworkRequest.swift
//  Reciplease
//
//  Created by David Dubez on 07/05/2019.
//  Copyright © 2019 David Dubez. All rights reserved.
//

import Foundation
import Alamofire

// Protocol for manage network requests
protocol NetworkRequest {

    /**
     Creates a request to retrive the contents of the specified 'url', with 'parameters'
     - Parameter url: url of the API
     - Parameter parameters: [String: Any]
     - Parameter completionHandler: the model decoded and an error
     - Returns : the model decoded and an error
     */
    func get<Model: Codable>(url: String,
                             parameters: [String: Any],
                             completionHandler: @escaping (Model?, Error?) -> Void)

    /**
     Creates a request to get data of the specified 'url'
     - Parameter dataUrl: url of the API
     - Parameter completionHandler: the data and an error
     - Returns : the data and an error
     */
    func getData(dataUrl: String, completionHandler: @escaping (Data?, Error?) -> Void)
}

// Creates a request using Alamofire
struct AlamofireNetworkRequest: NetworkRequest {

    func get<Model>(url: String,
                    parameters: Parameters,
                    completionHandler: @escaping (Model?, Error?) -> Void) where Model: Decodable, Model: Encodable {

        AF.request(url, parameters: parameters).responseData { (response) in
            if let error = response.error {
                completionHandler(nil, error)
            }

            guard let dataResponse = response.data else {
                completionHandler(nil, NRError.noData)
                return
            }

            let result: (Model?, Error?) = manageResponse(data: dataResponse)
            completionHandler(result.0, result.1)

        }
    }

    func getData(dataUrl: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        AF.request(dataUrl).responseData { response in

            guard let data = response.result.value else {
                completionHandler(nil, NRError.noData)
                return
            }
            completionHandler(data, nil)
        }
    }

}

// Creates a fake Request for testing
struct FakeNetwokRequest: NetworkRequest {
    var data: Data?
    var error: Error?

    func get<Model>(url: String,
                    parameters: [String: Any],
                    completionHandler: @escaping (Model?, Error?) -> Void) where Model: Decodable, Model: Encodable {

        if let error = error {
            completionHandler(nil, error)
        } else {
            let result: (Model?, Error?) = manageResponse(data: data)
            completionHandler(result.0, result.1)
        }
    }

    func getData(dataUrl: String, completionHandler: @escaping (Data?, Error?) -> Void) {
        completionHandler(data, error)
    }
}

/**
function to manage response data in get request
 - Parameters:
    - data: the simulate data return by url
 - Returns : the model decoded and an error
 */

private func manageResponse<Model: Codable>(data: Data?) -> (Model?, Error?) {
    if let dataToDecode = data {
        let decoder = JSONDecoder()
        decoder.userInfo[CodingUserInfoKey.context!] = AppDelegate.viewContext
        do {
            let model = try decoder.decode(Model.self, from: dataToDecode)
            return (model, nil)
        } catch {
            return (nil, error)
        }
    } else {
        return (nil, nil)
    }
}

/**
 'NRError' is the error type returned by NetworkRequest. It encompasses a few different types of errors, each with
 their own associated reasons.
 
 - noData: return when there is no data in NetworkRequest response
 - failedToDecode: return when decoding object throws an error during decoding process
 */
enum NRError: Error {
    case noData
}
