//
//  ViewController.swift
//  CustomMap
//
//  Created by Pankaj Prajapati on 03/10/17.
//  Copyright © 2017 Pankaj Prajapati. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Alamofire

class ViewController: UIViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var imgDemo: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        setCustomPinOnMap()
        getDataFromServer()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setCustomPinOnMap() {
        let mapPin = MKPointAnnotation()
        let cordinates = CLLocationCoordinate2D(latitude: 19.0760, longitude: 72.8777)
        mapPin.title = "my point"
        mapPin.coordinate = cordinates
        mapView.addAnnotation(mapPin)
        
        let span = MKCoordinateSpan(latitudeDelta:0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegionMake(cordinates, span)
        self.mapView.setRegion(region, animated: true)
    }
    
    //Mark:- Mapview Delegate Methods
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKind(of: MKUserLocation.self) {
            return nil
        }else{
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: "myPoint")
            if view == nil {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: "myPoint")
                view?.image = UIImage(named: "img_location_point")
                return view
            }else{
                view?.image = UIImage(named: "img_location_point")
                return view
            }
        }
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let callOutView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 120))
        let lblName = UILabel(frame: CGRect(x: 10, y: 10, width: 120, height: 25))
        callOutView.backgroundColor = UIColor.lightGray
        lblName.text = "show some data here"
        callOutView.addSubview(lblName)
        view.addSubview(callOutView)
    }
    

}

extension ViewController {
    func getDataFromServer() -> Void {
        
        let dictParam: Dictionary<String,Any> = [
            "foo": "bar",
            "baz": ["a", 1],
            "qux": [
                "x": 1,
                "y": 2,
                "z": 3
            ]
        ]
        let url = URL.init(string: "https://httpbin.org/post")
        Alamofire.request(url!, method: .post, parameters: dictParam, encoding: URLEncoding.default).responseJSON { (response) in
            
            print(response.result)
            self.getImageFromServer()
        }

    }
    func getImageFromServer() -> Void {
        /*Alamofire.download("https://www.marriage.com/advice/wp-content/uploads/2016/09/44.jpg").responseData { response in
            print(response)
            if let data = response.result.value {
                self.imgDemo.image = UIImage(data: data)
            }
            self.dataTaskWithUrl()
        }*/
        
        let url = URL.init(string: "https://www.marriage.com/advice/wp-content/uploads/2016/09/44.jpg")
        Alamofire.request(url!).responseData { response in
            guard let data = response.result.value else { return }
            let image = UIImage(data: data)
            self.imgDemo.image = image
        }

    }
    
    func dataTaskWithUrl() -> Void {
        let _url = NSURL(string: "https://www.marriage.com/advice/wp-content/uploads/2016/09/44.jpg") as! URL
        let dataTask = URLSession.shared.dataTask(with: _url) {
            data, response, error in
            if error == nil {
                if let  data = data,
                    let image = UIImage(data: data) {
                    self.imgDemo.image = image
                }
            } else {
                print(error?.localizedDescription ?? "no description")
            }
        }
        dataTask.resume()
    }

}
