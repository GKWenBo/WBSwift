import UIKit

/*
 Using associated enum values is a super nice way to encapsulate mutually exclusive state info (and avoiding state-specific optionals).
 */

// BEFORE: Lots of state-specific, optional properties

class Player {
    var isWaitingForMatchMaking: Bool
    var invitingUser: User?
    var numberOfLives: Int
    var playerDefeatedBy: Player?
    var roundDefeatedIn: Int?
}

// AFTER: All state-specific information is encapsulated in enum cases

class Player {
    enum State {
        case waitingForMatchMaking
        case waitingForInviteResponse(from: User)
        case active(numberOfLives: Int)
        case defeated(by: Player, roundNumber: Int)
    }
    
    var state: State
}
