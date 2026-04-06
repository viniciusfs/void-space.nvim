// Package main demonstrates Go syntax for void-space.nvim theme validation.
package main

import (
	"context"
	"errors"
	"fmt"
	"math"
	"os"
	"strings"
	"sync"
	"time"
)

// Constants & vars

const (
	Version    = "1.0.0"
	MaxRetries = 3
	Pi         = math.Pi
)

var (
	ErrNotFound  = errors.New("not found")
	ErrInvalidID = errors.New("invalid id")
)

// Types & interfaces

type SpectralClass string

const (
	ClassO SpectralClass = "O"
	ClassB SpectralClass = "B"
	ClassA SpectralClass = "A"
	ClassF SpectralClass = "F"
	ClassG SpectralClass = "G"
	ClassK SpectralClass = "K"
	ClassM SpectralClass = "M"
)

// CelestialBody is implemented by anything that can be described.
type CelestialBody interface {
	Name() string
	Describe() string
}

// Struct with methods

// Star represents a stellar object.
type Star struct {
	name        string
	massSolar   float64 // in solar masses
	luminosity  float64 // in solar luminosities
	tags        []string
	mu          sync.Mutex
	observations int
}

// NewStar constructs a Star, returning an error on invalid input.
func NewStar(name string, mass, luminosity float64) (*Star, error) {
	if strings.TrimSpace(name) == "" {
		return nil, fmt.Errorf("star name cannot be empty")
	}
	if mass <= 0 {
		return nil, fmt.Errorf("%w: mass=%.2f", ErrInvalidID, mass)
	}
	return &Star{name: name, massSolar: mass, luminosity: luminosity}, nil
}

func (s *Star) Name() string { return s.name }

func (s *Star) SpectralClass() SpectralClass {
	switch {
	case s.massSolar >= 16:
		return ClassO
	case s.massSolar >= 2.1:
		return ClassB
	case s.massSolar >= 1.4:
		return ClassA
	case s.massSolar >= 1.04:
		return ClassF
	case s.massSolar >= 0.8:
		return ClassG
	case s.massSolar >= 0.45:
		return ClassK
	default:
		return ClassM
	}
}

func (s *Star) Describe() string {
	return fmt.Sprintf("%s [class %s, mass=%.2f☉, lum=%.2e☉]",
		s.name, s.SpectralClass(), s.massSolar, s.luminosity)
}

func (s *Star) Observe() {
	s.mu.Lock()
	defer s.mu.Unlock()
	s.observations++
}

// Generics

// Map applies fn to every element of slice and returns the results.
func Map[T, U any](slice []T, fn func(T) U) []U {
	out := make([]U, len(slice))
	for i, v := range slice {
		out[i] = fn(v)
	}
	return out
}

// Filter returns elements for which predicate returns true.
func Filter[T any](slice []T, predicate func(T) bool) []T {
	var out []T
	for _, v := range slice {
		if predicate(v) {
			out = append(out, v)
		}
	}
	return out
}

// Error wrapping

type ObservationError struct {
	StarName string
	Err      error
}

func (e *ObservationError) Error() string {
	return fmt.Sprintf("observation of %q failed: %v", e.StarName, e.Err)
}

func (e *ObservationError) Unwrap() error { return e.Err }

// Goroutines & channels

// surveyStar sends the description of a star into ch, honouring ctx cancellation.
func surveyStar(ctx context.Context, s *Star, ch chan<- string, wg *sync.WaitGroup) {
	defer wg.Done()
	select {
	case <-ctx.Done():
		return
	case <-time.After(10 * time.Millisecond):
		s.Observe()
		ch <- s.Describe()
	}
}

// SurveyAll concurrently surveys all stars and collects results.
func SurveyAll(ctx context.Context, stars []*Star) []string {
	ch := make(chan string, len(stars))
	var wg sync.WaitGroup

	for _, s := range stars {
		wg.Add(1)
		go surveyStar(ctx, s, ch, &wg)
	}

	wg.Wait()
	close(ch)

	var results []string
	for r := range ch {
		results = append(results, r)
	}
	return results
}

// Closures

func makeCounter(start int) func() int {
	n := start
	return func() int {
		n++
		return n
	}
}

// Fibonacci (recursive + memoised)

func fibonacci(n int, memo map[int]int) int {
	if n <= 1 {
		return n
	}
	if v, ok := memo[n]; ok {
		return v
	}
	memo[n] = fibonacci(n-1, memo) + fibonacci(n-2, memo)
	return memo[n]
}

// Palette (map literal)

var palette = map[string]string{
	"void":   "#0d0f18",
	"nebula": "#c792ea",
	"aurora": "#89ddff",
	"comet":  "#82aaff",
	"pulsar": "#ff5370",
}

// main

func main() {
	fmt.Printf("void-space v%s — Pi ≈ %.6f\n", Version, Pi)

	sirius, err := NewStar("Sirius", 2.10, 25.4)
	if err != nil {
		fmt.Fprintf(os.Stderr, "error: %v\n", err)
		os.Exit(1)
	}
	sirius.tags = []string{"bright", "binary", "nearby"}

	betelgeuse, _ := NewStar("Betelgeuse", 20.0, 1e5)
	proxima, _    := NewStar("Proxima Centauri", 0.12, 0.0017)

	stars := []*Star{sirius, betelgeuse, proxima}

	// Print each star
	for _, s := range stars {
		fmt.Println(s.Describe())
	}

	// Generic map/filter
	names   := Map(stars, func(s *Star) string { return s.Name() })
	massive := Filter(stars, func(s *Star) bool { return s.massSolar > 5 })

	fmt.Printf("All names: %v\n", strings.Join(names, ", "))
	fmt.Printf("Massive stars: %d\n", len(massive))

	// Concurrent survey
	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()

	results := SurveyAll(ctx, stars)
	for _, r := range results {
		fmt.Println(" >", r)
	}

	// Closure counter
	next := makeCounter(0)
	for range 5 {
		fmt.Printf("tick %d\n", next())
	}

	// Fibonacci
	memo := make(map[int]int)
	for i := range 10 {
		fmt.Printf("fib(%d)=%d  ", i, fibonacci(i, memo))
	}
	fmt.Println()

	// Palette
	for k, v := range palette {
		fmt.Printf("  %-8s %s\n", k, v)
	}

	// Type assertion & switch
	bodies := []CelestialBody{sirius, betelgeuse}
	for _, b := range bodies {
		switch v := b.(type) {
		case *Star:
			fmt.Printf("Star %q has %d observations\n", v.Name(), v.observations)
		default:
			fmt.Printf("Unknown body: %T\n", v)
		}
	}

	// Multi-return & error check
	_, badErr := NewStar("", -1, 0)
	var obsErr *ObservationError
	wrappedErr := &ObservationError{StarName: "Ghost", Err: ErrNotFound}
	fmt.Println("bad star:", badErr)
	fmt.Println("wrapped:", wrappedErr)
	fmt.Println("is NotFound?", errors.Is(wrappedErr, ErrNotFound))
	fmt.Println("as ObsErr?", errors.As(wrappedErr, &obsErr))

	// Deferred + slice ops
	numbers := []int{3, 1, 4, 1, 5, 9, 2, 6, 5, 3}
	sum := 0
	for _, n := range numbers {
		sum += n
	}
	fmt.Printf("sum(%v) = %d\n", numbers, sum)

	fmt.Printf("HOME=%s\n", os.Getenv("HOME"))
}
