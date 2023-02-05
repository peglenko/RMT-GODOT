extends Node

var webApiKey = "AIzaSyCiK4WUGbUSNksljo3Lmrm_RfstaMB02Jk"
var signupUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key="
var loginUrl = "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key="

# LOGIN AND SIGNUP
func _loginSignup(url: String, email: String, password: String):
	var http = $HTTPRequest
	var jsonObject = JSON.new()
	var body = jsonObject.stringify({"email":email,"password":password})
	var headers = ["Content-Type: application/json"]
	var error = await http.request(url, headers, false, HTTPClient.METHOD_POST,body)


func _on_http_request_request_completed(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	
	if response_code==200:
		Global.email = response.email
		get_tree().change_scene_to_file("res://world.tscn")
	else:
		print(response.error)
		$CanvasLayer/MainMenu/MarginContainer/VBoxContainer/Error.text = response.error.message


func _on_signup_pressed():
	var url = signupUrl + webApiKey
	var email = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/LineEdit.text
	var password = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/LineEdit2.text
	_loginSignup(url, email, password)	


func _on_login_pressed():
	var url = loginUrl + webApiKey
	var email = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/LineEdit.text
	var password = $CanvasLayer/MainMenu/MarginContainer/VBoxContainer/LineEdit2.text
	_loginSignup(url, email, password)	
