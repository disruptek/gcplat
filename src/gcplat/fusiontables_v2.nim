
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Fusion Tables
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for working with Fusion Tables data.
## 
## https://developers.google.com/fusiontables
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_578355 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578355](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578355): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "fusiontables"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FusiontablesQuerySql_578896 = ref object of OpenApiRestCall_578355
proc url_FusiontablesQuerySql_578898(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesQuerySql_578897(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes a Fusion Tables SQL statement, which can be any of 
  ## - SELECT
  ## - INSERT
  ## - UPDATE
  ## - DELETE
  ## - SHOW
  ## - DESCRIBE
  ## - CREATE statement.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   typed: JBool
  ##        : Whether typed values are returned in the (JSON) response: numbers for numeric values and parsed geometries for KML values. Default is true.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hdrs: JBool
  ##       : Whether column names are included in the first row. Default is true.
  ##   sql: JString (required)
  ##      : A Fusion Tables SQL statement, which can be any of 
  ## - SELECT
  ## - INSERT
  ## - UPDATE
  ## - DELETE
  ## - SHOW
  ## - DESCRIBE
  ## - CREATE
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578899 = query.getOrDefault("key")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "key", valid_578899
  var valid_578900 = query.getOrDefault("prettyPrint")
  valid_578900 = validateParameter(valid_578900, JBool, required = false,
                                 default = newJBool(true))
  if valid_578900 != nil:
    section.add "prettyPrint", valid_578900
  var valid_578901 = query.getOrDefault("oauth_token")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "oauth_token", valid_578901
  var valid_578902 = query.getOrDefault("typed")
  valid_578902 = validateParameter(valid_578902, JBool, required = false, default = nil)
  if valid_578902 != nil:
    section.add "typed", valid_578902
  var valid_578903 = query.getOrDefault("alt")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = newJString("json"))
  if valid_578903 != nil:
    section.add "alt", valid_578903
  var valid_578904 = query.getOrDefault("userIp")
  valid_578904 = validateParameter(valid_578904, JString, required = false,
                                 default = nil)
  if valid_578904 != nil:
    section.add "userIp", valid_578904
  var valid_578905 = query.getOrDefault("quotaUser")
  valid_578905 = validateParameter(valid_578905, JString, required = false,
                                 default = nil)
  if valid_578905 != nil:
    section.add "quotaUser", valid_578905
  var valid_578906 = query.getOrDefault("hdrs")
  valid_578906 = validateParameter(valid_578906, JBool, required = false, default = nil)
  if valid_578906 != nil:
    section.add "hdrs", valid_578906
  assert query != nil, "query argument is necessary due to required `sql` field"
  var valid_578907 = query.getOrDefault("sql")
  valid_578907 = validateParameter(valid_578907, JString, required = true,
                                 default = nil)
  if valid_578907 != nil:
    section.add "sql", valid_578907
  var valid_578908 = query.getOrDefault("fields")
  valid_578908 = validateParameter(valid_578908, JString, required = false,
                                 default = nil)
  if valid_578908 != nil:
    section.add "fields", valid_578908
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578909: Call_FusiontablesQuerySql_578896; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes a Fusion Tables SQL statement, which can be any of 
  ## - SELECT
  ## - INSERT
  ## - UPDATE
  ## - DELETE
  ## - SHOW
  ## - DESCRIBE
  ## - CREATE statement.
  ## 
  let valid = call_578909.validator(path, query, header, formData, body)
  let scheme = call_578909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578909.url(scheme.get, call_578909.host, call_578909.base,
                         call_578909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578909, url, valid)

proc call*(call_578910: Call_FusiontablesQuerySql_578896; sql: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          typed: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; hdrs: bool = false; fields: string = ""): Recallable =
  ## fusiontablesQuerySql
  ## Executes a Fusion Tables SQL statement, which can be any of 
  ## - SELECT
  ## - INSERT
  ## - UPDATE
  ## - DELETE
  ## - SHOW
  ## - DESCRIBE
  ## - CREATE statement.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   typed: bool
  ##        : Whether typed values are returned in the (JSON) response: numbers for numeric values and parsed geometries for KML values. Default is true.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hdrs: bool
  ##       : Whether column names are included in the first row. Default is true.
  ##   sql: string (required)
  ##      : A Fusion Tables SQL statement, which can be any of 
  ## - SELECT
  ## - INSERT
  ## - UPDATE
  ## - DELETE
  ## - SHOW
  ## - DESCRIBE
  ## - CREATE
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578911 = newJObject()
  add(query_578911, "key", newJString(key))
  add(query_578911, "prettyPrint", newJBool(prettyPrint))
  add(query_578911, "oauth_token", newJString(oauthToken))
  add(query_578911, "typed", newJBool(typed))
  add(query_578911, "alt", newJString(alt))
  add(query_578911, "userIp", newJString(userIp))
  add(query_578911, "quotaUser", newJString(quotaUser))
  add(query_578911, "hdrs", newJBool(hdrs))
  add(query_578911, "sql", newJString(sql))
  add(query_578911, "fields", newJString(fields))
  result = call_578910.call(nil, query_578911, nil, nil, nil)

var fusiontablesQuerySql* = Call_FusiontablesQuerySql_578896(
    name: "fusiontablesQuerySql", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_FusiontablesQuerySql_578897, base: "/fusiontables/v2",
    url: url_FusiontablesQuerySql_578898, schemes: {Scheme.Https})
type
  Call_FusiontablesQuerySqlGet_578625 = ref object of OpenApiRestCall_578355
proc url_FusiontablesQuerySqlGet_578627(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesQuerySqlGet_578626(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes a SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   typed: JBool
  ##        : Whether typed values are returned in the (JSON) response: numbers for numeric values and parsed geometries for KML values. Default is true.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hdrs: JBool
  ##       : Whether column names are included (in the first row). Default is true.
  ##   sql: JString (required)
  ##      : A SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578739 = query.getOrDefault("key")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = nil)
  if valid_578739 != nil:
    section.add "key", valid_578739
  var valid_578753 = query.getOrDefault("prettyPrint")
  valid_578753 = validateParameter(valid_578753, JBool, required = false,
                                 default = newJBool(true))
  if valid_578753 != nil:
    section.add "prettyPrint", valid_578753
  var valid_578754 = query.getOrDefault("oauth_token")
  valid_578754 = validateParameter(valid_578754, JString, required = false,
                                 default = nil)
  if valid_578754 != nil:
    section.add "oauth_token", valid_578754
  var valid_578755 = query.getOrDefault("typed")
  valid_578755 = validateParameter(valid_578755, JBool, required = false, default = nil)
  if valid_578755 != nil:
    section.add "typed", valid_578755
  var valid_578756 = query.getOrDefault("alt")
  valid_578756 = validateParameter(valid_578756, JString, required = false,
                                 default = newJString("json"))
  if valid_578756 != nil:
    section.add "alt", valid_578756
  var valid_578757 = query.getOrDefault("userIp")
  valid_578757 = validateParameter(valid_578757, JString, required = false,
                                 default = nil)
  if valid_578757 != nil:
    section.add "userIp", valid_578757
  var valid_578758 = query.getOrDefault("quotaUser")
  valid_578758 = validateParameter(valid_578758, JString, required = false,
                                 default = nil)
  if valid_578758 != nil:
    section.add "quotaUser", valid_578758
  var valid_578759 = query.getOrDefault("hdrs")
  valid_578759 = validateParameter(valid_578759, JBool, required = false, default = nil)
  if valid_578759 != nil:
    section.add "hdrs", valid_578759
  assert query != nil, "query argument is necessary due to required `sql` field"
  var valid_578760 = query.getOrDefault("sql")
  valid_578760 = validateParameter(valid_578760, JString, required = true,
                                 default = nil)
  if valid_578760 != nil:
    section.add "sql", valid_578760
  var valid_578761 = query.getOrDefault("fields")
  valid_578761 = validateParameter(valid_578761, JString, required = false,
                                 default = nil)
  if valid_578761 != nil:
    section.add "fields", valid_578761
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578784: Call_FusiontablesQuerySqlGet_578625; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes a SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ## 
  let valid = call_578784.validator(path, query, header, formData, body)
  let scheme = call_578784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578784.url(scheme.get, call_578784.host, call_578784.base,
                         call_578784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578784, url, valid)

proc call*(call_578855: Call_FusiontablesQuerySqlGet_578625; sql: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          typed: bool = false; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; hdrs: bool = false; fields: string = ""): Recallable =
  ## fusiontablesQuerySqlGet
  ## Executes a SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   typed: bool
  ##        : Whether typed values are returned in the (JSON) response: numbers for numeric values and parsed geometries for KML values. Default is true.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   hdrs: bool
  ##       : Whether column names are included (in the first row). Default is true.
  ##   sql: string (required)
  ##      : A SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578856 = newJObject()
  add(query_578856, "key", newJString(key))
  add(query_578856, "prettyPrint", newJBool(prettyPrint))
  add(query_578856, "oauth_token", newJString(oauthToken))
  add(query_578856, "typed", newJBool(typed))
  add(query_578856, "alt", newJString(alt))
  add(query_578856, "userIp", newJString(userIp))
  add(query_578856, "quotaUser", newJString(quotaUser))
  add(query_578856, "hdrs", newJBool(hdrs))
  add(query_578856, "sql", newJString(sql))
  add(query_578856, "fields", newJString(fields))
  result = call_578855.call(nil, query_578856, nil, nil, nil)

var fusiontablesQuerySqlGet* = Call_FusiontablesQuerySqlGet_578625(
    name: "fusiontablesQuerySqlGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query",
    validator: validate_FusiontablesQuerySqlGet_578626, base: "/fusiontables/v2",
    url: url_FusiontablesQuerySqlGet_578627, schemes: {Scheme.Https})
type
  Call_FusiontablesTableInsert_578927 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableInsert_578929(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableInsert_578928(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new table.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("alt")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("json"))
  if valid_578933 != nil:
    section.add "alt", valid_578933
  var valid_578934 = query.getOrDefault("userIp")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "userIp", valid_578934
  var valid_578935 = query.getOrDefault("quotaUser")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "quotaUser", valid_578935
  var valid_578936 = query.getOrDefault("fields")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "fields", valid_578936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_578938: Call_FusiontablesTableInsert_578927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new table.
  ## 
  let valid = call_578938.validator(path, query, header, formData, body)
  let scheme = call_578938.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578938.url(scheme.get, call_578938.host, call_578938.base,
                         call_578938.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578938, url, valid)

proc call*(call_578939: Call_FusiontablesTableInsert_578927; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## fusiontablesTableInsert
  ## Creates a new table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578940 = newJObject()
  var body_578941 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "userIp", newJString(userIp))
  add(query_578940, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578941 = body
  add(query_578940, "fields", newJString(fields))
  result = call_578939.call(nil, query_578940, nil, nil, body_578941)

var fusiontablesTableInsert* = Call_FusiontablesTableInsert_578927(
    name: "fusiontablesTableInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables",
    validator: validate_FusiontablesTableInsert_578928, base: "/fusiontables/v2",
    url: url_FusiontablesTableInsert_578929, schemes: {Scheme.Https})
type
  Call_FusiontablesTableList_578912 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableList_578914(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableList_578913(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of tables a user owns.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token specifying which result page to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of tables to return. Default is 5.
  section = newJObject()
  var valid_578915 = query.getOrDefault("key")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = nil)
  if valid_578915 != nil:
    section.add "key", valid_578915
  var valid_578916 = query.getOrDefault("prettyPrint")
  valid_578916 = validateParameter(valid_578916, JBool, required = false,
                                 default = newJBool(true))
  if valid_578916 != nil:
    section.add "prettyPrint", valid_578916
  var valid_578917 = query.getOrDefault("oauth_token")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "oauth_token", valid_578917
  var valid_578918 = query.getOrDefault("alt")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = newJString("json"))
  if valid_578918 != nil:
    section.add "alt", valid_578918
  var valid_578919 = query.getOrDefault("userIp")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "userIp", valid_578919
  var valid_578920 = query.getOrDefault("quotaUser")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "quotaUser", valid_578920
  var valid_578921 = query.getOrDefault("pageToken")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "pageToken", valid_578921
  var valid_578922 = query.getOrDefault("fields")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "fields", valid_578922
  var valid_578923 = query.getOrDefault("maxResults")
  valid_578923 = validateParameter(valid_578923, JInt, required = false, default = nil)
  if valid_578923 != nil:
    section.add "maxResults", valid_578923
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578924: Call_FusiontablesTableList_578912; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of tables a user owns.
  ## 
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_FusiontablesTableList_578912; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; pageToken: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## fusiontablesTableList
  ## Retrieves a list of tables a user owns.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token specifying which result page to return.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of tables to return. Default is 5.
  var query_578926 = newJObject()
  add(query_578926, "key", newJString(key))
  add(query_578926, "prettyPrint", newJBool(prettyPrint))
  add(query_578926, "oauth_token", newJString(oauthToken))
  add(query_578926, "alt", newJString(alt))
  add(query_578926, "userIp", newJString(userIp))
  add(query_578926, "quotaUser", newJString(quotaUser))
  add(query_578926, "pageToken", newJString(pageToken))
  add(query_578926, "fields", newJString(fields))
  add(query_578926, "maxResults", newJInt(maxResults))
  result = call_578925.call(nil, query_578926, nil, nil, nil)

var fusiontablesTableList* = Call_FusiontablesTableList_578912(
    name: "fusiontablesTableList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables",
    validator: validate_FusiontablesTableList_578913, base: "/fusiontables/v2",
    url: url_FusiontablesTableList_578914, schemes: {Scheme.Https})
type
  Call_FusiontablesTableImportTable_578942 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableImportTable_578944(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableImportTable_578943(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports a new table.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   name: JString (required)
  ##       : The name to be assigned to the new table.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   encoding: JString
  ##           : The encoding of the content. Default is UTF-8. Use auto-detect if you are unsure of the encoding.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  section = newJObject()
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  var valid_578946 = query.getOrDefault("prettyPrint")
  valid_578946 = validateParameter(valid_578946, JBool, required = false,
                                 default = newJBool(true))
  if valid_578946 != nil:
    section.add "prettyPrint", valid_578946
  var valid_578947 = query.getOrDefault("oauth_token")
  valid_578947 = validateParameter(valid_578947, JString, required = false,
                                 default = nil)
  if valid_578947 != nil:
    section.add "oauth_token", valid_578947
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_578948 = query.getOrDefault("name")
  valid_578948 = validateParameter(valid_578948, JString, required = true,
                                 default = nil)
  if valid_578948 != nil:
    section.add "name", valid_578948
  var valid_578949 = query.getOrDefault("alt")
  valid_578949 = validateParameter(valid_578949, JString, required = false,
                                 default = newJString("json"))
  if valid_578949 != nil:
    section.add "alt", valid_578949
  var valid_578950 = query.getOrDefault("userIp")
  valid_578950 = validateParameter(valid_578950, JString, required = false,
                                 default = nil)
  if valid_578950 != nil:
    section.add "userIp", valid_578950
  var valid_578951 = query.getOrDefault("quotaUser")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "quotaUser", valid_578951
  var valid_578952 = query.getOrDefault("encoding")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "encoding", valid_578952
  var valid_578953 = query.getOrDefault("fields")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "fields", valid_578953
  var valid_578954 = query.getOrDefault("delimiter")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = nil)
  if valid_578954 != nil:
    section.add "delimiter", valid_578954
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578955: Call_FusiontablesTableImportTable_578942; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new table.
  ## 
  let valid = call_578955.validator(path, query, header, formData, body)
  let scheme = call_578955.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578955.url(scheme.get, call_578955.host, call_578955.base,
                         call_578955.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578955, url, valid)

proc call*(call_578956: Call_FusiontablesTableImportTable_578942; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          encoding: string = ""; fields: string = ""; delimiter: string = ""): Recallable =
  ## fusiontablesTableImportTable
  ## Imports a new table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   name: string (required)
  ##       : The name to be assigned to the new table.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   encoding: string
  ##           : The encoding of the content. Default is UTF-8. Use auto-detect if you are unsure of the encoding.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  var query_578957 = newJObject()
  add(query_578957, "key", newJString(key))
  add(query_578957, "prettyPrint", newJBool(prettyPrint))
  add(query_578957, "oauth_token", newJString(oauthToken))
  add(query_578957, "name", newJString(name))
  add(query_578957, "alt", newJString(alt))
  add(query_578957, "userIp", newJString(userIp))
  add(query_578957, "quotaUser", newJString(quotaUser))
  add(query_578957, "encoding", newJString(encoding))
  add(query_578957, "fields", newJString(fields))
  add(query_578957, "delimiter", newJString(delimiter))
  result = call_578956.call(nil, query_578957, nil, nil, nil)

var fusiontablesTableImportTable* = Call_FusiontablesTableImportTable_578942(
    name: "fusiontablesTableImportTable", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/import",
    validator: validate_FusiontablesTableImportTable_578943,
    base: "/fusiontables/v2", url: url_FusiontablesTableImportTable_578944,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableUpdate_578987 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableUpdate_578989(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableUpdate_578988(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : ID of the table that is being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_578990 = path.getOrDefault("tableId")
  valid_578990 = validateParameter(valid_578990, JString, required = true,
                                 default = nil)
  if valid_578990 != nil:
    section.add "tableId", valid_578990
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   replaceViewDefinition: JBool
  ##                        : Whether the view definition is also updated. The specified view definition replaces the existing one. Only a view can be updated with a new definition.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578991 = query.getOrDefault("key")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "key", valid_578991
  var valid_578992 = query.getOrDefault("prettyPrint")
  valid_578992 = validateParameter(valid_578992, JBool, required = false,
                                 default = newJBool(true))
  if valid_578992 != nil:
    section.add "prettyPrint", valid_578992
  var valid_578993 = query.getOrDefault("oauth_token")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "oauth_token", valid_578993
  var valid_578994 = query.getOrDefault("alt")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = newJString("json"))
  if valid_578994 != nil:
    section.add "alt", valid_578994
  var valid_578995 = query.getOrDefault("userIp")
  valid_578995 = validateParameter(valid_578995, JString, required = false,
                                 default = nil)
  if valid_578995 != nil:
    section.add "userIp", valid_578995
  var valid_578996 = query.getOrDefault("quotaUser")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "quotaUser", valid_578996
  var valid_578997 = query.getOrDefault("replaceViewDefinition")
  valid_578997 = validateParameter(valid_578997, JBool, required = false, default = nil)
  if valid_578997 != nil:
    section.add "replaceViewDefinition", valid_578997
  var valid_578998 = query.getOrDefault("fields")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "fields", valid_578998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579000: Call_FusiontablesTableUpdate_578987; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated.
  ## 
  let valid = call_579000.validator(path, query, header, formData, body)
  let scheme = call_579000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579000.url(scheme.get, call_579000.host, call_579000.base,
                         call_579000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579000, url, valid)

proc call*(call_579001: Call_FusiontablesTableUpdate_578987; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          replaceViewDefinition: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesTableUpdate
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : ID of the table that is being updated.
  ##   replaceViewDefinition: bool
  ##                        : Whether the view definition is also updated. The specified view definition replaces the existing one. Only a view can be updated with a new definition.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579002 = newJObject()
  var query_579003 = newJObject()
  var body_579004 = newJObject()
  add(query_579003, "key", newJString(key))
  add(query_579003, "prettyPrint", newJBool(prettyPrint))
  add(query_579003, "oauth_token", newJString(oauthToken))
  add(query_579003, "alt", newJString(alt))
  add(query_579003, "userIp", newJString(userIp))
  add(query_579003, "quotaUser", newJString(quotaUser))
  add(path_579002, "tableId", newJString(tableId))
  add(query_579003, "replaceViewDefinition", newJBool(replaceViewDefinition))
  if body != nil:
    body_579004 = body
  add(query_579003, "fields", newJString(fields))
  result = call_579001.call(path_579002, query_579003, nil, nil, body_579004)

var fusiontablesTableUpdate* = Call_FusiontablesTableUpdate_578987(
    name: "fusiontablesTableUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableUpdate_578988, base: "/fusiontables/v2",
    url: url_FusiontablesTableUpdate_578989, schemes: {Scheme.Https})
type
  Call_FusiontablesTableGet_578958 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableGet_578960(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableGet_578959(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a specific table by its ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Identifier for the table being requested.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_578975 = path.getOrDefault("tableId")
  valid_578975 = validateParameter(valid_578975, JString, required = true,
                                 default = nil)
  if valid_578975 != nil:
    section.add "tableId", valid_578975
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_578976 = query.getOrDefault("key")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "key", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("alt")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("json"))
  if valid_578979 != nil:
    section.add "alt", valid_578979
  var valid_578980 = query.getOrDefault("userIp")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "userIp", valid_578980
  var valid_578981 = query.getOrDefault("quotaUser")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "quotaUser", valid_578981
  var valid_578982 = query.getOrDefault("fields")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "fields", valid_578982
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578983: Call_FusiontablesTableGet_578958; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific table by its ID.
  ## 
  let valid = call_578983.validator(path, query, header, formData, body)
  let scheme = call_578983.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578983.url(scheme.get, call_578983.host, call_578983.base,
                         call_578983.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578983, url, valid)

proc call*(call_578984: Call_FusiontablesTableGet_578958; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## fusiontablesTableGet
  ## Retrieves a specific table by its ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Identifier for the table being requested.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578985 = newJObject()
  var query_578986 = newJObject()
  add(query_578986, "key", newJString(key))
  add(query_578986, "prettyPrint", newJBool(prettyPrint))
  add(query_578986, "oauth_token", newJString(oauthToken))
  add(query_578986, "alt", newJString(alt))
  add(query_578986, "userIp", newJString(userIp))
  add(query_578986, "quotaUser", newJString(quotaUser))
  add(path_578985, "tableId", newJString(tableId))
  add(query_578986, "fields", newJString(fields))
  result = call_578984.call(path_578985, query_578986, nil, nil, nil)

var fusiontablesTableGet* = Call_FusiontablesTableGet_578958(
    name: "fusiontablesTableGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableGet_578959, base: "/fusiontables/v2",
    url: url_FusiontablesTableGet_578960, schemes: {Scheme.Https})
type
  Call_FusiontablesTablePatch_579020 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTablePatch_579022(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTablePatch_579021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : ID of the table that is being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579023 = path.getOrDefault("tableId")
  valid_579023 = validateParameter(valid_579023, JString, required = true,
                                 default = nil)
  if valid_579023 != nil:
    section.add "tableId", valid_579023
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   replaceViewDefinition: JBool
  ##                        : Whether the view definition is also updated. The specified view definition replaces the existing one. Only a view can be updated with a new definition.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579024 = query.getOrDefault("key")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "key", valid_579024
  var valid_579025 = query.getOrDefault("prettyPrint")
  valid_579025 = validateParameter(valid_579025, JBool, required = false,
                                 default = newJBool(true))
  if valid_579025 != nil:
    section.add "prettyPrint", valid_579025
  var valid_579026 = query.getOrDefault("oauth_token")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "oauth_token", valid_579026
  var valid_579027 = query.getOrDefault("alt")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = newJString("json"))
  if valid_579027 != nil:
    section.add "alt", valid_579027
  var valid_579028 = query.getOrDefault("userIp")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "userIp", valid_579028
  var valid_579029 = query.getOrDefault("quotaUser")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "quotaUser", valid_579029
  var valid_579030 = query.getOrDefault("replaceViewDefinition")
  valid_579030 = validateParameter(valid_579030, JBool, required = false, default = nil)
  if valid_579030 != nil:
    section.add "replaceViewDefinition", valid_579030
  var valid_579031 = query.getOrDefault("fields")
  valid_579031 = validateParameter(valid_579031, JString, required = false,
                                 default = nil)
  if valid_579031 != nil:
    section.add "fields", valid_579031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579033: Call_FusiontablesTablePatch_579020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated. This method supports patch semantics.
  ## 
  let valid = call_579033.validator(path, query, header, formData, body)
  let scheme = call_579033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579033.url(scheme.get, call_579033.host, call_579033.base,
                         call_579033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579033, url, valid)

proc call*(call_579034: Call_FusiontablesTablePatch_579020; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          replaceViewDefinition: bool = false; body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesTablePatch
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : ID of the table that is being updated.
  ##   replaceViewDefinition: bool
  ##                        : Whether the view definition is also updated. The specified view definition replaces the existing one. Only a view can be updated with a new definition.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579035 = newJObject()
  var query_579036 = newJObject()
  var body_579037 = newJObject()
  add(query_579036, "key", newJString(key))
  add(query_579036, "prettyPrint", newJBool(prettyPrint))
  add(query_579036, "oauth_token", newJString(oauthToken))
  add(query_579036, "alt", newJString(alt))
  add(query_579036, "userIp", newJString(userIp))
  add(query_579036, "quotaUser", newJString(quotaUser))
  add(path_579035, "tableId", newJString(tableId))
  add(query_579036, "replaceViewDefinition", newJBool(replaceViewDefinition))
  if body != nil:
    body_579037 = body
  add(query_579036, "fields", newJString(fields))
  result = call_579034.call(path_579035, query_579036, nil, nil, body_579037)

var fusiontablesTablePatch* = Call_FusiontablesTablePatch_579020(
    name: "fusiontablesTablePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTablePatch_579021, base: "/fusiontables/v2",
    url: url_FusiontablesTablePatch_579022, schemes: {Scheme.Https})
type
  Call_FusiontablesTableDelete_579005 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableDelete_579007(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableDelete_579006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : ID of the table to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579008 = path.getOrDefault("tableId")
  valid_579008 = validateParameter(valid_579008, JString, required = true,
                                 default = nil)
  if valid_579008 != nil:
    section.add "tableId", valid_579008
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579009 = query.getOrDefault("key")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "key", valid_579009
  var valid_579010 = query.getOrDefault("prettyPrint")
  valid_579010 = validateParameter(valid_579010, JBool, required = false,
                                 default = newJBool(true))
  if valid_579010 != nil:
    section.add "prettyPrint", valid_579010
  var valid_579011 = query.getOrDefault("oauth_token")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "oauth_token", valid_579011
  var valid_579012 = query.getOrDefault("alt")
  valid_579012 = validateParameter(valid_579012, JString, required = false,
                                 default = newJString("json"))
  if valid_579012 != nil:
    section.add "alt", valid_579012
  var valid_579013 = query.getOrDefault("userIp")
  valid_579013 = validateParameter(valid_579013, JString, required = false,
                                 default = nil)
  if valid_579013 != nil:
    section.add "userIp", valid_579013
  var valid_579014 = query.getOrDefault("quotaUser")
  valid_579014 = validateParameter(valid_579014, JString, required = false,
                                 default = nil)
  if valid_579014 != nil:
    section.add "quotaUser", valid_579014
  var valid_579015 = query.getOrDefault("fields")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "fields", valid_579015
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579016: Call_FusiontablesTableDelete_579005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a table.
  ## 
  let valid = call_579016.validator(path, query, header, formData, body)
  let scheme = call_579016.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579016.url(scheme.get, call_579016.host, call_579016.base,
                         call_579016.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579016, url, valid)

proc call*(call_579017: Call_FusiontablesTableDelete_579005; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## fusiontablesTableDelete
  ## Deletes a table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : ID of the table to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579018 = newJObject()
  var query_579019 = newJObject()
  add(query_579019, "key", newJString(key))
  add(query_579019, "prettyPrint", newJBool(prettyPrint))
  add(query_579019, "oauth_token", newJString(oauthToken))
  add(query_579019, "alt", newJString(alt))
  add(query_579019, "userIp", newJString(userIp))
  add(query_579019, "quotaUser", newJString(quotaUser))
  add(path_579018, "tableId", newJString(tableId))
  add(query_579019, "fields", newJString(fields))
  result = call_579017.call(path_579018, query_579019, nil, nil, nil)

var fusiontablesTableDelete* = Call_FusiontablesTableDelete_579005(
    name: "fusiontablesTableDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableDelete_579006, base: "/fusiontables/v2",
    url: url_FusiontablesTableDelete_579007, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnInsert_579055 = ref object of OpenApiRestCall_578355
proc url_FusiontablesColumnInsert_579057(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/columns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesColumnInsert_579056(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new column to the table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table for which a new column is being added.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579058 = path.getOrDefault("tableId")
  valid_579058 = validateParameter(valid_579058, JString, required = true,
                                 default = nil)
  if valid_579058 != nil:
    section.add "tableId", valid_579058
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579059 = query.getOrDefault("key")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "key", valid_579059
  var valid_579060 = query.getOrDefault("prettyPrint")
  valid_579060 = validateParameter(valid_579060, JBool, required = false,
                                 default = newJBool(true))
  if valid_579060 != nil:
    section.add "prettyPrint", valid_579060
  var valid_579061 = query.getOrDefault("oauth_token")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "oauth_token", valid_579061
  var valid_579062 = query.getOrDefault("alt")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = newJString("json"))
  if valid_579062 != nil:
    section.add "alt", valid_579062
  var valid_579063 = query.getOrDefault("userIp")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "userIp", valid_579063
  var valid_579064 = query.getOrDefault("quotaUser")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = nil)
  if valid_579064 != nil:
    section.add "quotaUser", valid_579064
  var valid_579065 = query.getOrDefault("fields")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "fields", valid_579065
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579067: Call_FusiontablesColumnInsert_579055; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new column to the table.
  ## 
  let valid = call_579067.validator(path, query, header, formData, body)
  let scheme = call_579067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579067.url(scheme.get, call_579067.host, call_579067.base,
                         call_579067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579067, url, valid)

proc call*(call_579068: Call_FusiontablesColumnInsert_579055; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesColumnInsert
  ## Adds a new column to the table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table for which a new column is being added.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579069 = newJObject()
  var query_579070 = newJObject()
  var body_579071 = newJObject()
  add(query_579070, "key", newJString(key))
  add(query_579070, "prettyPrint", newJBool(prettyPrint))
  add(query_579070, "oauth_token", newJString(oauthToken))
  add(query_579070, "alt", newJString(alt))
  add(query_579070, "userIp", newJString(userIp))
  add(query_579070, "quotaUser", newJString(quotaUser))
  add(path_579069, "tableId", newJString(tableId))
  if body != nil:
    body_579071 = body
  add(query_579070, "fields", newJString(fields))
  result = call_579068.call(path_579069, query_579070, nil, nil, body_579071)

var fusiontablesColumnInsert* = Call_FusiontablesColumnInsert_579055(
    name: "fusiontablesColumnInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns",
    validator: validate_FusiontablesColumnInsert_579056, base: "/fusiontables/v2",
    url: url_FusiontablesColumnInsert_579057, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnList_579038 = ref object of OpenApiRestCall_578355
proc url_FusiontablesColumnList_579040(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/columns")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesColumnList_579039(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of columns.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table whose columns are being listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579041 = path.getOrDefault("tableId")
  valid_579041 = validateParameter(valid_579041, JString, required = true,
                                 default = nil)
  if valid_579041 != nil:
    section.add "tableId", valid_579041
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token specifying which result page to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of columns to return. Default is 5.
  section = newJObject()
  var valid_579042 = query.getOrDefault("key")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "key", valid_579042
  var valid_579043 = query.getOrDefault("prettyPrint")
  valid_579043 = validateParameter(valid_579043, JBool, required = false,
                                 default = newJBool(true))
  if valid_579043 != nil:
    section.add "prettyPrint", valid_579043
  var valid_579044 = query.getOrDefault("oauth_token")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "oauth_token", valid_579044
  var valid_579045 = query.getOrDefault("alt")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = newJString("json"))
  if valid_579045 != nil:
    section.add "alt", valid_579045
  var valid_579046 = query.getOrDefault("userIp")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "userIp", valid_579046
  var valid_579047 = query.getOrDefault("quotaUser")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "quotaUser", valid_579047
  var valid_579048 = query.getOrDefault("pageToken")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "pageToken", valid_579048
  var valid_579049 = query.getOrDefault("fields")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "fields", valid_579049
  var valid_579050 = query.getOrDefault("maxResults")
  valid_579050 = validateParameter(valid_579050, JInt, required = false, default = nil)
  if valid_579050 != nil:
    section.add "maxResults", valid_579050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579051: Call_FusiontablesColumnList_579038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of columns.
  ## 
  let valid = call_579051.validator(path, query, header, formData, body)
  let scheme = call_579051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579051.url(scheme.get, call_579051.host, call_579051.base,
                         call_579051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579051, url, valid)

proc call*(call_579052: Call_FusiontablesColumnList_579038; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## fusiontablesColumnList
  ## Retrieves a list of columns.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token specifying which result page to return.
  ##   tableId: string (required)
  ##          : Table whose columns are being listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of columns to return. Default is 5.
  var path_579053 = newJObject()
  var query_579054 = newJObject()
  add(query_579054, "key", newJString(key))
  add(query_579054, "prettyPrint", newJBool(prettyPrint))
  add(query_579054, "oauth_token", newJString(oauthToken))
  add(query_579054, "alt", newJString(alt))
  add(query_579054, "userIp", newJString(userIp))
  add(query_579054, "quotaUser", newJString(quotaUser))
  add(query_579054, "pageToken", newJString(pageToken))
  add(path_579053, "tableId", newJString(tableId))
  add(query_579054, "fields", newJString(fields))
  add(query_579054, "maxResults", newJInt(maxResults))
  result = call_579052.call(path_579053, query_579054, nil, nil, nil)

var fusiontablesColumnList* = Call_FusiontablesColumnList_579038(
    name: "fusiontablesColumnList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns",
    validator: validate_FusiontablesColumnList_579039, base: "/fusiontables/v2",
    url: url_FusiontablesColumnList_579040, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnUpdate_579088 = ref object of OpenApiRestCall_578355
proc url_FusiontablesColumnUpdate_579090(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "columnId" in path, "`columnId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesColumnUpdate_579089(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the name or type of an existing column.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table for which the column is being updated.
  ##   columnId: JString (required)
  ##           : Name or identifier for the column that is being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579091 = path.getOrDefault("tableId")
  valid_579091 = validateParameter(valid_579091, JString, required = true,
                                 default = nil)
  if valid_579091 != nil:
    section.add "tableId", valid_579091
  var valid_579092 = path.getOrDefault("columnId")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "columnId", valid_579092
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579093 = query.getOrDefault("key")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "key", valid_579093
  var valid_579094 = query.getOrDefault("prettyPrint")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "prettyPrint", valid_579094
  var valid_579095 = query.getOrDefault("oauth_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "oauth_token", valid_579095
  var valid_579096 = query.getOrDefault("alt")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("json"))
  if valid_579096 != nil:
    section.add "alt", valid_579096
  var valid_579097 = query.getOrDefault("userIp")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "userIp", valid_579097
  var valid_579098 = query.getOrDefault("quotaUser")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = nil)
  if valid_579098 != nil:
    section.add "quotaUser", valid_579098
  var valid_579099 = query.getOrDefault("fields")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "fields", valid_579099
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579101: Call_FusiontablesColumnUpdate_579088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or type of an existing column.
  ## 
  let valid = call_579101.validator(path, query, header, formData, body)
  let scheme = call_579101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579101.url(scheme.get, call_579101.host, call_579101.base,
                         call_579101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579101, url, valid)

proc call*(call_579102: Call_FusiontablesColumnUpdate_579088; tableId: string;
          columnId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesColumnUpdate
  ## Updates the name or type of an existing column.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table for which the column is being updated.
  ##   body: JObject
  ##   columnId: string (required)
  ##           : Name or identifier for the column that is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579103 = newJObject()
  var query_579104 = newJObject()
  var body_579105 = newJObject()
  add(query_579104, "key", newJString(key))
  add(query_579104, "prettyPrint", newJBool(prettyPrint))
  add(query_579104, "oauth_token", newJString(oauthToken))
  add(query_579104, "alt", newJString(alt))
  add(query_579104, "userIp", newJString(userIp))
  add(query_579104, "quotaUser", newJString(quotaUser))
  add(path_579103, "tableId", newJString(tableId))
  if body != nil:
    body_579105 = body
  add(path_579103, "columnId", newJString(columnId))
  add(query_579104, "fields", newJString(fields))
  result = call_579102.call(path_579103, query_579104, nil, nil, body_579105)

var fusiontablesColumnUpdate* = Call_FusiontablesColumnUpdate_579088(
    name: "fusiontablesColumnUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnUpdate_579089, base: "/fusiontables/v2",
    url: url_FusiontablesColumnUpdate_579090, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnGet_579072 = ref object of OpenApiRestCall_578355
proc url_FusiontablesColumnGet_579074(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "columnId" in path, "`columnId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesColumnGet_579073(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a specific column by its ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table to which the column belongs.
  ##   columnId: JString (required)
  ##           : Name or identifier for the column that is being requested.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579075 = path.getOrDefault("tableId")
  valid_579075 = validateParameter(valid_579075, JString, required = true,
                                 default = nil)
  if valid_579075 != nil:
    section.add "tableId", valid_579075
  var valid_579076 = path.getOrDefault("columnId")
  valid_579076 = validateParameter(valid_579076, JString, required = true,
                                 default = nil)
  if valid_579076 != nil:
    section.add "columnId", valid_579076
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579077 = query.getOrDefault("key")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "key", valid_579077
  var valid_579078 = query.getOrDefault("prettyPrint")
  valid_579078 = validateParameter(valid_579078, JBool, required = false,
                                 default = newJBool(true))
  if valid_579078 != nil:
    section.add "prettyPrint", valid_579078
  var valid_579079 = query.getOrDefault("oauth_token")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "oauth_token", valid_579079
  var valid_579080 = query.getOrDefault("alt")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = newJString("json"))
  if valid_579080 != nil:
    section.add "alt", valid_579080
  var valid_579081 = query.getOrDefault("userIp")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "userIp", valid_579081
  var valid_579082 = query.getOrDefault("quotaUser")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "quotaUser", valid_579082
  var valid_579083 = query.getOrDefault("fields")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "fields", valid_579083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579084: Call_FusiontablesColumnGet_579072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific column by its ID.
  ## 
  let valid = call_579084.validator(path, query, header, formData, body)
  let scheme = call_579084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579084.url(scheme.get, call_579084.host, call_579084.base,
                         call_579084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579084, url, valid)

proc call*(call_579085: Call_FusiontablesColumnGet_579072; tableId: string;
          columnId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## fusiontablesColumnGet
  ## Retrieves a specific column by its ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table to which the column belongs.
  ##   columnId: string (required)
  ##           : Name or identifier for the column that is being requested.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579086 = newJObject()
  var query_579087 = newJObject()
  add(query_579087, "key", newJString(key))
  add(query_579087, "prettyPrint", newJBool(prettyPrint))
  add(query_579087, "oauth_token", newJString(oauthToken))
  add(query_579087, "alt", newJString(alt))
  add(query_579087, "userIp", newJString(userIp))
  add(query_579087, "quotaUser", newJString(quotaUser))
  add(path_579086, "tableId", newJString(tableId))
  add(path_579086, "columnId", newJString(columnId))
  add(query_579087, "fields", newJString(fields))
  result = call_579085.call(path_579086, query_579087, nil, nil, nil)

var fusiontablesColumnGet* = Call_FusiontablesColumnGet_579072(
    name: "fusiontablesColumnGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnGet_579073, base: "/fusiontables/v2",
    url: url_FusiontablesColumnGet_579074, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnPatch_579122 = ref object of OpenApiRestCall_578355
proc url_FusiontablesColumnPatch_579124(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "columnId" in path, "`columnId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesColumnPatch_579123(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the name or type of an existing column. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table for which the column is being updated.
  ##   columnId: JString (required)
  ##           : Name or identifier for the column that is being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579125 = path.getOrDefault("tableId")
  valid_579125 = validateParameter(valid_579125, JString, required = true,
                                 default = nil)
  if valid_579125 != nil:
    section.add "tableId", valid_579125
  var valid_579126 = path.getOrDefault("columnId")
  valid_579126 = validateParameter(valid_579126, JString, required = true,
                                 default = nil)
  if valid_579126 != nil:
    section.add "columnId", valid_579126
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579127 = query.getOrDefault("key")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "key", valid_579127
  var valid_579128 = query.getOrDefault("prettyPrint")
  valid_579128 = validateParameter(valid_579128, JBool, required = false,
                                 default = newJBool(true))
  if valid_579128 != nil:
    section.add "prettyPrint", valid_579128
  var valid_579129 = query.getOrDefault("oauth_token")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "oauth_token", valid_579129
  var valid_579130 = query.getOrDefault("alt")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = newJString("json"))
  if valid_579130 != nil:
    section.add "alt", valid_579130
  var valid_579131 = query.getOrDefault("userIp")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "userIp", valid_579131
  var valid_579132 = query.getOrDefault("quotaUser")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "quotaUser", valid_579132
  var valid_579133 = query.getOrDefault("fields")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "fields", valid_579133
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579135: Call_FusiontablesColumnPatch_579122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or type of an existing column. This method supports patch semantics.
  ## 
  let valid = call_579135.validator(path, query, header, formData, body)
  let scheme = call_579135.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579135.url(scheme.get, call_579135.host, call_579135.base,
                         call_579135.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579135, url, valid)

proc call*(call_579136: Call_FusiontablesColumnPatch_579122; tableId: string;
          columnId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesColumnPatch
  ## Updates the name or type of an existing column. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table for which the column is being updated.
  ##   body: JObject
  ##   columnId: string (required)
  ##           : Name or identifier for the column that is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579137 = newJObject()
  var query_579138 = newJObject()
  var body_579139 = newJObject()
  add(query_579138, "key", newJString(key))
  add(query_579138, "prettyPrint", newJBool(prettyPrint))
  add(query_579138, "oauth_token", newJString(oauthToken))
  add(query_579138, "alt", newJString(alt))
  add(query_579138, "userIp", newJString(userIp))
  add(query_579138, "quotaUser", newJString(quotaUser))
  add(path_579137, "tableId", newJString(tableId))
  if body != nil:
    body_579139 = body
  add(path_579137, "columnId", newJString(columnId))
  add(query_579138, "fields", newJString(fields))
  result = call_579136.call(path_579137, query_579138, nil, nil, body_579139)

var fusiontablesColumnPatch* = Call_FusiontablesColumnPatch_579122(
    name: "fusiontablesColumnPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnPatch_579123, base: "/fusiontables/v2",
    url: url_FusiontablesColumnPatch_579124, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnDelete_579106 = ref object of OpenApiRestCall_578355
proc url_FusiontablesColumnDelete_579108(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "columnId" in path, "`columnId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/columns/"),
               (kind: VariableSegment, value: "columnId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesColumnDelete_579107(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the specified column.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table from which the column is being deleted.
  ##   columnId: JString (required)
  ##           : Name or identifier for the column being deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579109 = path.getOrDefault("tableId")
  valid_579109 = validateParameter(valid_579109, JString, required = true,
                                 default = nil)
  if valid_579109 != nil:
    section.add "tableId", valid_579109
  var valid_579110 = path.getOrDefault("columnId")
  valid_579110 = validateParameter(valid_579110, JString, required = true,
                                 default = nil)
  if valid_579110 != nil:
    section.add "columnId", valid_579110
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579111 = query.getOrDefault("key")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "key", valid_579111
  var valid_579112 = query.getOrDefault("prettyPrint")
  valid_579112 = validateParameter(valid_579112, JBool, required = false,
                                 default = newJBool(true))
  if valid_579112 != nil:
    section.add "prettyPrint", valid_579112
  var valid_579113 = query.getOrDefault("oauth_token")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "oauth_token", valid_579113
  var valid_579114 = query.getOrDefault("alt")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = newJString("json"))
  if valid_579114 != nil:
    section.add "alt", valid_579114
  var valid_579115 = query.getOrDefault("userIp")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = nil)
  if valid_579115 != nil:
    section.add "userIp", valid_579115
  var valid_579116 = query.getOrDefault("quotaUser")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "quotaUser", valid_579116
  var valid_579117 = query.getOrDefault("fields")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = nil)
  if valid_579117 != nil:
    section.add "fields", valid_579117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579118: Call_FusiontablesColumnDelete_579106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified column.
  ## 
  let valid = call_579118.validator(path, query, header, formData, body)
  let scheme = call_579118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579118.url(scheme.get, call_579118.host, call_579118.base,
                         call_579118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579118, url, valid)

proc call*(call_579119: Call_FusiontablesColumnDelete_579106; tableId: string;
          columnId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## fusiontablesColumnDelete
  ## Deletes the specified column.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table from which the column is being deleted.
  ##   columnId: string (required)
  ##           : Name or identifier for the column being deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579120 = newJObject()
  var query_579121 = newJObject()
  add(query_579121, "key", newJString(key))
  add(query_579121, "prettyPrint", newJBool(prettyPrint))
  add(query_579121, "oauth_token", newJString(oauthToken))
  add(query_579121, "alt", newJString(alt))
  add(query_579121, "userIp", newJString(userIp))
  add(query_579121, "quotaUser", newJString(quotaUser))
  add(path_579120, "tableId", newJString(tableId))
  add(path_579120, "columnId", newJString(columnId))
  add(query_579121, "fields", newJString(fields))
  result = call_579119.call(path_579120, query_579121, nil, nil, nil)

var fusiontablesColumnDelete* = Call_FusiontablesColumnDelete_579106(
    name: "fusiontablesColumnDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnDelete_579107, base: "/fusiontables/v2",
    url: url_FusiontablesColumnDelete_579108, schemes: {Scheme.Https})
type
  Call_FusiontablesTableCopy_579140 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableCopy_579142(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/copy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableCopy_579141(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Copies a table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : ID of the table that is being copied.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579143 = path.getOrDefault("tableId")
  valid_579143 = validateParameter(valid_579143, JString, required = true,
                                 default = nil)
  if valid_579143 != nil:
    section.add "tableId", valid_579143
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   copyPresentation: JBool
  ##                   : Whether to also copy tabs, styles, and templates. Default is false.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579144 = query.getOrDefault("key")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "key", valid_579144
  var valid_579145 = query.getOrDefault("prettyPrint")
  valid_579145 = validateParameter(valid_579145, JBool, required = false,
                                 default = newJBool(true))
  if valid_579145 != nil:
    section.add "prettyPrint", valid_579145
  var valid_579146 = query.getOrDefault("oauth_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "oauth_token", valid_579146
  var valid_579147 = query.getOrDefault("alt")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("json"))
  if valid_579147 != nil:
    section.add "alt", valid_579147
  var valid_579148 = query.getOrDefault("userIp")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "userIp", valid_579148
  var valid_579149 = query.getOrDefault("quotaUser")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "quotaUser", valid_579149
  var valid_579150 = query.getOrDefault("copyPresentation")
  valid_579150 = validateParameter(valid_579150, JBool, required = false, default = nil)
  if valid_579150 != nil:
    section.add "copyPresentation", valid_579150
  var valid_579151 = query.getOrDefault("fields")
  valid_579151 = validateParameter(valid_579151, JString, required = false,
                                 default = nil)
  if valid_579151 != nil:
    section.add "fields", valid_579151
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579152: Call_FusiontablesTableCopy_579140; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a table.
  ## 
  let valid = call_579152.validator(path, query, header, formData, body)
  let scheme = call_579152.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579152.url(scheme.get, call_579152.host, call_579152.base,
                         call_579152.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579152, url, valid)

proc call*(call_579153: Call_FusiontablesTableCopy_579140; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          copyPresentation: bool = false; fields: string = ""): Recallable =
  ## fusiontablesTableCopy
  ## Copies a table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : ID of the table that is being copied.
  ##   copyPresentation: bool
  ##                   : Whether to also copy tabs, styles, and templates. Default is false.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579154 = newJObject()
  var query_579155 = newJObject()
  add(query_579155, "key", newJString(key))
  add(query_579155, "prettyPrint", newJBool(prettyPrint))
  add(query_579155, "oauth_token", newJString(oauthToken))
  add(query_579155, "alt", newJString(alt))
  add(query_579155, "userIp", newJString(userIp))
  add(query_579155, "quotaUser", newJString(quotaUser))
  add(path_579154, "tableId", newJString(tableId))
  add(query_579155, "copyPresentation", newJBool(copyPresentation))
  add(query_579155, "fields", newJString(fields))
  result = call_579153.call(path_579154, query_579155, nil, nil, nil)

var fusiontablesTableCopy* = Call_FusiontablesTableCopy_579140(
    name: "fusiontablesTableCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/copy",
    validator: validate_FusiontablesTableCopy_579141, base: "/fusiontables/v2",
    url: url_FusiontablesTableCopy_579142, schemes: {Scheme.Https})
type
  Call_FusiontablesTableImportRows_579156 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableImportRows_579158(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableImportRows_579157(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports more rows into a table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : The table into which new rows are being imported.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579159 = path.getOrDefault("tableId")
  valid_579159 = validateParameter(valid_579159, JString, required = true,
                                 default = nil)
  if valid_579159 != nil:
    section.add "tableId", valid_579159
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   isStrict: JBool
  ##           : Whether the imported CSV must have the same number of values for each row. If false, rows with fewer values will be padded with empty values. Default is true.
  ##   startLine: JInt
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  ##   endLine: JInt
  ##          : The index of the line up to which data will be imported. Default is to import the entire file. If endLine is negative, it is an offset from the end of the file; the imported content will exclude the last endLine lines.
  ##   encoding: JString
  ##           : The encoding of the content. Default is UTF-8. Use auto-detect if you are unsure of the encoding.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  section = newJObject()
  var valid_579160 = query.getOrDefault("key")
  valid_579160 = validateParameter(valid_579160, JString, required = false,
                                 default = nil)
  if valid_579160 != nil:
    section.add "key", valid_579160
  var valid_579161 = query.getOrDefault("prettyPrint")
  valid_579161 = validateParameter(valid_579161, JBool, required = false,
                                 default = newJBool(true))
  if valid_579161 != nil:
    section.add "prettyPrint", valid_579161
  var valid_579162 = query.getOrDefault("oauth_token")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "oauth_token", valid_579162
  var valid_579163 = query.getOrDefault("alt")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = newJString("json"))
  if valid_579163 != nil:
    section.add "alt", valid_579163
  var valid_579164 = query.getOrDefault("userIp")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "userIp", valid_579164
  var valid_579165 = query.getOrDefault("quotaUser")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "quotaUser", valid_579165
  var valid_579166 = query.getOrDefault("isStrict")
  valid_579166 = validateParameter(valid_579166, JBool, required = false, default = nil)
  if valid_579166 != nil:
    section.add "isStrict", valid_579166
  var valid_579167 = query.getOrDefault("startLine")
  valid_579167 = validateParameter(valid_579167, JInt, required = false, default = nil)
  if valid_579167 != nil:
    section.add "startLine", valid_579167
  var valid_579168 = query.getOrDefault("endLine")
  valid_579168 = validateParameter(valid_579168, JInt, required = false, default = nil)
  if valid_579168 != nil:
    section.add "endLine", valid_579168
  var valid_579169 = query.getOrDefault("encoding")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "encoding", valid_579169
  var valid_579170 = query.getOrDefault("fields")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = nil)
  if valid_579170 != nil:
    section.add "fields", valid_579170
  var valid_579171 = query.getOrDefault("delimiter")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = nil)
  if valid_579171 != nil:
    section.add "delimiter", valid_579171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579172: Call_FusiontablesTableImportRows_579156; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports more rows into a table.
  ## 
  let valid = call_579172.validator(path, query, header, formData, body)
  let scheme = call_579172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579172.url(scheme.get, call_579172.host, call_579172.base,
                         call_579172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579172, url, valid)

proc call*(call_579173: Call_FusiontablesTableImportRows_579156; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          isStrict: bool = false; startLine: int = 0; endLine: int = 0;
          encoding: string = ""; fields: string = ""; delimiter: string = ""): Recallable =
  ## fusiontablesTableImportRows
  ## Imports more rows into a table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   isStrict: bool
  ##           : Whether the imported CSV must have the same number of values for each row. If false, rows with fewer values will be padded with empty values. Default is true.
  ##   tableId: string (required)
  ##          : The table into which new rows are being imported.
  ##   startLine: int
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  ##   endLine: int
  ##          : The index of the line up to which data will be imported. Default is to import the entire file. If endLine is negative, it is an offset from the end of the file; the imported content will exclude the last endLine lines.
  ##   encoding: string
  ##           : The encoding of the content. Default is UTF-8. Use auto-detect if you are unsure of the encoding.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  var path_579174 = newJObject()
  var query_579175 = newJObject()
  add(query_579175, "key", newJString(key))
  add(query_579175, "prettyPrint", newJBool(prettyPrint))
  add(query_579175, "oauth_token", newJString(oauthToken))
  add(query_579175, "alt", newJString(alt))
  add(query_579175, "userIp", newJString(userIp))
  add(query_579175, "quotaUser", newJString(quotaUser))
  add(query_579175, "isStrict", newJBool(isStrict))
  add(path_579174, "tableId", newJString(tableId))
  add(query_579175, "startLine", newJInt(startLine))
  add(query_579175, "endLine", newJInt(endLine))
  add(query_579175, "encoding", newJString(encoding))
  add(query_579175, "fields", newJString(fields))
  add(query_579175, "delimiter", newJString(delimiter))
  result = call_579173.call(path_579174, query_579175, nil, nil, nil)

var fusiontablesTableImportRows* = Call_FusiontablesTableImportRows_579156(
    name: "fusiontablesTableImportRows", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/import",
    validator: validate_FusiontablesTableImportRows_579157,
    base: "/fusiontables/v2", url: url_FusiontablesTableImportRows_579158,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableRefetchSheet_579176 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableRefetchSheet_579178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/refetch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableRefetchSheet_579177(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replaces rows of the table with the rows of the spreadsheet that is first imported from. Current rows remain visible until all replacement rows are ready.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table whose rows will be replaced from the spreadsheet.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579179 = path.getOrDefault("tableId")
  valid_579179 = validateParameter(valid_579179, JString, required = true,
                                 default = nil)
  if valid_579179 != nil:
    section.add "tableId", valid_579179
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579180 = query.getOrDefault("key")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "key", valid_579180
  var valid_579181 = query.getOrDefault("prettyPrint")
  valid_579181 = validateParameter(valid_579181, JBool, required = false,
                                 default = newJBool(true))
  if valid_579181 != nil:
    section.add "prettyPrint", valid_579181
  var valid_579182 = query.getOrDefault("oauth_token")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "oauth_token", valid_579182
  var valid_579183 = query.getOrDefault("alt")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = newJString("json"))
  if valid_579183 != nil:
    section.add "alt", valid_579183
  var valid_579184 = query.getOrDefault("userIp")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "userIp", valid_579184
  var valid_579185 = query.getOrDefault("quotaUser")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "quotaUser", valid_579185
  var valid_579186 = query.getOrDefault("fields")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "fields", valid_579186
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579187: Call_FusiontablesTableRefetchSheet_579176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces rows of the table with the rows of the spreadsheet that is first imported from. Current rows remain visible until all replacement rows are ready.
  ## 
  let valid = call_579187.validator(path, query, header, formData, body)
  let scheme = call_579187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579187.url(scheme.get, call_579187.host, call_579187.base,
                         call_579187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579187, url, valid)

proc call*(call_579188: Call_FusiontablesTableRefetchSheet_579176; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## fusiontablesTableRefetchSheet
  ## Replaces rows of the table with the rows of the spreadsheet that is first imported from. Current rows remain visible until all replacement rows are ready.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table whose rows will be replaced from the spreadsheet.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579189 = newJObject()
  var query_579190 = newJObject()
  add(query_579190, "key", newJString(key))
  add(query_579190, "prettyPrint", newJBool(prettyPrint))
  add(query_579190, "oauth_token", newJString(oauthToken))
  add(query_579190, "alt", newJString(alt))
  add(query_579190, "userIp", newJString(userIp))
  add(query_579190, "quotaUser", newJString(quotaUser))
  add(path_579189, "tableId", newJString(tableId))
  add(query_579190, "fields", newJString(fields))
  result = call_579188.call(path_579189, query_579190, nil, nil, nil)

var fusiontablesTableRefetchSheet* = Call_FusiontablesTableRefetchSheet_579176(
    name: "fusiontablesTableRefetchSheet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/refetch",
    validator: validate_FusiontablesTableRefetchSheet_579177,
    base: "/fusiontables/v2", url: url_FusiontablesTableRefetchSheet_579178,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableReplaceRows_579191 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTableReplaceRows_579193(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/replace")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableReplaceRows_579192(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Replaces rows of an existing table. Current rows remain visible until all replacement rows are ready.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table whose rows will be replaced.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579194 = path.getOrDefault("tableId")
  valid_579194 = validateParameter(valid_579194, JString, required = true,
                                 default = nil)
  if valid_579194 != nil:
    section.add "tableId", valid_579194
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   isStrict: JBool
  ##           : Whether the imported CSV must have the same number of column values for each row. If true, throws an exception if the CSV does not have the same number of columns. If false, rows with fewer column values will be padded with empty values. Default is true.
  ##   startLine: JInt
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  ##   endLine: JInt
  ##          : The index of the line up to which data will be imported. Default is to import the entire file. If endLine is negative, it is an offset from the end of the file; the imported content will exclude the last endLine lines.
  ##   encoding: JString
  ##           : The encoding of the content. Default is UTF-8. Use 'auto-detect' if you are unsure of the encoding.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: JString
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  section = newJObject()
  var valid_579195 = query.getOrDefault("key")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "key", valid_579195
  var valid_579196 = query.getOrDefault("prettyPrint")
  valid_579196 = validateParameter(valid_579196, JBool, required = false,
                                 default = newJBool(true))
  if valid_579196 != nil:
    section.add "prettyPrint", valid_579196
  var valid_579197 = query.getOrDefault("oauth_token")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "oauth_token", valid_579197
  var valid_579198 = query.getOrDefault("alt")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = newJString("json"))
  if valid_579198 != nil:
    section.add "alt", valid_579198
  var valid_579199 = query.getOrDefault("userIp")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "userIp", valid_579199
  var valid_579200 = query.getOrDefault("quotaUser")
  valid_579200 = validateParameter(valid_579200, JString, required = false,
                                 default = nil)
  if valid_579200 != nil:
    section.add "quotaUser", valid_579200
  var valid_579201 = query.getOrDefault("isStrict")
  valid_579201 = validateParameter(valid_579201, JBool, required = false, default = nil)
  if valid_579201 != nil:
    section.add "isStrict", valid_579201
  var valid_579202 = query.getOrDefault("startLine")
  valid_579202 = validateParameter(valid_579202, JInt, required = false, default = nil)
  if valid_579202 != nil:
    section.add "startLine", valid_579202
  var valid_579203 = query.getOrDefault("endLine")
  valid_579203 = validateParameter(valid_579203, JInt, required = false, default = nil)
  if valid_579203 != nil:
    section.add "endLine", valid_579203
  var valid_579204 = query.getOrDefault("encoding")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "encoding", valid_579204
  var valid_579205 = query.getOrDefault("fields")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "fields", valid_579205
  var valid_579206 = query.getOrDefault("delimiter")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "delimiter", valid_579206
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579207: Call_FusiontablesTableReplaceRows_579191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces rows of an existing table. Current rows remain visible until all replacement rows are ready.
  ## 
  let valid = call_579207.validator(path, query, header, formData, body)
  let scheme = call_579207.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579207.url(scheme.get, call_579207.host, call_579207.base,
                         call_579207.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579207, url, valid)

proc call*(call_579208: Call_FusiontablesTableReplaceRows_579191; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          isStrict: bool = false; startLine: int = 0; endLine: int = 0;
          encoding: string = ""; fields: string = ""; delimiter: string = ""): Recallable =
  ## fusiontablesTableReplaceRows
  ## Replaces rows of an existing table. Current rows remain visible until all replacement rows are ready.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   isStrict: bool
  ##           : Whether the imported CSV must have the same number of column values for each row. If true, throws an exception if the CSV does not have the same number of columns. If false, rows with fewer column values will be padded with empty values. Default is true.
  ##   tableId: string (required)
  ##          : Table whose rows will be replaced.
  ##   startLine: int
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  ##   endLine: int
  ##          : The index of the line up to which data will be imported. Default is to import the entire file. If endLine is negative, it is an offset from the end of the file; the imported content will exclude the last endLine lines.
  ##   encoding: string
  ##           : The encoding of the content. Default is UTF-8. Use 'auto-detect' if you are unsure of the encoding.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   delimiter: string
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  var path_579209 = newJObject()
  var query_579210 = newJObject()
  add(query_579210, "key", newJString(key))
  add(query_579210, "prettyPrint", newJBool(prettyPrint))
  add(query_579210, "oauth_token", newJString(oauthToken))
  add(query_579210, "alt", newJString(alt))
  add(query_579210, "userIp", newJString(userIp))
  add(query_579210, "quotaUser", newJString(quotaUser))
  add(query_579210, "isStrict", newJBool(isStrict))
  add(path_579209, "tableId", newJString(tableId))
  add(query_579210, "startLine", newJInt(startLine))
  add(query_579210, "endLine", newJInt(endLine))
  add(query_579210, "encoding", newJString(encoding))
  add(query_579210, "fields", newJString(fields))
  add(query_579210, "delimiter", newJString(delimiter))
  result = call_579208.call(path_579209, query_579210, nil, nil, nil)

var fusiontablesTableReplaceRows* = Call_FusiontablesTableReplaceRows_579191(
    name: "fusiontablesTableReplaceRows", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/replace",
    validator: validate_FusiontablesTableReplaceRows_579192,
    base: "/fusiontables/v2", url: url_FusiontablesTableReplaceRows_579193,
    schemes: {Scheme.Https})
type
  Call_FusiontablesStyleInsert_579228 = ref object of OpenApiRestCall_578355
proc url_FusiontablesStyleInsert_579230(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/styles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesStyleInsert_579229(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Adds a new style for the table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table for which a new style is being added
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579231 = path.getOrDefault("tableId")
  valid_579231 = validateParameter(valid_579231, JString, required = true,
                                 default = nil)
  if valid_579231 != nil:
    section.add "tableId", valid_579231
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579232 = query.getOrDefault("key")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = nil)
  if valid_579232 != nil:
    section.add "key", valid_579232
  var valid_579233 = query.getOrDefault("prettyPrint")
  valid_579233 = validateParameter(valid_579233, JBool, required = false,
                                 default = newJBool(true))
  if valid_579233 != nil:
    section.add "prettyPrint", valid_579233
  var valid_579234 = query.getOrDefault("oauth_token")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "oauth_token", valid_579234
  var valid_579235 = query.getOrDefault("alt")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = newJString("json"))
  if valid_579235 != nil:
    section.add "alt", valid_579235
  var valid_579236 = query.getOrDefault("userIp")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "userIp", valid_579236
  var valid_579237 = query.getOrDefault("quotaUser")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "quotaUser", valid_579237
  var valid_579238 = query.getOrDefault("fields")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "fields", valid_579238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579240: Call_FusiontablesStyleInsert_579228; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new style for the table.
  ## 
  let valid = call_579240.validator(path, query, header, formData, body)
  let scheme = call_579240.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579240.url(scheme.get, call_579240.host, call_579240.base,
                         call_579240.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579240, url, valid)

proc call*(call_579241: Call_FusiontablesStyleInsert_579228; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesStyleInsert
  ## Adds a new style for the table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table for which a new style is being added
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579242 = newJObject()
  var query_579243 = newJObject()
  var body_579244 = newJObject()
  add(query_579243, "key", newJString(key))
  add(query_579243, "prettyPrint", newJBool(prettyPrint))
  add(query_579243, "oauth_token", newJString(oauthToken))
  add(query_579243, "alt", newJString(alt))
  add(query_579243, "userIp", newJString(userIp))
  add(query_579243, "quotaUser", newJString(quotaUser))
  add(path_579242, "tableId", newJString(tableId))
  if body != nil:
    body_579244 = body
  add(query_579243, "fields", newJString(fields))
  result = call_579241.call(path_579242, query_579243, nil, nil, body_579244)

var fusiontablesStyleInsert* = Call_FusiontablesStyleInsert_579228(
    name: "fusiontablesStyleInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles",
    validator: validate_FusiontablesStyleInsert_579229, base: "/fusiontables/v2",
    url: url_FusiontablesStyleInsert_579230, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleList_579211 = ref object of OpenApiRestCall_578355
proc url_FusiontablesStyleList_579213(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/styles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesStyleList_579212(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of styles.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table whose styles are being listed
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579214 = path.getOrDefault("tableId")
  valid_579214 = validateParameter(valid_579214, JString, required = true,
                                 default = nil)
  if valid_579214 != nil:
    section.add "tableId", valid_579214
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token specifying which result page to return. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of styles to return. Optional. Default is 5.
  section = newJObject()
  var valid_579215 = query.getOrDefault("key")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "key", valid_579215
  var valid_579216 = query.getOrDefault("prettyPrint")
  valid_579216 = validateParameter(valid_579216, JBool, required = false,
                                 default = newJBool(true))
  if valid_579216 != nil:
    section.add "prettyPrint", valid_579216
  var valid_579217 = query.getOrDefault("oauth_token")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "oauth_token", valid_579217
  var valid_579218 = query.getOrDefault("alt")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = newJString("json"))
  if valid_579218 != nil:
    section.add "alt", valid_579218
  var valid_579219 = query.getOrDefault("userIp")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "userIp", valid_579219
  var valid_579220 = query.getOrDefault("quotaUser")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "quotaUser", valid_579220
  var valid_579221 = query.getOrDefault("pageToken")
  valid_579221 = validateParameter(valid_579221, JString, required = false,
                                 default = nil)
  if valid_579221 != nil:
    section.add "pageToken", valid_579221
  var valid_579222 = query.getOrDefault("fields")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "fields", valid_579222
  var valid_579223 = query.getOrDefault("maxResults")
  valid_579223 = validateParameter(valid_579223, JInt, required = false, default = nil)
  if valid_579223 != nil:
    section.add "maxResults", valid_579223
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579224: Call_FusiontablesStyleList_579211; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of styles.
  ## 
  let valid = call_579224.validator(path, query, header, formData, body)
  let scheme = call_579224.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579224.url(scheme.get, call_579224.host, call_579224.base,
                         call_579224.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579224, url, valid)

proc call*(call_579225: Call_FusiontablesStyleList_579211; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## fusiontablesStyleList
  ## Retrieves a list of styles.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token specifying which result page to return. Optional.
  ##   tableId: string (required)
  ##          : Table whose styles are being listed
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of styles to return. Optional. Default is 5.
  var path_579226 = newJObject()
  var query_579227 = newJObject()
  add(query_579227, "key", newJString(key))
  add(query_579227, "prettyPrint", newJBool(prettyPrint))
  add(query_579227, "oauth_token", newJString(oauthToken))
  add(query_579227, "alt", newJString(alt))
  add(query_579227, "userIp", newJString(userIp))
  add(query_579227, "quotaUser", newJString(quotaUser))
  add(query_579227, "pageToken", newJString(pageToken))
  add(path_579226, "tableId", newJString(tableId))
  add(query_579227, "fields", newJString(fields))
  add(query_579227, "maxResults", newJInt(maxResults))
  result = call_579225.call(path_579226, query_579227, nil, nil, nil)

var fusiontablesStyleList* = Call_FusiontablesStyleList_579211(
    name: "fusiontablesStyleList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles",
    validator: validate_FusiontablesStyleList_579212, base: "/fusiontables/v2",
    url: url_FusiontablesStyleList_579213, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleUpdate_579261 = ref object of OpenApiRestCall_578355
proc url_FusiontablesStyleUpdate_579263(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "styleId" in path, "`styleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/styles/"),
               (kind: VariableSegment, value: "styleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesStyleUpdate_579262(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing style.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table whose style is being updated.
  ##   styleId: JInt (required)
  ##          : Identifier (within a table) for the style being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579264 = path.getOrDefault("tableId")
  valid_579264 = validateParameter(valid_579264, JString, required = true,
                                 default = nil)
  if valid_579264 != nil:
    section.add "tableId", valid_579264
  var valid_579265 = path.getOrDefault("styleId")
  valid_579265 = validateParameter(valid_579265, JInt, required = true, default = nil)
  if valid_579265 != nil:
    section.add "styleId", valid_579265
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579266 = query.getOrDefault("key")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = nil)
  if valid_579266 != nil:
    section.add "key", valid_579266
  var valid_579267 = query.getOrDefault("prettyPrint")
  valid_579267 = validateParameter(valid_579267, JBool, required = false,
                                 default = newJBool(true))
  if valid_579267 != nil:
    section.add "prettyPrint", valid_579267
  var valid_579268 = query.getOrDefault("oauth_token")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "oauth_token", valid_579268
  var valid_579269 = query.getOrDefault("alt")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = newJString("json"))
  if valid_579269 != nil:
    section.add "alt", valid_579269
  var valid_579270 = query.getOrDefault("userIp")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "userIp", valid_579270
  var valid_579271 = query.getOrDefault("quotaUser")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "quotaUser", valid_579271
  var valid_579272 = query.getOrDefault("fields")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "fields", valid_579272
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579274: Call_FusiontablesStyleUpdate_579261; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing style.
  ## 
  let valid = call_579274.validator(path, query, header, formData, body)
  let scheme = call_579274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579274.url(scheme.get, call_579274.host, call_579274.base,
                         call_579274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579274, url, valid)

proc call*(call_579275: Call_FusiontablesStyleUpdate_579261; tableId: string;
          styleId: int; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesStyleUpdate
  ## Updates an existing style.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table whose style is being updated.
  ##   body: JObject
  ##   styleId: int (required)
  ##          : Identifier (within a table) for the style being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579276 = newJObject()
  var query_579277 = newJObject()
  var body_579278 = newJObject()
  add(query_579277, "key", newJString(key))
  add(query_579277, "prettyPrint", newJBool(prettyPrint))
  add(query_579277, "oauth_token", newJString(oauthToken))
  add(query_579277, "alt", newJString(alt))
  add(query_579277, "userIp", newJString(userIp))
  add(query_579277, "quotaUser", newJString(quotaUser))
  add(path_579276, "tableId", newJString(tableId))
  if body != nil:
    body_579278 = body
  add(path_579276, "styleId", newJInt(styleId))
  add(query_579277, "fields", newJString(fields))
  result = call_579275.call(path_579276, query_579277, nil, nil, body_579278)

var fusiontablesStyleUpdate* = Call_FusiontablesStyleUpdate_579261(
    name: "fusiontablesStyleUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleUpdate_579262, base: "/fusiontables/v2",
    url: url_FusiontablesStyleUpdate_579263, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleGet_579245 = ref object of OpenApiRestCall_578355
proc url_FusiontablesStyleGet_579247(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "styleId" in path, "`styleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/styles/"),
               (kind: VariableSegment, value: "styleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesStyleGet_579246(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets a specific style.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table to which the requested style belongs
  ##   styleId: JInt (required)
  ##          : Identifier (integer) for a specific style in a table
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579248 = path.getOrDefault("tableId")
  valid_579248 = validateParameter(valid_579248, JString, required = true,
                                 default = nil)
  if valid_579248 != nil:
    section.add "tableId", valid_579248
  var valid_579249 = path.getOrDefault("styleId")
  valid_579249 = validateParameter(valid_579249, JInt, required = true, default = nil)
  if valid_579249 != nil:
    section.add "styleId", valid_579249
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579250 = query.getOrDefault("key")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "key", valid_579250
  var valid_579251 = query.getOrDefault("prettyPrint")
  valid_579251 = validateParameter(valid_579251, JBool, required = false,
                                 default = newJBool(true))
  if valid_579251 != nil:
    section.add "prettyPrint", valid_579251
  var valid_579252 = query.getOrDefault("oauth_token")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "oauth_token", valid_579252
  var valid_579253 = query.getOrDefault("alt")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = newJString("json"))
  if valid_579253 != nil:
    section.add "alt", valid_579253
  var valid_579254 = query.getOrDefault("userIp")
  valid_579254 = validateParameter(valid_579254, JString, required = false,
                                 default = nil)
  if valid_579254 != nil:
    section.add "userIp", valid_579254
  var valid_579255 = query.getOrDefault("quotaUser")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = nil)
  if valid_579255 != nil:
    section.add "quotaUser", valid_579255
  var valid_579256 = query.getOrDefault("fields")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "fields", valid_579256
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579257: Call_FusiontablesStyleGet_579245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific style.
  ## 
  let valid = call_579257.validator(path, query, header, formData, body)
  let scheme = call_579257.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579257.url(scheme.get, call_579257.host, call_579257.base,
                         call_579257.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579257, url, valid)

proc call*(call_579258: Call_FusiontablesStyleGet_579245; tableId: string;
          styleId: int; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## fusiontablesStyleGet
  ## Gets a specific style.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table to which the requested style belongs
  ##   styleId: int (required)
  ##          : Identifier (integer) for a specific style in a table
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579259 = newJObject()
  var query_579260 = newJObject()
  add(query_579260, "key", newJString(key))
  add(query_579260, "prettyPrint", newJBool(prettyPrint))
  add(query_579260, "oauth_token", newJString(oauthToken))
  add(query_579260, "alt", newJString(alt))
  add(query_579260, "userIp", newJString(userIp))
  add(query_579260, "quotaUser", newJString(quotaUser))
  add(path_579259, "tableId", newJString(tableId))
  add(path_579259, "styleId", newJInt(styleId))
  add(query_579260, "fields", newJString(fields))
  result = call_579258.call(path_579259, query_579260, nil, nil, nil)

var fusiontablesStyleGet* = Call_FusiontablesStyleGet_579245(
    name: "fusiontablesStyleGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleGet_579246, base: "/fusiontables/v2",
    url: url_FusiontablesStyleGet_579247, schemes: {Scheme.Https})
type
  Call_FusiontablesStylePatch_579295 = ref object of OpenApiRestCall_578355
proc url_FusiontablesStylePatch_579297(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "styleId" in path, "`styleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/styles/"),
               (kind: VariableSegment, value: "styleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesStylePatch_579296(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing style. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table whose style is being updated.
  ##   styleId: JInt (required)
  ##          : Identifier (within a table) for the style being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579298 = path.getOrDefault("tableId")
  valid_579298 = validateParameter(valid_579298, JString, required = true,
                                 default = nil)
  if valid_579298 != nil:
    section.add "tableId", valid_579298
  var valid_579299 = path.getOrDefault("styleId")
  valid_579299 = validateParameter(valid_579299, JInt, required = true, default = nil)
  if valid_579299 != nil:
    section.add "styleId", valid_579299
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579300 = query.getOrDefault("key")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "key", valid_579300
  var valid_579301 = query.getOrDefault("prettyPrint")
  valid_579301 = validateParameter(valid_579301, JBool, required = false,
                                 default = newJBool(true))
  if valid_579301 != nil:
    section.add "prettyPrint", valid_579301
  var valid_579302 = query.getOrDefault("oauth_token")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "oauth_token", valid_579302
  var valid_579303 = query.getOrDefault("alt")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = newJString("json"))
  if valid_579303 != nil:
    section.add "alt", valid_579303
  var valid_579304 = query.getOrDefault("userIp")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "userIp", valid_579304
  var valid_579305 = query.getOrDefault("quotaUser")
  valid_579305 = validateParameter(valid_579305, JString, required = false,
                                 default = nil)
  if valid_579305 != nil:
    section.add "quotaUser", valid_579305
  var valid_579306 = query.getOrDefault("fields")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "fields", valid_579306
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579308: Call_FusiontablesStylePatch_579295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing style. This method supports patch semantics.
  ## 
  let valid = call_579308.validator(path, query, header, formData, body)
  let scheme = call_579308.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579308.url(scheme.get, call_579308.host, call_579308.base,
                         call_579308.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579308, url, valid)

proc call*(call_579309: Call_FusiontablesStylePatch_579295; tableId: string;
          styleId: int; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesStylePatch
  ## Updates an existing style. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table whose style is being updated.
  ##   body: JObject
  ##   styleId: int (required)
  ##          : Identifier (within a table) for the style being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579310 = newJObject()
  var query_579311 = newJObject()
  var body_579312 = newJObject()
  add(query_579311, "key", newJString(key))
  add(query_579311, "prettyPrint", newJBool(prettyPrint))
  add(query_579311, "oauth_token", newJString(oauthToken))
  add(query_579311, "alt", newJString(alt))
  add(query_579311, "userIp", newJString(userIp))
  add(query_579311, "quotaUser", newJString(quotaUser))
  add(path_579310, "tableId", newJString(tableId))
  if body != nil:
    body_579312 = body
  add(path_579310, "styleId", newJInt(styleId))
  add(query_579311, "fields", newJString(fields))
  result = call_579309.call(path_579310, query_579311, nil, nil, body_579312)

var fusiontablesStylePatch* = Call_FusiontablesStylePatch_579295(
    name: "fusiontablesStylePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStylePatch_579296, base: "/fusiontables/v2",
    url: url_FusiontablesStylePatch_579297, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleDelete_579279 = ref object of OpenApiRestCall_578355
proc url_FusiontablesStyleDelete_579281(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "styleId" in path, "`styleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/styles/"),
               (kind: VariableSegment, value: "styleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesStyleDelete_579280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a style.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table from which the style is being deleted
  ##   styleId: JInt (required)
  ##          : Identifier (within a table) for the style being deleted
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579282 = path.getOrDefault("tableId")
  valid_579282 = validateParameter(valid_579282, JString, required = true,
                                 default = nil)
  if valid_579282 != nil:
    section.add "tableId", valid_579282
  var valid_579283 = path.getOrDefault("styleId")
  valid_579283 = validateParameter(valid_579283, JInt, required = true, default = nil)
  if valid_579283 != nil:
    section.add "styleId", valid_579283
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579284 = query.getOrDefault("key")
  valid_579284 = validateParameter(valid_579284, JString, required = false,
                                 default = nil)
  if valid_579284 != nil:
    section.add "key", valid_579284
  var valid_579285 = query.getOrDefault("prettyPrint")
  valid_579285 = validateParameter(valid_579285, JBool, required = false,
                                 default = newJBool(true))
  if valid_579285 != nil:
    section.add "prettyPrint", valid_579285
  var valid_579286 = query.getOrDefault("oauth_token")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = nil)
  if valid_579286 != nil:
    section.add "oauth_token", valid_579286
  var valid_579287 = query.getOrDefault("alt")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = newJString("json"))
  if valid_579287 != nil:
    section.add "alt", valid_579287
  var valid_579288 = query.getOrDefault("userIp")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "userIp", valid_579288
  var valid_579289 = query.getOrDefault("quotaUser")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "quotaUser", valid_579289
  var valid_579290 = query.getOrDefault("fields")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "fields", valid_579290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579291: Call_FusiontablesStyleDelete_579279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a style.
  ## 
  let valid = call_579291.validator(path, query, header, formData, body)
  let scheme = call_579291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579291.url(scheme.get, call_579291.host, call_579291.base,
                         call_579291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579291, url, valid)

proc call*(call_579292: Call_FusiontablesStyleDelete_579279; tableId: string;
          styleId: int; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## fusiontablesStyleDelete
  ## Deletes a style.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table from which the style is being deleted
  ##   styleId: int (required)
  ##          : Identifier (within a table) for the style being deleted
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579293 = newJObject()
  var query_579294 = newJObject()
  add(query_579294, "key", newJString(key))
  add(query_579294, "prettyPrint", newJBool(prettyPrint))
  add(query_579294, "oauth_token", newJString(oauthToken))
  add(query_579294, "alt", newJString(alt))
  add(query_579294, "userIp", newJString(userIp))
  add(query_579294, "quotaUser", newJString(quotaUser))
  add(path_579293, "tableId", newJString(tableId))
  add(path_579293, "styleId", newJInt(styleId))
  add(query_579294, "fields", newJString(fields))
  result = call_579292.call(path_579293, query_579294, nil, nil, nil)

var fusiontablesStyleDelete* = Call_FusiontablesStyleDelete_579279(
    name: "fusiontablesStyleDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleDelete_579280, base: "/fusiontables/v2",
    url: url_FusiontablesStyleDelete_579281, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskList_579313 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTaskList_579315(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/tasks")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTaskList_579314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of tasks.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table whose tasks are being listed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579316 = path.getOrDefault("tableId")
  valid_579316 = validateParameter(valid_579316, JString, required = true,
                                 default = nil)
  if valid_579316 != nil:
    section.add "tableId", valid_579316
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: JInt
  ##             : Index of the first result returned in the current page.
  ##   pageToken: JString
  ##            : Continuation token specifying which result page to return.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of tasks to return. Default is 5.
  section = newJObject()
  var valid_579317 = query.getOrDefault("key")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "key", valid_579317
  var valid_579318 = query.getOrDefault("prettyPrint")
  valid_579318 = validateParameter(valid_579318, JBool, required = false,
                                 default = newJBool(true))
  if valid_579318 != nil:
    section.add "prettyPrint", valid_579318
  var valid_579319 = query.getOrDefault("oauth_token")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "oauth_token", valid_579319
  var valid_579320 = query.getOrDefault("alt")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = newJString("json"))
  if valid_579320 != nil:
    section.add "alt", valid_579320
  var valid_579321 = query.getOrDefault("userIp")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "userIp", valid_579321
  var valid_579322 = query.getOrDefault("quotaUser")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "quotaUser", valid_579322
  var valid_579323 = query.getOrDefault("startIndex")
  valid_579323 = validateParameter(valid_579323, JInt, required = false, default = nil)
  if valid_579323 != nil:
    section.add "startIndex", valid_579323
  var valid_579324 = query.getOrDefault("pageToken")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "pageToken", valid_579324
  var valid_579325 = query.getOrDefault("fields")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "fields", valid_579325
  var valid_579326 = query.getOrDefault("maxResults")
  valid_579326 = validateParameter(valid_579326, JInt, required = false, default = nil)
  if valid_579326 != nil:
    section.add "maxResults", valid_579326
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579327: Call_FusiontablesTaskList_579313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of tasks.
  ## 
  let valid = call_579327.validator(path, query, header, formData, body)
  let scheme = call_579327.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579327.url(scheme.get, call_579327.host, call_579327.base,
                         call_579327.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579327, url, valid)

proc call*(call_579328: Call_FusiontablesTaskList_579313; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          startIndex: int = 0; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## fusiontablesTaskList
  ## Retrieves a list of tasks.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   startIndex: int
  ##             : Index of the first result returned in the current page.
  ##   pageToken: string
  ##            : Continuation token specifying which result page to return.
  ##   tableId: string (required)
  ##          : Table whose tasks are being listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of tasks to return. Default is 5.
  var path_579329 = newJObject()
  var query_579330 = newJObject()
  add(query_579330, "key", newJString(key))
  add(query_579330, "prettyPrint", newJBool(prettyPrint))
  add(query_579330, "oauth_token", newJString(oauthToken))
  add(query_579330, "alt", newJString(alt))
  add(query_579330, "userIp", newJString(userIp))
  add(query_579330, "quotaUser", newJString(quotaUser))
  add(query_579330, "startIndex", newJInt(startIndex))
  add(query_579330, "pageToken", newJString(pageToken))
  add(path_579329, "tableId", newJString(tableId))
  add(query_579330, "fields", newJString(fields))
  add(query_579330, "maxResults", newJInt(maxResults))
  result = call_579328.call(path_579329, query_579330, nil, nil, nil)

var fusiontablesTaskList* = Call_FusiontablesTaskList_579313(
    name: "fusiontablesTaskList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks",
    validator: validate_FusiontablesTaskList_579314, base: "/fusiontables/v2",
    url: url_FusiontablesTaskList_579315, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskGet_579331 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTaskGet_579333(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTaskGet_579332(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a specific task by its ID.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table to which the task belongs.
  ##   taskId: JString (required)
  ##         : The identifier of the task to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579334 = path.getOrDefault("tableId")
  valid_579334 = validateParameter(valid_579334, JString, required = true,
                                 default = nil)
  if valid_579334 != nil:
    section.add "tableId", valid_579334
  var valid_579335 = path.getOrDefault("taskId")
  valid_579335 = validateParameter(valid_579335, JString, required = true,
                                 default = nil)
  if valid_579335 != nil:
    section.add "taskId", valid_579335
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579336 = query.getOrDefault("key")
  valid_579336 = validateParameter(valid_579336, JString, required = false,
                                 default = nil)
  if valid_579336 != nil:
    section.add "key", valid_579336
  var valid_579337 = query.getOrDefault("prettyPrint")
  valid_579337 = validateParameter(valid_579337, JBool, required = false,
                                 default = newJBool(true))
  if valid_579337 != nil:
    section.add "prettyPrint", valid_579337
  var valid_579338 = query.getOrDefault("oauth_token")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = nil)
  if valid_579338 != nil:
    section.add "oauth_token", valid_579338
  var valid_579339 = query.getOrDefault("alt")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = newJString("json"))
  if valid_579339 != nil:
    section.add "alt", valid_579339
  var valid_579340 = query.getOrDefault("userIp")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "userIp", valid_579340
  var valid_579341 = query.getOrDefault("quotaUser")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "quotaUser", valid_579341
  var valid_579342 = query.getOrDefault("fields")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "fields", valid_579342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579343: Call_FusiontablesTaskGet_579331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific task by its ID.
  ## 
  let valid = call_579343.validator(path, query, header, formData, body)
  let scheme = call_579343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579343.url(scheme.get, call_579343.host, call_579343.base,
                         call_579343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579343, url, valid)

proc call*(call_579344: Call_FusiontablesTaskGet_579331; tableId: string;
          taskId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## fusiontablesTaskGet
  ## Retrieves a specific task by its ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table to which the task belongs.
  ##   taskId: string (required)
  ##         : The identifier of the task to get.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579345 = newJObject()
  var query_579346 = newJObject()
  add(query_579346, "key", newJString(key))
  add(query_579346, "prettyPrint", newJBool(prettyPrint))
  add(query_579346, "oauth_token", newJString(oauthToken))
  add(query_579346, "alt", newJString(alt))
  add(query_579346, "userIp", newJString(userIp))
  add(query_579346, "quotaUser", newJString(quotaUser))
  add(path_579345, "tableId", newJString(tableId))
  add(path_579345, "taskId", newJString(taskId))
  add(query_579346, "fields", newJString(fields))
  result = call_579344.call(path_579345, query_579346, nil, nil, nil)

var fusiontablesTaskGet* = Call_FusiontablesTaskGet_579331(
    name: "fusiontablesTaskGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks/{taskId}",
    validator: validate_FusiontablesTaskGet_579332, base: "/fusiontables/v2",
    url: url_FusiontablesTaskGet_579333, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskDelete_579347 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTaskDelete_579349(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "taskId" in path, "`taskId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/tasks/"),
               (kind: VariableSegment, value: "taskId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTaskDelete_579348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specific task by its ID, unless that task has already started running.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table from which the task is being deleted.
  ##   taskId: JString (required)
  ##         : The identifier of the task to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579350 = path.getOrDefault("tableId")
  valid_579350 = validateParameter(valid_579350, JString, required = true,
                                 default = nil)
  if valid_579350 != nil:
    section.add "tableId", valid_579350
  var valid_579351 = path.getOrDefault("taskId")
  valid_579351 = validateParameter(valid_579351, JString, required = true,
                                 default = nil)
  if valid_579351 != nil:
    section.add "taskId", valid_579351
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579352 = query.getOrDefault("key")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "key", valid_579352
  var valid_579353 = query.getOrDefault("prettyPrint")
  valid_579353 = validateParameter(valid_579353, JBool, required = false,
                                 default = newJBool(true))
  if valid_579353 != nil:
    section.add "prettyPrint", valid_579353
  var valid_579354 = query.getOrDefault("oauth_token")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "oauth_token", valid_579354
  var valid_579355 = query.getOrDefault("alt")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = newJString("json"))
  if valid_579355 != nil:
    section.add "alt", valid_579355
  var valid_579356 = query.getOrDefault("userIp")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "userIp", valid_579356
  var valid_579357 = query.getOrDefault("quotaUser")
  valid_579357 = validateParameter(valid_579357, JString, required = false,
                                 default = nil)
  if valid_579357 != nil:
    section.add "quotaUser", valid_579357
  var valid_579358 = query.getOrDefault("fields")
  valid_579358 = validateParameter(valid_579358, JString, required = false,
                                 default = nil)
  if valid_579358 != nil:
    section.add "fields", valid_579358
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579359: Call_FusiontablesTaskDelete_579347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific task by its ID, unless that task has already started running.
  ## 
  let valid = call_579359.validator(path, query, header, formData, body)
  let scheme = call_579359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579359.url(scheme.get, call_579359.host, call_579359.base,
                         call_579359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579359, url, valid)

proc call*(call_579360: Call_FusiontablesTaskDelete_579347; tableId: string;
          taskId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## fusiontablesTaskDelete
  ## Deletes a specific task by its ID, unless that task has already started running.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table from which the task is being deleted.
  ##   taskId: string (required)
  ##         : The identifier of the task to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579361 = newJObject()
  var query_579362 = newJObject()
  add(query_579362, "key", newJString(key))
  add(query_579362, "prettyPrint", newJBool(prettyPrint))
  add(query_579362, "oauth_token", newJString(oauthToken))
  add(query_579362, "alt", newJString(alt))
  add(query_579362, "userIp", newJString(userIp))
  add(query_579362, "quotaUser", newJString(quotaUser))
  add(path_579361, "tableId", newJString(tableId))
  add(path_579361, "taskId", newJString(taskId))
  add(query_579362, "fields", newJString(fields))
  result = call_579360.call(path_579361, query_579362, nil, nil, nil)

var fusiontablesTaskDelete* = Call_FusiontablesTaskDelete_579347(
    name: "fusiontablesTaskDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks/{taskId}",
    validator: validate_FusiontablesTaskDelete_579348, base: "/fusiontables/v2",
    url: url_FusiontablesTaskDelete_579349, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateInsert_579380 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTemplateInsert_579382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/templates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTemplateInsert_579381(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new template for the table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table for which a new template is being created
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579383 = path.getOrDefault("tableId")
  valid_579383 = validateParameter(valid_579383, JString, required = true,
                                 default = nil)
  if valid_579383 != nil:
    section.add "tableId", valid_579383
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579384 = query.getOrDefault("key")
  valid_579384 = validateParameter(valid_579384, JString, required = false,
                                 default = nil)
  if valid_579384 != nil:
    section.add "key", valid_579384
  var valid_579385 = query.getOrDefault("prettyPrint")
  valid_579385 = validateParameter(valid_579385, JBool, required = false,
                                 default = newJBool(true))
  if valid_579385 != nil:
    section.add "prettyPrint", valid_579385
  var valid_579386 = query.getOrDefault("oauth_token")
  valid_579386 = validateParameter(valid_579386, JString, required = false,
                                 default = nil)
  if valid_579386 != nil:
    section.add "oauth_token", valid_579386
  var valid_579387 = query.getOrDefault("alt")
  valid_579387 = validateParameter(valid_579387, JString, required = false,
                                 default = newJString("json"))
  if valid_579387 != nil:
    section.add "alt", valid_579387
  var valid_579388 = query.getOrDefault("userIp")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "userIp", valid_579388
  var valid_579389 = query.getOrDefault("quotaUser")
  valid_579389 = validateParameter(valid_579389, JString, required = false,
                                 default = nil)
  if valid_579389 != nil:
    section.add "quotaUser", valid_579389
  var valid_579390 = query.getOrDefault("fields")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "fields", valid_579390
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579392: Call_FusiontablesTemplateInsert_579380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new template for the table.
  ## 
  let valid = call_579392.validator(path, query, header, formData, body)
  let scheme = call_579392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579392.url(scheme.get, call_579392.host, call_579392.base,
                         call_579392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579392, url, valid)

proc call*(call_579393: Call_FusiontablesTemplateInsert_579380; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesTemplateInsert
  ## Creates a new template for the table.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table for which a new template is being created
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579394 = newJObject()
  var query_579395 = newJObject()
  var body_579396 = newJObject()
  add(query_579395, "key", newJString(key))
  add(query_579395, "prettyPrint", newJBool(prettyPrint))
  add(query_579395, "oauth_token", newJString(oauthToken))
  add(query_579395, "alt", newJString(alt))
  add(query_579395, "userIp", newJString(userIp))
  add(query_579395, "quotaUser", newJString(quotaUser))
  add(path_579394, "tableId", newJString(tableId))
  if body != nil:
    body_579396 = body
  add(query_579395, "fields", newJString(fields))
  result = call_579393.call(path_579394, query_579395, nil, nil, body_579396)

var fusiontablesTemplateInsert* = Call_FusiontablesTemplateInsert_579380(
    name: "fusiontablesTemplateInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates",
    validator: validate_FusiontablesTemplateInsert_579381,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateInsert_579382,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateList_579363 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTemplateList_579365(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/templates")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTemplateList_579364(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of templates.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Identifier for the table whose templates are being requested
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579366 = path.getOrDefault("tableId")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "tableId", valid_579366
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Continuation token specifying which results page to return. Optional.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of templates to return. Optional. Default is 5.
  section = newJObject()
  var valid_579367 = query.getOrDefault("key")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "key", valid_579367
  var valid_579368 = query.getOrDefault("prettyPrint")
  valid_579368 = validateParameter(valid_579368, JBool, required = false,
                                 default = newJBool(true))
  if valid_579368 != nil:
    section.add "prettyPrint", valid_579368
  var valid_579369 = query.getOrDefault("oauth_token")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "oauth_token", valid_579369
  var valid_579370 = query.getOrDefault("alt")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = newJString("json"))
  if valid_579370 != nil:
    section.add "alt", valid_579370
  var valid_579371 = query.getOrDefault("userIp")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = nil)
  if valid_579371 != nil:
    section.add "userIp", valid_579371
  var valid_579372 = query.getOrDefault("quotaUser")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "quotaUser", valid_579372
  var valid_579373 = query.getOrDefault("pageToken")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "pageToken", valid_579373
  var valid_579374 = query.getOrDefault("fields")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "fields", valid_579374
  var valid_579375 = query.getOrDefault("maxResults")
  valid_579375 = validateParameter(valid_579375, JInt, required = false, default = nil)
  if valid_579375 != nil:
    section.add "maxResults", valid_579375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579376: Call_FusiontablesTemplateList_579363; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of templates.
  ## 
  let valid = call_579376.validator(path, query, header, formData, body)
  let scheme = call_579376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579376.url(scheme.get, call_579376.host, call_579376.base,
                         call_579376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579376, url, valid)

proc call*(call_579377: Call_FusiontablesTemplateList_579363; tableId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## fusiontablesTemplateList
  ## Retrieves a list of templates.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Continuation token specifying which results page to return. Optional.
  ##   tableId: string (required)
  ##          : Identifier for the table whose templates are being requested
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of templates to return. Optional. Default is 5.
  var path_579378 = newJObject()
  var query_579379 = newJObject()
  add(query_579379, "key", newJString(key))
  add(query_579379, "prettyPrint", newJBool(prettyPrint))
  add(query_579379, "oauth_token", newJString(oauthToken))
  add(query_579379, "alt", newJString(alt))
  add(query_579379, "userIp", newJString(userIp))
  add(query_579379, "quotaUser", newJString(quotaUser))
  add(query_579379, "pageToken", newJString(pageToken))
  add(path_579378, "tableId", newJString(tableId))
  add(query_579379, "fields", newJString(fields))
  add(query_579379, "maxResults", newJInt(maxResults))
  result = call_579377.call(path_579378, query_579379, nil, nil, nil)

var fusiontablesTemplateList* = Call_FusiontablesTemplateList_579363(
    name: "fusiontablesTemplateList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates",
    validator: validate_FusiontablesTemplateList_579364, base: "/fusiontables/v2",
    url: url_FusiontablesTemplateList_579365, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateUpdate_579413 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTemplateUpdate_579415(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "templateId" in path, "`templateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/templates/"),
               (kind: VariableSegment, value: "templateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTemplateUpdate_579414(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table to which the updated template belongs
  ##   templateId: JInt (required)
  ##             : Identifier for the template that is being updated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579416 = path.getOrDefault("tableId")
  valid_579416 = validateParameter(valid_579416, JString, required = true,
                                 default = nil)
  if valid_579416 != nil:
    section.add "tableId", valid_579416
  var valid_579417 = path.getOrDefault("templateId")
  valid_579417 = validateParameter(valid_579417, JInt, required = true, default = nil)
  if valid_579417 != nil:
    section.add "templateId", valid_579417
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579418 = query.getOrDefault("key")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "key", valid_579418
  var valid_579419 = query.getOrDefault("prettyPrint")
  valid_579419 = validateParameter(valid_579419, JBool, required = false,
                                 default = newJBool(true))
  if valid_579419 != nil:
    section.add "prettyPrint", valid_579419
  var valid_579420 = query.getOrDefault("oauth_token")
  valid_579420 = validateParameter(valid_579420, JString, required = false,
                                 default = nil)
  if valid_579420 != nil:
    section.add "oauth_token", valid_579420
  var valid_579421 = query.getOrDefault("alt")
  valid_579421 = validateParameter(valid_579421, JString, required = false,
                                 default = newJString("json"))
  if valid_579421 != nil:
    section.add "alt", valid_579421
  var valid_579422 = query.getOrDefault("userIp")
  valid_579422 = validateParameter(valid_579422, JString, required = false,
                                 default = nil)
  if valid_579422 != nil:
    section.add "userIp", valid_579422
  var valid_579423 = query.getOrDefault("quotaUser")
  valid_579423 = validateParameter(valid_579423, JString, required = false,
                                 default = nil)
  if valid_579423 != nil:
    section.add "quotaUser", valid_579423
  var valid_579424 = query.getOrDefault("fields")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "fields", valid_579424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579426: Call_FusiontablesTemplateUpdate_579413; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing template
  ## 
  let valid = call_579426.validator(path, query, header, formData, body)
  let scheme = call_579426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579426.url(scheme.get, call_579426.host, call_579426.base,
                         call_579426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579426, url, valid)

proc call*(call_579427: Call_FusiontablesTemplateUpdate_579413; tableId: string;
          templateId: int; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesTemplateUpdate
  ## Updates an existing template
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table to which the updated template belongs
  ##   templateId: int (required)
  ##             : Identifier for the template that is being updated
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579428 = newJObject()
  var query_579429 = newJObject()
  var body_579430 = newJObject()
  add(query_579429, "key", newJString(key))
  add(query_579429, "prettyPrint", newJBool(prettyPrint))
  add(query_579429, "oauth_token", newJString(oauthToken))
  add(query_579429, "alt", newJString(alt))
  add(query_579429, "userIp", newJString(userIp))
  add(query_579429, "quotaUser", newJString(quotaUser))
  add(path_579428, "tableId", newJString(tableId))
  add(path_579428, "templateId", newJInt(templateId))
  if body != nil:
    body_579430 = body
  add(query_579429, "fields", newJString(fields))
  result = call_579427.call(path_579428, query_579429, nil, nil, body_579430)

var fusiontablesTemplateUpdate* = Call_FusiontablesTemplateUpdate_579413(
    name: "fusiontablesTemplateUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateUpdate_579414,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateUpdate_579415,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateGet_579397 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTemplateGet_579399(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "templateId" in path, "`templateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/templates/"),
               (kind: VariableSegment, value: "templateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTemplateGet_579398(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a specific template by its id
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table to which the template belongs
  ##   templateId: JInt (required)
  ##             : Identifier for the template that is being requested
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579400 = path.getOrDefault("tableId")
  valid_579400 = validateParameter(valid_579400, JString, required = true,
                                 default = nil)
  if valid_579400 != nil:
    section.add "tableId", valid_579400
  var valid_579401 = path.getOrDefault("templateId")
  valid_579401 = validateParameter(valid_579401, JInt, required = true, default = nil)
  if valid_579401 != nil:
    section.add "templateId", valid_579401
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579402 = query.getOrDefault("key")
  valid_579402 = validateParameter(valid_579402, JString, required = false,
                                 default = nil)
  if valid_579402 != nil:
    section.add "key", valid_579402
  var valid_579403 = query.getOrDefault("prettyPrint")
  valid_579403 = validateParameter(valid_579403, JBool, required = false,
                                 default = newJBool(true))
  if valid_579403 != nil:
    section.add "prettyPrint", valid_579403
  var valid_579404 = query.getOrDefault("oauth_token")
  valid_579404 = validateParameter(valid_579404, JString, required = false,
                                 default = nil)
  if valid_579404 != nil:
    section.add "oauth_token", valid_579404
  var valid_579405 = query.getOrDefault("alt")
  valid_579405 = validateParameter(valid_579405, JString, required = false,
                                 default = newJString("json"))
  if valid_579405 != nil:
    section.add "alt", valid_579405
  var valid_579406 = query.getOrDefault("userIp")
  valid_579406 = validateParameter(valid_579406, JString, required = false,
                                 default = nil)
  if valid_579406 != nil:
    section.add "userIp", valid_579406
  var valid_579407 = query.getOrDefault("quotaUser")
  valid_579407 = validateParameter(valid_579407, JString, required = false,
                                 default = nil)
  if valid_579407 != nil:
    section.add "quotaUser", valid_579407
  var valid_579408 = query.getOrDefault("fields")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "fields", valid_579408
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579409: Call_FusiontablesTemplateGet_579397; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific template by its id
  ## 
  let valid = call_579409.validator(path, query, header, formData, body)
  let scheme = call_579409.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579409.url(scheme.get, call_579409.host, call_579409.base,
                         call_579409.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579409, url, valid)

proc call*(call_579410: Call_FusiontablesTemplateGet_579397; tableId: string;
          templateId: int; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## fusiontablesTemplateGet
  ## Retrieves a specific template by its id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table to which the template belongs
  ##   templateId: int (required)
  ##             : Identifier for the template that is being requested
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579411 = newJObject()
  var query_579412 = newJObject()
  add(query_579412, "key", newJString(key))
  add(query_579412, "prettyPrint", newJBool(prettyPrint))
  add(query_579412, "oauth_token", newJString(oauthToken))
  add(query_579412, "alt", newJString(alt))
  add(query_579412, "userIp", newJString(userIp))
  add(query_579412, "quotaUser", newJString(quotaUser))
  add(path_579411, "tableId", newJString(tableId))
  add(path_579411, "templateId", newJInt(templateId))
  add(query_579412, "fields", newJString(fields))
  result = call_579410.call(path_579411, query_579412, nil, nil, nil)

var fusiontablesTemplateGet* = Call_FusiontablesTemplateGet_579397(
    name: "fusiontablesTemplateGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateGet_579398, base: "/fusiontables/v2",
    url: url_FusiontablesTemplateGet_579399, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplatePatch_579447 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTemplatePatch_579449(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "templateId" in path, "`templateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/templates/"),
               (kind: VariableSegment, value: "templateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTemplatePatch_579448(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an existing template. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table to which the updated template belongs
  ##   templateId: JInt (required)
  ##             : Identifier for the template that is being updated
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579450 = path.getOrDefault("tableId")
  valid_579450 = validateParameter(valid_579450, JString, required = true,
                                 default = nil)
  if valid_579450 != nil:
    section.add "tableId", valid_579450
  var valid_579451 = path.getOrDefault("templateId")
  valid_579451 = validateParameter(valid_579451, JInt, required = true, default = nil)
  if valid_579451 != nil:
    section.add "templateId", valid_579451
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579452 = query.getOrDefault("key")
  valid_579452 = validateParameter(valid_579452, JString, required = false,
                                 default = nil)
  if valid_579452 != nil:
    section.add "key", valid_579452
  var valid_579453 = query.getOrDefault("prettyPrint")
  valid_579453 = validateParameter(valid_579453, JBool, required = false,
                                 default = newJBool(true))
  if valid_579453 != nil:
    section.add "prettyPrint", valid_579453
  var valid_579454 = query.getOrDefault("oauth_token")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = nil)
  if valid_579454 != nil:
    section.add "oauth_token", valid_579454
  var valid_579455 = query.getOrDefault("alt")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = newJString("json"))
  if valid_579455 != nil:
    section.add "alt", valid_579455
  var valid_579456 = query.getOrDefault("userIp")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "userIp", valid_579456
  var valid_579457 = query.getOrDefault("quotaUser")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "quotaUser", valid_579457
  var valid_579458 = query.getOrDefault("fields")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "fields", valid_579458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579460: Call_FusiontablesTemplatePatch_579447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing template. This method supports patch semantics.
  ## 
  let valid = call_579460.validator(path, query, header, formData, body)
  let scheme = call_579460.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579460.url(scheme.get, call_579460.host, call_579460.base,
                         call_579460.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579460, url, valid)

proc call*(call_579461: Call_FusiontablesTemplatePatch_579447; tableId: string;
          templateId: int; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## fusiontablesTemplatePatch
  ## Updates an existing template. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table to which the updated template belongs
  ##   templateId: int (required)
  ##             : Identifier for the template that is being updated
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579462 = newJObject()
  var query_579463 = newJObject()
  var body_579464 = newJObject()
  add(query_579463, "key", newJString(key))
  add(query_579463, "prettyPrint", newJBool(prettyPrint))
  add(query_579463, "oauth_token", newJString(oauthToken))
  add(query_579463, "alt", newJString(alt))
  add(query_579463, "userIp", newJString(userIp))
  add(query_579463, "quotaUser", newJString(quotaUser))
  add(path_579462, "tableId", newJString(tableId))
  add(path_579462, "templateId", newJInt(templateId))
  if body != nil:
    body_579464 = body
  add(query_579463, "fields", newJString(fields))
  result = call_579461.call(path_579462, query_579463, nil, nil, body_579464)

var fusiontablesTemplatePatch* = Call_FusiontablesTemplatePatch_579447(
    name: "fusiontablesTemplatePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplatePatch_579448,
    base: "/fusiontables/v2", url: url_FusiontablesTemplatePatch_579449,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateDelete_579431 = ref object of OpenApiRestCall_578355
proc url_FusiontablesTemplateDelete_579433(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  assert "templateId" in path, "`templateId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId"),
               (kind: ConstantSegment, value: "/templates/"),
               (kind: VariableSegment, value: "templateId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTemplateDelete_579432(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a template
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table from which the template is being deleted
  ##   templateId: JInt (required)
  ##             : Identifier for the template which is being deleted
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_579434 = path.getOrDefault("tableId")
  valid_579434 = validateParameter(valid_579434, JString, required = true,
                                 default = nil)
  if valid_579434 != nil:
    section.add "tableId", valid_579434
  var valid_579435 = path.getOrDefault("templateId")
  valid_579435 = validateParameter(valid_579435, JInt, required = true, default = nil)
  if valid_579435 != nil:
    section.add "templateId", valid_579435
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_579436 = query.getOrDefault("key")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "key", valid_579436
  var valid_579437 = query.getOrDefault("prettyPrint")
  valid_579437 = validateParameter(valid_579437, JBool, required = false,
                                 default = newJBool(true))
  if valid_579437 != nil:
    section.add "prettyPrint", valid_579437
  var valid_579438 = query.getOrDefault("oauth_token")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "oauth_token", valid_579438
  var valid_579439 = query.getOrDefault("alt")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = newJString("json"))
  if valid_579439 != nil:
    section.add "alt", valid_579439
  var valid_579440 = query.getOrDefault("userIp")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "userIp", valid_579440
  var valid_579441 = query.getOrDefault("quotaUser")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "quotaUser", valid_579441
  var valid_579442 = query.getOrDefault("fields")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = nil)
  if valid_579442 != nil:
    section.add "fields", valid_579442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579443: Call_FusiontablesTemplateDelete_579431; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a template
  ## 
  let valid = call_579443.validator(path, query, header, formData, body)
  let scheme = call_579443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579443.url(scheme.get, call_579443.host, call_579443.base,
                         call_579443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579443, url, valid)

proc call*(call_579444: Call_FusiontablesTemplateDelete_579431; tableId: string;
          templateId: int; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## fusiontablesTemplateDelete
  ## Deletes a template
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   tableId: string (required)
  ##          : Table from which the template is being deleted
  ##   templateId: int (required)
  ##             : Identifier for the template which is being deleted
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579445 = newJObject()
  var query_579446 = newJObject()
  add(query_579446, "key", newJString(key))
  add(query_579446, "prettyPrint", newJBool(prettyPrint))
  add(query_579446, "oauth_token", newJString(oauthToken))
  add(query_579446, "alt", newJString(alt))
  add(query_579446, "userIp", newJString(userIp))
  add(query_579446, "quotaUser", newJString(quotaUser))
  add(path_579445, "tableId", newJString(tableId))
  add(path_579445, "templateId", newJInt(templateId))
  add(query_579446, "fields", newJString(fields))
  result = call_579444.call(path_579445, query_579446, nil, nil, nil)

var fusiontablesTemplateDelete* = Call_FusiontablesTemplateDelete_579431(
    name: "fusiontablesTemplateDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateDelete_579432,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateDelete_579433,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
