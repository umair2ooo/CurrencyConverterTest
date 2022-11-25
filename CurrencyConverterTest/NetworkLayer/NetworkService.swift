import Foundation

struct HTTP {
    
    static func execute<T>(request: URLRequest, type : T.Type, completion : @escaping (Decodable?, String?) -> ()) where T: Decodable & ErrorVerificationInDecodable {
        
        let session = URLSession.shared
        
        debugPrint(request)
        
        session.loadData(using: request, type: T.self) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    print("model : \(String(describing: model))")
                    completion(model, nil)
                    break
                    
                case .failure(let error):
                    print("error : \(error)")
                    completion(nil, error.string)
                    break
                }
            }
        }
    }
}
