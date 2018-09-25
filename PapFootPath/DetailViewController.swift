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
    
    var sentData1, sentData2, sentData3: String!
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
        
        self.navigationItem.title = sentData1
        detailTitle.text = sentData1
        detailTextView.text = sentData2
        
        //self.detailImageView.downLoadIllustration(from: <#T##String#>) = UIImage(data: data!)
        
//        var urlIcon = "http://www.ifootpath.com/upload/"
//        urlIcon.append(sentData3)
//        let urlRequest = URLRequest(url: URL(string: urlIcon)!)
//        let task = URLSession.shared.dataTask(with: urlRequest) {(data,responder,error) in
//            if error != nil {
//                print(error!)
//                return
//            }
//            DispatchQueue.main.async {
//                self.detailImageView.image = UIImage(data: data!)
//            }
//        }
//        task.resume()
        
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
    
}

//extension UIImageView {
//    func downLoadIllustration(from url: String) {
//        var urlIcon = "http://www.ifootpath.com/upload/"
//        urlIcon.append(url)
//        //print(urlIcon)
//        let urlRequest = URLRequest(url: URL(string: urlIcon)!)
//        let task = URLSession.shared.dataTask(with: urlRequest) {(data,responder,error) in
//            if error != nil {
//                print(error!)
//                return
//            }
//            DispatchQueue.main.async {
//                self.image = UIImage(data: data!)
//            }
//        }
//        task.resume()
//    }
//}
