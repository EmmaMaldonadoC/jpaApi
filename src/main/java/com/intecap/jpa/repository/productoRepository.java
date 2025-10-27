package com.intecap.jpa.repository;

import com.intecap.jpa.models.productoModel;
import org.springframework.data.jpa.repository.JpaRepository;

public interface productoRepository extends JpaRepository<productoModel,Long> {
}
