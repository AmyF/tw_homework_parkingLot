
public protocol ParkingStrategy: Parkable, Pickable {
    var hubs: [AutomobileHub] { get }
    
    func input(context: [AutomobileHub])
    
    func findAvailableHub(in hubs: [AutomobileHub]) throws -> AutomobileHub
}

extension ParkingStrategy {
    public func park(_ car: Car) throws -> Ticket {
        let hub = try findAvailableHub(in: hubs)
        return try hub.park(car)
    }
    
    public func pickUp(_ ticket: Ticket) throws -> Car {
        try checkTicket(ticket, in: hubs)
        let hub = try findHub(with: ticket, in: hubs)
        return try hub.pickUp(ticket)
    }
    
    func checkTicket(_ ticket: Ticket, in hubs: [AutomobileHub]) throws {
        for hub in hubs {
            if hub.contains(ticket) {
                return
            }
        }
        throw ParkingBoyError.invalidTicket
    }
    
    func findHub(with ticket: Ticket, in hubs: [AutomobileHub]) throws -> AutomobileHub {
        guard let hub = hubs.filter({ $0.contains(ticket) }).first else {
            throw ParkingBoyError.noCar
        }
        return hub
    }
}
