
public enum ParkingBoyError: Error, Equatable {
    case allIsFull
    case noCar
    case invalidTicket
    case unavailableParkingLot
}

public class ParkingBoy: AutomobileHub {
    public let parkingLots: [ParkingLot]
    public var strategy: ParkingBoyStrategy = RegularParkingBoyStrategy() {
        didSet {
            strategy.input(context: parkingLots)
        }
    }
    
    public init(parkingLots: [ParkingLot]) {
        self.parkingLots = parkingLots
        
        strategy.input(context: parkingLots)
    }
    
    public func park(_ car: Car) throws -> Ticket {
        try strategy.park(car)
    }
    
    public func pickUp(_ ticket: Ticket) throws -> Car {
        return try strategy.pickUp(ticket)
    }
    
    public func contains(_ ticket: Ticket) -> Bool {
        parkingLots.contains(where: {$0.contains(ticket)})
    }
    
    public func isFull() -> Bool {
        parkingLots.reduce(true, { $0 && $1.isFull()})
    }
    
    public func freeSize() -> Int {
        parkingLots.reduce(0, { $0 + $1.freeSize()})
    }
}
