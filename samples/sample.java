/**
 * void-space.nvim — Java Sample
 *
 * <p>Demonstrates: classes, interfaces, generics, records, sealed types,
 * enums, lambdas, streams, Optional, annotations, and modern Java patterns.
 */
package space.void.sample;

import java.util.*;
import java.util.concurrent.*;
import java.util.function.*;
import java.util.stream.*;
import java.time.Instant;

// Annotations

@interface Author {
    String name();
    String since() default "1.0";
}

// Enum

enum SpectralClass {
    O(16.0), B(2.1), A(1.4), F(1.04), G(0.8), K(0.45), M(0.0);

    private final double minMass; // solar masses

    SpectralClass(double minMass) {
        this.minMass = minMass;
    }

    static SpectralClass of(double massSolar) {
        SpectralClass[] values = values();
        for (SpectralClass c : values) {
            if (massSolar >= c.minMass) return c;
        }
        return M;
    }

    @Override
    public String toString() { return name(); }
}

// Interface & sealed types

interface CelestialBody {
    String name();
    String describe();

    default String summary() {
        return "[%s] %s".formatted(getClass().getSimpleName(), describe());
    }
}

sealed interface Observation permits VisualObservation, RadioObservation {
    Instant timestamp();
    String target();
    String format();
}

// Records

record VisualObservation(Instant timestamp, String target, double magnitude)
        implements Observation {
    @Override public String format() {
        return "Visual[%s] target=%s mag=%.2f".formatted(timestamp, target, magnitude);
    }
}

record RadioObservation(Instant timestamp, String target, double frequencyGHz)
        implements Observation {
    @Override public String format() {
        return "Radio[%s] target=%s freq=%.3f GHz".formatted(timestamp, target, frequencyGHz);
    }
}

// Custom exception

class ObservationException extends RuntimeException {
    private final String starName;

    ObservationException(String starName, String message) {
        super(message);
        this.starName = starName;
    }

    ObservationException(String starName, String message, Throwable cause) {
        super(message, cause);
        this.starName = starName;
    }

    public String getStarName() { return starName; }
}

// Generic class

class Catalogue<T extends CelestialBody> {
    private final List<T> entries = new ArrayList<>();
    private final Map<String, T> index = new HashMap<>();

    void add(T body) {
        entries.add(body);
        index.put(body.name().toLowerCase(), body);
    }

    Optional<T> find(String name) {
        return Optional.ofNullable(index.get(name.toLowerCase()));
    }

    List<T> all() { return Collections.unmodifiableList(entries); }

    <R> List<R> map(Function<T, R> fn) {
        return entries.stream().map(fn).collect(Collectors.toList());
    }

    List<T> filter(Predicate<T> predicate) {
        return entries.stream().filter(predicate).collect(Collectors.toList());
    }

    @Override
    public String toString() {
        return "Catalogue{size=%d}".formatted(entries.size());
    }
}

// Main class

@Author(name = "void-space", since = "1.0")
public class Sample {

    private static final String VERSION    = "1.0.0";
    private static final double PI         = Math.PI;
    private static final int    MAX_STARS  = 1_000_000;

    private static final Map<String, String> PALETTE = Map.of(
        "void",   "#0d0f18",
        "nebula", "#c792ea",
        "aurora", "#89ddff",
        "comet",  "#82aaff",
        "pulsar", "#ff5370"
    );

    // Inner class

    static class Star implements CelestialBody {
        private final String  name;
        private final double  massSolar;
        private final double  luminosity;
        private final List<String> tags;
        private int observations = 0;

        Star(String name, double massSolar, double luminosity, String... tags) {
            Objects.requireNonNull(name, "name must not be null");
            if (massSolar <= 0) throw new IllegalArgumentException(
                "massSolar must be positive, got " + massSolar);
            this.name        = name;
            this.massSolar   = massSolar;
            this.luminosity  = luminosity;
            this.tags        = List.of(tags);
        }

        @Override public String name() { return name; }

        SpectralClass spectralClass() { return SpectralClass.of(massSolar); }

        void observe() { observations++; }

        int observationCount() { return observations; }

        @Override
        public String describe() {
            return "%s [class %s, mass=%.2f☉, lum=%.2e☉, obs=%d]"
                .formatted(name, spectralClass(), massSolar, luminosity, observations);
        }

        @Override
        public String toString() { return describe(); }
    }

    // Fibonacci (iterative)

    static List<Long> fibonacci(int n) {
        if (n <= 0) return List.of();
        List<Long> seq = new ArrayList<>(n);
        long a = 0, b = 1;
        for (int i = 0; i < n; i++) {
            seq.add(a);
            long tmp = a + b;
            a = b;
            b = tmp;
        }
        return seq;
    }

    // Concurrency

    static List<String> surveyAll(List<Star> stars) throws InterruptedException, ExecutionException {
        ExecutorService exec = Executors.newVirtualThreadPerTaskExecutor();
        try {
            List<Future<String>> futures = stars.stream()
                .map(star -> exec.submit(() -> {
                    Thread.sleep(10);
                    star.observe();
                    return star.describe();
                }))
                .collect(Collectors.toList());

            List<String> results = new ArrayList<>();
            for (Future<String> f : futures) {
                results.add(f.get());
            }
            return results;
        } finally {
            exec.shutdown();
        }
    }

    // Pattern matching helper

    static String classifyObservation(Observation obs) {
        return switch (obs) {
            case VisualObservation v when v.magnitude() < 0 ->
                "Extremely bright visual target: " + v.target();
            case VisualObservation v ->
                "Visual target: " + v.target() + " (mag " + v.magnitude() + ")";
            case RadioObservation r ->
                "Radio source: " + r.target() + " at " + r.frequencyGHz() + " GHz";
        };
    }

    // main

    public static void main(String[] args) throws Exception {
        System.out.printf("void-space v%s — Pi ≈ %.6f%n", VERSION, PI);
        System.out.printf("MAX_STARS = %,d%n%n", MAX_STARS);

        // Stars
        var sirius     = new Star("Sirius",           2.10,  25.4,   "bright", "binary");
        var betelgeuse = new Star("Betelgeuse",       20.0,  1.0e5,  "red-supergiant");
        var proxima    = new Star("Proxima Centauri", 0.12,  0.0017, "nearest");
        var sol        = new Star("Sol",              1.00,  1.0,    "home");

        var stars = List.of(sirius, betelgeuse, proxima, sol);

        // Catalogue + streams
        var catalogue = new Catalogue<Star>();
        stars.forEach(catalogue::add);

        System.out.println("── Catalogue ──");
        catalogue.all().forEach(System.out::println);
        System.out.println();

        // Stream pipeline
        System.out.println("── Massive stars (mass > 5☉) ──");
        catalogue.filter(s -> s.massSolar > 5)
            .stream()
            .sorted(Comparator.comparingDouble((Star s) -> s.massSolar).reversed())
            .map(Star::describe)
            .forEach(System.out::println);
        System.out.println();

        // Names via map
        List<String> names = catalogue.map(Star::name);
        System.out.println("All names: " + String.join(", ", names));

        // Optional
        catalogue.find("sirius")
            .ifPresentOrElse(
                s -> System.out.println("Found: " + s.name()),
                ()  -> System.out.println("Not found"));

        // Statistics
        DoubleSummaryStatistics stats = stars.stream()
            .mapToDouble(s -> s.massSolar)
            .summaryStatistics();
        System.out.printf("%nMass stats — min=%.2f max=%.2f avg=%.2f%n",
            stats.getMin(), stats.getMax(), stats.getAverage());

        // Fibonacci
        List<Long> fibs = fibonacci(10);
        System.out.println("Fibonacci(10): " + fibs);

        // Concurrent survey
        System.out.println("\n── Survey ──");
        List<String> observations = surveyAll(new ArrayList<>(stars));
        observations.forEach(r -> System.out.println(" > " + r));

        // Records & sealed types
        System.out.println("\n── Observations ──");
        List<Observation> obs = List.of(
            new VisualObservation(Instant.now(), "Sirius",  -1.46),
            new RadioObservation(Instant.now(),  "Cygnus A", 1.415)
        );
        obs.forEach(o -> System.out.println(classifyObservation(o)));

        // Palette
        System.out.println("\n── Palette ──");
        PALETTE.entrySet().stream()
            .sorted(Map.Entry.comparingByKey())
            .forEach(e -> System.out.printf("  %-8s %s%n", e.getKey(), e.getValue()));

        // Lambda & method reference demo
        Predicate<Star> isBright = s -> s.luminosity > 100;
        Function<Star, String> formatter = s ->
            "%-20s class=%s".formatted(s.name(), s.spectralClass());

        System.out.println("\n── Bright stars ──");
        stars.stream()
            .filter(isBright)
            .map(formatter)
            .forEach(System.out::println);

        // Exception handling
        try {
            var bad = new Star("", -1, 0);
        } catch (IllegalArgumentException e) {
            System.out.println("\nCaught: " + e.getMessage());
        }

        ObservationException obsEx = new ObservationException("Ghost", "star not found");
        System.out.println("ObservationException for: " + obsEx.getStarName());

        System.out.printf("%nDone. HOME=%s%n", System.getenv("HOME"));
    }
}
