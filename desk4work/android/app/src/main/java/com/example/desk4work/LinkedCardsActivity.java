package com.example.desk4work;

import android.preference.PreferenceManager;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.text.Editable;
import android.text.Selection;
import android.text.TextWatcher;
import android.widget.TextView;

public class LinkedCardsActivity extends AppCompatActivity {

    private static final int MAX_CARDS = 5;
    private static final String KEY_LAST_COUNT = "lastCount";

    static final String TEXT_ZERO = "0";
    static final String TEXT_MAX = "5";

    private int lastCount = 0;

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_linked_cards);

//        this.<TextView>findViewById(R.id.cards_count).addTextChangedListener(new CountTextWatcher());

        if (savedInstanceState == null) {
            lastCount = new Settings(this).getLinkedCardsCount();
        } else {
            lastCount = savedInstanceState.getInt(KEY_LAST_COUNT);
        }

//        this.<TextView>findViewById(R.id.cards_count).setText(String.valueOf(lastCount));
        findViewById(R.id.save).setOnClickListener(v -> onSave());
    }

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);

        outState.putInt(KEY_LAST_COUNT, lastCount);
    }

    void onSave() {
        PreferenceManager.getDefaultSharedPreferences(this).edit()
                .putInt(Settings.KEY_LINKED_CARDS_COUNT, lastCount)
                .apply();

        finish();
    }

    private class CountTextWatcher implements TextWatcher {
        @Override
        public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            // does nothing
        }

        @Override
        public void onTextChanged(CharSequence s, int start, int before, int count) {
            // does nothing
        }

        @Override
        public void afterTextChanged(Editable s) {
            try {
                final int parsed = Integer.parseInt(s.toString());
                if (parsed < 0 || parsed > MAX_CARDS || s.length() > 1) {
                    s.replace(0, s.length(), String.valueOf(lastCount));
                } else {
                    lastCount = parsed;
                }
            } catch (NumberFormatException e) {
                s.replace(0, s.length(), String.valueOf(lastCount));
            }

            Selection.selectAll(s);
        }
    }
}
