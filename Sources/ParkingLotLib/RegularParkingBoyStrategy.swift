
public class RegularParkingBoyStrategy: ParkingBoyStrategy {
    private(set) var parkingLots: [ParkingLot] = []
    
    public func input(context: [ParkingLot]) {
        self.parkingLots = context
    }
    
    public func park(_ car: Car) throws -> Ticket {
        let parkingLot = try findAvailableParkingLot(in: parkingLots)
        return try parkingLot.park(car)
    }
    
    public func pickUp(_ ticket: Ticket) throws -> Car {
        try checkTicket(ticket, in: parkingLots)
        let parkingLot = try findParkingLot(with: ticket, in: parkingLots)
        return try parkingLot.pickUp(ticket)
    }
}
