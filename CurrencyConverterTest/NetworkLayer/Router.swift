import Foundation


enum HttpHeaderType: String {
    case contentType = "Content-Type"
}


enum HttpHeaderValue: String {
    case json = "application/json"
}

public struct HTTPMethod: RawRepresentable, Equatable, Hashable {
    /// `CONNECT` method.
    public static let connect = HTTPMethod(rawValue: "CONNECT")
    /// `DELETE` method.
    public static let delete = HTTPMethod(rawValue: "DELETE")
    /// `GET` method.
    public static let get = HTTPMethod(rawValue: "GET")
    /// `HEAD` method.
    public static let head = HTTPMethod(rawValue: "HEAD")
    /// `OPTIONS` method.
    public static let options = HTTPMethod(rawValue: "OPTIONS")
    /// `PATCH` method.
    public static let patch = HTTPMethod(rawValue: "PATCH")
    /// `POST` method.
    public static let post = HTTPMethod(rawValue: "POST")
    /// `PUT` method.
    public static let put = HTTPMethod(rawValue: "PUT")
    /// `QUERY` method.
    public static let query = HTTPMethod(rawValue: "QUERY")
    /// `TRACE` method.
    public static let trace = HTTPMethod(rawValue: "TRACE")

    public let rawValue: String

    public init(rawValue: String) {
        self.rawValue = rawValue
    }
}



//fileprivate let k_baseUrl = "https://api.apilayer.com/exchangerates_data/"
fileprivate let k_baseUrl = "https://api.apilayer.com/fixer/"
//fileprivate let k_baseUrl = "http://dataservices.imf.org/"

fileprivate let k_org = "orgs"
fileprivate let k_latest = "latest?"
fileprivate let k_APIKey = "bMYXuHtWT3BrF6vPq4r1o76q1Vrqm0Hp"
fileprivate let k_symbols = "symbols"
fileprivate let k_convert = "convert"
fileprivate let k_timeseries = "timeseries"

//convert?to=to&from=from&amount=amount
//https://data.fixer.io/api/2013-12-24
//    ? access_key = API_KEY
//    & base = GBP
//    & symbols = USD,CAD,EUR


//https://data.fixer.io/api/2013-12-24
//    ? access_key = API_KEY
//    & base = GBP
//    & symbols = USD,CAD,EUR

enum Router {

    case latest
    case symbols
    case convert(from: String, to : String, amount : Double)
    case timeseries(from : String, to : String)
    case historicalRates(fromDate :String, symbols: String, baseCurrency : String)
//https://api.apilayer.com/fixer/2022-11-20?symbols=AED%2CAFN%2CUSD%2CPKR%2CGBP%2CJPY%2CEUR&base=USD
    
    
//https://api.apilayer.com/fixer/timeseries?start_date=2022-11-20&end_date=2022-11-24

    private var serverMethod: String {
        
        switch self
        {
            
        case .latest:
            return k_latest
            
        case .symbols:
            return k_symbols
            
        case .convert:
            return k_convert
            
        case .timeseries:
            return k_timeseries
            
        case .historicalRates:
            return ""
        }
    }
    
    
    private var params: String {
        switch self
        {

        case .latest:
            return "access_key=\(k_APIKey)"
            
        case let .convert(from, to, amount):
            return "&to=\(to)&from=\(from)&amount=\(amount)"
            
        case let .timeseries(from, to):
            return "?access_key=\(k_APIKey)&start_date=\(to)&end_date=\(from)"
            
        case let .historicalRates(fromDate, symbols, baseCurrency):
            return "\(fromDate)?symbols=\(symbols)&base=\(baseCurrency)"
            
        default:
            return ""
        }
    }
    
    
    private var method: HTTPMethod
    {
        switch self
        {
        case .latest, .symbols, .convert, .timeseries, .historicalRates:
            return .get
        }
    }
    
    

    private var subBaseUrl: String {
        switch self
        {
        default:
            return ""
        }
    }
    
    
    
    private var concatinateURL : String{
        
        switch self {
        
        default:
            return "\(subBaseUrl)\(serverMethod)\(params)"
        }
    }
    
    
    
    var getURL : URLRequest {
        
        URLSession.shared.cancelTaskWithUrl(self.serverMethod)
        
        let baseUrl = NSURL(string : k_baseUrl)!
        
        let url = NSURL(string: concatinateURL, relativeTo:baseUrl as URL)!
        var request = URLRequest(url: url as URL)
        request.httpMethod = method.rawValue
        request.setValue(HttpHeaderValue.json.rawValue, forHTTPHeaderField: HttpHeaderType.contentType.rawValue)
        request.setValue(k_APIKey, forHTTPHeaderField: "apikey")
        
        request.timeoutInterval = 120
        return request as URLRequest
    }
}
