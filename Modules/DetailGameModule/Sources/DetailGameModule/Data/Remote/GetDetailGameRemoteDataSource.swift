//
//  File.swift
//
//
//  Created by WDT on 15/08/24.
//

import Foundation
import Combine
import Alamofire
import Core

public struct GetDetailGameRemoteDataSource: DataSource {
  public typealias Request = Any
  public typealias Response = DetailGameResponse
  private let endpoint: String
  
  public init(endpoint: String) {
    self.endpoint = endpoint
  }
  
  public func execute(request: Any?) -> AnyPublisher<DetailGameResponse, Error> {
    return Future<DetailGameResponse, Error> { completion in
      if let url = URL(string: endpoint) {
        AF.request(url)
          .validate()
          .responseDecodable(of: DetailGameResponse.self) { response in
            switch response.result {
            case .success(let value):
              completion(.success(value))
            case .failure:
              completion(.failure(URLError.invalidResponse))
            }
          }
      }
    }.eraseToAnyPublisher()
  }
}
