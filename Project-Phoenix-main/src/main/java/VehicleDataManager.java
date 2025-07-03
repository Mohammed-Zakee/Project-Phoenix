import java.io.*;
import java.util.Arrays; // Added for Arrays.asList
import java.util.LinkedList;
import java.util.List;
import java.util.stream.Collectors;
public class VehicleDataManager {
    private static final String VEHICLE_FILE = "/vehicles.txt";
    private static final String RENTAL_FILE = "/rentals.txt";
    private static final String VEHICLE_FILE_WRITABLE = "vehicles.txt";
    private static final String RENTAL_FILE_WRITABLE = "rentals.txt";
    private LinkedList<RentalRecord> rentalRecords = new LinkedList<>();

    public void createVehicle(Vehicle vehicle) throws IOException {
        File file = new File(VEHICLE_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(vehicle.getId() + "," + vehicle.getModel() + "," +
                    vehicle.getRentPrice() + "," + vehicle.isAvailable() + "," + vehicle.getCategory());
            writer.newLine();
            System.out.println("Successfully created vehicle: " + vehicle.getModel());
        }
    }

    public Vehicle[] readVehicles() throws IOException {
        LinkedList<Vehicle> vehicles = new LinkedList<>();
        File writableFile = new File(VEHICLE_FILE_WRITABLE);
        boolean writableFileOutdated = false;

        if (writableFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(writableFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        String[] parts = line.split(",");
                        if (parts.length == 5) {
                            vehicles.add(new Vehicle(parts[0], parts[1],
                                    Double.parseDouble(parts[2]), Boolean.parseBoolean(parts[3]), parts[4]));
                        } else if (parts.length == 4) {
                            writableFileOutdated = true;
                            break;
                        }
                    }
                }
            }
            if (!vehicles.isEmpty() && !writableFileOutdated) {
                System.out.println("Successfully read " + vehicles.size() + " vehicles from writable file: " + writableFile.getAbsolutePath());
                return vehicles.toArray(new Vehicle[0]);
            }
        }

        vehicles.clear();
        try (InputStream is = getClass().getResourceAsStream(VEHICLE_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            if (is == null) {
                writableFile.createNewFile();
                System.out.println("No vehicles found in classpath, created empty writable file: " + writableFile.getAbsolutePath());
                return new Vehicle[0];
            }
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] parts = line.split(",");
                    if (parts.length == 5) {
                        vehicles.add(new Vehicle(parts[0], parts[1],
                                Double.parseDouble(parts[2]), Boolean.parseBoolean(parts[3]), parts[4]));
                    } else if (parts.length == 4) {
                        vehicles.add(new Vehicle(parts[0], parts[1],
                                Double.parseDouble(parts[2]), Boolean.parseBoolean(parts[3])));
                    }
                }
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(writableFile))) {
                for (Vehicle v : vehicles) {
                    writer.write(v.getId() + "," + v.getModel() + "," +
                            v.getRentPrice() + "," + v.isAvailable() + "," + v.getCategory());
                    writer.newLine();
                }
            }
            System.out.println("Successfully read " + vehicles.size() + " vehicles from classpath resource: " + VEHICLE_FILE);
        }
        return vehicles.toArray(new Vehicle[0]);
    }

    public void updateVehicle(Vehicle updatedVehicle) throws IOException {
        Vehicle[] vehicles = readVehicles();
        File file = new File(VEHICLE_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            boolean found = false;
            for (Vehicle v : vehicles) {
                if (v.getId().equals(updatedVehicle.getId())) {
                    writer.write(updatedVehicle.getId() + "," + updatedVehicle.getModel() + "," +
                            updatedVehicle.getRentPrice() + "," + updatedVehicle.isAvailable() + "," +
                            updatedVehicle.getCategory());
                    found = true;
                } else {
                    writer.write(v.getId() + "," + v.getModel() + "," +
                            v.getRentPrice() + "," + v.isAvailable() + "," + v.getCategory());
                }
                writer.newLine();
            }
            if (!found) {
                writer.write(updatedVehicle.getId() + "," + updatedVehicle.getModel() + "," +
                        updatedVehicle.getRentPrice() + "," + updatedVehicle.isAvailable() + "," +
                        updatedVehicle.getCategory());
                writer.newLine();
            }
            System.out.println("Successfully updated vehicle with ID: " + updatedVehicle.getId());
        }
    }

    public void deleteVehicle(String id) throws IOException {
        Vehicle[] vehicles = readVehicles();
        File file = new File(VEHICLE_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Vehicle v : vehicles) {
                if (!v.getId().equals(id)) {
                    writer.write(v.getId() + "," + v.getModel() + "," +
                            v.getRentPrice() + "," + v.isAvailable() + "," + v.getCategory());
                    writer.newLine();
                }
            }
            System.out.println("Successfully deleted vehicle with ID: " + id);
        }
    }

    public void rentVehicle(RentalRecord record) throws IOException {
        rentalRecords.add(record);
        File file = new File(RENTAL_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(record.getId() + "," + record.getModel() + "," +
                    record.getRentPrice() + "," + record.getCustomerName() + "," +
                    record.getIdCardNumber() + "," + record.getRentalDate() + "," +
                    (record.getReturnDate() != null ? record.getReturnDate() : "") + "," +
                    record.isReturned() + "," + record.getDays() + "," +
                    (record.getPayment() != null ? record.getPayment().getMethod() : "") + "," +
                    (record.getAddons() != null ? String.join(";", record.getAddons()) : ""));
            writer.newLine();
            System.out.println("Successfully rented vehicle with ID: " + record.getId() + " to " + record.getCustomerName());
        }
    }

    public LinkedList<RentalRecord> getRentalRecords() throws IOException {
        rentalRecords.clear();
        File writableFile = new File(RENTAL_FILE_WRITABLE);

        if (writableFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(writableFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        String[] parts = line.split(",");
                        if (parts.length >= 9) { // Ensure at least 9 fields (required fields)
                            try {
                                Payment payment = null;
                                if (parts.length > 9 && !parts[9].trim().isEmpty()) {
                                    payment = new Payment(parts[9], null, null); // Basic payment with method only
                                }
                                List<String> addons = null;
                                if (parts.length > 10 && !parts[10].trim().isEmpty()) {
                                    addons = Arrays.asList(parts[10].split(";"));
                                }
                                RentalRecord record = new RentalRecord(
                                        parts[0], parts[1],
                                        Double.parseDouble(parts[2]), parts[3], parts[5], parts[4],
                                        Integer.parseInt(parts[8]), payment, addons
                                );
                                if (parts.length > 6 && !parts[6].trim().isEmpty()) {
                                    record.setReturnDate(parts[6]);
                                }
                                if (parts.length > 7) {
                                    record.setReturned(Boolean.parseBoolean(parts[7]));
                                }
                                rentalRecords.add(record);
                            } catch (Exception e) {
                                System.err.println("Error parsing rental record: " + line + " - " + e.getMessage());
                                continue; // Skip malformed records
                            }
                        } else {
                            System.err.println("Invalid rental record format, skipping: " + line);
                        }
                    }
                }
            }
            System.out.println("Successfully read " + rentalRecords.size() + " rental records from writable file: " + writableFile.getAbsolutePath());
            return rentalRecords;
        }

        try (InputStream is = getClass().getResourceAsStream(RENTAL_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            if (is == null) {
                writableFile.createNewFile();
                System.out.println("No rental records found in classpath, created empty writable file: " + writableFile.getAbsolutePath());
                return rentalRecords;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] parts = line.split(",");
                    if (parts.length >= 9) { // Ensure at least 9 fields (required fields)
                        try {
                            Payment payment = null;
                            if (parts.length > 9 && !parts[9].trim().isEmpty()) {
                                payment = new Payment(parts[9], null, null); // Basic payment with method only
                            }
                            List<String> addons = null;
                            if (parts.length > 10 && !parts[10].trim().isEmpty()) {
                                addons = Arrays.asList(parts[10].split(";"));
                            }
                            RentalRecord record = new RentalRecord(
                                    parts[0], parts[1],
                                    Double.parseDouble(parts[2]), parts[3], parts[5], parts[4],
                                    Integer.parseInt(parts[8]), payment, addons
                            );
                            if (parts.length > 6 && !parts[6].trim().isEmpty()) {
                                record.setReturnDate(parts[6]);
                            }
                            if (parts.length > 7) {
                                record.setReturned(Boolean.parseBoolean(parts[7]));
                            }
                            rentalRecords.add(record);
                        } catch (Exception e) {
                            System.err.println("Error parsing rental record: " + line + " - " + e.getMessage());
                            continue; // Skip malformed records
                        }
                    } else {
                        System.err.println("Invalid rental record format, skipping: " + line);
                    }
                }
            }
            System.out.println("Successfully read " + rentalRecords.size() + " rental records from classpath resource: " + RENTAL_FILE);
        }
        return rentalRecords;
    }

    public void updateRentalRecord(RentalRecord updatedRecord) throws IOException {
        LinkedList<RentalRecord> records = getRentalRecords();
        File file = new File(RENTAL_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (RentalRecord r : records) {
                if (r.getId().equals(updatedRecord.getId()) && r.getRentalDate().equals(updatedRecord.getRentalDate())) {
                    writer.write(updatedRecord.getId() + "," + updatedRecord.getModel() + "," +
                            updatedRecord.getRentPrice() + "," + updatedRecord.getCustomerName() + "," +
                            updatedRecord.getIdCardNumber() + "," + updatedRecord.getRentalDate() + "," +
                            (updatedRecord.getReturnDate() != null ? updatedRecord.getReturnDate() : "") + "," +
                            updatedRecord.isReturned() + "," + updatedRecord.getDays() + "," +
                            (updatedRecord.getPayment() != null ? updatedRecord.getPayment().getMethod() : "") + "," +
                            (updatedRecord.getAddons() != null ? String.join(";", updatedRecord.getAddons()) : ""));
                } else {
                    writer.write(r.getId() + "," + r.getModel() + "," +
                            r.getRentPrice() + "," + r.getCustomerName() + "," +
                            r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                            (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                            r.isReturned() + "," + r.getDays() + "," +
                            (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                            (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                }
                writer.newLine();
            }
            System.out.println("Successfully updated rental record with ID: " + updatedRecord.getId() + " and date: " + updatedRecord.getRentalDate());
        }
    }

    public void updatePayment(String id, String rentalDate, Payment payment) throws IOException {
        LinkedList<RentalRecord> records = getRentalRecords();
        File file = new File(RENTAL_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        boolean recordFound = false;
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (RentalRecord r : records) {
                if (r.getId().equals(id) && r.getRentalDate().equals(rentalDate)) {
                    r.setPayment(payment);
                    writer.write(r.getId() + "," + r.getModel() + "," +
                            r.getRentPrice() + "," + r.getCustomerName() + "," +
                            r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                            (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                            r.isReturned() + "," + r.getDays() + "," +
                            (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                            (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                    recordFound = true;
                } else {
                    writer.write(r.getId() + "," + r.getModel() + "," +
                            r.getRentPrice() + "," + r.getCustomerName() + "," +
                            r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                            (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                            r.isReturned() + "," + r.getDays() + "," +
                            (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                            (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                }
                writer.newLine();
            }
            if (!recordFound) {
                throw new IOException("Rental record not found for ID: " + id + " and date: " + rentalDate);
            }
            System.out.println("Successfully updated payment for rental with ID: " + id + " and date: " + rentalDate);
        } catch (IOException e) {
            System.err.println("Error writing to rentals file: " + e.getMessage());
            throw e;
        }
    }

    public void deletePayment(String id, String rentalDate) throws IOException {
        LinkedList<RentalRecord> records = getRentalRecords();
        File rentalFile = new File(RENTAL_FILE_WRITABLE);
        if (!rentalFile.exists()) {
            rentalFile.createNewFile();
        }

        // Find the rental record to get vehicle details before deleting
        RentalRecord targetRecord = null;
        for (RentalRecord r : records) {
            if (r.getId().equals(id) && r.getRentalDate().equals(rentalDate)) {
                targetRecord = r;
                break;
            }
        }

        if (targetRecord != null) {
            // Mark the vehicle as available
            Vehicle[] vehicles = readVehicles();
            File vehicleFile = new File(VEHICLE_FILE_WRITABLE);
            if (!vehicleFile.exists()) {
                vehicleFile.createNewFile();
            }
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(vehicleFile))) {
                for (Vehicle v : vehicles) {
                    if (v.getId().equals(targetRecord.getId())) {
                        writer.write(v.getId() + "," + v.getModel() + "," +
                                v.getRentPrice() + "," + true + "," + v.getCategory());
                    } else {
                        writer.write(v.getId() + "," + v.getModel() + "," +
                                v.getRentPrice() + "," + v.isAvailable() + "," + v.getCategory());
                    }
                    writer.newLine();
                }
                System.out.println("Vehicle with ID " + targetRecord.getId() + " is now available for rent");
            }

            // Delete the rental record
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(rentalFile))) {
                for (RentalRecord r : records) {
                    if (!(r.getId().equals(id) && r.getRentalDate().equals(rentalDate))) {
                        writer.write(r.getId() + "," + r.getModel() + "," +
                                r.getRentPrice() + "," + r.getCustomerName() + "," +
                                r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                                (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                                r.isReturned() + "," + r.getDays() + "," +
                                (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                                (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                        writer.newLine();
                    }
                }
                System.out.println("Successfully deleted payment and rental record for rental with ID: " + id + " and date: " + rentalDate);
            }
        }
    }

    public void deleteRentals(String[] selectedRentals) throws IOException {
        LinkedList<RentalRecord> records = getRentalRecords();
        File file = new File(RENTAL_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (RentalRecord r : records) {
                String key = r.getId() + "_" + r.getRentalDate();
                boolean keep = true;
                for (String selected : selectedRentals) {
                    if (key.equals(selected)) {
                        keep = false;
                        break;
                    }
                }
                if (keep) {
                    writer.write(r.getId() + "," + r.getModel() + "," +
                            r.getRentPrice() + "," + r.getCustomerName() + "," +
                            r.getIdCardNumber() + "," + r.getRentalDate() + "," +
                            (r.getReturnDate() != null ? r.getReturnDate() : "") + "," +
                            r.isReturned() + "," + r.getDays() + "," +
                            (r.getPayment() != null ? r.getPayment().getMethod() : "") + "," +
                            (r.getAddons() != null ? String.join(";", r.getAddons()) : ""));
                    writer.newLine();
                }
            }
            System.out.println("Successfully deleted " + selectedRentals.length + " rental records");
        }
    }

    public Vehicle[] sortVehiclesByPrice(Vehicle[] vehicles) {
        for (int i = 0; i < vehicles.length - 1; i++) {
            int minIdx = i;
            for (int j = i + 1; j < vehicles.length; j++) {
                if (vehicles[j].getRentPrice() < vehicles[minIdx].getRentPrice()) {
                    minIdx = j;
                }
            }
            Vehicle temp = vehicles[minIdx];
            vehicles[minIdx] = vehicles[i];
            vehicles[i] = temp;
        }
        return vehicles;
    }
}