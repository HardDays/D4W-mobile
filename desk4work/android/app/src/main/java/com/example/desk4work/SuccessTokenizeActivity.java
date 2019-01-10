package com.example.desk4work;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;

public class SuccessTokenizeActivity extends AppCompatActivity {

    public static final String TOKEN_EXTRA = "paymentToken";
    public static final String TYPE_EXTRA = "type";

    @NonNull
    public static Intent createIntent(@NonNull Context context, @NonNull String paymentToken, @NonNull String type) {
        return new Intent(context, SuccessTokenizeActivity.class)
                .putExtra(SuccessTokenizeActivity.TOKEN_EXTRA, paymentToken)
                .putExtra(SuccessTokenizeActivity.TYPE_EXTRA, type);
    }

    @Override
    public void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_success_tokenize);

        findViewById(R.id.close).setOnClickListener(v -> finish());

        findViewById(R.id.showDocumentation).setOnClickListener(v -> {
            final Intent showDoc = new Intent(Intent.ACTION_VIEW,
                    Uri.parse(getString(R.string.checkout_documentation_link)));
            startActivity(showDoc);
        });

        findViewById(R.id.showToken).setOnClickListener(v -> {
            final Intent intent = getIntent();
            final String token = intent.getStringExtra(TOKEN_EXTRA);
            final String type = intent.getStringExtra(TYPE_EXTRA);
            new AlertDialog.Builder(this, R.style.DialogToken)
                    .setMessage("Token: " + token + "\nType: " + type)
                    .setPositiveButton(R.string.token_copy, (dialog, which) -> {
                        ClipboardManager clipboard = (ClipboardManager) getSystemService(Context.CLIPBOARD_SERVICE);
                        if (clipboard != null) {
                            ClipData clip = ClipData.newPlainText("token", token);
                            clipboard.setPrimaryClip(clip);
                        }
                    })
                    .setNegativeButton(R.string.token_cancel, (dialog, which) -> {
                    })
                    .show();
        });
    }
}
