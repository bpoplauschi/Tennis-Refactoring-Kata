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
    func isSatisfied(score1: Int, score2: Int) -> Bool
    func scoreDescription(score1: Int, score2: Int) -> String
}

extension Rule {
    var minScoreToWin: Int { 4 }
    var scoreDifferenceToWin: Int { 2 }
    
    func atLeastOneWinnableScore(score1: Int, score2: Int) -> Bool {
        score1 >= minScoreToWin || score2 >= minScoreToWin
    }
}

func scoreDifference(score1: Int, score2: Int) -> Int {
    abs(score1 - score2)
}

final class TieRule: Rule {
    func isSatisfied(score1: Int, score2: Int) -> Bool { score1 == score2 }
    
    func scoreDescription(score1: Int, score2: Int) -> String {
        let result: String
        switch score1 {
        case 0: result = "Love-All"
        case 1: result = "Fifteen-All"
        case 2: result = "Thirty-All"
        default: result = "Deuce"
        }
        return result
    }
}

final class WinRule: Rule {
    func isSatisfied(score1: Int, score2: Int) -> Bool {
        guard atLeastOneWinnableScore(score1: score1, score2: score2) else { return false }
        return scoreDifference(score1: score1, score2: score2) >= scoreDifferenceToWin
    }
    
    func scoreDescription(score1: Int, score2: Int) -> String {
        let result: String
        let minusResult = score1 - score2
        if minusResult>=2 { result = "Win for player1" }
        else { result = "Win for player2" }
        return result
    }
}

final class AdvantageRule: Rule {
    func isSatisfied(score1: Int, score2: Int) -> Bool {
        guard atLeastOneWinnableScore(score1: score1, score2: score2) else { return false }
        return scoreDifference(score1: score1, score2: score2) < scoreDifferenceToWin
    }
    
    func scoreDescription(score1: Int, score2: Int) -> String {
        let result: String
        let minusResult = score1 - score2
        if minusResult==1 { result = "Advantage player1" }
        else { result = "Advantage player2" }
        return result
    }
}

final class ScoreRule: Rule {
    func isSatisfied(score1: Int, score2: Int) -> Bool { true }
    
    func scoreDescription(score1: Int, score2: Int) -> String {
        var tempScore = 0
        var result = ""
        for i in 1..<3 {
            if i==1 { tempScore = score1 }
            else { result = "\(result)-"; tempScore = score2 }
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
    var rules: [Rule] = [TieRule(), WinRule(), AdvantageRule(), ScoreRule()]
    
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
        if let rule = rules.first(where: { $0.isSatisfied(score1: player1.score, score2: player2.score) }) {
            return rule.scoreDescription(score1: player1.score, score2: player2.score)
        }
        return ""
    }
}
