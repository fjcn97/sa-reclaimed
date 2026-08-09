extends RefCounted
class_name SoundTestPreviewGenerator

const SAMPLE_RATE := 22050
const PREVIEW_SECONDS := 4

static func make_preview(track_number: int, tempo: float) -> AudioStreamWAV:
	var sample_count := SAMPLE_RATE * PREVIEW_SECONDS
	var data := PackedByteArray()
	data.resize(sample_count * 2)
	var beat_hz := maxf(1.0, tempo / 60.0)
	var root_hz := 196.0 * pow(2.0, float(posmod(track_number - 1, 12)) / 12.0)
	for sample_index in range(sample_count):
		var time := float(sample_index) / float(SAMPLE_RATE)
		var beat: float = floor(time * beat_hz)
		var note_index := posmod(int(beat) + track_number, 8)
		var note_hz := root_hz * pow(2.0, float([0, 2, 4, 7, 9, 7, 4, 2][note_index]) / 12.0)
		var phase := time * note_hz * TAU
		var bass := sin(time * root_hz * 0.5 * TAU) * 0.22
		var lead := sin(phase) * 0.26 + sin(phase * 2.0) * 0.08
		var pulse := 0.12 if fmod(time * beat_hz, 1.0) < 0.08 else 0.0
		var envelope := minf(1.0, time * 12.0) * minf(1.0, (float(sample_count) / float(SAMPLE_RATE) - time) * 8.0)
		var sample := clampf((bass + lead + pulse) * envelope, -0.92, 0.92)
		data.encode_s16(sample_index * 2, int(sample * 32767.0))
	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = sample_count
	stream.data = data
	return stream
