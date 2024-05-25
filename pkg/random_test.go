package main

import (
	"testing"

	"neeraj.com/store-feedback/pkg/db"
)

func TestDbConnection(t *testing.T) {
	// Call the function under test
	db.CreateConnection()
}

func TestAdd(t *testing.T) {
	// Test cases
	testCases := []struct {
		name     string
		a, b     int
		expected int
	}{
		{"Positive numbers", 2, 3, 5},
		{"Negative numbers", -2, -3, -5},
		{"Mixed numbers", 2, -3, -1},
		// Add more test cases as needed
	}

	// Iterate over test cases
	for _, tc := range testCases {
		t.Run(tc.name, func(t *testing.T) {
			// Call the function under test
			result := tc.a + tc.b

			// Check if the result matches the expected value
			if result != tc.expected {
				t.Errorf("Unexpected result for %s: got %d, want %d", tc.name, result, tc.expected)
			}
		})
	}
}
