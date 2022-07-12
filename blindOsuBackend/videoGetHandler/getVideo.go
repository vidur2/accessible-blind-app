package videogethandler

import (
	"bytes"
	"encoding/base64"
	"encoding/json"
	"fmt"
	"io"
	"io/ioutil"
	"os"
	"strings"

	"github.com/kkdai/youtube/v2"
	"github.com/vidur2/blindOsuBackend/types"
)

func GetVideo(v types.VideoReq) (string, error) {
	ytdlClient := youtube.Client{}

	video, err := ytdlClient.GetVideo(v.VideoId)

	if err != nil {
		return "", err
	}

	formats := video.Formats.WithAudioChannels()

	passed := false

	var stream io.ReadCloser

	for idx, format := range formats {
		fmt.Println(format.MimeType)
		if strings.Contains(format.MimeType, "audio/mp4") {
			stream, _, err = ytdlClient.GetStream(video, &formats[idx])
			passed = true
		}
	}

	if !passed {
		fmt.Println("Bad")
		return "", fmt.Errorf("format error: Could not find format")
	}

	if err != nil {
		return "", err
	}

	converted, buf := convertToBuffer(stream)

	file, err := os.Create("audio.mp3")

	if err != nil {
		panic(err)
	}

	defer file.Close()
	_, err = io.Copy(file, &buf)

	if err != nil {
		panic(err)
	}

	retVal := types.VideoRes{
		Base64Url: converted,
	}

	final, err := json.Marshal(retVal)

	if err != nil {
		return "", err
	}

	return string(final), nil
}

func convertToBuffer(s io.ReadCloser) (string, bytes.Buffer) {
	buf := new(bytes.Buffer)

	tee := io.TeeReader(s, buf)
	ioutil.ReadAll(tee)

	data := buf.Bytes()
	retStr := base64.StdEncoding.EncodeToString(data)

	return retStr, *buf
}
