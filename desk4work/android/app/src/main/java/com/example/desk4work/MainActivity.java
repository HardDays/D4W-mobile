package com.example.desk4work;

import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.util.Log;

import io.flutter.app.FlutterActivity;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugins.GeneratedPluginRegistrant;

public class MainActivity extends FlutterActivity {
  private static final int PAYMENT_REQUEST_CODE = 800;
  private static final String CHANNEL = "desk4Work/payment";
  private Double amount;
  private String coWorkingName;
  private int paymentMethod;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);
    GeneratedPluginRegistrant.registerWith(this);
//    final double amount = getIntent().getDoubleExtra(PaymentActivity.KEY_AMOUNT,0);
    new MethodChannel(getFlutterView(), CHANNEL).setMethodCallHandler(
            new MethodChannel.MethodCallHandler() {
              @Override
              public void onMethodCall(MethodCall methodCall, MethodChannel.Result result) {
                  Log.d("called method:", methodCall.method.toString());
                if (methodCall.method.equals("startPaymentProcess")){
                    amount = methodCall.argument(PaymentActivity.KEY_AMOUNT);
                    coWorkingName = methodCall.argument(PaymentActivity.KEY_CO_WORKING_NAME);
                    paymentMethod = methodCall.argument(PaymentActivity.KEY_PAYMENT_METHOD);
                    startPaymentProcess();
                }else{
                  Log.d("not starting", "payment activity");
                }
              }
            }
    );
  }

  private void startPaymentProcess(){
    Intent i = new Intent(MainActivity.this,PaymentActivity.class);
    i.putExtra(PaymentActivity.KEY_AMOUNT, amount);
    i.putExtra(PaymentActivity.KEY_CO_WORKING_NAME, coWorkingName);
    i.putExtra(PaymentActivity.KEY_PAYMENT_METHOD, paymentMethod);
    startActivityForResult(i,PAYMENT_REQUEST_CODE);
  }

  private void startPaymentMethodManagement(){}



  @Override
  protected void onActivityResult(int requestCode, int resultCode, Intent data) {
    super.onActivityResult(requestCode, resultCode, data);
    Log.d("data from intent",data.toString());
  }
}
