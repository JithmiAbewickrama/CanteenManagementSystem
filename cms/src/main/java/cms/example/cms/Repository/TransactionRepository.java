package cms.example.cms.Repository;

import cms.example.cms.Model.Transaction;
import cms.example.cms.Model.User;
import org.springframework.data.jpa.repository.Query;

import java.util.List;

public interface TransactionRepository {

    //View all transaction
    @Query(value = "SELECT * FROM transaction ",nativeQuery = true)
    List<Transaction> getAllTransaction();
}
