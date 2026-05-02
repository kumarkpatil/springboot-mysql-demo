package com.example.demo;

import com.example.demo.entity.User;
import com.example.demo.repository.UserRepository;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class DemoApplication {

    public static void main(String[] args) {
        SpringApplication.run(DemoApplication.class, args);
    }

    @Bean
    public org.springframework.boot.CommandLineRunner loadData(UserRepository repo) {
        return args -> {
            repo.save(new User("Kumar", "kumar@test.com"));
            repo.save(new User("Dhruv", "dhruv@test.com"));
            repo.save(new User("Priya", "priya@test.com"));
        };
    }
}
