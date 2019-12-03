import XCTest
@testable import ParkingLotLib

final class ParkingLotTests: XCTestCase {
    var testParkingLot: ParkingLot!

    override func setUp() {
        testParkingLot = ParkingLot(id: UUID(), size: 1)
    }

    override func tearDown() {
        testParkingLot = nil
    }
    
    func test_should_return_ticket_when_park_a_car_in_parking_lot() {
        // given
        let car = makeNewCar()
        
        // when
        let ticket = try? testParkingLot.park(car)

        // then
        XCTAssertNotNil(ticket)
    }
    
    func test_should_throw_exception_when_park_a_car_in_full_parking_lot() {
        // given
        _ = try? testParkingLot.park(makeNewCar())
        
        // when
        
        // then
        XCTAssertThrowsError(try testParkingLot.park(makeNewCar())) {
            XCTAssertEqual(ParkingLotError.isFull, $0 as? ParkingLotError)
        }
    }
    
    func test_should_return_the_car_when_use_ticket_to_pick_up_in_parking_lot() {
        // given
        let parkedCar = makeNewCar()
        let ticket = try! testParkingLot.park(parkedCar)
        
        // when
        let pickedCar = try! testParkingLot.pickUp(ticket)
        
        // then
        XCTAssertEqual(pickedCar, parkedCar)
    }
    
    func test_should_throw_exception_when_use_fake_ticket_to_pick_up_in_parking_lot() {
        // given
        let parkedCar = makeNewCar()
        _ = try! testParkingLot.park(parkedCar)
        
        // when
        let ticket = Ticket(id: UUID(), parkingLotID: UUID())
        
        // then
        XCTAssertThrowsError(try testParkingLot.pickUp(ticket)) {
            XCTAssertEqual(ParkingLotError.invalidTicket, $0 as? ParkingLotError)
        }
    }
    
    func test_should_throw_exception_when_use_same_ticket_to_pick_car_in_same_parking_lot() {
        // given
        let car = makeNewCar()
        let ticket = try! testParkingLot.park(car)
        
        // when
        _ = try! testParkingLot.pickUp(ticket)
        
        // then
        XCTAssertThrowsError(try testParkingLot.pickUp(ticket)) {
            XCTAssertEqual(ParkingLotError.noCar, $0 as? ParkingLotError)
        }
    }
    
    func test_should_throw_exception_when_use_same_car_to_park_same_parking_lot() {
        // given
        let car = makeNewCar()
        _ = try! testParkingLot.park(car)
        
        // when
        
        // then
        XCTAssertThrowsError(try testParkingLot.park(car)) {
            XCTAssertEqual(ParkingLotError.isParked, $0 as? ParkingLotError)
        }
    }
    
    func test_should_return_ticket_when_park_two_car() {
        // given
        let testParkingLot = ParkingLot(id: UUID(), size: 2)
        let aCar = makeNewCar()
        let bCar = makeNewCar()
        
        // when
        let aTicket = try? testParkingLot.park(aCar)
        let bTicket = try? testParkingLot.park(bCar)
        
        // then
        XCTAssertNotNil(aTicket)
        XCTAssertNotNil(bTicket)
    }

    static var allTests = [
        ("test_should_return_ticket_when_park_a_car_in_parking_lot", test_should_return_ticket_when_park_a_car_in_parking_lot),
        ("test_should_throw_exception_when_park_a_car_in_full_parking_lot", test_should_throw_exception_when_park_a_car_in_full_parking_lot),
        ("test_should_return_the_car_when_use_ticket_to_pick_up_in_parking_lot", test_should_return_the_car_when_use_ticket_to_pick_up_in_parking_lot),
        ("test_should_throw_exception_when_use_fake_ticket_to_pick_up_in_parking_lot", test_should_throw_exception_when_use_fake_ticket_to_pick_up_in_parking_lot),
    ]
}

extension ParkingLotTests {
    func makeNewCar() -> Car {
        Car(id: UUID())
    }
}
