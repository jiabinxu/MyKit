//
//  CGPoint+.swift
//  MyKit
//
//  Created by Hai Nguyen on 6/29/15.
//  
//

public func CGPointDistanceToPoint(p1: CGPoint, _ p2: CGPoint) -> CGFloat {
    return sqrt(pow(p1.x - p2.x, 2) + pow(p1.y - p2.y, 2))
}