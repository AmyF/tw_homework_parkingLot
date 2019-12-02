
import Foundation

public struct Ticket: Hashable, Identifiable {
    public let id: UUID
    public let parkingLotID: UUID
    
    init(id: UUID, parkingLotID: UUID) {
        self.id = id
        self.parkingLotID = parkingLotID
    }
}
