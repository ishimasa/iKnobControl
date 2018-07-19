//
//  Knob.swift
//  iReusableKnob
//
//  Created by eagle two on 2018/06/22.
//  Copyright © 2018年 isshie. All rights reserved.
//


import UIKit

@IBDesignable public class Knob: UIControl {
    public var minimumValue: Float = 0
    
    public var maximumValue: Float = 1
    // 値は最小値と最大値の間でのみ設定できるため、そのsetterはprivate (set) 修飾子でプライベートにします。
    public private (set) var value: Float = 0
    
    // isContinuousがtrueの場合、コントロールは値の変更に応じて繰り返しコールバックします。 falseの場合、ユーザーが操作を終了した後、コントロールは一度だけコールバックします。
    public var isContinuous = true
    
    let renderer = KnobRenderer()
    // 公開プロパティ
    @IBInspectable public var lineWidth: CGFloat {
        get { return renderer.lineWidth }
        set { renderer.lineWidth = newValue }
    }
    
    public var startAngle: CGFloat {
        get { return renderer.startAngle }
        set { renderer.startAngle = newValue }
    }
    
    public var endAngle: CGFloat {
        get { return renderer.endAngle }
        set { renderer.endAngle = newValue }
    }
    
    @IBInspectable public var pointerLength: CGFloat {
        get { return renderer.pointerLength }
        set { renderer.pointerLength = newValue }
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    public override func tintColorDidChange() {
        renderer.color = tintColor
    }
    // knobレンダラーのサイズを設定し、2つのレイヤーをコントロールレイヤーのサブレイヤーとして追加します。
    private func commonInit() {
        renderer.updateBounds(bounds)
        renderer.color = tintColor
        renderer.setPointerAngle(renderer.startAngle, animated: false)
        
        layer.addSublayer(renderer.trackLayer)
        layer.addSublayer(renderer.pointerLayer)
        
        // recognizerを作成し、action時にKnob.handleGesture(_:)を呼び出します。
        let gestureRecognizer = RotationGestureRecognizer(target: self, action: #selector(Knob.handleGesture(_:)))
        addGestureRecognizer(gestureRecognizer)
    }
    
    // コントロールの値をプログラムで設定する、追加のbooleanパラメータは値の変更をアニメーション化する必要があるかどうかを示します。
    public func setValue(_ newValue: Float, animated: Bool = false) {
        value = min(maximumValue, max(minimumValue, newValue))
        // 最小値と最大値の範囲を最小値と最大値の角度範囲にマッピングすることによって、与えられた値に対して適切な角度を計算し、レンダラーにpointerAngleプロパティを設定します。
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = CGFloat(value - minimumValue) / CGFloat(valueRange) * angleRange + startAngle
        renderer.setPointerAngle(angleValue, animated: animated)
    }
    
    @objc private func handleGesture(_ gesture: RotationGestureRecognizer) {
        // 開始角度と終了角度の中間点を表す角度を計算します。これは、 knobトラックの一部ではない角度であり、ポインタが最大値と最小値の間でひっくり返る角度を表します。
        let midPointAngle = (2 * CGFloat(Double.pi) + startAngle - endAngle) / 2 + endAngle
        // gesture recognizerで計算された角度は、 inverse tangent関数を使用するため、-πとπの間になります。ただし、追跡に必要な角度は、startAngleとendAngleの間で連続している必要があります。したがって、新しいboundedAngle変数を作成し、変数が許容範囲内に収まるように調整します。
        var boundedAngle = gesture.touchAngle
        print("boundedAngle: ", boundedAngle * 180.0 / CGFloat(Double.pi))
        if boundedAngle > midPointAngle {
            // 90° -> 180°は、-270° -> -180°に変換する必要がある
            boundedAngle -= 2 * CGFloat(Double.pi)
        } else if boundedAngle < (midPointAngle - 2 * CGFloat(Double.pi)) {
            // ここには来ない
            boundedAngle -= 2 * CGFloat(Double.pi)
        }
        
        // 指定された境界の範囲内に位置するようにboundedAngleを更新します。
        boundedAngle = min(endAngle, max(startAngle, boundedAngle))
        
        // 角度を値に変換します。
        let angleRange = endAngle - startAngle
        let valueRange = maximumValue - minimumValue
        let angleValue = Float(boundedAngle - startAngle) / Float(angleRange) * valueRange + minimumValue
        
        // knobコントロールの値を設定します。
        setValue(angleValue)
        
        // isContinuousがtrueの場合、コントロールは値の変更に応じて繰り返しコールバックします。 falseの場合、ユーザーが操作を終了した後、コントロールは一度だけコールバックします。
        if isContinuous {
            // isContinuousがtrueの場合、ジェスチャが更新を送信するたびにイベントが発生します。
            sendActions(for: .valueChanged)
        } else {
            // isContinuousがfalseの場合、ジェスチャが終了するかキャンセルされたときにのみイベントが発生します。
            if gesture.state == .ended || gesture.state == .cancelled {
                sendActions(for: .valueChanged)
            }
        }
    }
}

extension Knob {
    public override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        // knobの境界を表示するためにその境界を設定しています。
        renderer.updateBounds(bounds)
    }
}

/*
import Foundation

// Knob.swift
public class Nacci: NSObject {
    public func NacciMethod() {
        print("Nacci().NacciMethod is called !!")
    }
}
*/
