package com.fot.CanteenManagementSystem.Repository;

import com.fot.CanteenManagementSystem.Model.Item;
import org.springframework.data.jpa.repository.JpaRepository;

public interface ItemRepository extends JpaRepository<Item,String> {
}
