return {
	s("redirect", {
		t({
			"[Options]",
			"location: true",
			"HTTP 200",
		}),
	}),

	s("header", {
		t({
			'Authorization: "Bearer token"',
		}),
	}),

	s("queryparams", {
		t({
			"[QueryStringParams]",
			"id: 42",
			"order_by: date",
		}),
	}),

	s("cookies", {
		t({
			"[Cookies]",
			"session_id: ASDFASDF",
		}),
	}),

	s("formparams", {
		t({
			"[FormParams]",
			"email: alice@rabbit.com",
			"password: cobalt_velvet",
		}),
	}),

	s("multiform", {
		t({
			"[MultipartFormData]",
			"name: jane doe",
			"contacts: file,contacts.csv; text/csv # ft optional",
		}),
	}),

	s("file", {
		t({
			"[MultipartFormData]",
			"file: file,data.csv; text/csv # ft optional",
		}),
	}),

	s("var", {
		t({
			"[Options]",
			"variable: something=else"
		})
	}),

	s("options", {
		t({
			"[Options]",
			"cacert: /etc/cert.pem   # a custom certificate file",
			"compressed: true        # request a compressed response",
			"insecure: true          # allows insecure SSL connections and transfers",
			"location: true          # follow redirection for this request",
			"max-redirs: 10          # maximum number of redirections",
			"path-as-is: true        # tell curl to not handle sequences of /../ or /./ in the given URL path",
			"variable: country=Italy # define variable country",
			"variable: planet=Earth  # define variable planet",
			"verbose: true           # allow verbose output",
			"very-verbose: true      # allow more verbose output",
		}),
	}),

	s("captures", {
		t({
			"GET https://www.example.org",
			"HTTP 200",
			"[Captures]",
			"csrf_token: xpath \"normalize-space(//meta[@name='_csrf_token']/@content)\"",
			'session-id: cookie "LSID"',
			'next_url: header "Location"',
			"resp_body: body",
			"# you can use captured values in subsequent requests",
			"POST https://www.example.org/login",
			"X-CSRF-TOKEN: {{csrf_token}}",
			"HTTP 302",
		}),
	}),

	s("assertcode", {
		t({
			"HTTP 200",
		}),
	}),

	s("assertstatus", {
		t({
			"[Asserts]",
			"status > 400",
		}),
	}),

	s("assertheader", {
		t({
			"[Asserts]",
			'header "content-type" contains "utf-8"',
		}),
	}),

	s("assertcookie", {
		t({
			"[Asserts]",
			'cookie "LSDI" == "DQAAAKEaem_vYg"',
		}),
	}),

	s("assertbody", {
		t({
			"[Asserts]",
			'body contains "happy new year!"',
		}),
	}),

	s("assertcount", {
		t({
			"[Asserts]",
			'jsonpath "$.cats" count == 42',
		}),
	}),

	s("assertequal", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].name" == "Felix"',
			'jsonpath "$.cats[0].lives" == 9',
		}),
	}),

	s("assertempty", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].pet" isEmpty',
		}),
	}),

	s("assertcollection", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].pets" isCollection',
		}),
	}),

	s("assertboolean", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].hasPet" isBoolean',
			'jsonpath "$.cats[0].hasPet" == true',
		}),
	}),

	s("assertdate", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].bornOn" isDate',
		}),
	}),

	s("assertfloat", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].age" not isFloat',
		}),
	}),

	s("assertinteger", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].age" isInteger',
		}),
	}),

	s("assertstring", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].age" not isString',
		}),
	}),

	s("assertexists", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].bestFriend" exists',
		}),
	}),

	s("assertmatches", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].bestFriend" matches /[a-zA-Z]+/',
		}),
	}),

	s("assertcontains", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].owner" contains "bob"',
		}),
	}),

	s("assertendswith", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].bestFriend" endsWith "ice"',
		}),
	}),

	s("assertstartswith", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].bestFriend" startsWith "al"',
		}),
	}),

	s("assertincludes", {
		t({
			"[Asserts]",
			'jsonpath "$.cats[0].pets" includes "lucy"',
		}),
	}),

	s("get", {
		t("GET http://localhost:"),
		i(1, "3000"),
	}),

	s("post", {
		t("POST http://localhost:"),
		i(1, "3000"),
	}),

	s("put", {
		t("PUT http://localhost:"),
		i(1, "3000"),
	}),

	s("patch", {
		t("PATCH http://localhost:"),
		i(1, "3000"),
	}),

	s("delete", {
		t("DELETE http://localhost:"),
		i(1, "3000"),
	}),

	s("inlinevar", {
		t({
			"[Options]",
			"variable: country=Italy",
		}),
	}),

	s("statusok", {
		t("HTTP 200"),
	}),

	s("statuscreated", {
		t("HTTP 201"),
	}),

	s("statusnocontent", {
		t("HTTP 201"),
	}),
}, {}
