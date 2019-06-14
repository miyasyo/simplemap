//
//  ViewController.swift
//  simpleHakodateMap
//
//  Created by 宮下翔伍 on 2019/06/11.
//  Copyright © 2019 宮下翔伍. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
class MapController: UIViewController,MKMapViewDelegate,CLLocationManagerDelegate {
let location = CLLocationManager()
    var modecount = 0
    var signal = 0
    var Foodarray:[MKAnnotation] = []
    var Foodshoparray:[MKAnnotation] = []
    var Shoparray:[MKAnnotation] = []
    @IBOutlet weak var Mymap: MKMapView!
    @IBOutlet weak var PinViewing: UIToolbar!
    @IBOutlet weak var OtherStore: UIBarButtonItem!
    @IBOutlet weak var Supermarket: UIBarButtonItem!
    @IBOutlet weak var FoodStore: UIBarButtonItem!
    @IBOutlet weak var LocationManager: UIButton!
    @IBOutlet weak var Backbutton: UIButton!
    
    let image1 = UIImage(named: "trackingnone")!
    let image2 = UIImage(named: "trackingfollow")!
    let image3 = UIImage(named: "trackingheading")!
    
    
    func addAno(_ id:Int,_ latitude:CLLocationDegrees,_ longitude: CLLocationDegrees,_ title:String,_ opentime:String){
        
        let ano = MKPointAnnotation()
        // 緯度経度を指定
        ano.coordinate = CLLocationCoordinate2DMake(latitude,longitude)
        // タイトル、サブタイトルを設定
        ano.title = title
          ano.subtitle = opentime
        // mapViewに追加
        self.Mymap.addAnnotation(ano)
        if(id==1){
        Foodarray.append(ano)
        }else if(id==2){
            Foodshoparray.append(ano)
        }else{
            Shoparray.append(ano)
        }
        Mymap.delegate = self
    }
    func locationManager(_ manager: CLLocationManager,didChangeAuthorization status: CLAuthorizationStatus){
        switch status {
        case .notDetermined:
            location.requestWhenInUseAuthorization()
        case .authorizedAlways, .authorizedWhenInUse:
            location.startUpdatingLocation()
            LocationManager.isEnabled = true
        case .restricted, .denied:
            break
        default:
            LocationManager.setImage(image1, for: .normal)
        }
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation)
        -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }else{
                // CustomAnnotationの場合に画像を配置
                let identifier = "Pin"
                var pinview = MKAnnotationView(annotation: annotation, reuseIdentifier:nil)
                if pinview == nil {
                    pinview = MKAnnotationView.init(annotation: annotation, reuseIdentifier: identifier)
                }
                //ボタンによるピンの画像の切り替え
                if(signal == 1){
                pinview.image = UIImage.init(named: "Food")
                }else if(signal == 2){
                    pinview.image = UIImage.init(named: "Foodshop")
                }else{
                     pinview.image = UIImage.init(named: "Shop")
                }
                pinview.annotation = annotation
                pinview.canShowCallout = true  // タップで吹き出しを表示
                pinview.rightCalloutAccessoryView = UIButton(type: UIButton.ButtonType.infoLight)
                
                return pinview
            }
    }
    @IBAction func TapPinFoodStore(_ sender: UIBarButtonItem) {
        signal = 1
        self.addAno(1,41.8362181,140.7375354,"びっくりドンキー","9:00~2:00")
        self.addAno(1,41.817343,140.7549725,"ラッキーピエロ美原店","10:00~0:30")
        self.addAno(1,41.8102747,140.7689863,"ラーメン山岡家 函館鍛治店","24時間営業")
        self.Mymap.removeAnnotations(Shoparray)
        self.Mymap.removeAnnotations(Foodshoparray)
    }
    @IBAction func TapPinSupermarket(_ sender: UIBarButtonItem) {
        signal = 2
        self.addAno(2,41.8190146,140.7510849,"アドマーニ","9:00~23:00")
        self.addAno(2,41.8327103, 140.7411222,"コープさっぽろ 石川店","9:00~21:45")
      self.addAno(2,41.8138484,140.7564413,"メガドンキー函館店","9:00~21:00")
         self.Mymap.removeAnnotations(Foodarray)
        self.Mymap.removeAnnotations(Shoparray)
    }

    @IBAction func TapPinOther(_ sender: UIBarButtonItem) {
        signal = 3
        self.addAno(3,41.8205361,140.7582250,"ツルハドラック北美原店","9:00~22:00")
        self.addAno(3,41.8305841,140.7352867,"蔦屋書店","7:00~1:00")
        self.addAno(3,41.7897120,140.7518890,"シエスタハコダテ","10:00~20:00")
          self.Mymap.removeAnnotations(Foodarray)
           self.Mymap.removeAnnotations(Foodshoparray)
    }
    
    @IBAction func BackScene(_ sender: UIButton) {
        let ano = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: 41.7687933, longitude:140.7288103)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        self.Mymap.setRegion(region, animated: true)
    }
    @IBAction func TrackingButton(_ sender: UIButton) {
                modecount+=1
        if(modecount%3==0){
            Mymap.userTrackingMode = MKUserTrackingMode.none
            LocationManager.setImage(image1, for: .normal)
        }else if(modecount%3==1){
            Mymap.userTrackingMode = MKUserTrackingMode.follow
            LocationManager.setImage(image2, for: .normal)
        }else if(modecount%3==2){
            Mymap.userTrackingMode = MKUserTrackingMode.followWithHeading
            LocationManager.setImage(image3, for: .normal)
        }else{return}
    }
    
    
    override func viewDidLoad() {
location.requestWhenInUseAuthorization()
        location.delegate = self
        super.viewDidLoad()
        let ano = MKPointAnnotation()
        let center = CLLocationCoordinate2D(latitude: 41.7687933, longitude:140.7288103)
        let span : MKCoordinateSpan = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region : MKCoordinateRegion = MKCoordinateRegion(center: center, span: span)
        Mymap.setRegion(region, animated: true)
        Mymap.delegate = self
        Mymap.addAnnotation(ano)
        // Do any additional setup after loading the view.
    }


}

