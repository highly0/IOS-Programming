//
//  model.swift
//  Assign3
//
//  Created by Hai Le on 4/11/21.
//

import Foundation

enum Direction {
    case up, down, left, right
}

// used for rotate
extension Array where Element : Collection {
    func getColumn(_ column : Element.Index) -> [ Element.Iterator.Element ] {
        return self.map { $0[ column ] }
    }
}

class Root: ObservableObject {
    var trip:Triples
    @Published var toggle:Bool
    @Published var score:Int
    @Published var gameover:Bool

    init() {
        toggle = false
        trip = Triples()
        trip.newgame(false)
        score = trip.score
        gameover = false
    }
}

struct SeededGenerator: RandomNumberGenerator {
    let seed: UInt64
    var curr: UInt64
    init(seed: UInt64 = 0) {
        self.seed = seed
        curr = seed
    }
    
    mutating func next() -> UInt64  {
        curr = (103 &+ curr) &* 65537
        curr = (103 &+ curr) &* 65537
        curr = (103 &+ curr) &* 65537
        return curr
    }
}

struct Tile {
    var val : Int = Int()
    var id : Int = Int()
    var row: Int = Int()
    var col: Int = Int()
}

class Triples {
    var board:[[Tile]] = [[Tile]] ()
    var score: Int = 0
    init() {
        var idx:Int = 0
        // initializing a 4x4 array
        for i in 0...3 {
            var row = [Tile] ()
            for j in 0...3 {
                row.append(Tile(val:0,id:idx,row:i,col:j))
                idx += 1
            }
            board.append(row)
        }
        newgame(false)
        score = TotalScore()
    }
    
    func newgame(_ rand: Bool) {
        board.removeAll()
        score = 0
        
        var seed: Int
        if rand {
            seed = Int.random(in: 0...1000)
        } else {
            seed = 42
        }
        srand48(seed)
        
        var idx:Int = 0
        // initializing a 4x4 array
        for i in 0...3 {
            var row = [Tile] ()
            for j in 0...3 {
                row.append(Tile(val:0,id:idx,row:i,col:j))
                idx += 1
            }
            board.append(row)
        }
        
        spawn(false)
        spawn(false)
        spawn(false)
        spawn(false)
        score = TotalScore()
    }
    
    // spawn with false -> no update score, true -> update score
    func spawn(_ flag:Bool){
        var indices: [Int] = Array()
        for i in 0...3 {
            for j in 0...3 {
                if board[i][j].val == 0 {
                    indices.append(i * 4 + j)
                }
            }
        }
        if(indices.count > 0){
            let val = prng(max: 2) + 1
            let x = indices[prng(max: indices.count)]
            board[x/4][x%4].val = val
            if flag == true {
                score += val
            }
        }
    }
    
    func prng(max: Int) -> Int {
        let ret = Int(floor(drand48() * (Double(max))))
        return (ret < max) ? ret : (ret-1)
    }
    
    func TotalScore() -> Int {
        var total:Int = 0
        for i in 0...3 {
            for j in 0...3 {
                total += board[i][j].val
            }
        }
        return total
    }
    
    func GameOver() -> Bool {
        var counter:Int = 0
        for i in 0...3 {
            for j in 0...3 {
                if board[i][j].val > 0 {
                    counter += 1
                } else {
                    return false
                }
            }
        }
        if counter == 16 {
            let copy: [[Tile]] = copy_array(array: board)
            var flag = 0

            self.collapse(dir: .left)
            if compare_array(arr1: board, arr2: copy) == true {
                flag = 1
            } else {
                flag = 0
            }
            
            // resetting to the initial board
            board = copy_array(array: copy)
            self.collapse(dir: .right)
            if compare_array(arr1: board, arr2: copy) == true {
                flag = 1
            } else {
                flag = 0
            }
            
            // resetting to the initial board
            board = copy_array(array: copy)
            self.collapse(dir: .up)
            if compare_array(arr1: board, arr2: copy) == true {
                flag = 1
            } else {
                flag = 0
            }
            
            // resetting to the initial board
            board = copy_array(array: copy)
            self.collapse(dir: .down)
            if compare_array(arr1: board, arr2: copy) == true {
                flag = 1
            } else {
                flag = 0
            }
            
            // resetting to the initial board before returning
            board = copy_array(array: copy)
            if(flag == 1) {
                return true
            } else {
                return false
            }
        } else {
            return false
        }
    }
    /*
    func shift() {
        for i in 0...3 {
            for j in 0...3 {
                if j >= 1 {
                    if board[i][j-1].val == 0 {
                        board[i][j-1].val = board[i][j].val
                        board[i][j].val = 0
                    } else if (board[i][j-1].val == board[i][j].val && board[i][j-1].val != 2 && board[i][j].val != 2) ||
                                (board[i][j-1].val == 2 && board[i][j].val == 1) ||
                                (board[i][j-1].val == 1 && board[i][j].val == 2) {
                        let temp = board[i][j-1].val
                        board[i][j-1].val = board[i][j-1].val + board[i][j].val
                        if temp != board[i][j-1].val {
                            score += temp
                        }
                        board[i][j].val = 0
                    }
                }
            }
        }
    } */
    
    func shift() {
        for i in 0...3{
            if (board[i][0].val == 0){
                for j in 0..<board.count - 1{
                    board[i][j] = board[i][j+1]
                }
                board[i][board.count - 1].val = 0
            } else {
                for k in 0..<board.count - 1 {
                    if(((board[i][k].val == 1) && (board[i][k + 1].val == 2)) ||
                        ((board[i][k].val == 2) && (board[i][k+1].val == 1)) ||
                        ((board[i][k].val >= 3) && (board[i][k+1].val == board[i][k].val)) ||
                        ((board[i][k].val) == 0))  {
                        
                        if(board[i][k].val != 0 && board[i][k+1].val != 0) {
                            score = score + board[i][k].val + board[i][k].val
                        }
                        board[i][k].val = board[i][k].val + board[i][k+1].val
                        board[i][k+1].val = 0
                    }
                }
            }
        }
    }

    
    func copy_array(array: [[Tile]]) -> [[Tile]] {
        var result:[[Tile]] = [[Tile]] ()
      
        for i in 0...3 {
            var row = [Tile] ()
            for j in 0...3 {
                row.append(Tile(val:array[i][j].val,id:array[i][j].id,row:i,col:j))
            }
            result.append(row)
        }
        
        return result
    }
    
    // return true if 2 arrays are the same
    func compare_array(arr1: [[Tile]], arr2: [[Tile]]) -> Bool {
        for i in 0...3 {
            for j in 0...3 {
                if arr1[i][j].val != arr2[i][j].val {
                    return false
                }
            }
        }
        return true
    }
    
    func collapse(dir: Direction) {
        switch dir{
        case .left:
            shift()
        case .right:
            rotate()
            rotate()
            shift()
            rotate()
            rotate()
        case .up:
            rotate()
            rotate()
            rotate()
            shift()
            rotate()
        case .down:
            rotate()
            shift()
            rotate()
            rotate()
            rotate()
        }
    }
    
    func rotate() {
        board = rotate2D(input: board)
    }
}

func rotate2DInts(input: Array<Array<Int>>) -> Array<Array<Int>>{
    return rotate2D(input: input)
}

func rotate2D<T>(input: Array<Array<T>>) -> Array<Array<T>> {
    var result = Array<Array<T>>()

    result.append(reverse(input.getColumn(0)))
    result.append(reverse(input.getColumn(1)))
    result.append(reverse(input.getColumn(2)))
    result.append(reverse(input.getColumn(3)))
    
    return result
}

func reverse<T>(_ input: Array<T>) -> Array<T> {
    var result = Array<T>()
    for i in stride(from: input.count - 1, through: 0, by: -1) {
        result.append(input[i])
    }
    return result
}

