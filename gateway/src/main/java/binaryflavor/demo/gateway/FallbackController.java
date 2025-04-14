package binaryflavor.demo.gateway;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;
import reactor.core.publisher.Mono;

@Slf4j
@RestController
class FallbackController {

    @GetMapping("/empty-fallback")
    Mono<Void> getBooksFallback() {
        return Mono.empty();
    }

}