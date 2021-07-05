package cms.example.cms.Service;

import cms.example.cms.Model.Order_details;
import cms.example.cms.Repository.Order_details_Repository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.sql.Timestamp;
import java.util.List;

@Service
public class OrderService {
    @Autowired
    private Order_details_Repository orderRepo;

    @Autowired
    @PersistenceContext
    private EntityManager em;

    public boolean addOrder(String order_id, String item, Integer quantity, String item_id, String user_id){
        orderRepo.addOrders(order_id,item,quantity,item_id,user_id);
        return true;
    }
    public List<Order_details> getOrdersList(){

        return orderRepo.getAllOrders();
    }


}
