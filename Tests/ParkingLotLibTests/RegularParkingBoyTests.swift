
import XCTest
@testable import ParkingLotLib

final class RegularParkingBoyTests: XCTestCase {
    var testAParkingLot: ParkingLot!
    var testBParkingLot: ParkingLot!
    var testParkingBoy: ParkingBoy!
    
    override func setUp() {
        testAParkingLot = ParkingLot(id: UUID(), size: 2)
        testBParkingLot = ParkingLot(id: UUID(), size: 2)
        testParkingBoy = ParkingBoy(parkingLots: [testAParkingLot, testBParkingLot])
    }
    
    override func tearDown() {
        testAParkingLot = nil
        testBParkingLot = nil
        testParkingBoy = nil
    }
    
    func test_should_return_ticket_when_park_a_car_with_parking_boy() {
        // given
        let car = makeNewCar()
        
        // when
        let ticket = try? testParkingBoy.park(car)
        
        // then
        XCTAssertNotNil(ticket)
    }
    
    func test_should_return_ticket_when_park_a_car_in_second_parking_lot() {
        // given
        _ = try? testParkingBoy.park(makeNewCar())
        _ = try? testParkingBoy.park(makeNewCar())
        
        // when
        let ticket = try! testParkingBoy.park(makeNewCar())
        
        // then
        XCTAssertNotNil(ticket)
        XCTAssertNoThrow(try testBParkingLot.pickUp(ticket))
    }
    
    func test_should_return_exception_when_park_a_car_in_all_full_parking_lot() {
        // given
        _ = try? testParkingBoy.park(makeNewCar())
        _ = try? testParkingBoy.park(makeNewCar())
        _ = try? testParkingBoy.park(makeNewCar())
        _ = try? testParkingBoy.park(makeNewCar())
        
        // when
        
        // then
        XCTAssertThrowsError(try testParkingBoy.park(makeNewCar())) {
            XCTAssertEqual(ParkingBoyError.allIsFull, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_return_the_car_when_use_ticket_to_pick_up_in_parking_lot() {
        // given
        let parkedCar = makeNewCar()
        let ticket = try! testParkingBoy.park(parkedCar)
        
        // when
        let pickedCar = try! testParkingBoy.pickUp(ticket)
        
        // then
        XCTAssertEqual(pickedCar, parkedCar)
    }
    
    func test_should_throw_exception_when_use_fake_ticket_to_pick_up_in_parking_lot() {
        // given
        let parkedCar = makeNewCar()
        _ = try! testParkingBoy.park(parkedCar)
        
        // when
        let ticket = Ticket(id: UUID(), parkingLotID: UUID())
        
        // then
        XCTAssertThrowsError(try testParkingBoy.pickUp(ticket)) {
            XCTAssertEqual(ParkingBoyError.invalidTicket, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_throw_exception_when_use_fake_ticket_to_pick_up_in_clear_parking_lot() {
        // given
        let ticket = Ticket(id: UUID(), parkingLotID: UUID())
        
        // when
        
        // then
        XCTAssertThrowsError(try testParkingBoy.pickUp(ticket)) {
            XCTAssertEqual(ParkingBoyError.invalidTicket, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_throw_exception_when_use_same_ticket_to_pick_car_in_same_parking_lot() {
        // given
        let car = makeNewCar()
        let ticket = try! testParkingBoy.park(car)
        
        // when
        _ = try! testParkingBoy.pickUp(ticket)
        
        // then
        XCTAssertThrowsError(try testParkingBoy.pickUp(ticket)) {
            XCTAssertEqual(ParkingBoyError.invalidTicket, $0 as? ParkingBoyError)
        }
    }
    
    static var allTests = [
        ("test_should_return_ticket_when_park_a_car_with_parking_boy",test_should_return_ticket_when_park_a_car_with_parking_boy),
        ("test_should_return_ticket_when_park_a_car_in_second_parking_lot", test_should_return_ticket_when_park_a_car_in_second_parking_lot),
        ("test_should_return_exception_when_park_a_car_in_all_full_parking_lot", test_should_return_exception_when_park_a_car_in_all_full_parking_lot),
    ]
}

extension RegularParkingBoyTests {
    func makeNewCar() -> Car {
        Car(id: UUID())
    }
}
