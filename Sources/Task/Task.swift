import Foundation
import Combine

public enum Task {
    @discardableResult
    public static func promise<T>(
        work: @escaping (@escaping Future<T, Error>.Promise) -> Void
    ) -> Future<T, Error> {
        Future { promise in
            DispatchQueue.global().async {
                work(promise)
            }
        }
    }
    
    @discardableResult
    public static func promise(
        work: @escaping (@escaping Future<Void, Error>.Promise) -> Void
    ) -> Future<Void, Error> {
        Future { promise in
            DispatchQueue.global().async {
                work(promise)
            }
        }
    }
    
    @discardableResult
    public static func `do`<T>(
        withDelay delay: UInt32 = 0,
        work: @escaping () throws -> T
    ) -> Future<T, Error> {
        Task.promise { promise in
            sleep(delay)
            do {
                promise(.success(try work()))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    @discardableResult
    public static func `do`(
        withDelay delay: UInt32 = 0,
        work: @escaping () throws -> Void = {}
    ) -> Future<Void, Error> {
        Task.promise { promise in
            sleep(delay)
            do {
                promise(.success(try work()))
            } catch {
                promise(.failure(error))
            }
        }
    }
    
    @discardableResult
    public static func main<T>(
        withDelay delay: UInt32 = 0,
        work: @escaping () throws -> T
    ) -> Future<T, Error> {
        Task.promise { promise in
            sleep(delay)
            DispatchQueue.main.async {
                do {
                    promise(.success(try work()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
    
    @discardableResult
    public static func main(
        withDelay delay: UInt32 = 0,
        work: @escaping () throws -> Void
    ) -> Future<Void, Error> {
        Task.promise { promise in
            sleep(delay)
            DispatchQueue.main.async {
                do {
                    promise(.success(try work()))
                } catch {
                    promise(.failure(error))
                }
            }
        }
    }
}
