public class Payment {
    private String method; // "Cash" or "Card"
    private String cardNumber; // Null for cash payments
    private String cvn; // Card Verification Number, null for cash payments

    public Payment(String method, String cardNumber, String cvn) {
        this.method = method;
        this.cardNumber = cardNumber;
        this.cvn = cvn;
    }

    public Payment(String method) {
        this.method = method;
        this.cardNumber = null;
        this.cvn = null;
    }
    // Getters and setters
    public String getMethod() { return method; }
    public void setMethod(String method) { this.method = method; }
    public String getCardNumber() { return cardNumber; }
    public void setCardNumber(String cardNumber) { this.cardNumber = cardNumber; }
    public String getCvn() { return cvn; }
    public void setCvn(String cvn) { this.cvn = cvn; }

    @Override
    public String toString() {
        return method; // Only store the payment method in rentals.txt
    }
}
