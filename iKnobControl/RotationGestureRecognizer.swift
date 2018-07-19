//
//  RotationGestureRecognizer.swift
//  iReusableKnob
//
//  Created by eagle two on 2018/06/23.
//  Copyright © 2018年 isshie. All rights reserved.
//
        

import UIKit.UIGestureRecognizerSubclass

// 画面全体にドラッグした単一の指を追跡し、必要に応じて場所を更新します。
@IBDesignable class RotationGestureRecognizer: UIPanGestureRecognizer {
    // ビューの 現在のタッチポイントを中心 に結合する線のタッチ角を表します。
    private(set) var touchAngle: CGFloat = 0
    
    // 一度にワンタッチで動作しなければならない
    override init(target: Any?, action: Selector?) {
        super.init(target: target, action: action)
        
        maximumNumberOfTouches = 1
        minimumNumberOfTouches = 1
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesBegan(touches, with: event)
        updateAngle(with: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        super.touchesMoved(touches, with: event)
        updateAngle(with: touches)
    }
    // updateAngle(with:)は一連のタッチを受け取り、最初のものを抽出します。
    private func updateAngle(with touches: Set<UITouch>) {
        guard
            let touch = touches.first,
            let view = view
            else {
                return
        }
        // location(in:)を使用して、このgesture recognizerに関連付けられたビューの座標系にタッチポイントを変換します。
        let touchPoint = touch.location(in: view)
        // タッチ角の計算
        touchAngle = angle(for: touchPoint, in: view)
    }
    
    // タッチ角の計算
    private func angle(for point: CGPoint, in view: UIView) -> CGFloat {
        let centerOffset = CGPoint(x: point.x - view.bounds.midX, y: point.y - view.bounds.midY)
        return atan2(centerOffset.y, centerOffset.x)
    }
    

}
