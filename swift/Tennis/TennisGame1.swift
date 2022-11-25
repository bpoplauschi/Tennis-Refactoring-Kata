import Foundation

class TennisGame1: TennisGame {
    final class Player {
        let name: String
        var score: Int
        
        init(name: String, score: Int = 0) {
            self.name = name
            self.score = score
        }
    }
    
    private let player1: Player
    private let player2: Player
    
    required init(player1: String, player2: String) {
        self.player1 = Player(name: player1)
        self.player2 = Player(name: player2)
    }

    func wonPoint(_ playerName: String) {
        if playerName == player1.name {
            player1.score += 1
        } else {
            player2.score += 1
        }
    }
    
    private func scoreIsEqual() -> Bool { player1.score == player2.score }
    
    private func singleScoreDescription() -> String {
        let result: String
        switch player1.score {
        case 0: result = "Love-All"
        case 1: result = "Fifteen-All"
        case 2: result = "Thirty-All"
        default: result = "Deuce"
        }
        return result
    }
    
    private func scoreIsAdvantageOrWin() -> Bool { player1.score >= 4 || player2.score >= 4 }
    
    private func scoreDescriptionAdvantageOrWin() -> String {
        let result: String
        let minusResult = player1.score - player2.score
        if minusResult==1 { result = "Advantage player1" }
        else if minusResult  == -1 { result = "Advantage player2" }
        else if minusResult>=2 { result = "Win for player1" }
        else { result = "Win for player2" }
        return result
    }
    
    private func scoreDescription() -> String {
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
    
    var score: String? {
        var score = ""
        if scoreIsEqual() {
            score = singleScoreDescription()
        } else if scoreIsAdvantageOrWin() {
            score = scoreDescriptionAdvantageOrWin()
        } else {
            score = scoreDescription()
        }
        return score
    }
}
