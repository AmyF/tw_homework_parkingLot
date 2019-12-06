
public enum ParkingBoyError: Error, Equatable {
    case allIsFull
    case noCar
    case invalidTicket
    case unavailableParkingLot
}

public class ParkingBoy: AutomobileHub {
    public let hubs: [AutomobileHub]
    public var strategy: ParkingStrategy = RegularParkingBoyStrategy() {
        didSet {
            strategy.input(context: hubs)
        }
    }
    
    public init(hubs: [AutomobileHub]) {
        self.hubs = hubs
        
        strategy.input(context: hubs)
    }
    
    public func park(_ car: Car) throws -> Ticket {
        try strategy.park(car)
    }
    
    public func pickUp(_ ticket: Ticket) throws -> Car {
        return try strategy.pickUp(ticket)
    }
    
    public func contains(_ ticket: Ticket) -> Bool {
        hubs.contains(where: {$0.contains(ticket)})
    }
    
    public func isFull() -> Bool {
        hubs.reduce(true, { $0 && $1.isFull()})
    }
    
    public func freeSize() -> Int {
        hubs.reduce(0, { $0 + $1.freeSize()})
    }
    
    public func vacancyRate() -> Float {
        return 0
    }
}
