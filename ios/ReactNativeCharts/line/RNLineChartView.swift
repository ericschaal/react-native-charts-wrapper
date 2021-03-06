//  Created by xudong wu on 24/02/2017.
//  Copyright wuxudong
//

import Charts
import SwiftyJSON

class RNLineChartView: RNBarLineChartViewBase {
  let _chart: LineChartView;
  let _dataExtract : LineDataExtract;
  var _loaded: Bool;
  
  override var chart: LineChartView {
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
      let minRange = min(chartRange/2, 5*60)
      chart.setVisibleXRangeMinimum(minRange) // 10mn
      chart.setVisibleXRangeMaximum(12*3600) // 12h
    }
    
    if (!_loaded) {
      sendEvent("chartLoaded")
      _loaded = true
    }
    
  }
  
  override init(frame: CoreGraphics.CGRect) {
    self._loaded = false;
    self._chart = LineChartView(frame: frame)
    self._dataExtract = LineDataExtract()
    
    super.init(frame: frame);
    
    self._chart.delegate = self
    self.addSubview(_chart);
    
    
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
