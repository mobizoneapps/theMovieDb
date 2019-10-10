
import Foundation


struct Movie: Equatable {
    
    let id: Int64?
    let title: String?
    let overview: String?
    let posterPath: String?
    let releaseDate: Date?
    let voteAverage: Double?
}

extension Movie: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case posterPath  = "poster_path"
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
    }
    
    init?(data: Data) {
        guard let me = try? JSONDecoder.theMovieDB.decode(Movie.self, from: data) else { return nil }
        self = me
    }
    
    init?(id: Int64, title: String?, overview: String?, posterPath: String?, releaseDate: Date?, voteAverage: Double?) {
        self.id = id
        self.title = title
        self.overview = overview
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.voteAverage = voteAverage
    }
}


