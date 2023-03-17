import Foundation
import Alamofire
import Combine

class OpenAIService {

let api = "https://experimental.willow.vectara.io/v1/"


func sendMessage(message: String) -> AnyPublisher<OpenAICompletionResponse, Error>{
    let body = OpenAICompletionBody(model: "text-davinci-003", prompt: message, temperature: 0.7, max_tokens: 256)
    let headers: HTTPHeaders = [
        "customer-id": "3091600073",
        "x-api-key": "zqt_uEYSyZvWiPKYseL6tTZVsyQscyxC60KCEpSS6w",
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
