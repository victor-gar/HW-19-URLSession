import Foundation

// for hash
import CryptoKit

class CreateURL {
    
    // create func hash
    private func MD5(data: String) -> String {
        let hash = Insecure.MD5.hash(data: data.data(using: .utf8) ?? Data())
        return hash.map {
            String(format: "%02hhx", $0)
        }
        .joined()
    }
    
    // URL Marvel in String
    func urlMarvelString() -> String {
        let publicKey = "eb29d3c3d55b564c378a3145801683a1"
        let privateKey = "829690ca0d938d31dbdc9c6df9b042d130778670"
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        let urlStrint = "https://gateway.marvel.com:443/v1/public/events?ts=\(ts)&apikey=\(publicKey)&hash=\(hash)"
        
        return urlStrint
    }
    
    // URL Marvel
    func urlMarvel() -> URL? {
        var components = URLComponents()
        
        components.scheme = "https"
        components.host = "gateway.marvel.com"
        components.path = "/v1/public/events"
        
        let publicKey = "b90a3fd7a0a93fdaa96b7c60d0c106ac"
        let privateKey = "43de8dd58a89f96c97947ba35dc6c77cc36d037d"
        
        let ts = String(Date().timeIntervalSince1970)
        let hash = MD5(data: "\(ts)\(privateKey)\(publicKey)")
        
        let queryItemTs = URLQueryItem(name: "ts", value: ts)
        let queryItemApiKey = URLQueryItem(name: "apikey", value: publicKey)
        let queryItemHash = URLQueryItem(name: "hash", value: hash)
        
        components.queryItems = [queryItemTs, queryItemApiKey, queryItemHash]
        let url = components.url
        
        return url
    }
}

class ProcessUrl {
    
    // data from string
    func getDataString(urlRequest: String) {
        let urlRequests = URL(string: urlRequest)
        
        guard let url = urlRequests else {
            print("error URL")
            return
        }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { data, responce, error in
            if let error {
                print("Error - \(error)")
            } else if let responce = responce as? HTTPURLResponse, responce.statusCode == 200 {
                print("Server response code - \(responce.statusCode)\n")
                guard let data = data else { return }
                let dataAsString = String(data: data, encoding: .utf8)
                print("Data received from the server: \n\(dataAsString ?? "Nothing")")
            }
        }.resume()
    }
}
