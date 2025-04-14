package binaryflavor.demo.gateway;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.reactive.config.EnableWebFlux;
import reactor.core.publisher.Hooks;


@EnableWebFlux
@SpringBootApplication
public class GatewayApplication
{

  public static void main(String[] args)
  {
    SpringApplication.run(GatewayApplication.class, args);
    Hooks.enableAutomaticContextPropagation();
  }

}
