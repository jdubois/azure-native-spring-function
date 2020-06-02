package com.example.demo;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

import java.util.Collections;

@SpringBootApplication(proxyBeanMethods = false)
public class DemoApplication {

	public static void main(String[] args) {
		SpringApplication app = new SpringApplication(DemoApplication.class);
		String functionServerPort = System.getenv("FUNCTIONS_HTTPWORKER_PORT");
		if (functionServerPort != null) {
			app.setDefaultProperties(Collections
					.singletonMap("server.port", functionServerPort));
		}
		app.run(args);
	}
}
