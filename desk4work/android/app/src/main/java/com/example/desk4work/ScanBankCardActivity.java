package com.example.desk4work;

import android.app.Activity;
import android.content.Intent;
import android.support.v7.app.AppCompatActivity;

import ru.yandex.money.android.sdk.Checkout;

public class ScanBankCardActivity extends AppCompatActivity {

    private void onScanningDone(final String cardNumber, final int expirationMonth, final int expirationYear) {

        final Intent result = Checkout.createScanBankCardResult(cardNumber, expirationMonth, expirationYear);

        setResult(Activity.RESULT_OK, result);

        finish();

    }
}
