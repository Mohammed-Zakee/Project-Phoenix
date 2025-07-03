import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.LinkedList;
import java.util.Arrays;
import java.util.List;

@WebServlet("/vehicles")
public class VehicleServlet extends HttpServlet {
    private VehicleDataManager dataManager = new VehicleDataManager();
    private UserDataManager userDataManager = new UserDataManager();
    private ReviewDataManager reviewDataManager = new ReviewDataManager();
    private AddonDataManager addonDataManager = new AddonDataManager();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {
            session.setAttribute("isAdmin", user instanceof Admin);
        } else {
            session.setAttribute("isAdmin", false);
        }
        String action = request.getParameter("action");

        if (session.getAttribute("user") == null && !"login".equals(action) && !"register".equals(action)) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("list".equals(action)) {
            String search = request.getParameter("search");
            String availability = request.getParameter("availability");
            String category = request.getParameter("category");
            Vehicle[] vehicles = dataManager.readVehicles();
            LinkedList<Vehicle> filteredVehicles = new LinkedList<>();

            for (Vehicle v : vehicles) {
                boolean matchesSearch = search == null || search.isEmpty() ||
                        v.getId().toLowerCase().contains(search.toLowerCase()) ||
                        v.getModel().toLowerCase().contains(search.toLowerCase());
                boolean matchesAvailability = availability == null || availability.isEmpty() ||
                        v.isAvailable() == Boolean.parseBoolean(availability);
                boolean matchesCategory = category == null || category.isEmpty() ||
                        v.getCategory().equals(category);

                if (matchesSearch && matchesAvailability && matchesCategory) {
                    filteredVehicles.add(v);
                }
            }

            Vehicle[] sortedVehicles = dataManager.sortVehiclesByPrice(filteredVehicles.toArray(new Vehicle[0]));
            request.setAttribute("vehicles", sortedVehicles);
            request.setAttribute("addons", addonDataManager.readAddons());
            request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
        } else if ("edit".equals(action)) {
            if (!(user instanceof Admin)) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String id = request.getParameter("id");
            Vehicle[] vehicles = dataManager.readVehicles();
            for (Vehicle v : vehicles) {
                if (v.getId().equals(id)) {
                    request.setAttribute("vehicle", v);
                    break;
                }
            }
            request.getRequestDispatcher("/edit-vehicle.jsp").forward(request, response);
        } else if ("rentals".equals(action)) {
            LinkedList<RentalRecord> rentals = dataManager.getRentalRecords();
            LinkedList<RentalRecord> filteredRentals = new LinkedList<>();
            if (user instanceof Admin) {
                filteredRentals = rentals;
                System.out.println("Admin view: Loaded " + rentals.size() + " rentals");
            } else {
                for (RentalRecord r : rentals) {
                    if (r.getCustomerName().equals(user.getUsername())) {
                        filteredRentals.add(r);
                    }
                }
                System.out.println("Customer view for " + user.getUsername() + ": Loaded " + filteredRentals.size() + " rentals");
            }
            request.setAttribute("rentals", filteredRentals);
            request.setAttribute("isAdmin", user instanceof Admin);
            request.getRequestDispatcher("/rentals.jsp").forward(request, response);
        } else if ("reviews".equals(action)) {
            LinkedList<Review> reviews = reviewDataManager.getReviews();
            LinkedList<Review> filteredReviews = new LinkedList<>();
            if (user instanceof Admin) {
                for (Review r : reviews) {
                    try {
                        User reviewUser = userDataManager.getUserByUsername(r.getUsername());
                        if (reviewUser instanceof RegularUser) {
                            filteredReviews.add(r);
                        }
                    } catch (IOException e) {
                        // Skip if user not found
                    }
                }
            } else {
                for (Review r : reviews) {
                    if (r.getUsername().equals(user.getUsername())) {
                        filteredReviews.add(r);
                    }
                }
            }
            request.setAttribute("reviews", filteredReviews);
            request.setAttribute("vehicles", dataManager.readVehicles());
            request.getRequestDispatcher("/reviews.jsp").forward(request, response);
        } else if ("logout".equals(action)) {
            session.invalidate();
            response.sendRedirect("login.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");
        if (user != null) {
            session.setAttribute("isAdmin", user instanceof Admin);
        } else {
            session.setAttribute("isAdmin", false);
        }
        String action = request.getParameter("action");

        if (session.getAttribute("user") == null && !"login".equals(action) && !"register".equals(action)) {
            response.sendRedirect("login.jsp");
            return;
        }

        if ("login".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            System.out.println("Attempting login for username: " + username);
            try {
                User authenticatedUser = userDataManager.authenticate(username, password);
                if (authenticatedUser != null) {
                    System.out.println("Login successful for: " + username + ", user type: " + (authenticatedUser instanceof Admin ? "Admin" : "RegularUser"));
                    session.setAttribute("user", authenticatedUser);
                    session.setAttribute("isAdmin", authenticatedUser instanceof Admin);
                    response.sendRedirect("vehicles?action=list");
                } else {
                    System.out.println("Login failed: Invalid credentials for username: " + username);
                    request.setAttribute("error", "Invalid username or password");
                    request.getRequestDispatcher("/login.jsp").forward(request, response);
                }
            } catch (Exception e) {
                System.err.println("Login error for " + username + ": " + e.getMessage());
                e.printStackTrace();
                request.setAttribute("error", "Failed to authenticate user: " + e.getMessage());
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            }
        } else if ("register".equals(action)) {
            String username = request.getParameter("username");
            String password = request.getParameter("password");
            try {
                User newUser = new RegularUser(username, password);
                userDataManager.addUser(newUser);
                request.setAttribute("success", "Registration successful! Please login.");
                request.getRequestDispatcher("/login.jsp").forward(request, response);
            } catch (IOException e) {
                request.setAttribute("error", e.getMessage());
                request.getRequestDispatcher("/register.jsp").forward(request, response);
            }
        } else if ("add".equals(action)) {
            if (!(user instanceof Admin)) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            Vehicle vehicle = new Vehicle(
                    request.getParameter("id"),
                    request.getParameter("model"),
                    Double.parseDouble(request.getParameter("price")),
                    true,
                    request.getParameter("category")
            );
            dataManager.createVehicle(vehicle);
            response.sendRedirect("vehicles?action=list");
        } else if ("update".equals(action)) {
            if (!(user instanceof Admin)) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            Vehicle vehicle = new Vehicle(
                    request.getParameter("id"),
                    request.getParameter("model"),
                    Double.parseDouble(request.getParameter("price")),
                    Boolean.parseBoolean(request.getParameter("available")),
                    request.getParameter("category")
            );
            dataManager.updateVehicle(vehicle);
            response.sendRedirect("vehicles?action=list");
        } else if ("delete".equals(action)) {
            if (!(user instanceof Admin)) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String id = request.getParameter("id");
            dataManager.deleteVehicle(id);
            response.sendRedirect("vehicles?action=list");
        } else if ("rent".equals(action)) {
            if (user == null) {
                response.sendRedirect("login.jsp");
                return;
            }
            String daysStr = request.getParameter("days");
            String idCardNumber = request.getParameter("idCardNumber");
            String paymentMethod = request.getParameter("paymentMethod");
            String cardNumber = request.getParameter("cardNumber");
            String cvn = request.getParameter("cvn");
            String[] selectedAddons = request.getParameterValues("addons");
            String customerName = request.getParameter("customerName");

            System.out.println("Rental request - Username: " + user.getUsername() + ", Customer Name from Form: " + customerName + ", Payment Method: " + paymentMethod);

            if (idCardNumber == null || idCardNumber.trim().isEmpty() ||
                    daysStr == null || daysStr.trim().isEmpty() ||
                    paymentMethod == null || paymentMethod.trim().isEmpty() ||
                    customerName == null || customerName.trim().isEmpty()) {
                request.setAttribute("error", "Please fill in all required fields.");
                Vehicle[] vehicles = dataManager.readVehicles();
                request.setAttribute("vehicles", dataManager.sortVehiclesByPrice(vehicles));
                request.setAttribute("addons", addonDataManager.readAddons());
                request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
                return;
            }

            if ("Card".equals(paymentMethod)) {
                if (cardNumber == null || cardNumber.trim().isEmpty()) {
                    System.out.println("Validation failed: Card number is empty.");
                    request.setAttribute("error", "Card number is required for card payments.");
                    Vehicle[] vehicles = dataManager.readVehicles();
                    request.setAttribute("vehicles", dataManager.sortVehiclesByPrice(vehicles));
                    request.setAttribute("addons", addonDataManager.readAddons());
                    request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
                    return;
                }
                cardNumber = cardNumber.trim();
                if (!cardNumber.matches("^[0-9]{16}$")) {
                    System.out.println("Validation failed: Invalid card number: " + cardNumber);
                    request.setAttribute("error", "Please enter a valid 16-digit card number (numbers only).");
                    Vehicle[] vehicles = dataManager.readVehicles();
                    request.setAttribute("vehicles", dataManager.sortVehiclesByPrice(vehicles));
                    request.setAttribute("addons", addonDataManager.readAddons());
                    request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
                    return;
                }
                if (cvn == null || cvn.trim().isEmpty()) {
                    System.out.println("Validation failed: CVN is empty.");
                    request.setAttribute("error", "CVN is required for card payments.");
                    Vehicle[] vehicles = dataManager.readVehicles();
                    request.setAttribute("vehicles", dataManager.sortVehiclesByPrice(vehicles));
                    request.setAttribute("addons", addonDataManager.readAddons());
                    request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
                    return;
                }
                cvn = cvn.trim();
                if (!cvn.matches("^[0-9]{3,4}$")) {
                    System.out.println("Validation failed: Invalid CVN: " + cvn);
                    request.setAttribute("error", "Please enter a valid CVN (3-4 digits, numbers only).");
                    Vehicle[] vehicles = dataManager.readVehicles();
                    request.setAttribute("vehicles", dataManager.sortVehiclesByPrice(vehicles));
                    request.setAttribute("addons", addonDataManager.readAddons());
                    request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
                    return;
                }
            }

            int days;
            try {
                days = Integer.parseInt(daysStr);
                if (days < 1) {
                    throw new NumberFormatException("Days must be at least 1.");
                }
            } catch (NumberFormatException e) {
                System.out.println("Validation failed: Invalid days: " + daysStr);
                request.setAttribute("error", "Invalid number of days. Please enter a positive integer.");
                Vehicle[] vehicles = dataManager.readVehicles();
                request.setAttribute("vehicles", dataManager.sortVehiclesByPrice(vehicles));
                request.setAttribute("addons", addonDataManager.readAddons());
                request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
                return;
            }

            String vehicleId = request.getParameter("id");
            Vehicle[] vehicles = dataManager.readVehicles();
            Vehicle targetVehicle = null;
            for (Vehicle v : vehicles) {
                if (v.getId().equals(vehicleId) && v.isAvailable()) {
                    targetVehicle = v;
                    break;
                }
            }
            if (targetVehicle == null) {
                System.out.println("Validation failed: Vehicle not found or unavailable: " + vehicleId);
                request.setAttribute("error", "Vehicle not found or unavailable.");
                request.setAttribute("vehicles", dataManager.sortVehiclesByPrice(vehicles));
                request.setAttribute("addons", addonDataManager.readAddons());
                request.getRequestDispatcher("/vehicles.jsp").forward(request, response);
                return;
            }

            Payment payment = new Payment(paymentMethod, "Card".equals(paymentMethod) ? cardNumber : null, "Card".equals(paymentMethod) ? cvn : null);
            List<String> addons = selectedAddons != null ? Arrays.asList(selectedAddons) : null;
            RentalRecord record = new RentalRecord(
                    targetVehicle.getId(),
                    targetVehicle.getModel(),
                    targetVehicle.getRentPrice(),
                    customerName.trim(), // Use the customer-entered name
                    java.time.LocalDate.now().toString(),
                    idCardNumber,
                    days,
                    payment,
                    addons
            );
            System.out.println("Creating rental record for vehicle: " + targetVehicle.getId() + ", customer: " + customerName);
            dataManager.rentVehicle(record);
            Vehicle vehicle = new Vehicle(
                    targetVehicle.getId(),
                    targetVehicle.getModel(),
                    targetVehicle.getRentPrice(),
                    false,
                    targetVehicle.getCategory()
            );
            dataManager.updateVehicle(vehicle);
            System.out.println("Rental successful, redirecting to vehicle list.");
            response.sendRedirect("vehicles?action=list");
        } else if ("return".equals(action)) {
            if (!(user instanceof Admin)) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String id = request.getParameter("id");
            String rentalDate = request.getParameter("rentalDate");
            System.out.println("Attempting to return vehicle - ID: " + id + ", Rental Date: " + rentalDate);
            LinkedList<RentalRecord> records = dataManager.getRentalRecords();
            boolean found = false;
            for (RentalRecord r : records) {
                System.out.println("Checking record - ID: " + r.getId() + ", Rental Date: " + r.getRentalDate());
                if (r.getId().equals(id) && r.getRentalDate().equals(rentalDate)) {
                    found = true;
                    System.out.println("Match found, updating record.");
                    r.setReturnDate(java.time.LocalDate.now().toString());
                    r.setReturned(true);
                    try {
                        dataManager.updateRentalRecord(r);
                        System.out.println("Rental record updated successfully.");
                    } catch (IOException e) {
                        System.err.println("Failed to update rental record: " + e.getMessage());
                        request.setAttribute("error", "Failed to update rental record: " + e.getMessage());
                        request.setAttribute("rentals", records);
                        request.getRequestDispatcher("/rentals.jsp").forward(request, response);
                        return;
                    }
                    Vehicle[] vehicles = dataManager.readVehicles();
                    String category = "Unknown";
                    for (Vehicle v : vehicles) {
                        if (v.getId().equals(r.getId())) {
                            category = v.getCategory();
                            break;
                        }
                    }
                    Vehicle vehicle = new Vehicle(r.getId(), r.getModel(), r.getRentPrice(), true, category);
                    try {
                        dataManager.updateVehicle(vehicle);
                        System.out.println("Vehicle availability updated successfully.");
                    } catch (IOException e) {
                        System.err.println("Failed to update vehicle availability: " + e.getMessage());
                        request.setAttribute("error", "Failed to update vehicle availability: " + e.getMessage());
                        request.setAttribute("rentals", records);
                        request.getRequestDispatcher("/rentals.jsp").forward(request, response);
                        return;
                    }
                    break;
                }
            }
            if (!found) {
                System.out.println("No matching rental record found for ID: " + id + ", Rental Date: " + rentalDate);
                request.setAttribute("error", "No matching rental record found.");
                request.setAttribute("rentals", records);
                request.getRequestDispatcher("/rentals.jsp").forward(request, response);
                return;
            }
            response.sendRedirect("vehicles?action=rentals");
        } else if ("deleteRentals".equals(action)) {
            if (!(user instanceof Admin)) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String[] selectedRentals = request.getParameterValues("selectedRentals");
            if (selectedRentals != null && selectedRentals.length > 0) {
                dataManager.deleteRentals(selectedRentals);
            }
            response.sendRedirect("vehicles?action=rentals");
        } else if ("updatePayment".equals(action)) {
            if (user == null || user instanceof Admin) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String id = request.getParameter("id");
            String rentalDate = request.getParameter("rentalDate");
            String paymentMethod = request.getParameter("paymentMethod");
            String cardNumber = request.getParameter("cardNumber");
            String cvn = request.getParameter("cvn");

            // Validate input parameters
            if (id == null || rentalDate == null || paymentMethod == null) {
                LinkedList<RentalRecord> rentals = dataManager.getRentalRecords();
                LinkedList<RentalRecord> filteredRentals = new LinkedList<>();
                for (RentalRecord r : rentals) {
                    if (r.getCustomerName().equals(user.getUsername())) {
                        filteredRentals.add(r);
                    }
                }
                request.setAttribute("rentals", filteredRentals);
                request.setAttribute("error", "Invalid request parameters.");
                request.getRequestDispatcher("/rentals.jsp").forward(request, response);
                return;
            }

            // Validate card payment details if payment method is Card
            if ("Card".equals(paymentMethod)) {
                if (cardNumber == null || cardNumber.trim().isEmpty() || !cardNumber.matches("^[0-9]{16}$")) {
                    LinkedList<RentalRecord> rentals = dataManager.getRentalRecords();
                    LinkedList<RentalRecord> filteredRentals = new LinkedList<>();
                    for (RentalRecord r : rentals) {
                        if (r.getCustomerName().equals(user.getUsername())) {
                            filteredRentals.add(r);
                        }
                    }
                    request.setAttribute("rentals", filteredRentals);
                    request.setAttribute("error", "Please enter a valid 16-digit card number.");
                    request.getRequestDispatcher("/rentals.jsp").forward(request, response);
                    return;
                }
                if (cvn == null || cvn.trim().isEmpty() || !cvn.matches("^[0-9]{3,4}$")) {
                    LinkedList<RentalRecord> rentals = dataManager.getRentalRecords();
                    LinkedList<RentalRecord> filteredRentals = new LinkedList<>();
                    for (RentalRecord r : rentals) {
                        if (r.getCustomerName().equals(user.getUsername())) {
                            filteredRentals.add(r);
                        }
                    }
                    request.setAttribute("rentals", filteredRentals);
                    request.setAttribute("error", "Please enter a valid CVN (3-4 digits).");
                    request.getRequestDispatcher("/rentals.jsp").forward(request, response);
                    return;
                }
            }

            try {
                // Create new payment object
                Payment payment = new Payment(paymentMethod, "Card".equals(paymentMethod) ? cardNumber : null, "Card".equals(paymentMethod) ? cvn : null);

                // Update the payment in the data manager
                dataManager.updatePayment(id, rentalDate, payment);
                System.out.println("Successfully updated payment for rental with ID: " + id + " and date: " + rentalDate);

                // Reload rentals for the user
                LinkedList<RentalRecord> rentals = dataManager.getRentalRecords();
                LinkedList<RentalRecord> filteredRentals = new LinkedList<>();
                for (RentalRecord r : rentals) {
                    if (r.getCustomerName().equals(user.getUsername())) {
                        filteredRentals.add(r);
                    }
                }
                request.setAttribute("rentals", filteredRentals);
                request.setAttribute("success", "Payment method updated successfully!");
                request.getRequestDispatcher("/rentals.jsp").forward(request, response);
            } catch (Exception e) {
                System.err.println("Error updating payment for ID: " + id + ", Rental Date: " + rentalDate + " - " + e.getMessage());
                e.printStackTrace();
                LinkedList<RentalRecord> rentals = dataManager.getRentalRecords();
                LinkedList<RentalRecord> filteredRentals = new LinkedList<>();
                for (RentalRecord r : rentals) {
                    if (r.getCustomerName().equals(user.getUsername())) {
                        filteredRentals.add(r);
                    }
                }
                request.setAttribute("rentals", filteredRentals);
                request.setAttribute("error", "Failed to update payment: " + e.getMessage());
                request.getRequestDispatcher("/rentals.jsp").forward(request, response);
            }
        } else if ("deletePayment".equals(action)) {
            if (user == null || user instanceof Admin) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String id = request.getParameter("id");
            String rentalDate = request.getParameter("rentalDate");
            dataManager.deletePayment(id, rentalDate);
            System.out.println("Successfully deleted payment for rental with ID: " + id + " and date: " + rentalDate);
            request.setAttribute("success", "Payment deleted successfully! Rental record removed, and vehicle is now available.");
            LinkedList<RentalRecord> rentals = dataManager.getRentalRecords();
            LinkedList<RentalRecord> filteredRentals = new LinkedList<>();
            for (RentalRecord r : rentals) {
                if (r.getCustomerName().equals(user.getUsername())) {
                    filteredRentals.add(r);
                }
            }
            request.setAttribute("rentals", filteredRentals);
            request.getRequestDispatcher("/rentals.jsp").forward(request, response);
        } else if ("addReview".equals(action)) {
            if (user == null || user instanceof Admin) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String vehicleId = request.getParameter("vehicleId");
            String ratingStr = request.getParameter("rating");
            String comment = request.getParameter("comment");

            int rating;
            try {
                rating = Integer.parseInt(ratingStr);
                if (rating < 1 || rating > 5) {
                    throw new NumberFormatException("Rating must be between 1 and 5.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid rating. Please enter a number between 1 and 5.");
                LinkedList<Review> reviews = reviewDataManager.getReviews();
                LinkedList<Review> filteredReviews = new LinkedList<>();
                for (Review r : reviews) {
                    if (r.getUsername().equals(user.getUsername())) {
                        filteredReviews.add(r);
                    }
                }
                request.setAttribute("reviews", filteredReviews);
                request.setAttribute("vehicles", dataManager.readVehicles());
                request.getRequestDispatcher("/reviews.jsp").forward(request, response);
                return;
            }

            Review review = new Review(
                    "R" + System.currentTimeMillis(),
                    vehicleId,
                    user.getUsername(),
                    rating,
                    comment,
                    java.time.LocalDate.now().toString()
            );
            reviewDataManager.addReview(review);
            response.sendRedirect("vehicles?action=reviews");
        } else if ("deleteReview".equals(action)) {
            if (user == null || user instanceof Admin) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String reviewId = request.getParameter("reviewId");
            LinkedList<Review> reviews = reviewDataManager.getReviews();
            for (Review r : reviews) {
                if (r.getReviewId().equals(reviewId) && r.getUsername().equals(user.getUsername())) {
                    reviewDataManager.deleteReview(reviewId);
                    break;
                }
            }
            response.sendRedirect("vehicles?action=reviews");
        } else if ("createAddon".equals(action)) {
            if (!(user instanceof Admin)) {
                response.sendRedirect("vehicles?action=list");
                return;
            }
            String addonId = request.getParameter("addonId");
            String name = request.getParameter("name");
            String priceStr = request.getParameter("price");

            double price;
            try {
                price = Double.parseDouble(priceStr);
                if (price < 0) {
                    throw new NumberFormatException("Price must be non-negative.");
                }
            } catch (NumberFormatException e) {
                request.setAttribute("error", "Invalid price. Please enter a non-negative number.");
                request.getRequestDispatcher("/add-addon.jsp").forward(request, response);
                return;
            }

            Addon addon = new Addon(addonId, name, price);
            addonDataManager.createAddon(addon);
            response.sendRedirect("vehicles?action=list");
        }
    }
}