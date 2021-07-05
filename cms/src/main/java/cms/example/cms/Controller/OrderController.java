package cms.example.cms.Controller;

import cms.example.cms.Model.Order_details;
import cms.example.cms.Service.OrderService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class OrderController {

    @Autowired
    private OrderService orderSer;

    @PostMapping("/addOrder")
    public String saveOrder(@RequestParam("o_id") String id,@RequestParam("iname") String name,@RequestParam("qty") Integer quantity,@RequestParam("i_id") String itemid,@RequestParam("u_id") String userid){
        boolean status = orderSer.addOrder(id,name,quantity,itemid,userid);
        if (status){
            return "redirect:/addOrders";
        }
        else {
            return "redirect:/add_order";
        }
    }
    // view list of orders
    @GetMapping("/viewOrders")
    public String listOrders(Model model){
        List<Order_details> listOrders = orderSer.getOrdersList();
        model.addAttribute("listOrders",listOrders);
        return "/admin/view_order";
    }


}
