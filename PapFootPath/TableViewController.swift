//
//  TableViewController.swift
//  PapFootPath
//
//  Created by 1 on 19.09.2018.
//  Copyright © 2018 Papa. All rights reserved.
//

import UIKit
import CoreData

class TableViewController: UITableViewController {
    
    var urlIcon = "http://www.ifootpath.com/upload/thumbs/"
    var fetchResultController: NSFetchedResultsController<WalksData>!
    var walksData = [WalksData]()
    
    @IBAction func addWalks(_ sender: Any) {
         fetchWalks()
    }
    
    var walks: [Walks]? = []
    //var urlImage = "http://www.ifootpath.com/upload/"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        if UserDefaults.standard.bool(forKey: "firstBoot") == true {
//
//
//        } else {
//            UserDefaults.standard.set(true, forKey: "firstBoot")
//            UserDefaults.standard.synchronize()
//        }
        
        
        if firstBoot() {
            fetchWalks()
            
            UserDefaults.standard.set(false, forKey: "firstBoot")
            UserDefaults.standard.synchronize()
        }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
//        let fetchRequest: NSFetchRequest<WalksData> = WalksData.fetchRequest()
//        let sortDescriptor = NSSortDescriptor(key: "walkTitle", ascending: true)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        if let context = (UIApplication.shared.delegate as? CoreDataStack)?.persistentContainer.viewContext {
//            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
//
//            do {
//                try fetchResultController.performFetch()
//                walks = fetchResultController.fetchedObjects!
//            } catch let error as NSError {
//                print(error.localizedDescription)
//            }
//        }
//
  }

    func firstBoot() -> Bool {
        
        return UserDefaults.standard.bool(forKey: "firstBoot")
    }
    
    func fetchWalks() {
     
        let jsonUrlString = "http://www.ifootpath.com/API/get_walks.php"
        
        guard let url = URL(string: jsonUrlString) else { return }
        URLSession.shared.dataTask(with: url) { (data, response, err) in
            
            guard let data = data else {return}
            
            do {
                let webSiteDescription = try JSONDecoder().decode(Walks.Welcome.self, from: data)
                
                for one in webSiteDescription.walks {
                    let walk = Walks()

//                    if let context = (UIApplication.shared.delegate as? CoreDataStack)?.persistentContainer.viewContext {
                    
                        DispatchQueue.main.async {
                        //let walksData = WalksData(context: context)
                        walk.walkTitle = one.walkTitle
                        //print(walksData.walkTitle)
                        walk.walkDescription = one.walkDescription
                        walk.walkIcon = one.walkIcon
                        walk.walkIllustration = one.walkIllustration
                        walk.walkStartCoordLat = one.walkStartCoordLat
                        walk.walkStartCoordLong = one.walkStartCoordLong
                        walk.walkID = one.walkID
                        walk.walkRating = one.walkRating
                        
                        self.walks?.append(walk)
//                        do {
//                            try context.save()
//                            print("Save complit")
//                        } catch let error {
//                                        print("\(error)")
//                        }
                        self.tableView.reloadData();
                    }
                    
//                    walk.walkTitle = one.walkTitle
//                    walk.walkDescription = one.walkDescription
//                    walk.walkIcon = one.walkIcon
//                    walk.walkIllustration = one.walkIllustration
//                    walk.walkStartCoordLat = one.walkStartCoordLat
//                    walk.walkStartCoordLong = one.walkStartCoordLong
//                    walk.walkID = one.walkID
//                    walk.walkRating = one.walkRating
                    
         //       }
               // DispatchQueue.main.async {
                    //
                }
                self.tableView.reloadData()
            }catch let jsonErr {
                print(jsonErr)
            }
            
            } .resume()
        }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return walks?.count ?? 0
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.cellTitle.text = self.walks?[indexPath.item].walkTitle
        cell.cellDescription.text = self.walks?[indexPath.item].walkDescription
        
        if self.walks?[indexPath.item].walkIcon != nil {
            let url = urlIcon+(self.walks?[indexPath.item].walkIcon)!
            cell.cellImage.downLoadIcon(from: url )
        }
        
        if self.walks?[indexPath.item].walkIllustration != nil {
            
        }

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Delete the row from the data source
            self.walks?.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showDetail") {
            let detailViewController = segue.destination as! DetailViewController
            if let indexPath = self.tableView.indexPathForSelectedRow {
                detailViewController.sentData1 = walks?[indexPath.row].walkTitle
                detailViewController.sentData2 = walks?[indexPath.row].walkDescription
                detailViewController.sentData3 = walks?[indexPath.row].walkIllustration
                
                detailViewController.sentData4 = NumberFormatter().number(from: (walks?[indexPath.row].walkStartCoordLat)!)?.doubleValue
                detailViewController.sentData5 = NumberFormatter().number(from: (walks?[indexPath.row].walkStartCoordLong)!)?.doubleValue
            }
        }
    }
    
}


extension UIImageView {
    func downLoadIcon(from url: String) {
        //var urlIcon = "http://www.ifootpath.com/upload/thumbs/"
        //urlIcon.append(url)
        //print(urlIcon)
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data,responder,error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

extension UIImageView {
    func downLoadIllustration(from url: String) {
        var urlIcon = "http://www.ifootpath.com/upload/"
        urlIcon.append(url)
        //print(urlIcon)
        let urlRequest = URLRequest(url: URL(string: urlIcon)!)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data,responder,error) in
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        task.resume()
    }
}

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
