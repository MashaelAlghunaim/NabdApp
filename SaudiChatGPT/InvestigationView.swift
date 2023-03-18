//
//  InvestigationView.swift
//  SaudiChatGPT
//
//  Created by Sara Khalid BIN kuddah on 25/08/1444 AH.
//

import SwiftUI
import Combine
struct InvestigationView: View {
    @State var chatMessages1: [ChatMessage1] = []
    @State var questionSwitch: Int = 1
    @State var Q1 = "أهلا معك نبض المسعف الذكي ما هي حالتك الطارئه ؟"
    @State var emergencyText : String =  ""
    @State var Q2 = "حسنا ما هو اسمك ؟"
    @State var patientName : String =  ""
    @State var Q3 = "كم عمرك ؟"
    @State var patientAge : String =  ""
    var Q4 : String { return "\(self.chatMessages1[2].content) هل تعاني من أمراض مزمنه ؟"}
    @State var patientHealthhistory : String =  ""
    @State var Q5 = "أخيرا ما هي الاعراض الناتجه من الاصابه ؟"
    @State var patientSituation : String =  ""
    @State var messageText: String = ""
    @State var questionToGptText: String = ""
    let openAIService = OpenAIService()
    @State var cancellables = Set<AnyCancellable>()
    var body: some View {
        VStack{
            ScrollView{
                LazyVStack {
                    messageView1(message: firstQuestionMessage(questionNum: questionSwitch))
                    ForEach(chatMessages1, id: \.id) { message in
                        messageView1(message: message)
                        
                    }
                }
            }
            HStack{
                TextField("Enter a message", text: $messageText){
                    emergencyText = messageText
                    
                }
                    .foregroundColor(.black)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                Button{
                    sendMessage()
                    if(chatMessages1.count >= 8){
                        //print(chatMessages1)
                        //sendMessage()
                        questionToGptText = "أنا \(chatMessages1[2].content) عمري \(chatMessages1[4].content) سنه، أعاني من \(chatMessages1[6].content) ، \(chatMessages1[0].content) و أشعر ب \(chatMessages1[8].content) ما هي الاسعافات الاوليه اللتي يجب أن أتبعها ؟"
                       // print(questionToGptText)
                    }else{
                        sendQuistion(questionNum: questionSwitch)
                    }
                    
                } label: {
                    Text("Send")
                        .foregroundColor(.white)
                        .padding()
                        .background(.black)
                        .cornerRadius(12)
                }
                
            }
        }
            .padding()
          
        
        }
        func messageView1(message: ChatMessage1) -> some View {
            HStack{
                if message.sender == .me {Spacer()}
                Text(message.content)
                    .foregroundColor(message.sender == .me ? .white : .black)
                    .padding()
                    .background(message.sender == .me ? .blue : .gray.opacity(0.1))
                    .cornerRadius(16)
                if message.sender == .app {Spacer()}
            }
        }
    func questionMessage(questionNum : Int) ->
    String{
        var question = ""
        switch questionNum{
        case 1:
            question = Q1;
        case 2:
            question = Q2;
        case 3:
            question = Q3;
        case 4:
            question = Q4;
        case 5:
            question = Q5;
        default:
                print("questionNum default!")
        }
        return question
    }
    func firstQuestionMessage( questionNum : Int) ->
    ChatMessage1{
        var question = ""
        switch questionNum{
        case 1:
            question = Q1;
        case 2:
            question = Q2;
        case 3:
            question = Q3;
        case 4:
            question = Q4;
        case 5:
            question = Q5;
        default:
                print("questionNum default!")
        }

        let myMessage = ChatMessage1(id: UUID().uuidString, content: Q1, dateCreated: Date(), sender: .app)
        
        return myMessage;
    }
    func sendQuistion(questionNum : Int)
        {  switch questionNum{
        case 1:
            emergencyText = messageText;
        case 2:
            patientName = messageText;
        case 3:
            patientAge = messageText;
        case 4:
            patientHealthhistory = messageText;
        case 5:
            patientSituation = messageText;
        default:
                print("questionSwitch default!")
        }
            questionSwitch += 1
            let questionNum = questionSwitch
            var question = ""
                    switch questionNum{
                    case 1:
                        question = Q1;
                    case 2:
                        question = Q2;
                    case 3:
                        question = Q3;
                    case 4:
                        question = Q4;
                    case 5:
                        question = Q5;
                    default:
                            print("questionNum default!")
                    }
        let myMessage = ChatMessage1(id: UUID().uuidString, content: question, dateCreated: Date(), sender: .app)
        chatMessages1.append(myMessage)
            
            
    }
    func sendMessage(){
        let myMessage = ChatMessage1(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
        if(chatMessages1.count == 8){
            let myMessage = ChatMessage1(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
            
                chatMessages1.append(myMessage)
        }
        if(chatMessages1.count >= 9){
            //test send to GPT
            //chatMessages1.append(myMessage)
            questionToGptText = "أنا \(chatMessages1[2].content) عمري \(chatMessages1[4].content) سنه، أعاني من \(chatMessages1[6].content) ، \(chatMessages1[0].content) و أشعر ب\(chatMessages1[8].content) ما هي الاسعافات الاوليه اللتي يجب أن أتبعها ؟"
            print("test send to GPT \n \n \n")
            print("questionToGptText \(questionToGptText)")
            openAIService.sendMessage(message: questionToGptText).sink { completion in
                //handle error
            } receiveValue: { response in
                guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
                let gptMessage = ChatMessage1(id: response.id, content: textResponse, dateCreated: Date(), sender: .app)
                print("textResponse \(textResponse)")
                print("gptMessageToarray \(gptMessage)")
                chatMessages1.append(gptMessage)
            }
            .store(in: &cancellables)
            //end Test
        }else{
            chatMessages1.append(myMessage)
            print("No test send to GPT \n \n \n")
            
        }
        messageText = ""
       
    }
    
}

struct InvestigationView_Previews: PreviewProvider {
    static var previews: some View {
        InvestigationView()
    }
}
struct ChatMessage1 {
    let id: String
    let content: String
    let dateCreated: Date
    let sender: MessageSender1
}
enum MessageSender1{
    case me
    case app
}

extension ChatMessage1{
    static let sampleMessages = [
        ChatMessage1(id: UUID().uuidString, content: "Sample Message from me", dateCreated: Date(), sender: .me),
        ChatMessage1(id: UUID().uuidString, content: "Sample Message from gpt", dateCreated: Date(), sender: .app),
        ChatMessage1(id: UUID().uuidString, content: "Sample Message from me", dateCreated: Date(), sender: .me),
        ChatMessage1(id: UUID().uuidString, content: "Sample Message from gpt", dateCreated: Date(), sender: .app)
    ]
}
