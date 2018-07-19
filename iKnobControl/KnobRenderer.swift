//
//  KnobRenderer.swift
//  iReusableKnob
//
//  Created by eagle two on 2018/06/23.
//  Copyright © 2018年 isshie. All rights reserved.
//
        

import UIKit

// knobのレンダリングに関連するコードを追跡します。
@IBDesignable class KnobRenderer {
    // 色
    @IBInspectable public var color: UIColor = .blue {
        didSet {
            trackLayer.strokeColor = color.cgColor
            pointerLayer.strokeColor = color.cgColor
        }
    }
    // 線幅
    var lineWidth: CGFloat = 2 {
        didSet {
            trackLayer.lineWidth = lineWidth
            pointerLayer.lineWidth = lineWidth
            updateTrackLayerPath()
            updatePointerLayerPath()
        }
    }
    // マーカーの開始位置
    var startAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8 {
        didSet {
            updateTrackLayerPath()
        }
    }
    // マーカーの終了位置
    var endAngle: CGFloat = CGFloat(Double.pi) * 3 / 8 {
        didSet {
            updateTrackLayerPath()
        }
    }
    
    var pointerLength: CGFloat = 6 {
        didSet {
            updateTrackLayerPath()
            updatePointerLayerPath()
        }
    }
    
    private (set) var pointerAngle: CGFloat = CGFloat(-Double.pi) * 11 / 8
    // 角度設定
    func setPointerAngle(_ newPointerAngle: CGFloat, animated: Bool = false) {
        // レイヤーをz軸回りに指定された角度だけ回転させる回転変換を作成する。
        CATransaction.begin()
        // trueなので、このトランザクショングループ内で行われたプロパティ変更の結果としてトリガされるアクションを抑制する。アニメーションを無効にする。
        CATransaction.setDisableActions(true)
        
        pointerLayer.transform = CATransform3DMakeRotation(newPointerAngle, 0, 0, 1)
        // animatedがtrueのときは、ポインタを正しい方向に回転させる明示的なアニメーションを作成します。回転方向を指定するには、keyframe animationを使用します。これは単に、通常の開始点と終了点に加えていくつかの中間点を指定するアニメーションです。

        if animated {
            let midAngleValue = (max(newPointerAngle, pointerAngle) - min(newPointerAngle, pointerAngle)) / 2
                + min(newPointerAngle, pointerAngle)
            // CAKeyFrameAnimationを作成し、アニメーション化するプロパティがキーパスとしてtransform.rotation.zを使用してz軸周りの回転であることを指定します。
            let animation = CAKeyframeAnimation(keyPath: "transform.rotation.z")
            // animation.valuesでは、レイヤーを回転させる3つの角度（開始ポイント、中間ポイント、および終了ポイント）を指定します。
            animation.values = [pointerAngle, midAngleValue, newPointerAngle]
            // 配列animation.keyTimesは、それらの値に到達する正規化された時間（パーセンテージとして）を指定します。
            animation.keyTimes = [0.0, 0.5, 1.0]
            animation.timingFunctions = [CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)]
            pointerLayer.add(animation, forKey: nil)
        }
        
        
        CATransaction.commit()
        
        pointerAngle = newPointerAngle
    }
    
    let trackLayer = CAShapeLayer()
    let pointerLayer = CAShapeLayer()
    
    init() {
        trackLayer.fillColor = UIColor.clear.cgColor
        pointerLayer.fillColor = UIColor.clear.cgColor
    }
    // TrackLayer描画
    private func updateTrackLayerPath() {
        let bounds = trackLayer.bounds
        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let offset = max(pointerLength, lineWidth  / 2)
        let radius = min(bounds.width, bounds.height) / 2 - offset
        
        let ring = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle,
                                endAngle: endAngle, clockwise: true)
        trackLayer.path = ring.cgPath
    }
    // PointerLayer描画
    private func updatePointerLayerPath() {
        let bounds = trackLayer.bounds
        
        let pointer = UIBezierPath()
        pointer.move(to: CGPoint(x: bounds.width - CGFloat(pointerLength)
            - CGFloat(lineWidth) / 2, y: bounds.midY))
        pointer.addLine(to: CGPoint(x: bounds.width, y: bounds.midY))
        pointerLayer.path = pointer.cgPath
    }
    // 境界と位置を設定する
    func updateBounds(_ bounds: CGRect) {
        trackLayer.bounds = bounds
        trackLayer.position = CGPoint(x: bounds.midX, y: bounds.midY)
        updateTrackLayerPath()
        
        pointerLayer.bounds = trackLayer.bounds
        pointerLayer.position = trackLayer.position
        updatePointerLayerPath()
    }
}


