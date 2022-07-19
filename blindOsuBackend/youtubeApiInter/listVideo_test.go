package youtubeapiinter

import (
	"fmt"
	"testing"

	"github.com/joho/godotenv"
)

func TestList(t *testing.T) {
	godotenv.Load("../.env")
	id, _ := GetVideoUrl("test")
	fmt.Println(id)
}
