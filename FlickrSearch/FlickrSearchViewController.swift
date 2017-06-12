//
//  FlikerSearchViewController.swift
//  FlikerSearch
//
//  Created by Abhijeet on 11/06/17.
//  Copyright © 2017 Abhijeet. All rights reserved.
//

import UIKit
import SDWebImage

class FlickrSearchViewController: UIViewController {
    
    @IBOutlet var viewModel: FlickrSearchViewModel! //Dependency Injected through Storyboard
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var searchBar: UISearchBar!
    
    var pageValue = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Hide keyboard while tapping any where
        self.hideKeyboardWhenTappedAround()

    }
    
    func showAlert(mesg:String) {
        OperationQueue.main.addOperation {
            let alertController = UIAlertController(title: "Test", message: mesg, preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: {(action:UIAlertAction) in
                //Do something needed
            })
            self.present(alertController, animated: true, completion: nil)
            alertController.addAction(defaultAction)
        }
    }
}

// MARK: UISearchBarDelegate and search request call
extension FlickrSearchViewController:UISearchBarDelegate {
    
    //Search when search bar is clicked.
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.pageValue = 1
        self.reload(page: "\(self.pageValue)")
    }
    
    //Call for the data
    func reload(page:String) {
        searchBar.resignFirstResponder()
        viewModel.fetchSearchResult(searchBar.text!, pageNumber: page)
        viewModel.completionClosure = {[unowned self] success in
            if success {
                OperationQueue.main.addOperation {[unowned self] in
                    self.collectionView.reloadData()
                }
            } else {
                self.showAlert(mesg: "Something went Wrong") //May  be some better error handling.
            }
        }
    }
    
    //Clear history if searchbar is cleared.
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            //Take it to original state.
            viewModel.clearHistorySearch()
            self.collectionView.reloadData()
        }
    }
}

// MARK: UICollectionViewDataSource,UICollectionViewDelegate
//and UICollectionViewDelegateFlowLayout (for the three item per row)
//Checking the infinite scrolling and making call the more items.

extension FlickrSearchViewController:UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItemsInSection(section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        
        // Configure the cell
        configureCell(cell, forItemAtIndexPath: indexPath)
        
        return cell
    }
    
    func configureCell(_ cell: CustomCollectionViewCell, forItemAtIndexPath indexPath: IndexPath) {
        //print(viewModel.urlForTheItemAtIndexPath(indexPath))
        cell.imageView.sd_setImage(with: URL(string: viewModel.urlForTheItemAtIndexPath(indexPath)), placeholderImage: UIImage(named: "placeholder.jpeg"))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = UIScreen.main.bounds.size
        
        // 8 - space between 3 collection cells
        // 4 - 4 times gap will appear between cell.
        return CGSize(width: ((size.width/3) - 16), height: (self.view.frame.size.width/3) - 45)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView,
                                  willDecelerate decelerate: Bool) {
        if !decelerate {
            checkHasScrolledToBottom(scrollView: scrollView)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        checkHasScrolledToBottom(scrollView: scrollView)
    }
    
    func checkHasScrolledToBottom(scrollView: UIScrollView) {
        let bottomEdge = scrollView.contentOffset.y + scrollView.frame.size.height
        if bottomEdge >= scrollView.contentSize.height {
            // we are at the end
            pageValue = pageValue + 1
            reload(page: "\(pageValue)")
        }
    }
}

//Extention to provide function to hide keyboard if tapping around.
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    func dismissKeyboard() {
        view.endEditing(true)
    }
}
