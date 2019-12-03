
public protocol AutomobileHub: Parkable, Pickable {
    func contains(_ ticket: Ticket) -> Bool
    
    func isFull() -> Bool
    
    func freeSize() -> Int
}

public protocol Parkable {
    func park(_ car: Car) throws -> Ticket
}

public protocol Pickable {
    func pickUp(_ ticket: Ticket)  throws -> Car
}
