
import Foundation

public enum ParkingLotError: Error, Equatable {
    case isParked
    case isFull
    case noCar
    case invalidTicket
}

public class ParkingLot: AutomobileHub, Identifiable {
    public let id: UUID
    private let size: Int
    private var parkingSpot: [Ticket: Car] = [:]
    
    public init(id: UUID, size: Int) {
        self.id = id
        self.size = size
    }
    
    public func park(_ car: Car) throws -> Ticket {
        guard isParkedCar(car) == false else {
            throw ParkingLotError.isParked
        }
        guard isFull() == false else {
            throw ParkingLotError.isFull
        }
        
        let ticket = Ticket(id: UUID(), parkingLotID: id)
        parkingSpot[ticket] = car
        return ticket
    }
    
    public func pickUp(_ ticket: Ticket) throws -> Car {
        guard ticket.parkingLotID == id else {
            throw ParkingLotError.invalidTicket
        }
        guard let car = parkingSpot.removeValue(forKey: ticket) else {
            throw ParkingLotError.noCar
        }
        return car
    }
    
    public func contains(_ ticket: Ticket) -> Bool {
        return parkingSpot.contains { (parkedTicket, _) -> Bool in
            parkedTicket == ticket
        }
    }
    
    public func isFull() -> Bool {
        return parkingSpot.count == size
    }
    
    public func freeSize() -> Int {
        return size - parkingSpot.count
    }
    
    func isParkedCar(_ car: Car) -> Bool {
        return parkingSpot.contains { (arg) -> Bool in
            let (_, parkedCar) = arg
            return parkedCar == car
        }
    }
}
