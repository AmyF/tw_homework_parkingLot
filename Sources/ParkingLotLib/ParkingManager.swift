//
//  ParkingManager.swift
//  ParkingLotLib
//
//  Created by 黄飞达 on 2019/12/6.
//

import Foundation

public enum ParkingManagerError: Error {
    case both
    case noAutomobileHub
}

public class ParkingManager: AutomobileHub {
    public let hubs: [AutomobileHub]
    public var strategy: ParkingStrategy = RegularParkingBoyStrategy() {
        didSet {
            strategy.input(context: hubs)
        }
    }
    
    public init(hubs: [AutomobileHub]) throws {
        let both = hubs.contains(where: {$0 is ParkingBoy}) && hubs.contains(where: {$0 is ParkingLot})
        guard both == false else {
            throw ParkingManagerError.both
        }
        self.hubs = hubs
        
        strategy.input(context: hubs)
    }
    
    public func park(_ car: Car) throws -> Ticket {
        guard hubs.count > 0 else {
            throw ParkingManagerError.noAutomobileHub
        }
        return try strategy.park(car)
    }
    
    public func pickUp(_ ticket: Ticket) throws -> Car {
        return try strategy.pickUp(ticket)
    }
    
    public func contains(_ ticket: Ticket) -> Bool {
        hubs.contains(where: {$0.contains(ticket)})
    }
    
    public func isFull() -> Bool {
        hubs.reduce(true, { $0 && $1.isFull()})
    }
    
    public func freeSize() -> Int {
        hubs.reduce(0, { $0 + $1.freeSize()})
    }
    
    public func vacancyRate() -> Float {
        return 0
    }
}
