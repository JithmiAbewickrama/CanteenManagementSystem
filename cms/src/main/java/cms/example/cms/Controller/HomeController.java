package cms.example.cms.Controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class HomeController {

    // Login Form

    @RequestMapping("/")
    public String getindex(){
        return "login";
    }

    // Register Form

    @RequestMapping("/register")
    public String getregister(){
        return "register";
    }

    // Admin Dashboard

    @RequestMapping("/adminDash")
    public String getadminDash(){
        return "admin/adminDash";
    }

    @RequestMapping("/createUser")
    public String getuaddUser(){
        return "admin/user_create";
    }

    @RequestMapping("/updateUser")
    public String getupdateUser(){
        return "view_user";
    }

    @RequestMapping("/deleteUser")
    public String getdeleteUser(){
        return "manage_user";
    }

//    @RequestMapping("/manageItems")
//    public String getmanageItem(){
//        return "admin/manage_item";
//    }

    @RequestMapping("/addItems")
    public String getcreateItem(){
        return "admin/add_item";
    }

    @RequestMapping("/updateItem")
    public String getupdateItem(){
        return "admin/update_item";
    }

    @RequestMapping("/deleteItem")
    public String getdeleteItem(){
        return "admin/delete_item";
    }

    @RequestMapping("/viewOrder")
    public String getOreders(){
        return "admin/view_order";
    }

//    @RequestMapping("/viewInvoice")
//    public String getInvoices(){
//        return "";
//    }



    // Customer Dashboard

    @RequestMapping("/customerDash")
    public String getcustomerDash(){
        return "customer/customerDash";
    }

//    @RequestMapping("/viewUserItem")
//    public String getItem(){
//        return "customer/view_item";
//    }

    @RequestMapping("/addOrders")
    public String getaddOrder(){

        return "customer/add_order";
    }

    @RequestMapping("/updateOrder")
    public String getupdateOrder(){

        return "customer/update_order";
    }

    @RequestMapping("/deleteOrder")
    public String getdeleteOrder(){
        return "customer/delete_order";
    }

    @RequestMapping("/viewUserOrder")
    public String getOreder()
    {
        return "customer/view_order";
    }

    @RequestMapping("/viewUserInvoice")
    public String getInvoice(){
        return "customer/view_invoice";
    }

}
