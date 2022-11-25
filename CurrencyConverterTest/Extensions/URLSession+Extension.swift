import Foundation


fileprivate let successCodes: Range<Int> = 200..<299

extension URLSession: NetworkLoader {
    
    func loadData<T>(using request: URLRequest, type: T.Type, with completion: @escaping HTTPCompletion) where T : Decodable & ErrorVerificationInDecodable {
        
        self.dataTask(with: request) { [weak self] (data, response, error) in
            
            
            print("error : \(String(describing: error?.localizedDescription))")
            print("response : \(String(describing: response))")
            print("request.allHTTPHeaderFields : \(String(describing: request.allHTTPHeaderFields))")
            
            
            if let error = error {
                
                guard !(error.localizedDescription.caseInsensitiveCompare("cancelled") == .orderedSame) else { return }
                guard !(error.localizedDescription.contains(Constants.GeneralConstants.offline)) else {
                    completion(.failure(.noInternetConnection(Constants.GeneralConstants.offline)))
                    return
                }
                
                completion(.failure(.returnedError(error)))
            }
            
            
            
            guard let self = self,
                  let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.dataReturnedNil))
                return
            }
            
            
            self.validateStatusCodes(data: data, type: type, httpResponse: httpResponse, completion: completion)
        }.resume()
    }
    
    
    fileprivate func validateStatusCodes<T>(data: Data?, type : T.Type, httpResponse: HTTPURLResponse, completion: HTTPCompletion) where T : Decodable & ErrorVerificationInDecodable {
        
        //        guard successCodes.contains(httpResponse.statusCode) else {
        
        guard httpResponse.statusCode == 200 else {
            self.returnError(code: httpResponse.statusCode, completion: completion)
            return
        }
        
        
        
        print("json : \(String(describing: data?.prettyPrintedJSONString))")
        
        
        
        
        if let model = data?.decode(to: type) {
            print(model.success)
            print(model.error as Any)
            
            guard let error = model.error, model.success == false else {
                completion(.success(model))
                return
            }
            
            self.returnError(code: error.code!, completion: completion)
        }
        else {
            completion(.failure(.errorParsingJSON(Constants.GeneralConstants.errorParsingJSON)))
        }
    }
    
    func returnError(code:Int, completion: HTTPCompletion) {
        if let customError = APIErrors(rawValue: code) {
            completion(.failure(.customError(customError)))
        }
        else if let networkError = NetworkLevelErrors(rawValue: code) {
            completion(.failure(.networkError(networkError)))
        }
        else {
            completion(.failure(.invalidStatusCode(code)))
        }
    }
}



extension URLSession {
    
    func cancelTaskWithUrl(_ currentRequest: String) {
        self.getAllTasks { tasks in
            
            let runningTasks = tasks.filter { $0.state == .running }
            
            runningTasks.forEach { task in
                
                if let previousRequest = task.originalRequest?.url?.absoluteString {
                    
                    if (previousRequest.contains(currentRequest)) {
                        print("previousRequest going to cancel: \(previousRequest)")
                        task.cancel()
                    }
                }
            }
        }
    }
}
