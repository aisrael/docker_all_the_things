package com.example;

/**
 * Hello world!
 *
 */
public class App
{
    public static void main(String[] args)
    {
        final String who;
        if (args.length > 0) {
            who = args[0];
        } else {
            who = "world";
        }
        System.out.println("Hello, " + who + "!");
    }
}
