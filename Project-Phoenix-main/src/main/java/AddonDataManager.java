import java.io.*;
import java.util.LinkedList;

public class AddonDataManager {
    private static final String ADDON_FILE = "/addons.txt";
    private static final String ADDON_FILE_WRITABLE = "addons.txt";

    public void createAddon(Addon addon) throws IOException {
        File file = new File(ADDON_FILE_WRITABLE);
        if (!file.exists()) {
            file.createNewFile();
        }
        try (BufferedWriter writer = new BufferedWriter(new FileWriter(file, true))) {
            writer.write(addon.getAddonId() + "," + addon.getName() + "," + addon.getPrice());
            writer.newLine();
            System.out.println("Successfully created addon: " + addon.getName());
        }
    }

    public LinkedList<Addon> readAddons() throws IOException {
        LinkedList<Addon> addons = new LinkedList<>();
        File writableFile = new File(ADDON_FILE_WRITABLE);

        if (writableFile.exists()) {
            try (BufferedReader reader = new BufferedReader(new FileReader(writableFile))) {
                String line;
                while ((line = reader.readLine()) != null) {
                    if (!line.trim().isEmpty()) {
                        String[] parts = line.split(",");
                        if (parts.length == 3) {
                            addons.add(new Addon(parts[0], parts[1], Double.parseDouble(parts[2])));
                        }
                    }
                }
            }
            System.out.println("Successfully read " + addons.size() + " addons from writable file: " + writableFile.getAbsolutePath());
            return addons;
        }

        try (InputStream is = getClass().getResourceAsStream(ADDON_FILE);
             BufferedReader reader = is != null ? new BufferedReader(new InputStreamReader(is)) : null) {
            if (is == null) {
                writableFile.createNewFile();
                System.out.println("No addons found in classpath, created empty writable file: " + writableFile.getAbsolutePath());
                return addons;
            }
            String line;
            while ((line = reader.readLine()) != null) {
                if (!line.trim().isEmpty()) {
                    String[] parts = line.split(",");
                    if (parts.length == 3) {
                        addons.add(new Addon(parts[0], parts[1], Double.parseDouble(parts[2])));
                    }
                }
            }
            System.out.println("Successfully read " + addons.size() + " addons from classpath resource: " + ADDON_FILE);
        }
        return addons;
    }
}