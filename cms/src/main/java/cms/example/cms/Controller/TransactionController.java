package cms.example.cms.Controller;

import cms.example.cms.Model.Transaction;
import cms.example.cms.Service.TransactionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import java.util.List;

public class TransactionController {

    @Autowired
    private TransactionService transactionSer;

//    @RequestMapping("/viewTransactionPage")
//    public String viewPage(Model model){
//        return "admin/test";
//    }

    //view transaction
    @RequestMapping("/viewTransaction")
    public String getAllTransaction(Model model){
        List<Transaction> transaction = transactionSer.getAllTransaction();
        model.addAttribute("ViewTransactions",transaction);
        return "redirect:/admin/view_transaction";

    }
}
