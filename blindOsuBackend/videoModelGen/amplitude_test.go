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
	ans, err := YingoUse()

	if err != nil {
		fmt.Println(err.Error())
	}

	for _, t := range ans {
		fmt.Println(t)
	}
}
