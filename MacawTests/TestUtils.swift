import Foundation
import Macaw
import CoreImage
import ImageIO
import CoreImage


class TestUtils {

	class func compareWithReferenceObject(_ fileName: String, referenceObject: AnyObject) -> Bool {
        // TODO: this needs to be replaced with SVG tests
		return true
	}

	class func prepareParametersList(_ mirror: Mirror) -> [(String, String)] {
		var result: [(String, String)] = []
		for (_, attribute) in mirror.children.enumerated() {
			if let label = attribute.label , (label == "_value" || label.first != "_") && label != "contentsVar" {
				result.append((label, String(describing: attribute.value)))
				result.append(contentsOf: prepareParametersList(Mirror(reflecting: attribute.value)))
			}
		}
		return result
	}
	
	
	class var bundle : Bundle {
		let bundle = Bundle(for:self)
		return bundle
	}
}


extension CGColor {
	
	public class func createRGBColor(withRed red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> CGColor {
		let colorSpace = CGColorSpaceCreateDeviceRGB()
		let array = [red, green, blue, alpha]
		let pointer = UnsafePointer<CGFloat>(array)
		let color = CGColor(colorSpace: colorSpace, components: pointer)!
		return color;
	}
	
	public class var clear : CGColor {
		get {
			let color = createRGBColor(withRed: 0.0, green: 0.0, blue: 0.0, alpha: 0.0)
			return color
		}
	}

	public var red : CGFloat {
		get{
			let coreColor = CIColor(cgColor: self)
			let redVal = coreColor.red
			return redVal
		}
	}
	
	
	public var green : CGFloat {
		get {
			let coreColor = CIColor(cgColor: self)
			let greenVal = coreColor.green
			return greenVal
		}
	}
	
	
	public var blue : CGFloat {
		get {
			let coreColor = CIColor(cgColor: self)
			let blueVal = coreColor.blue
			return blueVal
		}
	}
	
	
	public var alpha : CGFloat {
		get {
			let coreColor = CIColor(cgColor: self)
			let alphaVal = coreColor.alpha
			return alphaVal
		}
		
	}

}



extension CGImage {
	public func color(atPoint point: CGPoint) -> CGColor {
		guard let dataProvider = self.dataProvider else {
			return CGColor.clear
		}
		guard let pixelData = dataProvider.data else{
			return CGColor.clear
		}
		guard (point.x >= 0.0 && point.x < CGFloat(self.width) &&
					 point.y >= 0.0 && point.y < CGFloat(self.height)) else {
			return CGColor.clear
		}
		let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
		
		let pixelInfo: Int = ((self.width * Int(point.y)) + Int(point.x)) * 4
		
		let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
		let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
		let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
		let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
		
		return CGColor.createRGBColor(withRed: r, green: g, blue: b, alpha: a)
	}
}





