package com.aman.WebSocketDemo.product;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ProductService {
	private final ProductRepository repo;
	private final ProductWebSocketController wsController;
	public ProductService(ProductRepository repo, ProductWebSocketController wsController) {
		this.repo=repo;
		this.wsController=wsController;
	}
	@Transactional
   public Long saveProduct(ProductDto dto) {
	   Product product=new Product();
	   product.setName(dto.name());
	   product.setCategory(dto.category());
	   Product saved=repo.save(product);
	   wsController.broadcastProduct(saved); // notify all websocket subscribers
	   return saved.getId();
   }
   public List<Product> findAll(){
	   return repo.findAll();
   }
}
