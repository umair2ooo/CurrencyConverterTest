import Foundation


class ModelBase : Codable {
    var success : Bool = false
    var error : ModelError?
    
    init() {}
    
    private enum CodingKeys: String, CodingKey {
        case success
        case error
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        do {
            self.success = try container.decode(Bool.self, forKey: .success)
        } catch {
            self.success = false
        }
        
        do {
            self.error = try container.decode(ModelError.self, forKey: .error)
        } catch {
            self.error = nil
        }
        
    }
}



class ModelError : Codable {
    let code : Int?
    let info : String?
    
    
    private enum CodingKeys: String, CodingKey {
        case code
        case info
    }
    
    required init(from decoder: Decoder) throws {
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        do {
            self.code = try container.decode(Int.self, forKey: .code)
        } catch {
            self.code = -1
        }
        
        
        do {
            self.info = try container.decode(String.self, forKey: .info)
        } catch {
            self.info = nil
        }
    }
}
