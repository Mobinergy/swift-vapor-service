import Async

public protocol ServiceType: Service {
    /// An array of protocols (or types) that this
    /// service conforms to. 
    ///     ex. when `container.make(X.self)`
    ///     is called, all services that support `X`
    ///     will be considered.
    static var serviceSupports: [Any.Type] { get }

    /// Creates a new instance of the service
    /// Using the service container.
    static func makeService(for worker: Container) throws -> Self
}

/// MARK: Optional

extension ServiceType {
    /// See `ServiceType.serviceSupports`
    public static var serviceSupports: [Any.Type] {
        return []
    }
}
