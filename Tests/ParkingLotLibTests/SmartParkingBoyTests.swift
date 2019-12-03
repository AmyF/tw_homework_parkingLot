
import XCTest
@testable import ParkingLotLib

final class SmartParkingBoyTests: XCTestCase {
    var firstParkingLot: ParkingLot!
    var secondParkingLot: ParkingLot!
    var firstParkingBoy: ParkingBoy!
    
    var thirdParkingLot: ParkingLot!
    var fourthParkingLot: ParkingLot!
    var secondParkingBoy: ParkingBoy!
    
    override func setUp() {
        firstParkingLot = ParkingLot(id: UUID(), size: 2)
        secondParkingLot = ParkingLot(id: UUID(), size: 2)
        firstParkingBoy = ParkingBoy(parkingLots: [firstParkingLot, secondParkingLot])
        firstParkingBoy.strategy = SmartParkingBoyStrategy()
        
        thirdParkingLot = ParkingLot(id: UUID(), size: 1)
        fourthParkingLot = ParkingLot(id: UUID(), size: 2)
        secondParkingBoy = ParkingBoy(parkingLots: [thirdParkingLot, fourthParkingLot])
        secondParkingBoy.strategy = SmartParkingBoyStrategy()
    }
    
    override func tearDown() {
        firstParkingLot = nil
        secondParkingLot = nil
        firstParkingBoy = nil
        
        thirdParkingLot = nil
        fourthParkingLot = nil
        secondParkingBoy = nil
    }
    
    
    // MARK: [2, 0] [2, 0]
    func test_should_return_ticket_and_ticket_belong_to_first_parking_lot_when_park_first_car_with_parking_boy() {
        // given
        let car = makeNewCar()
        
        // when
        let ticket = try? firstParkingBoy.park(car)
        
        // then
        XCTAssertNotNil(ticket)
        XCTAssertNoThrow(try firstParkingLot.pickUp(ticket!))
    }
    
    func test_should_return_ticket_and_ticket_belong_to_second_parking_lot_when_park_second_car_with_parking_boy() {
        // given
        _ = try? firstParkingBoy.park(makeNewCar())
        
        // when
        let ticket = try! firstParkingBoy.park(makeNewCar())
        
        // then
        XCTAssertNotNil(ticket)
        XCTAssertNoThrow(try secondParkingLot.pickUp(ticket))
    }
    
    func test_should_return_ticket_and_ticket_belong_to_first_parking_lot_when_park_third_car_with_parking_boy() {
        // given
        _ = try? firstParkingBoy.park(makeNewCar())
        _ = try? firstParkingBoy.park(makeNewCar())
        
        // when
        let ticket = try! firstParkingBoy.park(makeNewCar())
        
        // then
        XCTAssertNotNil(ticket)
        XCTAssertNoThrow(try firstParkingLot.pickUp(ticket))
    }
    
    func test_should_return_exception_when_park_a_car_in_all_full_parking_lot() {
        // given
        _ = try? firstParkingBoy.park(makeNewCar())
        _ = try? firstParkingBoy.park(makeNewCar())
        _ = try? firstParkingBoy.park(makeNewCar())
        _ = try? firstParkingBoy.park(makeNewCar())
        
        // when
        
        // then
        XCTAssertThrowsError(try firstParkingBoy.park(makeNewCar())) {
            XCTAssertEqual(ParkingBoyError.allIsFull, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_return_the_car_when_use_ticket_to_pick_it_in_parking_lot() {
        // given
        let parkedCar = makeNewCar()
        let ticket = try! firstParkingBoy.park(parkedCar)
        
        // when
        let pickedCar = try! firstParkingBoy.pickUp(ticket)
        
        // then
        XCTAssertEqual(pickedCar, parkedCar)
    }
    
    func test_should_return_the_car_when_use_ticket_to_pick_it_in_first_parking_lot() {
        // given
        let ticket = try! firstParkingBoy.park(makeNewCar())
        
        // when
        
        // then
        XCTAssertNoThrow(try firstParkingLot.pickUp(ticket))
    }
    
    func test_should_return_the_car_when_use_ticket_to_pick_it_in_second_parking_lot() {
        // given
        let _ = try! firstParkingBoy.park(makeNewCar())
        
        // when
        let ticket = try! firstParkingBoy.park(makeNewCar())
        
        // then
        XCTAssertNoThrow(try secondParkingLot.pickUp(ticket))
    }
    
    func test_should_throw_exception_when_use_fake_ticket_to_pick_it_in_parking_lot() {
        // given
        _ = try! firstParkingBoy.park(makeNewCar())
        
        // when
        let ticket = Ticket(id: UUID(), parkingLotID: UUID())
        
        // then
        XCTAssertThrowsError(try firstParkingBoy.pickUp(ticket)) {
            XCTAssertEqual(ParkingBoyError.invalidTicket, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_throw_exception_when_use_fake_ticket_with_first_parking_lot_to_pick_it_in_parking_lot() {
        // given
        _ = try! firstParkingBoy.park(makeNewCar())
        
        // when
        let ticket = Ticket(id: UUID(), parkingLotID: firstParkingLot.id)
        
        // then
        XCTAssertThrowsError(try firstParkingBoy.pickUp(ticket)) {
            XCTAssertEqual(ParkingBoyError.invalidTicket, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_throw_exception_when_use_fake_ticket_to_pick_it_in_clear_parking_lot() {
        // given
        let ticket = Ticket(id: UUID(), parkingLotID: UUID())
        
        // when
        
        // then
        XCTAssertThrowsError(try firstParkingBoy.pickUp(ticket)) {
            XCTAssertEqual(ParkingBoyError.invalidTicket, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_throw_exception_when_use_fake_ticket_with_first_parking_lot_to_pick_it_in_clear_parking_lot() {
        // given
        let ticket = Ticket(id: UUID(), parkingLotID: firstParkingLot.id)
        
        // when
        
        // then
        XCTAssertThrowsError(try firstParkingBoy.pickUp(ticket)) {
            XCTAssertEqual(ParkingBoyError.invalidTicket, $0 as? ParkingBoyError)
        }
    }
    
    func test_should_throw_exception_when_use_same_ticket_to_pick_the_car_in_same_parking_lot() {
        // given
        let car = makeNewCar()
        let ticket = try! firstParkingBoy.park(car)
        
        // when
        _ = try! firstParkingBoy.pickUp(ticket)
        
        // then
        XCTAssertThrowsError(try firstParkingBoy.pickUp(ticket)) {
            XCTAssertEqual(ParkingBoyError.invalidTicket, $0 as? ParkingBoyError)
        }
    }
    
    // MARK: [1,0] [2,0]
    
    func test_should_return_a_ticket_when_park_a_car_in_fourth_parking_lot() {
        // given
        let parkedCar = makeNewCar()
        
        // when
        let ticket = try? secondParkingBoy.park(parkedCar)
        
        // then
        XCTAssertNotNil(ticket)
        XCTAssertEqual(try fourthParkingLot.pickUp(ticket!), parkedCar)
    }
    
    func test_should_return_a_ticket_when_park_a_car_in_third_parking_lot() {
        // given
        _ = try! secondParkingBoy.park(makeNewCar())
        let parkedCar = makeNewCar()
        
        // when
        let ticket = try? secondParkingBoy.park(parkedCar)
        
        // then
        XCTAssertNotNil(ticket)
        XCTAssertEqual(try thirdParkingLot.pickUp(ticket!), parkedCar)
    }
    
    func test_should_return_a_car_when_pick_it_in_fourth_parking_lot() {
        // given
        let parkedCar = makeNewCar()
        let ticket = try! secondParkingBoy.park(parkedCar)
        
        // when
        let pickedCar = try! fourthParkingLot.pickUp(ticket)
        
        // then
        XCTAssertEqual(pickedCar, parkedCar)
    }
    
    static var allTests = [
        ("test_should_return_ticket_and_ticket_belong_to_first_parking_lot_when_park_first_car_with_parking_boy", test_should_return_ticket_and_ticket_belong_to_first_parking_lot_when_park_first_car_with_parking_boy),
        ("test_should_return_ticket_and_ticket_belong_to_second_parking_lot_when_park_second_car_with_parking_boy", test_should_return_ticket_and_ticket_belong_to_second_parking_lot_when_park_second_car_with_parking_boy),
        ("test_should_return_ticket_and_ticket_belong_to_first_parking_lot_when_park_third_car_with_parking_boy", test_should_return_ticket_and_ticket_belong_to_first_parking_lot_when_park_third_car_with_parking_boy),
        ("test_should_return_exception_when_park_a_car_in_all_full_parking_lot", test_should_return_exception_when_park_a_car_in_all_full_parking_lot),
        ("test_should_return_the_car_when_use_ticket_to_pick_it_in_parking_lot", test_should_return_the_car_when_use_ticket_to_pick_it_in_parking_lot),
        ("test_should_return_the_car_when_use_ticket_to_pick_it_in_first_parking_lot", test_should_return_the_car_when_use_ticket_to_pick_it_in_first_parking_lot),
        ("test_should_return_the_car_when_use_ticket_to_pick_it_in_second_parking_lot", test_should_return_the_car_when_use_ticket_to_pick_it_in_second_parking_lot),
        ("test_should_throw_exception_when_use_fake_ticket_to_pick_it_in_parking_lot", test_should_throw_exception_when_use_fake_ticket_to_pick_it_in_parking_lot),
        ("test_should_throw_exception_when_use_fake_ticket_with_first_parking_lot_to_pick_it_in_parking_lot", test_should_throw_exception_when_use_fake_ticket_with_first_parking_lot_to_pick_it_in_parking_lot),
        ("test_should_throw_exception_when_use_fake_ticket_to_pick_it_in_clear_parking_lot", test_should_throw_exception_when_use_fake_ticket_to_pick_it_in_clear_parking_lot),
        ("test_should_throw_exception_when_use_fake_ticket_with_first_parking_lot_to_pick_it_in_clear_parking_lot", test_should_throw_exception_when_use_fake_ticket_with_first_parking_lot_to_pick_it_in_clear_parking_lot),
        ("test_should_throw_exception_when_use_same_ticket_to_pick_the_car_in_same_parking_lot", test_should_throw_exception_when_use_same_ticket_to_pick_the_car_in_same_parking_lot),
        ("test_should_return_a_ticket_when_park_a_car_in_fourth_parking_lot", test_should_return_a_ticket_when_park_a_car_in_fourth_parking_lot),
        ("test_should_return_a_ticket_when_park_a_car_in_third_parking_lot", test_should_return_a_ticket_when_park_a_car_in_third_parking_lot),
        ("test_should_return_a_car_when_pick_it_in_fourth_parking_lot", test_should_return_a_car_when_pick_it_in_fourth_parking_lot)
    ]
}

extension SmartParkingBoyTests {
    func makeNewCar() -> Car {
        Car(id: UUID())
    }
}
