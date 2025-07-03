public class Vehicle {
    protected String id;
    protected String model;
    protected double rentPrice;
    protected boolean isAvailable;
    protected String category; // New field

    public Vehicle(String id, String model, double rentPrice, boolean isAvailable) {
        this(id, model, rentPrice, isAvailable, "Unknown"); // Default category for backward compatibility
    }

    public Vehicle(String id, String model, double rentPrice, boolean isAvailable, String category) {
        this.id = id;
        this.model = model;
        this.rentPrice = rentPrice;
        this.isAvailable = isAvailable;
        this.category = category;
    }

    // Getters and setters
    public String getId() { return id; }
    public String getModel() { return model; }
    public double getRentPrice() { return rentPrice; }
    public boolean isAvailable() { return isAvailable; }
    public void setModel(String model) { this.model = model; }
    public void setRentPrice(double rentPrice) { this.rentPrice = rentPrice; }
    public void setAvailable(boolean available) { isAvailable = available; }
    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }
}