

import Foundation

struct Config {
    

    static let apiKey = "04817a57f3bfb81719b82e89126b3490"

    struct URL {
        static let base = "http://api.themoviedb.org/3"
        static let basePoster = "http://image.tmdb.org/t/p"
    }
    
    struct typeList {
        static let search = "/search/movie?api_key=\(apiKey)&language=pt-BR"
        static let popular = "/movie/popular?api_key=\(apiKey)&language=pt-BR"
    }


}
