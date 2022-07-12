package types

type VideoReq struct {
	VideoId string `json:"video_id"`
}

type VideoRes struct {
	Base64Url string               `json:"base64_url"`
	Game      []RelativeModelCoord `json:"model_coord"`
}

type ErrorRes struct {
	Err string `json:"err"`
}

type FFTInput struct {
	XVar []int32
}
