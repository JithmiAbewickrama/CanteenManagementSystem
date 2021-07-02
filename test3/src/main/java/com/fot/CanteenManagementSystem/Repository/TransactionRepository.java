package com.fot.CanteenManagementSystem.Repository;

import com.fot.CanteenManagementSystem.Model.Transaction;
import org.springframework.data.jpa.repository.JpaRepository;

public interface TransactionRepository extends JpaRepository<Transaction,String> {
}
