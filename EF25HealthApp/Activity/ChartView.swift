//
//  BarChartView.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 21/8/25.
//

import UIKit

final class LineChartView: UIView {
    func setData(points: [(Date, Double)]) {
        self.points = points
        rebuildLabels()
        setNeedsLayout()
    }

    private var points: [(Date, Double)] = []
    private let lineLayer = CAShapeLayer()
    private let fillLayer = CAShapeLayer()
    private let gridLayer = CAShapeLayer()
    private let yGridLayer = CAShapeLayer()
    private var markerLayers: [CAShapeLayer] = []
    private var xLabels: [UILabel] = []
    private var yLabels: [UILabel] = []
    private let titleLabel = UILabel()
    private let gradientLayer = CAGradientLayer()
    private var lastYMax: Double = 0

    private let topPadding: CGFloat = 28
    private let bottomPadding: CGFloat = 28
    private let leftPadding: CGFloat = 48
    private let rightPadding: CGFloat = 16

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.neutral5
        layer.cornerRadius = 12
        layer.masksToBounds = true

        titleLabel.text = "Steps"
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .neutral1
        addSubview(titleLabel)

        gridLayer.strokeColor = UIColor.systemGray3.cgColor
        gridLayer.fillColor = UIColor.clear.cgColor
        gridLayer.lineWidth = 1
        gridLayer.lineDashPattern = [2, 4]
        layer.addSublayer(gridLayer)

        yGridLayer.strokeColor = UIColor.systemGray3.cgColor
        yGridLayer.fillColor = UIColor.clear.cgColor
        yGridLayer.lineWidth = 1
        yGridLayer.lineDashPattern = [2, 4]
        layer.addSublayer(yGridLayer)

        gradientLayer.colors = [
            UIColor.primary1.withAlphaComponent(0.25).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.mask = fillLayer
        layer.addSublayer(gradientLayer)

        lineLayer.strokeColor = UIColor.primary1.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = 2
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        layer.addSublayer(lineLayer)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: leftPadding, y: 8, width: bounds.width - leftPadding - rightPadding, height: 18)
        gradientLayer.frame = bounds
        drawGrid()
        drawChart()
        layoutXLabels()
        layoutYLabels()
    }

    private func chartFrame() -> CGRect {
        return CGRect(x: leftPadding,
                      y: topPadding,
                      width: bounds.width - leftPadding - rightPadding,
                      height: bounds.height - topPadding - bottomPadding)
    }

    private func drawGrid() {
        let rect = chartFrame()
        guard rect.width > 0, rect.height > 0 else { return }

        let path = UIBezierPath()
        let count = max(points.count, 7)
        for i in 0..<count {
            let x = rect.minX + (CGFloat(i) / CGFloat(max(count - 1, 1))) * rect.width
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        gridLayer.path = path.cgPath

        let yPath = UIBezierPath()
        let ticks = 5
        for i in 0..<ticks {
            let t = CGFloat(i) / CGFloat(ticks - 1)
            let y = rect.maxY - t * rect.height
            yPath.move(to: CGPoint(x: rect.minX, y: y))
            yPath.addLine(to: CGPoint(x: rect.maxX, y: y))
        }
        yGridLayer.path = yPath.cgPath
    }

    private func drawChart() {
        markerLayers.forEach { $0.removeFromSuperlayer() }
        markerLayers.removeAll()

        let rect = chartFrame()
        guard rect.width > 0, rect.height > 0, !points.isEmpty else {
            lineLayer.path = nil
            fillLayer.path = nil
            return
        }

        let values = points.map { $0.1 }
        let rawMax = max(values.max() ?? 1, 1)
        let yMax = niceCeil(rawMax)
        lastYMax = yMax
        let yMin: Double = 0
        let range = max(yMax - yMin, 1)

        func point(at index: Int) -> CGPoint {
            let x = rect.minX + (CGFloat(index) / CGFloat(max(points.count - 1, 1))) * rect.width
            let normalized = (values[index] - yMin) / range
            let y = rect.minY + (1 - CGFloat(normalized)) * rect.height
            return CGPoint(x: x, y: y)
        }

        let linePath = UIBezierPath()
        let fillPath = UIBezierPath()
        let first = point(at: 0)
        linePath.move(to: first)
        fillPath.move(to: CGPoint(x: first.x, y: rect.maxY))
        fillPath.addLine(to: first)

        for i in 1..<points.count {
            let curr = point(at: i)
            linePath.addLine(to: curr)
            fillPath.addLine(to: curr)
        }

        fillPath.addLine(to: CGPoint(x: point(at: points.count - 1).x, y: rect.maxY))
        fillPath.close()

        lineLayer.path = linePath.cgPath
        fillLayer.path = fillPath.cgPath

        rebuildYLabels(maxValue: yMax)

        for i in 0..<points.count {
            let p = point(at: i)
            let outer = CAShapeLayer()
            let radius: CGFloat = 4
            outer.path = UIBezierPath(ovalIn: CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)).cgPath
            outer.fillColor = UIColor.neutral5.cgColor
            outer.strokeColor = UIColor.primary1.cgColor
            outer.lineWidth = 2
            layer.addSublayer(outer)
            markerLayers.append(outer)
        }
    }
    
    private func rebuildLabels() {
        xLabels.forEach { $0.removeFromSuperview() }
        xLabels.removeAll()
        guard !points.isEmpty else { return }
        let df = DateFormatter()
        df.locale = .current
        df.setLocalizedDateFormatFromTemplate("EEE")
        for (date, _) in points {
            let label = UILabel()
            label.text = df.string(from: date)
            label.font = .systemFont(ofSize: 12, weight: .regular)
            label.textColor = .secondaryLabel
            label.textAlignment = .center
            addSubview(label)
            xLabels.append(label)
        }
    }

    private func layoutXLabels() {
        let rect = chartFrame()
        guard rect.width > 0, !xLabels.isEmpty else { return }
        for (i, label) in xLabels.enumerated() {
            let x = rect.minX + (CGFloat(i) / CGFloat(max(xLabels.count - 1, 1))) * rect.width
            label.frame = CGRect(x: x - 20, y: rect.maxY + 4, width: 40, height: 16)
        }
    }

    // MARK: - Y labels and helpers
    private func rebuildYLabels(maxValue: Double) {
        yLabels.forEach { $0.removeFromSuperview() }
        yLabels.removeAll()
        let ticks = 5
        for i in 0..<ticks {
            let label = UILabel()
            label.text = formatSteps(maxValue * Double(i) / Double(ticks - 1))
            label.font = .systemFont(ofSize: 11, weight: .regular)
            label.textColor = .secondaryLabel
            label.textAlignment = .right
            addSubview(label)
            yLabels.append(label)
        }
    }

    private func layoutYLabels() {
        let rect = chartFrame()
        guard rect.height > 0, !yLabels.isEmpty else { return }
        let ticks = yLabels.count
        for i in 0..<ticks {
            let t = CGFloat(i) / CGFloat(ticks - 1)
            let y = rect.maxY - t * rect.height
            yLabels[i].frame = CGRect(x: 0, y: y - 8, width: leftPadding - 6, height: 16)
        }
    }

    private func niceCeil(_ v: Double) -> Double {
        if v <= 1000 { return 1000 }
        let magnitude = pow(10.0, floor(log10(v)))
        let normalized = v / magnitude
        let nice: Double
        if normalized <= 1 { nice = 1 }
        else if normalized <= 2 { nice = 2 }
        else if normalized <= 5 { nice = 5 }
        else { nice = 10 }
        return nice * magnitude
    }

    private func formatSteps(_ value: Double) -> String {
        let v = Int(round(value))
        if v >= 1000 {
            return String(format: "%.0f", Double(v))
        }
        return "\(v)"
    }
}
