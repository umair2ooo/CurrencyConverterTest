import Foundation


struct Constants {
    
    struct GeneralConstants {
        static let offline = "The Internet connection appears to be offline"
        static let errorParsingJSON = "Unable to parse JSON"
        static let noData = "No data"
        static let invalidStatusCode = "There is something wrong, status code:"
        static let currenciesToLocal = "currencies"
        static let noHistoryRecordFound = "No history record found"
        static let history = "History"
        static let from = "From"
        static let to = "to"
    }
    
    struct APIErrors {
        
        
        static let sourceNotExist = "The requested resource does not exist."
        static let invalidAPIKey = "No API Key was specified or an invalid API Key was specified."
        static let endPointNotExist = "The requested API endpoint does not exist."
        static let maxLimitReached = "The maximum allowed API amount of monthly API requests has been reached."
        static let APINotSupported = "The current subscription plan does not support this API endpoint."
        static let requestNoResults = "The current request did not return any results."
        static let accountInactive = "The account this API request is coming from is inactive."
        static let invalidCurrency = "An invalid base currency has been entered."
        static let invalidSymbols = "One or more invalid symbols have been specified."
        static let NoDateSpecified = "No date has been specified."
        static let invalidDateSpecified = "An invalid date has been specified."
        static let invalidAmountSpecified = "No or an invalid amount has been specified."
        static let NoOrInvalidTimeframeSpecified = "No or an invalid timeframe has been specified."
        static let invalidStartDateSpecified = "No or an invalid 'start_date' has been specified."
        static let invalidEndDateSpecified = "No or an invalid 'end_date' has been specified."
        static let invalidTimeframeSpecified = "An invalid timeframe has been specified."
        static let timeframeIsTooLong = "The specified timeframe is too long, exceeding 365 days."
        static let badRequest = "Bad request"
        static let unknownErrorOccured = "Unknown error occurred"
    }
}
