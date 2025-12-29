package com.coffeeshop.model;

public class Product {
    private int id;
    private String name;
    private String category;
    private double price;
    private String imageUrl;

    public Product(int id, String name, String category, double price, String imageUrl) {
        this.id = id;
        this.name = name;
        this.category = category;
        this.price = price;
        this.imageUrl = imageUrl;
    }

    // Getters
    public int getId() { return id; }
    public String getName() { return name; }
    public String getCategory() { return category; }
    public double getPrice() { return price; }
    public String getImageUrl() { return imageUrl; }
}