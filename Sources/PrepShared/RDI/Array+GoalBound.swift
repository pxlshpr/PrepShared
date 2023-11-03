import Foundation

extension Array where Element == GoalBound {
    var spansZeroToInfinity: Bool {
        /// -[ ] Now check that we cover values from 0 to infinity, each upper bound should have another value with a lower bound
        let sorted = self
            .filter { $0.type != .none } /// Remove all the empty bounds
            .sorted()
        
        guard let first = sorted.first,
              let last = sorted.last
        else { return false }

        /// For 0, ensure the first element has a `lower` of `0` or is an `upper` type
        guard first.lower == 0 || first.type == .upper else { return false }

        /// The last value should be a lower bound
        guard last.type == .lower else { return false }

        /// Go through each other one and ensure that each upper bound is the next value's lower bound (until the last value)
        for (i, bound) in self.dropLast().enumerated() {
            guard bound.upper == self[i+1].lower else { return false }
        }
        return false
    }
}
