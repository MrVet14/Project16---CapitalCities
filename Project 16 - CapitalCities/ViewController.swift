//
//  ViewController.swift
//  Project 16 - CapitalCities
//
//  Created by Vitali Vyucheiski on 4/29/22.
//

import UIKit
import MapKit
import WebKit

class ViewController: UIViewController, MKMapViewDelegate, WKNavigationDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var webView: WKWebView!
    
    var webToPass: URL?
    var mapType = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(selectMapType))
        
        let london = Capital(title: "London", coordinate: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275), info: "Home to the 2012 Summer Olympics", web: "https://en.wikipedia.org/wiki/London")
        let oslo = Capital(title: "Oslo", coordinate: CLLocationCoordinate2D(latitude: 59.95, longitude: 10.75), info: "Founded over a thouthand years ago.", web: "https://en.wikipedia.org/wiki/Oslo")
        let paris = Capital(title: "Paris", coordinate: CLLocationCoordinate2D(latitude: 48.8567, longitude: 2.3508), info: "Often called the City of Light", web: "https://en.wikipedia.org/wiki/Paris")
        let rome = Capital(title: "Rome", coordinate: CLLocationCoordinate2D(latitude: 41.9, longitude: 12.5), info: "Has a whole country inside it.", web: "https://en.wikipedia.org/wiki/Rome")
        let washington = Capital(title: "Washington DC", coordinate: CLLocationCoordinate2D(latitude: 38.895111, longitude: -77.036667), info: "Named after George himself.", web: "https://en.wikipedia.org/wiki/Washington,_D.C.")
        
        mapView.addAnnotations([london, oslo, paris, rome, washington])
    }

    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is Capital else { return nil }
        
        let identifier = "Capital"
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            let btn = UIButton(type: .detailDisclosure)
            annotationView?.rightCalloutAccessoryView = btn
        } else {
            annotationView?.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let capital = view.annotation as? Capital else { return }
        
        let placeName = capital.title
        let placeInfo = capital.info
        
        webToPass = URL(string: capital.web)
        
        let ac = UIAlertController(title: placeName, message: placeInfo, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        ac.addAction(UIAlertAction(title: "Wiki", style: .default, handler: openWebView))
        present(ac, animated: true)
    }
    
    func openWebView(action: UIAlertAction) {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(closeWebView))
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        webView.load(URLRequest(url: webToPass!))
        webView.allowsBackForwardNavigationGestures = true
    }
    
    @objc func closeWebView() {
        webView.removeFromSuperview()
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Map") as! ViewController
        self.navigationController?.present(vc, animated: true)
    }
    
    @objc func selectMapType() {
        let ac = UIAlertController(title: "Select Map Type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Standart", style: .default, handler: { _ in self.mapView.mapType = .standard }))
        ac.addAction(UIAlertAction(title: "Satellite", style: .default, handler: { _ in self.mapView.mapType = .satellite }))
        ac.addAction(UIAlertAction(title: "SatelliteFlyover", style: .default, handler: { _ in self.mapView.mapType = .satelliteFlyover }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default, handler: { _ in self.mapView.mapType = .hybrid }))
        ac.addAction(UIAlertAction(title: "HybridFlyover", style: .default, handler: { _ in self.mapView.mapType = .hybridFlyover }))
        ac.addAction(UIAlertAction(title: "MutedStandard", style: .default, handler: { _ in self.mapView.mapType = .mutedStandard }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }

}

