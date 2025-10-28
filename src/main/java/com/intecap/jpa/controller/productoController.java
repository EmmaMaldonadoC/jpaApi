package com.intecap.jpa.controller;

import com.intecap.jpa.models.productoModel;
import com.intecap.jpa.repository.productoRepository;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/productos")
public class productoController {

    private final productoRepository repo;

    public productoController(productoRepository repo) {
        this.repo = repo;
    }

    @GetMapping
    public List<productoModel> listar(){
        return  repo.findAll();
    }

    @PostMapping
    public ResponseEntity<productoModel> crear (@RequestBody productoModel p){
        if(p.getId() != null){
            return ResponseEntity.badRequest().build();
        }
        return ResponseEntity.ok(repo.save(p));
    }

}
