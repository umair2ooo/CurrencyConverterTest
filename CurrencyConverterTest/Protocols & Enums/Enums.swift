import Foundation

enum Result<T> {
    case success(T?)
    case failure(HTTPError)
}

enum HTTPError : Error {
    
    case errorParsingJSON(String)
    case noInternetConnection(String)
    case dataReturnedNil
    case returnedError(Error)
    case invalidStatusCode(Int)
    case customError(APIErrors)
    case networkError(NetworkLevelErrors)
    
    var string : String {
        switch self {
        case .errorParsingJSON(let string):
            return string
        case .noInternetConnection(let string):
            return string
        case .dataReturnedNil:
            return Constants.GeneralConstants.noData
        case .returnedError(let error):
            return error.localizedDescription
        case .invalidStatusCode(let int):
            return "\(Constants.GeneralConstants.invalidStatusCode) \(int)"
        case .customError(let aPIErrors):
            return aPIErrors.string
        case .networkError(let error):
            return error.string
        }
    }
}


enum NetworkLevelErrors : Int, Error {
    case badRequest = 400
    case sourceNotExist = 404
    case invalidAmountSpecified = 403
    
    var string : String {
        switch self {
        case .badRequest:
            return Constants.APIErrors.badRequest
        case .sourceNotExist:
            return Constants.APIErrors.sourceNotExist
        case .invalidAmountSpecified:
            return Constants.APIErrors.invalidAmountSpecified
        }
    }
}


enum APIErrors : Int, Error {
    
    case invalidAPIKey = 101
    case endPointNotExist = 103
    case maxLimitReached = 104
    case APINotSupported = 105
    case requestNoResults = 106
    case accountInactive = 102
    case invalidCurrency = 201
    case invalidSymbols = 202
    case NoDateSpecified = 301
    case invalidDateSpecified = 302
    case NoOrInvalidTimeframeSpecified = 501
    case invalidStartDateSpecified = 502
    case invalidEndDateSpecified = 503
    case invalidTimeframeSpecified = 504
    case timeframeIsTooLong = 505
    case unknownError
    
    
    var string : String {
        switch self {
        case .invalidAPIKey:
            return Constants.APIErrors.invalidAPIKey
        case .endPointNotExist:
            return Constants.APIErrors.endPointNotExist
        case .maxLimitReached:
            return Constants.APIErrors.maxLimitReached
        case .APINotSupported:
            return Constants.APIErrors.APINotSupported
        case .requestNoResults:
            return Constants.APIErrors.requestNoResults
        case .accountInactive:
            return Constants.APIErrors.accountInactive
        case .invalidCurrency:
            return Constants.APIErrors.invalidCurrency
        case .invalidSymbols:
            return Constants.APIErrors.invalidSymbols
        case .NoDateSpecified:
            return Constants.APIErrors.NoDateSpecified
        case .invalidDateSpecified:
            return Constants.APIErrors.invalidDateSpecified
        case .NoOrInvalidTimeframeSpecified:
            return Constants.APIErrors.NoOrInvalidTimeframeSpecified
        case .invalidStartDateSpecified:
            return Constants.APIErrors.invalidStartDateSpecified
        case .invalidEndDateSpecified:
            return Constants.APIErrors.invalidEndDateSpecified
        case .invalidTimeframeSpecified:
            return Constants.APIErrors.invalidTimeframeSpecified
        case .timeframeIsTooLong:
            return Constants.APIErrors.timeframeIsTooLong
        case .unknownError:
            return Constants.APIErrors.unknownErrorOccured
        }
    }
}
