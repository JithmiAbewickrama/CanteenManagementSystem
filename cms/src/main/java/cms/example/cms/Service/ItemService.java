package cms.example.cms.Service;

import cms.example.cms.Model.Item;
import cms.example.cms.Repository.ItemRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.Date;
import java.util.List;

@Service
public class ItemService {

    @Autowired
    private ItemRepository itemRepo;

    @Autowired
    @PersistenceContext
    private EntityManager em;

    public boolean CreateItem(String item_id, String item_type, String name, Float unit_price, Date mfd_date, Date exp_date) {
        itemRepo.CreateItem(item_id, name, item_type, unit_price, mfd_date, exp_date);
        return true;
    }

    //view all items
    public List<Item> getAllItems() {
        return itemRepo.getAllItems();
    }

    public void UpdateItem(String item_id, String item_type, String name, Float unit_price, Date mfd_date, Date exp_date) {
        itemRepo.UpdateItem(item_id, item_type, name, unit_price, mfd_date, exp_date);
    }

    public Item getItem(String item_id) {
        return itemRepo.findById(item_id).get();
    }

    //delete user
    public boolean DeleteItem(String item_id){
        itemRepo.itemDelete(item_id);
        return true;
    }

}
