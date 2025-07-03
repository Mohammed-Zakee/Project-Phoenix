public class Addon {
    private String addonId;
    private String name;
    private double price;

    public Addon(String addonId, String name, double price) {
        this.addonId = addonId;
        this.name = name;
        this.price = price;
    }

    // Getters
    public String getAddonId() {return this.addonId;}
    public String getName() {return this.name;}
    public double getPrice() {return this.price;}
}