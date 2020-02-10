package com.bytefiddler.demo.helloworld;

import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.RequestMapping;

@RestController
public class HelloController {

    public static final String REQUEST_MAPPING = "/";
    public static final String HELLO_WORLD = "Hello, World";

    @RequestMapping(REQUEST_MAPPING)
    public String index() {
        return HELLO_WORLD;
    }

}