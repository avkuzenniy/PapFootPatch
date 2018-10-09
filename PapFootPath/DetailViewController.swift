//
//  DetailViewController.swift
//  PapFootPath
//
//  Created by 1 on 20.09.2018.
//  Copyright © 2018 Papa. All rights reserved.
//

import UIKit
import MapKit

class DetailViewController: UIViewController {
    
    var sentData4, sentData5: Double!
    var data: WalksData!
    
    @IBOutlet weak var detailImageView: UIImageView!
    @IBOutlet weak var detailTitle: UILabel!
    @IBOutlet weak var detailDescription: UILabel!
    @IBOutlet weak var detailTextView: UITextView!
    @IBOutlet weak var detailMapView: MKMapView!
    @IBOutlet weak var directionButton: UIButton!
    
    var latitude = 0.0
    var longitude = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        directionButton.layer.cornerRadius = 5
        detailMapView.layer.cornerRadius = 5
        
        self.navigationItem.title = data.walkTitle
        detailTitle.text = data.walkTitle
        detailTextView.text = data.walkDescription
        
//        let url = "http://www.ifootpath.com/upload/"+data.walkIllustration!
//        self.detailImageView.downLoadIcon(from: url)
//        
//        SavedImageToFile(url: url, name: data.walkIllustration!)
        if let img = getSavedImage(named: data.walkIllustration!) {
            self.detailImageView.image = img
            // do something with image
        }
        
        latitude = sentData4
        longitude = sentData5
        
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: CLLocationCoordinate2DMake(latitude, longitude), span: span)
        
        detailMapView.setRegion(region, animated: true)
        
        let pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let pinAnn = MKPointAnnotation()
        pinAnn.coordinate = pinLocation
        pinAnn.title = detailTitle.text
        pinAnn.subtitle = detailDescription.text
        
        self.detailMapView.addAnnotation(pinAnn)

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func directions(_ sender: Any) {
        
        UIApplication.shared.open(URL(string: "http://maps.apple.com/maps?daddr=\(latitude),\(longitude)")!, options: [:], completionHandler: nil)
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
                if let data = image!.pngData(),
                    !FileManager.default.fileExists(atPath: fileURL.path) {
                    do {
                        // записывает данные изображения на диск
                        try data.write(to: fileURL)
                        //print("file saved")
                    } catch {
                        print("error saving file:", error)
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
    
}

