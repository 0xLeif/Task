import Combine

public extension Publisher {
    func `try`(
        action: @escaping (Output) throws -> Void
    ) -> AnyPublisher<Output, Error> {
        tryMap { data in
            try action(data)
            
            return data
        }
        .eraseToAnyPublisher()
    }
    
    func `do`(
        action: @escaping (Output) -> Void
    ) -> AnyPublisher<Output, Failure> {
        map { data in
            action(data)
            
            return data
        }
        .eraseToAnyPublisher()
    }
}
