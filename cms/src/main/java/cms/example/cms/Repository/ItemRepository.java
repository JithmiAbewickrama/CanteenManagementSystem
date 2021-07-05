package cms.example.cms.Repository;

import cms.example.cms.Model.Item;
import cms.example.cms.Model.User;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;

import javax.transaction.Transactional;
import java.util.Date;
import java.util.List;

@Repository
public interface ItemRepository extends CrudRepository<Item, String> {

    @Transactional
    @Procedure(procedureName = "add_item")
    void CreateItem(String item_id, String item_type, String name, Float unit_price, Date mfd_date, Date exp_date);

    @Query(value = "SELECT * FROM item", nativeQuery = true)
    List<Item> getAllItems();

    @Transactional
    @Procedure(procedureName = "update_item")
    void UpdateItem(String item_id, String item_type, String name, Float unit_price, Date mfd_date, Date exp_date);

    //delete user
    @Transactional
    @Procedure(procedureName = "delete_item")
    void itemDelete(String item_id);

}

