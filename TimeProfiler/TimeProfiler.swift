//
//  TimeProfiler.swift
//  TimeProfiler
//
//  Created by Stephen Wu on 4/3/19.
//  Copyright © 2019 Stephen Wu. All rights reserved.
//

import Foundation
import Dispatch

/// Utility for measuring runtime performance and time differences
public class TimeProfiler {

    /// Description of the code being timed
    private let description: String
    /// The time at which the profiler was started
    private var startTime: DispatchTime?
    /// The time at which the profiler was stopped
    private var endTime: DispatchTime?
    /// Total runtime in nanoseconds
    public var runtime: Double {
        guard let startTime = startTime else { fatalError("Time profiler was not started") }
        guard let endTime = endTime else { fatalError("Time profiler has not been stopped." )}

        return Double(bitPattern: endTime.uptimeNanoseconds - startTime.uptimeNanoseconds)
    }

    /// - Parameter description: A description of the code being timed
    public init(description: String = "") {
        self.description = description
    }

    /// Starts the time profiler
    @discardableResult
    public func start(logged: Bool = false) -> TimeProfiler {
        if logged { print("Started", description) }
        startTime = .now()
        return self
    }

    /// Stops the time profiler
    @discardableResult
    public func stop(logged: Bool = false) -> TimeProfiler {
        if logged { print("Stopped", description) }
        endTime = .now()
        return self
    }

    /// Executes a block of code
    @discardableResult
    public func execute(logged: Bool = false, _ block: () -> Void) -> TimeProfiler {
        if logged { print("Running", description) }
        block()
        return self
    }

    /// Report the total runtime
    @discardableResult
    public func report(message: String? = nil) -> TimeProfiler {
        let message = message ?? "Measured \(description)"
        print(message, "- Total runtime:", runtime)
        return self
    }

    /// Convenience method to start, execute, and stop time profiling a block of code
    ///
    /// - Parameters:
    ///   - description: A description of the code being measured
    ///   - logged: Whether or not to report the individual steps of the measurement
    ///   - block: The code to profile
    @discardableResult
    public func measure(logged: Bool = false, _ block: () -> Void) -> TimeProfiler {
        return self
            .start(logged: logged)
            .execute(logged: logged, block)
            .stop(logged: logged)
    }
}
