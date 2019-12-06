
public class RegularParkingBoyStrategy: ParkingStrategy {
    private(set) public var hubs: [AutomobileHub] = []
    
    public func input(context: [AutomobileHub]) {
        self.hubs = context
    }
    
    public func findAvailableHub(in hubs: [AutomobileHub]) throws -> AutomobileHub {
        for hub in hubs {
            if hub.isFull() == false {
                return hub
            }
        }
        throw ParkingBoyError.allIsFull
    }
}
