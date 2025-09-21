import SwiftUI

struct ContentView: View {
    
    @State var questions : [Question] = [
        
        Question(scrambledWord: ["G", "E", "A", "N", "R", "O"], answer: "ORANGE", size: 6, image: "orange"),
        
        Question(
            scrambledWord: ["L", "E", "P", "A", "P"],
            answer: "APPLE",
            size: 5, image: "apple"
        ),
        
        Question(
            scrambledWord: ["N", "A", "B", "A", "A", "N"],
            answer: "BANANA",
            size: 6, image: "banana"
        ),
        
    ]
    
    @State var word = ["G", "E", "A", "N", "R", "O"]
    
    @State var current: Int
    
    @State var guessed: [String] = [];
    @State var score = 0
    
    @State var showAlert: Bool = false
    @State var alertImage: String = ""
    
    var body: some View {
        
        GeometryReader { geometry in
            
            ZStack {
                
                Color.black
                    .ignoresSafeArea()
                
                VStack {
                    VStack{
                        
                        Spacer()
                        
                        Image(questions[current].image)
                            .resizable()
                            .frame(width: 150, height: 150)
                        
                        Spacer()
                        
                        HStack (alignment: .bottom) {
                            
                            ForEach(0 ..< questions[current].size, id: \.self) { i in
                                
                                if i < guessed.count {
                                    InsideLetter(letter: guessed[i])
                                    
                                        .onTapGesture {
                                            
                                            word = questions[current].scrambledWord
                                            
                                            let letter = guessed[i]
                                            
                                            questions[current].scrambledWord
                                                .append(letter)
                                            
                                            if let index = guessed.firstIndex(of: letter) {
                                                guessed.remove(at: index)
                                            }
                                            
                                            print(guessed)
                                        }
                                    
                                    
                                }
                                else {
                                    InsideLetter(letter: "")
                                }
                                
                            }
                            
                        }
                        .frame(height: 30)
                        
                        Spacer()
                        
                    }
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.width * 0.9)
                    .overlay {
                        RoundedRectangle(cornerRadius: 25)
                            .stroke(Color.gray, lineWidth: 1.5)
                    }
                    
                    Text("Score: \(score)")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .padding(.top)
                    
                    HStack {
                        
                        ForEach(
                            questions[current].scrambledWord,
                            id: \.self
                        ) { letter in
                            
                            LetterBox(letter: letter)
                                .onTapGesture {
                                    guessed.append(letter)
                                    if let index = questions[current].scrambledWord.firstIndex(
                                        of: letter
                                    ) {
                                        questions[current].scrambledWord
                                            .remove(at: index)
                                    }
                                    
                                    print(questions[current].scrambledWord)
                                    
                                    if (guessed.count == questions[current].size) {
                                        checkAns()
                                    }
                                    
                                }
                            
                        }
                        
                    }
                    
                }
                
                
                if (showAlert) {
                    
                    Color.black.opacity(0.8).ignoresSafeArea(.all)
                    
                    Image(alertImage)
                        .resizable()
                        .frame(width: 100, height: 100)
                    
                }
                
            }
            
        }
        
        
    }
    
    
    func checkAns() {
        
        if questions[current].answer == guessed.joined() {
            score += 1
            print("Correct Answer")
            
            alertImage = "tick"
            showAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                showAlert = false
            })
            
            clearInputs()
            
            if (current < questions.count - 1) {
                current += 1
            }
            
        }
        else {
            score = 0
            print("Wrong Answer")
            
            alertImage = "cross"
            showAlert = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                showAlert = false
            })
            clearInputs()
            current = 0
            
        }
        
    }
    
    
    func clearInputs() {
        guessed = []
        questions[current].scrambledWord = word
    }
    
    
    
}


struct LetterBox: View {
    
    let letter: String
    
    var body: some View {
        
        ZStack {
            
            Text(letter)
                .font(.title2)
                .fontWeight(.bold)
                .foregroundStyle(Color.white)
                .frame(width: 30, height: 30)
                .background(Color.gray)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}


struct InsideLetter: View {
    
    var letter: String
    
    var body: some View {
        
        
        VStack {
        
            LetterBox(letter: letter)
            
            Rectangle()
                .fill(Color.white)
                .frame(width: 30, height: 2)
                .padding(.top, 5.0)
        
        }
        
    }
    
}



#Preview {
    ContentView(current: 0)
}
