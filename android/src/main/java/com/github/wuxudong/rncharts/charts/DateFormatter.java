package com.github.wuxudong.rncharts.charts;

import com.github.mikephil.charting.components.AxisBase;
import com.github.mikephil.charting.data.Entry;
import com.github.mikephil.charting.formatter.IAxisValueFormatter;
import com.github.mikephil.charting.formatter.IValueFormatter;
import com.github.mikephil.charting.utils.ViewPortHandler;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.concurrent.TimeUnit;

/**
 * Created by dougl on 05/09/2017.
 */
public class DateFormatter implements IAxisValueFormatter, IValueFormatter {

    private String pattern;

    private long since = 0;

    private TimeUnit timeUnit;

    public DateFormatter(String pattern, long since, TimeUnit timeUnit) {
        //mFormat = new SimpleDateFormat(pattern, java.util.Locale.getDefault());

        this.since = since;
        this.pattern = pattern;
        this.timeUnit = timeUnit;
    }

    @Override
    public String getFormattedValue(float value, AxisBase yAxis) {
        return format((long) value);
    }

    @Override
    public String getFormattedValue(float value, Entry entry, int dataSetIndex, ViewPortHandler viewPortHandler) {
        return format((long) value);
    }

    private String format(long span) {
        if (pattern == "hh.mm.ss") {
            return DateFormat.getTimeInstance(DateFormat.MEDIUM).format(new Date(since + timeUnit.toMillis(span)));
        } else if ( pattern == "hh.mm") {
            return DateFormat.getTimeInstance(DateFormat.SHORT).format(new Date(since + timeUnit.toMillis(span)));
        } else {
            return DateFormat.getTimeInstance(DateFormat.SHORT).format(new Date(since + timeUnit.toMillis(span)));
        }
    }
}
