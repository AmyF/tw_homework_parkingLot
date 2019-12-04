
public class SuperParkingBoyStrategy: ParkingBoyStrategy {
    private(set) var hubs: [AutomobileHub] = []
    
    public func input(context: [AutomobileHub]) {
        self.hubs = context
    }
    
    public func park(_ car: Car) throws -> Ticket {
        let hub = try findAvailableHub(in: hubs)
        return try hub.park(car)
    }
    
    public func pickUp(_ ticket: Ticket) throws -> Car {
        try checkTicket(ticket, in: hubs)
        let hub = try findHub(with: ticket, in: hubs)
        return try hub.pickUp(ticket)
    }
    
    func findAvailableHub(in hubs: [AutomobileHub]) throws -> AutomobileHub {
        guard let target = hubs.max(by: { $0.vacancyRate() < $1.vacancyRate() }) else {
            throw ParkingBoyError.unavailableParkingLot
        }
        guard target.isFull() == false else {
            throw ParkingBoyError.allIsFull
        }
        return target
    }
}
