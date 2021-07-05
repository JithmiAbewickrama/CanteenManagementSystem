package cms.example.cms.Service;

import cms.example.cms.Model.Transaction;
import cms.example.cms.Repository.TransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;
import java.util.List;

public class TransactionService {

    @Autowired
    private TransactionRepository transactionRepo;

    @Autowired
    @PersistenceContext
    private EntityManager em;


    public List<Transaction> getAllTransaction() {
        return transactionRepo.getAllTransaction();
    }
}
