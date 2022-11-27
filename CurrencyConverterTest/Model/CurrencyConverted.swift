import Foundation




class CurrencyConvertedModel: ModelBase {
    var query: Query?
    var info: Info?
    var historical, date: String?
    var result: Double?
    
    
    private enum CodingKeys: String, CodingKey {
        case query, info, historical, date, result
    }
    
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {self.query = try container.decode(Query.self, forKey: .query)}
        catch {self.query = nil}
        
        do {self.info = try container.decode(Info.self, forKey: .info)}
        catch {self.info = nil}
        
        do {self.historical = try container.decode(String.self, forKey: .historical)}
        catch {self.historical = nil}
        
        do {self.date = try container.decode(String.self, forKey: .date)}
        catch {self.date = nil}
        
        do {self.result = try container.decode(Double.self, forKey: .result)}
        catch {self.result = nil}
    }
}



extension CurrencyConvertedModel: CustomStringConvertible {
    var description: String {
//        let result = self.result?.format(numberStyle: .currency, decimalPlaces: 2)
        let formattedValue = String(format: "%.2f", self.result ?? 0.0)
        return "\(formattedValue)"
    }
}

// MARK: - Info
class Info: Codable {
    var timestamp: Int?
    var rate: Double = 0.0
    
    private enum CodingKeys: String, CodingKey {
        case timestamp, rate
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {self.timestamp = try container.decode(Int.self, forKey: .timestamp)}
        catch {self.timestamp = nil}
        
        do {self.rate = try container.decode(Double.self, forKey: .rate)}
        catch {}
    }
}

// MARK: - Query
class Query: Codable {
    let from, to: String
    let amount: Int
    
    private enum CodingKeys: String, CodingKey {
        case from, to, amount
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {self.from = try container.decode(String.self, forKey: .from)}
        catch {self.from = ""}
        
        do {self.to = try container.decode(String.self, forKey: .to)}
        catch {self.to = ""}
        
        do {self.amount = try container.decode(Int.self, forKey: .amount)}
        catch {self.amount = 0}
    }
}


extension CurrencyConvertedModel : ErrorVerificationInDecodable {}
