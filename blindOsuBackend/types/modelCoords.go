package types

type AbsModelCoord struct {
	AbsolutePitch complex128
	Time          float64
}

func (a *AbsModelCoord) ConvertAbsModelCoord(scale complex128) RelativeModelCoord {
	return RelativeModelCoord{
		RelativePitchX: real(a.AbsolutePitch) / real(scale),
		RelativePitchY: imag(a.AbsolutePitch) / imag(scale),
		Time:           a.Time,
	}
}

type RelativeModelCoord struct {
	RelativePitchX float64 `json:"relative_pitch_x"`
	RelativePitchY float64 `json:"relative_pitch_y"`
	Time           float64 `json:"time"`
}
