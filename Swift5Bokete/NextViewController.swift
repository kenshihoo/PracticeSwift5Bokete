//
//  NextViewController.swift
//  Swift5Bokete
//
//  Created by Kenshiro on 2020/12/06.
//

import UIKit

class NextViewController: UIViewController {

    var selectedImage = UIImage()
    var commentString = String()
    var shareImage = UIImage()
    
    @IBOutlet weak var selectedImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //画像とボケを表示
        selectedImageView.image = selectedImage
        commentLabel.text = commentString
            //ボケの内容がcommentLabeの枠に収まるようにフォントサイズを調整
            commentLabel.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func share(_ sender: Any) {
        //スクショを撮る
        func takeScreenShot(){
            //スクショする範囲を指定
            let shotWidth = CGFloat(UIScreen.main.bounds.size.width)
            let shotheight = CGFloat(UIScreen.main.bounds.size.height/1.3)
            let shotSize = CGSize(width: shotWidth, height: shotheight)
        
            UIGraphicsBeginImageContextWithOptions(shotSize, false, 0.0)
        
            //Viewに書き出す
            self.view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        
            //書き出した画像をshareImageに反映
            shareImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndPDFContext()
        }
        
        //アクティビティビューに乗せてスクショをシェアさせる
        let shareItem = [shareImage] as! [Any]
        let activitiyVC = UIActivityViewController(activityItems: shareItem, applicationActivities: nil)
            //画像をシェアさせる呪文
            present(activitiyVC, animated: true, completion: nil)
    }
    
    
    @IBAction func back(_ sender: Any) {
        //モーダルから画面遷移を戻る呪文
        dismiss(animated: true, completion: nil)
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
