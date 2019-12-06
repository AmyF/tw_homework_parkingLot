
import XCTest
@testable import ParkingLotLib

final class ParkingManagerTests: XCTestCase {
    var manager: ParkingManager!
    var aBoy: ParkingBoy!
    var bBoy: ParkingBoy!
    var aParkingLot: ParkingLot!
    var bParkingLot: ParkingLot!
    
    override func setUp() {
        aParkingLot = ParkingLot(id: UUID(), size: 1)
        bParkingLot = ParkingLot(id: UUID(), size: 1)
        aBoy = try! ParkingBoy(hubs: [aParkingLot])
        bBoy = try! ParkingBoy(hubs: [bParkingLot])
        bBoy.strategy = SuperParkingBoyStrategy()
        manager = try! ParkingManager(hubs: [aBoy, bBoy])
    }
    
    override func tearDown() {
        aParkingLot = nil
        bParkingLot = nil
        aBoy = nil
        bBoy = nil
        manager = nil
    }
    
    func test_should_throw_exception_when_parking_boy_manager_parking_boy() {
        // given
        let parkingLot = ParkingLot(id: UUID(), size: 1)
        
        // when
        let parkingBoy = try! ParkingBoy(hubs: [parkingLot])
        
        // then
        XCTAssertThrowsError(try ParkingBoy(hubs: [parkingBoy])) {
            XCTAssertEqual(ParkingBoyError.manageBoy, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_throw_exception_when_manage_parking_lot_and_boy() {
        // given
        var targetError: Error?
        
        // when
        do {
            manager = try ParkingManager(hubs: [aParkingLot, aBoy])
        } catch {
            targetError = error
        }
        
        // then
        XCTAssertEqual(targetError as? ParkingManagerError, ParkingManagerError.both)
    }
    
    func test_should_return_ticket_when_park_a_car_by_manager() {
        // given
        let parkedCar = makeNewCar()
        // when
        let ticket = try! manager.park(parkedCar)
        
        // then
        let pickedCar = try! aBoy.pickUp(ticket)
        XCTAssertEqual(parkedCar, pickedCar)
    }
    
    func test_should_return_ticket_when_park_two_cars_by_manager() {
        // given
        _ = try! manager.park(makeNewCar())
        let parkedCar = makeNewCar()
        
        //when
        let ticket = try! manager.park(parkedCar)
        
        // then
        let pickedCar = try! bBoy.pickUp(ticket)
        XCTAssertEqual(parkedCar, pickedCar)
    }
    
    func test_should_throw_exception_when_park_three_cars_by_manager() {
        // given
        _ = try! manager.park(makeNewCar())
        _ = try! manager.park(makeNewCar())
        
        //when
        let parkedCar = makeNewCar()
        
        // then
        XCTAssertThrowsError(try manager.park(parkedCar)) {
            XCTAssertEqual(ParkingBoyError.allIsFull, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_return_ticket_when_manager_without_parking_lot_park_a_car() {
        // give
        let parkedCar = makeNewCar()
        
        // when
        let ticket = try! manager.park(parkedCar)
        
        // then
        XCTAssertNoThrow(try manager.pickUp(ticket))
    }
    
    func test_should_return_ticket_when_manager_without_boy_park_a_car() {
        // give
        manager = try! ParkingManager(hubs: [ParkingLot(id: UUID(), size: 1)])
        let parkedCar = makeNewCar()
        
        // when
        let ticket = try! manager.park(parkedCar)
        
        // then
        XCTAssertNoThrow(try manager.pickUp(ticket))
    }
    
    func test_should_throw_exception_when_manager_without_boy_and_lot_park_a_car() {
        // give
        manager = try! ParkingManager(hubs: [])
        
        // when
        let parkedCar = makeNewCar()
        
        // then
        XCTAssertThrowsError(try manager.park(parkedCar)) {
            XCTAssertEqual(ParkingManagerError.noAutomobileHub, $0 as? ParkingManagerError)
        }
    }
}

extension ParkingManagerTests {
    func makeNewCar() -> Car {
        Car(id: UUID())
    }
}
