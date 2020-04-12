///@func __jsons_rc4__(@buffer, key, offset, length)
///@param buffer
///@param key
///@param offset
///@param length
function __jsons_rc4__(argument0, argument1, argument2, argument3) {
	var i, j, s, temp, keyLength, pos;
	s = array_create(256);
	keyLength = string_byte_length(argument1);
	for (var i = 255; i >= 0; --i) {
		s[i] = i;
	}
	j = 0;
	for (var i = 0; i <= 255; ++i) {
		j = (j + s[i] + string_byte_at(argument1, i mod keyLength)) mod 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
	}
	i = 0;
	j = 0;
	pos = 0;
	buffer_seek(argument0, buffer_seek_start, argument2);
	repeat (argument3) {
		i = (i+1) mod 256;
		j = (j+s[i]) mod 256;
		temp = s[i];
		s[i] = s[j];
		s[j] = temp;
		var currentByte = buffer_peek(argument0, pos++, buffer_u8);
		buffer_write(argument0, buffer_u8, s[(s[i]+s[j]) mod 256] ^ currentByte);
	}
	return argument0;
}