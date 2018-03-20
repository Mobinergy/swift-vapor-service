import Async

public struct BasicServiceFactory: ServiceFactory {
    /// See ServiceFactory.serviceType
    public let serviceType: Any.Type

    /// See ServiceFactory.serviceSupports
    public var serviceSupports: [Any.Type]

    /// Accepts a container and worker, returning an
    /// initialized service.
    public typealias ServiceFactoryClosure = (Container) throws -> Any

    /// Closure that constructs the service
    public let closure: ServiceFactoryClosure

    /// Create a new basic service factoryl.
    public init(
        _ type: Any.Type,
        supports interfaces: [Any.Type],
        factory closure: @escaping ServiceFactoryClosure
    ) {
        self.serviceType = type
        self.serviceSupports = interfaces
        self.closure = closure
    }

    /// See ServiceFactory.makeService
    public func makeService(for worker: Container) throws -> Any {
        return try closure(worker)
    }
}
