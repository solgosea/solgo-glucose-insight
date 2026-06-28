package tk.glucodata;

import android.app.Activity;
import android.os.Bundle;
import android.widget.TextView;

public class ProbeFixtureActivity extends Activity {
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        TextView view = new TextView(this);
        view.setText("Juggluco Probe Fixture");
        view.setPadding(32, 32, 32, 32);
        setContentView(view);
    }
}
