package db

import (
	"context"
	"fmt"

	"github.com/jackc/pgx/v4"
)

func CreateConnection() (*pgx.Conn, error) {
	ctx := context.Background()
	conn, err := pgx.Connect(ctx, "postgres://neeraj:neeraj@localhost:5555/neeraj?sslmode=disable&search_path=neeraj")
	if err != nil {
		fmt.Println("Unable to connect to the database:", err)
		return nil, err
	}
	return conn, nil
}
