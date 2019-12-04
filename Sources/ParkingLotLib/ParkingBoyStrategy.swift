
public protocol ParkingBoyStrategy: Parkable, Pickable {
    func input(context: [AutomobileHub])
}

extension ParkingBoyStrategy {
    func findAvailableHub(in hubs: [AutomobileHub]) throws -> AutomobileHub {
        for hub in hubs {
            if hub.isFull() == false {
                return hub
            }
        }
        throw ParkingBoyError.allIsFull
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
