//  Created by xudong wu on 02/03/2017.
//  Copyright © 2017 wuxudong. All rights reserved.
//

import Foundation

import SwiftyJSON
import Charts

class LineDataExtract : DataExtract {
  override func createData() -> ChartData {
    return LineChartData();
  }
  
  override func createDataSet(_ entries: [ChartDataEntry]?, label: String?) -> IChartDataSet {
    return LineChartDataSet(values: entries, label: label)
  }
  
  
  override func extract(_ data: JSON) -> ChartData?  {
    if data["dataSets"].array == nil {
      return nil;
    }
    
    let chartData = createData();
    
    
    let dataSets = data["dataSets"].arrayValue;
    
    for (_, dataSet) in dataSets.enumerated() {
      
      let values = dataSet["values"].arrayValue;
      let label = dataSet["label"].stringValue;
      
      
      
      var entries: [ChartDataEntry];
      
      if (dataSet["xAccessor"].string != nil && dataSet["yAccessor"].string != nil) {
        let xAccessor = dataSet["xAccessor"].stringValue;
        let yAccessor = dataSet["yAccessor"].stringValue;
        entries = createEntries(values, xAccessor, yAccessor);
      } else {
        entries = createEntries(values)
      }
        
      let chartDataSet = createDataSet(entries, label: label);
      
      if dataSet["config"].dictionary != nil {
        dataSetConfig(chartDataSet, config: dataSet["config"])
      }
      
      chartData.addDataSet(chartDataSet);
    }
    
    if data["config"].dictionary != nil {
      dataConfig(chartData, config: data["config"])
    }
    
    
    return chartData
    
  }
  
  func createEntries(_ values: [JSON], _ xAccessor: String, _ yAccessor: String) -> [ChartDataEntry] {
    var entries = [ChartDataEntry]();
    for (index, value) in values.enumerated() {
      if value.null == nil {
        entries.append(createEntry(values, index: index, xAccessor: xAccessor, yAccessor: yAccessor))
      }
    }
    
    return entries;
    
  }
  
  override func dataSetConfig(_ dataSet: IChartDataSet, config: JSON) {
    
    
    let lineDataSet = dataSet as! LineChartDataSet;
    
    ChartDataSetConfigUtils.commonConfig(lineDataSet, config: config);
    ChartDataSetConfigUtils.commonBarLineScatterCandleBubbleConfig(lineDataSet, config: config);
    ChartDataSetConfigUtils.commonLineScatterCandleRadarConfig(lineDataSet, config: config);
    ChartDataSetConfigUtils.commonLineRadarConfig(lineDataSet, config: config);
    
    // LineDataSet only config
    if config["circleRadius"].number != nil {
      lineDataSet.circleRadius = CGFloat(config["circleRadius"].numberValue)
    }
    
    
    if config["drawCircles"].bool != nil {
      lineDataSet.drawCirclesEnabled = config["drawCircles"].boolValue
    }
    
    
    if config["mode"].string != nil {
      lineDataSet.mode = BridgeUtils.parseLineChartMode(config["mode"].stringValue)
    }
    
    
    if config["drawCubicIntensity"].number != nil {
      lineDataSet.cubicIntensity = CGFloat(config["drawCubicIntensity"].numberValue);
    }
    
    
    if config["circleColor"].int != nil {
      lineDataSet.setCircleColor(RCTConvert.uiColor(config["circleColor"].intValue))
    }
    
    if config["circleColors"].array != nil {
      lineDataSet.circleColors = BridgeUtils.parseColors(config["circleColors"].arrayValue)
    }
    
    if config["circleHoleColor"].int != nil {
      lineDataSet.circleHoleColor = RCTConvert.uiColor(config["circleHoleColor"].intValue)
    }
    
    
    if config["drawCircleHole"].bool != nil {
      lineDataSet.drawCircleHoleEnabled = config["drawCircleHole"].boolValue
    }
    
    if config["dashedLine"].exists() {
      let dashedLine = config["dashedLine"]
      var lineLength = CGFloat(0);
      var spaceLength = CGFloat(0);
      var phase = CGFloat(0);
      
      if dashedLine["lineLength"].number != nil {
        lineLength = CGFloat(dashedLine["lineLength"].numberValue)
      }
      if dashedLine["spaceLength"].number != nil {
        spaceLength = CGFloat(dashedLine["spaceLength"].numberValue)
      }
      if dashedLine["phase"].number != nil {
        phase = CGFloat(dashedLine["phase"].numberValue)
      }
      
      lineDataSet.lineDashLengths = [lineLength, spaceLength]
      lineDataSet.lineDashPhase = phase
    }
  }
  
  override func createEntry(_ values: [JSON], index: Int) -> ChartDataEntry {
    var entry: ChartDataEntry;
    
    var x = Double(index);
    let value = values[index];
    
    if value.dictionary != nil {
      let dict = value;
      
      if dict["x"].double != nil {
        x = Double((dict["x"].doubleValue));
      }
      
      if dict["y"].number != nil {
        entry = ChartDataEntry(x: x, y: dict["y"].doubleValue, data: dict as AnyObject?);
      } else {
        fatalError("invalid data " + values.description);
      }
      
      
    } else if value.double != nil {
      entry = ChartDataEntry(x: x, y: value.doubleValue);
    } else {
      fatalError("invalid data " + values.description);
    }
    
    return entry;
  }
  
  override func createEntry(_ values: [JSON], index: Int, xAccessor: String, yAccessor: String) -> ChartDataEntry {
    var entry: ChartDataEntry;
    
    var x = Double(index);
    let value = values[index];
    
    if value.dictionary != nil {
      let dict = value;
      
      if dict[xAccessor].double != nil {
        x = Double((dict[xAccessor].doubleValue));
      }
      
      if dict[yAccessor].number != nil {
        entry = ChartDataEntry(x: x, y: dict[yAccessor].doubleValue, data: dict as AnyObject?);
      } else {
        fatalError("invalid data " + values.description);
      }
      
      
    } else if value.double != nil {
      entry = ChartDataEntry(x: x, y: value.doubleValue);
    } else {
      fatalError("invalid data " + values.description);
    }
    
    return entry;
  }
}
