///@func json_struct_test_all()
function json_struct_test_all() {
	var timeA, timeB;
	timeA = current_time;
	json_struct_test_encode();
	json_struct_test_real_encoders();
	timeB = current_time;
	show_debug_message("JSON Struct tests done in " + string(timeB-timeA) + "ms.");
}
