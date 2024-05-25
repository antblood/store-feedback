package main

import (
	"context"
	"testing"

	"github.com/stretchr/testify/assert"
	"neeraj.com/store-feedback/pkg/db"
)

func TestDbConnection(t *testing.T) {
	// Call the function under test
	dbc, err := db.CreateConnection()
	assert.NoError(t, err)
	dbq := db.New(dbc)
	objs1, err := dbq.GetAllFeedbacks(context.Background())
	assert.NoError(t, err)
	_, err = dbq.InsertFeedback(context.Background(), "Test feedback")
	assert.NoError(t, err)
	objs2, err := dbq.GetAllFeedbacks(context.Background())
	assert.NoError(t, err)
	assert.Equal(t, 1, len(objs2)-len(objs1))
	err = dbq.DeleteAllFeedbacks(context.Background())
	assert.NoError(t, err)
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
