

import UIKit
import CoreData

class MovieRepository: NSObject {
    
    
    class func saveMovie(_ context: NSManagedObjectContext, movies: [Movie]){
        
        let entity = NSEntityDescription.entity(forEntityName: "MovieTable", in: context)!
        
        for item in movies {
            
            
            let idComic = item.id
            
            var obj = findComic(context, id: idComic!)
            
            if !(obj != nil) {
                obj = NSManagedObject(entity: entity, insertInto: context) as! MovieTable
            }
            
            obj?.idMovie = idComic!
            obj?.title = item.title
            obj?.overview = item.overview
            obj?.posterPath = item.posterPath
            obj?.releaseDate = item.releaseDate as! NSDate
            obj?.voteAverage = item.voteAverage ?? 0
            
            
            do {
                try context.save()
            } catch {
                print("Failed saving")
            }
        
        }
        
    }
    

    class func findComic(_ context: NSManagedObjectContext, id: Int64) -> MovieTable? {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieTable")
        request.predicate = NSPredicate(format: "idMovie = %d", id)
        request.returnsObjectsAsFaults = false

        do {
            let result = try context.fetch(request)

            return result.first as? MovieTable

        } catch {

            print("Failed")
            return nil
        }
    }


    private class func getAll(_ context: NSManagedObjectContext) -> [MovieTable]? {

        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "MovieTable")
        request.returnsObjectsAsFaults = false


        let sort = NSSortDescriptor(key: "title", ascending: true)

        request.sortDescriptors = [sort]

        do {
            let result = try context.fetch(request)

            return result as! [MovieTable]

        } catch {

            print("Failed")
            return nil
        }
    }
    
    
    class func parseMovieEntity(_ context: NSManagedObjectContext) -> [Movie] {
        
        let moviesDb = MovieRepository.getAll(context)
        
        var movies = [Movie]()
        
        for item in moviesDb! {
            
            var movie = Movie(id: item.idMovie, title: item.title, overview: item.overview, posterPath: item.posterPath, releaseDate: nil, voteAverage: item.voteAverage)
            
//            var movie = Movie(id: item.idMovie, title: item.title, overview: item.overview?, posterPath: item.posterPath?, releaseDate: item.releaseDate, voteAverage: item.voteAverage)
            
            movies.append(movie!)
            
        }
        
        return movies
        
        
    }

    
    
}
