import Foundation



typealias HTTPCompletion = ((Result<Decodable>) -> Void)


// owned by Models
protocol ErrorVerificationInDecodable {
    var success : Bool {get}
    var error : ModelError? {get}
}


protocol NetworkLoader {
    func loadData<T>(using request: URLRequest, type: T.Type, with completion: @escaping HTTPCompletion) where T : Decodable & ErrorVerificationInDecodable
}
