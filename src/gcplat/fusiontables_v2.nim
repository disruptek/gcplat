
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_FusiontablesQuerySql_579963 = ref object of OpenApiRestCall_579424
proc url_FusiontablesQuerySql_579965(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesQuerySql_579964(path: JsonNode; query: JsonNode;
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
  var valid_579966 = query.getOrDefault("fields")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "fields", valid_579966
  var valid_579967 = query.getOrDefault("quotaUser")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "quotaUser", valid_579967
  var valid_579968 = query.getOrDefault("alt")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = newJString("json"))
  if valid_579968 != nil:
    section.add "alt", valid_579968
  var valid_579969 = query.getOrDefault("typed")
  valid_579969 = validateParameter(valid_579969, JBool, required = false, default = nil)
  if valid_579969 != nil:
    section.add "typed", valid_579969
  assert query != nil, "query argument is necessary due to required `sql` field"
  var valid_579970 = query.getOrDefault("sql")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "sql", valid_579970
  var valid_579971 = query.getOrDefault("oauth_token")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "oauth_token", valid_579971
  var valid_579972 = query.getOrDefault("userIp")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "userIp", valid_579972
  var valid_579973 = query.getOrDefault("hdrs")
  valid_579973 = validateParameter(valid_579973, JBool, required = false, default = nil)
  if valid_579973 != nil:
    section.add "hdrs", valid_579973
  var valid_579974 = query.getOrDefault("key")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "key", valid_579974
  var valid_579975 = query.getOrDefault("prettyPrint")
  valid_579975 = validateParameter(valid_579975, JBool, required = false,
                                 default = newJBool(true))
  if valid_579975 != nil:
    section.add "prettyPrint", valid_579975
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579976: Call_FusiontablesQuerySql_579963; path: JsonNode;
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
  let valid = call_579976.validator(path, query, header, formData, body)
  let scheme = call_579976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579976.url(scheme.get, call_579976.host, call_579976.base,
                         call_579976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579976, url, valid)

proc call*(call_579977: Call_FusiontablesQuerySql_579963; sql: string;
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
  var query_579978 = newJObject()
  add(query_579978, "fields", newJString(fields))
  add(query_579978, "quotaUser", newJString(quotaUser))
  add(query_579978, "alt", newJString(alt))
  add(query_579978, "typed", newJBool(typed))
  add(query_579978, "sql", newJString(sql))
  add(query_579978, "oauth_token", newJString(oauthToken))
  add(query_579978, "userIp", newJString(userIp))
  add(query_579978, "hdrs", newJBool(hdrs))
  add(query_579978, "key", newJString(key))
  add(query_579978, "prettyPrint", newJBool(prettyPrint))
  result = call_579977.call(nil, query_579978, nil, nil, nil)

var fusiontablesQuerySql* = Call_FusiontablesQuerySql_579963(
    name: "fusiontablesQuerySql", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_FusiontablesQuerySql_579964, base: "/fusiontables/v2",
    url: url_FusiontablesQuerySql_579965, schemes: {Scheme.Https})
type
  Call_FusiontablesQuerySqlGet_579692 = ref object of OpenApiRestCall_579424
proc url_FusiontablesQuerySqlGet_579694(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesQuerySqlGet_579693(path: JsonNode; query: JsonNode;
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
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("quotaUser")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "quotaUser", valid_579807
  var valid_579821 = query.getOrDefault("alt")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = newJString("json"))
  if valid_579821 != nil:
    section.add "alt", valid_579821
  var valid_579822 = query.getOrDefault("typed")
  valid_579822 = validateParameter(valid_579822, JBool, required = false, default = nil)
  if valid_579822 != nil:
    section.add "typed", valid_579822
  assert query != nil, "query argument is necessary due to required `sql` field"
  var valid_579823 = query.getOrDefault("sql")
  valid_579823 = validateParameter(valid_579823, JString, required = true,
                                 default = nil)
  if valid_579823 != nil:
    section.add "sql", valid_579823
  var valid_579824 = query.getOrDefault("oauth_token")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "oauth_token", valid_579824
  var valid_579825 = query.getOrDefault("userIp")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "userIp", valid_579825
  var valid_579826 = query.getOrDefault("hdrs")
  valid_579826 = validateParameter(valid_579826, JBool, required = false, default = nil)
  if valid_579826 != nil:
    section.add "hdrs", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("prettyPrint")
  valid_579828 = validateParameter(valid_579828, JBool, required = false,
                                 default = newJBool(true))
  if valid_579828 != nil:
    section.add "prettyPrint", valid_579828
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579851: Call_FusiontablesQuerySqlGet_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes a SQL statement which can be any of 
  ## - SELECT
  ## - SHOW
  ## - DESCRIBE
  ## 
  let valid = call_579851.validator(path, query, header, formData, body)
  let scheme = call_579851.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579851.url(scheme.get, call_579851.host, call_579851.base,
                         call_579851.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579851, url, valid)

proc call*(call_579922: Call_FusiontablesQuerySqlGet_579692; sql: string;
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
  var query_579923 = newJObject()
  add(query_579923, "fields", newJString(fields))
  add(query_579923, "quotaUser", newJString(quotaUser))
  add(query_579923, "alt", newJString(alt))
  add(query_579923, "typed", newJBool(typed))
  add(query_579923, "sql", newJString(sql))
  add(query_579923, "oauth_token", newJString(oauthToken))
  add(query_579923, "userIp", newJString(userIp))
  add(query_579923, "hdrs", newJBool(hdrs))
  add(query_579923, "key", newJString(key))
  add(query_579923, "prettyPrint", newJBool(prettyPrint))
  result = call_579922.call(nil, query_579923, nil, nil, nil)

var fusiontablesQuerySqlGet* = Call_FusiontablesQuerySqlGet_579692(
    name: "fusiontablesQuerySqlGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query",
    validator: validate_FusiontablesQuerySqlGet_579693, base: "/fusiontables/v2",
    url: url_FusiontablesQuerySqlGet_579694, schemes: {Scheme.Https})
type
  Call_FusiontablesTableInsert_579994 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableInsert_579996(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableInsert_579995(path: JsonNode; query: JsonNode;
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
  var valid_579997 = query.getOrDefault("fields")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "fields", valid_579997
  var valid_579998 = query.getOrDefault("quotaUser")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "quotaUser", valid_579998
  var valid_579999 = query.getOrDefault("alt")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = newJString("json"))
  if valid_579999 != nil:
    section.add "alt", valid_579999
  var valid_580000 = query.getOrDefault("oauth_token")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "oauth_token", valid_580000
  var valid_580001 = query.getOrDefault("userIp")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "userIp", valid_580001
  var valid_580002 = query.getOrDefault("key")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "key", valid_580002
  var valid_580003 = query.getOrDefault("prettyPrint")
  valid_580003 = validateParameter(valid_580003, JBool, required = false,
                                 default = newJBool(true))
  if valid_580003 != nil:
    section.add "prettyPrint", valid_580003
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

proc call*(call_580005: Call_FusiontablesTableInsert_579994; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new table.
  ## 
  let valid = call_580005.validator(path, query, header, formData, body)
  let scheme = call_580005.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580005.url(scheme.get, call_580005.host, call_580005.base,
                         call_580005.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580005, url, valid)

proc call*(call_580006: Call_FusiontablesTableInsert_579994; fields: string = "";
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
  var query_580007 = newJObject()
  var body_580008 = newJObject()
  add(query_580007, "fields", newJString(fields))
  add(query_580007, "quotaUser", newJString(quotaUser))
  add(query_580007, "alt", newJString(alt))
  add(query_580007, "oauth_token", newJString(oauthToken))
  add(query_580007, "userIp", newJString(userIp))
  add(query_580007, "key", newJString(key))
  if body != nil:
    body_580008 = body
  add(query_580007, "prettyPrint", newJBool(prettyPrint))
  result = call_580006.call(nil, query_580007, nil, nil, body_580008)

var fusiontablesTableInsert* = Call_FusiontablesTableInsert_579994(
    name: "fusiontablesTableInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables",
    validator: validate_FusiontablesTableInsert_579995, base: "/fusiontables/v2",
    url: url_FusiontablesTableInsert_579996, schemes: {Scheme.Https})
type
  Call_FusiontablesTableList_579979 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableList_579981(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableList_579980(path: JsonNode; query: JsonNode;
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
  var valid_579982 = query.getOrDefault("fields")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "fields", valid_579982
  var valid_579983 = query.getOrDefault("pageToken")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = nil)
  if valid_579983 != nil:
    section.add "pageToken", valid_579983
  var valid_579984 = query.getOrDefault("quotaUser")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "quotaUser", valid_579984
  var valid_579985 = query.getOrDefault("alt")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = newJString("json"))
  if valid_579985 != nil:
    section.add "alt", valid_579985
  var valid_579986 = query.getOrDefault("oauth_token")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "oauth_token", valid_579986
  var valid_579987 = query.getOrDefault("userIp")
  valid_579987 = validateParameter(valid_579987, JString, required = false,
                                 default = nil)
  if valid_579987 != nil:
    section.add "userIp", valid_579987
  var valid_579988 = query.getOrDefault("maxResults")
  valid_579988 = validateParameter(valid_579988, JInt, required = false, default = nil)
  if valid_579988 != nil:
    section.add "maxResults", valid_579988
  var valid_579989 = query.getOrDefault("key")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "key", valid_579989
  var valid_579990 = query.getOrDefault("prettyPrint")
  valid_579990 = validateParameter(valid_579990, JBool, required = false,
                                 default = newJBool(true))
  if valid_579990 != nil:
    section.add "prettyPrint", valid_579990
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579991: Call_FusiontablesTableList_579979; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of tables a user owns.
  ## 
  let valid = call_579991.validator(path, query, header, formData, body)
  let scheme = call_579991.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579991.url(scheme.get, call_579991.host, call_579991.base,
                         call_579991.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579991, url, valid)

proc call*(call_579992: Call_FusiontablesTableList_579979; fields: string = "";
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
  var query_579993 = newJObject()
  add(query_579993, "fields", newJString(fields))
  add(query_579993, "pageToken", newJString(pageToken))
  add(query_579993, "quotaUser", newJString(quotaUser))
  add(query_579993, "alt", newJString(alt))
  add(query_579993, "oauth_token", newJString(oauthToken))
  add(query_579993, "userIp", newJString(userIp))
  add(query_579993, "maxResults", newJInt(maxResults))
  add(query_579993, "key", newJString(key))
  add(query_579993, "prettyPrint", newJBool(prettyPrint))
  result = call_579992.call(nil, query_579993, nil, nil, nil)

var fusiontablesTableList* = Call_FusiontablesTableList_579979(
    name: "fusiontablesTableList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables",
    validator: validate_FusiontablesTableList_579980, base: "/fusiontables/v2",
    url: url_FusiontablesTableList_579981, schemes: {Scheme.Https})
type
  Call_FusiontablesTableImportTable_580009 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableImportTable_580011(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableImportTable_580010(path: JsonNode; query: JsonNode;
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
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("key")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "key", valid_580017
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_580018 = query.getOrDefault("name")
  valid_580018 = validateParameter(valid_580018, JString, required = true,
                                 default = nil)
  if valid_580018 != nil:
    section.add "name", valid_580018
  var valid_580019 = query.getOrDefault("delimiter")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "delimiter", valid_580019
  var valid_580020 = query.getOrDefault("encoding")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "encoding", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580022: Call_FusiontablesTableImportTable_580009; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports a new table.
  ## 
  let valid = call_580022.validator(path, query, header, formData, body)
  let scheme = call_580022.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580022.url(scheme.get, call_580022.host, call_580022.base,
                         call_580022.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580022, url, valid)

proc call*(call_580023: Call_FusiontablesTableImportTable_580009; name: string;
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
  var query_580024 = newJObject()
  add(query_580024, "fields", newJString(fields))
  add(query_580024, "quotaUser", newJString(quotaUser))
  add(query_580024, "alt", newJString(alt))
  add(query_580024, "oauth_token", newJString(oauthToken))
  add(query_580024, "userIp", newJString(userIp))
  add(query_580024, "key", newJString(key))
  add(query_580024, "name", newJString(name))
  add(query_580024, "delimiter", newJString(delimiter))
  add(query_580024, "encoding", newJString(encoding))
  add(query_580024, "prettyPrint", newJBool(prettyPrint))
  result = call_580023.call(nil, query_580024, nil, nil, nil)

var fusiontablesTableImportTable* = Call_FusiontablesTableImportTable_580009(
    name: "fusiontablesTableImportTable", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/import",
    validator: validate_FusiontablesTableImportTable_580010,
    base: "/fusiontables/v2", url: url_FusiontablesTableImportTable_580011,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableUpdate_580054 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableUpdate_580056(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTableUpdate_580055(path: JsonNode; query: JsonNode;
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
  var valid_580057 = path.getOrDefault("tableId")
  valid_580057 = validateParameter(valid_580057, JString, required = true,
                                 default = nil)
  if valid_580057 != nil:
    section.add "tableId", valid_580057
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
  var valid_580058 = query.getOrDefault("replaceViewDefinition")
  valid_580058 = validateParameter(valid_580058, JBool, required = false, default = nil)
  if valid_580058 != nil:
    section.add "replaceViewDefinition", valid_580058
  var valid_580059 = query.getOrDefault("fields")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "fields", valid_580059
  var valid_580060 = query.getOrDefault("quotaUser")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "quotaUser", valid_580060
  var valid_580061 = query.getOrDefault("alt")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = newJString("json"))
  if valid_580061 != nil:
    section.add "alt", valid_580061
  var valid_580062 = query.getOrDefault("oauth_token")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "oauth_token", valid_580062
  var valid_580063 = query.getOrDefault("userIp")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "userIp", valid_580063
  var valid_580064 = query.getOrDefault("key")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = nil)
  if valid_580064 != nil:
    section.add "key", valid_580064
  var valid_580065 = query.getOrDefault("prettyPrint")
  valid_580065 = validateParameter(valid_580065, JBool, required = false,
                                 default = newJBool(true))
  if valid_580065 != nil:
    section.add "prettyPrint", valid_580065
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

proc call*(call_580067: Call_FusiontablesTableUpdate_580054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated.
  ## 
  let valid = call_580067.validator(path, query, header, formData, body)
  let scheme = call_580067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580067.url(scheme.get, call_580067.host, call_580067.base,
                         call_580067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580067, url, valid)

proc call*(call_580068: Call_FusiontablesTableUpdate_580054; tableId: string;
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
  var path_580069 = newJObject()
  var query_580070 = newJObject()
  var body_580071 = newJObject()
  add(query_580070, "replaceViewDefinition", newJBool(replaceViewDefinition))
  add(path_580069, "tableId", newJString(tableId))
  add(query_580070, "fields", newJString(fields))
  add(query_580070, "quotaUser", newJString(quotaUser))
  add(query_580070, "alt", newJString(alt))
  add(query_580070, "oauth_token", newJString(oauthToken))
  add(query_580070, "userIp", newJString(userIp))
  add(query_580070, "key", newJString(key))
  if body != nil:
    body_580071 = body
  add(query_580070, "prettyPrint", newJBool(prettyPrint))
  result = call_580068.call(path_580069, query_580070, nil, nil, body_580071)

var fusiontablesTableUpdate* = Call_FusiontablesTableUpdate_580054(
    name: "fusiontablesTableUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableUpdate_580055, base: "/fusiontables/v2",
    url: url_FusiontablesTableUpdate_580056, schemes: {Scheme.Https})
type
  Call_FusiontablesTableGet_580025 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableGet_580027(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTableGet_580026(path: JsonNode; query: JsonNode;
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
  var valid_580042 = path.getOrDefault("tableId")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "tableId", valid_580042
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
  var valid_580043 = query.getOrDefault("fields")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "fields", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("alt")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = newJString("json"))
  if valid_580045 != nil:
    section.add "alt", valid_580045
  var valid_580046 = query.getOrDefault("oauth_token")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "oauth_token", valid_580046
  var valid_580047 = query.getOrDefault("userIp")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "userIp", valid_580047
  var valid_580048 = query.getOrDefault("key")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "key", valid_580048
  var valid_580049 = query.getOrDefault("prettyPrint")
  valid_580049 = validateParameter(valid_580049, JBool, required = false,
                                 default = newJBool(true))
  if valid_580049 != nil:
    section.add "prettyPrint", valid_580049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580050: Call_FusiontablesTableGet_580025; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific table by its ID.
  ## 
  let valid = call_580050.validator(path, query, header, formData, body)
  let scheme = call_580050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580050.url(scheme.get, call_580050.host, call_580050.base,
                         call_580050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580050, url, valid)

proc call*(call_580051: Call_FusiontablesTableGet_580025; tableId: string;
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
  var path_580052 = newJObject()
  var query_580053 = newJObject()
  add(path_580052, "tableId", newJString(tableId))
  add(query_580053, "fields", newJString(fields))
  add(query_580053, "quotaUser", newJString(quotaUser))
  add(query_580053, "alt", newJString(alt))
  add(query_580053, "oauth_token", newJString(oauthToken))
  add(query_580053, "userIp", newJString(userIp))
  add(query_580053, "key", newJString(key))
  add(query_580053, "prettyPrint", newJBool(prettyPrint))
  result = call_580051.call(path_580052, query_580053, nil, nil, nil)

var fusiontablesTableGet* = Call_FusiontablesTableGet_580025(
    name: "fusiontablesTableGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableGet_580026, base: "/fusiontables/v2",
    url: url_FusiontablesTableGet_580027, schemes: {Scheme.Https})
type
  Call_FusiontablesTablePatch_580087 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTablePatch_580089(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTablePatch_580088(path: JsonNode; query: JsonNode;
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
  var valid_580090 = path.getOrDefault("tableId")
  valid_580090 = validateParameter(valid_580090, JString, required = true,
                                 default = nil)
  if valid_580090 != nil:
    section.add "tableId", valid_580090
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
  var valid_580091 = query.getOrDefault("replaceViewDefinition")
  valid_580091 = validateParameter(valid_580091, JBool, required = false, default = nil)
  if valid_580091 != nil:
    section.add "replaceViewDefinition", valid_580091
  var valid_580092 = query.getOrDefault("fields")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "fields", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("alt")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = newJString("json"))
  if valid_580094 != nil:
    section.add "alt", valid_580094
  var valid_580095 = query.getOrDefault("oauth_token")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "oauth_token", valid_580095
  var valid_580096 = query.getOrDefault("userIp")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "userIp", valid_580096
  var valid_580097 = query.getOrDefault("key")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = nil)
  if valid_580097 != nil:
    section.add "key", valid_580097
  var valid_580098 = query.getOrDefault("prettyPrint")
  valid_580098 = validateParameter(valid_580098, JBool, required = false,
                                 default = newJBool(true))
  if valid_580098 != nil:
    section.add "prettyPrint", valid_580098
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

proc call*(call_580100: Call_FusiontablesTablePatch_580087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated. This method supports patch semantics.
  ## 
  let valid = call_580100.validator(path, query, header, formData, body)
  let scheme = call_580100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580100.url(scheme.get, call_580100.host, call_580100.base,
                         call_580100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580100, url, valid)

proc call*(call_580101: Call_FusiontablesTablePatch_580087; tableId: string;
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
  var path_580102 = newJObject()
  var query_580103 = newJObject()
  var body_580104 = newJObject()
  add(query_580103, "replaceViewDefinition", newJBool(replaceViewDefinition))
  add(path_580102, "tableId", newJString(tableId))
  add(query_580103, "fields", newJString(fields))
  add(query_580103, "quotaUser", newJString(quotaUser))
  add(query_580103, "alt", newJString(alt))
  add(query_580103, "oauth_token", newJString(oauthToken))
  add(query_580103, "userIp", newJString(userIp))
  add(query_580103, "key", newJString(key))
  if body != nil:
    body_580104 = body
  add(query_580103, "prettyPrint", newJBool(prettyPrint))
  result = call_580101.call(path_580102, query_580103, nil, nil, body_580104)

var fusiontablesTablePatch* = Call_FusiontablesTablePatch_580087(
    name: "fusiontablesTablePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTablePatch_580088, base: "/fusiontables/v2",
    url: url_FusiontablesTablePatch_580089, schemes: {Scheme.Https})
type
  Call_FusiontablesTableDelete_580072 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableDelete_580074(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTableDelete_580073(path: JsonNode; query: JsonNode;
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
  var valid_580075 = path.getOrDefault("tableId")
  valid_580075 = validateParameter(valid_580075, JString, required = true,
                                 default = nil)
  if valid_580075 != nil:
    section.add "tableId", valid_580075
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
  var valid_580076 = query.getOrDefault("fields")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "fields", valid_580076
  var valid_580077 = query.getOrDefault("quotaUser")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "quotaUser", valid_580077
  var valid_580078 = query.getOrDefault("alt")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = newJString("json"))
  if valid_580078 != nil:
    section.add "alt", valid_580078
  var valid_580079 = query.getOrDefault("oauth_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "oauth_token", valid_580079
  var valid_580080 = query.getOrDefault("userIp")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "userIp", valid_580080
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  var valid_580082 = query.getOrDefault("prettyPrint")
  valid_580082 = validateParameter(valid_580082, JBool, required = false,
                                 default = newJBool(true))
  if valid_580082 != nil:
    section.add "prettyPrint", valid_580082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580083: Call_FusiontablesTableDelete_580072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a table.
  ## 
  let valid = call_580083.validator(path, query, header, formData, body)
  let scheme = call_580083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580083.url(scheme.get, call_580083.host, call_580083.base,
                         call_580083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580083, url, valid)

proc call*(call_580084: Call_FusiontablesTableDelete_580072; tableId: string;
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
  var path_580085 = newJObject()
  var query_580086 = newJObject()
  add(path_580085, "tableId", newJString(tableId))
  add(query_580086, "fields", newJString(fields))
  add(query_580086, "quotaUser", newJString(quotaUser))
  add(query_580086, "alt", newJString(alt))
  add(query_580086, "oauth_token", newJString(oauthToken))
  add(query_580086, "userIp", newJString(userIp))
  add(query_580086, "key", newJString(key))
  add(query_580086, "prettyPrint", newJBool(prettyPrint))
  result = call_580084.call(path_580085, query_580086, nil, nil, nil)

var fusiontablesTableDelete* = Call_FusiontablesTableDelete_580072(
    name: "fusiontablesTableDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableDelete_580073, base: "/fusiontables/v2",
    url: url_FusiontablesTableDelete_580074, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnInsert_580122 = ref object of OpenApiRestCall_579424
proc url_FusiontablesColumnInsert_580124(protocol: Scheme; host: string;
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

proc validate_FusiontablesColumnInsert_580123(path: JsonNode; query: JsonNode;
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
  var valid_580125 = path.getOrDefault("tableId")
  valid_580125 = validateParameter(valid_580125, JString, required = true,
                                 default = nil)
  if valid_580125 != nil:
    section.add "tableId", valid_580125
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
  var valid_580126 = query.getOrDefault("fields")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "fields", valid_580126
  var valid_580127 = query.getOrDefault("quotaUser")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "quotaUser", valid_580127
  var valid_580128 = query.getOrDefault("alt")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = newJString("json"))
  if valid_580128 != nil:
    section.add "alt", valid_580128
  var valid_580129 = query.getOrDefault("oauth_token")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "oauth_token", valid_580129
  var valid_580130 = query.getOrDefault("userIp")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "userIp", valid_580130
  var valid_580131 = query.getOrDefault("key")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = nil)
  if valid_580131 != nil:
    section.add "key", valid_580131
  var valid_580132 = query.getOrDefault("prettyPrint")
  valid_580132 = validateParameter(valid_580132, JBool, required = false,
                                 default = newJBool(true))
  if valid_580132 != nil:
    section.add "prettyPrint", valid_580132
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

proc call*(call_580134: Call_FusiontablesColumnInsert_580122; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new column to the table.
  ## 
  let valid = call_580134.validator(path, query, header, formData, body)
  let scheme = call_580134.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580134.url(scheme.get, call_580134.host, call_580134.base,
                         call_580134.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580134, url, valid)

proc call*(call_580135: Call_FusiontablesColumnInsert_580122; tableId: string;
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
  var path_580136 = newJObject()
  var query_580137 = newJObject()
  var body_580138 = newJObject()
  add(path_580136, "tableId", newJString(tableId))
  add(query_580137, "fields", newJString(fields))
  add(query_580137, "quotaUser", newJString(quotaUser))
  add(query_580137, "alt", newJString(alt))
  add(query_580137, "oauth_token", newJString(oauthToken))
  add(query_580137, "userIp", newJString(userIp))
  add(query_580137, "key", newJString(key))
  if body != nil:
    body_580138 = body
  add(query_580137, "prettyPrint", newJBool(prettyPrint))
  result = call_580135.call(path_580136, query_580137, nil, nil, body_580138)

var fusiontablesColumnInsert* = Call_FusiontablesColumnInsert_580122(
    name: "fusiontablesColumnInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns",
    validator: validate_FusiontablesColumnInsert_580123, base: "/fusiontables/v2",
    url: url_FusiontablesColumnInsert_580124, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnList_580105 = ref object of OpenApiRestCall_579424
proc url_FusiontablesColumnList_580107(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesColumnList_580106(path: JsonNode; query: JsonNode;
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
  var valid_580108 = path.getOrDefault("tableId")
  valid_580108 = validateParameter(valid_580108, JString, required = true,
                                 default = nil)
  if valid_580108 != nil:
    section.add "tableId", valid_580108
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
  var valid_580109 = query.getOrDefault("fields")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "fields", valid_580109
  var valid_580110 = query.getOrDefault("pageToken")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "pageToken", valid_580110
  var valid_580111 = query.getOrDefault("quotaUser")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "quotaUser", valid_580111
  var valid_580112 = query.getOrDefault("alt")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = newJString("json"))
  if valid_580112 != nil:
    section.add "alt", valid_580112
  var valid_580113 = query.getOrDefault("oauth_token")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "oauth_token", valid_580113
  var valid_580114 = query.getOrDefault("userIp")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "userIp", valid_580114
  var valid_580115 = query.getOrDefault("maxResults")
  valid_580115 = validateParameter(valid_580115, JInt, required = false, default = nil)
  if valid_580115 != nil:
    section.add "maxResults", valid_580115
  var valid_580116 = query.getOrDefault("key")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "key", valid_580116
  var valid_580117 = query.getOrDefault("prettyPrint")
  valid_580117 = validateParameter(valid_580117, JBool, required = false,
                                 default = newJBool(true))
  if valid_580117 != nil:
    section.add "prettyPrint", valid_580117
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580118: Call_FusiontablesColumnList_580105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of columns.
  ## 
  let valid = call_580118.validator(path, query, header, formData, body)
  let scheme = call_580118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580118.url(scheme.get, call_580118.host, call_580118.base,
                         call_580118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580118, url, valid)

proc call*(call_580119: Call_FusiontablesColumnList_580105; tableId: string;
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
  var path_580120 = newJObject()
  var query_580121 = newJObject()
  add(path_580120, "tableId", newJString(tableId))
  add(query_580121, "fields", newJString(fields))
  add(query_580121, "pageToken", newJString(pageToken))
  add(query_580121, "quotaUser", newJString(quotaUser))
  add(query_580121, "alt", newJString(alt))
  add(query_580121, "oauth_token", newJString(oauthToken))
  add(query_580121, "userIp", newJString(userIp))
  add(query_580121, "maxResults", newJInt(maxResults))
  add(query_580121, "key", newJString(key))
  add(query_580121, "prettyPrint", newJBool(prettyPrint))
  result = call_580119.call(path_580120, query_580121, nil, nil, nil)

var fusiontablesColumnList* = Call_FusiontablesColumnList_580105(
    name: "fusiontablesColumnList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns",
    validator: validate_FusiontablesColumnList_580106, base: "/fusiontables/v2",
    url: url_FusiontablesColumnList_580107, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnUpdate_580155 = ref object of OpenApiRestCall_579424
proc url_FusiontablesColumnUpdate_580157(protocol: Scheme; host: string;
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

proc validate_FusiontablesColumnUpdate_580156(path: JsonNode; query: JsonNode;
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
  var valid_580158 = path.getOrDefault("tableId")
  valid_580158 = validateParameter(valid_580158, JString, required = true,
                                 default = nil)
  if valid_580158 != nil:
    section.add "tableId", valid_580158
  var valid_580159 = path.getOrDefault("columnId")
  valid_580159 = validateParameter(valid_580159, JString, required = true,
                                 default = nil)
  if valid_580159 != nil:
    section.add "columnId", valid_580159
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
  var valid_580160 = query.getOrDefault("fields")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "fields", valid_580160
  var valid_580161 = query.getOrDefault("quotaUser")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "quotaUser", valid_580161
  var valid_580162 = query.getOrDefault("alt")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = newJString("json"))
  if valid_580162 != nil:
    section.add "alt", valid_580162
  var valid_580163 = query.getOrDefault("oauth_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "oauth_token", valid_580163
  var valid_580164 = query.getOrDefault("userIp")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "userIp", valid_580164
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("prettyPrint")
  valid_580166 = validateParameter(valid_580166, JBool, required = false,
                                 default = newJBool(true))
  if valid_580166 != nil:
    section.add "prettyPrint", valid_580166
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

proc call*(call_580168: Call_FusiontablesColumnUpdate_580155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or type of an existing column.
  ## 
  let valid = call_580168.validator(path, query, header, formData, body)
  let scheme = call_580168.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580168.url(scheme.get, call_580168.host, call_580168.base,
                         call_580168.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580168, url, valid)

proc call*(call_580169: Call_FusiontablesColumnUpdate_580155; tableId: string;
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
  var path_580170 = newJObject()
  var query_580171 = newJObject()
  var body_580172 = newJObject()
  add(path_580170, "tableId", newJString(tableId))
  add(query_580171, "fields", newJString(fields))
  add(query_580171, "quotaUser", newJString(quotaUser))
  add(query_580171, "alt", newJString(alt))
  add(query_580171, "oauth_token", newJString(oauthToken))
  add(query_580171, "userIp", newJString(userIp))
  add(query_580171, "key", newJString(key))
  add(path_580170, "columnId", newJString(columnId))
  if body != nil:
    body_580172 = body
  add(query_580171, "prettyPrint", newJBool(prettyPrint))
  result = call_580169.call(path_580170, query_580171, nil, nil, body_580172)

var fusiontablesColumnUpdate* = Call_FusiontablesColumnUpdate_580155(
    name: "fusiontablesColumnUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnUpdate_580156, base: "/fusiontables/v2",
    url: url_FusiontablesColumnUpdate_580157, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnGet_580139 = ref object of OpenApiRestCall_579424
proc url_FusiontablesColumnGet_580141(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesColumnGet_580140(path: JsonNode; query: JsonNode;
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
  var valid_580142 = path.getOrDefault("tableId")
  valid_580142 = validateParameter(valid_580142, JString, required = true,
                                 default = nil)
  if valid_580142 != nil:
    section.add "tableId", valid_580142
  var valid_580143 = path.getOrDefault("columnId")
  valid_580143 = validateParameter(valid_580143, JString, required = true,
                                 default = nil)
  if valid_580143 != nil:
    section.add "columnId", valid_580143
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
  var valid_580144 = query.getOrDefault("fields")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "fields", valid_580144
  var valid_580145 = query.getOrDefault("quotaUser")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "quotaUser", valid_580145
  var valid_580146 = query.getOrDefault("alt")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("json"))
  if valid_580146 != nil:
    section.add "alt", valid_580146
  var valid_580147 = query.getOrDefault("oauth_token")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "oauth_token", valid_580147
  var valid_580148 = query.getOrDefault("userIp")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "userIp", valid_580148
  var valid_580149 = query.getOrDefault("key")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "key", valid_580149
  var valid_580150 = query.getOrDefault("prettyPrint")
  valid_580150 = validateParameter(valid_580150, JBool, required = false,
                                 default = newJBool(true))
  if valid_580150 != nil:
    section.add "prettyPrint", valid_580150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580151: Call_FusiontablesColumnGet_580139; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific column by its ID.
  ## 
  let valid = call_580151.validator(path, query, header, formData, body)
  let scheme = call_580151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580151.url(scheme.get, call_580151.host, call_580151.base,
                         call_580151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580151, url, valid)

proc call*(call_580152: Call_FusiontablesColumnGet_580139; tableId: string;
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
  var path_580153 = newJObject()
  var query_580154 = newJObject()
  add(path_580153, "tableId", newJString(tableId))
  add(query_580154, "fields", newJString(fields))
  add(query_580154, "quotaUser", newJString(quotaUser))
  add(query_580154, "alt", newJString(alt))
  add(query_580154, "oauth_token", newJString(oauthToken))
  add(query_580154, "userIp", newJString(userIp))
  add(query_580154, "key", newJString(key))
  add(path_580153, "columnId", newJString(columnId))
  add(query_580154, "prettyPrint", newJBool(prettyPrint))
  result = call_580152.call(path_580153, query_580154, nil, nil, nil)

var fusiontablesColumnGet* = Call_FusiontablesColumnGet_580139(
    name: "fusiontablesColumnGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnGet_580140, base: "/fusiontables/v2",
    url: url_FusiontablesColumnGet_580141, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnPatch_580189 = ref object of OpenApiRestCall_579424
proc url_FusiontablesColumnPatch_580191(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesColumnPatch_580190(path: JsonNode; query: JsonNode;
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
  var valid_580192 = path.getOrDefault("tableId")
  valid_580192 = validateParameter(valid_580192, JString, required = true,
                                 default = nil)
  if valid_580192 != nil:
    section.add "tableId", valid_580192
  var valid_580193 = path.getOrDefault("columnId")
  valid_580193 = validateParameter(valid_580193, JString, required = true,
                                 default = nil)
  if valid_580193 != nil:
    section.add "columnId", valid_580193
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
  var valid_580194 = query.getOrDefault("fields")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "fields", valid_580194
  var valid_580195 = query.getOrDefault("quotaUser")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "quotaUser", valid_580195
  var valid_580196 = query.getOrDefault("alt")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = newJString("json"))
  if valid_580196 != nil:
    section.add "alt", valid_580196
  var valid_580197 = query.getOrDefault("oauth_token")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "oauth_token", valid_580197
  var valid_580198 = query.getOrDefault("userIp")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = nil)
  if valid_580198 != nil:
    section.add "userIp", valid_580198
  var valid_580199 = query.getOrDefault("key")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "key", valid_580199
  var valid_580200 = query.getOrDefault("prettyPrint")
  valid_580200 = validateParameter(valid_580200, JBool, required = false,
                                 default = newJBool(true))
  if valid_580200 != nil:
    section.add "prettyPrint", valid_580200
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

proc call*(call_580202: Call_FusiontablesColumnPatch_580189; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or type of an existing column. This method supports patch semantics.
  ## 
  let valid = call_580202.validator(path, query, header, formData, body)
  let scheme = call_580202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580202.url(scheme.get, call_580202.host, call_580202.base,
                         call_580202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580202, url, valid)

proc call*(call_580203: Call_FusiontablesColumnPatch_580189; tableId: string;
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
  var path_580204 = newJObject()
  var query_580205 = newJObject()
  var body_580206 = newJObject()
  add(path_580204, "tableId", newJString(tableId))
  add(query_580205, "fields", newJString(fields))
  add(query_580205, "quotaUser", newJString(quotaUser))
  add(query_580205, "alt", newJString(alt))
  add(query_580205, "oauth_token", newJString(oauthToken))
  add(query_580205, "userIp", newJString(userIp))
  add(query_580205, "key", newJString(key))
  add(path_580204, "columnId", newJString(columnId))
  if body != nil:
    body_580206 = body
  add(query_580205, "prettyPrint", newJBool(prettyPrint))
  result = call_580203.call(path_580204, query_580205, nil, nil, body_580206)

var fusiontablesColumnPatch* = Call_FusiontablesColumnPatch_580189(
    name: "fusiontablesColumnPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnPatch_580190, base: "/fusiontables/v2",
    url: url_FusiontablesColumnPatch_580191, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnDelete_580173 = ref object of OpenApiRestCall_579424
proc url_FusiontablesColumnDelete_580175(protocol: Scheme; host: string;
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

proc validate_FusiontablesColumnDelete_580174(path: JsonNode; query: JsonNode;
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
  var valid_580176 = path.getOrDefault("tableId")
  valid_580176 = validateParameter(valid_580176, JString, required = true,
                                 default = nil)
  if valid_580176 != nil:
    section.add "tableId", valid_580176
  var valid_580177 = path.getOrDefault("columnId")
  valid_580177 = validateParameter(valid_580177, JString, required = true,
                                 default = nil)
  if valid_580177 != nil:
    section.add "columnId", valid_580177
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
  var valid_580178 = query.getOrDefault("fields")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "fields", valid_580178
  var valid_580179 = query.getOrDefault("quotaUser")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "quotaUser", valid_580179
  var valid_580180 = query.getOrDefault("alt")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = newJString("json"))
  if valid_580180 != nil:
    section.add "alt", valid_580180
  var valid_580181 = query.getOrDefault("oauth_token")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = nil)
  if valid_580181 != nil:
    section.add "oauth_token", valid_580181
  var valid_580182 = query.getOrDefault("userIp")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "userIp", valid_580182
  var valid_580183 = query.getOrDefault("key")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = nil)
  if valid_580183 != nil:
    section.add "key", valid_580183
  var valid_580184 = query.getOrDefault("prettyPrint")
  valid_580184 = validateParameter(valid_580184, JBool, required = false,
                                 default = newJBool(true))
  if valid_580184 != nil:
    section.add "prettyPrint", valid_580184
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580185: Call_FusiontablesColumnDelete_580173; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the specified column.
  ## 
  let valid = call_580185.validator(path, query, header, formData, body)
  let scheme = call_580185.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580185.url(scheme.get, call_580185.host, call_580185.base,
                         call_580185.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580185, url, valid)

proc call*(call_580186: Call_FusiontablesColumnDelete_580173; tableId: string;
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
  var path_580187 = newJObject()
  var query_580188 = newJObject()
  add(path_580187, "tableId", newJString(tableId))
  add(query_580188, "fields", newJString(fields))
  add(query_580188, "quotaUser", newJString(quotaUser))
  add(query_580188, "alt", newJString(alt))
  add(query_580188, "oauth_token", newJString(oauthToken))
  add(query_580188, "userIp", newJString(userIp))
  add(query_580188, "key", newJString(key))
  add(path_580187, "columnId", newJString(columnId))
  add(query_580188, "prettyPrint", newJBool(prettyPrint))
  result = call_580186.call(path_580187, query_580188, nil, nil, nil)

var fusiontablesColumnDelete* = Call_FusiontablesColumnDelete_580173(
    name: "fusiontablesColumnDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnDelete_580174, base: "/fusiontables/v2",
    url: url_FusiontablesColumnDelete_580175, schemes: {Scheme.Https})
type
  Call_FusiontablesTableCopy_580207 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableCopy_580209(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTableCopy_580208(path: JsonNode; query: JsonNode;
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
  var valid_580210 = path.getOrDefault("tableId")
  valid_580210 = validateParameter(valid_580210, JString, required = true,
                                 default = nil)
  if valid_580210 != nil:
    section.add "tableId", valid_580210
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
  var valid_580211 = query.getOrDefault("fields")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = nil)
  if valid_580211 != nil:
    section.add "fields", valid_580211
  var valid_580212 = query.getOrDefault("quotaUser")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "quotaUser", valid_580212
  var valid_580213 = query.getOrDefault("alt")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = newJString("json"))
  if valid_580213 != nil:
    section.add "alt", valid_580213
  var valid_580214 = query.getOrDefault("oauth_token")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "oauth_token", valid_580214
  var valid_580215 = query.getOrDefault("userIp")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "userIp", valid_580215
  var valid_580216 = query.getOrDefault("key")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = nil)
  if valid_580216 != nil:
    section.add "key", valid_580216
  var valid_580217 = query.getOrDefault("copyPresentation")
  valid_580217 = validateParameter(valid_580217, JBool, required = false, default = nil)
  if valid_580217 != nil:
    section.add "copyPresentation", valid_580217
  var valid_580218 = query.getOrDefault("prettyPrint")
  valid_580218 = validateParameter(valid_580218, JBool, required = false,
                                 default = newJBool(true))
  if valid_580218 != nil:
    section.add "prettyPrint", valid_580218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580219: Call_FusiontablesTableCopy_580207; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a table.
  ## 
  let valid = call_580219.validator(path, query, header, formData, body)
  let scheme = call_580219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580219.url(scheme.get, call_580219.host, call_580219.base,
                         call_580219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580219, url, valid)

proc call*(call_580220: Call_FusiontablesTableCopy_580207; tableId: string;
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
  var path_580221 = newJObject()
  var query_580222 = newJObject()
  add(path_580221, "tableId", newJString(tableId))
  add(query_580222, "fields", newJString(fields))
  add(query_580222, "quotaUser", newJString(quotaUser))
  add(query_580222, "alt", newJString(alt))
  add(query_580222, "oauth_token", newJString(oauthToken))
  add(query_580222, "userIp", newJString(userIp))
  add(query_580222, "key", newJString(key))
  add(query_580222, "copyPresentation", newJBool(copyPresentation))
  add(query_580222, "prettyPrint", newJBool(prettyPrint))
  result = call_580220.call(path_580221, query_580222, nil, nil, nil)

var fusiontablesTableCopy* = Call_FusiontablesTableCopy_580207(
    name: "fusiontablesTableCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/copy",
    validator: validate_FusiontablesTableCopy_580208, base: "/fusiontables/v2",
    url: url_FusiontablesTableCopy_580209, schemes: {Scheme.Https})
type
  Call_FusiontablesTableImportRows_580223 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableImportRows_580225(protocol: Scheme; host: string;
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

proc validate_FusiontablesTableImportRows_580224(path: JsonNode; query: JsonNode;
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
  var valid_580226 = path.getOrDefault("tableId")
  valid_580226 = validateParameter(valid_580226, JString, required = true,
                                 default = nil)
  if valid_580226 != nil:
    section.add "tableId", valid_580226
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
  var valid_580227 = query.getOrDefault("endLine")
  valid_580227 = validateParameter(valid_580227, JInt, required = false, default = nil)
  if valid_580227 != nil:
    section.add "endLine", valid_580227
  var valid_580228 = query.getOrDefault("fields")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "fields", valid_580228
  var valid_580229 = query.getOrDefault("quotaUser")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "quotaUser", valid_580229
  var valid_580230 = query.getOrDefault("alt")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = newJString("json"))
  if valid_580230 != nil:
    section.add "alt", valid_580230
  var valid_580231 = query.getOrDefault("isStrict")
  valid_580231 = validateParameter(valid_580231, JBool, required = false, default = nil)
  if valid_580231 != nil:
    section.add "isStrict", valid_580231
  var valid_580232 = query.getOrDefault("oauth_token")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = nil)
  if valid_580232 != nil:
    section.add "oauth_token", valid_580232
  var valid_580233 = query.getOrDefault("userIp")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "userIp", valid_580233
  var valid_580234 = query.getOrDefault("key")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "key", valid_580234
  var valid_580235 = query.getOrDefault("delimiter")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "delimiter", valid_580235
  var valid_580236 = query.getOrDefault("encoding")
  valid_580236 = validateParameter(valid_580236, JString, required = false,
                                 default = nil)
  if valid_580236 != nil:
    section.add "encoding", valid_580236
  var valid_580237 = query.getOrDefault("prettyPrint")
  valid_580237 = validateParameter(valid_580237, JBool, required = false,
                                 default = newJBool(true))
  if valid_580237 != nil:
    section.add "prettyPrint", valid_580237
  var valid_580238 = query.getOrDefault("startLine")
  valid_580238 = validateParameter(valid_580238, JInt, required = false, default = nil)
  if valid_580238 != nil:
    section.add "startLine", valid_580238
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580239: Call_FusiontablesTableImportRows_580223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Imports more rows into a table.
  ## 
  let valid = call_580239.validator(path, query, header, formData, body)
  let scheme = call_580239.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580239.url(scheme.get, call_580239.host, call_580239.base,
                         call_580239.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580239, url, valid)

proc call*(call_580240: Call_FusiontablesTableImportRows_580223; tableId: string;
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
  var path_580241 = newJObject()
  var query_580242 = newJObject()
  add(query_580242, "endLine", newJInt(endLine))
  add(path_580241, "tableId", newJString(tableId))
  add(query_580242, "fields", newJString(fields))
  add(query_580242, "quotaUser", newJString(quotaUser))
  add(query_580242, "alt", newJString(alt))
  add(query_580242, "isStrict", newJBool(isStrict))
  add(query_580242, "oauth_token", newJString(oauthToken))
  add(query_580242, "userIp", newJString(userIp))
  add(query_580242, "key", newJString(key))
  add(query_580242, "delimiter", newJString(delimiter))
  add(query_580242, "encoding", newJString(encoding))
  add(query_580242, "prettyPrint", newJBool(prettyPrint))
  add(query_580242, "startLine", newJInt(startLine))
  result = call_580240.call(path_580241, query_580242, nil, nil, nil)

var fusiontablesTableImportRows* = Call_FusiontablesTableImportRows_580223(
    name: "fusiontablesTableImportRows", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/import",
    validator: validate_FusiontablesTableImportRows_580224,
    base: "/fusiontables/v2", url: url_FusiontablesTableImportRows_580225,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableRefetchSheet_580243 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableRefetchSheet_580245(protocol: Scheme; host: string;
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

proc validate_FusiontablesTableRefetchSheet_580244(path: JsonNode; query: JsonNode;
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
  var valid_580246 = path.getOrDefault("tableId")
  valid_580246 = validateParameter(valid_580246, JString, required = true,
                                 default = nil)
  if valid_580246 != nil:
    section.add "tableId", valid_580246
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
  var valid_580247 = query.getOrDefault("fields")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "fields", valid_580247
  var valid_580248 = query.getOrDefault("quotaUser")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "quotaUser", valid_580248
  var valid_580249 = query.getOrDefault("alt")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = newJString("json"))
  if valid_580249 != nil:
    section.add "alt", valid_580249
  var valid_580250 = query.getOrDefault("oauth_token")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "oauth_token", valid_580250
  var valid_580251 = query.getOrDefault("userIp")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "userIp", valid_580251
  var valid_580252 = query.getOrDefault("key")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "key", valid_580252
  var valid_580253 = query.getOrDefault("prettyPrint")
  valid_580253 = validateParameter(valid_580253, JBool, required = false,
                                 default = newJBool(true))
  if valid_580253 != nil:
    section.add "prettyPrint", valid_580253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580254: Call_FusiontablesTableRefetchSheet_580243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces rows of the table with the rows of the spreadsheet that is first imported from. Current rows remain visible until all replacement rows are ready.
  ## 
  let valid = call_580254.validator(path, query, header, formData, body)
  let scheme = call_580254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580254.url(scheme.get, call_580254.host, call_580254.base,
                         call_580254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580254, url, valid)

proc call*(call_580255: Call_FusiontablesTableRefetchSheet_580243; tableId: string;
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
  var path_580256 = newJObject()
  var query_580257 = newJObject()
  add(path_580256, "tableId", newJString(tableId))
  add(query_580257, "fields", newJString(fields))
  add(query_580257, "quotaUser", newJString(quotaUser))
  add(query_580257, "alt", newJString(alt))
  add(query_580257, "oauth_token", newJString(oauthToken))
  add(query_580257, "userIp", newJString(userIp))
  add(query_580257, "key", newJString(key))
  add(query_580257, "prettyPrint", newJBool(prettyPrint))
  result = call_580255.call(path_580256, query_580257, nil, nil, nil)

var fusiontablesTableRefetchSheet* = Call_FusiontablesTableRefetchSheet_580243(
    name: "fusiontablesTableRefetchSheet", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/refetch",
    validator: validate_FusiontablesTableRefetchSheet_580244,
    base: "/fusiontables/v2", url: url_FusiontablesTableRefetchSheet_580245,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableReplaceRows_580258 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTableReplaceRows_580260(protocol: Scheme; host: string;
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

proc validate_FusiontablesTableReplaceRows_580259(path: JsonNode; query: JsonNode;
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
  var valid_580261 = path.getOrDefault("tableId")
  valid_580261 = validateParameter(valid_580261, JString, required = true,
                                 default = nil)
  if valid_580261 != nil:
    section.add "tableId", valid_580261
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
  var valid_580262 = query.getOrDefault("endLine")
  valid_580262 = validateParameter(valid_580262, JInt, required = false, default = nil)
  if valid_580262 != nil:
    section.add "endLine", valid_580262
  var valid_580263 = query.getOrDefault("fields")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "fields", valid_580263
  var valid_580264 = query.getOrDefault("quotaUser")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "quotaUser", valid_580264
  var valid_580265 = query.getOrDefault("alt")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = newJString("json"))
  if valid_580265 != nil:
    section.add "alt", valid_580265
  var valid_580266 = query.getOrDefault("isStrict")
  valid_580266 = validateParameter(valid_580266, JBool, required = false, default = nil)
  if valid_580266 != nil:
    section.add "isStrict", valid_580266
  var valid_580267 = query.getOrDefault("oauth_token")
  valid_580267 = validateParameter(valid_580267, JString, required = false,
                                 default = nil)
  if valid_580267 != nil:
    section.add "oauth_token", valid_580267
  var valid_580268 = query.getOrDefault("userIp")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "userIp", valid_580268
  var valid_580269 = query.getOrDefault("key")
  valid_580269 = validateParameter(valid_580269, JString, required = false,
                                 default = nil)
  if valid_580269 != nil:
    section.add "key", valid_580269
  var valid_580270 = query.getOrDefault("delimiter")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "delimiter", valid_580270
  var valid_580271 = query.getOrDefault("encoding")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "encoding", valid_580271
  var valid_580272 = query.getOrDefault("prettyPrint")
  valid_580272 = validateParameter(valid_580272, JBool, required = false,
                                 default = newJBool(true))
  if valid_580272 != nil:
    section.add "prettyPrint", valid_580272
  var valid_580273 = query.getOrDefault("startLine")
  valid_580273 = validateParameter(valid_580273, JInt, required = false, default = nil)
  if valid_580273 != nil:
    section.add "startLine", valid_580273
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580274: Call_FusiontablesTableReplaceRows_580258; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Replaces rows of an existing table. Current rows remain visible until all replacement rows are ready.
  ## 
  let valid = call_580274.validator(path, query, header, formData, body)
  let scheme = call_580274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580274.url(scheme.get, call_580274.host, call_580274.base,
                         call_580274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580274, url, valid)

proc call*(call_580275: Call_FusiontablesTableReplaceRows_580258; tableId: string;
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
  var path_580276 = newJObject()
  var query_580277 = newJObject()
  add(query_580277, "endLine", newJInt(endLine))
  add(path_580276, "tableId", newJString(tableId))
  add(query_580277, "fields", newJString(fields))
  add(query_580277, "quotaUser", newJString(quotaUser))
  add(query_580277, "alt", newJString(alt))
  add(query_580277, "isStrict", newJBool(isStrict))
  add(query_580277, "oauth_token", newJString(oauthToken))
  add(query_580277, "userIp", newJString(userIp))
  add(query_580277, "key", newJString(key))
  add(query_580277, "delimiter", newJString(delimiter))
  add(query_580277, "encoding", newJString(encoding))
  add(query_580277, "prettyPrint", newJBool(prettyPrint))
  add(query_580277, "startLine", newJInt(startLine))
  result = call_580275.call(path_580276, query_580277, nil, nil, nil)

var fusiontablesTableReplaceRows* = Call_FusiontablesTableReplaceRows_580258(
    name: "fusiontablesTableReplaceRows", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/replace",
    validator: validate_FusiontablesTableReplaceRows_580259,
    base: "/fusiontables/v2", url: url_FusiontablesTableReplaceRows_580260,
    schemes: {Scheme.Https})
type
  Call_FusiontablesStyleInsert_580295 = ref object of OpenApiRestCall_579424
proc url_FusiontablesStyleInsert_580297(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleInsert_580296(path: JsonNode; query: JsonNode;
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
  var valid_580298 = path.getOrDefault("tableId")
  valid_580298 = validateParameter(valid_580298, JString, required = true,
                                 default = nil)
  if valid_580298 != nil:
    section.add "tableId", valid_580298
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
  var valid_580299 = query.getOrDefault("fields")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "fields", valid_580299
  var valid_580300 = query.getOrDefault("quotaUser")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "quotaUser", valid_580300
  var valid_580301 = query.getOrDefault("alt")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = newJString("json"))
  if valid_580301 != nil:
    section.add "alt", valid_580301
  var valid_580302 = query.getOrDefault("oauth_token")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "oauth_token", valid_580302
  var valid_580303 = query.getOrDefault("userIp")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "userIp", valid_580303
  var valid_580304 = query.getOrDefault("key")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "key", valid_580304
  var valid_580305 = query.getOrDefault("prettyPrint")
  valid_580305 = validateParameter(valid_580305, JBool, required = false,
                                 default = newJBool(true))
  if valid_580305 != nil:
    section.add "prettyPrint", valid_580305
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

proc call*(call_580307: Call_FusiontablesStyleInsert_580295; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new style for the table.
  ## 
  let valid = call_580307.validator(path, query, header, formData, body)
  let scheme = call_580307.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580307.url(scheme.get, call_580307.host, call_580307.base,
                         call_580307.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580307, url, valid)

proc call*(call_580308: Call_FusiontablesStyleInsert_580295; tableId: string;
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
  var path_580309 = newJObject()
  var query_580310 = newJObject()
  var body_580311 = newJObject()
  add(path_580309, "tableId", newJString(tableId))
  add(query_580310, "fields", newJString(fields))
  add(query_580310, "quotaUser", newJString(quotaUser))
  add(query_580310, "alt", newJString(alt))
  add(query_580310, "oauth_token", newJString(oauthToken))
  add(query_580310, "userIp", newJString(userIp))
  add(query_580310, "key", newJString(key))
  if body != nil:
    body_580311 = body
  add(query_580310, "prettyPrint", newJBool(prettyPrint))
  result = call_580308.call(path_580309, query_580310, nil, nil, body_580311)

var fusiontablesStyleInsert* = Call_FusiontablesStyleInsert_580295(
    name: "fusiontablesStyleInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles",
    validator: validate_FusiontablesStyleInsert_580296, base: "/fusiontables/v2",
    url: url_FusiontablesStyleInsert_580297, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleList_580278 = ref object of OpenApiRestCall_579424
proc url_FusiontablesStyleList_580280(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleList_580279(path: JsonNode; query: JsonNode;
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
  var valid_580281 = path.getOrDefault("tableId")
  valid_580281 = validateParameter(valid_580281, JString, required = true,
                                 default = nil)
  if valid_580281 != nil:
    section.add "tableId", valid_580281
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
  var valid_580282 = query.getOrDefault("fields")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "fields", valid_580282
  var valid_580283 = query.getOrDefault("pageToken")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = nil)
  if valid_580283 != nil:
    section.add "pageToken", valid_580283
  var valid_580284 = query.getOrDefault("quotaUser")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "quotaUser", valid_580284
  var valid_580285 = query.getOrDefault("alt")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("json"))
  if valid_580285 != nil:
    section.add "alt", valid_580285
  var valid_580286 = query.getOrDefault("oauth_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "oauth_token", valid_580286
  var valid_580287 = query.getOrDefault("userIp")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = nil)
  if valid_580287 != nil:
    section.add "userIp", valid_580287
  var valid_580288 = query.getOrDefault("maxResults")
  valid_580288 = validateParameter(valid_580288, JInt, required = false, default = nil)
  if valid_580288 != nil:
    section.add "maxResults", valid_580288
  var valid_580289 = query.getOrDefault("key")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "key", valid_580289
  var valid_580290 = query.getOrDefault("prettyPrint")
  valid_580290 = validateParameter(valid_580290, JBool, required = false,
                                 default = newJBool(true))
  if valid_580290 != nil:
    section.add "prettyPrint", valid_580290
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580291: Call_FusiontablesStyleList_580278; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of styles.
  ## 
  let valid = call_580291.validator(path, query, header, formData, body)
  let scheme = call_580291.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580291.url(scheme.get, call_580291.host, call_580291.base,
                         call_580291.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580291, url, valid)

proc call*(call_580292: Call_FusiontablesStyleList_580278; tableId: string;
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
  var path_580293 = newJObject()
  var query_580294 = newJObject()
  add(path_580293, "tableId", newJString(tableId))
  add(query_580294, "fields", newJString(fields))
  add(query_580294, "pageToken", newJString(pageToken))
  add(query_580294, "quotaUser", newJString(quotaUser))
  add(query_580294, "alt", newJString(alt))
  add(query_580294, "oauth_token", newJString(oauthToken))
  add(query_580294, "userIp", newJString(userIp))
  add(query_580294, "maxResults", newJInt(maxResults))
  add(query_580294, "key", newJString(key))
  add(query_580294, "prettyPrint", newJBool(prettyPrint))
  result = call_580292.call(path_580293, query_580294, nil, nil, nil)

var fusiontablesStyleList* = Call_FusiontablesStyleList_580278(
    name: "fusiontablesStyleList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles",
    validator: validate_FusiontablesStyleList_580279, base: "/fusiontables/v2",
    url: url_FusiontablesStyleList_580280, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleUpdate_580328 = ref object of OpenApiRestCall_579424
proc url_FusiontablesStyleUpdate_580330(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleUpdate_580329(path: JsonNode; query: JsonNode;
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
  var valid_580331 = path.getOrDefault("tableId")
  valid_580331 = validateParameter(valid_580331, JString, required = true,
                                 default = nil)
  if valid_580331 != nil:
    section.add "tableId", valid_580331
  var valid_580332 = path.getOrDefault("styleId")
  valid_580332 = validateParameter(valid_580332, JInt, required = true, default = nil)
  if valid_580332 != nil:
    section.add "styleId", valid_580332
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
  var valid_580333 = query.getOrDefault("fields")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "fields", valid_580333
  var valid_580334 = query.getOrDefault("quotaUser")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "quotaUser", valid_580334
  var valid_580335 = query.getOrDefault("alt")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = newJString("json"))
  if valid_580335 != nil:
    section.add "alt", valid_580335
  var valid_580336 = query.getOrDefault("oauth_token")
  valid_580336 = validateParameter(valid_580336, JString, required = false,
                                 default = nil)
  if valid_580336 != nil:
    section.add "oauth_token", valid_580336
  var valid_580337 = query.getOrDefault("userIp")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "userIp", valid_580337
  var valid_580338 = query.getOrDefault("key")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = nil)
  if valid_580338 != nil:
    section.add "key", valid_580338
  var valid_580339 = query.getOrDefault("prettyPrint")
  valid_580339 = validateParameter(valid_580339, JBool, required = false,
                                 default = newJBool(true))
  if valid_580339 != nil:
    section.add "prettyPrint", valid_580339
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

proc call*(call_580341: Call_FusiontablesStyleUpdate_580328; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing style.
  ## 
  let valid = call_580341.validator(path, query, header, formData, body)
  let scheme = call_580341.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580341.url(scheme.get, call_580341.host, call_580341.base,
                         call_580341.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580341, url, valid)

proc call*(call_580342: Call_FusiontablesStyleUpdate_580328; tableId: string;
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
  var path_580343 = newJObject()
  var query_580344 = newJObject()
  var body_580345 = newJObject()
  add(path_580343, "tableId", newJString(tableId))
  add(query_580344, "fields", newJString(fields))
  add(query_580344, "quotaUser", newJString(quotaUser))
  add(query_580344, "alt", newJString(alt))
  add(query_580344, "oauth_token", newJString(oauthToken))
  add(query_580344, "userIp", newJString(userIp))
  add(path_580343, "styleId", newJInt(styleId))
  add(query_580344, "key", newJString(key))
  if body != nil:
    body_580345 = body
  add(query_580344, "prettyPrint", newJBool(prettyPrint))
  result = call_580342.call(path_580343, query_580344, nil, nil, body_580345)

var fusiontablesStyleUpdate* = Call_FusiontablesStyleUpdate_580328(
    name: "fusiontablesStyleUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleUpdate_580329, base: "/fusiontables/v2",
    url: url_FusiontablesStyleUpdate_580330, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleGet_580312 = ref object of OpenApiRestCall_579424
proc url_FusiontablesStyleGet_580314(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleGet_580313(path: JsonNode; query: JsonNode;
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
  var valid_580315 = path.getOrDefault("tableId")
  valid_580315 = validateParameter(valid_580315, JString, required = true,
                                 default = nil)
  if valid_580315 != nil:
    section.add "tableId", valid_580315
  var valid_580316 = path.getOrDefault("styleId")
  valid_580316 = validateParameter(valid_580316, JInt, required = true, default = nil)
  if valid_580316 != nil:
    section.add "styleId", valid_580316
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
  var valid_580317 = query.getOrDefault("fields")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "fields", valid_580317
  var valid_580318 = query.getOrDefault("quotaUser")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "quotaUser", valid_580318
  var valid_580319 = query.getOrDefault("alt")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = newJString("json"))
  if valid_580319 != nil:
    section.add "alt", valid_580319
  var valid_580320 = query.getOrDefault("oauth_token")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "oauth_token", valid_580320
  var valid_580321 = query.getOrDefault("userIp")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "userIp", valid_580321
  var valid_580322 = query.getOrDefault("key")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "key", valid_580322
  var valid_580323 = query.getOrDefault("prettyPrint")
  valid_580323 = validateParameter(valid_580323, JBool, required = false,
                                 default = newJBool(true))
  if valid_580323 != nil:
    section.add "prettyPrint", valid_580323
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580324: Call_FusiontablesStyleGet_580312; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific style.
  ## 
  let valid = call_580324.validator(path, query, header, formData, body)
  let scheme = call_580324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580324.url(scheme.get, call_580324.host, call_580324.base,
                         call_580324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580324, url, valid)

proc call*(call_580325: Call_FusiontablesStyleGet_580312; tableId: string;
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
  var path_580326 = newJObject()
  var query_580327 = newJObject()
  add(path_580326, "tableId", newJString(tableId))
  add(query_580327, "fields", newJString(fields))
  add(query_580327, "quotaUser", newJString(quotaUser))
  add(query_580327, "alt", newJString(alt))
  add(query_580327, "oauth_token", newJString(oauthToken))
  add(query_580327, "userIp", newJString(userIp))
  add(path_580326, "styleId", newJInt(styleId))
  add(query_580327, "key", newJString(key))
  add(query_580327, "prettyPrint", newJBool(prettyPrint))
  result = call_580325.call(path_580326, query_580327, nil, nil, nil)

var fusiontablesStyleGet* = Call_FusiontablesStyleGet_580312(
    name: "fusiontablesStyleGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleGet_580313, base: "/fusiontables/v2",
    url: url_FusiontablesStyleGet_580314, schemes: {Scheme.Https})
type
  Call_FusiontablesStylePatch_580362 = ref object of OpenApiRestCall_579424
proc url_FusiontablesStylePatch_580364(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStylePatch_580363(path: JsonNode; query: JsonNode;
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
  var valid_580365 = path.getOrDefault("tableId")
  valid_580365 = validateParameter(valid_580365, JString, required = true,
                                 default = nil)
  if valid_580365 != nil:
    section.add "tableId", valid_580365
  var valid_580366 = path.getOrDefault("styleId")
  valid_580366 = validateParameter(valid_580366, JInt, required = true, default = nil)
  if valid_580366 != nil:
    section.add "styleId", valid_580366
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
  var valid_580367 = query.getOrDefault("fields")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "fields", valid_580367
  var valid_580368 = query.getOrDefault("quotaUser")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "quotaUser", valid_580368
  var valid_580369 = query.getOrDefault("alt")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("json"))
  if valid_580369 != nil:
    section.add "alt", valid_580369
  var valid_580370 = query.getOrDefault("oauth_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "oauth_token", valid_580370
  var valid_580371 = query.getOrDefault("userIp")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "userIp", valid_580371
  var valid_580372 = query.getOrDefault("key")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "key", valid_580372
  var valid_580373 = query.getOrDefault("prettyPrint")
  valid_580373 = validateParameter(valid_580373, JBool, required = false,
                                 default = newJBool(true))
  if valid_580373 != nil:
    section.add "prettyPrint", valid_580373
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

proc call*(call_580375: Call_FusiontablesStylePatch_580362; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing style. This method supports patch semantics.
  ## 
  let valid = call_580375.validator(path, query, header, formData, body)
  let scheme = call_580375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580375.url(scheme.get, call_580375.host, call_580375.base,
                         call_580375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580375, url, valid)

proc call*(call_580376: Call_FusiontablesStylePatch_580362; tableId: string;
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
  var path_580377 = newJObject()
  var query_580378 = newJObject()
  var body_580379 = newJObject()
  add(path_580377, "tableId", newJString(tableId))
  add(query_580378, "fields", newJString(fields))
  add(query_580378, "quotaUser", newJString(quotaUser))
  add(query_580378, "alt", newJString(alt))
  add(query_580378, "oauth_token", newJString(oauthToken))
  add(query_580378, "userIp", newJString(userIp))
  add(path_580377, "styleId", newJInt(styleId))
  add(query_580378, "key", newJString(key))
  if body != nil:
    body_580379 = body
  add(query_580378, "prettyPrint", newJBool(prettyPrint))
  result = call_580376.call(path_580377, query_580378, nil, nil, body_580379)

var fusiontablesStylePatch* = Call_FusiontablesStylePatch_580362(
    name: "fusiontablesStylePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStylePatch_580363, base: "/fusiontables/v2",
    url: url_FusiontablesStylePatch_580364, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleDelete_580346 = ref object of OpenApiRestCall_579424
proc url_FusiontablesStyleDelete_580348(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleDelete_580347(path: JsonNode; query: JsonNode;
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
  var valid_580349 = path.getOrDefault("tableId")
  valid_580349 = validateParameter(valid_580349, JString, required = true,
                                 default = nil)
  if valid_580349 != nil:
    section.add "tableId", valid_580349
  var valid_580350 = path.getOrDefault("styleId")
  valid_580350 = validateParameter(valid_580350, JInt, required = true, default = nil)
  if valid_580350 != nil:
    section.add "styleId", valid_580350
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
  var valid_580351 = query.getOrDefault("fields")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "fields", valid_580351
  var valid_580352 = query.getOrDefault("quotaUser")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "quotaUser", valid_580352
  var valid_580353 = query.getOrDefault("alt")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = newJString("json"))
  if valid_580353 != nil:
    section.add "alt", valid_580353
  var valid_580354 = query.getOrDefault("oauth_token")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "oauth_token", valid_580354
  var valid_580355 = query.getOrDefault("userIp")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "userIp", valid_580355
  var valid_580356 = query.getOrDefault("key")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "key", valid_580356
  var valid_580357 = query.getOrDefault("prettyPrint")
  valid_580357 = validateParameter(valid_580357, JBool, required = false,
                                 default = newJBool(true))
  if valid_580357 != nil:
    section.add "prettyPrint", valid_580357
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580358: Call_FusiontablesStyleDelete_580346; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a style.
  ## 
  let valid = call_580358.validator(path, query, header, formData, body)
  let scheme = call_580358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580358.url(scheme.get, call_580358.host, call_580358.base,
                         call_580358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580358, url, valid)

proc call*(call_580359: Call_FusiontablesStyleDelete_580346; tableId: string;
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
  var path_580360 = newJObject()
  var query_580361 = newJObject()
  add(path_580360, "tableId", newJString(tableId))
  add(query_580361, "fields", newJString(fields))
  add(query_580361, "quotaUser", newJString(quotaUser))
  add(query_580361, "alt", newJString(alt))
  add(query_580361, "oauth_token", newJString(oauthToken))
  add(query_580361, "userIp", newJString(userIp))
  add(path_580360, "styleId", newJInt(styleId))
  add(query_580361, "key", newJString(key))
  add(query_580361, "prettyPrint", newJBool(prettyPrint))
  result = call_580359.call(path_580360, query_580361, nil, nil, nil)

var fusiontablesStyleDelete* = Call_FusiontablesStyleDelete_580346(
    name: "fusiontablesStyleDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleDelete_580347, base: "/fusiontables/v2",
    url: url_FusiontablesStyleDelete_580348, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskList_580380 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTaskList_580382(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTaskList_580381(path: JsonNode; query: JsonNode;
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
  var valid_580383 = path.getOrDefault("tableId")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "tableId", valid_580383
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
  var valid_580384 = query.getOrDefault("fields")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "fields", valid_580384
  var valid_580385 = query.getOrDefault("pageToken")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "pageToken", valid_580385
  var valid_580386 = query.getOrDefault("quotaUser")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "quotaUser", valid_580386
  var valid_580387 = query.getOrDefault("alt")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = newJString("json"))
  if valid_580387 != nil:
    section.add "alt", valid_580387
  var valid_580388 = query.getOrDefault("oauth_token")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "oauth_token", valid_580388
  var valid_580389 = query.getOrDefault("userIp")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "userIp", valid_580389
  var valid_580390 = query.getOrDefault("maxResults")
  valid_580390 = validateParameter(valid_580390, JInt, required = false, default = nil)
  if valid_580390 != nil:
    section.add "maxResults", valid_580390
  var valid_580391 = query.getOrDefault("key")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "key", valid_580391
  var valid_580392 = query.getOrDefault("prettyPrint")
  valid_580392 = validateParameter(valid_580392, JBool, required = false,
                                 default = newJBool(true))
  if valid_580392 != nil:
    section.add "prettyPrint", valid_580392
  var valid_580393 = query.getOrDefault("startIndex")
  valid_580393 = validateParameter(valid_580393, JInt, required = false, default = nil)
  if valid_580393 != nil:
    section.add "startIndex", valid_580393
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580394: Call_FusiontablesTaskList_580380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of tasks.
  ## 
  let valid = call_580394.validator(path, query, header, formData, body)
  let scheme = call_580394.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580394.url(scheme.get, call_580394.host, call_580394.base,
                         call_580394.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580394, url, valid)

proc call*(call_580395: Call_FusiontablesTaskList_580380; tableId: string;
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
  var path_580396 = newJObject()
  var query_580397 = newJObject()
  add(path_580396, "tableId", newJString(tableId))
  add(query_580397, "fields", newJString(fields))
  add(query_580397, "pageToken", newJString(pageToken))
  add(query_580397, "quotaUser", newJString(quotaUser))
  add(query_580397, "alt", newJString(alt))
  add(query_580397, "oauth_token", newJString(oauthToken))
  add(query_580397, "userIp", newJString(userIp))
  add(query_580397, "maxResults", newJInt(maxResults))
  add(query_580397, "key", newJString(key))
  add(query_580397, "prettyPrint", newJBool(prettyPrint))
  add(query_580397, "startIndex", newJInt(startIndex))
  result = call_580395.call(path_580396, query_580397, nil, nil, nil)

var fusiontablesTaskList* = Call_FusiontablesTaskList_580380(
    name: "fusiontablesTaskList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks",
    validator: validate_FusiontablesTaskList_580381, base: "/fusiontables/v2",
    url: url_FusiontablesTaskList_580382, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskGet_580398 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTaskGet_580400(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTaskGet_580399(path: JsonNode; query: JsonNode;
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
  var valid_580401 = path.getOrDefault("tableId")
  valid_580401 = validateParameter(valid_580401, JString, required = true,
                                 default = nil)
  if valid_580401 != nil:
    section.add "tableId", valid_580401
  var valid_580402 = path.getOrDefault("taskId")
  valid_580402 = validateParameter(valid_580402, JString, required = true,
                                 default = nil)
  if valid_580402 != nil:
    section.add "taskId", valid_580402
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
  var valid_580403 = query.getOrDefault("fields")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = nil)
  if valid_580403 != nil:
    section.add "fields", valid_580403
  var valid_580404 = query.getOrDefault("quotaUser")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "quotaUser", valid_580404
  var valid_580405 = query.getOrDefault("alt")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = newJString("json"))
  if valid_580405 != nil:
    section.add "alt", valid_580405
  var valid_580406 = query.getOrDefault("oauth_token")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "oauth_token", valid_580406
  var valid_580407 = query.getOrDefault("userIp")
  valid_580407 = validateParameter(valid_580407, JString, required = false,
                                 default = nil)
  if valid_580407 != nil:
    section.add "userIp", valid_580407
  var valid_580408 = query.getOrDefault("key")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "key", valid_580408
  var valid_580409 = query.getOrDefault("prettyPrint")
  valid_580409 = validateParameter(valid_580409, JBool, required = false,
                                 default = newJBool(true))
  if valid_580409 != nil:
    section.add "prettyPrint", valid_580409
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580410: Call_FusiontablesTaskGet_580398; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific task by its ID.
  ## 
  let valid = call_580410.validator(path, query, header, formData, body)
  let scheme = call_580410.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580410.url(scheme.get, call_580410.host, call_580410.base,
                         call_580410.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580410, url, valid)

proc call*(call_580411: Call_FusiontablesTaskGet_580398; tableId: string;
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
  var path_580412 = newJObject()
  var query_580413 = newJObject()
  add(path_580412, "tableId", newJString(tableId))
  add(query_580413, "fields", newJString(fields))
  add(query_580413, "quotaUser", newJString(quotaUser))
  add(query_580413, "alt", newJString(alt))
  add(query_580413, "oauth_token", newJString(oauthToken))
  add(query_580413, "userIp", newJString(userIp))
  add(query_580413, "key", newJString(key))
  add(query_580413, "prettyPrint", newJBool(prettyPrint))
  add(path_580412, "taskId", newJString(taskId))
  result = call_580411.call(path_580412, query_580413, nil, nil, nil)

var fusiontablesTaskGet* = Call_FusiontablesTaskGet_580398(
    name: "fusiontablesTaskGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks/{taskId}",
    validator: validate_FusiontablesTaskGet_580399, base: "/fusiontables/v2",
    url: url_FusiontablesTaskGet_580400, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskDelete_580414 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTaskDelete_580416(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTaskDelete_580415(path: JsonNode; query: JsonNode;
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
  var valid_580417 = path.getOrDefault("tableId")
  valid_580417 = validateParameter(valid_580417, JString, required = true,
                                 default = nil)
  if valid_580417 != nil:
    section.add "tableId", valid_580417
  var valid_580418 = path.getOrDefault("taskId")
  valid_580418 = validateParameter(valid_580418, JString, required = true,
                                 default = nil)
  if valid_580418 != nil:
    section.add "taskId", valid_580418
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
  var valid_580419 = query.getOrDefault("fields")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "fields", valid_580419
  var valid_580420 = query.getOrDefault("quotaUser")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "quotaUser", valid_580420
  var valid_580421 = query.getOrDefault("alt")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = newJString("json"))
  if valid_580421 != nil:
    section.add "alt", valid_580421
  var valid_580422 = query.getOrDefault("oauth_token")
  valid_580422 = validateParameter(valid_580422, JString, required = false,
                                 default = nil)
  if valid_580422 != nil:
    section.add "oauth_token", valid_580422
  var valid_580423 = query.getOrDefault("userIp")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "userIp", valid_580423
  var valid_580424 = query.getOrDefault("key")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "key", valid_580424
  var valid_580425 = query.getOrDefault("prettyPrint")
  valid_580425 = validateParameter(valid_580425, JBool, required = false,
                                 default = newJBool(true))
  if valid_580425 != nil:
    section.add "prettyPrint", valid_580425
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580426: Call_FusiontablesTaskDelete_580414; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a specific task by its ID, unless that task has already started running.
  ## 
  let valid = call_580426.validator(path, query, header, formData, body)
  let scheme = call_580426.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580426.url(scheme.get, call_580426.host, call_580426.base,
                         call_580426.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580426, url, valid)

proc call*(call_580427: Call_FusiontablesTaskDelete_580414; tableId: string;
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
  var path_580428 = newJObject()
  var query_580429 = newJObject()
  add(path_580428, "tableId", newJString(tableId))
  add(query_580429, "fields", newJString(fields))
  add(query_580429, "quotaUser", newJString(quotaUser))
  add(query_580429, "alt", newJString(alt))
  add(query_580429, "oauth_token", newJString(oauthToken))
  add(query_580429, "userIp", newJString(userIp))
  add(query_580429, "key", newJString(key))
  add(query_580429, "prettyPrint", newJBool(prettyPrint))
  add(path_580428, "taskId", newJString(taskId))
  result = call_580427.call(path_580428, query_580429, nil, nil, nil)

var fusiontablesTaskDelete* = Call_FusiontablesTaskDelete_580414(
    name: "fusiontablesTaskDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks/{taskId}",
    validator: validate_FusiontablesTaskDelete_580415, base: "/fusiontables/v2",
    url: url_FusiontablesTaskDelete_580416, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateInsert_580447 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTemplateInsert_580449(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplateInsert_580448(path: JsonNode; query: JsonNode;
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
  var valid_580450 = path.getOrDefault("tableId")
  valid_580450 = validateParameter(valid_580450, JString, required = true,
                                 default = nil)
  if valid_580450 != nil:
    section.add "tableId", valid_580450
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
  var valid_580451 = query.getOrDefault("fields")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "fields", valid_580451
  var valid_580452 = query.getOrDefault("quotaUser")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "quotaUser", valid_580452
  var valid_580453 = query.getOrDefault("alt")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = newJString("json"))
  if valid_580453 != nil:
    section.add "alt", valid_580453
  var valid_580454 = query.getOrDefault("oauth_token")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "oauth_token", valid_580454
  var valid_580455 = query.getOrDefault("userIp")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "userIp", valid_580455
  var valid_580456 = query.getOrDefault("key")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "key", valid_580456
  var valid_580457 = query.getOrDefault("prettyPrint")
  valid_580457 = validateParameter(valid_580457, JBool, required = false,
                                 default = newJBool(true))
  if valid_580457 != nil:
    section.add "prettyPrint", valid_580457
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

proc call*(call_580459: Call_FusiontablesTemplateInsert_580447; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new template for the table.
  ## 
  let valid = call_580459.validator(path, query, header, formData, body)
  let scheme = call_580459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580459.url(scheme.get, call_580459.host, call_580459.base,
                         call_580459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580459, url, valid)

proc call*(call_580460: Call_FusiontablesTemplateInsert_580447; tableId: string;
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
  var path_580461 = newJObject()
  var query_580462 = newJObject()
  var body_580463 = newJObject()
  add(path_580461, "tableId", newJString(tableId))
  add(query_580462, "fields", newJString(fields))
  add(query_580462, "quotaUser", newJString(quotaUser))
  add(query_580462, "alt", newJString(alt))
  add(query_580462, "oauth_token", newJString(oauthToken))
  add(query_580462, "userIp", newJString(userIp))
  add(query_580462, "key", newJString(key))
  if body != nil:
    body_580463 = body
  add(query_580462, "prettyPrint", newJBool(prettyPrint))
  result = call_580460.call(path_580461, query_580462, nil, nil, body_580463)

var fusiontablesTemplateInsert* = Call_FusiontablesTemplateInsert_580447(
    name: "fusiontablesTemplateInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates",
    validator: validate_FusiontablesTemplateInsert_580448,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateInsert_580449,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateList_580430 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTemplateList_580432(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplateList_580431(path: JsonNode; query: JsonNode;
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
  var valid_580433 = path.getOrDefault("tableId")
  valid_580433 = validateParameter(valid_580433, JString, required = true,
                                 default = nil)
  if valid_580433 != nil:
    section.add "tableId", valid_580433
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
  var valid_580434 = query.getOrDefault("fields")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "fields", valid_580434
  var valid_580435 = query.getOrDefault("pageToken")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "pageToken", valid_580435
  var valid_580436 = query.getOrDefault("quotaUser")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "quotaUser", valid_580436
  var valid_580437 = query.getOrDefault("alt")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = newJString("json"))
  if valid_580437 != nil:
    section.add "alt", valid_580437
  var valid_580438 = query.getOrDefault("oauth_token")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "oauth_token", valid_580438
  var valid_580439 = query.getOrDefault("userIp")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "userIp", valid_580439
  var valid_580440 = query.getOrDefault("maxResults")
  valid_580440 = validateParameter(valid_580440, JInt, required = false, default = nil)
  if valid_580440 != nil:
    section.add "maxResults", valid_580440
  var valid_580441 = query.getOrDefault("key")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "key", valid_580441
  var valid_580442 = query.getOrDefault("prettyPrint")
  valid_580442 = validateParameter(valid_580442, JBool, required = false,
                                 default = newJBool(true))
  if valid_580442 != nil:
    section.add "prettyPrint", valid_580442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580443: Call_FusiontablesTemplateList_580430; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of templates.
  ## 
  let valid = call_580443.validator(path, query, header, formData, body)
  let scheme = call_580443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580443.url(scheme.get, call_580443.host, call_580443.base,
                         call_580443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580443, url, valid)

proc call*(call_580444: Call_FusiontablesTemplateList_580430; tableId: string;
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
  var path_580445 = newJObject()
  var query_580446 = newJObject()
  add(path_580445, "tableId", newJString(tableId))
  add(query_580446, "fields", newJString(fields))
  add(query_580446, "pageToken", newJString(pageToken))
  add(query_580446, "quotaUser", newJString(quotaUser))
  add(query_580446, "alt", newJString(alt))
  add(query_580446, "oauth_token", newJString(oauthToken))
  add(query_580446, "userIp", newJString(userIp))
  add(query_580446, "maxResults", newJInt(maxResults))
  add(query_580446, "key", newJString(key))
  add(query_580446, "prettyPrint", newJBool(prettyPrint))
  result = call_580444.call(path_580445, query_580446, nil, nil, nil)

var fusiontablesTemplateList* = Call_FusiontablesTemplateList_580430(
    name: "fusiontablesTemplateList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates",
    validator: validate_FusiontablesTemplateList_580431, base: "/fusiontables/v2",
    url: url_FusiontablesTemplateList_580432, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateUpdate_580480 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTemplateUpdate_580482(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplateUpdate_580481(path: JsonNode; query: JsonNode;
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
  var valid_580483 = path.getOrDefault("tableId")
  valid_580483 = validateParameter(valid_580483, JString, required = true,
                                 default = nil)
  if valid_580483 != nil:
    section.add "tableId", valid_580483
  var valid_580484 = path.getOrDefault("templateId")
  valid_580484 = validateParameter(valid_580484, JInt, required = true, default = nil)
  if valid_580484 != nil:
    section.add "templateId", valid_580484
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
  var valid_580485 = query.getOrDefault("fields")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "fields", valid_580485
  var valid_580486 = query.getOrDefault("quotaUser")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "quotaUser", valid_580486
  var valid_580487 = query.getOrDefault("alt")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = newJString("json"))
  if valid_580487 != nil:
    section.add "alt", valid_580487
  var valid_580488 = query.getOrDefault("oauth_token")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "oauth_token", valid_580488
  var valid_580489 = query.getOrDefault("userIp")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "userIp", valid_580489
  var valid_580490 = query.getOrDefault("key")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "key", valid_580490
  var valid_580491 = query.getOrDefault("prettyPrint")
  valid_580491 = validateParameter(valid_580491, JBool, required = false,
                                 default = newJBool(true))
  if valid_580491 != nil:
    section.add "prettyPrint", valid_580491
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

proc call*(call_580493: Call_FusiontablesTemplateUpdate_580480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing template
  ## 
  let valid = call_580493.validator(path, query, header, formData, body)
  let scheme = call_580493.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580493.url(scheme.get, call_580493.host, call_580493.base,
                         call_580493.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580493, url, valid)

proc call*(call_580494: Call_FusiontablesTemplateUpdate_580480; tableId: string;
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
  var path_580495 = newJObject()
  var query_580496 = newJObject()
  var body_580497 = newJObject()
  add(path_580495, "tableId", newJString(tableId))
  add(query_580496, "fields", newJString(fields))
  add(query_580496, "quotaUser", newJString(quotaUser))
  add(query_580496, "alt", newJString(alt))
  add(path_580495, "templateId", newJInt(templateId))
  add(query_580496, "oauth_token", newJString(oauthToken))
  add(query_580496, "userIp", newJString(userIp))
  add(query_580496, "key", newJString(key))
  if body != nil:
    body_580497 = body
  add(query_580496, "prettyPrint", newJBool(prettyPrint))
  result = call_580494.call(path_580495, query_580496, nil, nil, body_580497)

var fusiontablesTemplateUpdate* = Call_FusiontablesTemplateUpdate_580480(
    name: "fusiontablesTemplateUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateUpdate_580481,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateUpdate_580482,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateGet_580464 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTemplateGet_580466(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTemplateGet_580465(path: JsonNode; query: JsonNode;
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
  var valid_580467 = path.getOrDefault("tableId")
  valid_580467 = validateParameter(valid_580467, JString, required = true,
                                 default = nil)
  if valid_580467 != nil:
    section.add "tableId", valid_580467
  var valid_580468 = path.getOrDefault("templateId")
  valid_580468 = validateParameter(valid_580468, JInt, required = true, default = nil)
  if valid_580468 != nil:
    section.add "templateId", valid_580468
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
  var valid_580469 = query.getOrDefault("fields")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "fields", valid_580469
  var valid_580470 = query.getOrDefault("quotaUser")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "quotaUser", valid_580470
  var valid_580471 = query.getOrDefault("alt")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = newJString("json"))
  if valid_580471 != nil:
    section.add "alt", valid_580471
  var valid_580472 = query.getOrDefault("oauth_token")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "oauth_token", valid_580472
  var valid_580473 = query.getOrDefault("userIp")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "userIp", valid_580473
  var valid_580474 = query.getOrDefault("key")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = nil)
  if valid_580474 != nil:
    section.add "key", valid_580474
  var valid_580475 = query.getOrDefault("prettyPrint")
  valid_580475 = validateParameter(valid_580475, JBool, required = false,
                                 default = newJBool(true))
  if valid_580475 != nil:
    section.add "prettyPrint", valid_580475
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580476: Call_FusiontablesTemplateGet_580464; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific template by its id
  ## 
  let valid = call_580476.validator(path, query, header, formData, body)
  let scheme = call_580476.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580476.url(scheme.get, call_580476.host, call_580476.base,
                         call_580476.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580476, url, valid)

proc call*(call_580477: Call_FusiontablesTemplateGet_580464; tableId: string;
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
  var path_580478 = newJObject()
  var query_580479 = newJObject()
  add(path_580478, "tableId", newJString(tableId))
  add(query_580479, "fields", newJString(fields))
  add(query_580479, "quotaUser", newJString(quotaUser))
  add(query_580479, "alt", newJString(alt))
  add(path_580478, "templateId", newJInt(templateId))
  add(query_580479, "oauth_token", newJString(oauthToken))
  add(query_580479, "userIp", newJString(userIp))
  add(query_580479, "key", newJString(key))
  add(query_580479, "prettyPrint", newJBool(prettyPrint))
  result = call_580477.call(path_580478, query_580479, nil, nil, nil)

var fusiontablesTemplateGet* = Call_FusiontablesTemplateGet_580464(
    name: "fusiontablesTemplateGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateGet_580465, base: "/fusiontables/v2",
    url: url_FusiontablesTemplateGet_580466, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplatePatch_580514 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTemplatePatch_580516(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplatePatch_580515(path: JsonNode; query: JsonNode;
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
  var valid_580517 = path.getOrDefault("tableId")
  valid_580517 = validateParameter(valid_580517, JString, required = true,
                                 default = nil)
  if valid_580517 != nil:
    section.add "tableId", valid_580517
  var valid_580518 = path.getOrDefault("templateId")
  valid_580518 = validateParameter(valid_580518, JInt, required = true, default = nil)
  if valid_580518 != nil:
    section.add "templateId", valid_580518
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
  var valid_580519 = query.getOrDefault("fields")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "fields", valid_580519
  var valid_580520 = query.getOrDefault("quotaUser")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = nil)
  if valid_580520 != nil:
    section.add "quotaUser", valid_580520
  var valid_580521 = query.getOrDefault("alt")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = newJString("json"))
  if valid_580521 != nil:
    section.add "alt", valid_580521
  var valid_580522 = query.getOrDefault("oauth_token")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "oauth_token", valid_580522
  var valid_580523 = query.getOrDefault("userIp")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "userIp", valid_580523
  var valid_580524 = query.getOrDefault("key")
  valid_580524 = validateParameter(valid_580524, JString, required = false,
                                 default = nil)
  if valid_580524 != nil:
    section.add "key", valid_580524
  var valid_580525 = query.getOrDefault("prettyPrint")
  valid_580525 = validateParameter(valid_580525, JBool, required = false,
                                 default = newJBool(true))
  if valid_580525 != nil:
    section.add "prettyPrint", valid_580525
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

proc call*(call_580527: Call_FusiontablesTemplatePatch_580514; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing template. This method supports patch semantics.
  ## 
  let valid = call_580527.validator(path, query, header, formData, body)
  let scheme = call_580527.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580527.url(scheme.get, call_580527.host, call_580527.base,
                         call_580527.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580527, url, valid)

proc call*(call_580528: Call_FusiontablesTemplatePatch_580514; tableId: string;
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
  var path_580529 = newJObject()
  var query_580530 = newJObject()
  var body_580531 = newJObject()
  add(path_580529, "tableId", newJString(tableId))
  add(query_580530, "fields", newJString(fields))
  add(query_580530, "quotaUser", newJString(quotaUser))
  add(query_580530, "alt", newJString(alt))
  add(path_580529, "templateId", newJInt(templateId))
  add(query_580530, "oauth_token", newJString(oauthToken))
  add(query_580530, "userIp", newJString(userIp))
  add(query_580530, "key", newJString(key))
  if body != nil:
    body_580531 = body
  add(query_580530, "prettyPrint", newJBool(prettyPrint))
  result = call_580528.call(path_580529, query_580530, nil, nil, body_580531)

var fusiontablesTemplatePatch* = Call_FusiontablesTemplatePatch_580514(
    name: "fusiontablesTemplatePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplatePatch_580515,
    base: "/fusiontables/v2", url: url_FusiontablesTemplatePatch_580516,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateDelete_580498 = ref object of OpenApiRestCall_579424
proc url_FusiontablesTemplateDelete_580500(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplateDelete_580499(path: JsonNode; query: JsonNode;
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
  var valid_580501 = path.getOrDefault("tableId")
  valid_580501 = validateParameter(valid_580501, JString, required = true,
                                 default = nil)
  if valid_580501 != nil:
    section.add "tableId", valid_580501
  var valid_580502 = path.getOrDefault("templateId")
  valid_580502 = validateParameter(valid_580502, JInt, required = true, default = nil)
  if valid_580502 != nil:
    section.add "templateId", valid_580502
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
  var valid_580503 = query.getOrDefault("fields")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "fields", valid_580503
  var valid_580504 = query.getOrDefault("quotaUser")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "quotaUser", valid_580504
  var valid_580505 = query.getOrDefault("alt")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = newJString("json"))
  if valid_580505 != nil:
    section.add "alt", valid_580505
  var valid_580506 = query.getOrDefault("oauth_token")
  valid_580506 = validateParameter(valid_580506, JString, required = false,
                                 default = nil)
  if valid_580506 != nil:
    section.add "oauth_token", valid_580506
  var valid_580507 = query.getOrDefault("userIp")
  valid_580507 = validateParameter(valid_580507, JString, required = false,
                                 default = nil)
  if valid_580507 != nil:
    section.add "userIp", valid_580507
  var valid_580508 = query.getOrDefault("key")
  valid_580508 = validateParameter(valid_580508, JString, required = false,
                                 default = nil)
  if valid_580508 != nil:
    section.add "key", valid_580508
  var valid_580509 = query.getOrDefault("prettyPrint")
  valid_580509 = validateParameter(valid_580509, JBool, required = false,
                                 default = newJBool(true))
  if valid_580509 != nil:
    section.add "prettyPrint", valid_580509
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580510: Call_FusiontablesTemplateDelete_580498; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a template
  ## 
  let valid = call_580510.validator(path, query, header, formData, body)
  let scheme = call_580510.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580510.url(scheme.get, call_580510.host, call_580510.base,
                         call_580510.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580510, url, valid)

proc call*(call_580511: Call_FusiontablesTemplateDelete_580498; tableId: string;
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
  var path_580512 = newJObject()
  var query_580513 = newJObject()
  add(path_580512, "tableId", newJString(tableId))
  add(query_580513, "fields", newJString(fields))
  add(query_580513, "quotaUser", newJString(quotaUser))
  add(query_580513, "alt", newJString(alt))
  add(path_580512, "templateId", newJInt(templateId))
  add(query_580513, "oauth_token", newJString(oauthToken))
  add(query_580513, "userIp", newJString(userIp))
  add(query_580513, "key", newJString(key))
  add(query_580513, "prettyPrint", newJBool(prettyPrint))
  result = call_580511.call(path_580512, query_580513, nil, nil, nil)

var fusiontablesTemplateDelete* = Call_FusiontablesTemplateDelete_580498(
    name: "fusiontablesTemplateDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateDelete_580499,
    base: "/fusiontables/v2", url: url_FusiontablesTemplateDelete_580500,
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
