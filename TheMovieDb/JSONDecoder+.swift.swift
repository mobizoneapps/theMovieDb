import Foundation

extension JSONDecoder {
    
    static let theMovieDB: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .formatted(DateFormatter.yyyyMMdd)
        return decoder
    }()
}
