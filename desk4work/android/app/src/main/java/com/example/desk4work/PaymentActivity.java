package com.example.desk4work;

import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.preference.PreferenceManager;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.text.InputType;
import android.util.Log;
import android.view.View;
import android.view.inputmethod.EditorInfo;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;

import com.example.desk4work.utils.AmountFormatter;

import org.jetbrains.annotations.NotNull;

import java.math.BigDecimal;
import java.util.Currency;
import java.util.HashSet;
import java.util.Locale;
import java.util.Set;

import ru.yandex.money.android.sdk.Amount;
import ru.yandex.money.android.sdk.Checkout;
import ru.yandex.money.android.sdk.Configuration;
import ru.yandex.money.android.sdk.PaymentMethodType;
import ru.yandex.money.android.sdk.ShopParameters;

public class PaymentActivity extends AppCompatActivity {

    private static final BigDecimal MAX_AMOUNT = new BigDecimal("99999.99");
    public static final Currency RUB = Currency.getInstance("RUB");
    public static final String KEY_AMOUNT = "amount";
    public static final String KEY_CO_WORKING_NAME = "coWorkingName";


    @Nullable
    private View buyButton;
    @NonNull
    private BigDecimal amount = BigDecimal.ZERO;

    private String placeName;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        initUi();

        // Attach MSDK to supportFragmentManager
        Checkout.attach(getSupportFragmentManager());

        // Set action on MSDK result
        Checkout.setResultCallback((paymentToken, type)
                -> {
            startActivity(SuccessTokenizeActivity.createIntent(this, paymentToken, type.name()));
            finish();
        });

        onBuyClick();
    }

    private void onBuyClick() {
        if (validateAmount()) {
            final Settings settings = new Settings(this);
            final Set<PaymentMethodType> paymentMethodTypes = getPaymentMethodTypes(settings);

            Checkout.configureTestMode(
                    new Configuration(
                             true, // enableTestMode - is test mode enabled,
                             false, // completeWithError - complete tokenization with error,
                            true, // paymentAuthPassed - user authenticated,
                            5, // linkedCardsCount - test linked cards count,
                             true, // googlePayAvailable - emulate google pay availability,
                            true // googlePayTestEnvironment - use google pay test environment
                    )
            );

            // Start MSDK to get payment token
            Checkout.tokenize(
                    this,
                    new Amount(amount, RUB),
                    new ShopParameters(
//                            getString(R.string.main_product_name),
                            placeName,
                            getString(R.string.main_product_description),
//                            BuildConfig.MERCHANT_TOKEN,
                            "MERCHANT_TOKEN",
                            paymentMethodTypes,
                            paymentMethodTypes.isEmpty() || settings.isGooglePayAllowed(),
//                            BuildConfig.SHOP_ID,
                            "SHOP_ID" ,
//                            BuildConfig.GATEWAY_ID,
                            "GATEWAY_ID",
                            settings.showYandexCheckoutLogo()
                    )
            );
        }
    }

    @Override
    protected void onDestroy() {
        // Detach MSDK from supportFragmentManager
        Checkout.detach();
        // Detach result callback
        Checkout.setResultCallback(null);

        if (validateAmount()) {
            saveAmount();
        }

        super.onDestroy();
    }


    private void initUi() {
        setContentView(R.layout.activity_payment_main);

        setTitle(R.string.main_toolbar_title);
        Intent i = getIntent();

        Double price = i.getDoubleExtra(PaymentActivity.KEY_AMOUNT,0);
        price = 300.0;
        placeName = i.getStringExtra(PaymentActivity.KEY_CO_WORKING_NAME);
        amount = new BigDecimal(price);




//        final ScrollView scrollContainer = findViewById(R.id.scroll_container);
//        if (scrollContainer != null) {
//            scrollContainer.post(() -> scrollContainer.fullScroll(ScrollView.FOCUS_DOWN));
//        }

        buyButton = findViewById(R.id.buy);
        buyButton.setOnClickListener(v -> onBuyClick());

        final TextView priceEdit = findViewById(R.id.price_container);
        priceEdit.setText(String.format(Locale.FRENCH,"%f", price));

        final TextView placeNameText = findViewById(R.id.good_name);
        placeNameText.setText(placeName);

        priceEdit.setInputType(InputType.TYPE_CLASS_TEXT);
        priceEdit.setRawInputType(InputType.TYPE_CLASS_NUMBER | InputType.TYPE_NUMBER_FLAG_DECIMAL);

//        priceEdit.addTextChangedListener(new AmountFormatter(priceEdit, this::onAmountChange, RUB, MAX_AMOUNT));
        priceEdit.setOnEditorActionListener((v, actionId, event) -> {
            final boolean isActionDone = actionId == EditorInfo.IME_ACTION_DONE;
            if (isActionDone) {
                onBuyClick();
            }
            return isActionDone;
        });

        final SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(this);
        priceEdit.setText(sp.getString(KEY_AMOUNT, BigDecimal.ZERO.toString()));


    }

    private void onAmountChange(@NonNull BigDecimal newAmount) {
        amount = newAmount;

        if (buyButton != null) {
            buyButton.setEnabled(validateAmount());
        }
    }

    private void saveAmount() {
        PreferenceManager.getDefaultSharedPreferences(this).edit()
                .putString(KEY_AMOUNT, amount.toPlainString())
                .apply();
    }

    private boolean validateAmount() {
        return amount.compareTo(BigDecimal.ZERO) > 0;
    }

    @NonNull
    private static Set<PaymentMethodType> getPaymentMethodTypes(Settings settings) {
        final Set<PaymentMethodType> paymentMethodTypes = new HashSet<>();
        paymentMethodTypes.add(PaymentMethodType.BANK_CARD);
        paymentMethodTypes.add(PaymentMethodType.SBERBANK);
        paymentMethodTypes.add(PaymentMethodType.GOOGLE_PAY);


//        if (settings.isYandexMoneyAllowed()) {
//            paymentMethodTypes.add(PaymentMethodType.YANDEX_MONEY);
//        }
//
//        if (settings.isNewCardAllowed()) {
//            paymentMethodTypes.add(PaymentMethodType.BANK_CARD);
//        }
//
//        if (settings.isSberbankOnlineAllowed()) {
//            paymentMethodTypes.add(PaymentMethodType.SBERBANK);
//        }
//
//        if (settings.isGooglePayAllowed()) {
//            paymentMethodTypes.add(PaymentMethodType.GOOGLE_PAY);
//        }

        return paymentMethodTypes;
    }
}
