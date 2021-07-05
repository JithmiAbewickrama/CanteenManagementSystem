package cms.example.cms.Repository;


import cms.example.cms.Model.Order_details;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Timestamp;
import java.util.List;

@Repository
public interface Order_details_Repository extends JpaRepository<Order_details,String> {

    @Transactional
    @Procedure(procedureName = "insert_order")
    void addOrders(String order_id, String item, Integer quantity, String item_id, String user_id);

    @Query(value = "SELECT o FROM Order_details o")
    List<Order_details> getAllOrders();

}
