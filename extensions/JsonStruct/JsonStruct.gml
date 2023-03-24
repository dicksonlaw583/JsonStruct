#define jsons_clone
///@func jsons_clone(val)
{
	var cloneResult, siz;
	switch (typeof(argument0)) {
		case "struct":
			if (instanceof(argument0) == "JsonStruct") {
				cloneResult = new JsonStruct();
				var keys = argument0.keys();
				siz = array_length(keys);
				for (var i = 0; i < siz; ++i) {
					var k = keys[i];
					cloneResult.set(k,  jsons_clone(argument0.get(k)));
				}
			} else {
				cloneResult = {};
				var keys = variable_struct_get_names(argument0);
				siz = array_length(keys);
				for (var i = 0; i < siz; ++i) {
					var k = keys[i];
					variable_struct_set(cloneResult, k, jsons_clone(variable_struct_get(argument0, k)));
				}
			}
			return cloneResult;
		break;
		case "array":
			siz = array_length(argument0);
			cloneResult = array_create(siz);
			for (var i = siz-1; i >= 0; --i) {
				cloneResult[i] = jsons_clone(argument0[i]);
			}
			return cloneResult;
		default:
			return argument0;
	}
}

#define jsons_decode
///@func jsons_decode(jsonstr)
///@param jsonstr
///@desc Decode the given JSON string back into GML 2020 native types
{
	// Seek to first active non-space character
	var seekrec = { str: argument0, pos: 0 };
	var c = __jsons_decode_seek__(seekrec);
	// Throw an exception if end of string reached without identifiable content
	if (c == "") throw new JsonStructParseException(seekrec.pos, "Unexpected end of string");
	// Decode to the correct type based on first sniffed character
	return __jsons_decode_subcontent__(seekrec, false);
}

#define jsons_decode_safe
///@func jsons_decode_safe(jsonstr)
///@param jsonstr
///@desc Decode the given JSON string back into GML 2020 native types and JsonStruct structs
{
	// Seek to first active non-space character
	var seekrec = { str: argument0, pos: 0 };
	var c = __jsons_decode_seek__(seekrec);
	// Throw an exception if end of string reached without identifiable content
	if (c == "") throw new JsonStructParseException(seekrec.pos, "Unexpected end of string");
	// Decode to the correct type based on first sniffed character
	return __jsons_decode_subcontent__(seekrec, true);
}

#define jsons_decrypt
///@func jsons_decrypt(jsonencstr, [deckey], [decfunc])
///@param jsonencstr
///@param [deckey]
///@param [decfunc]
{
	var deckey = "theJsonEncryptedKey",
		decfunc = function(v, k) { return __jsons_decrypt__(v, k); };//__jsons_decrypt__;
	switch (argument_count) {
		case 3:
			decfunc = argument[2];
		case 2:
			deckey = argument[1];
		case 1:
			break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
			break;
	}
	return jsons_decode(is_method(decfunc) ? decfunc(argument[0], deckey) : script_execute(decfunc, argument[0], deckey));
}

#define jsons_decrypt_safe
///@func jsons_decrypt_safe(jsonencstr, [deckey], [decfunc])
///@param jsonencstr
///@param [deckey]
///@param [decfunc]
{
	var deckey = "theJsonEncryptedKey",
		decfunc = function(v, k) { return __jsons_decrypt__(v, k); };//__jsons_decrypt__;
	switch (argument_count) {
		case 3:
			decfunc = argument[2];
		case 2:
			deckey = argument[1];
		case 1:
			break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
			break;
	}
	return jsons_decode_safe(is_method(decfunc) ? decfunc(argument[0], deckey) : script_execute(decfunc, argument[0], deckey));
}

#define jsons_encode
///@func jsons_encode(val)
///@param val
///@desc Encode the given value into JSON.
{
	var buffer, result, siz;
	switch (typeof(argument0)) {
		case "number":
			return JSONS_REAL_ENCODER(argument0);
		break;
		case "int64": case "int32":
			return string(argument0);
		break;
		case "string":
			siz = string_length(argument0);
			buffer = buffer_create(32, buffer_grow, 1);
			buffer_write(buffer, buffer_text, @'"');
			for (var i = 1; i <= siz; ++i) {
				var c = string_char_at(argument0, i);
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
			siz = array_length(argument0);
			buffer_write(buffer, buffer_text, "[");
			for (var i = 0; i < siz; ++i) {
				if (i > 0) buffer_write(buffer, buffer_text, ",");
				buffer_write(buffer, buffer_text, jsons_encode(argument0[i]));
			}
			buffer_write(buffer, buffer_string, "]");
		break;
		case "struct":
			buffer = buffer_create(64, buffer_grow, 1);
			var isConflict = instanceof(argument0) == "JsonStruct";
			var keys = isConflict ? argument0.keys() : variable_struct_get_names(argument0);
			siz = array_length(keys);
			buffer_write(buffer, buffer_text, "{");
			for (var i = 0; i < siz; ++i) {
				var k = keys[i];
				if (i > 0) buffer_write(buffer, buffer_text, ",");
				buffer_write(buffer, buffer_text, jsons_encode(k));
				buffer_write(buffer, buffer_text, ":");
				buffer_write(buffer, buffer_text, jsons_encode(isConflict ? argument0.get(k) : variable_struct_get(argument0, k)));
			}
			buffer_write(buffer, buffer_string, "}");
		break;
		case "bool":
			return argument0 ? "true" : "false";
		break;
		case "undefined":
			return "null";
		break;
		default:
			throw new JsonStructTypeException(argument0);
		break;
	}
	// Only strings, arrays and struct to make their way here
	buffer_seek(buffer, buffer_seek_start, 0);
	var result = buffer_read(buffer, buffer_string);
	buffer_delete(buffer);
	return result;
}

#define jsons_encode_formatted
///@func jsons_encode_formatted(val, [indent], [maxDepth], [colon], [comma])
///@param val
///@param [indent]
///@param [maxDepth]
///@param [colon]
///@param [comma]
{
	var val = argument[0];
	var indent = (argument_count > 1) ? argument[1] : JSONS_FORMATTED_INDENT;
	var maxDepth = (argument_count > 2) ? argument[2] : JSONS_FORMATTED_MAX_DEPTH;
	var colon = (argument_count > 3) ? argument[3] : JSONS_FORMATTED_COLON;
	var comma = (argument_count > 4) ? argument[4] : JSONS_FORMATTED_COMMA;
	return __jsons_encode_formatted__(val, indent, 0, maxDepth, colon, comma);
}

#define jsons_encrypt
///@func jsons_encrypt(thing, [enckey], [encfunc])
///@param thing
///@param [enckey]
///@param [encfunc]
{
	var enckey = "theJsonEncryptedKey",
		encfunc = function(v, k) { return __jsons_encrypt__(v, k); };//__jsons_encrypt__;
	switch (argument_count) {
		case 3:
			encfunc = argument[2];
		case 2:
			enckey = argument[1];
		case 1:
			break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
			break;
	}
	return is_method(encfunc) ? encfunc(jsons_encode(argument[0]), enckey) : script_execute(encfunc, jsons_encode(argument[0]), enckey);
}

#define jsons_load
///@func jsons_load(fname)
///@param fname
{
	var f = file_text_open_read(argument0),
		jsonstr = file_text_read_string(f);
	while (!file_text_eof(f)) {
		file_text_readln(f);
		jsonstr += "\n" + file_text_read_string(f);
	}
	file_text_close(f);
	return jsons_decode(jsonstr);
}

#define jsons_load_safe
///@func jsons_load_safe(fname)
///@param fname
{
	var f = file_text_open_read(argument0),
		jsonstr = file_text_read_string(f);
	while (!file_text_eof(f)) {
		file_text_readln(f);
		jsonstr += "\n" + file_text_read_string(f);
	}
	file_text_close(f);
	return jsons_decode_safe(jsonstr);
}

#define jsons_load_encrypted
///@func jsons_load_encrypted(fname, [deckey], [decfunc])
///@param fname
///@param [deckey]
///@param [decfunc]
{
	var deckey = "theJsonEncryptedKey",
		decfunc = function(v, k) { return __jsons_decrypt__(v, k); };//__jsons_decrypt__;
	switch (argument_count) {
		case 3:
			decfunc = argument[2];
		case 2:
			deckey = argument[1];
		case 1:
			break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
			break;
	}
	var f = file_text_open_read(argument[0]),
		jsonstr = file_text_read_string(f);
	while (!file_text_eof(f)) {
		file_text_readln(f);
		jsonstr += "\n" + file_text_read_string(f);
	}
	file_text_close(f);
	return jsons_decrypt(jsonstr, deckey, decfunc);
}

#define jsons_load_encrypted_safe
///@func jsons_load_encrypted_safe(fname, [deckey], [decfunc])
///@param fname
///@param [deckey]
///@param [decfunc]
{
	var deckey = "theJsonEncryptedKey",
		decfunc = function(v, k) { return __jsons_decrypt__(v, k); };//__jsons_decrypt__;
	switch (argument_count) {
		case 3:
			decfunc = argument[2];
		case 2:
			deckey = argument[1];
		case 1:
			break;
		default:
			show_error("Expected 1-3 arguments, got " + string(argument_count) + ".", true);
			break;
	}
	var f = file_text_open_read(argument[0]),
		jsonstr = file_text_read_string(f);
	while (!file_text_eof(f)) {
		file_text_readln(f);
		jsonstr += "\n" + file_text_read_string(f);
	}
	file_text_close(f);
	return jsons_decrypt_safe(jsonstr, deckey, decfunc);
}

#define jsons_real_encoder_detailed
///@func jsons_real_encoder_detailed(val)
///@param val
///@desc Return a detailed string-form encode of the given real value, including scientific notification if not an integer
{
	// Return straight string if it is an integer
	if (frac(argument0) == 0) {
		return string(argument0);
	}

	// Compute scientific notation otherwise
	var mantissa, exponent;
	exponent = floor(log10(abs(argument0)));
	mantissa = string_replace_all(string_format(argument0/power(10,exponent), 15, 14), " ", "");
	var i, ca;
    i = string_length(mantissa);
	do {
		ca = string_char_at(mantissa, i);
		i -= 1;
	} until (ca != "0")
	if (ca != ".") {
		mantissa = string_copy(mantissa, 1, i+1);
	}
	else {
		mantissa = string_copy(mantissa, 1, i);
	}

	// Omit exponent if it is 0
	if (exponent != 0) {
		return mantissa + "e" + string(exponent);
	}
	else {
		return mantissa;
	}
}

#define jsons_real_encoder_string_format
///@func jsons_real_encoder_string_format(val)
///@param val
///@desc Return the given real value in string form, with up to 15 decimal digits if needed
{
	if (frac(argument0) == 0) return string(argument0);
	var result = string_replace_all(string_format(argument0, 30, 15), " ", "");
	var decimalPos = string_pos(".", result);
	for (var i = string_length(result); i > decimalPos && string_char_at(result, i) == "0"; --i) {}
	return string_copy(result, 0, i-(i==decimalPos));
}

#define jsons_save
/// @description jsons_save(fname, thing)
/// @param fname
/// @param thing
{
	var f = file_text_open_write(argument0);
	file_text_write_string(f, jsons_encode(argument1));
	file_text_close(f);
}

#define jsons_save_encrypted
///@func jsons_save_encrypted(fname, thing, [enckey], [encfunc])
///@param fname
///@param thing
///@param [enckey]
///@param [encfunc]
{
	var enckey = "theJsonEncryptedKey",
		encfunc = function(v, k) { return __jsons_encrypt__(v, k); };//__jsons_encrypt__;
	switch (argument_count) {
		case 4:
			encfunc = argument[3];
		case 3:
			enckey = argument[2];
		case 2:
			break;
		default:
			show_error("Expected 2-4 arguments, got " + string(argument_count) + ".", true);
			break;
	}
	var f = file_text_open_write(argument[0]);
	file_text_write_string(f, jsons_encrypt(argument[1], enckey, encfunc));
	file_text_close(f);
}

#define jsons_save_formatted
///@func jsons_save_formatted(fname, val, [indent], [maxDepth], [colon], [comma])
///@param fname
///@param val
///@param [indent]
///@param [maxDepth]
///@param [colon]
///@param [comma]
{
	var val = argument[1];
	var indent = (argument_count > 2) ? argument[2] : JSONS_FORMATTED_INDENT;
	var maxDepth = (argument_count > 3) ? argument[3] : JSONS_FORMATTED_MAX_DEPTH;
	var colon = (argument_count > 4) ? argument[4] : JSONS_FORMATTED_COLON;
	var comma = (argument_count > 5) ? argument[5] : JSONS_FORMATTED_COMMA;
	var output = __jsons_encode_formatted__(val, indent, 0, maxDepth, colon, comma);
	var f = file_text_open_write(argument[0]);
	file_text_write_string(f, output);
	file_text_close(f);
}
