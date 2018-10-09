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
    var urlIlustration = "http://www.ifootpath.com/upload/"
    var fetchResultController: NSFetchedResultsController<WalksData>!
    var walksData = [WalksData]()
    var walks = [WalksData]()
    let isFirstLaunch = UserDefaults.isFirstLaunch()
    
    @IBAction func addWalks(_ sender: Any) {
        fetchWalks()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if isFirstLaunch {
            fetchWalks()
            //print("JSON+CORE+\(isFirstLaunch)")
            
        } else {
            //print("CORE+\(isFirstLaunch)")
            loadWalksCoreData()
        }

        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func loadWalksCoreData() {
        let fetchRequest: NSFetchRequest<WalksData> = WalksData.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "walkTitle", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
            
            do {
                try fetchResultController.performFetch()
                walks = fetchResultController.fetchedObjects!
                
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
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
                let webSiteDescription = try JSONDecoder().decode(Welcome.self, from: data)
               
            DispatchQueue.main.async {
                self.saveCoreData(data:webSiteDescription.walks)
                self.loadWalksCoreData()
                self.tableView.reloadData()
            }
            
            }catch let jsonErr {
                print(jsonErr)
            }
            
            } .resume()
    }
    
    func saveCoreData(data:[Walk]) {
        let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
        
        if walks.isEmpty {
            let emptyWalksData = WalksData(context: context!)
            emptyWalksData.walkDescription = ""
            emptyWalksData.walkIcon = ""
            emptyWalksData.walkID = ""
            emptyWalksData.walkIllustration = ""
            emptyWalksData.walkRating = ""
            emptyWalksData.walkStartCoordLat = ""
            emptyWalksData.walkStartCoordLong = ""
            emptyWalksData.walkTitle = ""
            walks.append(emptyWalksData)
        }
        
        if let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext {
            
            for one in data {
                for i in walks {
                    
                    if i.walkID == one.walkID {
                        break
                    } else if(i == walks[walks.endIndex - 1]) {
                        let walksData = WalksData(context: context)
                        walksData.walkTitle = one.walkTitle
                        
                        walksData.walkDescription = one.walkDescription
                        
                        // douwn load json image icon end save to file
                        let url = urlIcon+one.walkIcon
                        SavedImageToFile(url: url, name: one.walkIcon)
                        if one.walkIllustration != nil {
                            let url2 = urlIlustration+one.walkIllustration!
                            SavedImageToFile(url: url2, name: one.walkIllustration!)
                        }
                        walksData.walkIcon = one.walkIcon
                        walksData.walkIllustration = one.walkIllustration
                        walksData.walkStartCoordLat = one.walkStartCoordLat
                        walksData.walkStartCoordLong = one.walkStartCoordLong
                        walksData.walkID = one.walkID
                        walksData.walkRating = one.walkRating
                        
                        self.tableView.reloadData();
                    }
            }
            }
            do {
                try context.save()
                print("Core Data save complit")
            } catch let error {
                print("\(error)")
            }
        }
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
        return walks.count
    }
    
    func SavedImageToFile (url: String, name: String) {
        let urlRequest = URLRequest(url: URL(string: url)!)
        let task = URLSession.shared.dataTask(with: urlRequest) {(data,responder,error) in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                
                let image = UIImage(data: data!)
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                //print(documentsDirectory)
                // выберите имя для своего изображения
                let fileName = name
                // создать URL-адрес целевого файла для сохранения изображения
                let fileURL = documentsDirectory.appendingPathComponent(fileName)
                // получить представление данных jpeg UIImage и проверить, существует ли URL-адрес целевого файлаs
                if image != nil {
                if let data = image!.pngData(),
                    !FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        // записывает данные изображения на диск
                        try data.write(to: fileURL)
                        print("file saved")
                    } catch {
                        print("error saving file:", error)
                    }
                    }
                    
                }
            }
        }
        task.resume()
    }
    
    //load image from file
    func getSavedImage(named: String) -> UIImage? {
        if let dir = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false) {
            return UIImage(contentsOfFile: URL(fileURLWithPath: dir.absoluteString).appendingPathComponent(named).path)
        }
        return nil
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TableViewCell
        
        cell.cellTitle.text = self.walks[indexPath.item].walkTitle
        cell.cellDescription.text = self.walks[indexPath.item].walkDescription
        
        if self.walks[indexPath.item].walkIcon != nil {
//            let url = urlIcon+(self.walks[indexPath.item].walkIcon)!
//            cell.cellImage.downLoadIcon(from: url)
            
            if let img = getSavedImage(named: walks[indexPath.item].walkIcon!) {
                cell.cellImage.image = img
                // do something with image
            }
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
            
            if walks.count>indexPath.row {
                let walk = walks[indexPath.row]
                let context = (UIApplication.shared.delegate as? AppDelegate)?.coreDataStack.persistentContainer.viewContext
                
                context!.delete(walk as NSManagedObject)

                self.walks.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                do {
                    try context!.save()
                } catch let error {
                    print("\(error)")
                }
            }
            
            // Delete the row from the data source
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
                detailViewController.data = walks[indexPath.row]
                
                detailViewController.sentData4 = NumberFormatter().number(from: (walks[indexPath.row].walkStartCoordLat)!)?.doubleValue
                detailViewController.sentData5 = NumberFormatter().number(from: (walks[indexPath.row].walkStartCoordLong)!)?.doubleValue
            }
        }
    }
}


extension UIImageView {
    func downLoadIcon(from url: String) {
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

extension String {
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
}
