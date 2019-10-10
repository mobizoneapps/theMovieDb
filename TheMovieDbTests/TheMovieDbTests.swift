
import XCTest

class TheMovieDbTests: XCTestCase {
    
    
    var serverUrl: URLSession!
    
    override func setUp() {
        super.setUp()
        
        serverUrl = URLSession(configuration: .default)
    }
    
    override func tearDown() {
        super.tearDown()
        
        serverUrl = nil
    }
    
    func testValidResponseFromAPI() {
        
        let urlServerMovies = Config.URL.base + Config.typeList.popular + "page=1"
        
        let url = URL(string:  urlServerMovies)
        
        let promise = expectation(description: "Resultado esperado: 200")
        
        let dataTask = serverUrl.dataTask(with: url!) { data, response, error in
            
            if let err = error {
                XCTFail("Erro ao consultar a API: \(err.localizedDescription)")
            } else if let statusCode = (response as? HTTPURLResponse)?.statusCode {
                if statusCode == 200 {
                    promise.fulfill()
                } else {
                    XCTFail("Resultado erro code: \(statusCode)")
                }
            }
        }
        
        dataTask.resume()
        
        wait(for: [promise], timeout: 5)
        
    }
    
   
}
