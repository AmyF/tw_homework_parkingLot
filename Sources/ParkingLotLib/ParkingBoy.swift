
import Foundation

public enum ParkingBoyError: Error, Equatable {
    case allIsFull
    case noCar
    case invalidTicket
}

public class ParkingBoy {
    private let parkingLots: [ParkingLot]
    
    public init(parkingLots: [ParkingLot]) {
        self.parkingLots = parkingLots
    }
    
    public func park(_ car: Car) throws -> Ticket {
        for parkingLot in parkingLots {
            do {
                return try parkingLot.park(car)
            } catch {
                continue
            }
        }
        throw ParkingBoyError.allIsFull
    }
    
    public func pickUp(_ ticket: Ticket) throws -> Car {
        try checkTicket(ticket)
        let parkingLot = try findParkingLot(with: ticket)
        return try parkingLot.pickUp(ticket)
    }
    
    func checkTicket(_ ticket: Ticket) throws {
        for parkingLot in parkingLots {
            if parkingLot.contains(ticket) {
                return
            }
        }
        throw ParkingBoyError.invalidTicket
    }
    
    func findParkingLot(with ticket: Ticket) throws -> ParkingLot {
        guard let parkingLot = parkingLots.filter({ $0.contains(ticket) }).first else {
            throw ParkingBoyError.noCar
        }
        return parkingLot
    }
    
}
