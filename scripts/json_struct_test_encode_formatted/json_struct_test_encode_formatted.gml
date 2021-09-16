///@func json_struct_test_encode_formatted()
function json_struct_test_encode_formatted() {
	// Encode numbers
	assert_equal(jsons_encode_formatted(3.25, "  "), "3.25", "jsons_encode_formatted encode number 1");
	assert_equal(jsons_encode_formatted(-2.75, "  "), "-2.75", "jsons_encode_formatted encode number 2");
	assert_equal(jsons_encode_formatted(583, "  "), "583", "jsons_encode_formatted encode number 3");
	assert_equal(jsons_encode_formatted(int64(-583), "  "), "-583", "jsons_encode_formatted encode number 4");
	
	// Encode strings
	assert_equal(jsons_encode_formatted("Hello world!", "  "), @'"Hello world!"', "jsons_encode_formatted encode string 1");
	assert_equal(jsons_encode_formatted("\"\\\n\r\t\v\b\a", "  "), @'"\"\\\n\r\t\v\b\a"', "jsons_encode_formatted encode string 2");
	assert_equal(jsons_encode_formatted("Hello\nworld!", "  "), @'"Hello\nworld!"', "jsons_encode_formatted encode string 3");
	
	// Encode booleans
	assert_equal(jsons_encode_formatted(bool(true), "  "), "true", "jsons_encode_formatted encode true");
	assert_equal(jsons_encode_formatted(bool(false), "  "), "false", "jsons_encode_formatted encode false");
	
	// Encode undefined
	assert_equal(jsons_encode_formatted(undefined, "  "), "null", "jsons_encode_formatted encode undefined");
	
	// Encode arrays
	assert_equal(jsons_encode_formatted([], "  "), "[]", "jsons_encode_formatted encode arrays 1");
	assert_equal(jsons_encode_formatted([999], "  "), "[\n  999\n]", "jsons_encode_formatted encode arrays 2");
	assert_equal(jsons_encode_formatted([3.25, -2.75, "Hello world!", bool(true), undefined], "  "), "[\n  3.25, \n  -2.75, \n  \"Hello world!\", \n  true, \n  null\n]", "jsons_encode_formatted encode arrays 3");

	// Encode structs
	assert_equal(jsons_encode_formatted({}, "    "), "{}", "jsons_encode_formatted encode structs 1");
	assert_equal(jsons_encode_formatted({abc: "def"}, "    "), "{\n    \"abc\": \"def\"\n}", "jsons_encode_formatted encode structs 2");
	assert_equal(jsons_encode_formatted({abc: "def", ghi: 583}, "  "), "{\n  \"abc\": \"def\", \n  \"ghi\": 583\n}", "jsons_encode_formatted encode structs 3");
	
	// Encode structs (conflict mode)
	assert_equal(jsons_encode_formatted(new JsonStruct(), "    "), "{}", "jsons_encode_formatted encode structs (conflict mode) 1");
	assert_equal(jsons_encode_formatted(new JsonStruct("abc", "def"), "    "), "{\n    \"abc\": \"def\"\n}", "jsons_encode_formatted encode structs (conflict mode) 3");
	assert_equal(jsons_encode_formatted(new JsonStruct("abc", "def", "ghi", 583), "  "), "{\n  \"abc\": \"def\", \n  \"ghi\": 583\n}", "jsons_encode_formatted encode structs (conflict mode) 3");
	
	// Encode mixed
	assert_equal(jsons_encode_formatted({foo: [3.25, -2.75, "Hello world!", bool(true), undefined]}, "  "), "{\n  \"foo\": [\n    3.25, \n    -2.75, \n    \"Hello world!\", \n    true, \n    null\n  ]\n}", "jsons_encode_formatted mixed 1");
	assert_equal(jsons_encode_formatted([3, -2, {foo: "bar", goo: "baz"}, bool(false)], "  "), "[\n  3, \n  -2, \n  {\n    \"foo\": \"bar\", \n    \"goo\": \"baz\"\n  }, \n  false\n]", "jsons_encode_formatted mixed 2");
	
	// Encode capped depth
	assert_equal(jsons_encode_formatted([1, [2, [3, [4, [5]]]]], "\t", 2), "[\n\t1, \n\t[\n\t\t2, \n\t\t[3, [4, [5]]]\n\t]\n]", "jsons_encode_formatted encode capped depth 1");
	assert_equal(jsons_encode_formatted({a: {b: {c: {d: { e: 5 }}}}}, "\t", 3), "{\n\t\"a\": {\n\t\t\"b\": {\n\t\t\t\"c\": {\"d\": {\"e\": 5}}\n\t\t}\n\t}\n}", "jsons_encode_formatted encode capped depth 2");

	// Encode unsupported type
	assert_throws_instance_of(function() {
		jsons_encode_formatted(function(a, b) { return a+b; }, "  ");
	}, "JsonStructTypeException", "jsons_encode_formatted unsupported type");
}
