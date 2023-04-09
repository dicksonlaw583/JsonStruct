///@func json_struct_test_load_save_formatted()
function json_struct_test_load_save_formatted() {
	var fname = working_directory + "test.json";
	var fixture = {foo: [3, "four", undefined]};
	var conflictFixture = new JsonStruct("foo", [3, "four", undefined]);
	var f;
	
	// jsons_save_formatted(fname, thing)
	jsons_save_formatted(fname, fixture);
	var fileBody = "";
	for (f = file_text_open_read(fname); !file_text_eof(f); file_text_readln(f)) {
		fileBody += file_text_read_string(f) + "\n";
	}
	fileBody = string_copy(fileBody, 1, string_length(fileBody)-1);
	file_text_close(f);
	assert_not_equal(fileBody, jsons_encode(fixture));
	assert_equal(fileBody, jsons_encode_formatted(fixture));
	
	// jsons_load(fname)
	assert_equal(jsons_load(fname), fixture);
	
	// jsons_load(fname) with conflict mode
	assert_equal(jsons_load_safe(fname), conflictFixture);
	
	// Cleanup
	file_delete(fname);
}
