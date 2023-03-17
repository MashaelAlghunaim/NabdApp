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
    @State var Q1 = "أهلا معك المسعف الذكي ما هي حالتك الطارئه ؟"
    @State var emergencyText : String =  ""
    @State var Q2 = "حسنا ما هو اسمك ؟"
    @State var patientName : String =  ""
    @State var Q3 = "كم عمرك ؟"
    @State var patientAge : String =  ""
    var Q4 : String { return "\(self.patientName) هل تعاني من أمراض مزمنه ؟"}
    @State var patientHealthhistory : String =  ""
    @State var Q5 = "أخيرا ما هي الاعراض الناتجه من الاصابه ؟"
    @State var patientSituation : String =  ""
    
    @State var messageText: String = ""
    
   // let openAIService = OpenAIService()
    @State var cancellables = Set<AnyCancellable>()
    var body: some View {
        VStack{
            ScrollView{
                LazyVStack {
                    ForEach(chatMessages1, id: \.id) { message in
                        messageView1(message: questionMessage(questionNum: questionSwitch))
                        messageView1(message: message)
                        
                    }
                }
            }
            HStack{
                TextField("Enter a message", text: $messageText){
                    switch questionSwitch{
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
                    
                }
                    .foregroundColor(.black)
                    .padding()
                    .background(.gray.opacity(0.1))
                    .cornerRadius(12)
                Button{
                    sendMessage()
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
     
     func questionMessage(questionNum : Int) ->  ChatMessage1{
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
        //messageText = ""
        return myMessage;
    }
    func sendMessage(){
        let myMessage = ChatMessage1(id: UUID().uuidString, content: messageText, dateCreated: Date(), sender: .me)
        chatMessages1.append(myMessage)
//        openAIService.sendMessage(message: messageText).sink { completion in
//            //handle error
//        } receiveValue: { response in
//            guard let textResponse = response.choices.first?.text.trimmingCharacters(in: .whitespacesAndNewlines.union(.init(charactersIn: "\""))) else {return}
//            let gptMessage = ChatMessage1(id: response.id, content: textResponse, dateCreated: Date(), sender: .gpt)
//            chatMessages1.append(gptMessage)
//        }
//        .store(in: &cancellables)

        messageText = ""
        questionSwitch += 1
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
