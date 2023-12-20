//
//  TESTVC.swift
//  TickerApp
//
//  Created by Serj on 10.12.2023.
//

import UIKit

//
//class TESTVC: UIViewController {
//
////    @IBOutlet weak var label: UILabel!
//    let label: UILabel = UILabel()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        self.label.text = "TEST1🎃"
//
//        // Предполагаем, что ваш UILabel уже содержит текст
//        guard let labelText = label.text else { return }
//
//        // Создаем UIImage из текста с помощью Core Graphics
//        let imageSize = CGSize(width: 300, height: 300)  // Задайте размер изображения
//        let renderer = UIGraphicsImageRenderer(size: imageSize)
//
//        let image = renderer.image { context in
//            let paragraphStyle = NSMutableParagraphStyle()
//            paragraphStyle.alignment = .center
//
//            let attributes: [NSAttributedString.Key: Any] = [
//                .font: UIFont.systemFont(ofSize: 16.0),
//                .foregroundColor: UIColor.black,
//                .paragraphStyle: paragraphStyle
//            ]
//
//            labelText.draw(in: CGRect(origin: .zero, size: imageSize), withAttributes: attributes)
//        }
//
//        // Теперь у вас есть изображение, которое вы можете модифицировать в пиксельный грид
//
//        // Пример: преобразование изображения в черно-белый пиксельный грид
//        let pixelGridView = convertToPixelGrid(image: image)
//
//        // Далее вы можете использовать pixelGridView для дальнейших манипуляций
//        // Например, вы можете отобразить его в UIImageView
//        let imageView = UIImageView(image: pixelGridView)
//        imageView.frame.origin = CGPoint(x: 50, y: 200)
//        view.addSubview(imageView)
//    }
//
////    func setUI() {
////
////    }
//
//    func convertToPixelGrid(image: UIImage) -> UIImage? {
//        // Пример: преобразование изображения в черно-белый пиксельный грид
//        let pixelData = image.pixelData()
//        let gridSize = CGSize(width: image.size.width, height: image.size.height)
//
//        UIGraphicsBeginImageContextWithOptions(gridSize, false, 0.0)
//
//        guard let context = UIGraphicsGetCurrentContext() else { return nil }
//
//        context.setFillColor(UIColor.white.cgColor)
//        context.fill(CGRect(origin: .zero, size: gridSize))
//
//        for x in 0..<Int(gridSize.width) {
//            for y in 0..<Int(gridSize.height) {
//                let index = (Int(image.size.width) * y + x) * 4
//                let alpha = CGFloat(pixelData[index + 3]) / 255.0
//                context.setFillColor(UIColor(white: 0, alpha: alpha).cgColor)
//                context.fill(CGRect(x: CGFloat(x), y: CGFloat(y), width: 1.0, height: 1.0))
//            }
//        }
//
//        let pixelGridView = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return pixelGridView
//    }
//}
//
//extension UIImage {
//    func pixelData() -> [UInt8] {
//        let cgImage = self.cgImage!
//        let dataSize = cgImage.width * cgImage.height * 4
//        var pixelData = [UInt8](repeating: 0, count: dataSize)
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
//        let context = CGContext(
//            data: &pixelData,
//            width: cgImage.width,
//            height: cgImage.height,
//            bitsPerComponent: 8,
//            bytesPerRow: 4 * cgImage.width,
//            space: colorSpace,
//            bitmapInfo: bitmapInfo.rawValue
//        )!
//
//        context.draw(cgImage, in: CGRect(x: 0, y: 0, width: cgImage.width, height: cgImage.height))
//
//        return pixelData
//    }
//}
