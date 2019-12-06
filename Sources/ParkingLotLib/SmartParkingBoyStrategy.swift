
public class SmartParkingBoyStrategy: ParkingStrategy {
    private(set) public var hubs: [AutomobileHub] = []
    
    public func input(context: [AutomobileHub]) {
        self.hubs = context
    }
    
    public func findAvailableHub(in parkingLots: [AutomobileHub]) throws -> AutomobileHub {
        guard let target = hubs.max(by: { $0.freeSize() < $1.freeSize() }) else {
            throw ParkingBoyError.unavailableParkingLot
        }
        guard target.isFull() == false else {
            throw ParkingBoyError.allIsFull
        }
        return target
    }
}
