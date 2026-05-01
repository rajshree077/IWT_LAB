package com.mywebtoon.model;

import java.sql.Timestamp;

public class Episode {
    private int id;
    private int comicId;
    private int episodeNumber;
    private String title;
    private String imagesJson;
    private boolean isLocked;
    private int price;
    private Timestamp createdAt;

    public Episode() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getComicId() { return comicId; }
    public void setComicId(int comicId) { this.comicId = comicId; }

    public int getEpisodeNumber() { return episodeNumber; }
    public void setEpisodeNumber(int episodeNumber) { this.episodeNumber = episodeNumber; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getImagesJson() { return imagesJson; }
    public void setImagesJson(String imagesJson) { this.imagesJson = imagesJson; }

    public boolean isLocked() { return isLocked; }
    public void setLocked(boolean isLocked) { this.isLocked = isLocked; }

    public int getPrice() { return price; }
    public void setPrice(int price) { this.price = price; }

    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
}
