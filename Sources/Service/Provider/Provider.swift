/// `Provider`s allow third-party services to be easily integrated into a service `Container`.
///
/// Simply register the `Provider` like any other service and it will take care of setting up any necessary
/// configurations on itself and the container.
///
///     services.register(RedisProvider())
///
/// # Lifecycle
///
/// `Provider`s have two phases:
///
/// - Registration
/// - Boot
///
/// ## Registration
///
/// During the registration phase, the `Provider` is supplied with a mutable `Services` struct. The `Provider`
/// is expected to register all services it would like to expose to the `Container` during this phase.
///
///     services.register(RedisCache.self)
///
/// ## Boot
///
/// There are two parts of the boot phase: `willBoot(_:)` and `didBoot(_:)`. Both of these methods supply
/// the `Provider` with access to the initialized `Container` and allow asynchronous work to be done.
///
/// The `didBoot(_:)` method is guaranteed to be called _after_ `willBoot(_:)`. Most providers should try to do
/// their work in the `willBoot(_:)` method, resorting to the `didBoot(_:)` method if they rely on work from previous
/// providers to be done first.
///
public protocol Provider {
    /// This should be the name of the actual git repository that contains the `Provider`. This may be used in the future
    /// for locating physical resources in the `.build` folder.
    static var repositoryName: String { get }
    
    /// Register all services you would like to provide the `Container` here.
    ///
    ///     services.register(RedisCache.self)
    ///
    func register(_ services: inout Services) throws

    /// Called before the container has fully initialized.
    func willBoot(_ worker: Container) throws -> Future<Void>

    /// Called after the container has fully initialized and after `willBoot(_:)`.
    func didBoot(_ worker: Container) throws -> Future<Void>
}

extension Provider {
    /// See `Provider`.
    public func willBoot(_ worker: Container) throws -> Future<Void> {
        return .done(on: worker)
    }
}