///@func jsons_encode_formatted(val, <indent>, <max_depth>, <colon>, <comma>)
function jsons_encode_formatted() {
	var val = argument[0];
	var indent = (argument_count > 1) ? argument[1] : JSONS_FORMATTED_INDENT;
	var max_depth = (argument_count > 2) ? argument[2] : JSONS_FORMATTED_MAX_DEPTH;
	var colon = (argument_count > 3) ? argument[3] : JSONS_FORMATTED_COLON;
	var comma = (argument_count > 4) ? argument[4] : JSONS_FORMATTED_COMMA;
	return __jsons_encode_formatted__(val, indent, 0, max_depth, colon, comma);
}

function __jsons_encode_formatted__(val, indent, current_depth, max_depth, colon, comma) {
	var buffer, result, siz;
	var currentIndent = "";
	var fullIndent = "";
	if (current_depth < max_depth) {
		currentIndent = "\n" + string_repeat(indent, current_depth);
		fullIndent = currentIndent + indent;
	}
	switch (typeof(val)) {
		case "number":
			return JSONS_REAL_ENCODER(val);
		break;
		case "int64": case "int32":
			return string(val);
		break;
		case "string":
			siz = string_length(val);
			buffer = buffer_create(32, buffer_grow, 1);
			buffer_write(buffer, buffer_text, @'"');
			for (var i = 1; i <= siz; ++i) {
				var c = string_char_at(val, i);
				switch (ord(c)) {
					case ord("\""): //"
						c = @'\"';
					break;
					case ord("\n"): //\n
						c = @'\n';
					break;
					case ord("\r"): //\r
						c = @'\r';
					break;
					case ord("\\"): //\
						c = @'\\';
					break;
					case ord("\t"): //\t
						c = @'\t';
					break;
					case ord("\v"): //\v
						c = @'\v';
					break;
					case ord("\b"): //\b
						c = @'\b';
					break;
					case ord("\a"): //\a
						c = @'\a';
					break;
				}
				buffer_write(buffer, buffer_text, c);
			}
			buffer_write(buffer, buffer_string, @'"');
		break;
		case "array":
			buffer = buffer_create(64, buffer_grow, 1);
			siz = array_length(val);
			buffer_write(buffer, buffer_text, "[");
			for (var i = 0; i < siz; ++i) {
				if (i > 0) buffer_write(buffer, buffer_text, comma);
				buffer_write(buffer, buffer_text, fullIndent);
				buffer_write(buffer, buffer_text, __jsons_encode_formatted__(val[i], indent, current_depth+1, max_depth, colon, comma));
			}
			if (siz > 0) buffer_write(buffer, buffer_text, currentIndent);
			buffer_write(buffer, buffer_string, "]");
		break;
		case "struct":
			buffer = buffer_create(64, buffer_grow, 1);
			var isConflict = instanceof(val) == "JsonStruct";
			var keys = isConflict ? val.keys() : variable_struct_get_names(val);
			siz = array_length(keys);
			array_sort(keys, true);
			buffer_write(buffer, buffer_text, "{");
			for (var i = 0; i < siz; ++i) {
				var k = keys[i];
				if (i > 0) buffer_write(buffer, buffer_text, comma);
				buffer_write(buffer, buffer_text, fullIndent);
				buffer_write(buffer, buffer_text, jsons_encode(k));
				buffer_write(buffer, buffer_text, colon);
				buffer_write(buffer, buffer_text, __jsons_encode_formatted__(isConflict ? val.get(k) : variable_struct_get(val, k), indent, current_depth+1, max_depth, colon, comma));
			}
			if (siz > 0) buffer_write(buffer, buffer_text, currentIndent);
			buffer_write(buffer, buffer_string, "}");
		break;
		case "bool":
			return val ? "true" : "false";
		break;
		case "undefined":
			return "null";
		break;
		default:
			throw new JsonStructTypeException(val);
		break;
	}
	// Only strings, arrays and struct to make their way here
	buffer_seek(buffer, buffer_seek_start, 0);
	var result = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
	return result;
}
