package com.example;

import com.example.model.Greeting;
import com.example.model.User;
import org.junit.jupiter.api.Test;
import reactor.core.publisher.Mono;

import static org.assertj.core.api.Assertions.assertThat;

public class HelloFunctionTest {

    @Test
    public void test() {
        Mono<Greeting> result = new HelloFunction().apply(Mono.just(new User("foo")));
        assertThat(result.block().getMessage()).isEqualTo("Hello 1, foo!\n");
    }
}
