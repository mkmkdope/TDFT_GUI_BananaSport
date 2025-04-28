package model;

import java.sql.Timestamp;

public class Products {

    private String productId;
    private String productName;
    private String productCategory;
    private Integer productQty;
    private Double productPrice;
    private Integer productPopularity;
    private Timestamp productCreatedTime;
    private String imageLink;
    private String description;


    public Products() {
    }

 
    public Products(String productId, String productName, String productCategory, Integer productQty, Double productPrice,
            Integer productPopularity, Timestamp productCreatedTime,String imageLink,String description) {
        this.productId = productId;
        this.productName = productName;
        this.productCategory = productCategory;
        this.productQty = productQty;
        this.productPrice = productPrice;
        this.productPopularity = productPopularity;
        this.productCreatedTime = productCreatedTime;
        this.imageLink = imageLink;
        this.description = description;
    }

  
    public String getProductId() {
        return productId;
    }

    public void setProductId(String productId) {
        this.productId = productId;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String ProductName) {
        this.productName = productName;
    }

    public String getProductCategory() {
        return productCategory;
    }

    public void setProductCategory(String productCategory) {
        this.productCategory = productCategory;
    }

    public Double getProductPrice() {
        return productPrice;
    }

    public void setProductPrice(Double productPrice) {
        this.productPrice = productPrice;
    }

    public Integer getProductQty() {
        return productQty;
    }

    public void setProductQty(Integer productQty) {
        this.productQty = productQty;
    }


    public String getImageLink() {
        return imageLink;
    }

    public void setImageLink(String imageLink) {
        this.imageLink = imageLink;
    }

    public Integer getProductPopularity() {
        return productPopularity;
    }

    public void setProductPopularity(Integer productPopularity) {
        this.productPopularity = productPopularity;
    }

    public Timestamp getProductCreatedTime() {
        return productCreatedTime;
    }

    public void setProductCreatedTime(Timestamp productCreatedTime) {
        this.productCreatedTime = productCreatedTime;
    }
    
     public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Override
    public String toString() {
        return "Products{"
                + "id='" + productId + '\''
                + ", name='" + productName + '\''
                + ", price=" + productPrice
                + ", stockQuantity=" + productCategory
                + ", category='" + productCategory + '\''
                + ", imageUrl='" + imageLink + '\''
                + ", productPopularity=" + productPopularity
                + ", productCreatedTime=" + productCreatedTime + '\''
                + ",productDescription=" + description
                + '}';
    }
}
