package com.mywebtoon.model;

import java.sql.Timestamp;

public class Purchase {
    private int id;
    private int userId;
    private int episodeId;
    private int coinsSpent;
    private Timestamp purchasedAt;

    public Purchase() {}

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public int getEpisodeId() { return episodeId; }
    public void setEpisodeId(int episodeId) { this.episodeId = episodeId; }

    public int getCoinsSpent() { return coinsSpent; }
    public void setCoinsSpent(int coinsSpent) { this.coinsSpent = coinsSpent; }

    public Timestamp getPurchasedAt() { return purchasedAt; }
    public void setPurchasedAt(Timestamp purchasedAt) { this.purchasedAt = purchasedAt; }
}
