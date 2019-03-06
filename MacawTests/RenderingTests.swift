//
//  RenderingTests.swift
//  MacawTests
//
//  Created by Andrew Romanov on 06/03/2019.
//  Copyright © 2019 Exyte. All rights reserved.
//

import XCTest
@testable import Macaw


class RenderingTests: XCTestCase {
	
	func testRenderScaleToFill() {
		let bundle = TestUtils.bundle
		guard let path = bundle.path(forResource: "floatBorders", ofType: "svg") else {
			XCTAssert(false)
			return
		}
		let svgNode = try! SVGParser.parse(fullPath: path)
		
		let resultImageWidth = 828.0
		guard let bounds = svgNode.bounds else {
			XCTAssert(false, "can't read bounds")
			return
		}
		
		let koeff = resultImageWidth / bounds.w
		
		let size = CGSize(width: ceil(bounds.w * koeff), height: ceil(bounds.h * koeff))
		let resulImage : UIImage = svgNode.toNativeImage(size: size.toMacaw(), layout: ContentLayout.of(contentMode: .scaleToFill))
		
		XCTAssert(resulImage.size == size)
		
		guard let cgIm = resulImage.cgImage else {
			XCTAssert(resulImage.cgImage != nil)
			return
		}
		
		for i in 0 ..< cgIm.width {
			for j in 0 ..< cgIm.height{
				let point = CGPoint(x: i, y: j)
				let color = cgIm.color(atPoint: point)
				XCTAssert(color.alpha == 1.0)
			}
		}
	}
	
	func testPerformanceExample() {
		// This is an example of a performance test case.
		self.measure {
			// Put the code you want to measure the time of here.
		}
	}
	
}

