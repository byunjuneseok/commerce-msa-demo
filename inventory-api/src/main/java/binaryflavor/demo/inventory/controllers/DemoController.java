package binaryflavor.demo.inventory.controllers;

import java.util.Map;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RequestMapping("")
@RestController
public class DemoController
{

    @GetMapping("/demo")
    public Map<String, String> demo() {
        return Map.of("message", "Hello from Inventory API");
    }

}
