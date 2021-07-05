package cms.example.cms.Controller;

import cms.example.cms.Model.Item;
import cms.example.cms.Service.UserService;
import cms.example.cms.Model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import javax.transaction.Transactional;
import java.util.List;
import java.util.Objects;

@Controller
public class UserController {

    @Autowired
    private UserService userSer;

    @PostMapping("/logUser")
    public String login(@RequestParam("username") String uname, @RequestParam("password") String pwd){
        User user = userSer.loginusers(uname, pwd);
        if (Objects.nonNull(user)) {
            String role = user.getRole();
            if (role.equals("Admin")) {
                return "redirect:/adminDash";
            }
            else {
                return "redirect:/customerDash";
            }
        }
        else {
            return "redirect:/";
        }
    }

    @PostMapping("/addAccount")
    public String saveUser(@RequestParam("u_id") String id, @RequestParam("name") String uname, @RequestParam("email") String uemail, @RequestParam("password") String pwd, @RequestParam("phone") Integer number, @RequestParam("role") String role){
        boolean state = userSer.registerUsers(id,uname,uemail,pwd,number,role);
        if (state){
            return "redirect:/";
        }
        else {
            return "redirect:/register";
        }
    }

    //view user by admin
    @RequestMapping("/viewUser")
    public String getAllUsers(Model model){
        List <User> users =userSer.getAllUsers();
        model.addAttribute("ViewUsers",users);
        return "admin/view_user";

    }


    //Create users by admin
    @PostMapping("/userCreate")
    public String addUser(@RequestParam("u_id") String id, @RequestParam("name") String uname, @RequestParam("email") String uemail, @RequestParam("password") String pwd, @RequestParam("phone") Integer number, @RequestParam("role") String role){
        boolean result =userSer.registerUsers(id,uname,uemail,pwd,number,role);
        if (result){
            return "redirect:/createUser";
        }
        else {
            return "redirect:/adminDash";
        }
    }

    // manage user
    @RequestMapping("/manageUser")
    public String manageUser(Model model){
        List<User> users = userSer.getAllUsers();
        model.addAttribute("ViewUser", users);
        return "/admin/manage_user";
    }

    // delete user
    @RequestMapping("/delete_user/{u_id}")
    public String deleteUser(Model model, @PathVariable("u_id") String user_id){
        boolean status = userSer.getUser(user_id);
        if (status)
            return "redirect:/manageUser";
        else
            return "redirect:/manageUser";
    }


}
