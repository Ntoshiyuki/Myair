//
//  ViewController.swift
//  MyAir
//
//  Created by docomo on 2017/03/05.
//  Copyright © 2017年 NAGAE TOSHIYUKI. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        //Search Barのdelegate通知先
        searchText.delegate = self
        //入力のヒントをプレースホルダへ設定
        searchText.placeholder = "空港の名前を入力してください"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    //お菓子のリスト(タプル配列)
    var okashiList :[(mobile:String,pc:String)] = []
    
    
    //サーチボタンクリックじ
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        //キーボード閉じる
        view.endEditing(true)
        //デバックエリアに出力
        print(searchBar.text)
        
        if let searchWord = searchBar.text{
            //入力されていたら、お菓子を検索
            searchOkashi(keyword : searchWord)
        }

    }
    
    func searchOkashi(keyword : String){
        //お菓子の検索キーワードをURLエンコードする
        let keyword_eocode = keyword.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        //URLオブジェクトの生成
        //=TYO&keyword
//https://webservice.recruit.co.jp/ab-road/tour/v1/?key=8dd0e17904d54982&dept=TYO&keyword=ヨセミテ
        //http://webservice.recruit.co.jp/ab-road-air/city/v1/?key=8dd0e17904d54982&json&keyword=\(keyword_eocode!)&max=10&order=r"
        
        //ツアー詳細のURL,画像を載せる。お菓子APIの形をそのまま使う
        //dept=TYO&
        //"https://webservice.recruit.co.jp/ab-road/tour/v1/?key=8dd0e17904d54982&format=json&dept=TYO&keyword=\(keyword_eocode!)&max=10&order=r"
        
//        let URL = Foundation.URL(string:"https://webservice.recruit.co.jp/ab-road/tour/v1/?key=8dd0e17904d54982&format=json&keyword=\(keyword_eocode!)&max=10&order=r")
        
        let URL = Foundation.URL(string:"http://webservice.recruit.co.jp/ab-road-air/ticket/v1/?city=SFO&key=8dd0e17904d54982&format=json&keyword=\(keyword_eocode!)&max=10&order=r")
        
        print(URL)
        
        //リクエストオブジェクトの生成
        let req = URLRequest(url: URL!)
        
        //セッションの接続をカスタマイズ
        //タイムアウト値、キャッシュポリシーなどが指定できる。今回は、デフォルト値を使用
        let configuration = URLSessionConfiguration.default
        
        //セッション情報を取り出し
        let session = URLSession(configuration: configuration, delegate: nil, delegateQueue: OperationQueue.main)
        
        //リクエストをタスクとして登録
        let task = session.dataTask(with: req, completionHandler: {
            (data, response, error) in
            //do try catch　エラーハンドリング
            do{
                //受け取ったJsonデータを解析して格納
                let json = try JSONSerialization.jsonObject(with: data!) as! [String:Any]
                
                
                print("count = \(json["count"])")
                
//                //お菓子の情報が取得できているか確認
//                if let url = json["urls"] as? [[String:Any]]{
//                    //取得しているお菓子の数だけ処理
//                    for urls in url{
//                        //メーカー名
//                        guard let mobile = urls["mobile"] as? String else{
//                            continue
//                        }
//                        guard let pc = urls["pc"] as? String else{
//                            continue
//                        }
//                        //一つのお菓子をタプルでまとめて管理
//                        let okashi = (mobile,pc)
//                        //お菓子の配列へ追加
//                        self.okashiList.append(okashi)
//                    }
//                }
//                print("----------------")
//                print("okashiList[0] = \(self.okashiList[0])")
//
            }catch{
                //エラー処理
                print("エラーが出たよ")
            }
        })
        //ダウンロード開始
        task.resume()

        
    }
    
}

