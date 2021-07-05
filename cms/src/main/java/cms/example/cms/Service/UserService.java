package cms.example.cms.Service;

import cms.example.cms.Model.Transaction;
import cms.example.cms.Repository.UserRepository;
import cms.example.cms.Model.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

@Service
public class UserService {

    @Autowired
    private UserRepository userRepo;

    @Autowired
    @PersistenceContext
    private EntityManager em;


    public User loginusers(String uname, String pwd) {
        return userRepo.availableUser(uname, pwd);
    }

    public boolean registerUsers(String user_id, String name, String email, String password, Integer mobile, String role) {
        userRepo.addUsers(user_id, name, email, password, mobile, role);
        return true;
    }

    //View all users by admin
    public List <User> getAllUsers(){
        return userRepo.getAllUsers();
    }

    // delete user
    public boolean getUser(String user_id) {
        userRepo.deleteUser(user_id);
        return true;
    }
}
