package api

import (
	"context"
	"fmt"

	"neeraj.com/store-feedback/pkg/pb"
)

type StoreFeedbackServer struct {
	message string
}

func (s *StoreFeedbackServer) GetAllFeedbacks(ctx context.Context, in *pb.GetAllFeedbacksRequest) (*pb.GetAllFeedbacksResponse, error) {
	fmt.Println("xoxox")
	return &pb.GetAllFeedbacksResponse{}, nil
}
