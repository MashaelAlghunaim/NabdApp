import Foundation
import Alamofire
import Combine

class OpenAIService {

let api = "your api"


func sendMessage(message: String) -> AnyPublisher<OpenAICompletionResponse, Error>{
    let body = OpenAICompletionBody(model: "text-davinci-003", prompt: message, temperature: 0.7, max_tokens: 500)
    let headers: HTTPHeaders = [
        "customer-id": "3091600073",
        "x-api-key": "x-api-key",
        "Content-Type": "application/json"
    ]
    return Future{ [weak self] promise in
        guard let self = self else {return}

        AF.request(self.api + "completions", method: .post, parameters: body, encoder: .json, headers: headers).responseDecodable(of: OpenAICompletionResponse.self){ response in
            switch response.result{
            case.success(let result):
                promise(.success(result))
            case .failure(let error):
                promise(.failure(error))
            }
        }
    }
    .eraseToAnyPublisher()

}

}
struct OpenAICompletionBody: Codable{
let model: String
let prompt: String
let temperature: Float?
let max_tokens: Int?
}

struct OpenAICompletionResponse: Decodable {
let id: String
let choices: [OpenAICompletionsChoices]

}
struct OpenAICompletionsChoices: Decodable{
let text: String
}
