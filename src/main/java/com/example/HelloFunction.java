package com.example;

import com.example.model.Greeting;
import com.example.model.User;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.util.function.Function;

@Component
public class HelloFunction implements Function<Mono<User>, Mono<Greeting>> {

    public Mono<Greeting> apply(Mono<User> mono) {
        return mono.map(user -> new Greeting("Hello from Spring Boot 2.5.0, " + user.getName() + "!\n"));
    }
}
