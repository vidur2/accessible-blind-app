package youtubeapiinter

import (
	"fmt"
	"os"
	"strings"

	"github.com/valyala/fasthttp"
	"github.com/vidur2/blindOsuBackend/util"
)

const BASE_URL = "https://www.googleapis.com/youtube/v3/search?key=%v&q=%v&maxResults=1"

func GetVideoUrl(title string) (string, error) {
	reqUrl := fmt.Sprintf(BASE_URL, os.Getenv("KEY"), title)
	client := util.GetClient()
	req := fasthttp.AcquireRequest()
	res := fasthttp.AcquireResponse()

	req.SetRequestURI(reqUrl)

	err := client.Do(req, res)

	if err != nil {
		return "", err
	}

	strResp := string(res.Body())

	videoId := strings.Split(strings.Split(strResp, "\"videoId\":")[1], "\"")[1]

	fmt.Println(videoId)

	return videoId, nil
}
