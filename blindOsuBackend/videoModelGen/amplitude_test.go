package videomodelgen

import (
	"fmt"
	"testing"
)

func TestFrequency(t *testing.T) {
	err := TransposeMp3File()
	if err != nil {
		panic(err)
	}
	ans, err := GenerateCoordPoints()

	if err != nil {
		fmt.Println(err.Error())
	}

	fmt.Println(len(ans))
}
