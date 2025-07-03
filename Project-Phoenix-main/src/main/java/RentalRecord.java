import java.util.List;

public class RentalRecord extends Vehicle {
    private String customerName;
    private String rentalDate;
    private String returnDate;
    private boolean returned;
    private String idCardNumber;
    private int days;
    private Payment payment;
    private List<String> addons;

    public RentalRecord(String id, String model, double rentPrice, String customerName, String rentalDate, String idCardNumber, int days, Payment payment, List<String> addons) {
        super(id, model, rentPrice, false);
        this.customerName = customerName;
        this.rentalDate = rentalDate;
        this.returnDate = null;
        this.returned = false;
        this.idCardNumber = idCardNumber;
        this.days = days;
        this.payment = payment;
        this.addons = addons;
    }

    // Getters and setters
    public String getCustomerName() { return customerName; }
    public String getRentalDate() { return rentalDate; }
    public String getReturnDate() { return returnDate; }
    public void setReturnDate(String returnDate) { this.returnDate = returnDate; }
    public boolean isReturned() { return returned; }
    public void setReturned(boolean returned) { this.returned = returned; }
    public String getIdCardNumber() { return idCardNumber; }
    public int getDays() { return days; }
    public void setDays(int days) { this.days = days; }
    public Payment getPayment() { return payment; }
    public void setPayment(Payment payment) { this.payment = payment; }
    public List<String> getAddons() { return addons; }
    public void setAddons(List<String> addons) { this.addons = addons; }
}  
