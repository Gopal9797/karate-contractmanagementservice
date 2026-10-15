import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

public class KarateCache {
    private static final Map<String, String> KARATE_CACHE = new ConcurrentHashMap<>();

    public static void add(String key, String value) {
        KARATE_CACHE.put(key, value);
    }

    public static String get(String key) {
        return KARATE_CACHE.get(key);
    }
}