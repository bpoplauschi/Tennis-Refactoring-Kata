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
    func scoreDescription(player1: Player, player2: Player) -> String
}

extension Rule {
    private var minScoreToWin: Int { 4 }
    private var scoreDifferenceToWin: Int { 2 }
    
    func atLeastOneWinnableScore(score1: Int, score2: Int) -> Bool {
        score1 >= minScoreToWin || score2 >= minScoreToWin
    }
    
    func isScoreDifferenceEnoughToWin(score1: Int, score2: Int) -> Bool {
        scoreDifference(score1: score1, score2: score2) >= scoreDifferenceToWin
    }
    
    func isScoreDifferenceNotEnoughToWin(score1: Int, score2: Int) -> Bool {
        !isScoreDifferenceEnoughToWin(score1: score1, score2: score2)
    }
}

extension Player {
    private var scoreDescriptions: [String] { ["Love", "Fifteen", "Thirty", "Forty", "Advantage"] }
    var scoreDescription: String { scoreDescriptions[score] }
}

func scoreDifference(score1: Int, score2: Int) -> Int {
    abs(score1 - score2)
}

final class TieRule: Rule {
    func isSatisfied(score1: Int, score2: Int) -> Bool { score1 == score2 }
    
    func scoreDescription(player1: Player, player2: Player) -> String {
        let formattedScore: String = player1.scoreDescription + "-All"
        return applyTennisTerms(score: formattedScore)
    }
    
    private func applyTennisTerms(score: String) -> String {
        switch score {
        case "Forty-All": return "Deuce"
        case "Advantage-All": return "Deuce"
        default: return score
        }
    }
}

func playerAhead(_ player1: Player, _ player2: Player) -> String {
    player1.score > player2.score ? player1.name : player2.name
}

final class WinRule: Rule {
    func isSatisfied(score1: Int, score2: Int) -> Bool {
        guard atLeastOneWinnableScore(score1: score1, score2: score2) else { return false }
        return isScoreDifferenceEnoughToWin(score1: score1, score2: score2)
    }
    
    func scoreDescription(player1: Player, player2: Player) -> String {
        return "Win for \(playerAhead(player1, player2))"
    }
}

final class AdvantageRule: Rule {
    func isSatisfied(score1: Int, score2: Int) -> Bool {
        guard atLeastOneWinnableScore(score1: score1, score2: score2) else { return false }
        return isScoreDifferenceNotEnoughToWin(score1: score1, score2: score2)
    }
    
    func scoreDescription(player1: Player, player2: Player) -> String {
        return "Advantage \(playerAhead(player1, player2))"
    }
}

final class ScoreRule: Rule {
    func isSatisfied(score1: Int, score2: Int) -> Bool { true }
    
    func scoreDescription(player1: Player, player2: Player) -> String {
        player1.scoreDescription + "-" + player2.scoreDescription
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
        guard let rule = rules.first(where: { $0.isSatisfied(score1: player1.score, score2: player2.score) }) else { return "" }
        return rule.scoreDescription(player1: player1, player2: player2)
    }
}
