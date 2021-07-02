package com.fot.CanteenManagementSystem.Model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.text.DecimalFormat;
import java.util.Date;

@Entity
public class Transaction {
    @Id
    @GeneratedValue
    private String t_id;
    private String order_id;
    private DecimalFormat total_amount;
    private Date date;

    public String getT_id() {
        return t_id;
    }

    public void setT_id(String t_id) {
        this.t_id = t_id;
    }

    public String getOrder_id() {
        return order_id;
    }

    public void setOrder_id(String order_id) {
        this.order_id = order_id;
    }

    public DecimalFormat getTotal_amount() {
        return total_amount;
    }

    public void setTotal_amount(DecimalFormat total_amount) {
        this.total_amount = total_amount;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }
}
