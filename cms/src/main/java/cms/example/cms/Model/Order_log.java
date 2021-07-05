package cms.example.cms.Model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;

@Entity
public class Order_log {

    @Id
    @GeneratedValue
    private int id;
    private String data;
    private String user;
    private String operation;
    private String changedat;

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getData() {
        return data;
    }

    public void setData(String data) {
        this.data = data;
    }

    public String getUser() {
        return user;
    }

    public void setUser(String user) {
        this.user = user;
    }

    public String getOperation() {
        return operation;
    }

    public void setOperation(String operation) {
        this.operation = operation;
    }

    public String getChangedat() {
        return changedat;
    }

    public void setChangedat(String changedat) {
        this.changedat = changedat;
    }
}
