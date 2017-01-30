//
//  MostPopularMoviesVC.swift
//  TrivagoProjectByNouriAyoub
//
//  Created by mac on 10/08/16.
//  Copyright © 2016 AYOUB NOURI. All rights reserved.
//

import UIKit
import SDWebImage

class MostPopularMoviesVC: UIViewController,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate{
    
    var movies = NSMutableArray()
    let dm = DataManager()
    var pageNumber = 1
    var isLoading = false
    var searchActive : Bool = false
    var mySearchText = ""
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var footerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        movies = dm.getMostPopularMovies("1")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies.count
    }
    
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell   = tableView.dequeueReusableCellWithIdentifier("cell1", forIndexPath: indexPath) as! MostPopularMoviesCell
        
        // Configure the cell...
        let movie = movies[indexPath.row] as! Movie
        //Title
        cell.title.text = movie.title
        if(movie.year == "<null>"){
            cell.year.text = "year not available yet"
        }else{
            cell.year.text = movie.year
        }
        //implement the poster image
        cell.poster.sd_setImageWithURL(NSURL(string: movie.poster!), placeholderImage: UIImage(named: "posterPlaceholder1.png"))
        //Description
        if(movie.overview == "<null>"){
            cell.overview.text = "description not available yet"
        }else{
            cell.overview.text = movie.overview
        }
        cell.overview.textColor = UIColor.whiteColor()
        return cell
    }
    //check the scroll if reaches the limit (10 movies)
     func scrollViewDidScroll(scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let maxOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if (maxOffset - offset) <= 0 {
            if (!self.isLoading) {
                self.isLoading = true
                //load new data (new 10 movies)
                loadNewMovies(movies.count)
            }
        }
    }
    
    func loadNewMovies(offset : Int){
        dispatch_async(dispatch_get_global_queue(QOS_CLASS_BACKGROUND, 0)) {
            // this runs on the background queue
            // here the query starts to add new 10 rows of data to arrays
            if offset != 0 {
                sleep(2)
            }
            dispatch_async(dispatch_get_main_queue()) {
                self.pageNumber += 1
                var newMovies : NSMutableArray
                if(self.searchActive){
                     newMovies  = self.dm.searchMoviesByQuery(self.mySearchText, pageNumber: String(self.pageNumber))
                }else{
                    newMovies  = self.dm.getMostPopularMovies(String(self.pageNumber))
                }
                
                for newMovie in newMovies {
                    let row = self.movies.count
                    let indexPath = NSIndexPath(forRow:row,inSection:0)
                    self.movies.addObject(newMovie)
                    
                    self.tableView?.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
                }
                self.isLoading = false
                
            }
        }
    }
    
    //search
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        
        if(searchText == ""){
            searchActive = false
        }else{
            searchActive = true
        }
        if(searchActive){
            movies = dm.searchMoviesByQuery(searchText,pageNumber: "1")
        }else{
             movies = dm.getMostPopularMovies("1")
        }
        pageNumber = 1
        self.tableView.reloadData()
        mySearchText = searchText
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        if(searchActive){
        if indexPath.row+1 == movies.count {
            let topPath = NSIndexPath(forRow: 0, inSection: 0)
            self.tableView.scrollToRowAtIndexPath(topPath, atScrollPosition: UITableViewScrollPosition.Top, animated: false)
        }
        }
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        searchActive = false
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchActive = false;
    }


    

}
