import AVFoundation
import UIKit

public class ScannerOverlayPreviewLayer: AVCaptureVideoPreviewLayer {

    // MARK: - OverlayScannerPreviewLayer

    public var cornerLength: CGFloat = 30

    public var lineWidth: CGFloat = 6
    public var lineColor: UIColor = .white
    public var lineCap: CAShapeLayerLineCap = .round

    public var maskSize: CGSize = CGSize(width: 200, height: 200)

    public var rectOfInterest: CGRect {
        metadataOutputRectConverted(fromLayerRect: maskContainer)
    }

    public override var frame: CGRect {
        didSet {
            setNeedsDisplay()
        }
    }

    private var maskContainer: CGRect {
        CGRect(x: (bounds.width / 2) - (maskSize.width / 2),
        y: (bounds.height / 2) - (maskSize.height / 2),
        width: maskSize.width, height: maskSize.height)
    }

    // MARK: - Drawing

    public override func draw(in ctx: CGContext) {
        super.draw(in: ctx)

        // MARK: - Background Mask
        let path = CGMutablePath()
        path.addRect(bounds)
        path.addRoundedRect(in: maskContainer, cornerWidth: cornerRadius, cornerHeight: cornerRadius)

        let maskLayer = CAShapeLayer()
        maskLayer.path = path
        maskLayer.fillColor = UIColor.systemGray4.withAlphaComponent(0.5).cgColor // Gray tint with alpha
        maskLayer.fillRule = .evenOdd

        addSublayer(maskLayer)

        // MARK: - Edged Corners
        if cornerRadius > cornerLength { cornerRadius = cornerLength }
        if cornerLength > maskContainer.width / 2 { cornerLength = maskContainer.width / 2 }

        // Drawing corner shapes...
    }

}

//internal extension CGPoint {
//
//    // MARK: - CGPoint+offsetBy
//
//    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
//        var point = self
//        point.x += dx
//        point.y += dy
//        return point
//    }
//}
