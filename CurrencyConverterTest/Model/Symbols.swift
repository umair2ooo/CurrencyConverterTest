import Foundation

protocol SymoblsModelProtocol {
    var symbols: [String: String]? {get}
    var symbolsArray : [String] {get}
}


extension Symobls : SymoblsModelProtocol {
    var symbolsArray : [String] {
        return self.symbols?.keys.compactMap({String($0)}) ?? []
    }
}

class Symobls: ModelBase {
    
    var symbols: [String: String]?

   
    private enum CodingKeys: String, CodingKey {
        case symbols
    }
    required init(from decoder: Decoder) throws {
        
        try super.init(from: decoder)
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.symbols = try container.decode([String : String].self, forKey: .symbols)
        } catch  {
            self.symbols = nil
        }
    }
}

extension Symobls : ErrorVerificationInDecodable {}
