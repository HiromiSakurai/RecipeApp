//
//  Client.swift
//  RecipeAppKit
//
//  Created by 櫻井寛海 on 2020/05/12.
//  Copyright © 2020 HiromiSakurai. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

public enum APIError: Error {
    case decodingFailure
    case noResponse
}

protocol Client {
    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response>
}

final class ClientImpl: Client {
    private let session: Alamofire.Session
    private let baseURL = URL(string: "https://s3-ap-northeast-1.amazonaws.com/data.kurashiru.com")!
    private let queue = DispatchQueue(label: "RecipeAppKit.Client.request")

    init() {
        self.session = Alamofire.Session.default
    }

    func request<Response>(_ endpoint: Endpoint<Response>) -> Single<Response> {
        return Single<Response>.create { observer in
            let request = self.session.request(
                self.url(path: endpoint.path),
                method: httpMethod(from: endpoint.method),
                parameters: endpoint.parameters
            )
            request
                .validate()
                .responseData(queue: self.queue) { response in
                    guard let data = response.data else {
                        return observer(.error(APIError.noResponse))
                    }

                    if let decodedResponse = try? endpoint.decode(data) {
                        observer(.success(decodedResponse))
                    } else {
                        observer(.error(APIError.decodingFailure))
                    }
            }
            return Disposables.create {
                request.cancel()
            }
        }
    }

    private func url(path: Path) -> URL {
        return baseURL.appendingPathComponent(path)
    }
}

private func httpMethod(from method: Method) -> Alamofire.HTTPMethod {
    switch method {
        case .get: return .get
    }
}
