//
//  QL_Map_ViewController.swift
//  QLDT
//
//  Created by Thanh Hai Tran on 9/12/18.
//  Copyright © 2018 Thanh Hai Tran. All rights reserved.
//

import UIKit

protocol MapDelegate:class {
    func didReloadData(data: NSArray, indexing: String)
}

class QL_Map_ViewController: UIViewController {

    weak var delegate: MapDelegate?

    @IBOutlet var mapBox: MGLMapView!
    
    var indexing: String!
    
    var tempLocation: [[String:String]] = []

    var progressView: UIProgressView!

    var coor = [CLLocationCoordinate2D]()

    var isMulti: Bool!
    
    @IBOutlet var auto: UIButton!
    
    @IBOutlet var delete: UIButton!

    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        
        auto.isHidden = !isMulti
        
        delete.isHidden = !isMulti

        
        mapBox.logoView.isHidden = true
        
        mapBox.attributionButton.isHidden = true
        
        mapBox.showsUserLocation = true
        
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(onMapSingleTapped(recognizer:)))
        
        mapBox.addGestureRecognizer(tap)
        
        didPressLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackProgressDidChange), name: NSNotification.Name.MGLOfflinePackProgressChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveError), name: NSNotification.Name.MGLOfflinePackError, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(offlinePackDidReceiveMaximumAllowedMapboxTiles), name: NSNotification.Name.MGLOfflinePackMaximumMapboxTilesReached, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func startOfflinePackDownload() {
        
        let region = MGLTilePyramidOfflineRegion(styleURL: mapBox.styleURL, bounds: mapBox.visibleCoordinateBounds, fromZoomLevel: mapBox.zoomLevel, toZoomLevel: 16)
        
        let userInfo = ["name": "My Offline Pack"]
        let context = NSKeyedArchiver.archivedData(withRootObject: userInfo)
        
        
        MGLOfflineStorage.shared.addPack(for: region, withContext: context) { (pack, error) in
            guard error == nil else {
                // The pack couldn’t be created for some reason.
                print("Error: \(error?.localizedDescription ?? "unknown error")")
                return
            }
            
            pack!.resume()
        }
        
    }
    
    @objc func offlinePackProgressDidChange(notification: NSNotification) {

        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String] {
            let progress = pack.progress
            // or notification.userInfo![MGLOfflinePackProgressUserInfoKey]!.MGLOfflinePackProgressValue
            let completedResources = progress.countOfResourcesCompleted
            let expectedResources = progress.countOfResourcesExpected
            
            let progressPercentage = Float(completedResources) / Float(expectedResources)
            
            if progressView == nil {
                progressView = UIProgressView(progressViewStyle: .default)
                let frame = view.bounds.size
                progressView.frame = CGRect(x: frame.width / 4, y: frame.height * 0.75, width: frame.width / 2, height: 10)
                view.addSubview(progressView)
            }
            
            progressView.progress = progressPercentage
            
//            self.showSVHUD("ahihii", andProgress: progressPercentage)
            
            if completedResources == expectedResources {
                let byteCount = ByteCountFormatter.string(fromByteCount: Int64(pack.progress.countOfBytesCompleted), countStyle: ByteCountFormatter.CountStyle.memory)
                print("Offline pack “\(userInfo["name"] ?? "unknown")” completed: \(byteCount), \(completedResources) resources")
            } else {
                print("Offline pack “\(userInfo["name"] ?? "unknown")” has \(completedResources) of \(expectedResources) resources — \(progressPercentage * 100)%.")
            }
        }
    }
    
    @objc func offlinePackDidReceiveError(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let error = notification.userInfo?[MGLOfflinePackUserInfoKey.error] as? NSError {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” received error: \(error.localizedFailureReason ?? "unknown error")")
        }
    }
    
    @objc func offlinePackDidReceiveMaximumAllowedMapboxTiles(notification: NSNotification) {
        if let pack = notification.object as? MGLOfflinePack,
            let userInfo = NSKeyedUnarchiver.unarchiveObject(with: pack.context) as? [String: String],
            let maximumCount = (notification.userInfo?[MGLOfflinePackUserInfoKey.maximumCount] as AnyObject).uint64Value {
            print("Offline pack “\(userInfo["name"] ?? "unknown")” reached limit of \(maximumCount) tiles.")
        }
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
            if !isMulti {
                mapBox.removeAnnotations(annotations)
            }
        }
        
        let mapLocation: CLLocationCoordinate2D = mapBox.convert(viewLocation, toCoordinateFrom: mapBox)
        
        let marker = MGLPointAnnotation()
        
        marker.title = ""
        
        marker.subtitle = ""
        
        marker.coordinate = CLLocationCoordinate2D(latitude: mapLocation.latitude , longitude: mapLocation.longitude)
        
        mapBox.addAnnotation(marker)
        
        if !isMulti {
            coor.removeAll()
            
            tempLocation.removeAll()
        }
        
        coor.append(CLLocationCoordinate2D(latitude: mapLocation.latitude , longitude: mapLocation.longitude))

        tempLocation.append(["lat":"%f".format(parameters: mapLocation.latitude), "lng":"%f".format(parameters: mapLocation.longitude)])
        
        if isMulti {
            let myTourline = MGLPolyline(coordinates: &self.coor, count: UInt(self.coor.count))
    
            mapBox.addAnnotation(myTourline)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didPressBack() {
        delegate?.didReloadData(data: tempLocation as NSArray, indexing: self.indexing)
        
        self.dismiss(animated: true) {
            
        }
    }
    
    @IBAction func didPressLocation() {
        mapBox.userTrackingMode = .follow
    }
    
    @IBAction func didPressTimer() {
        
    }
    
    
    @IBAction func didPressClear() {
        if let annotations = mapBox.annotations {
            mapBox.removeAnnotations(annotations)
        }
        
        coor.removeAll()
        
        tempLocation.removeAll()
    }
}

extension QL_Map_ViewController: MGLMapViewDelegate {
    
    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        //startOfflinePackDownload()
    }
    
    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        
        if annotation.isKind(of: MGLUserLocation.self) {
            return MGLAnnotationImage(image: UIImage.init(named: "direction_arrow")!, reuseIdentifier: "userLocation")
        }
        
        print(annotation)
        
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
