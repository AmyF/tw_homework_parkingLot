
public class RegularParkingBoyStrategy: ParkingBoyStrategy {
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
}
