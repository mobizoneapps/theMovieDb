import UIKit
import SDWebImage

class DetailsViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imageMovieView: UIImageView!
    @IBOutlet weak var overviewLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    
    var movie: Movie?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.titleLabel.text = movie?.title
        self.overviewLabel.text = movie?.overview
        
        let urlImage = Config.URL.basePoster + "/w300" + (movie?.posterPath)!
        
        self.imageMovieView.sd_setImage(with: NSURL(string:urlImage)! as URL, placeholderImage: nil, options: [.continueInBackground])
        
        let df = DateFormatter()
        df.dateFormat = "dd/MM/yyyy"
        self.yearLabel.text = df.string(from: (movie?.releaseDate)!)
       
    }
  
}
