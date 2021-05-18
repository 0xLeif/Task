import Combine

public enum SinkEvent<Value> {
    case completion(_ closure: () -> Void)
    case failure(_ closure: (Error) -> Void)
    case success(_ closure: (Value) -> Void)
}

public extension Publisher {
    func sink(_ event: SinkEvent<Output>) -> AnyCancellable {
        sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                if case .failure(let closure) = event {
                    closure(error)
                }
                
            }
            if case .completion(let closure) = event {
                closure()
            }
            
        }) { (value) in
            if case .success(let closure) = event {
                closure(value)
            }
            
        }
    }
    
    func sink(_ closure: () -> [SinkEvent<Output>]) -> AnyCancellable {
        let events = closure()
        
        return sink(receiveCompletion: { completion in
            if case .failure(let error) = completion {
                events.forEach { event in
                    if case .failure(let closure) = event {
                        closure(error)
                    }
                }
            }
            events.forEach { event in
                if case .completion(let closure) = event {
                    closure()
                }
            }
        }) { (value) in
            events.forEach { event in
                if case .success(let closure) = event {
                    closure(value)
                }
            }
        }
    }
}

