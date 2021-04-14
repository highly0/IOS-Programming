//
//  BoardView.swift
//  Assign3
//
//  Created by Hai Le on 4/12/21.
//

import SwiftUI
var x = 1
var offSet:CGFloat = -180
struct BoardView: View {
    @State var tileArray: [[TileView]] = Array(repeating: Array(repeating: TileView(tile: Tile(val:0, id:0,row: 0, col: 0), isPortrait: true), count: 4), count: 4)
    @Environment(\.verticalSizeClass) var verticalSizeClass : UserInterfaceSizeClass?
    
    @State var isRand:Bool = false
    @ObservedObject var MyRoot:Root = Root()
    @EnvironmentObject var listArr:ScoreList // list of scores
    

    
    func updateArray(_ flag:Bool) {
        for i in 0...3 {
            for j in 0...3 {
                tileArray[i][j] = TileView(tile: MyRoot.trip.board[i][j], isPortrait: flag)
            }
        }
    }
    
    func updateBoard() {
        for i in 0...3 {
            for j in 0...3 {
                MyRoot.trip.board[i][j] =
                    Tile(
                        val: tileArray[i][j].tile.val,
                        id:tileArray[i][j].tile.id,
                        row:tileArray[i][j].tile.row,
                        col:tileArray[i][j].tile.col)
            }
        }
    }
    
    func printVal() {
        for i in 0...3 {
            for j in 0...3 {
                print(tileArray[i][j].tile.val)
            }
        }
    }
    
    func printValBoard() {
        for i in 0...3 {
            for j in 0...3 {
                print(MyRoot.trip.board[i][j].val)
            }
        }
    }
    
    var body: some View {
        //portrait mode
        if(verticalSizeClass == .regular) {
            NavigationView {
                ZStack {
                    //the background
                    Rectangle()
                        .frame(width: 330, height: 330)
                        .foregroundColor(Color.blue.opacity(0.2))
                        .cornerRadius(5).foregroundColor(.white)
                        .shadow(radius: 2)
                        .offset(y: offSet)
                    
                    
                    
                    GameGrid(offX:0, offY: offSet, isPortrait: true, MyBoard: $MyRoot.trip, tileArr: tileArray)
                        .onAppear(perform: {
                            print("game grid")
                            printVal()
                            updateArray(true)
                            
                        })
                    
                    // only allow instructions if game is not over
                    if(MyRoot.gameover == false) {
                        GameInstruction(0, offSet + 270, $tileArray, $MyRoot.trip, $MyRoot.score, $MyRoot.gameover, $MyRoot.toggle, true)
                            .onAppear(perform: {
                                print("")
                                print("game instruction")
                                printValBoard()
                            })
                    }
                    
                    Text("Score: \(MyRoot.trip.score)")
                        .fontWeight(.bold)
                        .font(.title)
                        .offset(y: -375)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                    
                    
                    VStack {
                        if(isRand) {
                            Text("Random")
                                .foregroundColor(.blue)
                        } else {
                            Text("Deterministic")
                                .foregroundColor(.blue)
                        }
                    }.offset( x: -50,y: offSet + 470)
                    
                    Toggle(isOn: $isRand) {
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                    .offset( x: 40, y: offSet + 470)
                    .labelsHidden()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                        .foregroundColor(isRand ? .blue : .gray)
                        .offset(x: 40, y: offSet + 470)
                    )
                    
                    // game over pop up
                    if(MyRoot.gameover == true) {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.white)
                            .frame(width: 300, height: 300)
                            .offset(y: -85)
                            .shadow(radius: 5)
                        Text("Gameover")
                            .font(.system(size: 35, weight: .heavy, design: .default))
                            .offset(y: -200)
                            .foregroundColor(Color.blue)
                        Text("Score: \(MyRoot.score)")
                            .font(.system(size: 20, weight: .heavy, design: .default))
                            .offset(y: -100)
                        
                        Button(action: {
                            // adding the score to the high score page
                            listArr.scoreList.append(Score(score: MyRoot.score, time: Date()))
                            listArr.scoreList.sort { $0.score > $1.score }
                            
                            MyRoot.trip.newgame(isRand)
                            
                            updateArray(true)
                            MyRoot.score = MyRoot.trip.score
                            MyRoot.gameover = false

                            print("in restart")
                        }) {
                             Text("Restart")
                                .foregroundColor(Color.white)
                        }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                    }

                    if isRand {
                        NewGame(offX: 0, offY: offSet + 400, rand: true, orientation: true,  MyBoard: $MyRoot.trip, score: $MyRoot.score, toggle: $MyRoot.toggle, gameover: $MyRoot.gameover, tileArr: $tileArray)
                    } else {
                        NewGame(offX: 0, offY: offSet + 400,  rand: false, orientation: true, MyBoard: $MyRoot.trip, score: $MyRoot.score, toggle: $MyRoot.toggle, gameover: $MyRoot.gameover, tileArr: $tileArray)
                    }
                }
            }
            .onAppear(perform: {
                print("here in horizontal")
            })
            // for the swiping gestures
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                        print("left")
                        MyRoot.trip.collapse(dir: .left)
                        MyRoot.trip.spawn(true)
                        MyRoot.score =  MyRoot.trip.score
                        MyRoot.gameover =  MyRoot.trip.GameOver()
                        
                        MyRoot.toggle = !MyRoot.toggle
                        updateArray(true)
                    }

                    if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                        print("right")
                        MyRoot.trip.collapse(dir: .right)
                        MyRoot.trip.spawn(true)
                        MyRoot.score =  MyRoot.trip.score
                        
                        MyRoot.gameover =  MyRoot.trip.GameOver()
                        MyRoot.toggle = !MyRoot.toggle
                        updateArray(true)
                    }
                    if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                        print("up")
                        MyRoot.trip.collapse(dir: .up)
                        MyRoot.trip.spawn(true)
                        MyRoot.score =  MyRoot.trip.score
                        MyRoot.gameover =  MyRoot.trip.GameOver()
                        
                        MyRoot.toggle = !MyRoot.toggle
                        updateArray(true)
                    }
                    if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                        print("down")
                        MyRoot.trip.collapse(dir: .down)
                        MyRoot.trip.spawn(true)
                        MyRoot.score =  MyRoot.trip.score
                        MyRoot.gameover =  MyRoot.trip.GameOver()
                        MyRoot.toggle = !MyRoot.toggle
                        updateArray(true)
                    }
                })
            )
        } else {
            NavigationView {
                ZStack {
                    Rectangle()
                        .frame(width: 220, height: 220)
                        .foregroundColor(Color.blue.opacity(0.2))
                        .cornerRadius(5).foregroundColor(.white)
                        .offset(x:-180, y: 10)
                    
                    // only allow instructions if game is not over
                    if(MyRoot.gameover == false) {
                        GameInstruction(100, 0, $tileArray, $MyRoot.trip, $MyRoot.score, $MyRoot.gameover, $MyRoot.toggle, false)
                    }
                    
                    Text("Score: \(MyRoot.trip.score)")
                        .fontWeight(.bold)
                        .font(.title)
                        .offset(x:-180, y: -130)
                        .font(.system(size: 20))
                        .foregroundColor(.blue)
                    
                    GameGrid(offX: -180, offY: 10, isPortrait: false, MyBoard: $MyRoot.trip, tileArr: tileArray)
                        .onAppear(perform: {
                            updateArray(false)
                        })
                    
                    VStack {
                        if(isRand) {
                            Text("Random")
                                .foregroundColor(.blue)
                        } else {
                            Text("Deterministic")
                                .foregroundColor(.blue)
                        }
                    }.offset(x: 70 ,y: 120)
                    
                    
                    Toggle(isOn: $isRand) {
                    }
                    .toggleStyle(SwitchToggleStyle(tint: Color.blue))
                    .offset( x: 170, y: 120)
                    .labelsHidden()
                    .overlay(
                        RoundedRectangle(cornerRadius: 15)
                        .stroke(lineWidth: 2)
                        .foregroundColor(isRand ? .blue : .gray)
                        .offset(x: 170, y: 120)
                    )
                    
                    // game over pop up
                    if(MyRoot.gameover == true) {
                        RoundedRectangle(cornerRadius: 25, style: .continuous)
                            .fill(Color.white)
                            .frame(width: 300, height: 300)
                            .offset(x:-140, y: -10)
                            .shadow(radius: 5)
                        Text("Gameover")
                            .font(.system(size: 35, weight: .heavy, design: .default))
                            .offset(x:-140, y: -100)
                            .foregroundColor(Color.blue)
                        Text("Score: \(MyRoot.score)")
                            .font(.system(size: 20, weight: .heavy, design: .default))
                            .offset(x:-140, y: -50)
                        
                        Button(action: {
                            // adding the score to the high score page
                            listArr.scoreList.append(Score(score: MyRoot.score, time: Date()))
                            listArr.scoreList.sort { $0.score > $1.score }
                            updateArray(false)
                            
                            MyRoot.trip = Triples()
                            MyRoot.trip.newgame(true)
                            MyRoot.score = MyRoot.trip.score
                            MyRoot.gameover = false
                            MyRoot.toggle = !MyRoot.toggle

                            print("\(MyRoot.trip.score)")
                            
                        })
                            {
                                 Text("Restart")
                                    .foregroundColor(Color.white)
                            }
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(8)
                        .offset(x:-140, y: -10)
                    }
                    
                    if isRand {
                        NewGame(offX: 300, offY: offSet + 180, rand: true, orientation: false, MyBoard: $MyRoot.trip, score: $MyRoot.score, toggle: $MyRoot.toggle, gameover: $MyRoot.gameover, tileArr: $tileArray)
                    } else {
                        NewGame(offX: 300, offY: offSet + 180, rand: false, orientation: false, MyBoard: $MyRoot.trip, score: $MyRoot.score, toggle: $MyRoot.toggle, gameover: $MyRoot.gameover, tileArr: $tileArray)
                    }
                }
                /*
                .onAppear(perform: {
                    updateArray(false)
                }) */
            }.onAppear(perform: {
                print("here in vertical")
            })

            // for the swiping gestures
            .gesture(DragGesture(minimumDistance: 3.0, coordinateSpace: .local)
                .onEnded({ value in
                    if value.translation.width < 0 && value.translation.height > -30 && value.translation.height < 30 {
                        print("left")
                        MyRoot.trip.collapse(dir: .left)
                        MyRoot.trip.spawn(true)
                        MyRoot.score =  MyRoot.trip.score
                        MyRoot.gameover =  MyRoot.trip.GameOver()
                        MyRoot.toggle = !MyRoot.toggle
                        updateArray(false)
                    }

                    if value.translation.width > 0 && value.translation.height > -30 && value.translation.height < 30 {
                        print("right")
                        MyRoot.trip.collapse(dir: .right)
                        MyRoot.trip.spawn(true)
                        MyRoot.score =  MyRoot.trip.score
                        MyRoot.gameover =  MyRoot.trip.GameOver()
                        MyRoot.toggle = !MyRoot.toggle
                        updateArray(false)
                    }
                    if value.translation.height < 0 && value.translation.width < 100 && value.translation.width > -100 {
                        print("up")
                        MyRoot.trip.collapse(dir: .up)
                        MyRoot.trip.spawn(true)
                        MyRoot.score =  MyRoot.trip.score
                        MyRoot.gameover =  MyRoot.trip.GameOver()
                        MyRoot.toggle = !MyRoot.toggle
                        updateArray(false)
                    }
                    if value.translation.height > 0 && value.translation.width < 100 && value.translation.width > -100 {
                        print("down")
                        MyRoot.trip.collapse(dir: .down)
                        MyRoot.trip.spawn(true)
                        MyRoot.score =  MyRoot.trip.score
                        MyRoot.gameover =  MyRoot.trip.GameOver()
                        MyRoot.toggle = !MyRoot.toggle
                        updateArray(false)
                    }
                })
            )
        }
    }
}



struct GameGrid: View {
    var offX:CGFloat
    var offY:CGFloat
    var isPortrait:Bool
    @Binding var MyBoard: Triples
    var tileArr:[[TileView]]
    
    var body: some View {
        VStack (spacing: 10) {
            ForEach(0...3, id:\.self) { row in
                HStack (spacing: 10) {
                    ForEach(0...3, id:\.self) { column in
                        tileArr[row][column]
                            .offset(x: offX, y: offY)
                    }
                }

            }
        }
    }
}

struct GameInstruction: View {
    var offX:CGFloat
    var offY:CGFloat
    @Binding var MyBoard:Triples
    @Binding var score:Int
    @Binding var gameover: Bool
    @Binding var toggle:Bool
    @Binding var tileArr:[[TileView]]
    var flag:Bool
    
    init(_ offX:CGFloat, _ offY:CGFloat, _ tileArr:Binding<[[TileView]]>,_ MyBoard:Binding<Triples>, _ score:Binding<Int>, _ gameover:Binding<Bool>, _ toggle:Binding<Bool>, _ flag: Bool) {
        self.offX = offX
        self.offY = offY
        self._MyBoard = MyBoard
        self._score = score
        self._gameover = gameover
        self._toggle = toggle
        self._tileArr = tileArr
        self.flag = flag
    }
    
    func updateArr(_ flag:Bool) {
        for i in 0...3 {
            for j in 0...3 {
                tileArr[i][j] = TileView(tile: MyBoard.board[i][j], isPortrait: flag)
            }
        }
    }
    func printArray(_ arr:[[TileView]]) {
        for i in 0...3 {
            for j in 0...3 {
                print(MyBoard.board[i][j])
                print(arr[i][j].tile)
            }
        }
    }
    
    var body: some View {
        VStack(spacing:15) {
            Button(action: {
                print("Press Left ")
                MyBoard.collapse(dir: .up)
                MyBoard.spawn(true)
                score = MyBoard.score
                gameover = MyBoard.GameOver()
               
                updateArr(flag)

                toggle = !toggle
            }) {
                 Text("Up")
                    .foregroundColor(Color.white)
            }
            .frame(width: 90, height: 50)
            .background(Color.blue.opacity(0.4))
            .cornerRadius(5).foregroundColor(.white)
            
            HStack(spacing: 15) {
                Button(action: {
                    print("Press Left ")
                    MyBoard.collapse(dir: .left)
                    MyBoard.spawn(true)
                    score = MyBoard.score
                    gameover = MyBoard.GameOver()
                    
                    updateArr(flag)
                    toggle = !toggle
                }) {
                     Text("Left")
                        .foregroundColor(Color.white)
                }
                .frame(width: 90, height: 50)
                .background(Color.blue.opacity(0.4))
                .cornerRadius(5).foregroundColor(.white)
                
                Button(action: {
                    print("Press Right")
                    MyBoard.collapse(dir: .right)
                    MyBoard.spawn(true)
                    score = MyBoard.score
                    gameover = MyBoard.GameOver()
                    
                    updateArr(flag)
                    toggle = !toggle
                }) {
                    Text("Right")
                        .foregroundColor(Color.white)
                }
                .frame(width: 90, height: 50)
                .background(Color.blue.opacity(0.4))
                .cornerRadius(5).foregroundColor(.white)
            }
            
            Button(action: {
                print("Press down")
                MyBoard.collapse(dir: .down)
                MyBoard.spawn(true)
                score = MyBoard.score
                gameover = MyBoard.GameOver()
                
                updateArr(flag)
                toggle = !toggle
            }) {
                 Text("Down")
                    .foregroundColor(Color.white)
            }
            .frame(width: 90, height: 50)
            .background(Color.blue.opacity(0.4))
            .cornerRadius(5)
        }.offset(x: offX, y: offY)
    }
}

struct NewGame : View {
    var offX:CGFloat
    var offY:CGFloat
    var rand:Bool
    var orientation:Bool
    @Binding var MyBoard:Triples
    @Binding var score:Int
    @Binding var toggle:Bool
    @Binding var gameover:Bool
    @Binding var tileArr:[[TileView]]
    var reinit:Bool?

    func updateArray(_ flag:Bool) {
        for i in 0...3 {
            for j in 0...3 {
                tileArr[i][j] = TileView(tile: MyBoard.board[i][j], isPortrait: flag)
            }
        }
    }
    func printValBoard() {
        for i in 0...3 {
            for j in 0...3 {
                print(MyBoard.board[i][j].val)
            }
        }
    }
    
    var body: some View {
        Button(action: {
            print("Press new game")
            MyBoard.newgame(rand)
            printValBoard()
            //updateArray(orientation)
            toggle = !toggle
            tileArr = Array(repeating: Array(repeating: TileView(tile: Tile(val:0, id:0,row: 0, col: 0), isPortrait: true), count: 4), count: 4)
            
            gameover = true
        }) {
             Text("New Game")
                .foregroundColor(Color.white)
        }
        .frame(width: 150, height: 50)
        .background(Color.blue.opacity(0.7))
        .cornerRadius(5).foregroundColor(.white)
        .offset(x: offX, y: offY)
    }
}


