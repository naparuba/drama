extends Node

const END_VALUE = 1



var _is_active = false
var _time_start
var _duration_ms
var _start_value


func start(duration = 0.1, strength = 0.9):
	if self._is_active:
		return
	self._time_start = OS.get_ticks_msec()
	self._duration_ms = duration * 1000
	self._start_value = 1 - strength
	Engine.time_scale = self._start_value
	self._is_active = true
	
	
func _process(delta):
	if not self._is_active:
		return
	var current_time = OS.get_ticks_msec() - self._time_start
	var value = circle_ease_in(current_time, self._start_value, END_VALUE, self._duration_ms)
	if current_time >= self._duration_ms:
		self._is_active = false
		value = END_VALUE
	Engine.time_scale = value
	
# t : current_time
# b : start_value
# c : end_value
# d : duration
func circle_ease_in(t, b, c ,d):
	t /= d
	return -c * (sqrt(1 - t * t) - 1) + b
	
	
