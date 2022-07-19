package youtubeapiinter

import (
	"fmt"
	"testing"

	"github.com/joho/godotenv"
)

func TestList(t *testing.T) {
	godotenv.Load("../.env")
	id, _ := GetVideoUrl(`pray%20for%20em`)
	fmt.Println(id)
}
