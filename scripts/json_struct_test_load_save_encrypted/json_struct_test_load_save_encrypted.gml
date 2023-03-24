///@func json_struct_test_load_save_encrypted()
function json_struct_test_load_save_encrypted() {
	var fnames = [working_directory + "test1.xjson", working_directory + "test2.xjson", working_directory + "test3.xjson"];
	var fixture = {goo: ["three", 4, undefined]};
	var conflictFixture = new JsonStruct("goo", ["three", 4, undefined]);
	var customKey = 987654321;
	var caesarEncrypt = function(str, key) {
		var result = "";
		var strlen = string_length(str);
		for (var i = 1; i <= strlen; ++i) {
			result += chr(ord(string_char_at(str, i))+key);
		}
		return result;
	};
	var caesarDecrypt = function(str, key) {
		var result = "";
		var strlen = string_length(str);
		for (var i = 1; i <= strlen; ++i) {
			result += chr(ord(string_char_at(str, i))-key);
		}
		return result;
	};
	var f, line;
	
	//jsons_save_encrypted(fname, thing)
	jsons_save_encrypted(fnames[0], fixture)
	f = file_text_open_read(fnames[0]);
	line = file_text_read_string(f);
	assert_equal(line, jsons_encrypt(fixture));
	file_text_close(f);
	
	//jsons_load_encrypted(fname, thing)
	assert_equal(jsons_load_encrypted(fnames[0]), fixture);
	assert_equal(jsons_load_encrypted_safe(fnames[0]), conflictFixture);
	
	//jsons_save_encrypted(fname, thing, enckey)
	jsons_save_encrypted(fnames[1], fixture, customKey)
	f = file_text_open_read(fnames[1]);
	line = file_text_read_string(f);
	assert_equal(line, jsons_encrypt(fixture, customKey));
	file_text_close(f);
	
	//jsons_load_encrypted(fname, thing, enckey)
	assert_equal(jsons_load_encrypted(fnames[1], customKey), fixture);
	assert_equal(jsons_load_encrypted_safe(fnames[1], customKey), conflictFixture);
	
	//jsons_save_encrypted(fname, thing, enckey, encfunc)
	jsons_save_encrypted(fnames[2], fixture, customKey, caesarEncrypt)
	f = file_text_open_read(fnames[2]);
	line = file_text_read_string(f);
	assert_equal(line, jsons_encrypt(fixture, customKey, caesarEncrypt));
	file_text_close(f);
	
	//jsons_load_encrypted(fname, thing, enckey, encfunc)
	assert_equal(jsons_load_encrypted(fnames[2], customKey, caesarDecrypt), fixture);
	assert_equal(jsons_load_encrypted_safe(fnames[2], customKey, caesarDecrypt), conflictFixture);
}
