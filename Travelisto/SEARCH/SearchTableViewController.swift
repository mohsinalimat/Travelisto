//
//  SearchTableViewController.swift
//  Travelisto
//
//  Created by Chidi Emeh on 4/10/18.
//  Copyright © 2018 Chidi Emeh. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchBarDelegate, UISearchControllerDelegate {
    
    //UI Properties
    @IBOutlet weak var searchSegmentedControl: UISegmentedControl!
    var customSearch : UISearchController?

    //var data = [[""], [""]]()
    var searchCodes : [[Codable]]!
    var position : Int!
    var dummyCount = [["one", "two", "three", "four"], [" one", "two"]]
    var toSearchCountrySelectionTVC = "toSearchCountrySelectionTVC"
    
    //Refresh Control
    lazy var refresher: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = .darkGray
        refreshControl.addTarget(self, action: #selector(requestData), for: .valueChanged)
        return refreshControl
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        position = 0
        
        //Destination SearchCodeTVC
        let searchStoryboard = UIStoryboard(name: "Search", bundle: nil)
        let destinationVC = searchStoryboard.instantiateViewController(withIdentifier: "SearchCodeTVC")
        
        //Search Bar
        let searchController = UISearchController(searchResultsController: destinationVC)
        searchController.delegate = self
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = true
        tableView.refreshControl = refresher
        searchController.searchBar.placeholder = "Where to?"
        searchController.searchBar.tintColor = UIColor(red: 253/255, green: 87/255, blue: 57/255, alpha: 1)
        customSearch = searchController
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadData()
    }


    @objc
    private func requestData(){
        refreshControl?.beginRefreshing()
        print("Refreshing SearchTableViewController ....")
        //Reload or refetch data
        refreshControl?.endRefreshing()
    }
    
    //Search Type tapped
    @IBAction func searchSegmentedControlSwitched(_ sender: UISegmentedControl) {
        position = sender.selectedSegmentIndex
        tableView.reloadData()
    }
    
    
    func willPresentSearchController(_ searchController: UISearchController) {
        //TODO: Need to fix so cursor is removed after screen shows
        self.performSegue(withIdentifier: toSearchCountrySelectionTVC, sender: nil)
    }
    
}

//MARK : Prepare for Segue
extension SearchTableViewController{
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == toSearchCountrySelectionTVC {
            if let searchCodeNavController = segue.destination as? UINavigationController {
                guard let searchCodeTVC = searchCodeNavController.childViewControllers[0] as? SearchCodeTVC else { return }
                let codesToSend = searchCodes[position]
                searchCodeTVC.codes = codesToSend
            }
        }
    }
    
}

//MARK: Row Height
extension SearchTableViewController {
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let destinationCellHeight = CGFloat(263), dealsCellHeight = CGFloat(195),
            defaultHeight = CGFloat(100)
        switch indexPath.row {
        case 0:
            return destinationCellHeight
        case 1:
            return dealsCellHeight
        case 2:
            return destinationCellHeight
        default:
            break
        }
        return defaultHeight
    }
    
}



//MARK: Data Source
extension SearchTableViewController {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3  //data[position].count to be used in TVCell
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell()
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCells.destinationTVCell.rawValue) as!
            DestinationTVCell
            cell.dummyDataCount = dummyCount[position].count
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCells.dealsTVCell.rawValue) as!
            DealsTVCell
            cell.dummyDataCount = dummyCount[position].count
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: SearchCells.destinationTVCell.rawValue) as!
            DestinationTVCell
            cell.dummyDataCount = dummyCount[position].count
            return cell
        default:
            break
        }
        return cell
    }
}

//MARK: - Load Data
extension SearchTableViewController {
    func loadData(){
        
        //Load Currency
        let airportfilePath = Bundle.main.path(forResource: "airports", ofType: "json")
        let airportUrl = URL(fileURLWithPath: airportfilePath!)
        
        do {
            let airportJSONCodes = try Data(contentsOf: airportUrl)
            let airportCodes = try JSONDecoder().decode([Cairport].self, from: airportJSONCodes)
            let codeCopy = airportCodes
            searchCodes = [airportCodes, codeCopy]
        }catch let error as NSError {
            print("Error Loading Cairports : \(error)")
        }
    }
    
}

