import Foundation
import UIKit
import SDWebImage


class MovieViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageCell: UIImageView!
    @IBOutlet weak var titleLabelCell: UILabel!
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
    }
    
    var moviesCell: Movie? {
        
        didSet {
            
            if let image = moviesCell?.posterPath {
                
                let urlPost = Config.URL.basePoster + "/w185" + image
                
                imageCell.setShowActivityIndicator(true)
                imageCell.setIndicatorStyle(.white)
                imageCell.sd_setImage(with: NSURL(string:urlPost) as! URL, placeholderImage: nil, options: [.continueInBackground])
                
            }
            
            if let title = moviesCell?.title {
                titleLabelCell.text = title
            }
            
        }
        
    }
    
}
