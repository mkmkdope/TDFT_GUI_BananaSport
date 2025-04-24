package com.bananasports.servlet;

import jakarta.persistence.Entity;
import jakarta.persistence.Id;
import jakarta.persistence.Table;
import jakarta.persistence.Column;

@Entity
@Table(name = "Staff")
public class Staff {
    @Id
    @Column(name = "staff_ID")
    private int staffId;

    @Column(name = "staff_name")
    private String staffName;

    @Column(name = "staff_email")
    private String staffEmail;

    @Column(name = "staff_password")
    private String staffPassword;

    @Column(name = "staff_position")
    private String staffPosition;

    @Column(name = "staff_contact_number")
    private String staffContactNumber;

    // Getters and setters
    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }

    public String getStaffName() {
        return staffName;
    }

    public void setStaffName(String staffName) {
        this.staffName = staffName;
    }

    public String getStaffEmail() {
        return staffEmail;
    }

    public void setStaffEmail(String staffEmail) {
        this.staffEmail = staffEmail;
    }

    public String getStaffPassword() {
        return staffPassword;
    }

    public void setStaffPassword(String staffPassword) {
        this.staffPassword = staffPassword;
    }

    public String getStaffPosition() {
        return staffPosition;
    }

    public void setStaffPosition(String staffPosition) {
        this.staffPosition = staffPosition;
    }

    public String getStaffContactNumber() {
        return staffContactNumber;
    }

    public void setStaffContactNumber(String staffContactNumber) {
        this.staffContactNumber = staffContactNumber;
    }
}