package com.example.desk4work;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MiddleActivity extends FlutterActivity {
    private static final int PAYMENT_REQUEST_CODE = 800;
    private static final String CHANNEL = "desk4Work/payment";
    private double amount;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        GeneratedPluginRegistrant.registerWith(this);
        final double amount = getIntent().getDoubleExtra(PaymentActivity.KEY_AMOUNT,0);
        new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
                new MethodChannel.MethodCallHandler() {
                    @Override
                    public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                        Log.d("called method:", methodCall.method.toString());
                        Intent i = new Intent(MiddleActivity.this,PaymentActivity.class);
                        i.putExtra(PaymentActivity.KEY_AMOUNT, amount);
                        startActivityForResult(i,PAYMENT_REQUEST_CODE);
                    }
                }
        );

    }

    private void startPaymentProcess(){

    }



    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        Log.d("data from intent",data.toString());
    }
}
