import Foundation

extension GoalBound: Comparable {
    public static func <(lhs: GoalBound, rhs: GoalBound) -> Bool {
        /// Test this
        /**
         b(0, 0.5)
         b(0.5, 1.0)
         b(1, 4)
         b(4, 9)
         b(9, 14)
         b(14, 19)
         l(19)
         */
        switch (lhs.lower, lhs.upper, rhs.lower, rhs.upper) {
//        case (.closed, .closed):
        case (.some(let ll), .some(let lu), .some(let rl), .some(let ru)):
            if ll == rl {
                lu < ru
            } else {
                ll < rl
            }

//        case (.closed, .upper):
        case (.some, .some(let lu), .none, .some(let ru)):
            if lu == ru {
                false /// closed bounds always after upper bounds
            } else {
                lu < ru
            }

//        case (.closed, .lower):
        case (.some(let ll), .some, .some(let rl), .none):
            if ll == rl {
                true /// closed bounds always before lower bounds
            } else {
                ll < rl
            }
            
//        case (.closed, .none):
        case (.some, .some, .none, .none):
            true /// empty bounds always at the end
            
//        case (.upper, .closed):
        case (.none, .some(let lu), .some, .some(let ru)):
            if lu == ru {
                true /// closed bounds always after upper bounds
            } else {
                lu < ru
            }
            
//        case (.upper, .upper):
        case (.none, .some(let lu), .none, .some(let ru)):
            lu < ru
            
//        case (.upper, .lower):
        case (.none, .some(let lu), .some(let rl), .none):
            if lu == rl {
                true /// upper always before lower
            } else {
                lu < rl
            }
            
//        case (.upper, .none):
        case (.none, .some, .none, .none):
            true /// empty bounds always at the end

//        case (.lower, .closed):
        case (.some(let ll), .none, .some(let rl), .some):
            if ll == rl {
                false /// closed bounds always before lower bounds
            } else {
                ll < rl
            }

//        case (.lower, .upper):
        case (.some(let ll), .none, .none, .some(let ru)):
            if ll == ru {
                false /// upper always before lower
            } else {
                ll < ru
            }

//        case (.lower, .lower):
        case (.some(let ll), .none, .some(let rl), .none):
            ll < rl

//        case (.lower, .none):
        case (.some, .none, .none, .none):
            true /// empty bounds always at the end

//        case (.none, .closed):
        case (.none, .none, .some, .some):
            true /// empty bounds always at the end

//        case (.none, .upper):
        case (.none, .none, .none, .some):
            true /// empty bounds always at the end

//        case (.none, .lower):
        case (.none, .none, .some, .none):
            true /// empty bounds always at the end

//        case (.none, .none):
        case (.none, .none, .none, .none):
            true /// empty bounds always at the end
        }
    }
}
