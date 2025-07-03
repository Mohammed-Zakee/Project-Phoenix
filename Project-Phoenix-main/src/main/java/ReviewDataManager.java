import java.io.*;
import java.util.LinkedList;

public class ReviewDataManager {
    private static final String REVIEW_FILE = "/reviews.txt";
    private static final String REVIEW_FILE_WRITABLE = "reviews.txt";

    public void addReview(Review review) throws IOException {
        File file = new File(REVIEW_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(review.getReviewId() + "," + review.getVehicleId() + "," +
                    review.getUsername() + "," + review.getRating() + "," +
                    review.getComment().replace(",", ";") + "," + review.getReviewDate());
            writer.newLine();
            System.out.println("Successfully added review with ID: " + review.getReviewId());
        }
    }

    public LinkedList<Review> getReviews() throws IOException {
        LinkedList<Review> reviews = new LinkedList<>();
        File writableFile = new File(REVIEW_FILE_WRITABLE);

        if (writableFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(writableFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        String[] parts = line.split(",");
                        if (parts.length == 6) {
                            reviews.add(new Review(parts[0], parts[1], parts[2],
                                    Integer.parseInt(parts[3]), parts[4].replace(";", ","), parts[5]));
                        }
                    }
                }
            }
            System.out.println("Successfully read " + reviews.size() + " reviews from writable file: " + writableFile.getAbsolutePath());
            return reviews;
        }

        try (InputStream is = getClass().getResourceAsStream(REVIEW_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            if (is == null) {
                writableFile.createNewFile();
                System.out.println("No reviews found in classpath, created empty writable file: " + writableFile.getAbsolutePath());
                return reviews;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] parts = line.split(",");
                    if (parts.length == 6) {
                        reviews.add(new Review(parts[0], parts[1], parts[2],
                                Integer.parseInt(parts[3]), parts[4].replace(";", ","), parts[5]));
                    }
                }
            }
            System.out.println("Successfully read " + reviews.size() + " reviews from classpath resource: " + REVIEW_FILE);
        }
        return reviews;
    }

    public void deleteReview(String reviewId) throws IOException {
        LinkedList<Review> reviews = getReviews();
        File file = new File(REVIEW_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
            for (Review r : reviews) {
                if (!r.getReviewId().equals(reviewId)) {
                    writer.write(r.getReviewId() + "," + r.getVehicleId() + "," +
                            r.getUsername() + "," + r.getRating() + "," +
                            r.getComment().replace(",", ";") + "," + r.getReviewDate());
                    writer.newLine();
                }
            }
            System.out.println("Successfully deleted review with ID: " + reviewId);
        }
    }
}