package edu.berkeley.eecs.acclogger;

import android.app.Activity;
import android.os.Bundle;

import android.R.array;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.TextView;

import com.getpebble.android.kit.PebbleKit;
import com.google.common.primitives.UnsignedInteger;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.TimeZone;
import java.util.UUID;


public class AccLoggerActivity extends Activity
{

  private static final UUID ACC_LOGGER_APP_UUID = UUID.fromString("7B017F7D-21AB-4E18-8FF5-7F63B6E30345");
  private static final DateFormat DATE_FORMAT = new SimpleDateFormat("HH:mm:ss");
  private String mDisplayText;
  private PebbleKit.PebbleDataLogReceiver mDataLogReceiver = null;

  public BufferedWriter logFileWriter = null;
  private String filename = "logfile.csv";
  

  /** Called when the activity is first created. */
  @Override
  public void onCreate(Bundle savedInstanceState)
  {
    super.onCreate(savedInstanceState);
    setContentView(R.layout.main);
    DATE_FORMAT.setTimeZone(TimeZone.getDefault());


    File root = Environment.getExternalStorageDirectory();
    File file = new File(root, filename);
    
    try {
      if (root.canWrite()) {
	FileWriter filewriter = new FileWriter(file, true);
	this.logFileWriter = new BufferedWriter(filewriter);
      }
    } catch (IOException e) {
      Log.e("TAG", "Could not write file " + e.getMessage());
    }
  }


  @Override
  protected void onPause() {
    super.onPause();
    if (mDataLogReceiver != null) {
      unregisterReceiver(mDataLogReceiver);
      mDataLogReceiver = null;
    }
  }
  
  @Override
  protected void onDestroy() {
    if (this.logFileWriter != null) {
      try {
	this.logFileWriter.close();
	logFileWriter = null;
      } catch (IOException e) {
      Log.e("TAG", "Could not write file " + e.getMessage());
      }
    }

    super.onDestroy();
  }

  private int count = 0;  
  @Override
  protected void onResume() {
    super.onResume();
    final Handler handler = new Handler();

    mDataLogReceiver = new PebbleKit.PebbleDataLogReceiver(ACC_LOGGER_APP_UUID) {
	@Override
	public void receiveData(Context context, UUID logUuid, UnsignedInteger timestamp, UnsignedInteger tag, byte[] data) {

	  for (AccelData reading : AccelData.fromDataArray(data)) {
	    mDisplayText += reading.toString() + "\n";

	    Log.i("acc", reading.toJson().toString());
	    count += 1;
	    if (count > 20) {
	      count = 0;
	      try {
		logFileWriter.write(mDisplayText);
	      } catch (IOException e) {
		Log.e("TAG", "Could not write file " + e.getMessage());
	      }
	      mDisplayText = "";
	    }
	  }

	  handler.post(new Runnable() {
	      @Override
	      public void run() {
		updateUi();
	      }
	    });
	}
      };

    PebbleKit.registerDataLogReceiver(this, mDataLogReceiver);
    PebbleKit.requestDataLogsForApp(this, ACC_LOGGER_APP_UUID);
  }

  private void updateUi() {
    TextView textView = (TextView) findViewById(R.id.log_data_text_view);
    textView.setText(mDisplayText);
  }

  private String getUintAsTimestamp(UnsignedInteger uint) {
    return DATE_FORMAT.format(new Date(uint.longValue() * 1000L)).toString();
  }

}
