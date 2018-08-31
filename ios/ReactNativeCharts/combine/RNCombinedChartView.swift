//  Created by xudong wu on 24/02/2017.
//  Copyright wuxudong
//

import Charts
import SwiftyJSON

class RNCombinedChartView: RNBarLineChartViewBase {

    let _chart: CombinedChartView;
    let _dataExtract : CombinedDataExtract;

    override var chart: CombinedChartView {
        return _chart
    }
    
    override var dataExtract: DataExtract {
        return _dataExtract
    }
  
  
  override func setData(_ data: NSDictionary) {
    let json = BridgeUtils.toJson(data)
    chart.data = dataExtract.extract(json)
    if let chartData = chart.data {
      let chartRange = chartData.xMax - chartData.xMin
      let minRange = min(chartRange, 5*60)
      chart.setVisibleXRangeMinimum(minRange) // 10mn
      chart.setVisibleXRangeMaximum(12*3600) // 12h
    }
  }
  
    override init(frame: CoreGraphics.CGRect) {

        self._chart = CombinedChartView(frame: frame)
        self._dataExtract = CombinedDataExtract()

        super.init(frame: frame)
      

        self._chart.delegate = self
        self.addSubview(_chart)
      
      let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(chartViewLongPress(gesture:)))
      gestureRecognizer.minimumPressDuration = 0.25;
      self.addGestureRecognizer(gestureRecognizer);
      
      self._chart.highlightFullBarEnabled = true;
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setDrawValueAboveBar(_ enabled: Bool) {
        _chart.drawValueAboveBarEnabled = enabled
    }

    func setDrawBarShadow(_ enabled: Bool) {
        _chart.drawBarShadowEnabled = enabled
    }

    func setHighlightFullBarEnabled(_ enabled: Bool) {
        _chart.highlightFullBarEnabled = enabled
    }

}
