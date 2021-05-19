import Foundation
import Combine

// MARK: Post
public struct TaskPostError: Error {
    let error: Error
    let response: URLResponse?
}

public extension Task {
    static func post(
        request: URLRequest
    ) -> Future<(Data?, URLResponse?), Error> {
        Task.promise { promise in
            URLSession.shared
                .dataTask(with: request) { (data, response, error) in
                    if let error = error {
                        promise(.failure(TaskPostError(error: error,
                                                       response: response)))
                    }
                    promise(.success((data, response)))
                }
                .resume()
        }
    }
    
    static func post(
        url: URL,
        withData data: (() -> Data)? = nil
    ) -> Future<(Data?, URLResponse?), Error> {
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = data?()
        request.allHTTPHeaderFields = [
            "Content-Type": "application/json; charset=utf-8"
        ]
        
        return post(request: request)
    }
}

// MARK: Fetch
public extension Task {
    @discardableResult
    static func fetch(
        url: URL
    ) -> Future<(Data?, URLResponse?), Error> {
        Task.promise { promise in
            URLSession.shared
                .dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    promise(.success((data, response)))
                }
                .resume()
        }
    }
    
    @discardableResult
    static func fetch(
        url: URLRequest
    ) -> Future<(Data?, URLResponse?), Error> {
        Task.promise { promise in
            URLSession.shared
                .dataTask(with: url) { (data, response, error) in
                    if let error = error {
                        promise(.failure(error))
                    }
                    promise(.success((data, response)))
                }
                .resume()
        }
    }
}
