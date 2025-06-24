package com.example.demo;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class DemoApplicationTests {
    @Test
    void testHello() {
        HelloController controller = new HelloController();
        String response = controller.hello();
        assertEquals("hello ci/cd", response);
    }
}
