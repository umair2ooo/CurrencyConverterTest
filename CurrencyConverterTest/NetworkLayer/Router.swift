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




fileprivate let k_baseUrl = "https://api.apilayer.com/fixer/"


fileprivate let k_org = "orgs"
fileprivate let k_latest = "latest?"
fileprivate let k_APIKey = "bMYXuHtWT3BrF6vPq4r1o76q1Vrqm0Hp"
fileprivate let k_symbols = "symbols"
fileprivate let k_convert = "convert"
fileprivate let k_timeseries = "timeseries"



enum Router {

    case latest
    case symbols
    case convert(from: String, to : String, amount : Double)
    case timeseries(startDate : String, endDate : String, symbols: String, baseCurrency : String)

    
    


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
        }
    }
    
    
    private var params: String {
        switch self
        {

        case .latest:
            return "access_key=\(k_APIKey)"
            
        case let .convert(from, to, amount):
            return "&to=\(to)&from=\(from)&amount=\(amount)"
            
        case let .timeseries(statDate, endDate, symobls, baseCurrency):
            return "?start_date=\(statDate)&end_date=\(endDate)&symbols=\(symobls)&base=\(baseCurrency)"
            
        default:
            return ""
        }
    }
    
    
    private var method: HTTPMethod
    {
        switch self
        {
        case .latest, .symbols, .convert, .timeseries:
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
