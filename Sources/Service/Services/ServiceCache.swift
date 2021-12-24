/// Caches services. All API besides creating a new `ServiceCache` are internal.
public final class ServiceCache {
    /// The internal services cache.
    private var services: ConcurrentDictionary<ServiceID, ResolvedService>

    /// Create a new service cache.
    public init() {
        self.services = .init()
    }

    /// Gets or compute the cached service.
    internal func insert<T>(_ interface: T.Type, using computeValue: () throws -> Service) throws -> T {
        let resolved = services.insertValue(forKey: .init(T.self)) {
            do {
                return try .service(computeValue())
            } catch {
                return .error(error)
            }
        }

        return try resolved.resolve() as! T
    }
}

/// A cacheable, resolved Service. Can be either an error or the actual service.
fileprivate enum ResolvedService {
    case service(Service)
    case error(Error)

    /// returns the service or throws the error
    internal func resolve() throws -> Service {
        switch self {
        case .error(let error): throw error
        case .service(let service): return service
        }
    }
}
