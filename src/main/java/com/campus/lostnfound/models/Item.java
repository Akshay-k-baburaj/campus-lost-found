package com.campus.lostnfound.models;

import java.time.LocalDateTime;

public class Item {
    private int id;
    private int userId;
    private String itemName;
    private String description;
    private String itemType; // LOST or FOUND
    private String location;
    private String status; // OPEN, CLAIMED, RETURNED
    private LocalDateTime postedDate;
    private LocalDateTime claimedDate;
    private String contactInfo;
    private String category;

    public Item() {}

    public Item(int userId, String itemName, String description, String itemType,
                String location, String contactInfo, String category) {
        this.userId = userId;
        this.itemName = itemName;
        this.description = description;
        this.itemType = itemType;
        this.location = location;
        this.contactInfo = contactInfo;
        this.category = category;
        this.status = "OPEN";
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getItemName() { return itemName; }
    public void setItemName(String itemName) { this.itemName = itemName; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public String getItemType() { return itemType; }
    public void setItemType(String itemType) { this.itemType = itemType; }

    public String getLocation() { return location; }
    public void setLocation(String location) { this.location = location; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getPostedDate() { return postedDate; }
    public void setPostedDate(LocalDateTime postedDate) { this.postedDate = postedDate; }

    public LocalDateTime getClaimedDate() { return claimedDate; }
    public void setClaimedDate(LocalDateTime claimedDate) { this.claimedDate = claimedDate; }

    public String getContactInfo() { return contactInfo; }
    public void setContactInfo(String contactInfo) { this.contactInfo = contactInfo; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}
