//
//  ViewController.swift
//  DetectPlane
//
//  Created by 柳生宗矩 on 2021/09/07.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    private let label: UILabel = UILabel()              //検知したplaneに対してラベルをつけていく。ラベルの中だけで使う変数を定義
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView = ARSCNView(frame: self.view.frame)  //③subViewを追加しデバッグオプションを追加する
        
        self.label.frame = CGRect(x: 0, y: 0, width: self.sceneView.frame.size.width, height: 50)   //ラベルの表示枠をrectanguler(四角)で画面に表示する記述
        self.label.center = self.sceneView.center           //ラベルの表示位置をセンターに
        self.label.textAlignment = .center                  //テキストの表示位置をセンターに
        self.label.textColor = UIColor.red                  //テキストカラー
        self.label.font = UIFont.preferredFont(forTextStyle: .headline) //フォントを(見出し)に
        self.label.alpha = 0                                //透明値、0で透明
        
        self.sceneView.addSubview(self.label)
        
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,ARSCNDebugOptions.showWorldOrigin]  //平面の点を追加(feature~、特徴点、きらきらするやつ)、座標系を追加(world~)
        self.view.addSubview(self.sceneView)           //④sceneViewをメインに追加
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene　②空の引数にする
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        configuration.planeDetection = .horizontal //①水平平面を検知。垂直はまだ。水平を認識する機能を有効化

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }

    // MARK: - ARSCNViewDelegate
    // 平面を検知したときにARAnchorに格納する
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        DispatchQueue.main.async {              //平面を感知したとき　非同期
            self.label.text = "Plane Detected!" //表示させる文字
            
            UIView.animate(withDuration: 3.0, animations: {     //表示時間を設定、3秒のアニメーション
                self.label.alpha = 1.0          //
            }) {(completion: Bool) in          //3秒経っていたら
            self.label.alpha = 0.0              //アルファ値を戻す
            }
        }
    }
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
