package com.fot.CanteenManagementSystem.Repository;

import com.fot.CanteenManagementSystem.Model.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRepository extends JpaRepository<User,String> {

}
