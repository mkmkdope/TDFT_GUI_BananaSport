package model;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

@Entity
@Table(name = "Managers")
public class Manager {
    @Id
    @Column(name = "managers_manager_id")
    private int managerId;

    @Column(name = "managers_name")
    private String managerName;

    @Column(name = "managers_email")
    private String managerEmail;

    @Column(name = "managers_password")
    private String managerPassword;

    @Column(name = "managers_position")
    private String managerPosition;

    @Column(name = "managers_contact_number")
    private String managerContactNumber;

    // Getters and setters
    public int getManagerId() {
        return managerId;
    }

    public void setManagerId(int managerId) {
        this.managerId = managerId;
    }

    public String getManagerName() {
        return managerName;
    }

    public void setManagerName(String managerName) {
        this.managerName = managerName;
    }

    public String getManagerEmail() {
        return managerEmail;
    }

    public void setManagerEmail(String managerEmail) {
        this.managerEmail = managerEmail;
    }

    public String getManagerPassword() {
        return managerPassword;
    }

    public void setManagerPassword(String managerPassword) {
        this.managerPassword = managerPassword;
    }

    public String getManagerPosition() {
        return managerPosition;
    }

    public void setManagerPosition(String managerPosition) {
        this.managerPosition = managerPosition;
    }

    public String getManagerContactNumber() {
        return managerContactNumber;
    }

    public void setManagerContactNumber(String managerContactNumber) {
        this.managerContactNumber = managerContactNumber;
    }
} 