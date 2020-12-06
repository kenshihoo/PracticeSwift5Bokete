//
//  ViewController.swift
//  Swift5Bokete
//
//  Created by Kenshiro on 2020/12/05.
//

import UIKit
//cocoapodから持ってきたライブラリを呼び出す
import Alamofire
import SwiftyJSON
import SDWebImage
//アルバム使用の許可画面を出すために呼び出す
import Photos

class ViewController: UIViewController {

    @IBOutlet weak var odaiImage: UIImageView!
    @IBOutlet weak var commentTextView: UITextView!
    @IBOutlet weak var searchTextField: UITextField!
    
    //nextOdaiボタンで次のお題を表示する際に使う変数
    var count = 0
    //お題を検索する前に事前に表示される画像の検索キーワード
    var defaultKeyWord = "funny"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //コメントボックスの角を丸くした
        commentTextView.layer.cornerRadius = 20.0
        
        //アルバム仕様の許可画面の挙動を設定
        PHPhotoLibrary.requestAuthorization {  (status) in switch(status){
        case .authorized:break
        case .denied:break
        case .notDetermined:break
        case .restricted:break
        case .limited:break
            }
        }
        
        //ViwewControllerが読み込まれた際に最初に表示させる画像
        getImage(keyWord:defaultKeyWord)
    }
    
    //検索キーワードの値から画像を持ってくる
    //APIを使ってpixabay.comからもってくる
    
    func getImage(keyWord:String) {
        //APIを使って持って来たい画像のURLを作成
        //アプリでの検索内容によって検索ワード(q=以下)が変わるので、引数keyWordを使っている
        let odaiurl = "https://pixabay.com/api/?key=19403437-6b5aa0ccfb6dec3d86ec780b9&q=\(keyWord)_type=photo"
            
        //Alaｍofireを使ってHTTPリクエストを投げる
            //AlamofireはAFと略せる
        AF.request(odaiurl,method: .get,parameters: nil,encoding: JSONEncoding.default).responseJSON
        
        //JSON解析をして、持ってくる画像を探し出す
            //クロージャー使っている
        {(response) in
            switch response.result{
                case .success:
                    let jsonData:JSON = JSON(response.data as Any)
                //APIを使って持ってきたデータのhits内にあるcount番目のwebformatURLを持ってくる
                        //クロージャを使っているのでsefl.countと記載しないと行けない
                    let imageString = jsonData["hits"][self.count]["webformatURL"].string
                //持ってきた画像を表示
                    self.odaiImage.sd_setImage(with: URL(string: imageString!), completed: nil)
            //エラーだったときの処理
                case .failure:
                    print("エラーです")
            }
        }
        //帰ってきた値をJSON解析をする
        //解析をしたものをodaiImage.imageに貼り付け
    }
    
    //お題のキーワード検索がされたときの処理
    @IBAction func searchOdai(_ sender: Any) {
        //countの値を0に戻す
        count = 0
        
        //検索した画像を表示させる
            //searchTextFieldに何記載されていない場合の処理
        if searchTextField.text == nil{
            getImage(keyWord:defaultKeyWord)
        }
            //searchTextFieldに検索キーワードが入っていた場合の処理
        else{
            getImage(keyWord:searchTextField.text!)
        }
        
    }
    
    //「次のお題へ」が押されたときの処理
    @IBAction func nextOdai(_ sender: Any) {
        //countの値を増やして表示する画像を変更する
        count = count+1
        
        //検索した画像を表示させる
            //searchTextFieldに何記載されていない場合の処理
        if searchTextField.text == nil{
            getImage(keyWord:defaultKeyWord)
        }
            //searchTextFieldに検索キーワードが入っていた場合の処理
        else{
            getImage(keyWord:searchTextField.text!)
        }
    }
    
    //「ボケる」が押されたときの処理
    @IBAction func boketa(_ sender: Any) {
        //画面遷移する
        performSegue(withIdentifier:"next", sender: nil)
    }
    
    //segueを準備する
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let nextVC = segue.destination as? NextViewController
        //ボケの内容(値)をNextViewControllerにわたす
        nextVC?.commentString = commentTextView.text
        //お題の画像をNextViewControllerにわたす
        nextVC?.selectedImage = odaiImage.image!
    }
    
}
