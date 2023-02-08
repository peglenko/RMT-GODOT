@tool
class_name FunctionTask
extends RefCounted


signal task_finished(result)

signal function_executed(response, result)

signal task_error(code, status, message)

var data : Dictionary
var error : Dictionary

var _response_headers : PackedStringArray
var _response_code : int = 0

var _method := -1
var _url : String
var _fields : String
var _headers : PackedStringArray


func _on_request_completed(result : int, response_code : int, headers : PackedStringArray, body : PackedByteArray) -> void:
	var bod
	if JSON.parse_string(body.get_string_from_utf8()) != null:
		bod = JSON.parse_string(body.get_string_from_utf8())
	else:
		bod = {content = body.get_string_from_utf8()}
	
	data = bod
	if response_code == HTTPClient.RESPONSE_OK and data != null:
		function_executed.emit(result, data)
	else:
		error = {result=result, response_code = response_code, data=data}
		task_error.emit(result, response_code, str(data))
	task_finished.emit(data)
