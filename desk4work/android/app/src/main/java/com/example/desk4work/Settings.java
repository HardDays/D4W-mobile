package com.example.desk4work;

import android.content.Context;
import android.content.SharedPreferences;
import android.preference.PreferenceManager;
import android.support.annotation.NonNull;

public class Settings {
    public static final String KEY_LINKED_CARDS_COUNT = "linked_cards_count";
    static final String KEY_YANDEX_MONEY_ALLOWED = "yandex_money_allowed";
    static final String KEY_SBERBANK_ONLINE_ALLOWED = "sberbank_online_allowed";
    static final String KEY_GOOGLE_PAY_ALLOWED = "google_pay_allowed";
    static final String KEY_NEW_CARD_ALLOWED = "new_card_allowed";
    static final String KEY_SHOW_YANDEX_CHECKOUT_LOGO = "show_yandex_checkout_logo";
    static final String KEY_TEST_MODE_ENABLED = "test_mode_enabled";
    static final String KEY_PAYMENT_AUTH_PASSED = "payment_auth_passed";
    static final String KEY_SHOULD_COMPLETE_PAYMENT_WITH_ERROR = "should_complete_with_error";
    static final String KEY_GOOGLE_PAY_AVAILABLE = "google_pay_available";

    private SharedPreferences sp;

    public Settings(@NonNull Context context) {
        sp = PreferenceManager.getDefaultSharedPreferences(context);
    }

    public boolean isYandexMoneyAllowed() {
        return sp.getBoolean(KEY_YANDEX_MONEY_ALLOWED, true);
    }

    public boolean isSberbankOnlineAllowed() {
        return sp.getBoolean(KEY_SBERBANK_ONLINE_ALLOWED, true);
    }

    public boolean isGooglePayAllowed() {
        return sp.getBoolean(KEY_GOOGLE_PAY_ALLOWED, true);
    }

    public boolean isNewCardAllowed() {
        return sp.getBoolean(KEY_NEW_CARD_ALLOWED, true);
    }

    public boolean showYandexCheckoutLogo() {
        return sp.getBoolean(KEY_SHOW_YANDEX_CHECKOUT_LOGO, true);
    }

    public boolean isTestModeEnabled() {
        return sp.getBoolean(KEY_TEST_MODE_ENABLED, false);
    }

    public boolean isPaymentAuthPassed() {
        return sp.getBoolean(KEY_PAYMENT_AUTH_PASSED, false);
    }

    public int getLinkedCardsCount() {
        return sp.getInt(KEY_LINKED_CARDS_COUNT, 1);
    }

    public boolean shouldCompletePaymentWithError() {
        return sp.getBoolean(KEY_SHOULD_COMPLETE_PAYMENT_WITH_ERROR, false);
    }

    public boolean isGooglePayAvailable() {
        return sp.getBoolean(KEY_GOOGLE_PAY_AVAILABLE, true);
    }
}
