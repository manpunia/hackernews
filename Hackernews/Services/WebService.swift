//
//  WebService.swift
//  WebService
//
//  Created by Manish Punia on 20/09/21.
//
import Foundation

class WebService {

    func getArticles(url: URL, completion: @escaping ([NewsItem]?) ->()){
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let error = error
            {
                print(error.localizedDescription)
                completion(nil)
            }
            else if let data = data
            {
                do
                {
                    let itemList = try JSONDecoder().decode(NewItemList.self, from: data).hits
                    completion(itemList)
                }
                catch
                {
                    print("Error: \(error)")
                }
            }
        }.resume()
    }
}
