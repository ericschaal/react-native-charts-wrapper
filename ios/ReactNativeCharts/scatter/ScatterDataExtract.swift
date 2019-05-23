//
//  ScatterDataExtract.swift
//  reactNativeCharts
//
//  Created by xudong wu on 02/03/2017.
//  Copyright © 2017 wuxudong. All rights reserved.
//

import Foundation

import SwiftyJSON
import Charts

class ScatterDataExtract : DataExtract {
    override func createData() -> ChartData {
        return ScatterChartData();
    }
    
    override func createDataSet(_ entries: [ChartDataEntry]?, label: String?) -> IChartDataSet {
        return ScatterChartDataSet(entries: entries, label: label)
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
        let scatterDataSet = dataSet as! ScatterChartDataSet;
        
        ChartDataSetConfigUtils.commonConfig(scatterDataSet, config: config);
        ChartDataSetConfigUtils.commonBarLineScatterCandleBubbleConfig(scatterDataSet, config: config);
        ChartDataSetConfigUtils.commonLineScatterCandleRadarConfig(scatterDataSet, config: config);
        
        // ScatterDataSet only config
        if config["scatterShapeSize"].float != nil {
            scatterDataSet.scatterShapeSize = CGFloat(config["scatterShapeSize"].floatValue)
        }
        if config["scatterShape"].string != nil {
            scatterDataSet.setScatterShape(BridgeUtils.parseScatterShape(config["scatterShape"].stringValue))
        }
        
        if config["scatterShapeHoleColor"].int != nil {
            scatterDataSet.scatterShapeHoleColor = RCTConvert.uiColor(config["scatterShapeHoleColor"].intValue);
        }
        
        if config["scatterShapeHoleRadius"].float != nil {
            scatterDataSet.scatterShapeHoleRadius = CGFloat(config["scatterShapeHoleRadius"].floatValue)
        }
        
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
}
