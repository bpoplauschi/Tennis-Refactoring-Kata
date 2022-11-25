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
    
    private func isEqualScore() -> Bool { player1.score == player2.score }
    
    private func scoreDescription(for player: Player) -> String {
        let result: String
        switch player.score {
        case 0: result = "Love-All"
        case 1: result = "Fifteen-All"
        case 2: result = "Thirty-All"
        default: result = "Deuce"
        }
        return result
    }
    
    var score: String? {
        var score = ""
        var tempScore = 0
        if isEqualScore() {
            score = scoreDescription(for: player1)
        }
        else if player1.score>=4 || player2.score>=4
        {
            let minusResult = player1.score-player2.score
            if minusResult==1 { score = "Advantage player1" }
            else if minusResult  == -1 { score = "Advantage player2" }
            else if minusResult>=2 { score = "Win for player1" }
            else { score = "Win for player2" }
        }
        else
        {
            for i in 1..<3
            {
                if i==1 { tempScore = player1.score }
                else { score = "\(score)-"; tempScore = player2.score }
                switch tempScore
                {
                case 0:
                    score = "\(score)Love"

                case 1:
                    score = "\(score)Fifteen"

                case 2:
                    score = "\(score)Thirty"

                case 3:
                    score = "\(score)Forty"

                default:
                    break

                }
            }
        }
        return score
    }
    
    
}
