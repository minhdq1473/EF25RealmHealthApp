//
//  BarChartView.swift
//  EF25HealthApp
//
//  Created by iKame Elite Fresher 2025 on 21/8/25.
//

import UIKit

final class BarChartView: UIView {
    private var points: [(Date, Double)] = []
    private let barColor = UIColor.systemBlue
    private let axisColor = UIColor.secondaryLabel
    private let labelFont = UIFont.systemFont(ofSize: 10)
     
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .clear
        isOpaque = false
    }
    func setData(points: [(Date, Double)]) {
        self.points = points
        setNeedsDisplay()
    }

    override func draw(_ rect: CGRect) {
        guard !points.isEmpty, let context = UIGraphicsGetCurrentContext() else { return }
        let insetRect = rect.insetBy(dx: 8, dy: 8)

        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(1)
        context.move(to: CGPoint(x: insetRect.minX, y: insetRect.maxY))
        context.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY))
        context.strokePath()

        let maxValue = max(points.map { $0.1 }.max() ?? 1, 1)
        let count = CGFloat(points.count)
        let spacing: CGFloat = 6
        let barWidth = max(2, (insetRect.width - spacing * (count - 1)) / count)
        let calendar = Calendar.current
        for (index, point) in points.enumerated() {
            let value = CGFloat(point.1)
            let heightRatio = value / CGFloat(maxValue)
            let barHeight = max(1, insetRect.height * heightRatio)
            let x = insetRect.minX + CGFloat(index) * (barWidth + spacing)
            let y = insetRect.maxY - barHeight
            let barRect = CGRect(x: x, y: y, width: barWidth, height: barHeight)
            context.setFillColor(barColor.cgColor)
            context.fill(barRect)

            let weekday = calendar.component(.weekday, from: point.0)
            let sym = calendar.shortWeekdaySymbols[(weekday - 1) % 7]
            let text = String(sym.prefix(1)) as NSString
            let size = text.size(withAttributes: [.font: labelFont])
            let tx = x + (barWidth - size.width) / 2
            let ty = insetRect.maxY + 2
            text.draw(at: CGPoint(x: tx, y: ty), withAttributes: [.font: labelFont, .foregroundColor: axisColor])
        }
    }
}

final class TrendLineChartView: UIView {
    // Public API
    func setData(points: [(Date, Double)]) {
        self.points = points
        rebuildLabels()
        setNeedsLayout()
    }

    // MARK: - Private state
    private var points: [(Date, Double)] = []
    private let lineLayer = CAShapeLayer()
    private let fillLayer = CAShapeLayer()
    private let gridLayer = CAShapeLayer()
    private var markerLayers: [CAShapeLayer] = []
    private var xLabels: [UILabel] = []
    private let titleLabel = UILabel()
    private let gradientLayer = CAGradientLayer()

    // Layout constants
    private let topPadding: CGFloat = 28
    private let bottomPadding: CGFloat = 28
    private let leftPadding: CGFloat = 12
    private let rightPadding: CGFloat = 12

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        backgroundColor = UIColor.systemGray6
        layer.cornerRadius = 12
        layer.masksToBounds = true

        // Title
        titleLabel.text = "Steps"
        titleLabel.font = .systemFont(ofSize: 14, weight: .semibold)
        titleLabel.textColor = .label
        addSubview(titleLabel)

        // Grid
        gridLayer.strokeColor = UIColor.systemGray3.cgColor
        gridLayer.fillColor = UIColor.clear.cgColor
        gridLayer.lineWidth = 1
        gridLayer.lineDashPattern = [2, 4]
        layer.addSublayer(gridLayer)

        // Fill gradient under line
        gradientLayer.colors = [
            UIColor.systemBlue.withAlphaComponent(0.25).cgColor,
            UIColor.clear.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1)
        gradientLayer.mask = fillLayer
        layer.addSublayer(gradientLayer)

        // Line
        lineLayer.strokeColor = UIColor.systemBlue.cgColor
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = 2
        lineLayer.lineJoin = .round
        lineLayer.lineCap = .round
        layer.addSublayer(lineLayer)
    }

    // MARK: - Layout
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = CGRect(x: leftPadding, y: 8, width: bounds.width - leftPadding - rightPadding, height: 18)
        gradientLayer.frame = bounds
        drawGrid()
        drawChart()
        layoutXLabels()
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
        let count = max(points.count, 7) // draw 7 vertical guides by default
        for i in 0..<count {
            let x = rect.minX + (CGFloat(i) / CGFloat(max(count - 1, 1))) * rect.width
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
        gridLayer.path = path.cgPath
    }

    private func drawChart() {
        // Clear old markers
        markerLayers.forEach { $0.removeFromSuperlayer() }
        markerLayers.removeAll()

        let rect = chartFrame()
        guard rect.width > 0, rect.height > 0, !points.isEmpty else {
            lineLayer.path = nil
            fillLayer.path = nil
            return
        }

        // Values
        let values = points.map { $0.1 }
        let maxValue = max(values.max() ?? 1, 1)
        let minValue = min(values.min() ?? 0, 0)
        let range = max(maxValue - minValue, 1)

        func point(at index: Int) -> CGPoint {
            let x = rect.minX + (CGFloat(index) / CGFloat(max(points.count - 1, 1))) * rect.width
            let normalized = (values[index] - minValue) / range
            let y = rect.minY + (1 - CGFloat(normalized)) * rect.height
            return CGPoint(x: x, y: y)
        }

        // Build line path
        let linePath = UIBezierPath()
        let fillPath = UIBezierPath()
        let first = point(at: 0)
        linePath.move(to: first)
        fillPath.move(to: CGPoint(x: first.x, y: rect.maxY))
        fillPath.addLine(to: first)

        for i in 1..<points.count {
            let prev = point(at: i - 1)
            let curr = point(at: i)
            let mid = CGPoint(x: (prev.x + curr.x) / 2, y: (prev.y + curr.y) / 2)
            if i == 1 {
                linePath.addQuadCurve(to: mid, controlPoint: prev)
            } else {
                let pprev = point(at: i - 2)
                let prevMid = CGPoint(x: (pprev.x + prev.x) / 2, y: (pprev.y + prev.y) / 2)
                linePath.addCurve(to: mid, controlPoint1: prevMid, controlPoint2: prev)
            }
            fillPath.addLine(to: curr)
        }

        fillPath.addLine(to: CGPoint(x: point(at: points.count - 1).x, y: rect.maxY))
        fillPath.close()

        lineLayer.path = linePath.cgPath
        fillLayer.path = fillPath.cgPath

        // Markers (white inner, blue border)
        for i in 0..<points.count {
            let p = point(at: i)
            let outer = CAShapeLayer()
            let radius: CGFloat = 4
            outer.path = UIBezierPath(ovalIn: CGRect(x: p.x - radius, y: p.y - radius, width: radius * 2, height: radius * 2)).cgPath
            outer.fillColor = UIColor.white.cgColor
            outer.strokeColor = UIColor.systemBlue.cgColor
            outer.lineWidth = 2
            layer.addSublayer(outer)
            markerLayers.append(outer)
        }
    }

    // MARK: - X Labels
    private func rebuildLabels() {
        xLabels.forEach { $0.removeFromSuperview() }
        xLabels.removeAll()
        guard !points.isEmpty else { return }
        let df = DateFormatter()
        df.locale = .current
        df.setLocalizedDateFormatFromTemplate("EEE") // Fri, Sat
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
}
