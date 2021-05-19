import Combine

public extension Publisher {
    func `try`(
        action: @escaping (Output) throws -> Void
    ) -> AnyPublisher<Output, Failure> where Failure == Error {
        flatMap { data in
            Task.do {
                try action(data)
                
                return data
            }
        }
        .eraseToAnyPublisher()
    }
    
    func `do`(
        action: @escaping (Output) -> Void
    ) -> AnyPublisher<Output, Failure> where Failure == Error {
        flatMap { data in
            Task.do {
                action(data)
                
                return data
            }
        }
        .eraseToAnyPublisher()
    }
}
