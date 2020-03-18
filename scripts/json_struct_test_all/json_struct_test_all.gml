///@func json_struct_test_all()
function json_struct_test_all() {
	var timeA, time_b;
	timeA = current_time;
	json_struct_test_encode();
	timeB = current_time;
	show_debug_message("JSON Struct tests done in " + string(timeB-timeA) + "ms.");
}
