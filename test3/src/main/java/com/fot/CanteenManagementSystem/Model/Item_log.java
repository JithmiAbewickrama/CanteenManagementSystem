package com.fot.CanteenManagementSystem.Model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import java.time.LocalDateTime;

@Entity
public class Item_log {
    @Id
    @GeneratedValue
    private int id;
    private String data;
    private String user;
    private String operation;
    private LocalDateTime changedat;

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

    public LocalDateTime getChangedat() {
        return changedat;
    }

    public void setChangedat(LocalDateTime changedat) {
        this.changedat = changedat;
    }
}
