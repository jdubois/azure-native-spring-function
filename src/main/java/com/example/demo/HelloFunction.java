package com.example.demo;

import java.util.function.Function;

import com.example.demo.model.Greeting;
import com.example.demo.model.User;
import org.springframework.stereotype.Component;

@Component
public class HelloFunction implements Function<User, Greeting> {

    @Override
    public Greeting apply(User user) {
        return new Greeting("Hello from GraalVM, " + user.getName() + "!\n");
    }
}
