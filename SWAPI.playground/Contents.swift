import UIKit


struct Person: Decodable {
    let name: String
    let films: [URL]
}
struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
}

class SwapiService {
    static private let baseURL  = URL(string: "https://swapi.dev/api/")
    static let people = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        //Step 1.
        guard let baseURL = baseURL else { return completion(nil) }
        let finalURL = baseURL.appendingPathComponent(people).appendingPathComponent("\(id)")
        print(finalURL)
        //Step 2
        URLSession.shared.dataTask(with: finalURL) { data, _, error in
            //Handle Error
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            } // Make sure we got data
            guard let data = data else { return completion(nil)}
            
            // Decode Data
            do {
                let person = try JSONDecoder().decode(Person.self, from: data)
                return completion(person)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        } .resume()
        
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            do {
                let film = try JSONDecoder().decode(Film.self, from: data)
                return completion(film)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion(nil)
            }
        } .resume()
    }
    
    
} // end of classs


SwapiService.fetchPerson(id: 5) { person in
    if let person = person {
        print(person)
    }
}


func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film)
        }
    }
}

SwapiService.fetchPerson(id: 1) { person in
    if let person = person {
        print(person)
        // print out the films from person.films. In this case first person.
        for filmURL in person.films {
            fetchFilm(url: filmURL)
        }
    }
}

