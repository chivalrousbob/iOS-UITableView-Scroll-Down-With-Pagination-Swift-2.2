//
//  DataManager.swift
//  TrivagoProjectByNouriAyoub
//
//  Created by mac on 06/08/16.
//  Copyright © 2016 AYOUB NOURI. All rights reserved.
//

import UIKit

public class DataManager: NSObject {
    
    //variables Declaration
    var mDict = NSMutableArray()
    var mArray = NSMutableArray()
    var myArray = NSArray()
    
    //get the most popular movies
    public func getMostPopularMovies(pageNumber: String)-> NSMutableArray{
        
        let url = NSURL(string: MOST_POPULAR_MOVIES+"&page="+pageNumber+"&limit=10")
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod="get"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue(CLIENT_ID, forHTTPHeaderField: "trakt-api-key")
        
        let urlData:NSData?
        var response: NSURLResponse?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let error as NSError {
            print("error = \(error)")
            urlData = nil
        }

        let movies : NSMutableArray = []
        if let httpResponse = response as? NSHTTPURLResponse {
            if (httpResponse.statusCode>=200 && httpResponse.statusCode<=300){
                
                do{
                    mArray = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSMutableArray
                    
                    for object in mArray {
                        let movie = Movie()
                        movie.title = String(object.valueForKey("title")!)
                        movie.year = String(object.objectForKey("year")!)
                        movie.slug = String(object.valueForKey("ids")?.valueForKey("slug")!)
                        movie.trakt = String(object.valueForKey("ids")?.valueForKey("trakt")!)
                        movie.imdb = String(object.valueForKey("ids")?.valueForKey("imdb")!)
                        movie.tmdb = String(object.valueForKey("ids")?.valueForKey("tmdb")!)
                        movie.poster = String(object.valueForKey("images")!.valueForKey("poster")!.valueForKey("thumb")!)
                        movie.overview = String(object.valueForKey("overview")!)
                        movies.addObject(movie)
                    }
                } catch let err as NSError{
                    print("err \(err)")
                }
                
            }else{
                
            }
        }else{
           
        }
        return movies
    }
    
    //get the most popular movies
    public func searchMoviesByQuery(query: String,pageNumber: String)-> NSMutableArray{
        
        let link = SEARCH+query+"&extended=full,images&page="+pageNumber+"&limit=10"
        let urlString = link.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let url = NSURL(string: urlString)
        let request = NSMutableURLRequest(URL:url!)
        request.HTTPMethod="get"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.addValue("2", forHTTPHeaderField: "trakt-api-version")
        request.addValue(CLIENT_ID, forHTTPHeaderField: "trakt-api-key")
        
        let urlData:NSData?
        var response: NSURLResponse?
        do {
            urlData = try NSURLConnection.sendSynchronousRequest(request, returningResponse:&response)
        } catch let err as NSError {
            print("err \(err)")
            urlData = nil
        }
        let movies : NSMutableArray = []
        if let httpResponse = response as? NSHTTPURLResponse {
            if (httpResponse.statusCode>=200 && httpResponse.statusCode<=300){
                do{
                    
                   mArray = try NSJSONSerialization.JSONObjectWithData(urlData!, options:NSJSONReadingOptions.MutableContainers ) as! NSMutableArray
                    for object in mArray {
                        let movie = Movie()
                        if let title = object.valueForKey("movie")?.valueForKey("title") {
                             movie.title = String(title)
                        }
                        if let year = object.valueForKey("movie")?.valueForKey("year"){
                            movie.year = String(year)
                        }
                        if let poster = object.valueForKey("movie")?.valueForKey("images")?.valueForKey("poster")?.valueForKey("thumb"){
                            movie.poster = String(poster)
                        }
                        if let overview = object.valueForKey("movie")?.valueForKey("overview"){
                            movie.overview = String(overview)
                        }
                       
                        movies.addObject(movie)
                    }
                } catch let err as NSError{
                   print("err \(err)")
                }
            }
        }
                
           
      
        return movies
    }


    

}
