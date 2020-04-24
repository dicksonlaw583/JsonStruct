# JSON Struct

## Overview

This library allows encoding and decoding JSON as structs, arrays and other first-order data types as of GMS 2.3.

## Requirements

- GameMaker Studio 2.3 Open Beta

## Installation

Get the current beta asset package and associated documentation from [the releases page](https://github.com/dicksonlaw583/JsonStruct/releases).

## Limitations

- Only the following types are supported (the `thing` placeholder type):
	- String
	- Number
	- Array
	- Struct
	- Undefined
	- Boolean
- Structs built using constructors and the `new` operator will not retain their `instanceof()` type.
- Circular references are not supported, and will crash if given as input.

## Contributing to JSON Struct

- Clone this repository.
- Open the project in GameMaker Studio 2.3 and make your additions/changes to the `JsonStruct` extension. Also add the corresponding tests to the `JsonStructTest` group.
- Open a pull request [here](https://github.com/dicksonlaw583/JsonStruct/issues).