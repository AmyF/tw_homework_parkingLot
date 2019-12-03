
public protocol ParkingBoyStrategy: Parkable, Pickable {
    func input(context: [ParkingLot])
}

extension ParkingBoyStrategy {
    func findAvailableParkingLot(in parkingLots: [ParkingLot]) throws -> ParkingLot {
        for parkingLot in parkingLots {
            if parkingLot.isFull() == false {
                return parkingLot
            }
        }
        throw ParkingBoyError.allIsFull
    }
    
    func checkTicket(_ ticket: Ticket, in parkingLots: [ParkingLot]) throws {
        for parkingLot in parkingLots {
            if parkingLot.contains(ticket) {
                return
            }
        }
        throw ParkingBoyError.invalidTicket
    }
    
    func findParkingLot(with ticket: Ticket, in parkingLots: [ParkingLot]) throws -> ParkingLot {
        guard let parkingLot = parkingLots.filter({ $0.contains(ticket) }).first else {
            throw ParkingBoyError.noCar
        }
        return parkingLot
    }
}
