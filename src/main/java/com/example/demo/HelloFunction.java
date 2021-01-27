package com.example.demo;

import java.util.function.Function;

import org.springframework.stereotype.Component;

@Component
public class HelloFunction implements Function<String, String> {

    @Override
    public String apply(String user) {
        return "Hello from GraalVM, " + user + "!\n";
    }
}
