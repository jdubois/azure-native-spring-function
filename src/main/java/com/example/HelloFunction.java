package com.example;

import com.example.model.Greeting;
import org.springframework.stereotype.Component;
import reactor.core.publisher.Mono;

import java.util.function.Function;

@Component
public class HelloFunction implements Function<Mono<String>, Mono<Greeting>> {

    public Mono<Greeting> apply(Mono<String> name) {
        return name.map(user -> new Greeting("Hello, " + name + "!\n"));
    }
}
