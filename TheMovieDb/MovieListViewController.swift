import UIKit

import Alamofire


class MovieListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    
    private var currentPage: Int = 1
    private let refreshControl = UIRefreshControl()
    
    
    var isFiltering: Bool {
        return  !(searchBar.text?.isEmpty ?? true)
    }
    
    var inSearching: Bool = false
    var movieSelected: Movie?
    
    var movies = [Movie]()
    var filteredMovies: [Movie] = []
    var inLoading = false
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    let cellID = "cellId"
    fileprivate let itemsPerRow: CGFloat = 3
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidAppear(_ animated: Bool) {
        loadMovies(page: self.currentPage)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        searchBar.delegate = self
        searchBar.showsCancelButton = true
        
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshControl
        } else {
            collectionView.addSubview(refreshControl)
        }
        
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar.text!)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchBar.text = ""
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset: CGFloat = 200
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height;
        if (bottomEdge + offset >= scrollView.contentSize.height) {
            self.loadMovies(page: self.currentPage)
        }
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        loadMovies(page: 1)
    }
    
    func loadLocalMovies(){
        
        let alert = UIAlertController(title: "Sem conexão", message: "Não há conexão com a internet, dados persistidos serão exibidos", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: false, completion: nil)
        
        let context = appDelegate.managedObjectContext
        self.movies = MovieRepository.parseMovieEntity(context!)
        self.collectionView.reloadData()
        self.refreshControl.endRefreshing()
        
    }
    
    func loadMovies(page: Int) {
        
     
        if (!NetworkReachabilityManager()!.isReachable){
            loadLocalMovies()
            return
        }
        
        guard !inLoading else { return }
        
        inLoading = true
        
        let context = appDelegate.managedObjectContext
        let urlServerMovies = Config.URL.base + Config.typeList.popular + "page=\(page)"
        
        Alamofire.request(urlServerMovies).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                
                guard let data = response.data else { return }
                
                let me = try! JSONDecoder.theMovieDB.decode(MoviesResults.self, from: response.data!)
                
                self.movies.append(contentsOf: me.movies)
                
                MovieRepository.saveMovie(context!, movies: me.movies)
                
            case .failure(let error):
                
                print(error)
            }
            
            self.collectionView.reloadData()
            self.currentPage = page + 1
            self.refreshControl.endRefreshing()
            self.inLoading = false
        }
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if isFiltering {
            return filteredMovies.count
        }
        
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! MovieViewCell
        
        if isFiltering {
            cell.moviesCell = filteredMovies[indexPath.item]
        } else {
            cell.moviesCell = movies[indexPath.item]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.frame.width/itemsPerRow
        let height = (width * 250) / 140
        return CGSize(width: width, height: height)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if isFiltering {
            movieSelected = filteredMovies[indexPath.item]
        } else {
            movieSelected = movies[indexPath.item]
        }
        
        self.performSegue(withIdentifier: "details", sender: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? DetailsViewController {
            vc.movie = self.movieSelected
        }
    }
    
    
    func filterContentForSearchText(_ searchText: String) {
        
        //        filteredMovies = movies.filter { (movie: Movie) -> Bool in
        //            return movie.title!.lowercased().contains(searchText.lowercased())
        //        }
        
        if (searchText.count < 4 || inSearching) {
            return
        }
        
        if (!NetworkReachabilityManager()!.isReachable){
            loadLocalMovies()
            return
        }
        
        inSearching = true
        let urlsearch = Config.URL.base + Config.typeList.search + "?&query=\(searchText)&page=1&include_adult=false"
        
        Alamofire.request(urlsearch).responseJSON { response in
            switch response.result {
                
            case .success(let value):
                
                guard let data = response.data else { return }
                
                do {
                    let me = try! JSONDecoder.theMovieDB.decode(MoviesResults.self, from: response.data!)
                    self.filteredMovies = me.movies
                } catch {
                    self.filteredMovies = self.movies
                }
                
            case .failure(let error):
                
                print(error)
            }
            self.inSearching = false
            self.collectionView.reloadData()
            self.searchBar.resignFirstResponder()
        }
        
    }
}



