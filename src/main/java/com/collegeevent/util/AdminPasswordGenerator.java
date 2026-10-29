package com.collegeevent.util;

import org.mindrot.jbcrypt.BCrypt;
import java.io.Console;

public class AdminPasswordGenerator {

    public static void main(String[] args) {
        Console console = System.console();

        if (console == null) {
            System.out.println(
                "Run this program in a terminal that supports password input."
            );
            return;
        }

        char[] passwordChars = console.readPassword("Enter admin password: ");

        if (passwordChars == null || passwordChars.length < 12) {
            System.out.println("Use a password with at least 12 characters.");
            return;
        }

        String password = new String(passwordChars);
        String hash = BCrypt.hashpw(password, BCrypt.gensalt(12));

        System.out.println("BCrypt hash:");
        System.out.println(hash);

        java.util.Arrays.fill(passwordChars, '\0');
        password = null;
    }
}

