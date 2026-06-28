package tk.glucodata.probe;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.util.Log;

public class JugglucoProbeFixtureReceiver extends BroadcastReceiver {
    private static final String TAG = "JugglucoProbeFixture";
    private static final String ACTION_SEND_GLUCOSE = "com.metaguru.probe.JUGGLUCO_SEND_GLUCOSE";
    private static final String ACTION_GLUCODATA_MINUTE = "glucodata.Minute";
    private static final String ACTION_XDRIP_BG_ESTIMATE = "com.eveningoutpost.dexdrip.BgEstimate";

    @Override
    public void onReceive(Context context, Intent intent) {
        if (intent == null || !ACTION_SEND_GLUCOSE.equals(intent.getAction())) {
            return;
        }
        long timestamp = intent.getLongExtra("timestamp", System.currentTimeMillis());
        float glucose = intent.getFloatExtra("glucose", 121f);
        boolean xdripCompatible = intent.getBooleanExtra("xdripCompatible", false);
        Log.i(TAG, "Forwarding glucose=" + glucose + " timestamp=" + timestamp + " xdripCompatible=" + xdripCompatible);

        Intent outbound = xdripCompatible
                ? new Intent(ACTION_XDRIP_BG_ESTIMATE)
                : new Intent(ACTION_GLUCODATA_MINUTE);
        outbound.putExtra("timestamp", timestamp);
        outbound.putExtra("time", timestamp);
        outbound.putExtra("date", timestamp);
        outbound.putExtra("glucose", glucose);
        outbound.putExtra("unit", "mg/dL");
        if (xdripCompatible) {
            outbound.putExtra("com.eveningoutpost.dexdrip.Extras.Time", timestamp);
            outbound.putExtra("com.eveningoutpost.dexdrip.Extras.BgEstimate", glucose);
        } else {
            outbound.putExtra("glucodata.Minute.Time", timestamp);
            outbound.putExtra("glucodata.Minute.glucose", glucose);
            outbound.putExtra("glucodata.Minute.mgdl", glucose);
        }
        context.sendBroadcast(outbound);

        Intent explicit = new Intent(outbound);
        explicit.setClassName(
                "com.metaguru.smartxdrip",
                "com.metaguru.smartxdrip.statusmonitor.juggluco.JugglucoBroadcastReceiver");
        context.sendBroadcast(explicit);
        Log.i(TAG, "Forwarded explicit Juggluco evidence to SolgoInsight");
    }
}
