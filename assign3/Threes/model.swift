//
//  model.swift
//  assign3
//
//  Created by Yan Pinglan on 4/17/22.
//

import Foundation

var myEncoder = JSONEncoder()
var myDecoder = JSONDecoder()

struct ScoreTable: Hashable, Identifiable, Codable {
    
    var myScore: Int
    var time: String
    var id: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(time)
    }
    
    init(id: Int, myScore: Int, time: String) {
        self.myScore = myScore
        self.time = time
        self.id = id
    }
}


struct Tile: Identifiable {
    var val: Int
    var id: Int = 0
    var row: Int
    var col: Int
    
    init(val: Int, id: Int, row: Int, col: Int) {
        self.val = val
        self.id = id
        self.row = row
        self.col = col
    }
}

class Triples: ObservableObject {
    @Published var board: [[Tile?]]
    @Published var singleRow: [Tile]
    @Published var score: Int
    @Published var rand: Bool
    @Published var collapeScore: Int
    @Published var isOver: Bool
    
    @Published var dateArr: [ScoreTable]
    
    var seedFlag: SeededGenerator
    
    var count: Int = 0
    var scoreID: Int = 3
 
    //need to determine if game is over in collapse
    enum Direction {
        case up
        case down
        case left
        case right
    }
    
    init(data: [ScoreTable]) {
        self.board = [[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil]]
        self.singleRow = []
        self.score = 0
        self.collapeScore = 0
        self.rand = true
        self.seedFlag = SeededGenerator(seed: UInt64(Int.random(in: 1...1000)))
        self.isOver = false
        self.dateArr = [ScoreTable.init(id: 1, myScore: 400, time: initDate()), ScoreTable.init(id: 2, myScore: 300, time: initDate())]
        for x in data {
            self.dateArr.append(ScoreTable(id: self.scoreID, myScore: x.myScore, time: initDate()))
            scoreID += 1
        }
    }
    
    init() {
        self.board = [[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil]]
        self.singleRow = []
        self.score = 0
        self.collapeScore = 0
        self.rand = true
        self.seedFlag = SeededGenerator(seed: UInt64(Int.random(in: 1...1000)))
        self.isOver = false
        self.dateArr = [ScoreTable.init(id: 1, myScore: 400, time: initDate()), ScoreTable.init(id: 2, myScore: 300, time: initDate())]
    }
    
    func dataStorage() {
        let storedScore = try! myEncoder.encode(self.dateArr)
        UserDefaults.standard.set(storedScore, forKey: "dateArr")
    }
    
    
    func idNum() -> Int {
        count += 1
        return count
    }
    
    func updateScoreView(data: ScoreTable) {
        dataStorage()
        self.dateArr.append(ScoreTable.init(id: self.count, myScore: data.myScore, time: initDate()))
        self.scoreID += 1
    }
    
    func sortScoreView() {
        dateArr = dateArr.sorted(by: { $0.myScore > $1.myScore })
    }
    
    
    func newgame(rand: Bool) {
        board = [[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil]]
        singleRow = []
        score = 0
        collapeScore = 0
        if (rand) {
            seedFlag = SeededGenerator(seed: UInt64(Int.random(in: 1...1000)))
        } else {
            seedFlag = SeededGenerator(seed: 14)
        }
        spawn()
        spawn()
        spawn()
        spawn()
        scoreCount()
        dataStorage()
        //print("\(singleRow) \n+++++++++")
    }
    
    func scoreCount() {
        //var checkList: [Tile] = []
        score = 0
        for i in 0...3 {
            for j in 0...3 {
                if board[i][j] != nil {
                    singleRow.append(board[i][j]!)
                }
            }
        }
        for i in singleRow {
            score += i.val
        }
        score += collapeScore
    }
    
    func spawn() {
        singleRow = []
        let temp = Int.random(in: 1...2, using: &seedFlag)
        var zeroNum = 0
        var createZero = [(Int, Int)]()
        for i in 0..<4 {
            for j in 0..<4 {
                if board[i][j] == nil {
                    zeroNum += 1
                    createZero.append((i, j))
                }
            }
        }
        if zeroNum != 0 {
            let index = Int.random(in: 0..<zeroNum, using: &seedFlag)
            board[createZero[index].0][createZero[index].1] = Tile(val: temp, id: idNum(), row: createZero[index].0, col: createZero[index].1)
        }
    }
    
    func checkNil(board: [[Tile?]]) -> Bool {
        var count = 0
        for i in 0..<4 {
            for j in 0..<4 {
                if board[i][j] == nil {
                    count += 1
                }
            }
        }
        if count == 0 {
            return true
        }
        else {
            return false
        }
    }
    
    func isGameOver() -> Bool {
        
        var temp1 = board
        var temp2 = board
        var temp3 = board
        var temp4 = board
        var flag = false
        var count = 0
        
        //Test Up
        temp1 = rotate2D(input: temp1)
        temp1 = rotate2D(input: temp1)
        temp1 = rotate2D(input: temp1)
        temp1 = shift2DInts(input: temp1)
        temp1 = rotate2D(input: temp1)
        //Test Down
        temp2 = rotate2D(input: temp2)
        temp2 = shift2DInts(input: temp2)
        temp2 = rotate2D(input: temp2)
        temp2 = rotate2D(input: temp2)
        temp2 = rotate2D(input: temp2)
        //Test Left
        temp3 = shift2DInts(input: temp3)
        //Test Right
        temp4 = rotate2D(input: temp4)
        temp4 = rotate2D(input: temp4)
        temp4 = shift2DInts(input: temp4)
        temp4 = rotate2D(input: temp4)
        temp4 = rotate2D(input: temp4)
        
        for i in 0...3 {
            for j in 0...3 {
                if temp1[i][j] != nil && temp2[i][j] != nil && temp3[i][j] != nil && temp4[i][j] != nil {
                    if temp1[i][j]!.val == temp2[i][j]!.val && temp1[i][j]!.val == temp3[i][j]!.val && temp1[i][j]!.val == temp4[i][j]!.val {
                        count += 1
                    }
                }
            }
        }
        
        if count == 16 {
            flag = true
        }
        
        if checkNil(board: temp1) && checkNil(board: temp2) && checkNil(board: temp3) && checkNil(board: temp4) && flag == true{
            return true
        }
        return false;
    }
    
    func rotate() {
        board = rotate2D(input: board)
    }
    
    func shift() {
        board = shift2DInts(input: board)
    }
    
    func collapse(dir: Direction) {
        isOver = false
        
        if count != 0 {
            isOver = isGameOver()
            if isOver == false {
                switch dir {
                case .up:
                    rotate_times(input: 3)
                    shift()
                    rotate_times(input: 1)
                case .down:
                    rotate_times(input: 1)
                    shift()
                    rotate_times(input: 3)
                case .left:
                    shift()
                case .right:
                    rotate_times(input: 2)
                    shift()
                    rotate_times(input: 2)
                }
                spawn()
                scoreCount()
            } else {
                //Update Score
                updateScoreView(data: ScoreTable(id: self.count, myScore: self.score, time: initDate()))
                sortScoreView()
                dataStorage()
            }
        }
    }
    
    func rotate_times(input: Int) {
        var i = 0
        while i < input {
            rotate()
            i += 1
        }
    }
    
    public func rotate2DInts(input: [[Int]]) -> [[Int]] {
        var rotated_board = input
        for i in 0...3 {
            for j in 0...3 {
                rotated_board[j][3-i] = input[i][j]
            }
        }
        return rotated_board
    }

    public func rotate2D(input: [[Tile?]]) -> [[Tile?]] {
        var rotated_board = input
        for i in 0...3 {
            for j in 0...3 {
                if input[i][j] != nil {
                    rotated_board[j][3-i] = Tile(val: input[i][j]!.val, id: idNum(), row: j, col: 3-i)
                } else {
                    rotated_board[j][3-i] = nil
                }
            }
        }
        return rotated_board
    }
    
    // class-less function that will return of any square 2D Int array rotated clockwise
    public func shift2DInts(input: [[Tile?]]) -> [[Tile?]] {
        //collaping from numbers that close to left wall
    
        //var shifted_board: [[Tile?]] = [[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil],[nil,nil,nil,nil]]
        var shifted_board: [[Tile?]] = input
        for i in 0...3 {
            for j in 0...2 {
                if shifted_board[i][j] == nil {
                    //case 1: value of index is nil and index+1 is nil
                    if input[i][j] == nil && input[i][j+1] == nil {
                        shifted_board[i][j] = nil
                        shifted_board[i][j+1] = nil
                        //do nothing, let j traverse
                    }
                    //case 2: value of index is nil and index+1 is not nil
                    else if shifted_board[i][j] == nil && shifted_board[i][j+1] != nil {
                        shifted_board[i][j] = Tile(val: input[i][j+1]!.val, id: idNum(), row: i, col: j)
                        //make index+1 nil to perform next traverse
                        shifted_board[i][j+1] = nil
                    }
                    
                //case 3: non nil + nil
                } else if shifted_board[i][j+1] == nil {
                    shifted_board[i][j] = Tile(val: input[i][j]!.val, id: idNum(), row: i, col: j)
                    shifted_board[i][j+1] = nil
                    
                //case 4: 1 + 1
                } else if shifted_board[i][j]!.val == 1 && shifted_board[i][j+1]!.val == 1 {
                    shifted_board[i][j] = Tile(val: 1, id: idNum(), row: i, col: j)
                    shifted_board[i][j+1] = Tile(val: 1, id: idNum(), row: i, col: j+1)
                    
                    //do nothing
                //case 5: 1 + 2 or 2 + 1 collapsing
                } else if (shifted_board[i][j]!.val == 1 && shifted_board[i][j+1]!.val == 2) {
                    shifted_board[i][j] = Tile(val: 3, id: idNum(), row: i, col: j)
                    shifted_board[i][j+1] = nil
                    collapeScore += 3
                    
                //case 5:
                } else if (shifted_board[i][j]!.val == 2 && shifted_board[i][j+1]!.val == 1) {
                    shifted_board[i][j] = Tile(val: 3, id: idNum(), row: i, col: j)
                    shifted_board[i][j+1] = nil
                    collapeScore += 3
                    
                //case 6: 2 + any number that greater than 2
                } else if shifted_board[i][j]!.val == 2 && shifted_board[i][j+1]!.val >= 2{
                    shifted_board[i][j] = Tile(val: 2, id: idNum(), row: i, col: j)
                    shifted_board[i][j+1] = Tile(val: input[i][j+1]!.val, id: idNum(), row: i, col: j+1)
                    
                    //do nothing
                //case 7: 1 + >=3
                } else if shifted_board[i][j]!.val == 1 && shifted_board[i][j+1]!.val >= 3 {
                    shifted_board[i][j] = Tile(val: 1, id: idNum(), row: i, col: j)
                    shifted_board[i][j+1] = Tile(val: input[i][j+1]!.val, id: idNum(), row: i, col: j+1)
                    
                    //do nothing
                //case 8: 3 + 3
                } else if shifted_board[i][j]!.val == 3 && shifted_board[i][j+1]!.val == 3 {
                    shifted_board[i][j] = Tile(val: 6, id: idNum(), row: i, col: j)
                    shifted_board[i][j+1] = nil
                    collapeScore += 6
                    
                //case 9: 3 + any number other than nil and 3
                } else if (shifted_board[i][j]!.val == 3 && shifted_board[i][j+1]!.val != 3) {
                    shifted_board[i][j] = Tile(val: input[i][j]!.val, id: idNum(), row: i, col: j)
                    shifted_board[i][j+1] = Tile(val: input[i][j+1]!.val, id: idNum(), row: i, col: j+1)
                    
                //case 10: any number greater than 3 + different number that greater than 3
                } else if (shifted_board[i][j]!.val > 3 && shifted_board[i][j+1]!.val > 3) {
                    //same number -> collaping
                    if (input[i][j]!.val == input[i][j+1]!.val) {
                        shifted_board[i][j] = Tile(val: input[i][j]!.val*2, id: idNum(), row: i, col: j)
                        shifted_board[i][j+1] = nil
                        collapeScore += input[i][j]!.val*2
                    //different number -> do nothing
                    } else {
                        shifted_board[i][j] = Tile(val: input[i][j]!.val, id: idNum(), row: i, col: j)
                        shifted_board[i][j+1] = Tile(val: input[i][j+1]!.val, id: idNum(), row: i, col: j+1)
                    }
                }
            } // j for loop end
        } // i for loop end
        
        //print("\(shifted_board)\n********")
        print("\(dateArr)\n********")
        return shifted_board
    }
}
