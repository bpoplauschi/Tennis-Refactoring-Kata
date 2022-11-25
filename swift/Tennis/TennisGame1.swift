import Foundation

final class Player {
    let name: String
    var score: Int
    
    init(name: String, score: Int = 0) {
        self.name = name
        self.score = score
    }
    
    func wonPoint() { score += 1 }
}

protocol Rule {
    var isSatisfied: Bool { get }
    var score: String { get }
}

final class TieRule: Rule {
    private let player1: Player
    private let player2: Player
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    var isSatisfied: Bool { player1.score == player2.score }
    
    var score: String {
        let result: String
        switch player1.score {
        case 0: result = "Love-All"
        case 1: result = "Fifteen-All"
        case 2: result = "Thirty-All"
        default: result = "Deuce"
        }
        return result
    }
}

final class AdvantageOrWinRule: Rule {
    private let player1: Player
    private let player2: Player
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    var isSatisfied: Bool { player1.score >= 4 || player2.score >= 4 }
    
    var score: String {
        let result: String
        let minusResult = player1.score - player2.score
        if minusResult==1 { result = "Advantage player1" }
        else if minusResult  == -1 { result = "Advantage player2" }
        else if minusResult>=2 { result = "Win for player1" }
        else { result = "Win for player2" }
        return result
    }
}

final class ScoreRule: Rule {
    private let player1: Player
    private let player2: Player
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    var isSatisfied: Bool { true }
    
    var score: String {
        var tempScore = 0
        var result = ""
        for i in 1..<3 {
            if i==1 { tempScore = player1.score }
            else { result = "\(result)-"; tempScore = player2.score }
            switch tempScore {
            case 0: result = "\(result)Love"
            case 1: result = "\(result)Fifteen"
            case 2: result = "\(result)Thirty"
            case 3: result = "\(result)Forty"
            default: break
            }
        }
        return result
    }
}

class TennisGame1: TennisGame {
    private let player1: Player
    private let player2: Player
    
    required init(player1: String, player2: String) {
        self.player1 = Player(name: player1)
        self.player2 = Player(name: player2)
    }

    func wonPoint(_ playerName: String) {
        if playerName == player1.name {
            player1.wonPoint()
        } else if playerName == player2.name {
            player2.wonPoint()
        }
    }
        
    var score: String? {
        let tieRule = TieRule(player1: player1, player2: player2)
        let advantageOrWinRule = AdvantageOrWinRule(player1: player1, player2: player2)
        let scoreRule = ScoreRule(player1: player1, player2: player2)
        var score = ""
        if tieRule.isSatisfied {
            score = tieRule.score
        } else if advantageOrWinRule.isSatisfied {
            score = advantageOrWinRule.score
        } else if scoreRule.isSatisfied {
            score = scoreRule.score
        }
        return score
    }
}
