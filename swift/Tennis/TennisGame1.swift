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
    var player1: Player { get }
    var player2: Player { get }
    var isSatisfied: Bool { get }
    var score: String { get }
    var scoreDifference: Int { get }
    
    init(player1: Player, player2: Player)
    
    func isSatisfied(score1: Int, score2: Int) -> Bool
}

extension Rule {
    var scoreDifference: Int { abs(player1.score - player2.score) }
}

final class TieRule: Rule {
    let player1: Player
    let player2: Player
    
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
    
    func isSatisfied(score1: Int, score2: Int) -> Bool { score1 == score2 }
}

final class WinRule: Rule {
    let player1: Player
    let player2: Player
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    var isSatisfied: Bool { (player1.score >= 4 || player2.score >= 4) && scoreDifference >= 2 }
    
    var score: String {
        let result: String
        let minusResult = player1.score - player2.score
        if minusResult>=2 { result = "Win for player1" }
        else { result = "Win for player2" }
        return result
    }
    
    func isSatisfied(score1: Int, score2: Int) -> Bool { (score1 >= 4 || score2 >= 4) && scoreDifference >= 2 }
}

final class AdvantageRule: Rule {
    let player1: Player
    let player2: Player
    
    init(player1: Player, player2: Player) {
        self.player1 = player1
        self.player2 = player2
    }
    
    var isSatisfied: Bool { (player1.score >= 4 || player2.score >= 4) && scoreDifference < 2 }
    
    var score: String {
        let result: String
        let minusResult = player1.score - player2.score
        if minusResult==1 { result = "Advantage player1" }
        else { result = "Advantage player2" }
        return result
    }
    
    func isSatisfied(score1: Int, score2: Int) -> Bool { (score1 >= 4 || score2 >= 4) && scoreDifference < 2 }
}

final class ScoreRule: Rule {
    let player1: Player
    let player2: Player
    
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
    
    func isSatisfied(score1: Int, score2: Int) -> Bool { true }
}

class TennisGame1: TennisGame {
    private let player1: Player
    private let player2: Player
    private let rules: [Rule]
    static var ruleTypes: [Rule.Type] = [TieRule.self, WinRule.self, AdvantageRule.self, ScoreRule.self]
    
    required init(player1: String, player2: String) {
        let playerOne = Player(name: player1)
        let playerTwo = Player(name: player2)
        self.rules = TennisGame1.ruleTypes.map { $0.init(player1: playerOne, player2: playerTwo) }
        self.player1 = playerOne
        self.player2 = playerTwo
    }

    func wonPoint(_ playerName: String) {
        if playerName == player1.name {
            player1.wonPoint()
        } else if playerName == player2.name {
            player2.wonPoint()
        }
    }
        
    var score: String? {
        if let rule = rules.first(where: { $0.isSatisfied(score1: player1.score, score2: player2.score) }) {
            return rule.score
        }
        return ""
    }
}
