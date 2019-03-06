//
//  PixelColorsProvider.swift
//  MacawTests
//
//  Created by Andrew Romanov on 06/03/2019.
//  Copyright © 2019 Exyte. All rights reserved.
//

import Foundation
import CoreGraphics
import ImageIO


public class PixelColorsProvider {
	
	private let binaryData : UnsafePointer<UInt8>
	private let width : Int
	private let height : Int
	
	public init?(withImage image: CGImage) {
		
		width = image.width
		height = image.height
		
		let writeInData = UnsafeMutablePointer<UInt8>.allocate(capacity: width * height * 4)
		writeInData.initialize(to: 0)
		
		guard let context = CGContext(data: writeInData,
														 width: width,
														 height: height,
														 bitsPerComponent: 8,
														 bytesPerRow: 4 * width,
														 space: CGColorSpaceCreateDeviceRGB(),
														 bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.last.rawValue).rawValue) else {
															assert(false)
															return nil
		}
		context.translateBy(x: 0.0, y: CGFloat(height))
		context.scaleBy(x: 1.0, y: -1.0)
		context.draw(image, in: CGRect(x: 0, y: 0, width: width, height: height))
		
		binaryData = UnsafePointer<UInt8>(writeInData)
	}
	
	
	deinit {
		binaryData.deallocate()
	}
	
	
	public func color(atPixel pixel: CGPoint)-> CGColor {
		let offset : Int = self.width * Int(pixel.y) + Int(pixel.x)
		
		guard offset >= 0 && offset < self.width * self.height * 4 else {
			return CGColor.clear
		}
		
		let red = self.binaryData[offset]
		let green = self.binaryData[offset + 1]
		let blue = self.binaryData[offset + 2]
		let alpha = self.binaryData[offset + 3]
		
		let color = CGColor.createRGBColor(withRed: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: CGFloat(alpha) / 255.0)
		
		return color
	}
	
}
