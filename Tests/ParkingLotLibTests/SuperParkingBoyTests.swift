
import XCTest
@testable import ParkingLotLib

final class SuperParkingBoyTests: XCTestCase {
    var firstParkingLot: ParkingLot!
    var secondParkingLot: ParkingLot!
    var thirdParkingLot: ParkingLot!
    var parkingBoy: ParkingBoy!
    
    override func setUp() {
        firstParkingLot = ParkingLot(id: UUID(), size: 10)
        secondParkingLot = ParkingLot(id: UUID(), size: 10)
        thirdParkingLot = ParkingLot(id: UUID(), size: 20)
        parkingBoy = try! ParkingBoy(hubs: [firstParkingLot, secondParkingLot, thirdParkingLot])
        parkingBoy.strategy = SuperParkingBoyStrategy()
    }
    
    override func tearDown() {
        firstParkingLot = nil
        secondParkingLot = nil
        thirdParkingLot = nil
        parkingBoy = nil
    }
    
    func test_should_return_true_when_park_a_car_and_pick_it_in_first_parking_lot_and_third_is_biggest() {
        // given
        let parkedCar = makeNewCar()
        
        // when
        let ticket = try! parkingBoy.park(parkedCar)
        
        // then
        let pickedCar = try! firstParkingLot.pickUp(ticket)
        XCTAssertEqual(parkedCar, pickedCar)
    }
    
    func test_should_return_true_when_park_a_car_and_pick_it_in_first_parking_lot_and_third_is_least() {
        // given
        let firstParkingLot = ParkingLot(id: UUID(), size: 10)
        let secondParkingLot = ParkingLot(id: UUID(), size: 10)
        let thirdParkingLot = ParkingLot(id: UUID(), size: 5)
        let firstParkingBoy = try! ParkingBoy(hubs: [firstParkingLot, secondParkingLot, thirdParkingLot])
        firstParkingBoy.strategy = SuperParkingBoyStrategy()
        let parkedCar = makeNewCar()
        
        // when
        let ticket = try! firstParkingBoy.park(parkedCar)
        
        // then
        let pickedCar = try! firstParkingLot.pickUp(ticket)
        XCTAssertEqual(parkedCar, pickedCar)
    }
    
    func test_should_return_true_when_park_a_car_and_pick_it_in_first_parking_lot_and_first_has_one() {
        // given
        _ = try! parkingBoy.park(makeNewCar())
        let parkedCar = makeNewCar()
        
        // when
        let ticket = try! parkingBoy.park(parkedCar)
        
        // then
        let pickedCar = try! secondParkingLot.pickUp(ticket)
        XCTAssertEqual(parkedCar, pickedCar)
    }
    
    func test_should_return_true_when_park_a_car_and_pick_it_in_first_parking_lot_and_all_has_one() {
        // given
        _ = try! parkingBoy.park(makeNewCar())
        _ = try! secondParkingLot.park(makeNewCar())
        _ = try! thirdParkingLot.park(makeNewCar())
        let parkedCar = makeNewCar()
        
        // when
        let ticket = try! parkingBoy.park(parkedCar)
        
        // then
        let pickedCar = try! thirdParkingLot.pickUp(ticket)
        XCTAssertEqual(parkedCar, pickedCar)
    }
    
    func test_should_throw_exception_when_park_a_car_and_pick_it_in_first_parking_lot_and_all_is_full() {
        // given
        let firstParkingLot = ParkingLot(id: UUID(), size: 1)
        let secondParkingLot = ParkingLot(id: UUID(), size: 1)
        let thirdParkingLot = ParkingLot(id: UUID(), size: 2)
        let firstParkingBoy = try! ParkingBoy(hubs: [firstParkingLot, secondParkingLot, thirdParkingLot])
        firstParkingBoy.strategy = SuperParkingBoyStrategy()
        
        // when
        _ = try! firstParkingBoy.park(makeNewCar())
        _ = try! secondParkingLot.park(makeNewCar())
        _ = try! thirdParkingLot.park(makeNewCar())
        _ = try! thirdParkingLot.park(makeNewCar())
        
        // then
        XCTAssertThrowsError(try firstParkingBoy.park(makeNewCar())) {
            XCTAssertEqual(ParkingBoyError.allIsFull, $0 as? ParkingBoyError)
        }
    }

}

extension SuperParkingBoyTests {
    func makeNewCar() -> Car {
        Car(id: UUID())
    }
}
