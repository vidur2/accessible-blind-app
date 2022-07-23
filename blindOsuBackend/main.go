package main

import (
	"encoding/json"
	"fmt"
	"os"

	"github.com/joho/godotenv"
	"github.com/valyala/fasthttp"
	"github.com/vidur2/blindOsuBackend/types"
	videogethandler "github.com/vidur2/blindOsuBackend/videoGetHandler"
	videomodelgen "github.com/vidur2/blindOsuBackend/videoModelGen"
)

func handler(ctx *fasthttp.RequestCtx) {
	switch string(ctx.Path()) {
	case "/get_video":
		var req types.VideoReq
		_ = json.Unmarshal(ctx.Request.Body(), &req)

		_ = req.TranslateVideoId()

		res, _ := videogethandler.GetVideo(req)
		videomodelgen.TransposeMp3File()
		game, err := videomodelgen.GenerateCoordPoints()

		if err != nil {
			handleError(ctx, err)
		} else {
			parsed := types.VideoRes{
				Base64Url: res,
				Game:      game,
			}

			final, err := json.Marshal(parsed)

			if err != nil {
				handleError(ctx, err)
			}

			ctx.Response.AppendBody(final)
		}

	case "/get_video_yin":
		var req types.VideoReq

		_ = json.Unmarshal(ctx.Request.Body(), &req)

		req.TranslateVideoId()

		res, _ := videogethandler.GetVideo(req)
		videomodelgen.TransposeMp3File()
		game, err := videomodelgen.YingoUse()

		if err != nil {
			handleError(ctx, err)
		} else {
			parsed := types.VideoResYin{
				PitchCoords: game,
				Base64Url:   res,
			}

			parsed.TranslateToRelative()

			final, err := json.Marshal(parsed)

			if err != nil {
				handleError(ctx, err)
			}
			fmt.Println("thing")
			ctx.Response.AppendBody(final)
		}

	default:
		ctx.Response.SetStatusCode(fasthttp.StatusNotFound)
		ctx.Response.AppendBodyString("Not found")
	}
}

func handleError(ctx *fasthttp.RequestCtx, err error) {
	ctx.Response.SetStatusCode(fasthttp.StatusInternalServerError)
	errRes := types.ErrorRes{
		Err: err.Error(),
	}
	final, _ := json.Marshal(errRes)
	ctx.Response.AppendBody(final)
}

func main() {
	godotenv.Load("./.env")

	fmt.Println("Listening on " + os.Getenv("PORT"))
	err := fasthttp.ListenAndServe(":"+os.Getenv("PORT"), handler)

	if err != nil {
		fmt.Println(err)
	}
}
