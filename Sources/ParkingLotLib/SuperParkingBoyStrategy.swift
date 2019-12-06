
public class SuperParkingBoyStrategy: ParkingStrategy {
    private(set) public var hubs: [AutomobileHub] = []
    
    public func input(context: [AutomobileHub]) {
        self.hubs = context
    }
    
    public func findAvailableHub(in hubs: [AutomobileHub]) throws -> AutomobileHub {
        guard let target = hubs.max(by: { $0.vacancyRate() < $1.vacancyRate() }) else {
            throw ParkingBoyError.unavailableParkingLot
        }
        guard target.isFull() == false else {
            throw ParkingBoyError.allIsFull
        }
        return target
    }
}
