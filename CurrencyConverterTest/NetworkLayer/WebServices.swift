import Foundation

class WebServices {
    

    static func symbols(completion : @escaping (Symobls?, String?)->()) {
        
        let router = Router.symbols.getURL
        HTTP.execute(request: router, type: Symobls.self) { model, error in
            completion(model as? Symobls, error)
        }
    }
    
    
    static func exchangeRate(from : String, to : String, amount : Double, completion : @escaping (ConvertedResponse?, String?)->()) {
        
        let router = Router.convert(from: from, to: to, amount: amount).getURL
        HTTP.execute(request: router, type: ConvertedResponse.self) { model, error in
            completion(model as? ConvertedResponse, error)
        }
    }
    
    
    static func timeseries(from : String, to : String, completion : @escaping (ConvertedResponse?, String?)->()) {

        let router = Router.timeseries(from: from, to: to).getURL
        HTTP.execute(request: router, type: ConvertedResponse.self) { model, error in
            completion(model as? ConvertedResponse, error)
        }
    }
    
    
    static func historicalRates(fromDate: String, symbols: String, baseCurrency: String, completion : @escaping (ConvertedResponse?, String?)->()) {

        let router = Router.historicalRates(fromDate: fromDate, symbols: symbols, baseCurrency: baseCurrency).getURL
        HTTP.execute(request: router, type: ConvertedResponse.self) { model, error in
            completion(model as? ConvertedResponse, error)
        }
    }
}
