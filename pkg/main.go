package main

import (
	"context"
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"

	"neeraj.com/store-feedback/pkg/db"
)

func handler(w http.ResponseWriter, r *http.Request) {
	body, err := ioutil.ReadAll(r.Body)
	if err != nil {
		fmt.Println(fmt.Errorf("error reading request body: %v", err))
	}
	var feedback db.Feedback
	json.Unmarshal(body, &feedback)
	conn, err := db.CreateConnection()
	if err != nil {
		fmt.Println("Error connecting to the database:", err)
		return
	}
	dbq := db.New(conn)
	insertedFeedback, err := dbq.InsertFeedback(context.Background(), feedback.Message)
	if err != nil {
		fmt.Println(fmt.Errorf("error inserting feedback: %v", err))
	} else {
		fmt.Println("Inserted feedback:", insertedFeedback)
	}
	w.Write([]byte(fmt.Sprintf("Feedback received!%v", feedback.Message)))
	defer conn.Close(context.Background())
}

func main() {
	http.HandleFunc("/", handler)
	fmt.Println("Server listening on port 6543...")
	http.ListenAndServe(":6543", nil)
}
