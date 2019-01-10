package com.example.desk4work.utils;

import android.support.annotation.NonNull;

public class Strings2 {
    private Strings2() {
    }

    static int getCursorPositionAfterFormat(
            @NonNull final String formattedString,
            @NonNull final String originalString,
            final int originalPosition
    ) {
        int digitsCounter = 0;
        for (int i = originalString.length() - 1; i >= originalPosition; i--) {
            if (Character.isDigit(originalString.charAt(i))) {
                digitsCounter++;
            }
        }

        int positionToSet = formattedString.length();
        int digitsCounterAfterFormat = 0;
        while (digitsCounter > digitsCounterAfterFormat && positionToSet > 0) {
            if (Character.isDigit(formattedString.charAt(--positionToSet))) {
                digitsCounterAfterFormat++;
            }
        }
        return positionToSet;
    }

    static int getFirstDigitIndex(@NonNull CharSequence sequence) {
        int sequenceLength = sequence.length();
        for (int i = 0; i < sequenceLength; i++) {
            if (Character.isDigit(sequence.charAt(i))) {
                return i;
            }
        }
        return -1;
    }
}
