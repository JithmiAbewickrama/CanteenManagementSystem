package cms.example.cms.Repository;

import cms.example.cms.Model.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Repository
public interface UserRepository extends JpaRepository<User,String> {

    @Transactional
    @Procedure(procedureName = "insert_user")
    void addUsers(String user_id, String name, String email, String password, Integer mobile, String role);

    @Query(value = "SELECT u FROM User u WHERE u.user_id=?1 AND u.password=?2")
    User availableUser(String user_id, String password);

    //View all users by admin
    @Query(value = "SELECT * FROM user",nativeQuery = true)
    List<User> getAllUsers();

    //delete user
    @javax.transaction.Transactional
    @Procedure(procedureName = "delete_user")
    void deleteUser(String user_id);

}