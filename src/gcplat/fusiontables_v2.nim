
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "fusiontables"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FusiontablesQuerySql_593963 = ref object of OpenApiRestCall_593424
proc url_FusiontablesQuerySql_593965(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FusiontablesQuerySql_593964(path: JsonNode; query: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   typed: JBool
  ##        : Whether typed values are returned in the (JSON) response: numbers for numeric values and parsed geometries for KML values. Default is true.
  ##   sql: JString (required)
  ##      : A Fusion Tables SQL statement, which can be any of 
  ## - SELECT
  ## - INSERT
  ## - UPDATE
  ## - DELETE
  ## - SHOW
  ## - DESCRIBE
  ## - CREATE
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   hdrs: JBool
  ##       : Whether column names are included in the first row. Default is true.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593966 = query.getOrDefault("fields")
  valid_593966 = validateParameter(valid_593966, JString, required = false,
                                 default = nil)
  if valid_593966 != nil:
    section.add "fields", valid_593966
  var valid_593967 = query.getOrDefault("quotaUser")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "quotaUser", valid_593967
  var valid_593968 = query.getOrDefault("alt")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = newJString("json"))
  if valid_593968 != nil:
    section.add "alt", valid_593968
  var valid_593969 = query.getOrDefault("typed")
  valid_593969 = validateParameter(valid_593969, JBool, required = false, default = nil)
  if valid_593969 != nil:
    section.add "typed", valid_593969
  assert query != nil, "query argument is necessary due to required `sql` field"
  var valid_593970 = query.getOrDefault("sql")
  valid_593970 = validateParameter(valid_593970, JString, required = true,
                                 default = nil)
  if valid_593970 != nil:
    section.add "sql", valid_593970
  var valid_593971 = query.getOrDefault("oauth_token")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "oauth_token", valid_593971
  var valid_593972 = query.getOrDefault("userIp")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "userIp", valid_593972
  var valid_593973 = query.getOrDefault("hdrs")
  valid_593973 = validateParameter(valid_593973, JBool, required = false, default = nil)
  if valid_593973 != nil:
    section.add "hdrs", valid_593973
  var valid_593974 = query.getOrDefault("key")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "key", valid_593974
  var valid_593975 = query.getOrDefault("prettyPrint")
  valid_593975 = validateParameter(valid_593975, JBool, required = false,
                                 default = newJBool(true))
  if valid_593975 != nil:
    section.add "prettyPrint", valid_593975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593976: Call_FusiontablesQuerySql_593963; path: JsonNode;
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
  let valid = call_593976.validator(path, query, header, formData, body)
  let scheme = call_593976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593976.url(scheme.get, call_593976.host, call_593976.base,
                         call_593976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593976, url, valid)

proc call*(call_593977: Call_FusiontablesQuerySql_593963; sql: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          typed: bool = false; oauthToken: string = ""; userIp: string = "";
          hdrs: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesQuerySql
  ## Executes a Fusion Tables SQL statement, which can be any of 
  ## - SELECT
  ## - INSERT
  ## - UPDATE
  ## - DELETE
  ## - SHOW
  ## - DESCRIBE
  ## - CREATE statement.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typed: bool
  ##        : Whether typed values are returned in the (JSON) response: numbers for numeric values and parsed geometries for KML values. Default is true.
  ##   sql: string (required)
  ##      : A Fusion Tables SQL statement, which can be any of 
  ## - SELECT
  ## - INSERT
  ## - UPDATE
  ## - DELETE
  ## - SHOW
  ## - DESCRIBE
  ## - CREATE
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   hdrs: bool
  ##       : Whether column names are included in the first row. Default is true.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593978 = newJObject()
  add(query_593978, "fields", newJString(fields))
  add(query_593978, "quotaUser", newJString(quotaUser))
  add(query_593978, "alt", newJString(alt))
  add(query_593978, "typed", newJBool(typed))
  add(query_593978, "sql", newJString(sql))
  add(query_593978, "oauth_token", newJString(oauthToken))
  add(query_593978, "userIp", newJString(userIp))
  add(query_593978, "hdrs", newJBool(hdrs))
  add(query_593978, "key", newJString(key))
  add(query_593978, "prettyPrint", newJBool(prettyPrint))
  result = call_593977.call(nil, query_593978, nil, nil, nil)

var fusiontablesQuerySql* = Call_FusiontablesQuerySql_593963(
    name: "fusiontablesQuerySql", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_FusiontablesQuerySql_593964, base: "/fusiontables/v2",
    url: url_FusiontablesQuerySql_593965, schemes: {Scheme.Https})
type
  Call_FusiontablesQuerySqlGet_593692 = ref object of OpenApiRestCall_593424
proc url_FusiontablesQuerySqlGet_593694(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FusiontablesQuerySqlGet_593693(path: JsonNode; query: JsonNode;
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
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   typed: JBool
  ##        : Whether typed values are returned in the (JSON) response: numbers for numeric values and parsed geometries for KML values. Default is true.
  ##   sql: JString (required)
  ##      : A SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   hdrs: JBool
  ##       : Whether column names are included (in the first row). Default is true.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593806 = query.getOrDefault("fields")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "fields", valid_593806
  var valid_593807 = query.getOrDefault("quotaUser")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "quotaUser", valid_593807
  var valid_593821 = query.getOrDefault("alt")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = newJString("json"))
  if valid_593821 != nil:
    section.add "alt", valid_593821
  var valid_593822 = query.getOrDefault("typed")
  valid_593822 = validateParameter(valid_593822, JBool, required = false, default = nil)
  if valid_593822 != nil:
    section.add "typed", valid_593822
  assert query != nil, "query argument is necessary due to required `sql` field"
  var valid_593823 = query.getOrDefault("sql")
  valid_593823 = validateParameter(valid_593823, JString, required = true,
                                 default = nil)
  if valid_593823 != nil:
    section.add "sql", valid_593823
  var valid_593824 = query.getOrDefault("oauth_token")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "oauth_token", valid_593824
  var valid_593825 = query.getOrDefault("userIp")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "userIp", valid_593825
  var valid_593826 = query.getOrDefault("hdrs")
  valid_593826 = validateParameter(valid_593826, JBool, required = false, default = nil)
  if valid_593826 != nil:
    section.add "hdrs", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("prettyPrint")
  valid_593828 = validateParameter(valid_593828, JBool, required = false,
                                 default = newJBool(true))
  if valid_593828 != nil:
    section.add "prettyPrint", valid_593828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593851: Call_FusiontablesQuerySqlGet_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes a SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ## 
  let valid = call_593851.validator(path, query, header, formData, body)
  let scheme = call_593851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593851.url(scheme.get, call_593851.host, call_593851.base,
                         call_593851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593851, url, valid)

proc call*(call_593922: Call_FusiontablesQuerySqlGet_593692; sql: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          typed: bool = false; oauthToken: string = ""; userIp: string = "";
          hdrs: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesQuerySqlGet
  ## Executes a SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typed: bool
  ##        : Whether typed values are returned in the (JSON) response: numbers for numeric values and parsed geometries for KML values. Default is true.
  ##   sql: string (required)
  ##      : A SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   hdrs: bool
  ##       : Whether column names are included (in the first row). Default is true.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593923 = newJObject()
  add(query_593923, "fields", newJString(fields))
  add(query_593923, "quotaUser", newJString(quotaUser))
  add(query_593923, "alt", newJString(alt))
  add(query_593923, "typed", newJBool(typed))
  add(query_593923, "sql", newJString(sql))
  add(query_593923, "oauth_token", newJString(oauthToken))
  add(query_593923, "userIp", newJString(userIp))
  add(query_593923, "hdrs", newJBool(hdrs))
  add(query_593923, "key", newJString(key))
  add(query_593923, "prettyPrint", newJBool(prettyPrint))
  result = call_593922.call(nil, query_593923, nil, nil, nil)

var fusiontablesQuerySqlGet* = Call_FusiontablesQuerySqlGet_593692(
    name: "fusiontablesQuerySqlGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query",
    validator: validate_FusiontablesQuerySqlGet_593693, base: "/fusiontables/v2",
    url: url_FusiontablesQuerySqlGet_593694, schemes: {Scheme.Https})
type
  Call_FusiontablesTableInsert_593994 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableInsert_593996(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FusiontablesTableInsert_593995(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new table.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593997 = query.getOrDefault("fields")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = nil)
  if valid_593997 != nil:
    section.add "fields", valid_593997
  var valid_593998 = query.getOrDefault("quotaUser")
  valid_593998 = validateParameter(valid_593998, JString, required = false,
                                 default = nil)
  if valid_593998 != nil:
    section.add "quotaUser", valid_593998
  var valid_593999 = query.getOrDefault("alt")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = newJString("json"))
  if valid_593999 != nil:
    section.add "alt", valid_593999
  var valid_594000 = query.getOrDefault("oauth_token")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "oauth_token", valid_594000
  var valid_594001 = query.getOrDefault("userIp")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "userIp", valid_594001
  var valid_594002 = query.getOrDefault("key")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "key", valid_594002
  var valid_594003 = query.getOrDefault("prettyPrint")
  valid_594003 = validateParameter(valid_594003, JBool, required = false,
                                 default = newJBool(true))
  if valid_594003 != nil:
    section.add "prettyPrint", valid_594003
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

proc call*(call_594005: Call_FusiontablesTableInsert_593994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new table.
  ## 
  let valid = call_594005.validator(path, query, header, formData, body)
  let scheme = call_594005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594005.url(scheme.get, call_594005.host, call_594005.base,
                         call_594005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594005, url, valid)

proc call*(call_594006: Call_FusiontablesTableInsert_593994; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTableInsert
  ## Creates a new table.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594007 = newJObject()
  var body_594008 = newJObject()
  add(query_594007, "fields", newJString(fields))
  add(query_594007, "quotaUser", newJString(quotaUser))
  add(query_594007, "alt", newJString(alt))
  add(query_594007, "oauth_token", newJString(oauthToken))
  add(query_594007, "userIp", newJString(userIp))
  add(query_594007, "key", newJString(key))
  if body != nil:
    body_594008 = body
  add(query_594007, "prettyPrint", newJBool(prettyPrint))
  result = call_594006.call(nil, query_594007, nil, nil, body_594008)

var fusiontablesTableInsert* = Call_FusiontablesTableInsert_593994(
    name: "fusiontablesTableInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables",
    validator: validate_FusiontablesTableInsert_593995, base: "/fusiontables/v2",
    url: url_FusiontablesTableInsert_593996, schemes: {Scheme.Https})
type
  Call_FusiontablesTableList_593979 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableList_593981(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FusiontablesTableList_593980(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of tables a user owns.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token specifying which result page to return.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of tables to return. Default is 5.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593982 = query.getOrDefault("fields")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "fields", valid_593982
  var valid_593983 = query.getOrDefault("pageToken")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "pageToken", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("userIp")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "userIp", valid_593987
  var valid_593988 = query.getOrDefault("maxResults")
  valid_593988 = validateParameter(valid_593988, JInt, required = false, default = nil)
  if valid_593988 != nil:
    section.add "maxResults", valid_593988
  var valid_593989 = query.getOrDefault("key")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "key", valid_593989
  var valid_593990 = query.getOrDefault("prettyPrint")
  valid_593990 = validateParameter(valid_593990, JBool, required = false,
                                 default = newJBool(true))
  if valid_593990 != nil:
    section.add "prettyPrint", valid_593990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593991: Call_FusiontablesTableList_593979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of tables a user owns.
  ## 
  let valid = call_593991.validator(path, query, header, formData, body)
  let scheme = call_593991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593991.url(scheme.get, call_593991.host, call_593991.base,
                         call_593991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593991, url, valid)

proc call*(call_593992: Call_FusiontablesTableList_593979; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTableList
  ## Retrieves a list of tables a user owns.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token specifying which result page to return.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of tables to return. Default is 5.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_593993 = newJObject()
  add(query_593993, "fields", newJString(fields))
  add(query_593993, "pageToken", newJString(pageToken))
  add(query_593993, "quotaUser", newJString(quotaUser))
  add(query_593993, "alt", newJString(alt))
  add(query_593993, "oauth_token", newJString(oauthToken))
  add(query_593993, "userIp", newJString(userIp))
  add(query_593993, "maxResults", newJInt(maxResults))
  add(query_593993, "key", newJString(key))
  add(query_593993, "prettyPrint", newJBool(prettyPrint))
  result = call_593992.call(nil, query_593993, nil, nil, nil)

var fusiontablesTableList* = Call_FusiontablesTableList_593979(
    name: "fusiontablesTableList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables",
    validator: validate_FusiontablesTableList_593980, base: "/fusiontables/v2",
    url: url_FusiontablesTableList_593981, schemes: {Scheme.Https})
type
  Call_FusiontablesTableImportTable_594009 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableImportTable_594011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_FusiontablesTableImportTable_594010(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Imports a new table.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString (required)
  ##       : The name to be assigned to the new table.
  ##   delimiter: JString
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  ##   encoding: JString
  ##           : The encoding of the content. Default is UTF-8. Use auto-detect if you are unsure of the encoding.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594012 = query.getOrDefault("fields")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "fields", valid_594012
  var valid_594013 = query.getOrDefault("quotaUser")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "quotaUser", valid_594013
  var valid_594014 = query.getOrDefault("alt")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("json"))
  if valid_594014 != nil:
    section.add "alt", valid_594014
  var valid_594015 = query.getOrDefault("oauth_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "oauth_token", valid_594015
  var valid_594016 = query.getOrDefault("userIp")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "userIp", valid_594016
  var valid_594017 = query.getOrDefault("key")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "key", valid_594017
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_594018 = query.getOrDefault("name")
  valid_594018 = validateParameter(valid_594018, JString, required = true,
                                 default = nil)
  if valid_594018 != nil:
    section.add "name", valid_594018
  var valid_594019 = query.getOrDefault("delimiter")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "delimiter", valid_594019
  var valid_594020 = query.getOrDefault("encoding")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "encoding", valid_594020
  var valid_594021 = query.getOrDefault("prettyPrint")
  valid_594021 = validateParameter(valid_594021, JBool, required = false,
                                 default = newJBool(true))
  if valid_594021 != nil:
    section.add "prettyPrint", valid_594021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594022: Call_FusiontablesTableImportTable_594009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new table.
  ## 
  let valid = call_594022.validator(path, query, header, formData, body)
  let scheme = call_594022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594022.url(scheme.get, call_594022.host, call_594022.base,
                         call_594022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594022, url, valid)

proc call*(call_594023: Call_FusiontablesTableImportTable_594009; name: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          delimiter: string = ""; encoding: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTableImportTable
  ## Imports a new table.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string (required)
  ##       : The name to be assigned to the new table.
  ##   delimiter: string
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  ##   encoding: string
  ##           : The encoding of the content. Default is UTF-8. Use auto-detect if you are unsure of the encoding.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_594024 = newJObject()
  add(query_594024, "fields", newJString(fields))
  add(query_594024, "quotaUser", newJString(quotaUser))
  add(query_594024, "alt", newJString(alt))
  add(query_594024, "oauth_token", newJString(oauthToken))
  add(query_594024, "userIp", newJString(userIp))
  add(query_594024, "key", newJString(key))
  add(query_594024, "name", newJString(name))
  add(query_594024, "delimiter", newJString(delimiter))
  add(query_594024, "encoding", newJString(encoding))
  add(query_594024, "prettyPrint", newJBool(prettyPrint))
  result = call_594023.call(nil, query_594024, nil, nil, nil)

var fusiontablesTableImportTable* = Call_FusiontablesTableImportTable_594009(
    name: "fusiontablesTableImportTable", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/import",
    validator: validate_FusiontablesTableImportTable_594010,
    base: "/fusiontables/v2", url: url_FusiontablesTableImportTable_594011,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableUpdate_594054 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableUpdate_594056(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableUpdate_594055(path: JsonNode; query: JsonNode;
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
  var valid_594057 = path.getOrDefault("tableId")
  valid_594057 = validateParameter(valid_594057, JString, required = true,
                                 default = nil)
  if valid_594057 != nil:
    section.add "tableId", valid_594057
  result.add "path", section
  ## parameters in `query` object:
  ##   replaceViewDefinition: JBool
  ##                        : Whether the view definition is also updated. The specified view definition replaces the existing one. Only a view can be updated with a new definition.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594058 = query.getOrDefault("replaceViewDefinition")
  valid_594058 = validateParameter(valid_594058, JBool, required = false, default = nil)
  if valid_594058 != nil:
    section.add "replaceViewDefinition", valid_594058
  var valid_594059 = query.getOrDefault("fields")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "fields", valid_594059
  var valid_594060 = query.getOrDefault("quotaUser")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "quotaUser", valid_594060
  var valid_594061 = query.getOrDefault("alt")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = newJString("json"))
  if valid_594061 != nil:
    section.add "alt", valid_594061
  var valid_594062 = query.getOrDefault("oauth_token")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "oauth_token", valid_594062
  var valid_594063 = query.getOrDefault("userIp")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "userIp", valid_594063
  var valid_594064 = query.getOrDefault("key")
  valid_594064 = validateParameter(valid_594064, JString, required = false,
                                 default = nil)
  if valid_594064 != nil:
    section.add "key", valid_594064
  var valid_594065 = query.getOrDefault("prettyPrint")
  valid_594065 = validateParameter(valid_594065, JBool, required = false,
                                 default = newJBool(true))
  if valid_594065 != nil:
    section.add "prettyPrint", valid_594065
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

proc call*(call_594067: Call_FusiontablesTableUpdate_594054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated.
  ## 
  let valid = call_594067.validator(path, query, header, formData, body)
  let scheme = call_594067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594067.url(scheme.get, call_594067.host, call_594067.base,
                         call_594067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594067, url, valid)

proc call*(call_594068: Call_FusiontablesTableUpdate_594054; tableId: string;
          replaceViewDefinition: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTableUpdate
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated.
  ##   replaceViewDefinition: bool
  ##                        : Whether the view definition is also updated. The specified view definition replaces the existing one. Only a view can be updated with a new definition.
  ##   tableId: string (required)
  ##          : ID of the table that is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594069 = newJObject()
  var query_594070 = newJObject()
  var body_594071 = newJObject()
  add(query_594070, "replaceViewDefinition", newJBool(replaceViewDefinition))
  add(path_594069, "tableId", newJString(tableId))
  add(query_594070, "fields", newJString(fields))
  add(query_594070, "quotaUser", newJString(quotaUser))
  add(query_594070, "alt", newJString(alt))
  add(query_594070, "oauth_token", newJString(oauthToken))
  add(query_594070, "userIp", newJString(userIp))
  add(query_594070, "key", newJString(key))
  if body != nil:
    body_594071 = body
  add(query_594070, "prettyPrint", newJBool(prettyPrint))
  result = call_594068.call(path_594069, query_594070, nil, nil, body_594071)

var fusiontablesTableUpdate* = Call_FusiontablesTableUpdate_594054(
    name: "fusiontablesTableUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableUpdate_594055, base: "/fusiontables/v2",
    url: url_FusiontablesTableUpdate_594056, schemes: {Scheme.Https})
type
  Call_FusiontablesTableGet_594025 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableGet_594027(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableGet_594026(path: JsonNode; query: JsonNode;
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
  var valid_594042 = path.getOrDefault("tableId")
  valid_594042 = validateParameter(valid_594042, JString, required = true,
                                 default = nil)
  if valid_594042 != nil:
    section.add "tableId", valid_594042
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594043 = query.getOrDefault("fields")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "fields", valid_594043
  var valid_594044 = query.getOrDefault("quotaUser")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "quotaUser", valid_594044
  var valid_594045 = query.getOrDefault("alt")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = newJString("json"))
  if valid_594045 != nil:
    section.add "alt", valid_594045
  var valid_594046 = query.getOrDefault("oauth_token")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "oauth_token", valid_594046
  var valid_594047 = query.getOrDefault("userIp")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = nil)
  if valid_594047 != nil:
    section.add "userIp", valid_594047
  var valid_594048 = query.getOrDefault("key")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "key", valid_594048
  var valid_594049 = query.getOrDefault("prettyPrint")
  valid_594049 = validateParameter(valid_594049, JBool, required = false,
                                 default = newJBool(true))
  if valid_594049 != nil:
    section.add "prettyPrint", valid_594049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594050: Call_FusiontablesTableGet_594025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific table by its ID.
  ## 
  let valid = call_594050.validator(path, query, header, formData, body)
  let scheme = call_594050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594050.url(scheme.get, call_594050.host, call_594050.base,
                         call_594050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594050, url, valid)

proc call*(call_594051: Call_FusiontablesTableGet_594025; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTableGet
  ## Retrieves a specific table by its ID.
  ##   tableId: string (required)
  ##          : Identifier for the table being requested.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594052 = newJObject()
  var query_594053 = newJObject()
  add(path_594052, "tableId", newJString(tableId))
  add(query_594053, "fields", newJString(fields))
  add(query_594053, "quotaUser", newJString(quotaUser))
  add(query_594053, "alt", newJString(alt))
  add(query_594053, "oauth_token", newJString(oauthToken))
  add(query_594053, "userIp", newJString(userIp))
  add(query_594053, "key", newJString(key))
  add(query_594053, "prettyPrint", newJBool(prettyPrint))
  result = call_594051.call(path_594052, query_594053, nil, nil, nil)

var fusiontablesTableGet* = Call_FusiontablesTableGet_594025(
    name: "fusiontablesTableGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableGet_594026, base: "/fusiontables/v2",
    url: url_FusiontablesTableGet_594027, schemes: {Scheme.Https})
type
  Call_FusiontablesTablePatch_594087 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTablePatch_594089(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTablePatch_594088(path: JsonNode; query: JsonNode;
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
  var valid_594090 = path.getOrDefault("tableId")
  valid_594090 = validateParameter(valid_594090, JString, required = true,
                                 default = nil)
  if valid_594090 != nil:
    section.add "tableId", valid_594090
  result.add "path", section
  ## parameters in `query` object:
  ##   replaceViewDefinition: JBool
  ##                        : Whether the view definition is also updated. The specified view definition replaces the existing one. Only a view can be updated with a new definition.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594091 = query.getOrDefault("replaceViewDefinition")
  valid_594091 = validateParameter(valid_594091, JBool, required = false, default = nil)
  if valid_594091 != nil:
    section.add "replaceViewDefinition", valid_594091
  var valid_594092 = query.getOrDefault("fields")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "fields", valid_594092
  var valid_594093 = query.getOrDefault("quotaUser")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "quotaUser", valid_594093
  var valid_594094 = query.getOrDefault("alt")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = newJString("json"))
  if valid_594094 != nil:
    section.add "alt", valid_594094
  var valid_594095 = query.getOrDefault("oauth_token")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "oauth_token", valid_594095
  var valid_594096 = query.getOrDefault("userIp")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "userIp", valid_594096
  var valid_594097 = query.getOrDefault("key")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "key", valid_594097
  var valid_594098 = query.getOrDefault("prettyPrint")
  valid_594098 = validateParameter(valid_594098, JBool, required = false,
                                 default = newJBool(true))
  if valid_594098 != nil:
    section.add "prettyPrint", valid_594098
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

proc call*(call_594100: Call_FusiontablesTablePatch_594087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated. This method supports patch semantics.
  ## 
  let valid = call_594100.validator(path, query, header, formData, body)
  let scheme = call_594100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594100.url(scheme.get, call_594100.host, call_594100.base,
                         call_594100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594100, url, valid)

proc call*(call_594101: Call_FusiontablesTablePatch_594087; tableId: string;
          replaceViewDefinition: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTablePatch
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated. This method supports patch semantics.
  ##   replaceViewDefinition: bool
  ##                        : Whether the view definition is also updated. The specified view definition replaces the existing one. Only a view can be updated with a new definition.
  ##   tableId: string (required)
  ##          : ID of the table that is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594102 = newJObject()
  var query_594103 = newJObject()
  var body_594104 = newJObject()
  add(query_594103, "replaceViewDefinition", newJBool(replaceViewDefinition))
  add(path_594102, "tableId", newJString(tableId))
  add(query_594103, "fields", newJString(fields))
  add(query_594103, "quotaUser", newJString(quotaUser))
  add(query_594103, "alt", newJString(alt))
  add(query_594103, "oauth_token", newJString(oauthToken))
  add(query_594103, "userIp", newJString(userIp))
  add(query_594103, "key", newJString(key))
  if body != nil:
    body_594104 = body
  add(query_594103, "prettyPrint", newJBool(prettyPrint))
  result = call_594101.call(path_594102, query_594103, nil, nil, body_594104)

var fusiontablesTablePatch* = Call_FusiontablesTablePatch_594087(
    name: "fusiontablesTablePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTablePatch_594088, base: "/fusiontables/v2",
    url: url_FusiontablesTablePatch_594089, schemes: {Scheme.Https})
type
  Call_FusiontablesTableDelete_594072 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableDelete_594074(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "tableId" in path, "`tableId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/tables/"),
               (kind: VariableSegment, value: "tableId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_FusiontablesTableDelete_594073(path: JsonNode; query: JsonNode;
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
  var valid_594075 = path.getOrDefault("tableId")
  valid_594075 = validateParameter(valid_594075, JString, required = true,
                                 default = nil)
  if valid_594075 != nil:
    section.add "tableId", valid_594075
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594076 = query.getOrDefault("fields")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "fields", valid_594076
  var valid_594077 = query.getOrDefault("quotaUser")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "quotaUser", valid_594077
  var valid_594078 = query.getOrDefault("alt")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("json"))
  if valid_594078 != nil:
    section.add "alt", valid_594078
  var valid_594079 = query.getOrDefault("oauth_token")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "oauth_token", valid_594079
  var valid_594080 = query.getOrDefault("userIp")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "userIp", valid_594080
  var valid_594081 = query.getOrDefault("key")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "key", valid_594081
  var valid_594082 = query.getOrDefault("prettyPrint")
  valid_594082 = validateParameter(valid_594082, JBool, required = false,
                                 default = newJBool(true))
  if valid_594082 != nil:
    section.add "prettyPrint", valid_594082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594083: Call_FusiontablesTableDelete_594072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a table.
  ## 
  let valid = call_594083.validator(path, query, header, formData, body)
  let scheme = call_594083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594083.url(scheme.get, call_594083.host, call_594083.base,
                         call_594083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594083, url, valid)

proc call*(call_594084: Call_FusiontablesTableDelete_594072; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTableDelete
  ## Deletes a table.
  ##   tableId: string (required)
  ##          : ID of the table to be deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594085 = newJObject()
  var query_594086 = newJObject()
  add(path_594085, "tableId", newJString(tableId))
  add(query_594086, "fields", newJString(fields))
  add(query_594086, "quotaUser", newJString(quotaUser))
  add(query_594086, "alt", newJString(alt))
  add(query_594086, "oauth_token", newJString(oauthToken))
  add(query_594086, "userIp", newJString(userIp))
  add(query_594086, "key", newJString(key))
  add(query_594086, "prettyPrint", newJBool(prettyPrint))
  result = call_594084.call(path_594085, query_594086, nil, nil, nil)

var fusiontablesTableDelete* = Call_FusiontablesTableDelete_594072(
    name: "fusiontablesTableDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableDelete_594073, base: "/fusiontables/v2",
    url: url_FusiontablesTableDelete_594074, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnInsert_594122 = ref object of OpenApiRestCall_593424
proc url_FusiontablesColumnInsert_594124(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesColumnInsert_594123(path: JsonNode; query: JsonNode;
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
  var valid_594125 = path.getOrDefault("tableId")
  valid_594125 = validateParameter(valid_594125, JString, required = true,
                                 default = nil)
  if valid_594125 != nil:
    section.add "tableId", valid_594125
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594126 = query.getOrDefault("fields")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "fields", valid_594126
  var valid_594127 = query.getOrDefault("quotaUser")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "quotaUser", valid_594127
  var valid_594128 = query.getOrDefault("alt")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = newJString("json"))
  if valid_594128 != nil:
    section.add "alt", valid_594128
  var valid_594129 = query.getOrDefault("oauth_token")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "oauth_token", valid_594129
  var valid_594130 = query.getOrDefault("userIp")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "userIp", valid_594130
  var valid_594131 = query.getOrDefault("key")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "key", valid_594131
  var valid_594132 = query.getOrDefault("prettyPrint")
  valid_594132 = validateParameter(valid_594132, JBool, required = false,
                                 default = newJBool(true))
  if valid_594132 != nil:
    section.add "prettyPrint", valid_594132
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

proc call*(call_594134: Call_FusiontablesColumnInsert_594122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new column to the table.
  ## 
  let valid = call_594134.validator(path, query, header, formData, body)
  let scheme = call_594134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594134.url(scheme.get, call_594134.host, call_594134.base,
                         call_594134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594134, url, valid)

proc call*(call_594135: Call_FusiontablesColumnInsert_594122; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesColumnInsert
  ## Adds a new column to the table.
  ##   tableId: string (required)
  ##          : Table for which a new column is being added.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594136 = newJObject()
  var query_594137 = newJObject()
  var body_594138 = newJObject()
  add(path_594136, "tableId", newJString(tableId))
  add(query_594137, "fields", newJString(fields))
  add(query_594137, "quotaUser", newJString(quotaUser))
  add(query_594137, "alt", newJString(alt))
  add(query_594137, "oauth_token", newJString(oauthToken))
  add(query_594137, "userIp", newJString(userIp))
  add(query_594137, "key", newJString(key))
  if body != nil:
    body_594138 = body
  add(query_594137, "prettyPrint", newJBool(prettyPrint))
  result = call_594135.call(path_594136, query_594137, nil, nil, body_594138)

var fusiontablesColumnInsert* = Call_FusiontablesColumnInsert_594122(
    name: "fusiontablesColumnInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns",
    validator: validate_FusiontablesColumnInsert_594123, base: "/fusiontables/v2",
    url: url_FusiontablesColumnInsert_594124, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnList_594105 = ref object of OpenApiRestCall_593424
proc url_FusiontablesColumnList_594107(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesColumnList_594106(path: JsonNode; query: JsonNode;
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
  var valid_594108 = path.getOrDefault("tableId")
  valid_594108 = validateParameter(valid_594108, JString, required = true,
                                 default = nil)
  if valid_594108 != nil:
    section.add "tableId", valid_594108
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token specifying which result page to return.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of columns to return. Default is 5.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594109 = query.getOrDefault("fields")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "fields", valid_594109
  var valid_594110 = query.getOrDefault("pageToken")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "pageToken", valid_594110
  var valid_594111 = query.getOrDefault("quotaUser")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "quotaUser", valid_594111
  var valid_594112 = query.getOrDefault("alt")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = newJString("json"))
  if valid_594112 != nil:
    section.add "alt", valid_594112
  var valid_594113 = query.getOrDefault("oauth_token")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "oauth_token", valid_594113
  var valid_594114 = query.getOrDefault("userIp")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "userIp", valid_594114
  var valid_594115 = query.getOrDefault("maxResults")
  valid_594115 = validateParameter(valid_594115, JInt, required = false, default = nil)
  if valid_594115 != nil:
    section.add "maxResults", valid_594115
  var valid_594116 = query.getOrDefault("key")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "key", valid_594116
  var valid_594117 = query.getOrDefault("prettyPrint")
  valid_594117 = validateParameter(valid_594117, JBool, required = false,
                                 default = newJBool(true))
  if valid_594117 != nil:
    section.add "prettyPrint", valid_594117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594118: Call_FusiontablesColumnList_594105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of columns.
  ## 
  let valid = call_594118.validator(path, query, header, formData, body)
  let scheme = call_594118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594118.url(scheme.get, call_594118.host, call_594118.base,
                         call_594118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594118, url, valid)

proc call*(call_594119: Call_FusiontablesColumnList_594105; tableId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesColumnList
  ## Retrieves a list of columns.
  ##   tableId: string (required)
  ##          : Table whose columns are being listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token specifying which result page to return.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of columns to return. Default is 5.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594120 = newJObject()
  var query_594121 = newJObject()
  add(path_594120, "tableId", newJString(tableId))
  add(query_594121, "fields", newJString(fields))
  add(query_594121, "pageToken", newJString(pageToken))
  add(query_594121, "quotaUser", newJString(quotaUser))
  add(query_594121, "alt", newJString(alt))
  add(query_594121, "oauth_token", newJString(oauthToken))
  add(query_594121, "userIp", newJString(userIp))
  add(query_594121, "maxResults", newJInt(maxResults))
  add(query_594121, "key", newJString(key))
  add(query_594121, "prettyPrint", newJBool(prettyPrint))
  result = call_594119.call(path_594120, query_594121, nil, nil, nil)

var fusiontablesColumnList* = Call_FusiontablesColumnList_594105(
    name: "fusiontablesColumnList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns",
    validator: validate_FusiontablesColumnList_594106, base: "/fusiontables/v2",
    url: url_FusiontablesColumnList_594107, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnUpdate_594155 = ref object of OpenApiRestCall_593424
proc url_FusiontablesColumnUpdate_594157(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesColumnUpdate_594156(path: JsonNode; query: JsonNode;
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
  var valid_594158 = path.getOrDefault("tableId")
  valid_594158 = validateParameter(valid_594158, JString, required = true,
                                 default = nil)
  if valid_594158 != nil:
    section.add "tableId", valid_594158
  var valid_594159 = path.getOrDefault("columnId")
  valid_594159 = validateParameter(valid_594159, JString, required = true,
                                 default = nil)
  if valid_594159 != nil:
    section.add "columnId", valid_594159
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594160 = query.getOrDefault("fields")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "fields", valid_594160
  var valid_594161 = query.getOrDefault("quotaUser")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "quotaUser", valid_594161
  var valid_594162 = query.getOrDefault("alt")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = newJString("json"))
  if valid_594162 != nil:
    section.add "alt", valid_594162
  var valid_594163 = query.getOrDefault("oauth_token")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "oauth_token", valid_594163
  var valid_594164 = query.getOrDefault("userIp")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "userIp", valid_594164
  var valid_594165 = query.getOrDefault("key")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "key", valid_594165
  var valid_594166 = query.getOrDefault("prettyPrint")
  valid_594166 = validateParameter(valid_594166, JBool, required = false,
                                 default = newJBool(true))
  if valid_594166 != nil:
    section.add "prettyPrint", valid_594166
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

proc call*(call_594168: Call_FusiontablesColumnUpdate_594155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or type of an existing column.
  ## 
  let valid = call_594168.validator(path, query, header, formData, body)
  let scheme = call_594168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594168.url(scheme.get, call_594168.host, call_594168.base,
                         call_594168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594168, url, valid)

proc call*(call_594169: Call_FusiontablesColumnUpdate_594155; tableId: string;
          columnId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesColumnUpdate
  ## Updates the name or type of an existing column.
  ##   tableId: string (required)
  ##          : Table for which the column is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   columnId: string (required)
  ##           : Name or identifier for the column that is being updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594170 = newJObject()
  var query_594171 = newJObject()
  var body_594172 = newJObject()
  add(path_594170, "tableId", newJString(tableId))
  add(query_594171, "fields", newJString(fields))
  add(query_594171, "quotaUser", newJString(quotaUser))
  add(query_594171, "alt", newJString(alt))
  add(query_594171, "oauth_token", newJString(oauthToken))
  add(query_594171, "userIp", newJString(userIp))
  add(query_594171, "key", newJString(key))
  add(path_594170, "columnId", newJString(columnId))
  if body != nil:
    body_594172 = body
  add(query_594171, "prettyPrint", newJBool(prettyPrint))
  result = call_594169.call(path_594170, query_594171, nil, nil, body_594172)

var fusiontablesColumnUpdate* = Call_FusiontablesColumnUpdate_594155(
    name: "fusiontablesColumnUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnUpdate_594156, base: "/fusiontables/v2",
    url: url_FusiontablesColumnUpdate_594157, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnGet_594139 = ref object of OpenApiRestCall_593424
proc url_FusiontablesColumnGet_594141(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesColumnGet_594140(path: JsonNode; query: JsonNode;
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
  var valid_594142 = path.getOrDefault("tableId")
  valid_594142 = validateParameter(valid_594142, JString, required = true,
                                 default = nil)
  if valid_594142 != nil:
    section.add "tableId", valid_594142
  var valid_594143 = path.getOrDefault("columnId")
  valid_594143 = validateParameter(valid_594143, JString, required = true,
                                 default = nil)
  if valid_594143 != nil:
    section.add "columnId", valid_594143
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594144 = query.getOrDefault("fields")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "fields", valid_594144
  var valid_594145 = query.getOrDefault("quotaUser")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "quotaUser", valid_594145
  var valid_594146 = query.getOrDefault("alt")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = newJString("json"))
  if valid_594146 != nil:
    section.add "alt", valid_594146
  var valid_594147 = query.getOrDefault("oauth_token")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "oauth_token", valid_594147
  var valid_594148 = query.getOrDefault("userIp")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = nil)
  if valid_594148 != nil:
    section.add "userIp", valid_594148
  var valid_594149 = query.getOrDefault("key")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "key", valid_594149
  var valid_594150 = query.getOrDefault("prettyPrint")
  valid_594150 = validateParameter(valid_594150, JBool, required = false,
                                 default = newJBool(true))
  if valid_594150 != nil:
    section.add "prettyPrint", valid_594150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594151: Call_FusiontablesColumnGet_594139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific column by its ID.
  ## 
  let valid = call_594151.validator(path, query, header, formData, body)
  let scheme = call_594151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594151.url(scheme.get, call_594151.host, call_594151.base,
                         call_594151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594151, url, valid)

proc call*(call_594152: Call_FusiontablesColumnGet_594139; tableId: string;
          columnId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesColumnGet
  ## Retrieves a specific column by its ID.
  ##   tableId: string (required)
  ##          : Table to which the column belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   columnId: string (required)
  ##           : Name or identifier for the column that is being requested.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594153 = newJObject()
  var query_594154 = newJObject()
  add(path_594153, "tableId", newJString(tableId))
  add(query_594154, "fields", newJString(fields))
  add(query_594154, "quotaUser", newJString(quotaUser))
  add(query_594154, "alt", newJString(alt))
  add(query_594154, "oauth_token", newJString(oauthToken))
  add(query_594154, "userIp", newJString(userIp))
  add(query_594154, "key", newJString(key))
  add(path_594153, "columnId", newJString(columnId))
  add(query_594154, "prettyPrint", newJBool(prettyPrint))
  result = call_594152.call(path_594153, query_594154, nil, nil, nil)

var fusiontablesColumnGet* = Call_FusiontablesColumnGet_594139(
    name: "fusiontablesColumnGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnGet_594140, base: "/fusiontables/v2",
    url: url_FusiontablesColumnGet_594141, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnPatch_594189 = ref object of OpenApiRestCall_593424
proc url_FusiontablesColumnPatch_594191(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesColumnPatch_594190(path: JsonNode; query: JsonNode;
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
  var valid_594192 = path.getOrDefault("tableId")
  valid_594192 = validateParameter(valid_594192, JString, required = true,
                                 default = nil)
  if valid_594192 != nil:
    section.add "tableId", valid_594192
  var valid_594193 = path.getOrDefault("columnId")
  valid_594193 = validateParameter(valid_594193, JString, required = true,
                                 default = nil)
  if valid_594193 != nil:
    section.add "columnId", valid_594193
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594194 = query.getOrDefault("fields")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "fields", valid_594194
  var valid_594195 = query.getOrDefault("quotaUser")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "quotaUser", valid_594195
  var valid_594196 = query.getOrDefault("alt")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = newJString("json"))
  if valid_594196 != nil:
    section.add "alt", valid_594196
  var valid_594197 = query.getOrDefault("oauth_token")
  valid_594197 = validateParameter(valid_594197, JString, required = false,
                                 default = nil)
  if valid_594197 != nil:
    section.add "oauth_token", valid_594197
  var valid_594198 = query.getOrDefault("userIp")
  valid_594198 = validateParameter(valid_594198, JString, required = false,
                                 default = nil)
  if valid_594198 != nil:
    section.add "userIp", valid_594198
  var valid_594199 = query.getOrDefault("key")
  valid_594199 = validateParameter(valid_594199, JString, required = false,
                                 default = nil)
  if valid_594199 != nil:
    section.add "key", valid_594199
  var valid_594200 = query.getOrDefault("prettyPrint")
  valid_594200 = validateParameter(valid_594200, JBool, required = false,
                                 default = newJBool(true))
  if valid_594200 != nil:
    section.add "prettyPrint", valid_594200
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

proc call*(call_594202: Call_FusiontablesColumnPatch_594189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or type of an existing column. This method supports patch semantics.
  ## 
  let valid = call_594202.validator(path, query, header, formData, body)
  let scheme = call_594202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594202.url(scheme.get, call_594202.host, call_594202.base,
                         call_594202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594202, url, valid)

proc call*(call_594203: Call_FusiontablesColumnPatch_594189; tableId: string;
          columnId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesColumnPatch
  ## Updates the name or type of an existing column. This method supports patch semantics.
  ##   tableId: string (required)
  ##          : Table for which the column is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   columnId: string (required)
  ##           : Name or identifier for the column that is being updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594204 = newJObject()
  var query_594205 = newJObject()
  var body_594206 = newJObject()
  add(path_594204, "tableId", newJString(tableId))
  add(query_594205, "fields", newJString(fields))
  add(query_594205, "quotaUser", newJString(quotaUser))
  add(query_594205, "alt", newJString(alt))
  add(query_594205, "oauth_token", newJString(oauthToken))
  add(query_594205, "userIp", newJString(userIp))
  add(query_594205, "key", newJString(key))
  add(path_594204, "columnId", newJString(columnId))
  if body != nil:
    body_594206 = body
  add(query_594205, "prettyPrint", newJBool(prettyPrint))
  result = call_594203.call(path_594204, query_594205, nil, nil, body_594206)

var fusiontablesColumnPatch* = Call_FusiontablesColumnPatch_594189(
    name: "fusiontablesColumnPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnPatch_594190, base: "/fusiontables/v2",
    url: url_FusiontablesColumnPatch_594191, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnDelete_594173 = ref object of OpenApiRestCall_593424
proc url_FusiontablesColumnDelete_594175(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesColumnDelete_594174(path: JsonNode; query: JsonNode;
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
  var valid_594176 = path.getOrDefault("tableId")
  valid_594176 = validateParameter(valid_594176, JString, required = true,
                                 default = nil)
  if valid_594176 != nil:
    section.add "tableId", valid_594176
  var valid_594177 = path.getOrDefault("columnId")
  valid_594177 = validateParameter(valid_594177, JString, required = true,
                                 default = nil)
  if valid_594177 != nil:
    section.add "columnId", valid_594177
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594178 = query.getOrDefault("fields")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "fields", valid_594178
  var valid_594179 = query.getOrDefault("quotaUser")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "quotaUser", valid_594179
  var valid_594180 = query.getOrDefault("alt")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = newJString("json"))
  if valid_594180 != nil:
    section.add "alt", valid_594180
  var valid_594181 = query.getOrDefault("oauth_token")
  valid_594181 = validateParameter(valid_594181, JString, required = false,
                                 default = nil)
  if valid_594181 != nil:
    section.add "oauth_token", valid_594181
  var valid_594182 = query.getOrDefault("userIp")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "userIp", valid_594182
  var valid_594183 = query.getOrDefault("key")
  valid_594183 = validateParameter(valid_594183, JString, required = false,
                                 default = nil)
  if valid_594183 != nil:
    section.add "key", valid_594183
  var valid_594184 = query.getOrDefault("prettyPrint")
  valid_594184 = validateParameter(valid_594184, JBool, required = false,
                                 default = newJBool(true))
  if valid_594184 != nil:
    section.add "prettyPrint", valid_594184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594185: Call_FusiontablesColumnDelete_594173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified column.
  ## 
  let valid = call_594185.validator(path, query, header, formData, body)
  let scheme = call_594185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594185.url(scheme.get, call_594185.host, call_594185.base,
                         call_594185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594185, url, valid)

proc call*(call_594186: Call_FusiontablesColumnDelete_594173; tableId: string;
          columnId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesColumnDelete
  ## Deletes the specified column.
  ##   tableId: string (required)
  ##          : Table from which the column is being deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   columnId: string (required)
  ##           : Name or identifier for the column being deleted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594187 = newJObject()
  var query_594188 = newJObject()
  add(path_594187, "tableId", newJString(tableId))
  add(query_594188, "fields", newJString(fields))
  add(query_594188, "quotaUser", newJString(quotaUser))
  add(query_594188, "alt", newJString(alt))
  add(query_594188, "oauth_token", newJString(oauthToken))
  add(query_594188, "userIp", newJString(userIp))
  add(query_594188, "key", newJString(key))
  add(path_594187, "columnId", newJString(columnId))
  add(query_594188, "prettyPrint", newJBool(prettyPrint))
  result = call_594186.call(path_594187, query_594188, nil, nil, nil)

var fusiontablesColumnDelete* = Call_FusiontablesColumnDelete_594173(
    name: "fusiontablesColumnDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnDelete_594174, base: "/fusiontables/v2",
    url: url_FusiontablesColumnDelete_594175, schemes: {Scheme.Https})
type
  Call_FusiontablesTableCopy_594207 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableCopy_594209(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTableCopy_594208(path: JsonNode; query: JsonNode;
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
  var valid_594210 = path.getOrDefault("tableId")
  valid_594210 = validateParameter(valid_594210, JString, required = true,
                                 default = nil)
  if valid_594210 != nil:
    section.add "tableId", valid_594210
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   copyPresentation: JBool
  ##                   : Whether to also copy tabs, styles, and templates. Default is false.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594211 = query.getOrDefault("fields")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "fields", valid_594211
  var valid_594212 = query.getOrDefault("quotaUser")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "quotaUser", valid_594212
  var valid_594213 = query.getOrDefault("alt")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = newJString("json"))
  if valid_594213 != nil:
    section.add "alt", valid_594213
  var valid_594214 = query.getOrDefault("oauth_token")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "oauth_token", valid_594214
  var valid_594215 = query.getOrDefault("userIp")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "userIp", valid_594215
  var valid_594216 = query.getOrDefault("key")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "key", valid_594216
  var valid_594217 = query.getOrDefault("copyPresentation")
  valid_594217 = validateParameter(valid_594217, JBool, required = false, default = nil)
  if valid_594217 != nil:
    section.add "copyPresentation", valid_594217
  var valid_594218 = query.getOrDefault("prettyPrint")
  valid_594218 = validateParameter(valid_594218, JBool, required = false,
                                 default = newJBool(true))
  if valid_594218 != nil:
    section.add "prettyPrint", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_FusiontablesTableCopy_594207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a table.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_FusiontablesTableCopy_594207; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          copyPresentation: bool = false; prettyPrint: bool = true): Recallable =
  ## fusiontablesTableCopy
  ## Copies a table.
  ##   tableId: string (required)
  ##          : ID of the table that is being copied.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   copyPresentation: bool
  ##                   : Whether to also copy tabs, styles, and templates. Default is false.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(path_594221, "tableId", newJString(tableId))
  add(query_594222, "fields", newJString(fields))
  add(query_594222, "quotaUser", newJString(quotaUser))
  add(query_594222, "alt", newJString(alt))
  add(query_594222, "oauth_token", newJString(oauthToken))
  add(query_594222, "userIp", newJString(userIp))
  add(query_594222, "key", newJString(key))
  add(query_594222, "copyPresentation", newJBool(copyPresentation))
  add(query_594222, "prettyPrint", newJBool(prettyPrint))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var fusiontablesTableCopy* = Call_FusiontablesTableCopy_594207(
    name: "fusiontablesTableCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/copy",
    validator: validate_FusiontablesTableCopy_594208, base: "/fusiontables/v2",
    url: url_FusiontablesTableCopy_594209, schemes: {Scheme.Https})
type
  Call_FusiontablesTableImportRows_594223 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableImportRows_594225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTableImportRows_594224(path: JsonNode; query: JsonNode;
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
  var valid_594226 = path.getOrDefault("tableId")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "tableId", valid_594226
  result.add "path", section
  ## parameters in `query` object:
  ##   endLine: JInt
  ##          : The index of the line up to which data will be imported. Default is to import the entire file. If endLine is negative, it is an offset from the end of the file; the imported content will exclude the last endLine lines.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   isStrict: JBool
  ##           : Whether the imported CSV must have the same number of values for each row. If false, rows with fewer values will be padded with empty values. Default is true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   delimiter: JString
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  ##   encoding: JString
  ##           : The encoding of the content. Default is UTF-8. Use auto-detect if you are unsure of the encoding.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startLine: JInt
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  section = newJObject()
  var valid_594227 = query.getOrDefault("endLine")
  valid_594227 = validateParameter(valid_594227, JInt, required = false, default = nil)
  if valid_594227 != nil:
    section.add "endLine", valid_594227
  var valid_594228 = query.getOrDefault("fields")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "fields", valid_594228
  var valid_594229 = query.getOrDefault("quotaUser")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "quotaUser", valid_594229
  var valid_594230 = query.getOrDefault("alt")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = newJString("json"))
  if valid_594230 != nil:
    section.add "alt", valid_594230
  var valid_594231 = query.getOrDefault("isStrict")
  valid_594231 = validateParameter(valid_594231, JBool, required = false, default = nil)
  if valid_594231 != nil:
    section.add "isStrict", valid_594231
  var valid_594232 = query.getOrDefault("oauth_token")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "oauth_token", valid_594232
  var valid_594233 = query.getOrDefault("userIp")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "userIp", valid_594233
  var valid_594234 = query.getOrDefault("key")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "key", valid_594234
  var valid_594235 = query.getOrDefault("delimiter")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "delimiter", valid_594235
  var valid_594236 = query.getOrDefault("encoding")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "encoding", valid_594236
  var valid_594237 = query.getOrDefault("prettyPrint")
  valid_594237 = validateParameter(valid_594237, JBool, required = false,
                                 default = newJBool(true))
  if valid_594237 != nil:
    section.add "prettyPrint", valid_594237
  var valid_594238 = query.getOrDefault("startLine")
  valid_594238 = validateParameter(valid_594238, JInt, required = false, default = nil)
  if valid_594238 != nil:
    section.add "startLine", valid_594238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594239: Call_FusiontablesTableImportRows_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports more rows into a table.
  ## 
  let valid = call_594239.validator(path, query, header, formData, body)
  let scheme = call_594239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594239.url(scheme.get, call_594239.host, call_594239.base,
                         call_594239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594239, url, valid)

proc call*(call_594240: Call_FusiontablesTableImportRows_594223; tableId: string;
          endLine: int = 0; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; isStrict: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; delimiter: string = "";
          encoding: string = ""; prettyPrint: bool = true; startLine: int = 0): Recallable =
  ## fusiontablesTableImportRows
  ## Imports more rows into a table.
  ##   endLine: int
  ##          : The index of the line up to which data will be imported. Default is to import the entire file. If endLine is negative, it is an offset from the end of the file; the imported content will exclude the last endLine lines.
  ##   tableId: string (required)
  ##          : The table into which new rows are being imported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   isStrict: bool
  ##           : Whether the imported CSV must have the same number of values for each row. If false, rows with fewer values will be padded with empty values. Default is true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   delimiter: string
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  ##   encoding: string
  ##           : The encoding of the content. Default is UTF-8. Use auto-detect if you are unsure of the encoding.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startLine: int
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  var path_594241 = newJObject()
  var query_594242 = newJObject()
  add(query_594242, "endLine", newJInt(endLine))
  add(path_594241, "tableId", newJString(tableId))
  add(query_594242, "fields", newJString(fields))
  add(query_594242, "quotaUser", newJString(quotaUser))
  add(query_594242, "alt", newJString(alt))
  add(query_594242, "isStrict", newJBool(isStrict))
  add(query_594242, "oauth_token", newJString(oauthToken))
  add(query_594242, "userIp", newJString(userIp))
  add(query_594242, "key", newJString(key))
  add(query_594242, "delimiter", newJString(delimiter))
  add(query_594242, "encoding", newJString(encoding))
  add(query_594242, "prettyPrint", newJBool(prettyPrint))
  add(query_594242, "startLine", newJInt(startLine))
  result = call_594240.call(path_594241, query_594242, nil, nil, nil)

var fusiontablesTableImportRows* = Call_FusiontablesTableImportRows_594223(
    name: "fusiontablesTableImportRows", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/import",
    validator: validate_FusiontablesTableImportRows_594224,
    base: "/fusiontables/v2", url: url_FusiontablesTableImportRows_594225,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableRefetchSheet_594243 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableRefetchSheet_594245(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTableRefetchSheet_594244(path: JsonNode; query: JsonNode;
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
  var valid_594246 = path.getOrDefault("tableId")
  valid_594246 = validateParameter(valid_594246, JString, required = true,
                                 default = nil)
  if valid_594246 != nil:
    section.add "tableId", valid_594246
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594247 = query.getOrDefault("fields")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "fields", valid_594247
  var valid_594248 = query.getOrDefault("quotaUser")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "quotaUser", valid_594248
  var valid_594249 = query.getOrDefault("alt")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = newJString("json"))
  if valid_594249 != nil:
    section.add "alt", valid_594249
  var valid_594250 = query.getOrDefault("oauth_token")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "oauth_token", valid_594250
  var valid_594251 = query.getOrDefault("userIp")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "userIp", valid_594251
  var valid_594252 = query.getOrDefault("key")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = nil)
  if valid_594252 != nil:
    section.add "key", valid_594252
  var valid_594253 = query.getOrDefault("prettyPrint")
  valid_594253 = validateParameter(valid_594253, JBool, required = false,
                                 default = newJBool(true))
  if valid_594253 != nil:
    section.add "prettyPrint", valid_594253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594254: Call_FusiontablesTableRefetchSheet_594243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces rows of the table with the rows of the spreadsheet that is first imported from. Current rows remain visible until all replacement rows are ready.
  ## 
  let valid = call_594254.validator(path, query, header, formData, body)
  let scheme = call_594254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594254.url(scheme.get, call_594254.host, call_594254.base,
                         call_594254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594254, url, valid)

proc call*(call_594255: Call_FusiontablesTableRefetchSheet_594243; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTableRefetchSheet
  ## Replaces rows of the table with the rows of the spreadsheet that is first imported from. Current rows remain visible until all replacement rows are ready.
  ##   tableId: string (required)
  ##          : Table whose rows will be replaced from the spreadsheet.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594256 = newJObject()
  var query_594257 = newJObject()
  add(path_594256, "tableId", newJString(tableId))
  add(query_594257, "fields", newJString(fields))
  add(query_594257, "quotaUser", newJString(quotaUser))
  add(query_594257, "alt", newJString(alt))
  add(query_594257, "oauth_token", newJString(oauthToken))
  add(query_594257, "userIp", newJString(userIp))
  add(query_594257, "key", newJString(key))
  add(query_594257, "prettyPrint", newJBool(prettyPrint))
  result = call_594255.call(path_594256, query_594257, nil, nil, nil)

var fusiontablesTableRefetchSheet* = Call_FusiontablesTableRefetchSheet_594243(
    name: "fusiontablesTableRefetchSheet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/refetch",
    validator: validate_FusiontablesTableRefetchSheet_594244,
    base: "/fusiontables/v2", url: url_FusiontablesTableRefetchSheet_594245,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableReplaceRows_594258 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTableReplaceRows_594260(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTableReplaceRows_594259(path: JsonNode; query: JsonNode;
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
  var valid_594261 = path.getOrDefault("tableId")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "tableId", valid_594261
  result.add "path", section
  ## parameters in `query` object:
  ##   endLine: JInt
  ##          : The index of the line up to which data will be imported. Default is to import the entire file. If endLine is negative, it is an offset from the end of the file; the imported content will exclude the last endLine lines.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   isStrict: JBool
  ##           : Whether the imported CSV must have the same number of column values for each row. If true, throws an exception if the CSV does not have the same number of columns. If false, rows with fewer column values will be padded with empty values. Default is true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   delimiter: JString
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  ##   encoding: JString
  ##           : The encoding of the content. Default is UTF-8. Use 'auto-detect' if you are unsure of the encoding.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startLine: JInt
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  section = newJObject()
  var valid_594262 = query.getOrDefault("endLine")
  valid_594262 = validateParameter(valid_594262, JInt, required = false, default = nil)
  if valid_594262 != nil:
    section.add "endLine", valid_594262
  var valid_594263 = query.getOrDefault("fields")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "fields", valid_594263
  var valid_594264 = query.getOrDefault("quotaUser")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "quotaUser", valid_594264
  var valid_594265 = query.getOrDefault("alt")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = newJString("json"))
  if valid_594265 != nil:
    section.add "alt", valid_594265
  var valid_594266 = query.getOrDefault("isStrict")
  valid_594266 = validateParameter(valid_594266, JBool, required = false, default = nil)
  if valid_594266 != nil:
    section.add "isStrict", valid_594266
  var valid_594267 = query.getOrDefault("oauth_token")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "oauth_token", valid_594267
  var valid_594268 = query.getOrDefault("userIp")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "userIp", valid_594268
  var valid_594269 = query.getOrDefault("key")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "key", valid_594269
  var valid_594270 = query.getOrDefault("delimiter")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "delimiter", valid_594270
  var valid_594271 = query.getOrDefault("encoding")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "encoding", valid_594271
  var valid_594272 = query.getOrDefault("prettyPrint")
  valid_594272 = validateParameter(valid_594272, JBool, required = false,
                                 default = newJBool(true))
  if valid_594272 != nil:
    section.add "prettyPrint", valid_594272
  var valid_594273 = query.getOrDefault("startLine")
  valid_594273 = validateParameter(valid_594273, JInt, required = false, default = nil)
  if valid_594273 != nil:
    section.add "startLine", valid_594273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594274: Call_FusiontablesTableReplaceRows_594258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces rows of an existing table. Current rows remain visible until all replacement rows are ready.
  ## 
  let valid = call_594274.validator(path, query, header, formData, body)
  let scheme = call_594274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594274.url(scheme.get, call_594274.host, call_594274.base,
                         call_594274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594274, url, valid)

proc call*(call_594275: Call_FusiontablesTableReplaceRows_594258; tableId: string;
          endLine: int = 0; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; isStrict: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; delimiter: string = "";
          encoding: string = ""; prettyPrint: bool = true; startLine: int = 0): Recallable =
  ## fusiontablesTableReplaceRows
  ## Replaces rows of an existing table. Current rows remain visible until all replacement rows are ready.
  ##   endLine: int
  ##          : The index of the line up to which data will be imported. Default is to import the entire file. If endLine is negative, it is an offset from the end of the file; the imported content will exclude the last endLine lines.
  ##   tableId: string (required)
  ##          : Table whose rows will be replaced.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   isStrict: bool
  ##           : Whether the imported CSV must have the same number of column values for each row. If true, throws an exception if the CSV does not have the same number of columns. If false, rows with fewer column values will be padded with empty values. Default is true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   delimiter: string
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ,.
  ##   encoding: string
  ##           : The encoding of the content. Default is UTF-8. Use 'auto-detect' if you are unsure of the encoding.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startLine: int
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  var path_594276 = newJObject()
  var query_594277 = newJObject()
  add(query_594277, "endLine", newJInt(endLine))
  add(path_594276, "tableId", newJString(tableId))
  add(query_594277, "fields", newJString(fields))
  add(query_594277, "quotaUser", newJString(quotaUser))
  add(query_594277, "alt", newJString(alt))
  add(query_594277, "isStrict", newJBool(isStrict))
  add(query_594277, "oauth_token", newJString(oauthToken))
  add(query_594277, "userIp", newJString(userIp))
  add(query_594277, "key", newJString(key))
  add(query_594277, "delimiter", newJString(delimiter))
  add(query_594277, "encoding", newJString(encoding))
  add(query_594277, "prettyPrint", newJBool(prettyPrint))
  add(query_594277, "startLine", newJInt(startLine))
  result = call_594275.call(path_594276, query_594277, nil, nil, nil)

var fusiontablesTableReplaceRows* = Call_FusiontablesTableReplaceRows_594258(
    name: "fusiontablesTableReplaceRows", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/replace",
    validator: validate_FusiontablesTableReplaceRows_594259,
    base: "/fusiontables/v2", url: url_FusiontablesTableReplaceRows_594260,
    schemes: {Scheme.Https})
type
  Call_FusiontablesStyleInsert_594295 = ref object of OpenApiRestCall_593424
proc url_FusiontablesStyleInsert_594297(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesStyleInsert_594296(path: JsonNode; query: JsonNode;
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
  var valid_594298 = path.getOrDefault("tableId")
  valid_594298 = validateParameter(valid_594298, JString, required = true,
                                 default = nil)
  if valid_594298 != nil:
    section.add "tableId", valid_594298
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594299 = query.getOrDefault("fields")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "fields", valid_594299
  var valid_594300 = query.getOrDefault("quotaUser")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = nil)
  if valid_594300 != nil:
    section.add "quotaUser", valid_594300
  var valid_594301 = query.getOrDefault("alt")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = newJString("json"))
  if valid_594301 != nil:
    section.add "alt", valid_594301
  var valid_594302 = query.getOrDefault("oauth_token")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "oauth_token", valid_594302
  var valid_594303 = query.getOrDefault("userIp")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "userIp", valid_594303
  var valid_594304 = query.getOrDefault("key")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "key", valid_594304
  var valid_594305 = query.getOrDefault("prettyPrint")
  valid_594305 = validateParameter(valid_594305, JBool, required = false,
                                 default = newJBool(true))
  if valid_594305 != nil:
    section.add "prettyPrint", valid_594305
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

proc call*(call_594307: Call_FusiontablesStyleInsert_594295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new style for the table.
  ## 
  let valid = call_594307.validator(path, query, header, formData, body)
  let scheme = call_594307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594307.url(scheme.get, call_594307.host, call_594307.base,
                         call_594307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594307, url, valid)

proc call*(call_594308: Call_FusiontablesStyleInsert_594295; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesStyleInsert
  ## Adds a new style for the table.
  ##   tableId: string (required)
  ##          : Table for which a new style is being added
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594309 = newJObject()
  var query_594310 = newJObject()
  var body_594311 = newJObject()
  add(path_594309, "tableId", newJString(tableId))
  add(query_594310, "fields", newJString(fields))
  add(query_594310, "quotaUser", newJString(quotaUser))
  add(query_594310, "alt", newJString(alt))
  add(query_594310, "oauth_token", newJString(oauthToken))
  add(query_594310, "userIp", newJString(userIp))
  add(query_594310, "key", newJString(key))
  if body != nil:
    body_594311 = body
  add(query_594310, "prettyPrint", newJBool(prettyPrint))
  result = call_594308.call(path_594309, query_594310, nil, nil, body_594311)

var fusiontablesStyleInsert* = Call_FusiontablesStyleInsert_594295(
    name: "fusiontablesStyleInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles",
    validator: validate_FusiontablesStyleInsert_594296, base: "/fusiontables/v2",
    url: url_FusiontablesStyleInsert_594297, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleList_594278 = ref object of OpenApiRestCall_593424
proc url_FusiontablesStyleList_594280(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesStyleList_594279(path: JsonNode; query: JsonNode;
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
  var valid_594281 = path.getOrDefault("tableId")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "tableId", valid_594281
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token specifying which result page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of styles to return. Optional. Default is 5.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594282 = query.getOrDefault("fields")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "fields", valid_594282
  var valid_594283 = query.getOrDefault("pageToken")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "pageToken", valid_594283
  var valid_594284 = query.getOrDefault("quotaUser")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "quotaUser", valid_594284
  var valid_594285 = query.getOrDefault("alt")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = newJString("json"))
  if valid_594285 != nil:
    section.add "alt", valid_594285
  var valid_594286 = query.getOrDefault("oauth_token")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "oauth_token", valid_594286
  var valid_594287 = query.getOrDefault("userIp")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "userIp", valid_594287
  var valid_594288 = query.getOrDefault("maxResults")
  valid_594288 = validateParameter(valid_594288, JInt, required = false, default = nil)
  if valid_594288 != nil:
    section.add "maxResults", valid_594288
  var valid_594289 = query.getOrDefault("key")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "key", valid_594289
  var valid_594290 = query.getOrDefault("prettyPrint")
  valid_594290 = validateParameter(valid_594290, JBool, required = false,
                                 default = newJBool(true))
  if valid_594290 != nil:
    section.add "prettyPrint", valid_594290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594291: Call_FusiontablesStyleList_594278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of styles.
  ## 
  let valid = call_594291.validator(path, query, header, formData, body)
  let scheme = call_594291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594291.url(scheme.get, call_594291.host, call_594291.base,
                         call_594291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594291, url, valid)

proc call*(call_594292: Call_FusiontablesStyleList_594278; tableId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesStyleList
  ## Retrieves a list of styles.
  ##   tableId: string (required)
  ##          : Table whose styles are being listed
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token specifying which result page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of styles to return. Optional. Default is 5.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594293 = newJObject()
  var query_594294 = newJObject()
  add(path_594293, "tableId", newJString(tableId))
  add(query_594294, "fields", newJString(fields))
  add(query_594294, "pageToken", newJString(pageToken))
  add(query_594294, "quotaUser", newJString(quotaUser))
  add(query_594294, "alt", newJString(alt))
  add(query_594294, "oauth_token", newJString(oauthToken))
  add(query_594294, "userIp", newJString(userIp))
  add(query_594294, "maxResults", newJInt(maxResults))
  add(query_594294, "key", newJString(key))
  add(query_594294, "prettyPrint", newJBool(prettyPrint))
  result = call_594292.call(path_594293, query_594294, nil, nil, nil)

var fusiontablesStyleList* = Call_FusiontablesStyleList_594278(
    name: "fusiontablesStyleList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles",
    validator: validate_FusiontablesStyleList_594279, base: "/fusiontables/v2",
    url: url_FusiontablesStyleList_594280, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleUpdate_594328 = ref object of OpenApiRestCall_593424
proc url_FusiontablesStyleUpdate_594330(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesStyleUpdate_594329(path: JsonNode; query: JsonNode;
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
  var valid_594331 = path.getOrDefault("tableId")
  valid_594331 = validateParameter(valid_594331, JString, required = true,
                                 default = nil)
  if valid_594331 != nil:
    section.add "tableId", valid_594331
  var valid_594332 = path.getOrDefault("styleId")
  valid_594332 = validateParameter(valid_594332, JInt, required = true, default = nil)
  if valid_594332 != nil:
    section.add "styleId", valid_594332
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594333 = query.getOrDefault("fields")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "fields", valid_594333
  var valid_594334 = query.getOrDefault("quotaUser")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "quotaUser", valid_594334
  var valid_594335 = query.getOrDefault("alt")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = newJString("json"))
  if valid_594335 != nil:
    section.add "alt", valid_594335
  var valid_594336 = query.getOrDefault("oauth_token")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = nil)
  if valid_594336 != nil:
    section.add "oauth_token", valid_594336
  var valid_594337 = query.getOrDefault("userIp")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "userIp", valid_594337
  var valid_594338 = query.getOrDefault("key")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "key", valid_594338
  var valid_594339 = query.getOrDefault("prettyPrint")
  valid_594339 = validateParameter(valid_594339, JBool, required = false,
                                 default = newJBool(true))
  if valid_594339 != nil:
    section.add "prettyPrint", valid_594339
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

proc call*(call_594341: Call_FusiontablesStyleUpdate_594328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing style.
  ## 
  let valid = call_594341.validator(path, query, header, formData, body)
  let scheme = call_594341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594341.url(scheme.get, call_594341.host, call_594341.base,
                         call_594341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594341, url, valid)

proc call*(call_594342: Call_FusiontablesStyleUpdate_594328; tableId: string;
          styleId: int; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesStyleUpdate
  ## Updates an existing style.
  ##   tableId: string (required)
  ##          : Table whose style is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   styleId: int (required)
  ##          : Identifier (within a table) for the style being updated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594343 = newJObject()
  var query_594344 = newJObject()
  var body_594345 = newJObject()
  add(path_594343, "tableId", newJString(tableId))
  add(query_594344, "fields", newJString(fields))
  add(query_594344, "quotaUser", newJString(quotaUser))
  add(query_594344, "alt", newJString(alt))
  add(query_594344, "oauth_token", newJString(oauthToken))
  add(query_594344, "userIp", newJString(userIp))
  add(path_594343, "styleId", newJInt(styleId))
  add(query_594344, "key", newJString(key))
  if body != nil:
    body_594345 = body
  add(query_594344, "prettyPrint", newJBool(prettyPrint))
  result = call_594342.call(path_594343, query_594344, nil, nil, body_594345)

var fusiontablesStyleUpdate* = Call_FusiontablesStyleUpdate_594328(
    name: "fusiontablesStyleUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleUpdate_594329, base: "/fusiontables/v2",
    url: url_FusiontablesStyleUpdate_594330, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleGet_594312 = ref object of OpenApiRestCall_593424
proc url_FusiontablesStyleGet_594314(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesStyleGet_594313(path: JsonNode; query: JsonNode;
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
  var valid_594315 = path.getOrDefault("tableId")
  valid_594315 = validateParameter(valid_594315, JString, required = true,
                                 default = nil)
  if valid_594315 != nil:
    section.add "tableId", valid_594315
  var valid_594316 = path.getOrDefault("styleId")
  valid_594316 = validateParameter(valid_594316, JInt, required = true, default = nil)
  if valid_594316 != nil:
    section.add "styleId", valid_594316
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594317 = query.getOrDefault("fields")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "fields", valid_594317
  var valid_594318 = query.getOrDefault("quotaUser")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "quotaUser", valid_594318
  var valid_594319 = query.getOrDefault("alt")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = newJString("json"))
  if valid_594319 != nil:
    section.add "alt", valid_594319
  var valid_594320 = query.getOrDefault("oauth_token")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "oauth_token", valid_594320
  var valid_594321 = query.getOrDefault("userIp")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "userIp", valid_594321
  var valid_594322 = query.getOrDefault("key")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "key", valid_594322
  var valid_594323 = query.getOrDefault("prettyPrint")
  valid_594323 = validateParameter(valid_594323, JBool, required = false,
                                 default = newJBool(true))
  if valid_594323 != nil:
    section.add "prettyPrint", valid_594323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594324: Call_FusiontablesStyleGet_594312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific style.
  ## 
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_FusiontablesStyleGet_594312; tableId: string;
          styleId: int; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## fusiontablesStyleGet
  ## Gets a specific style.
  ##   tableId: string (required)
  ##          : Table to which the requested style belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   styleId: int (required)
  ##          : Identifier (integer) for a specific style in a table
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594326 = newJObject()
  var query_594327 = newJObject()
  add(path_594326, "tableId", newJString(tableId))
  add(query_594327, "fields", newJString(fields))
  add(query_594327, "quotaUser", newJString(quotaUser))
  add(query_594327, "alt", newJString(alt))
  add(query_594327, "oauth_token", newJString(oauthToken))
  add(query_594327, "userIp", newJString(userIp))
  add(path_594326, "styleId", newJInt(styleId))
  add(query_594327, "key", newJString(key))
  add(query_594327, "prettyPrint", newJBool(prettyPrint))
  result = call_594325.call(path_594326, query_594327, nil, nil, nil)

var fusiontablesStyleGet* = Call_FusiontablesStyleGet_594312(
    name: "fusiontablesStyleGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleGet_594313, base: "/fusiontables/v2",
    url: url_FusiontablesStyleGet_594314, schemes: {Scheme.Https})
type
  Call_FusiontablesStylePatch_594362 = ref object of OpenApiRestCall_593424
proc url_FusiontablesStylePatch_594364(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesStylePatch_594363(path: JsonNode; query: JsonNode;
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
  var valid_594365 = path.getOrDefault("tableId")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "tableId", valid_594365
  var valid_594366 = path.getOrDefault("styleId")
  valid_594366 = validateParameter(valid_594366, JInt, required = true, default = nil)
  if valid_594366 != nil:
    section.add "styleId", valid_594366
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594367 = query.getOrDefault("fields")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "fields", valid_594367
  var valid_594368 = query.getOrDefault("quotaUser")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = nil)
  if valid_594368 != nil:
    section.add "quotaUser", valid_594368
  var valid_594369 = query.getOrDefault("alt")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = newJString("json"))
  if valid_594369 != nil:
    section.add "alt", valid_594369
  var valid_594370 = query.getOrDefault("oauth_token")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "oauth_token", valid_594370
  var valid_594371 = query.getOrDefault("userIp")
  valid_594371 = validateParameter(valid_594371, JString, required = false,
                                 default = nil)
  if valid_594371 != nil:
    section.add "userIp", valid_594371
  var valid_594372 = query.getOrDefault("key")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = nil)
  if valid_594372 != nil:
    section.add "key", valid_594372
  var valid_594373 = query.getOrDefault("prettyPrint")
  valid_594373 = validateParameter(valid_594373, JBool, required = false,
                                 default = newJBool(true))
  if valid_594373 != nil:
    section.add "prettyPrint", valid_594373
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

proc call*(call_594375: Call_FusiontablesStylePatch_594362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing style. This method supports patch semantics.
  ## 
  let valid = call_594375.validator(path, query, header, formData, body)
  let scheme = call_594375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594375.url(scheme.get, call_594375.host, call_594375.base,
                         call_594375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594375, url, valid)

proc call*(call_594376: Call_FusiontablesStylePatch_594362; tableId: string;
          styleId: int; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesStylePatch
  ## Updates an existing style. This method supports patch semantics.
  ##   tableId: string (required)
  ##          : Table whose style is being updated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   styleId: int (required)
  ##          : Identifier (within a table) for the style being updated.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594377 = newJObject()
  var query_594378 = newJObject()
  var body_594379 = newJObject()
  add(path_594377, "tableId", newJString(tableId))
  add(query_594378, "fields", newJString(fields))
  add(query_594378, "quotaUser", newJString(quotaUser))
  add(query_594378, "alt", newJString(alt))
  add(query_594378, "oauth_token", newJString(oauthToken))
  add(query_594378, "userIp", newJString(userIp))
  add(path_594377, "styleId", newJInt(styleId))
  add(query_594378, "key", newJString(key))
  if body != nil:
    body_594379 = body
  add(query_594378, "prettyPrint", newJBool(prettyPrint))
  result = call_594376.call(path_594377, query_594378, nil, nil, body_594379)

var fusiontablesStylePatch* = Call_FusiontablesStylePatch_594362(
    name: "fusiontablesStylePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStylePatch_594363, base: "/fusiontables/v2",
    url: url_FusiontablesStylePatch_594364, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleDelete_594346 = ref object of OpenApiRestCall_593424
proc url_FusiontablesStyleDelete_594348(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesStyleDelete_594347(path: JsonNode; query: JsonNode;
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
  var valid_594349 = path.getOrDefault("tableId")
  valid_594349 = validateParameter(valid_594349, JString, required = true,
                                 default = nil)
  if valid_594349 != nil:
    section.add "tableId", valid_594349
  var valid_594350 = path.getOrDefault("styleId")
  valid_594350 = validateParameter(valid_594350, JInt, required = true, default = nil)
  if valid_594350 != nil:
    section.add "styleId", valid_594350
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594351 = query.getOrDefault("fields")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "fields", valid_594351
  var valid_594352 = query.getOrDefault("quotaUser")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = nil)
  if valid_594352 != nil:
    section.add "quotaUser", valid_594352
  var valid_594353 = query.getOrDefault("alt")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = newJString("json"))
  if valid_594353 != nil:
    section.add "alt", valid_594353
  var valid_594354 = query.getOrDefault("oauth_token")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "oauth_token", valid_594354
  var valid_594355 = query.getOrDefault("userIp")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "userIp", valid_594355
  var valid_594356 = query.getOrDefault("key")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "key", valid_594356
  var valid_594357 = query.getOrDefault("prettyPrint")
  valid_594357 = validateParameter(valid_594357, JBool, required = false,
                                 default = newJBool(true))
  if valid_594357 != nil:
    section.add "prettyPrint", valid_594357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594358: Call_FusiontablesStyleDelete_594346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a style.
  ## 
  let valid = call_594358.validator(path, query, header, formData, body)
  let scheme = call_594358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594358.url(scheme.get, call_594358.host, call_594358.base,
                         call_594358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594358, url, valid)

proc call*(call_594359: Call_FusiontablesStyleDelete_594346; tableId: string;
          styleId: int; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## fusiontablesStyleDelete
  ## Deletes a style.
  ##   tableId: string (required)
  ##          : Table from which the style is being deleted
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   styleId: int (required)
  ##          : Identifier (within a table) for the style being deleted
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594360 = newJObject()
  var query_594361 = newJObject()
  add(path_594360, "tableId", newJString(tableId))
  add(query_594361, "fields", newJString(fields))
  add(query_594361, "quotaUser", newJString(quotaUser))
  add(query_594361, "alt", newJString(alt))
  add(query_594361, "oauth_token", newJString(oauthToken))
  add(query_594361, "userIp", newJString(userIp))
  add(path_594360, "styleId", newJInt(styleId))
  add(query_594361, "key", newJString(key))
  add(query_594361, "prettyPrint", newJBool(prettyPrint))
  result = call_594359.call(path_594360, query_594361, nil, nil, nil)

var fusiontablesStyleDelete* = Call_FusiontablesStyleDelete_594346(
    name: "fusiontablesStyleDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleDelete_594347, base: "/fusiontables/v2",
    url: url_FusiontablesStyleDelete_594348, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskList_594380 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTaskList_594382(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTaskList_594381(path: JsonNode; query: JsonNode;
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
  var valid_594383 = path.getOrDefault("tableId")
  valid_594383 = validateParameter(valid_594383, JString, required = true,
                                 default = nil)
  if valid_594383 != nil:
    section.add "tableId", valid_594383
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token specifying which result page to return.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of tasks to return. Default is 5.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  ##             : Index of the first result returned in the current page.
  section = newJObject()
  var valid_594384 = query.getOrDefault("fields")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "fields", valid_594384
  var valid_594385 = query.getOrDefault("pageToken")
  valid_594385 = validateParameter(valid_594385, JString, required = false,
                                 default = nil)
  if valid_594385 != nil:
    section.add "pageToken", valid_594385
  var valid_594386 = query.getOrDefault("quotaUser")
  valid_594386 = validateParameter(valid_594386, JString, required = false,
                                 default = nil)
  if valid_594386 != nil:
    section.add "quotaUser", valid_594386
  var valid_594387 = query.getOrDefault("alt")
  valid_594387 = validateParameter(valid_594387, JString, required = false,
                                 default = newJString("json"))
  if valid_594387 != nil:
    section.add "alt", valid_594387
  var valid_594388 = query.getOrDefault("oauth_token")
  valid_594388 = validateParameter(valid_594388, JString, required = false,
                                 default = nil)
  if valid_594388 != nil:
    section.add "oauth_token", valid_594388
  var valid_594389 = query.getOrDefault("userIp")
  valid_594389 = validateParameter(valid_594389, JString, required = false,
                                 default = nil)
  if valid_594389 != nil:
    section.add "userIp", valid_594389
  var valid_594390 = query.getOrDefault("maxResults")
  valid_594390 = validateParameter(valid_594390, JInt, required = false, default = nil)
  if valid_594390 != nil:
    section.add "maxResults", valid_594390
  var valid_594391 = query.getOrDefault("key")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "key", valid_594391
  var valid_594392 = query.getOrDefault("prettyPrint")
  valid_594392 = validateParameter(valid_594392, JBool, required = false,
                                 default = newJBool(true))
  if valid_594392 != nil:
    section.add "prettyPrint", valid_594392
  var valid_594393 = query.getOrDefault("startIndex")
  valid_594393 = validateParameter(valid_594393, JInt, required = false, default = nil)
  if valid_594393 != nil:
    section.add "startIndex", valid_594393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594394: Call_FusiontablesTaskList_594380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of tasks.
  ## 
  let valid = call_594394.validator(path, query, header, formData, body)
  let scheme = call_594394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594394.url(scheme.get, call_594394.host, call_594394.base,
                         call_594394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594394, url, valid)

proc call*(call_594395: Call_FusiontablesTaskList_594380; tableId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true;
          startIndex: int = 0): Recallable =
  ## fusiontablesTaskList
  ## Retrieves a list of tasks.
  ##   tableId: string (required)
  ##          : Table whose tasks are being listed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token specifying which result page to return.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of tasks to return. Default is 5.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  ##             : Index of the first result returned in the current page.
  var path_594396 = newJObject()
  var query_594397 = newJObject()
  add(path_594396, "tableId", newJString(tableId))
  add(query_594397, "fields", newJString(fields))
  add(query_594397, "pageToken", newJString(pageToken))
  add(query_594397, "quotaUser", newJString(quotaUser))
  add(query_594397, "alt", newJString(alt))
  add(query_594397, "oauth_token", newJString(oauthToken))
  add(query_594397, "userIp", newJString(userIp))
  add(query_594397, "maxResults", newJInt(maxResults))
  add(query_594397, "key", newJString(key))
  add(query_594397, "prettyPrint", newJBool(prettyPrint))
  add(query_594397, "startIndex", newJInt(startIndex))
  result = call_594395.call(path_594396, query_594397, nil, nil, nil)

var fusiontablesTaskList* = Call_FusiontablesTaskList_594380(
    name: "fusiontablesTaskList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks",
    validator: validate_FusiontablesTaskList_594381, base: "/fusiontables/v2",
    url: url_FusiontablesTaskList_594382, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskGet_594398 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTaskGet_594400(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTaskGet_594399(path: JsonNode; query: JsonNode;
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
  var valid_594401 = path.getOrDefault("tableId")
  valid_594401 = validateParameter(valid_594401, JString, required = true,
                                 default = nil)
  if valid_594401 != nil:
    section.add "tableId", valid_594401
  var valid_594402 = path.getOrDefault("taskId")
  valid_594402 = validateParameter(valid_594402, JString, required = true,
                                 default = nil)
  if valid_594402 != nil:
    section.add "taskId", valid_594402
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594403 = query.getOrDefault("fields")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "fields", valid_594403
  var valid_594404 = query.getOrDefault("quotaUser")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "quotaUser", valid_594404
  var valid_594405 = query.getOrDefault("alt")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = newJString("json"))
  if valid_594405 != nil:
    section.add "alt", valid_594405
  var valid_594406 = query.getOrDefault("oauth_token")
  valid_594406 = validateParameter(valid_594406, JString, required = false,
                                 default = nil)
  if valid_594406 != nil:
    section.add "oauth_token", valid_594406
  var valid_594407 = query.getOrDefault("userIp")
  valid_594407 = validateParameter(valid_594407, JString, required = false,
                                 default = nil)
  if valid_594407 != nil:
    section.add "userIp", valid_594407
  var valid_594408 = query.getOrDefault("key")
  valid_594408 = validateParameter(valid_594408, JString, required = false,
                                 default = nil)
  if valid_594408 != nil:
    section.add "key", valid_594408
  var valid_594409 = query.getOrDefault("prettyPrint")
  valid_594409 = validateParameter(valid_594409, JBool, required = false,
                                 default = newJBool(true))
  if valid_594409 != nil:
    section.add "prettyPrint", valid_594409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594410: Call_FusiontablesTaskGet_594398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific task by its ID.
  ## 
  let valid = call_594410.validator(path, query, header, formData, body)
  let scheme = call_594410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594410.url(scheme.get, call_594410.host, call_594410.base,
                         call_594410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594410, url, valid)

proc call*(call_594411: Call_FusiontablesTaskGet_594398; tableId: string;
          taskId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTaskGet
  ## Retrieves a specific task by its ID.
  ##   tableId: string (required)
  ##          : Table to which the task belongs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskId: string (required)
  ##         : The identifier of the task to get.
  var path_594412 = newJObject()
  var query_594413 = newJObject()
  add(path_594412, "tableId", newJString(tableId))
  add(query_594413, "fields", newJString(fields))
  add(query_594413, "quotaUser", newJString(quotaUser))
  add(query_594413, "alt", newJString(alt))
  add(query_594413, "oauth_token", newJString(oauthToken))
  add(query_594413, "userIp", newJString(userIp))
  add(query_594413, "key", newJString(key))
  add(query_594413, "prettyPrint", newJBool(prettyPrint))
  add(path_594412, "taskId", newJString(taskId))
  result = call_594411.call(path_594412, query_594413, nil, nil, nil)

var fusiontablesTaskGet* = Call_FusiontablesTaskGet_594398(
    name: "fusiontablesTaskGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks/{taskId}",
    validator: validate_FusiontablesTaskGet_594399, base: "/fusiontables/v2",
    url: url_FusiontablesTaskGet_594400, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskDelete_594414 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTaskDelete_594416(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTaskDelete_594415(path: JsonNode; query: JsonNode;
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
  var valid_594417 = path.getOrDefault("tableId")
  valid_594417 = validateParameter(valid_594417, JString, required = true,
                                 default = nil)
  if valid_594417 != nil:
    section.add "tableId", valid_594417
  var valid_594418 = path.getOrDefault("taskId")
  valid_594418 = validateParameter(valid_594418, JString, required = true,
                                 default = nil)
  if valid_594418 != nil:
    section.add "taskId", valid_594418
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594419 = query.getOrDefault("fields")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = nil)
  if valid_594419 != nil:
    section.add "fields", valid_594419
  var valid_594420 = query.getOrDefault("quotaUser")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "quotaUser", valid_594420
  var valid_594421 = query.getOrDefault("alt")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = newJString("json"))
  if valid_594421 != nil:
    section.add "alt", valid_594421
  var valid_594422 = query.getOrDefault("oauth_token")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "oauth_token", valid_594422
  var valid_594423 = query.getOrDefault("userIp")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "userIp", valid_594423
  var valid_594424 = query.getOrDefault("key")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "key", valid_594424
  var valid_594425 = query.getOrDefault("prettyPrint")
  valid_594425 = validateParameter(valid_594425, JBool, required = false,
                                 default = newJBool(true))
  if valid_594425 != nil:
    section.add "prettyPrint", valid_594425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594426: Call_FusiontablesTaskDelete_594414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific task by its ID, unless that task has already started running.
  ## 
  let valid = call_594426.validator(path, query, header, formData, body)
  let scheme = call_594426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594426.url(scheme.get, call_594426.host, call_594426.base,
                         call_594426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594426, url, valid)

proc call*(call_594427: Call_FusiontablesTaskDelete_594414; tableId: string;
          taskId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTaskDelete
  ## Deletes a specific task by its ID, unless that task has already started running.
  ##   tableId: string (required)
  ##          : Table from which the task is being deleted.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   taskId: string (required)
  ##         : The identifier of the task to delete.
  var path_594428 = newJObject()
  var query_594429 = newJObject()
  add(path_594428, "tableId", newJString(tableId))
  add(query_594429, "fields", newJString(fields))
  add(query_594429, "quotaUser", newJString(quotaUser))
  add(query_594429, "alt", newJString(alt))
  add(query_594429, "oauth_token", newJString(oauthToken))
  add(query_594429, "userIp", newJString(userIp))
  add(query_594429, "key", newJString(key))
  add(query_594429, "prettyPrint", newJBool(prettyPrint))
  add(path_594428, "taskId", newJString(taskId))
  result = call_594427.call(path_594428, query_594429, nil, nil, nil)

var fusiontablesTaskDelete* = Call_FusiontablesTaskDelete_594414(
    name: "fusiontablesTaskDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks/{taskId}",
    validator: validate_FusiontablesTaskDelete_594415, base: "/fusiontables/v2",
    url: url_FusiontablesTaskDelete_594416, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateInsert_594447 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTemplateInsert_594449(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTemplateInsert_594448(path: JsonNode; query: JsonNode;
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
  var valid_594450 = path.getOrDefault("tableId")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "tableId", valid_594450
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594451 = query.getOrDefault("fields")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = nil)
  if valid_594451 != nil:
    section.add "fields", valid_594451
  var valid_594452 = query.getOrDefault("quotaUser")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "quotaUser", valid_594452
  var valid_594453 = query.getOrDefault("alt")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = newJString("json"))
  if valid_594453 != nil:
    section.add "alt", valid_594453
  var valid_594454 = query.getOrDefault("oauth_token")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "oauth_token", valid_594454
  var valid_594455 = query.getOrDefault("userIp")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "userIp", valid_594455
  var valid_594456 = query.getOrDefault("key")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = nil)
  if valid_594456 != nil:
    section.add "key", valid_594456
  var valid_594457 = query.getOrDefault("prettyPrint")
  valid_594457 = validateParameter(valid_594457, JBool, required = false,
                                 default = newJBool(true))
  if valid_594457 != nil:
    section.add "prettyPrint", valid_594457
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

proc call*(call_594459: Call_FusiontablesTemplateInsert_594447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new template for the table.
  ## 
  let valid = call_594459.validator(path, query, header, formData, body)
  let scheme = call_594459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594459.url(scheme.get, call_594459.host, call_594459.base,
                         call_594459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594459, url, valid)

proc call*(call_594460: Call_FusiontablesTemplateInsert_594447; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesTemplateInsert
  ## Creates a new template for the table.
  ##   tableId: string (required)
  ##          : Table for which a new template is being created
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594461 = newJObject()
  var query_594462 = newJObject()
  var body_594463 = newJObject()
  add(path_594461, "tableId", newJString(tableId))
  add(query_594462, "fields", newJString(fields))
  add(query_594462, "quotaUser", newJString(quotaUser))
  add(query_594462, "alt", newJString(alt))
  add(query_594462, "oauth_token", newJString(oauthToken))
  add(query_594462, "userIp", newJString(userIp))
  add(query_594462, "key", newJString(key))
  if body != nil:
    body_594463 = body
  add(query_594462, "prettyPrint", newJBool(prettyPrint))
  result = call_594460.call(path_594461, query_594462, nil, nil, body_594463)

var fusiontablesTemplateInsert* = Call_FusiontablesTemplateInsert_594447(
    name: "fusiontablesTemplateInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates",
    validator: validate_FusiontablesTemplateInsert_594448,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateInsert_594449,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateList_594430 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTemplateList_594432(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTemplateList_594431(path: JsonNode; query: JsonNode;
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
  var valid_594433 = path.getOrDefault("tableId")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "tableId", valid_594433
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Continuation token specifying which results page to return. Optional.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of templates to return. Optional. Default is 5.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594434 = query.getOrDefault("fields")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "fields", valid_594434
  var valid_594435 = query.getOrDefault("pageToken")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "pageToken", valid_594435
  var valid_594436 = query.getOrDefault("quotaUser")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "quotaUser", valid_594436
  var valid_594437 = query.getOrDefault("alt")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = newJString("json"))
  if valid_594437 != nil:
    section.add "alt", valid_594437
  var valid_594438 = query.getOrDefault("oauth_token")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "oauth_token", valid_594438
  var valid_594439 = query.getOrDefault("userIp")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "userIp", valid_594439
  var valid_594440 = query.getOrDefault("maxResults")
  valid_594440 = validateParameter(valid_594440, JInt, required = false, default = nil)
  if valid_594440 != nil:
    section.add "maxResults", valid_594440
  var valid_594441 = query.getOrDefault("key")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = nil)
  if valid_594441 != nil:
    section.add "key", valid_594441
  var valid_594442 = query.getOrDefault("prettyPrint")
  valid_594442 = validateParameter(valid_594442, JBool, required = false,
                                 default = newJBool(true))
  if valid_594442 != nil:
    section.add "prettyPrint", valid_594442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594443: Call_FusiontablesTemplateList_594430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of templates.
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_FusiontablesTemplateList_594430; tableId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTemplateList
  ## Retrieves a list of templates.
  ##   tableId: string (required)
  ##          : Identifier for the table whose templates are being requested
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Continuation token specifying which results page to return. Optional.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of templates to return. Optional. Default is 5.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594445 = newJObject()
  var query_594446 = newJObject()
  add(path_594445, "tableId", newJString(tableId))
  add(query_594446, "fields", newJString(fields))
  add(query_594446, "pageToken", newJString(pageToken))
  add(query_594446, "quotaUser", newJString(quotaUser))
  add(query_594446, "alt", newJString(alt))
  add(query_594446, "oauth_token", newJString(oauthToken))
  add(query_594446, "userIp", newJString(userIp))
  add(query_594446, "maxResults", newJInt(maxResults))
  add(query_594446, "key", newJString(key))
  add(query_594446, "prettyPrint", newJBool(prettyPrint))
  result = call_594444.call(path_594445, query_594446, nil, nil, nil)

var fusiontablesTemplateList* = Call_FusiontablesTemplateList_594430(
    name: "fusiontablesTemplateList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates",
    validator: validate_FusiontablesTemplateList_594431, base: "/fusiontables/v2",
    url: url_FusiontablesTemplateList_594432, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateUpdate_594480 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTemplateUpdate_594482(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTemplateUpdate_594481(path: JsonNode; query: JsonNode;
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
  var valid_594483 = path.getOrDefault("tableId")
  valid_594483 = validateParameter(valid_594483, JString, required = true,
                                 default = nil)
  if valid_594483 != nil:
    section.add "tableId", valid_594483
  var valid_594484 = path.getOrDefault("templateId")
  valid_594484 = validateParameter(valid_594484, JInt, required = true, default = nil)
  if valid_594484 != nil:
    section.add "templateId", valid_594484
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594485 = query.getOrDefault("fields")
  valid_594485 = validateParameter(valid_594485, JString, required = false,
                                 default = nil)
  if valid_594485 != nil:
    section.add "fields", valid_594485
  var valid_594486 = query.getOrDefault("quotaUser")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = nil)
  if valid_594486 != nil:
    section.add "quotaUser", valid_594486
  var valid_594487 = query.getOrDefault("alt")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = newJString("json"))
  if valid_594487 != nil:
    section.add "alt", valid_594487
  var valid_594488 = query.getOrDefault("oauth_token")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "oauth_token", valid_594488
  var valid_594489 = query.getOrDefault("userIp")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "userIp", valid_594489
  var valid_594490 = query.getOrDefault("key")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "key", valid_594490
  var valid_594491 = query.getOrDefault("prettyPrint")
  valid_594491 = validateParameter(valid_594491, JBool, required = false,
                                 default = newJBool(true))
  if valid_594491 != nil:
    section.add "prettyPrint", valid_594491
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

proc call*(call_594493: Call_FusiontablesTemplateUpdate_594480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing template
  ## 
  let valid = call_594493.validator(path, query, header, formData, body)
  let scheme = call_594493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594493.url(scheme.get, call_594493.host, call_594493.base,
                         call_594493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594493, url, valid)

proc call*(call_594494: Call_FusiontablesTemplateUpdate_594480; tableId: string;
          templateId: int; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesTemplateUpdate
  ## Updates an existing template
  ##   tableId: string (required)
  ##          : Table to which the updated template belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   templateId: int (required)
  ##             : Identifier for the template that is being updated
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594495 = newJObject()
  var query_594496 = newJObject()
  var body_594497 = newJObject()
  add(path_594495, "tableId", newJString(tableId))
  add(query_594496, "fields", newJString(fields))
  add(query_594496, "quotaUser", newJString(quotaUser))
  add(query_594496, "alt", newJString(alt))
  add(path_594495, "templateId", newJInt(templateId))
  add(query_594496, "oauth_token", newJString(oauthToken))
  add(query_594496, "userIp", newJString(userIp))
  add(query_594496, "key", newJString(key))
  if body != nil:
    body_594497 = body
  add(query_594496, "prettyPrint", newJBool(prettyPrint))
  result = call_594494.call(path_594495, query_594496, nil, nil, body_594497)

var fusiontablesTemplateUpdate* = Call_FusiontablesTemplateUpdate_594480(
    name: "fusiontablesTemplateUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateUpdate_594481,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateUpdate_594482,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateGet_594464 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTemplateGet_594466(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTemplateGet_594465(path: JsonNode; query: JsonNode;
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
  var valid_594467 = path.getOrDefault("tableId")
  valid_594467 = validateParameter(valid_594467, JString, required = true,
                                 default = nil)
  if valid_594467 != nil:
    section.add "tableId", valid_594467
  var valid_594468 = path.getOrDefault("templateId")
  valid_594468 = validateParameter(valid_594468, JInt, required = true, default = nil)
  if valid_594468 != nil:
    section.add "templateId", valid_594468
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594469 = query.getOrDefault("fields")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = nil)
  if valid_594469 != nil:
    section.add "fields", valid_594469
  var valid_594470 = query.getOrDefault("quotaUser")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "quotaUser", valid_594470
  var valid_594471 = query.getOrDefault("alt")
  valid_594471 = validateParameter(valid_594471, JString, required = false,
                                 default = newJString("json"))
  if valid_594471 != nil:
    section.add "alt", valid_594471
  var valid_594472 = query.getOrDefault("oauth_token")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "oauth_token", valid_594472
  var valid_594473 = query.getOrDefault("userIp")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "userIp", valid_594473
  var valid_594474 = query.getOrDefault("key")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = nil)
  if valid_594474 != nil:
    section.add "key", valid_594474
  var valid_594475 = query.getOrDefault("prettyPrint")
  valid_594475 = validateParameter(valid_594475, JBool, required = false,
                                 default = newJBool(true))
  if valid_594475 != nil:
    section.add "prettyPrint", valid_594475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594476: Call_FusiontablesTemplateGet_594464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific template by its id
  ## 
  let valid = call_594476.validator(path, query, header, formData, body)
  let scheme = call_594476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594476.url(scheme.get, call_594476.host, call_594476.base,
                         call_594476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594476, url, valid)

proc call*(call_594477: Call_FusiontablesTemplateGet_594464; tableId: string;
          templateId: int; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTemplateGet
  ## Retrieves a specific template by its id
  ##   tableId: string (required)
  ##          : Table to which the template belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   templateId: int (required)
  ##             : Identifier for the template that is being requested
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594478 = newJObject()
  var query_594479 = newJObject()
  add(path_594478, "tableId", newJString(tableId))
  add(query_594479, "fields", newJString(fields))
  add(query_594479, "quotaUser", newJString(quotaUser))
  add(query_594479, "alt", newJString(alt))
  add(path_594478, "templateId", newJInt(templateId))
  add(query_594479, "oauth_token", newJString(oauthToken))
  add(query_594479, "userIp", newJString(userIp))
  add(query_594479, "key", newJString(key))
  add(query_594479, "prettyPrint", newJBool(prettyPrint))
  result = call_594477.call(path_594478, query_594479, nil, nil, nil)

var fusiontablesTemplateGet* = Call_FusiontablesTemplateGet_594464(
    name: "fusiontablesTemplateGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateGet_594465, base: "/fusiontables/v2",
    url: url_FusiontablesTemplateGet_594466, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplatePatch_594514 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTemplatePatch_594516(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTemplatePatch_594515(path: JsonNode; query: JsonNode;
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
  var valid_594517 = path.getOrDefault("tableId")
  valid_594517 = validateParameter(valid_594517, JString, required = true,
                                 default = nil)
  if valid_594517 != nil:
    section.add "tableId", valid_594517
  var valid_594518 = path.getOrDefault("templateId")
  valid_594518 = validateParameter(valid_594518, JInt, required = true, default = nil)
  if valid_594518 != nil:
    section.add "templateId", valid_594518
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594519 = query.getOrDefault("fields")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = nil)
  if valid_594519 != nil:
    section.add "fields", valid_594519
  var valid_594520 = query.getOrDefault("quotaUser")
  valid_594520 = validateParameter(valid_594520, JString, required = false,
                                 default = nil)
  if valid_594520 != nil:
    section.add "quotaUser", valid_594520
  var valid_594521 = query.getOrDefault("alt")
  valid_594521 = validateParameter(valid_594521, JString, required = false,
                                 default = newJString("json"))
  if valid_594521 != nil:
    section.add "alt", valid_594521
  var valid_594522 = query.getOrDefault("oauth_token")
  valid_594522 = validateParameter(valid_594522, JString, required = false,
                                 default = nil)
  if valid_594522 != nil:
    section.add "oauth_token", valid_594522
  var valid_594523 = query.getOrDefault("userIp")
  valid_594523 = validateParameter(valid_594523, JString, required = false,
                                 default = nil)
  if valid_594523 != nil:
    section.add "userIp", valid_594523
  var valid_594524 = query.getOrDefault("key")
  valid_594524 = validateParameter(valid_594524, JString, required = false,
                                 default = nil)
  if valid_594524 != nil:
    section.add "key", valid_594524
  var valid_594525 = query.getOrDefault("prettyPrint")
  valid_594525 = validateParameter(valid_594525, JBool, required = false,
                                 default = newJBool(true))
  if valid_594525 != nil:
    section.add "prettyPrint", valid_594525
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

proc call*(call_594527: Call_FusiontablesTemplatePatch_594514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing template. This method supports patch semantics.
  ## 
  let valid = call_594527.validator(path, query, header, formData, body)
  let scheme = call_594527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594527.url(scheme.get, call_594527.host, call_594527.base,
                         call_594527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594527, url, valid)

proc call*(call_594528: Call_FusiontablesTemplatePatch_594514; tableId: string;
          templateId: int; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## fusiontablesTemplatePatch
  ## Updates an existing template. This method supports patch semantics.
  ##   tableId: string (required)
  ##          : Table to which the updated template belongs
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   templateId: int (required)
  ##             : Identifier for the template that is being updated
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594529 = newJObject()
  var query_594530 = newJObject()
  var body_594531 = newJObject()
  add(path_594529, "tableId", newJString(tableId))
  add(query_594530, "fields", newJString(fields))
  add(query_594530, "quotaUser", newJString(quotaUser))
  add(query_594530, "alt", newJString(alt))
  add(path_594529, "templateId", newJInt(templateId))
  add(query_594530, "oauth_token", newJString(oauthToken))
  add(query_594530, "userIp", newJString(userIp))
  add(query_594530, "key", newJString(key))
  if body != nil:
    body_594531 = body
  add(query_594530, "prettyPrint", newJBool(prettyPrint))
  result = call_594528.call(path_594529, query_594530, nil, nil, body_594531)

var fusiontablesTemplatePatch* = Call_FusiontablesTemplatePatch_594514(
    name: "fusiontablesTemplatePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplatePatch_594515,
    base: "/fusiontables/v2", url: url_FusiontablesTemplatePatch_594516,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateDelete_594498 = ref object of OpenApiRestCall_593424
proc url_FusiontablesTemplateDelete_594500(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_FusiontablesTemplateDelete_594499(path: JsonNode; query: JsonNode;
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
  var valid_594501 = path.getOrDefault("tableId")
  valid_594501 = validateParameter(valid_594501, JString, required = true,
                                 default = nil)
  if valid_594501 != nil:
    section.add "tableId", valid_594501
  var valid_594502 = path.getOrDefault("templateId")
  valid_594502 = validateParameter(valid_594502, JInt, required = true, default = nil)
  if valid_594502 != nil:
    section.add "templateId", valid_594502
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594503 = query.getOrDefault("fields")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "fields", valid_594503
  var valid_594504 = query.getOrDefault("quotaUser")
  valid_594504 = validateParameter(valid_594504, JString, required = false,
                                 default = nil)
  if valid_594504 != nil:
    section.add "quotaUser", valid_594504
  var valid_594505 = query.getOrDefault("alt")
  valid_594505 = validateParameter(valid_594505, JString, required = false,
                                 default = newJString("json"))
  if valid_594505 != nil:
    section.add "alt", valid_594505
  var valid_594506 = query.getOrDefault("oauth_token")
  valid_594506 = validateParameter(valid_594506, JString, required = false,
                                 default = nil)
  if valid_594506 != nil:
    section.add "oauth_token", valid_594506
  var valid_594507 = query.getOrDefault("userIp")
  valid_594507 = validateParameter(valid_594507, JString, required = false,
                                 default = nil)
  if valid_594507 != nil:
    section.add "userIp", valid_594507
  var valid_594508 = query.getOrDefault("key")
  valid_594508 = validateParameter(valid_594508, JString, required = false,
                                 default = nil)
  if valid_594508 != nil:
    section.add "key", valid_594508
  var valid_594509 = query.getOrDefault("prettyPrint")
  valid_594509 = validateParameter(valid_594509, JBool, required = false,
                                 default = newJBool(true))
  if valid_594509 != nil:
    section.add "prettyPrint", valid_594509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594510: Call_FusiontablesTemplateDelete_594498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a template
  ## 
  let valid = call_594510.validator(path, query, header, formData, body)
  let scheme = call_594510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594510.url(scheme.get, call_594510.host, call_594510.base,
                         call_594510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594510, url, valid)

proc call*(call_594511: Call_FusiontablesTemplateDelete_594498; tableId: string;
          templateId: int; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTemplateDelete
  ## Deletes a template
  ##   tableId: string (required)
  ##          : Table from which the template is being deleted
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   templateId: int (required)
  ##             : Identifier for the template which is being deleted
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594512 = newJObject()
  var query_594513 = newJObject()
  add(path_594512, "tableId", newJString(tableId))
  add(query_594513, "fields", newJString(fields))
  add(query_594513, "quotaUser", newJString(quotaUser))
  add(query_594513, "alt", newJString(alt))
  add(path_594512, "templateId", newJInt(templateId))
  add(query_594513, "oauth_token", newJString(oauthToken))
  add(query_594513, "userIp", newJString(userIp))
  add(query_594513, "key", newJString(key))
  add(query_594513, "prettyPrint", newJBool(prettyPrint))
  result = call_594511.call(path_594512, query_594513, nil, nil, nil)

var fusiontablesTemplateDelete* = Call_FusiontablesTemplateDelete_594498(
    name: "fusiontablesTemplateDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateDelete_594499,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateDelete_594500,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
