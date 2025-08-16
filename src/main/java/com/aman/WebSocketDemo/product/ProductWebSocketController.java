package com.aman.WebSocketDemo.product;

import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.stereotype.Controller;

@Controller
public class ProductWebSocketController {

    private final SimpMessagingTemplate messagingTemplate;

    public ProductWebSocketController(SimpMessagingTemplate messagingTemplate) {
        this.messagingTemplate = messagingTemplate;
    }

    public void broadcastProduct(Product product) {
        messagingTemplate.convertAndSend("/topic/products", product);
    }
}
