//
//  QL_Map_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/12/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

protocol MapDelegate:class {
    func didReloadData(data: NSArray)
}

class QL_Map_ViewController: UIViewController {

    weak var delegate: MapDelegate?

    @IBOutlet var mapBox: MGLMapView!
    
    var tempLocation: [[String:String]] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        mapBox.logoView.isHidden = true
        
        mapBox.attributionButton.isHidden = true
        
        mapBox.showsUserLocation = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onMapSingleTapped(recognizer:)))
        
        mapBox.addGestureRecognizer(tap)
        
        didPressLocation()
    }

    @objc func onMapSingleTapped(recognizer: UITapGestureRecognizer)
    {
        let viewLocation: CGPoint = recognizer.location(in: mapBox)
        
        if(mapBox.annotations != nil)
        {
            for annotation in mapBox.annotations!
            {
                if(annotation.isKind(of: MGLAnnotation.self))
                {
//                    let pin: MGLAnnotation = annotation
//
//                    if let pinView = pin.view
//                    {
//                        print("pinview \(pinView.frame.origin)")
//
//                        if(viewLocation.x >= pinView.frame.origin.x && viewLocation.x < pinView.frame.origin.x + pinView.frame.width)
//                        {
//                            if(viewLocation.y >= pinView.frame.origin.y && viewLocation.y < pinView.frame.origin.y + pinView.frame.height)
//                            {
//                                mapView(mapBox, didSelectAnnotationView: pinView)
                                return
//                            }
//                        }
//                    }
                }
            }
        }
        
        if let annotations = mapBox.annotations {
            mapBox.removeAnnotations(annotations)
        }
        
        let mapLocation: CLLocationCoordinate2D = mapBox.convert(viewLocation, toCoordinateFrom: mapBox)
        
        let marker = MGLPointAnnotation()
        
        marker.title = ""
        
        marker.subtitle = ""
        
        marker.coordinate = CLLocationCoordinate2D(latitude: mapLocation.latitude , longitude: mapLocation.longitude)
        
        mapBox.addAnnotation(marker)
        
        tempLocation.removeAll()
        
        tempLocation.append(["lat":"%f".format(parameters: mapLocation.latitude), "lng":"%f".format(parameters: mapLocation.longitude)])
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPressBack() {
        delegate?.didReloadData(data: tempLocation as NSArray)
        
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func didPressLocation() {
        mapBox.userTrackingMode = .follow
    }
}

extension QL_Map_ViewController: MGLMapViewDelegate {
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        if annotation is MGLUserLocation && mapBox.userLocation != nil {
            return MGLAnnotationImage(image: UIImage.init(named: "direction_arrow")!, reuseIdentifier: "userLocation")
        }
        
        let reuseIdentifier = reuseIdentifierForAnnotation(annotation: annotation)
        
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: reuseIdentifier)
        
        if annotationImage == nil {
            let image = imageForAnnotation(annotation: annotation)
            
            annotationImage = MGLAnnotationImage(image: image, reuseIdentifier: reuseIdentifier)
        }
        
        return annotationImage
    }
    
    func reuseIdentifierForAnnotation(annotation: MGLAnnotation) -> String {
        var reuseIdentifier = "\(annotation.coordinate.latitude),\(annotation.coordinate.longitude)"
        if let title = annotation.title, title != nil {
            reuseIdentifier += title!
        }
        if let subtitle = annotation.subtitle, subtitle != nil {
            reuseIdentifier += subtitle!
        }
        
        return reuseIdentifier
    }
    
    func imageForAnnotation(annotation: MGLAnnotation) -> UIImage {
        
//        let type = (annotation as! MGLPointAnnotation).accessibilityLabel
        
        return UIImage(named: "point")!

//        return UIImage(named: "maker_%@".format(parameters:type!))!
    }
    
    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        return true
    }
}
