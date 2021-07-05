package cms.example.cms.Controller;

import cms.example.cms.Model.Item;
import cms.example.cms.Repository.ItemRepository;
import cms.example.cms.Service.ItemService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import java.sql.Date;
import java.util.List;


@Controller
public class ItemController {

    @Autowired
    private ItemService itemSer;

    @Autowired
    private ItemRepository itemRepo;

    @PostMapping("/addItem")
    public String saveItem(@RequestParam("i_id") String item_id, @RequestParam("i_type") String item_type, @RequestParam("i_name") String  name, @RequestParam("u_price") Float unit_price, @RequestParam("m_date") Date mfd_date, @RequestParam("e_date") Date exp_date){
        boolean state = itemSer.CreateItem(item_id, item_type, name, unit_price, mfd_date, exp_date);
        if (state){
            return "redirect:/addItems";
        }
        else {
            return "redirect:/adminDash";
        }
    }

    @RequestMapping("/viewItem")
    public String getItems(Model model){
        List<Item> items = itemSer.getAllItems();
        model.addAttribute("ViewItems", items);
        return "admin/view_item";
    }

    @RequestMapping("/manageItems")
    public String manageItems(Model model){
        List<Item> items = itemSer.getAllItems();
        model.addAttribute("ViewItems", items);
        return "/admin/manage_item";
    }

    @RequestMapping("/admin/update_item/{i_id}")
    public String viewItemUpdate(Model model, @PathVariable("i_id") String item_id){
        Item item = itemSer.getItem(item_id);
        model.addAttribute("UpdateItem", item);
        return "/admin/update_item";
    }

    @PostMapping("/itemUpdate")
    public String UpdateItems(@RequestParam("i_id") String item_id, @RequestParam("i_type") String item_type, @RequestParam("i_name") String  name, @RequestParam("u_price") Float unit_price, @RequestParam("m_date") Date mfd_date, @RequestParam("e_date") Date exp_date){
        itemSer.UpdateItem(item_id, item_type, name, unit_price, mfd_date, exp_date);
        return "redirect:/admin/viewItem";
    }


    //item view by customer
    @RequestMapping("/viewUserItem")
    public String getItemCus(Model model){
        List<Item> items = itemSer.getAllItems();
        model.addAttribute("ViewItems", items);
        return "/customer/view_item";
    }


    //admin delete item
    @RequestMapping("/delete_item/{id}")
    public String deleteItem(@PathVariable("id") String item_id){
        boolean status = itemSer.DeleteItem(item_id);
        if (status)
            return "redirect:/manageItems";
        else
            return "redirect:/manageItems";
    }


}
