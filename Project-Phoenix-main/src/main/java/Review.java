public class Review {
    private String reviewId;
    private String vehicleId;
    private String username;
    private int rating;
    private String comment;
    private String reviewDate;

    public Review(String reviewId, String vehicleId, String username, int rating, String comment, String reviewDate) {
        this.reviewId = reviewId;
        this.vehicleId = vehicleId;
        this.username = username;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
    }

    // Getters
    public String getReviewId() { return reviewId; }
    public String getVehicleId() { return vehicleId; }
    public String getUsername() { return username; }
    public int getRating() { return rating; }
    public String getComment() { return comment; }
    public String getReviewDate() { return reviewDate; }
}