package com.github.wuxudong.rncharts.charts;


import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.uimanager.ThemedReactContext;
import com.github.mikephil.charting.charts.CombinedChart;
import com.github.mikephil.charting.data.Entry;
import com.github.wuxudong.rncharts.data.CombinedDataExtract;
import com.github.wuxudong.rncharts.data.DataExtract;
import com.github.wuxudong.rncharts.listener.RNOnChartGestureListener;
import com.github.wuxudong.rncharts.listener.RNOnChartValueSelectedListener;

public class CombinedChartManager extends BarLineChartBaseManager<CombinedChart, Entry> {

    @Override
    public String getName() {
        return "RNCombinedChart";
    }

    @Override
    protected CombinedChart createViewInstance(ThemedReactContext reactContext) {
        CombinedChart combinedChart = new CombinedChart(reactContext);
        combinedChart.setOnChartValueSelectedListener(new RNOnChartValueSelectedListener(combinedChart));
        combinedChart.setOnChartGestureListener(new RNOnChartGestureListener(combinedChart));
        return combinedChart;
    }

    @Override
    public void setData(CombinedChart chart, ReadableMap propMap) {
        super.setData(chart, propMap);
        float chartRange = chart.getXChartMax() - chart.getXChartMin();
        chart.setVisibleXRangeMinimum(Math.min(chartRange, 600));
        chart.setVisibleXRangeMaximum(12*3600);
    }

    @Override
    DataExtract getDataExtract() {
        return new CombinedDataExtract();
    }




    @Override
    protected void onAfterUpdateTransaction(CombinedChart chart) {
        super.onAfterUpdateTransaction(chart);
        float chartRange = chart.getXChartMax() - chart.getXChartMin();
        System.out.println("Chart Range: " + chartRange);
    }
}
