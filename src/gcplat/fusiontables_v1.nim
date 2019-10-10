
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Fusion Tables
## version: v1
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
  Call_FusiontablesQuerySql_588996 = ref object of OpenApiRestCall_588457
proc url_FusiontablesQuerySql_588998(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesQuerySql_588997(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes an SQL SELECT/INSERT/UPDATE/DELETE/SHOW/DESCRIBE/CREATE statement.
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
  ##        : Should typed values be returned in the (JSON) response -- numbers for numeric values and parsed geometries for KML values? Default is true.
  ##   sql: JString (required)
  ##      : An SQL SELECT/SHOW/DESCRIBE/INSERT/UPDATE/DELETE/CREATE statement.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   hdrs: JBool
  ##       : Should column names be included (in the first row)?. Default is true.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588999 = query.getOrDefault("fields")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = nil)
  if valid_588999 != nil:
    section.add "fields", valid_588999
  var valid_589000 = query.getOrDefault("quotaUser")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "quotaUser", valid_589000
  var valid_589001 = query.getOrDefault("alt")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = newJString("json"))
  if valid_589001 != nil:
    section.add "alt", valid_589001
  var valid_589002 = query.getOrDefault("typed")
  valid_589002 = validateParameter(valid_589002, JBool, required = false, default = nil)
  if valid_589002 != nil:
    section.add "typed", valid_589002
  assert query != nil, "query argument is necessary due to required `sql` field"
  var valid_589003 = query.getOrDefault("sql")
  valid_589003 = validateParameter(valid_589003, JString, required = true,
                                 default = nil)
  if valid_589003 != nil:
    section.add "sql", valid_589003
  var valid_589004 = query.getOrDefault("oauth_token")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "oauth_token", valid_589004
  var valid_589005 = query.getOrDefault("userIp")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "userIp", valid_589005
  var valid_589006 = query.getOrDefault("hdrs")
  valid_589006 = validateParameter(valid_589006, JBool, required = false, default = nil)
  if valid_589006 != nil:
    section.add "hdrs", valid_589006
  var valid_589007 = query.getOrDefault("key")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "key", valid_589007
  var valid_589008 = query.getOrDefault("prettyPrint")
  valid_589008 = validateParameter(valid_589008, JBool, required = false,
                                 default = newJBool(true))
  if valid_589008 != nil:
    section.add "prettyPrint", valid_589008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589009: Call_FusiontablesQuerySql_588996; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an SQL SELECT/INSERT/UPDATE/DELETE/SHOW/DESCRIBE/CREATE statement.
  ## 
  let valid = call_589009.validator(path, query, header, formData, body)
  let scheme = call_589009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589009.url(scheme.get, call_589009.host, call_589009.base,
                         call_589009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589009, url, valid)

proc call*(call_589010: Call_FusiontablesQuerySql_588996; sql: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          typed: bool = false; oauthToken: string = ""; userIp: string = "";
          hdrs: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesQuerySql
  ## Executes an SQL SELECT/INSERT/UPDATE/DELETE/SHOW/DESCRIBE/CREATE statement.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typed: bool
  ##        : Should typed values be returned in the (JSON) response -- numbers for numeric values and parsed geometries for KML values? Default is true.
  ##   sql: string (required)
  ##      : An SQL SELECT/SHOW/DESCRIBE/INSERT/UPDATE/DELETE/CREATE statement.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   hdrs: bool
  ##       : Should column names be included (in the first row)?. Default is true.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589011 = newJObject()
  add(query_589011, "fields", newJString(fields))
  add(query_589011, "quotaUser", newJString(quotaUser))
  add(query_589011, "alt", newJString(alt))
  add(query_589011, "typed", newJBool(typed))
  add(query_589011, "sql", newJString(sql))
  add(query_589011, "oauth_token", newJString(oauthToken))
  add(query_589011, "userIp", newJString(userIp))
  add(query_589011, "hdrs", newJBool(hdrs))
  add(query_589011, "key", newJString(key))
  add(query_589011, "prettyPrint", newJBool(prettyPrint))
  result = call_589010.call(nil, query_589011, nil, nil, nil)

var fusiontablesQuerySql* = Call_FusiontablesQuerySql_588996(
    name: "fusiontablesQuerySql", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_FusiontablesQuerySql_588997, base: "/fusiontables/v1",
    url: url_FusiontablesQuerySql_588998, schemes: {Scheme.Https})
type
  Call_FusiontablesQuerySqlGet_588725 = ref object of OpenApiRestCall_588457
proc url_FusiontablesQuerySqlGet_588727(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesQuerySqlGet_588726(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Executes an SQL SELECT/SHOW/DESCRIBE statement.
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
  ##        : Should typed values be returned in the (JSON) response -- numbers for numeric values and parsed geometries for KML values? Default is true.
  ##   sql: JString (required)
  ##      : An SQL SELECT/SHOW/DESCRIBE statement.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   hdrs: JBool
  ##       : Should column names be included (in the first row)?. Default is true.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588839 = query.getOrDefault("fields")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "fields", valid_588839
  var valid_588840 = query.getOrDefault("quotaUser")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "quotaUser", valid_588840
  var valid_588854 = query.getOrDefault("alt")
  valid_588854 = validateParameter(valid_588854, JString, required = false,
                                 default = newJString("json"))
  if valid_588854 != nil:
    section.add "alt", valid_588854
  var valid_588855 = query.getOrDefault("typed")
  valid_588855 = validateParameter(valid_588855, JBool, required = false, default = nil)
  if valid_588855 != nil:
    section.add "typed", valid_588855
  assert query != nil, "query argument is necessary due to required `sql` field"
  var valid_588856 = query.getOrDefault("sql")
  valid_588856 = validateParameter(valid_588856, JString, required = true,
                                 default = nil)
  if valid_588856 != nil:
    section.add "sql", valid_588856
  var valid_588857 = query.getOrDefault("oauth_token")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "oauth_token", valid_588857
  var valid_588858 = query.getOrDefault("userIp")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "userIp", valid_588858
  var valid_588859 = query.getOrDefault("hdrs")
  valid_588859 = validateParameter(valid_588859, JBool, required = false, default = nil)
  if valid_588859 != nil:
    section.add "hdrs", valid_588859
  var valid_588860 = query.getOrDefault("key")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "key", valid_588860
  var valid_588861 = query.getOrDefault("prettyPrint")
  valid_588861 = validateParameter(valid_588861, JBool, required = false,
                                 default = newJBool(true))
  if valid_588861 != nil:
    section.add "prettyPrint", valid_588861
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588884: Call_FusiontablesQuerySqlGet_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Executes an SQL SELECT/SHOW/DESCRIBE statement.
  ## 
  let valid = call_588884.validator(path, query, header, formData, body)
  let scheme = call_588884.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588884.url(scheme.get, call_588884.host, call_588884.base,
                         call_588884.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588884, url, valid)

proc call*(call_588955: Call_FusiontablesQuerySqlGet_588725; sql: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          typed: bool = false; oauthToken: string = ""; userIp: string = "";
          hdrs: bool = false; key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesQuerySqlGet
  ## Executes an SQL SELECT/SHOW/DESCRIBE statement.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   typed: bool
  ##        : Should typed values be returned in the (JSON) response -- numbers for numeric values and parsed geometries for KML values? Default is true.
  ##   sql: string (required)
  ##      : An SQL SELECT/SHOW/DESCRIBE statement.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   hdrs: bool
  ##       : Should column names be included (in the first row)?. Default is true.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588956 = newJObject()
  add(query_588956, "fields", newJString(fields))
  add(query_588956, "quotaUser", newJString(quotaUser))
  add(query_588956, "alt", newJString(alt))
  add(query_588956, "typed", newJBool(typed))
  add(query_588956, "sql", newJString(sql))
  add(query_588956, "oauth_token", newJString(oauthToken))
  add(query_588956, "userIp", newJString(userIp))
  add(query_588956, "hdrs", newJBool(hdrs))
  add(query_588956, "key", newJString(key))
  add(query_588956, "prettyPrint", newJBool(prettyPrint))
  result = call_588955.call(nil, query_588956, nil, nil, nil)

var fusiontablesQuerySqlGet* = Call_FusiontablesQuerySqlGet_588725(
    name: "fusiontablesQuerySqlGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query",
    validator: validate_FusiontablesQuerySqlGet_588726, base: "/fusiontables/v1",
    url: url_FusiontablesQuerySqlGet_588727, schemes: {Scheme.Https})
type
  Call_FusiontablesTableInsert_589027 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTableInsert_589029(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableInsert_589028(path: JsonNode; query: JsonNode;
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
  var valid_589030 = query.getOrDefault("fields")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "fields", valid_589030
  var valid_589031 = query.getOrDefault("quotaUser")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "quotaUser", valid_589031
  var valid_589032 = query.getOrDefault("alt")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("json"))
  if valid_589032 != nil:
    section.add "alt", valid_589032
  var valid_589033 = query.getOrDefault("oauth_token")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "oauth_token", valid_589033
  var valid_589034 = query.getOrDefault("userIp")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "userIp", valid_589034
  var valid_589035 = query.getOrDefault("key")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "key", valid_589035
  var valid_589036 = query.getOrDefault("prettyPrint")
  valid_589036 = validateParameter(valid_589036, JBool, required = false,
                                 default = newJBool(true))
  if valid_589036 != nil:
    section.add "prettyPrint", valid_589036
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

proc call*(call_589038: Call_FusiontablesTableInsert_589027; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new table.
  ## 
  let valid = call_589038.validator(path, query, header, formData, body)
  let scheme = call_589038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589038.url(scheme.get, call_589038.host, call_589038.base,
                         call_589038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589038, url, valid)

proc call*(call_589039: Call_FusiontablesTableInsert_589027; fields: string = "";
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
  var query_589040 = newJObject()
  var body_589041 = newJObject()
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "userIp", newJString(userIp))
  add(query_589040, "key", newJString(key))
  if body != nil:
    body_589041 = body
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589039.call(nil, query_589040, nil, nil, body_589041)

var fusiontablesTableInsert* = Call_FusiontablesTableInsert_589027(
    name: "fusiontablesTableInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables",
    validator: validate_FusiontablesTableInsert_589028, base: "/fusiontables/v1",
    url: url_FusiontablesTableInsert_589029, schemes: {Scheme.Https})
type
  Call_FusiontablesTableList_589012 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTableList_589014(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableList_589013(path: JsonNode; query: JsonNode;
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
  var valid_589015 = query.getOrDefault("fields")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = nil)
  if valid_589015 != nil:
    section.add "fields", valid_589015
  var valid_589016 = query.getOrDefault("pageToken")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "pageToken", valid_589016
  var valid_589017 = query.getOrDefault("quotaUser")
  valid_589017 = validateParameter(valid_589017, JString, required = false,
                                 default = nil)
  if valid_589017 != nil:
    section.add "quotaUser", valid_589017
  var valid_589018 = query.getOrDefault("alt")
  valid_589018 = validateParameter(valid_589018, JString, required = false,
                                 default = newJString("json"))
  if valid_589018 != nil:
    section.add "alt", valid_589018
  var valid_589019 = query.getOrDefault("oauth_token")
  valid_589019 = validateParameter(valid_589019, JString, required = false,
                                 default = nil)
  if valid_589019 != nil:
    section.add "oauth_token", valid_589019
  var valid_589020 = query.getOrDefault("userIp")
  valid_589020 = validateParameter(valid_589020, JString, required = false,
                                 default = nil)
  if valid_589020 != nil:
    section.add "userIp", valid_589020
  var valid_589021 = query.getOrDefault("maxResults")
  valid_589021 = validateParameter(valid_589021, JInt, required = false, default = nil)
  if valid_589021 != nil:
    section.add "maxResults", valid_589021
  var valid_589022 = query.getOrDefault("key")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "key", valid_589022
  var valid_589023 = query.getOrDefault("prettyPrint")
  valid_589023 = validateParameter(valid_589023, JBool, required = false,
                                 default = newJBool(true))
  if valid_589023 != nil:
    section.add "prettyPrint", valid_589023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589024: Call_FusiontablesTableList_589012; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of tables a user owns.
  ## 
  let valid = call_589024.validator(path, query, header, formData, body)
  let scheme = call_589024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589024.url(scheme.get, call_589024.host, call_589024.base,
                         call_589024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589024, url, valid)

proc call*(call_589025: Call_FusiontablesTableList_589012; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTableList
  ## Retrieves a list of tables a user owns.
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
  var query_589026 = newJObject()
  add(query_589026, "fields", newJString(fields))
  add(query_589026, "pageToken", newJString(pageToken))
  add(query_589026, "quotaUser", newJString(quotaUser))
  add(query_589026, "alt", newJString(alt))
  add(query_589026, "oauth_token", newJString(oauthToken))
  add(query_589026, "userIp", newJString(userIp))
  add(query_589026, "maxResults", newJInt(maxResults))
  add(query_589026, "key", newJString(key))
  add(query_589026, "prettyPrint", newJBool(prettyPrint))
  result = call_589025.call(nil, query_589026, nil, nil, nil)

var fusiontablesTableList* = Call_FusiontablesTableList_589012(
    name: "fusiontablesTableList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables",
    validator: validate_FusiontablesTableList_589013, base: "/fusiontables/v1",
    url: url_FusiontablesTableList_589014, schemes: {Scheme.Https})
type
  Call_FusiontablesTableImportTable_589042 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTableImportTable_589044(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_FusiontablesTableImportTable_589043(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Import a new table.
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
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ','.
  ##   encoding: JString
  ##           : The encoding of the content. Default is UTF-8. Use 'auto-detect' if you are unsure of the encoding.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589045 = query.getOrDefault("fields")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "fields", valid_589045
  var valid_589046 = query.getOrDefault("quotaUser")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "quotaUser", valid_589046
  var valid_589047 = query.getOrDefault("alt")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("json"))
  if valid_589047 != nil:
    section.add "alt", valid_589047
  var valid_589048 = query.getOrDefault("oauth_token")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "oauth_token", valid_589048
  var valid_589049 = query.getOrDefault("userIp")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "userIp", valid_589049
  var valid_589050 = query.getOrDefault("key")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "key", valid_589050
  assert query != nil, "query argument is necessary due to required `name` field"
  var valid_589051 = query.getOrDefault("name")
  valid_589051 = validateParameter(valid_589051, JString, required = true,
                                 default = nil)
  if valid_589051 != nil:
    section.add "name", valid_589051
  var valid_589052 = query.getOrDefault("delimiter")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "delimiter", valid_589052
  var valid_589053 = query.getOrDefault("encoding")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = nil)
  if valid_589053 != nil:
    section.add "encoding", valid_589053
  var valid_589054 = query.getOrDefault("prettyPrint")
  valid_589054 = validateParameter(valid_589054, JBool, required = false,
                                 default = newJBool(true))
  if valid_589054 != nil:
    section.add "prettyPrint", valid_589054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589055: Call_FusiontablesTableImportTable_589042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Import a new table.
  ## 
  let valid = call_589055.validator(path, query, header, formData, body)
  let scheme = call_589055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589055.url(scheme.get, call_589055.host, call_589055.base,
                         call_589055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589055, url, valid)

proc call*(call_589056: Call_FusiontablesTableImportTable_589042; name: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          delimiter: string = ""; encoding: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTableImportTable
  ## Import a new table.
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
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ','.
  ##   encoding: string
  ##           : The encoding of the content. Default is UTF-8. Use 'auto-detect' if you are unsure of the encoding.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589057 = newJObject()
  add(query_589057, "fields", newJString(fields))
  add(query_589057, "quotaUser", newJString(quotaUser))
  add(query_589057, "alt", newJString(alt))
  add(query_589057, "oauth_token", newJString(oauthToken))
  add(query_589057, "userIp", newJString(userIp))
  add(query_589057, "key", newJString(key))
  add(query_589057, "name", newJString(name))
  add(query_589057, "delimiter", newJString(delimiter))
  add(query_589057, "encoding", newJString(encoding))
  add(query_589057, "prettyPrint", newJBool(prettyPrint))
  result = call_589056.call(nil, query_589057, nil, nil, nil)

var fusiontablesTableImportTable* = Call_FusiontablesTableImportTable_589042(
    name: "fusiontablesTableImportTable", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/import",
    validator: validate_FusiontablesTableImportTable_589043,
    base: "/fusiontables/v1", url: url_FusiontablesTableImportTable_589044,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTableUpdate_589087 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTableUpdate_589089(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTableUpdate_589088(path: JsonNode; query: JsonNode;
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
  var valid_589090 = path.getOrDefault("tableId")
  valid_589090 = validateParameter(valid_589090, JString, required = true,
                                 default = nil)
  if valid_589090 != nil:
    section.add "tableId", valid_589090
  result.add "path", section
  ## parameters in `query` object:
  ##   replaceViewDefinition: JBool
  ##                        : Should the view definition also be updated? The specified view definition replaces the existing one. Only a view can be updated with a new definition.
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
  var valid_589091 = query.getOrDefault("replaceViewDefinition")
  valid_589091 = validateParameter(valid_589091, JBool, required = false, default = nil)
  if valid_589091 != nil:
    section.add "replaceViewDefinition", valid_589091
  var valid_589092 = query.getOrDefault("fields")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "fields", valid_589092
  var valid_589093 = query.getOrDefault("quotaUser")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "quotaUser", valid_589093
  var valid_589094 = query.getOrDefault("alt")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = newJString("json"))
  if valid_589094 != nil:
    section.add "alt", valid_589094
  var valid_589095 = query.getOrDefault("oauth_token")
  valid_589095 = validateParameter(valid_589095, JString, required = false,
                                 default = nil)
  if valid_589095 != nil:
    section.add "oauth_token", valid_589095
  var valid_589096 = query.getOrDefault("userIp")
  valid_589096 = validateParameter(valid_589096, JString, required = false,
                                 default = nil)
  if valid_589096 != nil:
    section.add "userIp", valid_589096
  var valid_589097 = query.getOrDefault("key")
  valid_589097 = validateParameter(valid_589097, JString, required = false,
                                 default = nil)
  if valid_589097 != nil:
    section.add "key", valid_589097
  var valid_589098 = query.getOrDefault("prettyPrint")
  valid_589098 = validateParameter(valid_589098, JBool, required = false,
                                 default = newJBool(true))
  if valid_589098 != nil:
    section.add "prettyPrint", valid_589098
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

proc call*(call_589100: Call_FusiontablesTableUpdate_589087; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated.
  ## 
  let valid = call_589100.validator(path, query, header, formData, body)
  let scheme = call_589100.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589100.url(scheme.get, call_589100.host, call_589100.base,
                         call_589100.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589100, url, valid)

proc call*(call_589101: Call_FusiontablesTableUpdate_589087; tableId: string;
          replaceViewDefinition: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTableUpdate
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated.
  ##   replaceViewDefinition: bool
  ##                        : Should the view definition also be updated? The specified view definition replaces the existing one. Only a view can be updated with a new definition.
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
  var path_589102 = newJObject()
  var query_589103 = newJObject()
  var body_589104 = newJObject()
  add(query_589103, "replaceViewDefinition", newJBool(replaceViewDefinition))
  add(path_589102, "tableId", newJString(tableId))
  add(query_589103, "fields", newJString(fields))
  add(query_589103, "quotaUser", newJString(quotaUser))
  add(query_589103, "alt", newJString(alt))
  add(query_589103, "oauth_token", newJString(oauthToken))
  add(query_589103, "userIp", newJString(userIp))
  add(query_589103, "key", newJString(key))
  if body != nil:
    body_589104 = body
  add(query_589103, "prettyPrint", newJBool(prettyPrint))
  result = call_589101.call(path_589102, query_589103, nil, nil, body_589104)

var fusiontablesTableUpdate* = Call_FusiontablesTableUpdate_589087(
    name: "fusiontablesTableUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableUpdate_589088, base: "/fusiontables/v1",
    url: url_FusiontablesTableUpdate_589089, schemes: {Scheme.Https})
type
  Call_FusiontablesTableGet_589058 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTableGet_589060(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTableGet_589059(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a specific table by its id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Identifier(ID) for the table being requested.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589075 = path.getOrDefault("tableId")
  valid_589075 = validateParameter(valid_589075, JString, required = true,
                                 default = nil)
  if valid_589075 != nil:
    section.add "tableId", valid_589075
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
  var valid_589076 = query.getOrDefault("fields")
  valid_589076 = validateParameter(valid_589076, JString, required = false,
                                 default = nil)
  if valid_589076 != nil:
    section.add "fields", valid_589076
  var valid_589077 = query.getOrDefault("quotaUser")
  valid_589077 = validateParameter(valid_589077, JString, required = false,
                                 default = nil)
  if valid_589077 != nil:
    section.add "quotaUser", valid_589077
  var valid_589078 = query.getOrDefault("alt")
  valid_589078 = validateParameter(valid_589078, JString, required = false,
                                 default = newJString("json"))
  if valid_589078 != nil:
    section.add "alt", valid_589078
  var valid_589079 = query.getOrDefault("oauth_token")
  valid_589079 = validateParameter(valid_589079, JString, required = false,
                                 default = nil)
  if valid_589079 != nil:
    section.add "oauth_token", valid_589079
  var valid_589080 = query.getOrDefault("userIp")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "userIp", valid_589080
  var valid_589081 = query.getOrDefault("key")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "key", valid_589081
  var valid_589082 = query.getOrDefault("prettyPrint")
  valid_589082 = validateParameter(valid_589082, JBool, required = false,
                                 default = newJBool(true))
  if valid_589082 != nil:
    section.add "prettyPrint", valid_589082
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589083: Call_FusiontablesTableGet_589058; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific table by its id.
  ## 
  let valid = call_589083.validator(path, query, header, formData, body)
  let scheme = call_589083.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589083.url(scheme.get, call_589083.host, call_589083.base,
                         call_589083.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589083, url, valid)

proc call*(call_589084: Call_FusiontablesTableGet_589058; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTableGet
  ## Retrieves a specific table by its id.
  ##   tableId: string (required)
  ##          : Identifier(ID) for the table being requested.
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
  var path_589085 = newJObject()
  var query_589086 = newJObject()
  add(path_589085, "tableId", newJString(tableId))
  add(query_589086, "fields", newJString(fields))
  add(query_589086, "quotaUser", newJString(quotaUser))
  add(query_589086, "alt", newJString(alt))
  add(query_589086, "oauth_token", newJString(oauthToken))
  add(query_589086, "userIp", newJString(userIp))
  add(query_589086, "key", newJString(key))
  add(query_589086, "prettyPrint", newJBool(prettyPrint))
  result = call_589084.call(path_589085, query_589086, nil, nil, nil)

var fusiontablesTableGet* = Call_FusiontablesTableGet_589058(
    name: "fusiontablesTableGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableGet_589059, base: "/fusiontables/v1",
    url: url_FusiontablesTableGet_589060, schemes: {Scheme.Https})
type
  Call_FusiontablesTablePatch_589120 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTablePatch_589122(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTablePatch_589121(path: JsonNode; query: JsonNode;
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
  var valid_589123 = path.getOrDefault("tableId")
  valid_589123 = validateParameter(valid_589123, JString, required = true,
                                 default = nil)
  if valid_589123 != nil:
    section.add "tableId", valid_589123
  result.add "path", section
  ## parameters in `query` object:
  ##   replaceViewDefinition: JBool
  ##                        : Should the view definition also be updated? The specified view definition replaces the existing one. Only a view can be updated with a new definition.
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
  var valid_589124 = query.getOrDefault("replaceViewDefinition")
  valid_589124 = validateParameter(valid_589124, JBool, required = false, default = nil)
  if valid_589124 != nil:
    section.add "replaceViewDefinition", valid_589124
  var valid_589125 = query.getOrDefault("fields")
  valid_589125 = validateParameter(valid_589125, JString, required = false,
                                 default = nil)
  if valid_589125 != nil:
    section.add "fields", valid_589125
  var valid_589126 = query.getOrDefault("quotaUser")
  valid_589126 = validateParameter(valid_589126, JString, required = false,
                                 default = nil)
  if valid_589126 != nil:
    section.add "quotaUser", valid_589126
  var valid_589127 = query.getOrDefault("alt")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = newJString("json"))
  if valid_589127 != nil:
    section.add "alt", valid_589127
  var valid_589128 = query.getOrDefault("oauth_token")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "oauth_token", valid_589128
  var valid_589129 = query.getOrDefault("userIp")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = nil)
  if valid_589129 != nil:
    section.add "userIp", valid_589129
  var valid_589130 = query.getOrDefault("key")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "key", valid_589130
  var valid_589131 = query.getOrDefault("prettyPrint")
  valid_589131 = validateParameter(valid_589131, JBool, required = false,
                                 default = newJBool(true))
  if valid_589131 != nil:
    section.add "prettyPrint", valid_589131
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

proc call*(call_589133: Call_FusiontablesTablePatch_589120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated. This method supports patch semantics.
  ## 
  let valid = call_589133.validator(path, query, header, formData, body)
  let scheme = call_589133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589133.url(scheme.get, call_589133.host, call_589133.base,
                         call_589133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589133, url, valid)

proc call*(call_589134: Call_FusiontablesTablePatch_589120; tableId: string;
          replaceViewDefinition: bool = false; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTablePatch
  ## Updates an existing table. Unless explicitly requested, only the name, description, and attribution will be updated. This method supports patch semantics.
  ##   replaceViewDefinition: bool
  ##                        : Should the view definition also be updated? The specified view definition replaces the existing one. Only a view can be updated with a new definition.
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
  var path_589135 = newJObject()
  var query_589136 = newJObject()
  var body_589137 = newJObject()
  add(query_589136, "replaceViewDefinition", newJBool(replaceViewDefinition))
  add(path_589135, "tableId", newJString(tableId))
  add(query_589136, "fields", newJString(fields))
  add(query_589136, "quotaUser", newJString(quotaUser))
  add(query_589136, "alt", newJString(alt))
  add(query_589136, "oauth_token", newJString(oauthToken))
  add(query_589136, "userIp", newJString(userIp))
  add(query_589136, "key", newJString(key))
  if body != nil:
    body_589137 = body
  add(query_589136, "prettyPrint", newJBool(prettyPrint))
  result = call_589134.call(path_589135, query_589136, nil, nil, body_589137)

var fusiontablesTablePatch* = Call_FusiontablesTablePatch_589120(
    name: "fusiontablesTablePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTablePatch_589121, base: "/fusiontables/v1",
    url: url_FusiontablesTablePatch_589122, schemes: {Scheme.Https})
type
  Call_FusiontablesTableDelete_589105 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTableDelete_589107(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTableDelete_589106(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : ID of the table that is being deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589108 = path.getOrDefault("tableId")
  valid_589108 = validateParameter(valid_589108, JString, required = true,
                                 default = nil)
  if valid_589108 != nil:
    section.add "tableId", valid_589108
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
  var valid_589109 = query.getOrDefault("fields")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "fields", valid_589109
  var valid_589110 = query.getOrDefault("quotaUser")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "quotaUser", valid_589110
  var valid_589111 = query.getOrDefault("alt")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("json"))
  if valid_589111 != nil:
    section.add "alt", valid_589111
  var valid_589112 = query.getOrDefault("oauth_token")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "oauth_token", valid_589112
  var valid_589113 = query.getOrDefault("userIp")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "userIp", valid_589113
  var valid_589114 = query.getOrDefault("key")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "key", valid_589114
  var valid_589115 = query.getOrDefault("prettyPrint")
  valid_589115 = validateParameter(valid_589115, JBool, required = false,
                                 default = newJBool(true))
  if valid_589115 != nil:
    section.add "prettyPrint", valid_589115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589116: Call_FusiontablesTableDelete_589105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a table.
  ## 
  let valid = call_589116.validator(path, query, header, formData, body)
  let scheme = call_589116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589116.url(scheme.get, call_589116.host, call_589116.base,
                         call_589116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589116, url, valid)

proc call*(call_589117: Call_FusiontablesTableDelete_589105; tableId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## fusiontablesTableDelete
  ## Deletes a table.
  ##   tableId: string (required)
  ##          : ID of the table that is being deleted.
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
  var path_589118 = newJObject()
  var query_589119 = newJObject()
  add(path_589118, "tableId", newJString(tableId))
  add(query_589119, "fields", newJString(fields))
  add(query_589119, "quotaUser", newJString(quotaUser))
  add(query_589119, "alt", newJString(alt))
  add(query_589119, "oauth_token", newJString(oauthToken))
  add(query_589119, "userIp", newJString(userIp))
  add(query_589119, "key", newJString(key))
  add(query_589119, "prettyPrint", newJBool(prettyPrint))
  result = call_589117.call(path_589118, query_589119, nil, nil, nil)

var fusiontablesTableDelete* = Call_FusiontablesTableDelete_589105(
    name: "fusiontablesTableDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}",
    validator: validate_FusiontablesTableDelete_589106, base: "/fusiontables/v1",
    url: url_FusiontablesTableDelete_589107, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnInsert_589155 = ref object of OpenApiRestCall_588457
proc url_FusiontablesColumnInsert_589157(protocol: Scheme; host: string;
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

proc validate_FusiontablesColumnInsert_589156(path: JsonNode; query: JsonNode;
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
  var valid_589158 = path.getOrDefault("tableId")
  valid_589158 = validateParameter(valid_589158, JString, required = true,
                                 default = nil)
  if valid_589158 != nil:
    section.add "tableId", valid_589158
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
  var valid_589159 = query.getOrDefault("fields")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "fields", valid_589159
  var valid_589160 = query.getOrDefault("quotaUser")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = nil)
  if valid_589160 != nil:
    section.add "quotaUser", valid_589160
  var valid_589161 = query.getOrDefault("alt")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = newJString("json"))
  if valid_589161 != nil:
    section.add "alt", valid_589161
  var valid_589162 = query.getOrDefault("oauth_token")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "oauth_token", valid_589162
  var valid_589163 = query.getOrDefault("userIp")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "userIp", valid_589163
  var valid_589164 = query.getOrDefault("key")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "key", valid_589164
  var valid_589165 = query.getOrDefault("prettyPrint")
  valid_589165 = validateParameter(valid_589165, JBool, required = false,
                                 default = newJBool(true))
  if valid_589165 != nil:
    section.add "prettyPrint", valid_589165
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

proc call*(call_589167: Call_FusiontablesColumnInsert_589155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new column to the table.
  ## 
  let valid = call_589167.validator(path, query, header, formData, body)
  let scheme = call_589167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589167.url(scheme.get, call_589167.host, call_589167.base,
                         call_589167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589167, url, valid)

proc call*(call_589168: Call_FusiontablesColumnInsert_589155; tableId: string;
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
  var path_589169 = newJObject()
  var query_589170 = newJObject()
  var body_589171 = newJObject()
  add(path_589169, "tableId", newJString(tableId))
  add(query_589170, "fields", newJString(fields))
  add(query_589170, "quotaUser", newJString(quotaUser))
  add(query_589170, "alt", newJString(alt))
  add(query_589170, "oauth_token", newJString(oauthToken))
  add(query_589170, "userIp", newJString(userIp))
  add(query_589170, "key", newJString(key))
  if body != nil:
    body_589171 = body
  add(query_589170, "prettyPrint", newJBool(prettyPrint))
  result = call_589168.call(path_589169, query_589170, nil, nil, body_589171)

var fusiontablesColumnInsert* = Call_FusiontablesColumnInsert_589155(
    name: "fusiontablesColumnInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns",
    validator: validate_FusiontablesColumnInsert_589156, base: "/fusiontables/v1",
    url: url_FusiontablesColumnInsert_589157, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnList_589138 = ref object of OpenApiRestCall_588457
proc url_FusiontablesColumnList_589140(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesColumnList_589139(path: JsonNode; query: JsonNode;
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
  var valid_589141 = path.getOrDefault("tableId")
  valid_589141 = validateParameter(valid_589141, JString, required = true,
                                 default = nil)
  if valid_589141 != nil:
    section.add "tableId", valid_589141
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
  ##             : Maximum number of columns to return. Optional. Default is 5.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589142 = query.getOrDefault("fields")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "fields", valid_589142
  var valid_589143 = query.getOrDefault("pageToken")
  valid_589143 = validateParameter(valid_589143, JString, required = false,
                                 default = nil)
  if valid_589143 != nil:
    section.add "pageToken", valid_589143
  var valid_589144 = query.getOrDefault("quotaUser")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "quotaUser", valid_589144
  var valid_589145 = query.getOrDefault("alt")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = newJString("json"))
  if valid_589145 != nil:
    section.add "alt", valid_589145
  var valid_589146 = query.getOrDefault("oauth_token")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = nil)
  if valid_589146 != nil:
    section.add "oauth_token", valid_589146
  var valid_589147 = query.getOrDefault("userIp")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "userIp", valid_589147
  var valid_589148 = query.getOrDefault("maxResults")
  valid_589148 = validateParameter(valid_589148, JInt, required = false, default = nil)
  if valid_589148 != nil:
    section.add "maxResults", valid_589148
  var valid_589149 = query.getOrDefault("key")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "key", valid_589149
  var valid_589150 = query.getOrDefault("prettyPrint")
  valid_589150 = validateParameter(valid_589150, JBool, required = false,
                                 default = newJBool(true))
  if valid_589150 != nil:
    section.add "prettyPrint", valid_589150
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589151: Call_FusiontablesColumnList_589138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of columns.
  ## 
  let valid = call_589151.validator(path, query, header, formData, body)
  let scheme = call_589151.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589151.url(scheme.get, call_589151.host, call_589151.base,
                         call_589151.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589151, url, valid)

proc call*(call_589152: Call_FusiontablesColumnList_589138; tableId: string;
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
  ##             : Maximum number of columns to return. Optional. Default is 5.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589153 = newJObject()
  var query_589154 = newJObject()
  add(path_589153, "tableId", newJString(tableId))
  add(query_589154, "fields", newJString(fields))
  add(query_589154, "pageToken", newJString(pageToken))
  add(query_589154, "quotaUser", newJString(quotaUser))
  add(query_589154, "alt", newJString(alt))
  add(query_589154, "oauth_token", newJString(oauthToken))
  add(query_589154, "userIp", newJString(userIp))
  add(query_589154, "maxResults", newJInt(maxResults))
  add(query_589154, "key", newJString(key))
  add(query_589154, "prettyPrint", newJBool(prettyPrint))
  result = call_589152.call(path_589153, query_589154, nil, nil, nil)

var fusiontablesColumnList* = Call_FusiontablesColumnList_589138(
    name: "fusiontablesColumnList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns",
    validator: validate_FusiontablesColumnList_589139, base: "/fusiontables/v1",
    url: url_FusiontablesColumnList_589140, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnUpdate_589188 = ref object of OpenApiRestCall_588457
proc url_FusiontablesColumnUpdate_589190(protocol: Scheme; host: string;
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

proc validate_FusiontablesColumnUpdate_589189(path: JsonNode; query: JsonNode;
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
  var valid_589191 = path.getOrDefault("tableId")
  valid_589191 = validateParameter(valid_589191, JString, required = true,
                                 default = nil)
  if valid_589191 != nil:
    section.add "tableId", valid_589191
  var valid_589192 = path.getOrDefault("columnId")
  valid_589192 = validateParameter(valid_589192, JString, required = true,
                                 default = nil)
  if valid_589192 != nil:
    section.add "columnId", valid_589192
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
  var valid_589193 = query.getOrDefault("fields")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = nil)
  if valid_589193 != nil:
    section.add "fields", valid_589193
  var valid_589194 = query.getOrDefault("quotaUser")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "quotaUser", valid_589194
  var valid_589195 = query.getOrDefault("alt")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = newJString("json"))
  if valid_589195 != nil:
    section.add "alt", valid_589195
  var valid_589196 = query.getOrDefault("oauth_token")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "oauth_token", valid_589196
  var valid_589197 = query.getOrDefault("userIp")
  valid_589197 = validateParameter(valid_589197, JString, required = false,
                                 default = nil)
  if valid_589197 != nil:
    section.add "userIp", valid_589197
  var valid_589198 = query.getOrDefault("key")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "key", valid_589198
  var valid_589199 = query.getOrDefault("prettyPrint")
  valid_589199 = validateParameter(valid_589199, JBool, required = false,
                                 default = newJBool(true))
  if valid_589199 != nil:
    section.add "prettyPrint", valid_589199
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

proc call*(call_589201: Call_FusiontablesColumnUpdate_589188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or type of an existing column.
  ## 
  let valid = call_589201.validator(path, query, header, formData, body)
  let scheme = call_589201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589201.url(scheme.get, call_589201.host, call_589201.base,
                         call_589201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589201, url, valid)

proc call*(call_589202: Call_FusiontablesColumnUpdate_589188; tableId: string;
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
  var path_589203 = newJObject()
  var query_589204 = newJObject()
  var body_589205 = newJObject()
  add(path_589203, "tableId", newJString(tableId))
  add(query_589204, "fields", newJString(fields))
  add(query_589204, "quotaUser", newJString(quotaUser))
  add(query_589204, "alt", newJString(alt))
  add(query_589204, "oauth_token", newJString(oauthToken))
  add(query_589204, "userIp", newJString(userIp))
  add(query_589204, "key", newJString(key))
  add(path_589203, "columnId", newJString(columnId))
  if body != nil:
    body_589205 = body
  add(query_589204, "prettyPrint", newJBool(prettyPrint))
  result = call_589202.call(path_589203, query_589204, nil, nil, body_589205)

var fusiontablesColumnUpdate* = Call_FusiontablesColumnUpdate_589188(
    name: "fusiontablesColumnUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnUpdate_589189, base: "/fusiontables/v1",
    url: url_FusiontablesColumnUpdate_589190, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnGet_589172 = ref object of OpenApiRestCall_588457
proc url_FusiontablesColumnGet_589174(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesColumnGet_589173(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a specific column by its id.
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
  var valid_589175 = path.getOrDefault("tableId")
  valid_589175 = validateParameter(valid_589175, JString, required = true,
                                 default = nil)
  if valid_589175 != nil:
    section.add "tableId", valid_589175
  var valid_589176 = path.getOrDefault("columnId")
  valid_589176 = validateParameter(valid_589176, JString, required = true,
                                 default = nil)
  if valid_589176 != nil:
    section.add "columnId", valid_589176
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
  var valid_589177 = query.getOrDefault("fields")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = nil)
  if valid_589177 != nil:
    section.add "fields", valid_589177
  var valid_589178 = query.getOrDefault("quotaUser")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "quotaUser", valid_589178
  var valid_589179 = query.getOrDefault("alt")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = newJString("json"))
  if valid_589179 != nil:
    section.add "alt", valid_589179
  var valid_589180 = query.getOrDefault("oauth_token")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "oauth_token", valid_589180
  var valid_589181 = query.getOrDefault("userIp")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "userIp", valid_589181
  var valid_589182 = query.getOrDefault("key")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "key", valid_589182
  var valid_589183 = query.getOrDefault("prettyPrint")
  valid_589183 = validateParameter(valid_589183, JBool, required = false,
                                 default = newJBool(true))
  if valid_589183 != nil:
    section.add "prettyPrint", valid_589183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589184: Call_FusiontablesColumnGet_589172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific column by its id.
  ## 
  let valid = call_589184.validator(path, query, header, formData, body)
  let scheme = call_589184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589184.url(scheme.get, call_589184.host, call_589184.base,
                         call_589184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589184, url, valid)

proc call*(call_589185: Call_FusiontablesColumnGet_589172; tableId: string;
          columnId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesColumnGet
  ## Retrieves a specific column by its id.
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
  var path_589186 = newJObject()
  var query_589187 = newJObject()
  add(path_589186, "tableId", newJString(tableId))
  add(query_589187, "fields", newJString(fields))
  add(query_589187, "quotaUser", newJString(quotaUser))
  add(query_589187, "alt", newJString(alt))
  add(query_589187, "oauth_token", newJString(oauthToken))
  add(query_589187, "userIp", newJString(userIp))
  add(query_589187, "key", newJString(key))
  add(path_589186, "columnId", newJString(columnId))
  add(query_589187, "prettyPrint", newJBool(prettyPrint))
  result = call_589185.call(path_589186, query_589187, nil, nil, nil)

var fusiontablesColumnGet* = Call_FusiontablesColumnGet_589172(
    name: "fusiontablesColumnGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnGet_589173, base: "/fusiontables/v1",
    url: url_FusiontablesColumnGet_589174, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnPatch_589222 = ref object of OpenApiRestCall_588457
proc url_FusiontablesColumnPatch_589224(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesColumnPatch_589223(path: JsonNode; query: JsonNode;
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
  var valid_589225 = path.getOrDefault("tableId")
  valid_589225 = validateParameter(valid_589225, JString, required = true,
                                 default = nil)
  if valid_589225 != nil:
    section.add "tableId", valid_589225
  var valid_589226 = path.getOrDefault("columnId")
  valid_589226 = validateParameter(valid_589226, JString, required = true,
                                 default = nil)
  if valid_589226 != nil:
    section.add "columnId", valid_589226
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
  var valid_589227 = query.getOrDefault("fields")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = nil)
  if valid_589227 != nil:
    section.add "fields", valid_589227
  var valid_589228 = query.getOrDefault("quotaUser")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "quotaUser", valid_589228
  var valid_589229 = query.getOrDefault("alt")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = newJString("json"))
  if valid_589229 != nil:
    section.add "alt", valid_589229
  var valid_589230 = query.getOrDefault("oauth_token")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "oauth_token", valid_589230
  var valid_589231 = query.getOrDefault("userIp")
  valid_589231 = validateParameter(valid_589231, JString, required = false,
                                 default = nil)
  if valid_589231 != nil:
    section.add "userIp", valid_589231
  var valid_589232 = query.getOrDefault("key")
  valid_589232 = validateParameter(valid_589232, JString, required = false,
                                 default = nil)
  if valid_589232 != nil:
    section.add "key", valid_589232
  var valid_589233 = query.getOrDefault("prettyPrint")
  valid_589233 = validateParameter(valid_589233, JBool, required = false,
                                 default = newJBool(true))
  if valid_589233 != nil:
    section.add "prettyPrint", valid_589233
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

proc call*(call_589235: Call_FusiontablesColumnPatch_589222; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the name or type of an existing column. This method supports patch semantics.
  ## 
  let valid = call_589235.validator(path, query, header, formData, body)
  let scheme = call_589235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589235.url(scheme.get, call_589235.host, call_589235.base,
                         call_589235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589235, url, valid)

proc call*(call_589236: Call_FusiontablesColumnPatch_589222; tableId: string;
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
  var path_589237 = newJObject()
  var query_589238 = newJObject()
  var body_589239 = newJObject()
  add(path_589237, "tableId", newJString(tableId))
  add(query_589238, "fields", newJString(fields))
  add(query_589238, "quotaUser", newJString(quotaUser))
  add(query_589238, "alt", newJString(alt))
  add(query_589238, "oauth_token", newJString(oauthToken))
  add(query_589238, "userIp", newJString(userIp))
  add(query_589238, "key", newJString(key))
  add(path_589237, "columnId", newJString(columnId))
  if body != nil:
    body_589239 = body
  add(query_589238, "prettyPrint", newJBool(prettyPrint))
  result = call_589236.call(path_589237, query_589238, nil, nil, body_589239)

var fusiontablesColumnPatch* = Call_FusiontablesColumnPatch_589222(
    name: "fusiontablesColumnPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnPatch_589223, base: "/fusiontables/v1",
    url: url_FusiontablesColumnPatch_589224, schemes: {Scheme.Https})
type
  Call_FusiontablesColumnDelete_589206 = ref object of OpenApiRestCall_588457
proc url_FusiontablesColumnDelete_589208(protocol: Scheme; host: string;
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

proc validate_FusiontablesColumnDelete_589207(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the column.
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
  var valid_589209 = path.getOrDefault("tableId")
  valid_589209 = validateParameter(valid_589209, JString, required = true,
                                 default = nil)
  if valid_589209 != nil:
    section.add "tableId", valid_589209
  var valid_589210 = path.getOrDefault("columnId")
  valid_589210 = validateParameter(valid_589210, JString, required = true,
                                 default = nil)
  if valid_589210 != nil:
    section.add "columnId", valid_589210
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
  var valid_589211 = query.getOrDefault("fields")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = nil)
  if valid_589211 != nil:
    section.add "fields", valid_589211
  var valid_589212 = query.getOrDefault("quotaUser")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = nil)
  if valid_589212 != nil:
    section.add "quotaUser", valid_589212
  var valid_589213 = query.getOrDefault("alt")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = newJString("json"))
  if valid_589213 != nil:
    section.add "alt", valid_589213
  var valid_589214 = query.getOrDefault("oauth_token")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "oauth_token", valid_589214
  var valid_589215 = query.getOrDefault("userIp")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "userIp", valid_589215
  var valid_589216 = query.getOrDefault("key")
  valid_589216 = validateParameter(valid_589216, JString, required = false,
                                 default = nil)
  if valid_589216 != nil:
    section.add "key", valid_589216
  var valid_589217 = query.getOrDefault("prettyPrint")
  valid_589217 = validateParameter(valid_589217, JBool, required = false,
                                 default = newJBool(true))
  if valid_589217 != nil:
    section.add "prettyPrint", valid_589217
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589218: Call_FusiontablesColumnDelete_589206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the column.
  ## 
  let valid = call_589218.validator(path, query, header, formData, body)
  let scheme = call_589218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589218.url(scheme.get, call_589218.host, call_589218.base,
                         call_589218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589218, url, valid)

proc call*(call_589219: Call_FusiontablesColumnDelete_589206; tableId: string;
          columnId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesColumnDelete
  ## Deletes the column.
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
  var path_589220 = newJObject()
  var query_589221 = newJObject()
  add(path_589220, "tableId", newJString(tableId))
  add(query_589221, "fields", newJString(fields))
  add(query_589221, "quotaUser", newJString(quotaUser))
  add(query_589221, "alt", newJString(alt))
  add(query_589221, "oauth_token", newJString(oauthToken))
  add(query_589221, "userIp", newJString(userIp))
  add(query_589221, "key", newJString(key))
  add(path_589220, "columnId", newJString(columnId))
  add(query_589221, "prettyPrint", newJBool(prettyPrint))
  result = call_589219.call(path_589220, query_589221, nil, nil, nil)

var fusiontablesColumnDelete* = Call_FusiontablesColumnDelete_589206(
    name: "fusiontablesColumnDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/columns/{columnId}",
    validator: validate_FusiontablesColumnDelete_589207, base: "/fusiontables/v1",
    url: url_FusiontablesColumnDelete_589208, schemes: {Scheme.Https})
type
  Call_FusiontablesTableCopy_589240 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTableCopy_589242(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTableCopy_589241(path: JsonNode; query: JsonNode;
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
  var valid_589243 = path.getOrDefault("tableId")
  valid_589243 = validateParameter(valid_589243, JString, required = true,
                                 default = nil)
  if valid_589243 != nil:
    section.add "tableId", valid_589243
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
  var valid_589244 = query.getOrDefault("fields")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "fields", valid_589244
  var valid_589245 = query.getOrDefault("quotaUser")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "quotaUser", valid_589245
  var valid_589246 = query.getOrDefault("alt")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = newJString("json"))
  if valid_589246 != nil:
    section.add "alt", valid_589246
  var valid_589247 = query.getOrDefault("oauth_token")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "oauth_token", valid_589247
  var valid_589248 = query.getOrDefault("userIp")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "userIp", valid_589248
  var valid_589249 = query.getOrDefault("key")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "key", valid_589249
  var valid_589250 = query.getOrDefault("copyPresentation")
  valid_589250 = validateParameter(valid_589250, JBool, required = false, default = nil)
  if valid_589250 != nil:
    section.add "copyPresentation", valid_589250
  var valid_589251 = query.getOrDefault("prettyPrint")
  valid_589251 = validateParameter(valid_589251, JBool, required = false,
                                 default = newJBool(true))
  if valid_589251 != nil:
    section.add "prettyPrint", valid_589251
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589252: Call_FusiontablesTableCopy_589240; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a table.
  ## 
  let valid = call_589252.validator(path, query, header, formData, body)
  let scheme = call_589252.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589252.url(scheme.get, call_589252.host, call_589252.base,
                         call_589252.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589252, url, valid)

proc call*(call_589253: Call_FusiontablesTableCopy_589240; tableId: string;
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
  var path_589254 = newJObject()
  var query_589255 = newJObject()
  add(path_589254, "tableId", newJString(tableId))
  add(query_589255, "fields", newJString(fields))
  add(query_589255, "quotaUser", newJString(quotaUser))
  add(query_589255, "alt", newJString(alt))
  add(query_589255, "oauth_token", newJString(oauthToken))
  add(query_589255, "userIp", newJString(userIp))
  add(query_589255, "key", newJString(key))
  add(query_589255, "copyPresentation", newJBool(copyPresentation))
  add(query_589255, "prettyPrint", newJBool(prettyPrint))
  result = call_589253.call(path_589254, query_589255, nil, nil, nil)

var fusiontablesTableCopy* = Call_FusiontablesTableCopy_589240(
    name: "fusiontablesTableCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/copy",
    validator: validate_FusiontablesTableCopy_589241, base: "/fusiontables/v1",
    url: url_FusiontablesTableCopy_589242, schemes: {Scheme.Https})
type
  Call_FusiontablesTableImportRows_589256 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTableImportRows_589258(protocol: Scheme; host: string;
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

proc validate_FusiontablesTableImportRows_589257(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Import more rows into a table.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : The table into which new rows are being imported.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589259 = path.getOrDefault("tableId")
  valid_589259 = validateParameter(valid_589259, JString, required = true,
                                 default = nil)
  if valid_589259 != nil:
    section.add "tableId", valid_589259
  result.add "path", section
  ## parameters in `query` object:
  ##   endLine: JInt
  ##          : The index of the last line from which to start importing, exclusive. Thus, the number of imported lines is endLine - startLine. If this parameter is not provided, the file will be imported until the last line of the file. If endLine is negative, then the imported content will exclude the last endLine lines. That is, if endline is negative, no line will be imported whose index is greater than N + endLine where N is the number of lines in the file, and the number of imported lines will be N + endLine - startLine.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   isStrict: JBool
  ##           : Whether the CSV must have the same number of values for each row. If false, rows with fewer values will be padded with empty values. Default is true.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   delimiter: JString
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ','.
  ##   encoding: JString
  ##           : The encoding of the content. Default is UTF-8. Use 'auto-detect' if you are unsure of the encoding.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startLine: JInt
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  section = newJObject()
  var valid_589260 = query.getOrDefault("endLine")
  valid_589260 = validateParameter(valid_589260, JInt, required = false, default = nil)
  if valid_589260 != nil:
    section.add "endLine", valid_589260
  var valid_589261 = query.getOrDefault("fields")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "fields", valid_589261
  var valid_589262 = query.getOrDefault("quotaUser")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "quotaUser", valid_589262
  var valid_589263 = query.getOrDefault("alt")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = newJString("json"))
  if valid_589263 != nil:
    section.add "alt", valid_589263
  var valid_589264 = query.getOrDefault("isStrict")
  valid_589264 = validateParameter(valid_589264, JBool, required = false, default = nil)
  if valid_589264 != nil:
    section.add "isStrict", valid_589264
  var valid_589265 = query.getOrDefault("oauth_token")
  valid_589265 = validateParameter(valid_589265, JString, required = false,
                                 default = nil)
  if valid_589265 != nil:
    section.add "oauth_token", valid_589265
  var valid_589266 = query.getOrDefault("userIp")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "userIp", valid_589266
  var valid_589267 = query.getOrDefault("key")
  valid_589267 = validateParameter(valid_589267, JString, required = false,
                                 default = nil)
  if valid_589267 != nil:
    section.add "key", valid_589267
  var valid_589268 = query.getOrDefault("delimiter")
  valid_589268 = validateParameter(valid_589268, JString, required = false,
                                 default = nil)
  if valid_589268 != nil:
    section.add "delimiter", valid_589268
  var valid_589269 = query.getOrDefault("encoding")
  valid_589269 = validateParameter(valid_589269, JString, required = false,
                                 default = nil)
  if valid_589269 != nil:
    section.add "encoding", valid_589269
  var valid_589270 = query.getOrDefault("prettyPrint")
  valid_589270 = validateParameter(valid_589270, JBool, required = false,
                                 default = newJBool(true))
  if valid_589270 != nil:
    section.add "prettyPrint", valid_589270
  var valid_589271 = query.getOrDefault("startLine")
  valid_589271 = validateParameter(valid_589271, JInt, required = false, default = nil)
  if valid_589271 != nil:
    section.add "startLine", valid_589271
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589272: Call_FusiontablesTableImportRows_589256; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Import more rows into a table.
  ## 
  let valid = call_589272.validator(path, query, header, formData, body)
  let scheme = call_589272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589272.url(scheme.get, call_589272.host, call_589272.base,
                         call_589272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589272, url, valid)

proc call*(call_589273: Call_FusiontablesTableImportRows_589256; tableId: string;
          endLine: int = 0; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; isStrict: bool = false; oauthToken: string = "";
          userIp: string = ""; key: string = ""; delimiter: string = "";
          encoding: string = ""; prettyPrint: bool = true; startLine: int = 0): Recallable =
  ## fusiontablesTableImportRows
  ## Import more rows into a table.
  ##   endLine: int
  ##          : The index of the last line from which to start importing, exclusive. Thus, the number of imported lines is endLine - startLine. If this parameter is not provided, the file will be imported until the last line of the file. If endLine is negative, then the imported content will exclude the last endLine lines. That is, if endline is negative, no line will be imported whose index is greater than N + endLine where N is the number of lines in the file, and the number of imported lines will be N + endLine - startLine.
  ##   tableId: string (required)
  ##          : The table into which new rows are being imported.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   isStrict: bool
  ##           : Whether the CSV must have the same number of values for each row. If false, rows with fewer values will be padded with empty values. Default is true.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   delimiter: string
  ##            : The delimiter used to separate cell values. This can only consist of a single character. Default is ','.
  ##   encoding: string
  ##           : The encoding of the content. Default is UTF-8. Use 'auto-detect' if you are unsure of the encoding.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startLine: int
  ##            : The index of the first line from which to start importing, inclusive. Default is 0.
  var path_589274 = newJObject()
  var query_589275 = newJObject()
  add(query_589275, "endLine", newJInt(endLine))
  add(path_589274, "tableId", newJString(tableId))
  add(query_589275, "fields", newJString(fields))
  add(query_589275, "quotaUser", newJString(quotaUser))
  add(query_589275, "alt", newJString(alt))
  add(query_589275, "isStrict", newJBool(isStrict))
  add(query_589275, "oauth_token", newJString(oauthToken))
  add(query_589275, "userIp", newJString(userIp))
  add(query_589275, "key", newJString(key))
  add(query_589275, "delimiter", newJString(delimiter))
  add(query_589275, "encoding", newJString(encoding))
  add(query_589275, "prettyPrint", newJBool(prettyPrint))
  add(query_589275, "startLine", newJInt(startLine))
  result = call_589273.call(path_589274, query_589275, nil, nil, nil)

var fusiontablesTableImportRows* = Call_FusiontablesTableImportRows_589256(
    name: "fusiontablesTableImportRows", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/import",
    validator: validate_FusiontablesTableImportRows_589257,
    base: "/fusiontables/v1", url: url_FusiontablesTableImportRows_589258,
    schemes: {Scheme.Https})
type
  Call_FusiontablesStyleInsert_589293 = ref object of OpenApiRestCall_588457
proc url_FusiontablesStyleInsert_589295(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleInsert_589294(path: JsonNode; query: JsonNode;
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
  var valid_589296 = path.getOrDefault("tableId")
  valid_589296 = validateParameter(valid_589296, JString, required = true,
                                 default = nil)
  if valid_589296 != nil:
    section.add "tableId", valid_589296
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
  var valid_589297 = query.getOrDefault("fields")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "fields", valid_589297
  var valid_589298 = query.getOrDefault("quotaUser")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "quotaUser", valid_589298
  var valid_589299 = query.getOrDefault("alt")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = newJString("json"))
  if valid_589299 != nil:
    section.add "alt", valid_589299
  var valid_589300 = query.getOrDefault("oauth_token")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "oauth_token", valid_589300
  var valid_589301 = query.getOrDefault("userIp")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "userIp", valid_589301
  var valid_589302 = query.getOrDefault("key")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "key", valid_589302
  var valid_589303 = query.getOrDefault("prettyPrint")
  valid_589303 = validateParameter(valid_589303, JBool, required = false,
                                 default = newJBool(true))
  if valid_589303 != nil:
    section.add "prettyPrint", valid_589303
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

proc call*(call_589305: Call_FusiontablesStyleInsert_589293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Adds a new style for the table.
  ## 
  let valid = call_589305.validator(path, query, header, formData, body)
  let scheme = call_589305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589305.url(scheme.get, call_589305.host, call_589305.base,
                         call_589305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589305, url, valid)

proc call*(call_589306: Call_FusiontablesStyleInsert_589293; tableId: string;
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
  var path_589307 = newJObject()
  var query_589308 = newJObject()
  var body_589309 = newJObject()
  add(path_589307, "tableId", newJString(tableId))
  add(query_589308, "fields", newJString(fields))
  add(query_589308, "quotaUser", newJString(quotaUser))
  add(query_589308, "alt", newJString(alt))
  add(query_589308, "oauth_token", newJString(oauthToken))
  add(query_589308, "userIp", newJString(userIp))
  add(query_589308, "key", newJString(key))
  if body != nil:
    body_589309 = body
  add(query_589308, "prettyPrint", newJBool(prettyPrint))
  result = call_589306.call(path_589307, query_589308, nil, nil, body_589309)

var fusiontablesStyleInsert* = Call_FusiontablesStyleInsert_589293(
    name: "fusiontablesStyleInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles",
    validator: validate_FusiontablesStyleInsert_589294, base: "/fusiontables/v1",
    url: url_FusiontablesStyleInsert_589295, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleList_589276 = ref object of OpenApiRestCall_588457
proc url_FusiontablesStyleList_589278(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleList_589277(path: JsonNode; query: JsonNode;
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
  var valid_589279 = path.getOrDefault("tableId")
  valid_589279 = validateParameter(valid_589279, JString, required = true,
                                 default = nil)
  if valid_589279 != nil:
    section.add "tableId", valid_589279
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
  var valid_589280 = query.getOrDefault("fields")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "fields", valid_589280
  var valid_589281 = query.getOrDefault("pageToken")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "pageToken", valid_589281
  var valid_589282 = query.getOrDefault("quotaUser")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "quotaUser", valid_589282
  var valid_589283 = query.getOrDefault("alt")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = newJString("json"))
  if valid_589283 != nil:
    section.add "alt", valid_589283
  var valid_589284 = query.getOrDefault("oauth_token")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "oauth_token", valid_589284
  var valid_589285 = query.getOrDefault("userIp")
  valid_589285 = validateParameter(valid_589285, JString, required = false,
                                 default = nil)
  if valid_589285 != nil:
    section.add "userIp", valid_589285
  var valid_589286 = query.getOrDefault("maxResults")
  valid_589286 = validateParameter(valid_589286, JInt, required = false, default = nil)
  if valid_589286 != nil:
    section.add "maxResults", valid_589286
  var valid_589287 = query.getOrDefault("key")
  valid_589287 = validateParameter(valid_589287, JString, required = false,
                                 default = nil)
  if valid_589287 != nil:
    section.add "key", valid_589287
  var valid_589288 = query.getOrDefault("prettyPrint")
  valid_589288 = validateParameter(valid_589288, JBool, required = false,
                                 default = newJBool(true))
  if valid_589288 != nil:
    section.add "prettyPrint", valid_589288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589289: Call_FusiontablesStyleList_589276; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of styles.
  ## 
  let valid = call_589289.validator(path, query, header, formData, body)
  let scheme = call_589289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589289.url(scheme.get, call_589289.host, call_589289.base,
                         call_589289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589289, url, valid)

proc call*(call_589290: Call_FusiontablesStyleList_589276; tableId: string;
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
  var path_589291 = newJObject()
  var query_589292 = newJObject()
  add(path_589291, "tableId", newJString(tableId))
  add(query_589292, "fields", newJString(fields))
  add(query_589292, "pageToken", newJString(pageToken))
  add(query_589292, "quotaUser", newJString(quotaUser))
  add(query_589292, "alt", newJString(alt))
  add(query_589292, "oauth_token", newJString(oauthToken))
  add(query_589292, "userIp", newJString(userIp))
  add(query_589292, "maxResults", newJInt(maxResults))
  add(query_589292, "key", newJString(key))
  add(query_589292, "prettyPrint", newJBool(prettyPrint))
  result = call_589290.call(path_589291, query_589292, nil, nil, nil)

var fusiontablesStyleList* = Call_FusiontablesStyleList_589276(
    name: "fusiontablesStyleList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles",
    validator: validate_FusiontablesStyleList_589277, base: "/fusiontables/v1",
    url: url_FusiontablesStyleList_589278, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleUpdate_589326 = ref object of OpenApiRestCall_588457
proc url_FusiontablesStyleUpdate_589328(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleUpdate_589327(path: JsonNode; query: JsonNode;
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
  var valid_589329 = path.getOrDefault("tableId")
  valid_589329 = validateParameter(valid_589329, JString, required = true,
                                 default = nil)
  if valid_589329 != nil:
    section.add "tableId", valid_589329
  var valid_589330 = path.getOrDefault("styleId")
  valid_589330 = validateParameter(valid_589330, JInt, required = true, default = nil)
  if valid_589330 != nil:
    section.add "styleId", valid_589330
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
  var valid_589331 = query.getOrDefault("fields")
  valid_589331 = validateParameter(valid_589331, JString, required = false,
                                 default = nil)
  if valid_589331 != nil:
    section.add "fields", valid_589331
  var valid_589332 = query.getOrDefault("quotaUser")
  valid_589332 = validateParameter(valid_589332, JString, required = false,
                                 default = nil)
  if valid_589332 != nil:
    section.add "quotaUser", valid_589332
  var valid_589333 = query.getOrDefault("alt")
  valid_589333 = validateParameter(valid_589333, JString, required = false,
                                 default = newJString("json"))
  if valid_589333 != nil:
    section.add "alt", valid_589333
  var valid_589334 = query.getOrDefault("oauth_token")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "oauth_token", valid_589334
  var valid_589335 = query.getOrDefault("userIp")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "userIp", valid_589335
  var valid_589336 = query.getOrDefault("key")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = nil)
  if valid_589336 != nil:
    section.add "key", valid_589336
  var valid_589337 = query.getOrDefault("prettyPrint")
  valid_589337 = validateParameter(valid_589337, JBool, required = false,
                                 default = newJBool(true))
  if valid_589337 != nil:
    section.add "prettyPrint", valid_589337
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

proc call*(call_589339: Call_FusiontablesStyleUpdate_589326; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing style.
  ## 
  let valid = call_589339.validator(path, query, header, formData, body)
  let scheme = call_589339.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589339.url(scheme.get, call_589339.host, call_589339.base,
                         call_589339.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589339, url, valid)

proc call*(call_589340: Call_FusiontablesStyleUpdate_589326; tableId: string;
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
  var path_589341 = newJObject()
  var query_589342 = newJObject()
  var body_589343 = newJObject()
  add(path_589341, "tableId", newJString(tableId))
  add(query_589342, "fields", newJString(fields))
  add(query_589342, "quotaUser", newJString(quotaUser))
  add(query_589342, "alt", newJString(alt))
  add(query_589342, "oauth_token", newJString(oauthToken))
  add(query_589342, "userIp", newJString(userIp))
  add(path_589341, "styleId", newJInt(styleId))
  add(query_589342, "key", newJString(key))
  if body != nil:
    body_589343 = body
  add(query_589342, "prettyPrint", newJBool(prettyPrint))
  result = call_589340.call(path_589341, query_589342, nil, nil, body_589343)

var fusiontablesStyleUpdate* = Call_FusiontablesStyleUpdate_589326(
    name: "fusiontablesStyleUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleUpdate_589327, base: "/fusiontables/v1",
    url: url_FusiontablesStyleUpdate_589328, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleGet_589310 = ref object of OpenApiRestCall_588457
proc url_FusiontablesStyleGet_589312(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleGet_589311(path: JsonNode; query: JsonNode;
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
  var valid_589313 = path.getOrDefault("tableId")
  valid_589313 = validateParameter(valid_589313, JString, required = true,
                                 default = nil)
  if valid_589313 != nil:
    section.add "tableId", valid_589313
  var valid_589314 = path.getOrDefault("styleId")
  valid_589314 = validateParameter(valid_589314, JInt, required = true, default = nil)
  if valid_589314 != nil:
    section.add "styleId", valid_589314
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
  var valid_589315 = query.getOrDefault("fields")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "fields", valid_589315
  var valid_589316 = query.getOrDefault("quotaUser")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "quotaUser", valid_589316
  var valid_589317 = query.getOrDefault("alt")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = newJString("json"))
  if valid_589317 != nil:
    section.add "alt", valid_589317
  var valid_589318 = query.getOrDefault("oauth_token")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = nil)
  if valid_589318 != nil:
    section.add "oauth_token", valid_589318
  var valid_589319 = query.getOrDefault("userIp")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "userIp", valid_589319
  var valid_589320 = query.getOrDefault("key")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "key", valid_589320
  var valid_589321 = query.getOrDefault("prettyPrint")
  valid_589321 = validateParameter(valid_589321, JBool, required = false,
                                 default = newJBool(true))
  if valid_589321 != nil:
    section.add "prettyPrint", valid_589321
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589322: Call_FusiontablesStyleGet_589310; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets a specific style.
  ## 
  let valid = call_589322.validator(path, query, header, formData, body)
  let scheme = call_589322.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589322.url(scheme.get, call_589322.host, call_589322.base,
                         call_589322.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589322, url, valid)

proc call*(call_589323: Call_FusiontablesStyleGet_589310; tableId: string;
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
  var path_589324 = newJObject()
  var query_589325 = newJObject()
  add(path_589324, "tableId", newJString(tableId))
  add(query_589325, "fields", newJString(fields))
  add(query_589325, "quotaUser", newJString(quotaUser))
  add(query_589325, "alt", newJString(alt))
  add(query_589325, "oauth_token", newJString(oauthToken))
  add(query_589325, "userIp", newJString(userIp))
  add(path_589324, "styleId", newJInt(styleId))
  add(query_589325, "key", newJString(key))
  add(query_589325, "prettyPrint", newJBool(prettyPrint))
  result = call_589323.call(path_589324, query_589325, nil, nil, nil)

var fusiontablesStyleGet* = Call_FusiontablesStyleGet_589310(
    name: "fusiontablesStyleGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleGet_589311, base: "/fusiontables/v1",
    url: url_FusiontablesStyleGet_589312, schemes: {Scheme.Https})
type
  Call_FusiontablesStylePatch_589360 = ref object of OpenApiRestCall_588457
proc url_FusiontablesStylePatch_589362(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStylePatch_589361(path: JsonNode; query: JsonNode;
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
  var valid_589363 = path.getOrDefault("tableId")
  valid_589363 = validateParameter(valid_589363, JString, required = true,
                                 default = nil)
  if valid_589363 != nil:
    section.add "tableId", valid_589363
  var valid_589364 = path.getOrDefault("styleId")
  valid_589364 = validateParameter(valid_589364, JInt, required = true, default = nil)
  if valid_589364 != nil:
    section.add "styleId", valid_589364
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
  var valid_589365 = query.getOrDefault("fields")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "fields", valid_589365
  var valid_589366 = query.getOrDefault("quotaUser")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "quotaUser", valid_589366
  var valid_589367 = query.getOrDefault("alt")
  valid_589367 = validateParameter(valid_589367, JString, required = false,
                                 default = newJString("json"))
  if valid_589367 != nil:
    section.add "alt", valid_589367
  var valid_589368 = query.getOrDefault("oauth_token")
  valid_589368 = validateParameter(valid_589368, JString, required = false,
                                 default = nil)
  if valid_589368 != nil:
    section.add "oauth_token", valid_589368
  var valid_589369 = query.getOrDefault("userIp")
  valid_589369 = validateParameter(valid_589369, JString, required = false,
                                 default = nil)
  if valid_589369 != nil:
    section.add "userIp", valid_589369
  var valid_589370 = query.getOrDefault("key")
  valid_589370 = validateParameter(valid_589370, JString, required = false,
                                 default = nil)
  if valid_589370 != nil:
    section.add "key", valid_589370
  var valid_589371 = query.getOrDefault("prettyPrint")
  valid_589371 = validateParameter(valid_589371, JBool, required = false,
                                 default = newJBool(true))
  if valid_589371 != nil:
    section.add "prettyPrint", valid_589371
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

proc call*(call_589373: Call_FusiontablesStylePatch_589360; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing style. This method supports patch semantics.
  ## 
  let valid = call_589373.validator(path, query, header, formData, body)
  let scheme = call_589373.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589373.url(scheme.get, call_589373.host, call_589373.base,
                         call_589373.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589373, url, valid)

proc call*(call_589374: Call_FusiontablesStylePatch_589360; tableId: string;
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
  var path_589375 = newJObject()
  var query_589376 = newJObject()
  var body_589377 = newJObject()
  add(path_589375, "tableId", newJString(tableId))
  add(query_589376, "fields", newJString(fields))
  add(query_589376, "quotaUser", newJString(quotaUser))
  add(query_589376, "alt", newJString(alt))
  add(query_589376, "oauth_token", newJString(oauthToken))
  add(query_589376, "userIp", newJString(userIp))
  add(path_589375, "styleId", newJInt(styleId))
  add(query_589376, "key", newJString(key))
  if body != nil:
    body_589377 = body
  add(query_589376, "prettyPrint", newJBool(prettyPrint))
  result = call_589374.call(path_589375, query_589376, nil, nil, body_589377)

var fusiontablesStylePatch* = Call_FusiontablesStylePatch_589360(
    name: "fusiontablesStylePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStylePatch_589361, base: "/fusiontables/v1",
    url: url_FusiontablesStylePatch_589362, schemes: {Scheme.Https})
type
  Call_FusiontablesStyleDelete_589344 = ref object of OpenApiRestCall_588457
proc url_FusiontablesStyleDelete_589346(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesStyleDelete_589345(path: JsonNode; query: JsonNode;
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
  var valid_589347 = path.getOrDefault("tableId")
  valid_589347 = validateParameter(valid_589347, JString, required = true,
                                 default = nil)
  if valid_589347 != nil:
    section.add "tableId", valid_589347
  var valid_589348 = path.getOrDefault("styleId")
  valid_589348 = validateParameter(valid_589348, JInt, required = true, default = nil)
  if valid_589348 != nil:
    section.add "styleId", valid_589348
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
  var valid_589349 = query.getOrDefault("fields")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "fields", valid_589349
  var valid_589350 = query.getOrDefault("quotaUser")
  valid_589350 = validateParameter(valid_589350, JString, required = false,
                                 default = nil)
  if valid_589350 != nil:
    section.add "quotaUser", valid_589350
  var valid_589351 = query.getOrDefault("alt")
  valid_589351 = validateParameter(valid_589351, JString, required = false,
                                 default = newJString("json"))
  if valid_589351 != nil:
    section.add "alt", valid_589351
  var valid_589352 = query.getOrDefault("oauth_token")
  valid_589352 = validateParameter(valid_589352, JString, required = false,
                                 default = nil)
  if valid_589352 != nil:
    section.add "oauth_token", valid_589352
  var valid_589353 = query.getOrDefault("userIp")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "userIp", valid_589353
  var valid_589354 = query.getOrDefault("key")
  valid_589354 = validateParameter(valid_589354, JString, required = false,
                                 default = nil)
  if valid_589354 != nil:
    section.add "key", valid_589354
  var valid_589355 = query.getOrDefault("prettyPrint")
  valid_589355 = validateParameter(valid_589355, JBool, required = false,
                                 default = newJBool(true))
  if valid_589355 != nil:
    section.add "prettyPrint", valid_589355
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589356: Call_FusiontablesStyleDelete_589344; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a style.
  ## 
  let valid = call_589356.validator(path, query, header, formData, body)
  let scheme = call_589356.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589356.url(scheme.get, call_589356.host, call_589356.base,
                         call_589356.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589356, url, valid)

proc call*(call_589357: Call_FusiontablesStyleDelete_589344; tableId: string;
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
  var path_589358 = newJObject()
  var query_589359 = newJObject()
  add(path_589358, "tableId", newJString(tableId))
  add(query_589359, "fields", newJString(fields))
  add(query_589359, "quotaUser", newJString(quotaUser))
  add(query_589359, "alt", newJString(alt))
  add(query_589359, "oauth_token", newJString(oauthToken))
  add(query_589359, "userIp", newJString(userIp))
  add(path_589358, "styleId", newJInt(styleId))
  add(query_589359, "key", newJString(key))
  add(query_589359, "prettyPrint", newJBool(prettyPrint))
  result = call_589357.call(path_589358, query_589359, nil, nil, nil)

var fusiontablesStyleDelete* = Call_FusiontablesStyleDelete_589344(
    name: "fusiontablesStyleDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/styles/{styleId}",
    validator: validate_FusiontablesStyleDelete_589345, base: "/fusiontables/v1",
    url: url_FusiontablesStyleDelete_589346, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskList_589378 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTaskList_589380(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTaskList_589379(path: JsonNode; query: JsonNode;
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
  var valid_589381 = path.getOrDefault("tableId")
  valid_589381 = validateParameter(valid_589381, JString, required = true,
                                 default = nil)
  if valid_589381 != nil:
    section.add "tableId", valid_589381
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of columns to return. Optional. Default is 5.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: JInt
  section = newJObject()
  var valid_589382 = query.getOrDefault("fields")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "fields", valid_589382
  var valid_589383 = query.getOrDefault("pageToken")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "pageToken", valid_589383
  var valid_589384 = query.getOrDefault("quotaUser")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "quotaUser", valid_589384
  var valid_589385 = query.getOrDefault("alt")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = newJString("json"))
  if valid_589385 != nil:
    section.add "alt", valid_589385
  var valid_589386 = query.getOrDefault("oauth_token")
  valid_589386 = validateParameter(valid_589386, JString, required = false,
                                 default = nil)
  if valid_589386 != nil:
    section.add "oauth_token", valid_589386
  var valid_589387 = query.getOrDefault("userIp")
  valid_589387 = validateParameter(valid_589387, JString, required = false,
                                 default = nil)
  if valid_589387 != nil:
    section.add "userIp", valid_589387
  var valid_589388 = query.getOrDefault("maxResults")
  valid_589388 = validateParameter(valid_589388, JInt, required = false, default = nil)
  if valid_589388 != nil:
    section.add "maxResults", valid_589388
  var valid_589389 = query.getOrDefault("key")
  valid_589389 = validateParameter(valid_589389, JString, required = false,
                                 default = nil)
  if valid_589389 != nil:
    section.add "key", valid_589389
  var valid_589390 = query.getOrDefault("prettyPrint")
  valid_589390 = validateParameter(valid_589390, JBool, required = false,
                                 default = newJBool(true))
  if valid_589390 != nil:
    section.add "prettyPrint", valid_589390
  var valid_589391 = query.getOrDefault("startIndex")
  valid_589391 = validateParameter(valid_589391, JInt, required = false, default = nil)
  if valid_589391 != nil:
    section.add "startIndex", valid_589391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589392: Call_FusiontablesTaskList_589378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of tasks.
  ## 
  let valid = call_589392.validator(path, query, header, formData, body)
  let scheme = call_589392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589392.url(scheme.get, call_589392.host, call_589392.base,
                         call_589392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589392, url, valid)

proc call*(call_589393: Call_FusiontablesTaskList_589378; tableId: string;
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
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of columns to return. Optional. Default is 5.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   startIndex: int
  var path_589394 = newJObject()
  var query_589395 = newJObject()
  add(path_589394, "tableId", newJString(tableId))
  add(query_589395, "fields", newJString(fields))
  add(query_589395, "pageToken", newJString(pageToken))
  add(query_589395, "quotaUser", newJString(quotaUser))
  add(query_589395, "alt", newJString(alt))
  add(query_589395, "oauth_token", newJString(oauthToken))
  add(query_589395, "userIp", newJString(userIp))
  add(query_589395, "maxResults", newJInt(maxResults))
  add(query_589395, "key", newJString(key))
  add(query_589395, "prettyPrint", newJBool(prettyPrint))
  add(query_589395, "startIndex", newJInt(startIndex))
  result = call_589393.call(path_589394, query_589395, nil, nil, nil)

var fusiontablesTaskList* = Call_FusiontablesTaskList_589378(
    name: "fusiontablesTaskList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks",
    validator: validate_FusiontablesTaskList_589379, base: "/fusiontables/v1",
    url: url_FusiontablesTaskList_589380, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskGet_589396 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTaskGet_589398(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTaskGet_589397(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a specific task by its id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table to which the task belongs.
  ##   taskId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589399 = path.getOrDefault("tableId")
  valid_589399 = validateParameter(valid_589399, JString, required = true,
                                 default = nil)
  if valid_589399 != nil:
    section.add "tableId", valid_589399
  var valid_589400 = path.getOrDefault("taskId")
  valid_589400 = validateParameter(valid_589400, JString, required = true,
                                 default = nil)
  if valid_589400 != nil:
    section.add "taskId", valid_589400
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
  var valid_589401 = query.getOrDefault("fields")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "fields", valid_589401
  var valid_589402 = query.getOrDefault("quotaUser")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "quotaUser", valid_589402
  var valid_589403 = query.getOrDefault("alt")
  valid_589403 = validateParameter(valid_589403, JString, required = false,
                                 default = newJString("json"))
  if valid_589403 != nil:
    section.add "alt", valid_589403
  var valid_589404 = query.getOrDefault("oauth_token")
  valid_589404 = validateParameter(valid_589404, JString, required = false,
                                 default = nil)
  if valid_589404 != nil:
    section.add "oauth_token", valid_589404
  var valid_589405 = query.getOrDefault("userIp")
  valid_589405 = validateParameter(valid_589405, JString, required = false,
                                 default = nil)
  if valid_589405 != nil:
    section.add "userIp", valid_589405
  var valid_589406 = query.getOrDefault("key")
  valid_589406 = validateParameter(valid_589406, JString, required = false,
                                 default = nil)
  if valid_589406 != nil:
    section.add "key", valid_589406
  var valid_589407 = query.getOrDefault("prettyPrint")
  valid_589407 = validateParameter(valid_589407, JBool, required = false,
                                 default = newJBool(true))
  if valid_589407 != nil:
    section.add "prettyPrint", valid_589407
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589408: Call_FusiontablesTaskGet_589396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific task by its id.
  ## 
  let valid = call_589408.validator(path, query, header, formData, body)
  let scheme = call_589408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589408.url(scheme.get, call_589408.host, call_589408.base,
                         call_589408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589408, url, valid)

proc call*(call_589409: Call_FusiontablesTaskGet_589396; tableId: string;
          taskId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTaskGet
  ## Retrieves a specific task by its id.
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
  var path_589410 = newJObject()
  var query_589411 = newJObject()
  add(path_589410, "tableId", newJString(tableId))
  add(query_589411, "fields", newJString(fields))
  add(query_589411, "quotaUser", newJString(quotaUser))
  add(query_589411, "alt", newJString(alt))
  add(query_589411, "oauth_token", newJString(oauthToken))
  add(query_589411, "userIp", newJString(userIp))
  add(query_589411, "key", newJString(key))
  add(query_589411, "prettyPrint", newJBool(prettyPrint))
  add(path_589410, "taskId", newJString(taskId))
  result = call_589409.call(path_589410, query_589411, nil, nil, nil)

var fusiontablesTaskGet* = Call_FusiontablesTaskGet_589396(
    name: "fusiontablesTaskGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks/{taskId}",
    validator: validate_FusiontablesTaskGet_589397, base: "/fusiontables/v1",
    url: url_FusiontablesTaskGet_589398, schemes: {Scheme.Https})
type
  Call_FusiontablesTaskDelete_589412 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTaskDelete_589414(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTaskDelete_589413(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the task, unless already started.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   tableId: JString (required)
  ##          : Table from which the task is being deleted.
  ##   taskId: JString (required)
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `tableId` field"
  var valid_589415 = path.getOrDefault("tableId")
  valid_589415 = validateParameter(valid_589415, JString, required = true,
                                 default = nil)
  if valid_589415 != nil:
    section.add "tableId", valid_589415
  var valid_589416 = path.getOrDefault("taskId")
  valid_589416 = validateParameter(valid_589416, JString, required = true,
                                 default = nil)
  if valid_589416 != nil:
    section.add "taskId", valid_589416
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
  var valid_589417 = query.getOrDefault("fields")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "fields", valid_589417
  var valid_589418 = query.getOrDefault("quotaUser")
  valid_589418 = validateParameter(valid_589418, JString, required = false,
                                 default = nil)
  if valid_589418 != nil:
    section.add "quotaUser", valid_589418
  var valid_589419 = query.getOrDefault("alt")
  valid_589419 = validateParameter(valid_589419, JString, required = false,
                                 default = newJString("json"))
  if valid_589419 != nil:
    section.add "alt", valid_589419
  var valid_589420 = query.getOrDefault("oauth_token")
  valid_589420 = validateParameter(valid_589420, JString, required = false,
                                 default = nil)
  if valid_589420 != nil:
    section.add "oauth_token", valid_589420
  var valid_589421 = query.getOrDefault("userIp")
  valid_589421 = validateParameter(valid_589421, JString, required = false,
                                 default = nil)
  if valid_589421 != nil:
    section.add "userIp", valid_589421
  var valid_589422 = query.getOrDefault("key")
  valid_589422 = validateParameter(valid_589422, JString, required = false,
                                 default = nil)
  if valid_589422 != nil:
    section.add "key", valid_589422
  var valid_589423 = query.getOrDefault("prettyPrint")
  valid_589423 = validateParameter(valid_589423, JBool, required = false,
                                 default = newJBool(true))
  if valid_589423 != nil:
    section.add "prettyPrint", valid_589423
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589424: Call_FusiontablesTaskDelete_589412; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes the task, unless already started.
  ## 
  let valid = call_589424.validator(path, query, header, formData, body)
  let scheme = call_589424.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589424.url(scheme.get, call_589424.host, call_589424.base,
                         call_589424.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589424, url, valid)

proc call*(call_589425: Call_FusiontablesTaskDelete_589412; tableId: string;
          taskId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## fusiontablesTaskDelete
  ## Deletes the task, unless already started.
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
  var path_589426 = newJObject()
  var query_589427 = newJObject()
  add(path_589426, "tableId", newJString(tableId))
  add(query_589427, "fields", newJString(fields))
  add(query_589427, "quotaUser", newJString(quotaUser))
  add(query_589427, "alt", newJString(alt))
  add(query_589427, "oauth_token", newJString(oauthToken))
  add(query_589427, "userIp", newJString(userIp))
  add(query_589427, "key", newJString(key))
  add(query_589427, "prettyPrint", newJBool(prettyPrint))
  add(path_589426, "taskId", newJString(taskId))
  result = call_589425.call(path_589426, query_589427, nil, nil, nil)

var fusiontablesTaskDelete* = Call_FusiontablesTaskDelete_589412(
    name: "fusiontablesTaskDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/tasks/{taskId}",
    validator: validate_FusiontablesTaskDelete_589413, base: "/fusiontables/v1",
    url: url_FusiontablesTaskDelete_589414, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateInsert_589445 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTemplateInsert_589447(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplateInsert_589446(path: JsonNode; query: JsonNode;
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
  var valid_589448 = path.getOrDefault("tableId")
  valid_589448 = validateParameter(valid_589448, JString, required = true,
                                 default = nil)
  if valid_589448 != nil:
    section.add "tableId", valid_589448
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
  var valid_589449 = query.getOrDefault("fields")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "fields", valid_589449
  var valid_589450 = query.getOrDefault("quotaUser")
  valid_589450 = validateParameter(valid_589450, JString, required = false,
                                 default = nil)
  if valid_589450 != nil:
    section.add "quotaUser", valid_589450
  var valid_589451 = query.getOrDefault("alt")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = newJString("json"))
  if valid_589451 != nil:
    section.add "alt", valid_589451
  var valid_589452 = query.getOrDefault("oauth_token")
  valid_589452 = validateParameter(valid_589452, JString, required = false,
                                 default = nil)
  if valid_589452 != nil:
    section.add "oauth_token", valid_589452
  var valid_589453 = query.getOrDefault("userIp")
  valid_589453 = validateParameter(valid_589453, JString, required = false,
                                 default = nil)
  if valid_589453 != nil:
    section.add "userIp", valid_589453
  var valid_589454 = query.getOrDefault("key")
  valid_589454 = validateParameter(valid_589454, JString, required = false,
                                 default = nil)
  if valid_589454 != nil:
    section.add "key", valid_589454
  var valid_589455 = query.getOrDefault("prettyPrint")
  valid_589455 = validateParameter(valid_589455, JBool, required = false,
                                 default = newJBool(true))
  if valid_589455 != nil:
    section.add "prettyPrint", valid_589455
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

proc call*(call_589457: Call_FusiontablesTemplateInsert_589445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new template for the table.
  ## 
  let valid = call_589457.validator(path, query, header, formData, body)
  let scheme = call_589457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589457.url(scheme.get, call_589457.host, call_589457.base,
                         call_589457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589457, url, valid)

proc call*(call_589458: Call_FusiontablesTemplateInsert_589445; tableId: string;
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
  var path_589459 = newJObject()
  var query_589460 = newJObject()
  var body_589461 = newJObject()
  add(path_589459, "tableId", newJString(tableId))
  add(query_589460, "fields", newJString(fields))
  add(query_589460, "quotaUser", newJString(quotaUser))
  add(query_589460, "alt", newJString(alt))
  add(query_589460, "oauth_token", newJString(oauthToken))
  add(query_589460, "userIp", newJString(userIp))
  add(query_589460, "key", newJString(key))
  if body != nil:
    body_589461 = body
  add(query_589460, "prettyPrint", newJBool(prettyPrint))
  result = call_589458.call(path_589459, query_589460, nil, nil, body_589461)

var fusiontablesTemplateInsert* = Call_FusiontablesTemplateInsert_589445(
    name: "fusiontablesTemplateInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates",
    validator: validate_FusiontablesTemplateInsert_589446,
    base: "/fusiontables/v1", url: url_FusiontablesTemplateInsert_589447,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateList_589428 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTemplateList_589430(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplateList_589429(path: JsonNode; query: JsonNode;
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
  var valid_589431 = path.getOrDefault("tableId")
  valid_589431 = validateParameter(valid_589431, JString, required = true,
                                 default = nil)
  if valid_589431 != nil:
    section.add "tableId", valid_589431
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
  var valid_589432 = query.getOrDefault("fields")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "fields", valid_589432
  var valid_589433 = query.getOrDefault("pageToken")
  valid_589433 = validateParameter(valid_589433, JString, required = false,
                                 default = nil)
  if valid_589433 != nil:
    section.add "pageToken", valid_589433
  var valid_589434 = query.getOrDefault("quotaUser")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "quotaUser", valid_589434
  var valid_589435 = query.getOrDefault("alt")
  valid_589435 = validateParameter(valid_589435, JString, required = false,
                                 default = newJString("json"))
  if valid_589435 != nil:
    section.add "alt", valid_589435
  var valid_589436 = query.getOrDefault("oauth_token")
  valid_589436 = validateParameter(valid_589436, JString, required = false,
                                 default = nil)
  if valid_589436 != nil:
    section.add "oauth_token", valid_589436
  var valid_589437 = query.getOrDefault("userIp")
  valid_589437 = validateParameter(valid_589437, JString, required = false,
                                 default = nil)
  if valid_589437 != nil:
    section.add "userIp", valid_589437
  var valid_589438 = query.getOrDefault("maxResults")
  valid_589438 = validateParameter(valid_589438, JInt, required = false, default = nil)
  if valid_589438 != nil:
    section.add "maxResults", valid_589438
  var valid_589439 = query.getOrDefault("key")
  valid_589439 = validateParameter(valid_589439, JString, required = false,
                                 default = nil)
  if valid_589439 != nil:
    section.add "key", valid_589439
  var valid_589440 = query.getOrDefault("prettyPrint")
  valid_589440 = validateParameter(valid_589440, JBool, required = false,
                                 default = newJBool(true))
  if valid_589440 != nil:
    section.add "prettyPrint", valid_589440
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589441: Call_FusiontablesTemplateList_589428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of templates.
  ## 
  let valid = call_589441.validator(path, query, header, formData, body)
  let scheme = call_589441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589441.url(scheme.get, call_589441.host, call_589441.base,
                         call_589441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589441, url, valid)

proc call*(call_589442: Call_FusiontablesTemplateList_589428; tableId: string;
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
  var path_589443 = newJObject()
  var query_589444 = newJObject()
  add(path_589443, "tableId", newJString(tableId))
  add(query_589444, "fields", newJString(fields))
  add(query_589444, "pageToken", newJString(pageToken))
  add(query_589444, "quotaUser", newJString(quotaUser))
  add(query_589444, "alt", newJString(alt))
  add(query_589444, "oauth_token", newJString(oauthToken))
  add(query_589444, "userIp", newJString(userIp))
  add(query_589444, "maxResults", newJInt(maxResults))
  add(query_589444, "key", newJString(key))
  add(query_589444, "prettyPrint", newJBool(prettyPrint))
  result = call_589442.call(path_589443, query_589444, nil, nil, nil)

var fusiontablesTemplateList* = Call_FusiontablesTemplateList_589428(
    name: "fusiontablesTemplateList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates",
    validator: validate_FusiontablesTemplateList_589429, base: "/fusiontables/v1",
    url: url_FusiontablesTemplateList_589430, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateUpdate_589478 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTemplateUpdate_589480(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplateUpdate_589479(path: JsonNode; query: JsonNode;
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
  var valid_589481 = path.getOrDefault("tableId")
  valid_589481 = validateParameter(valid_589481, JString, required = true,
                                 default = nil)
  if valid_589481 != nil:
    section.add "tableId", valid_589481
  var valid_589482 = path.getOrDefault("templateId")
  valid_589482 = validateParameter(valid_589482, JInt, required = true, default = nil)
  if valid_589482 != nil:
    section.add "templateId", valid_589482
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
  var valid_589483 = query.getOrDefault("fields")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = nil)
  if valid_589483 != nil:
    section.add "fields", valid_589483
  var valid_589484 = query.getOrDefault("quotaUser")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "quotaUser", valid_589484
  var valid_589485 = query.getOrDefault("alt")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = newJString("json"))
  if valid_589485 != nil:
    section.add "alt", valid_589485
  var valid_589486 = query.getOrDefault("oauth_token")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "oauth_token", valid_589486
  var valid_589487 = query.getOrDefault("userIp")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "userIp", valid_589487
  var valid_589488 = query.getOrDefault("key")
  valid_589488 = validateParameter(valid_589488, JString, required = false,
                                 default = nil)
  if valid_589488 != nil:
    section.add "key", valid_589488
  var valid_589489 = query.getOrDefault("prettyPrint")
  valid_589489 = validateParameter(valid_589489, JBool, required = false,
                                 default = newJBool(true))
  if valid_589489 != nil:
    section.add "prettyPrint", valid_589489
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

proc call*(call_589491: Call_FusiontablesTemplateUpdate_589478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing template
  ## 
  let valid = call_589491.validator(path, query, header, formData, body)
  let scheme = call_589491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589491.url(scheme.get, call_589491.host, call_589491.base,
                         call_589491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589491, url, valid)

proc call*(call_589492: Call_FusiontablesTemplateUpdate_589478; tableId: string;
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
  var path_589493 = newJObject()
  var query_589494 = newJObject()
  var body_589495 = newJObject()
  add(path_589493, "tableId", newJString(tableId))
  add(query_589494, "fields", newJString(fields))
  add(query_589494, "quotaUser", newJString(quotaUser))
  add(query_589494, "alt", newJString(alt))
  add(path_589493, "templateId", newJInt(templateId))
  add(query_589494, "oauth_token", newJString(oauthToken))
  add(query_589494, "userIp", newJString(userIp))
  add(query_589494, "key", newJString(key))
  if body != nil:
    body_589495 = body
  add(query_589494, "prettyPrint", newJBool(prettyPrint))
  result = call_589492.call(path_589493, query_589494, nil, nil, body_589495)

var fusiontablesTemplateUpdate* = Call_FusiontablesTemplateUpdate_589478(
    name: "fusiontablesTemplateUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateUpdate_589479,
    base: "/fusiontables/v1", url: url_FusiontablesTemplateUpdate_589480,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateGet_589462 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTemplateGet_589464(protocol: Scheme; host: string; base: string;
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

proc validate_FusiontablesTemplateGet_589463(path: JsonNode; query: JsonNode;
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
  var valid_589465 = path.getOrDefault("tableId")
  valid_589465 = validateParameter(valid_589465, JString, required = true,
                                 default = nil)
  if valid_589465 != nil:
    section.add "tableId", valid_589465
  var valid_589466 = path.getOrDefault("templateId")
  valid_589466 = validateParameter(valid_589466, JInt, required = true, default = nil)
  if valid_589466 != nil:
    section.add "templateId", valid_589466
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
  var valid_589467 = query.getOrDefault("fields")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "fields", valid_589467
  var valid_589468 = query.getOrDefault("quotaUser")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "quotaUser", valid_589468
  var valid_589469 = query.getOrDefault("alt")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = newJString("json"))
  if valid_589469 != nil:
    section.add "alt", valid_589469
  var valid_589470 = query.getOrDefault("oauth_token")
  valid_589470 = validateParameter(valid_589470, JString, required = false,
                                 default = nil)
  if valid_589470 != nil:
    section.add "oauth_token", valid_589470
  var valid_589471 = query.getOrDefault("userIp")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "userIp", valid_589471
  var valid_589472 = query.getOrDefault("key")
  valid_589472 = validateParameter(valid_589472, JString, required = false,
                                 default = nil)
  if valid_589472 != nil:
    section.add "key", valid_589472
  var valid_589473 = query.getOrDefault("prettyPrint")
  valid_589473 = validateParameter(valid_589473, JBool, required = false,
                                 default = newJBool(true))
  if valid_589473 != nil:
    section.add "prettyPrint", valid_589473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589474: Call_FusiontablesTemplateGet_589462; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a specific template by its id
  ## 
  let valid = call_589474.validator(path, query, header, formData, body)
  let scheme = call_589474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589474.url(scheme.get, call_589474.host, call_589474.base,
                         call_589474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589474, url, valid)

proc call*(call_589475: Call_FusiontablesTemplateGet_589462; tableId: string;
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
  var path_589476 = newJObject()
  var query_589477 = newJObject()
  add(path_589476, "tableId", newJString(tableId))
  add(query_589477, "fields", newJString(fields))
  add(query_589477, "quotaUser", newJString(quotaUser))
  add(query_589477, "alt", newJString(alt))
  add(path_589476, "templateId", newJInt(templateId))
  add(query_589477, "oauth_token", newJString(oauthToken))
  add(query_589477, "userIp", newJString(userIp))
  add(query_589477, "key", newJString(key))
  add(query_589477, "prettyPrint", newJBool(prettyPrint))
  result = call_589475.call(path_589476, query_589477, nil, nil, nil)

var fusiontablesTemplateGet* = Call_FusiontablesTemplateGet_589462(
    name: "fusiontablesTemplateGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateGet_589463, base: "/fusiontables/v1",
    url: url_FusiontablesTemplateGet_589464, schemes: {Scheme.Https})
type
  Call_FusiontablesTemplatePatch_589512 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTemplatePatch_589514(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplatePatch_589513(path: JsonNode; query: JsonNode;
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
  var valid_589515 = path.getOrDefault("tableId")
  valid_589515 = validateParameter(valid_589515, JString, required = true,
                                 default = nil)
  if valid_589515 != nil:
    section.add "tableId", valid_589515
  var valid_589516 = path.getOrDefault("templateId")
  valid_589516 = validateParameter(valid_589516, JInt, required = true, default = nil)
  if valid_589516 != nil:
    section.add "templateId", valid_589516
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
  var valid_589517 = query.getOrDefault("fields")
  valid_589517 = validateParameter(valid_589517, JString, required = false,
                                 default = nil)
  if valid_589517 != nil:
    section.add "fields", valid_589517
  var valid_589518 = query.getOrDefault("quotaUser")
  valid_589518 = validateParameter(valid_589518, JString, required = false,
                                 default = nil)
  if valid_589518 != nil:
    section.add "quotaUser", valid_589518
  var valid_589519 = query.getOrDefault("alt")
  valid_589519 = validateParameter(valid_589519, JString, required = false,
                                 default = newJString("json"))
  if valid_589519 != nil:
    section.add "alt", valid_589519
  var valid_589520 = query.getOrDefault("oauth_token")
  valid_589520 = validateParameter(valid_589520, JString, required = false,
                                 default = nil)
  if valid_589520 != nil:
    section.add "oauth_token", valid_589520
  var valid_589521 = query.getOrDefault("userIp")
  valid_589521 = validateParameter(valid_589521, JString, required = false,
                                 default = nil)
  if valid_589521 != nil:
    section.add "userIp", valid_589521
  var valid_589522 = query.getOrDefault("key")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "key", valid_589522
  var valid_589523 = query.getOrDefault("prettyPrint")
  valid_589523 = validateParameter(valid_589523, JBool, required = false,
                                 default = newJBool(true))
  if valid_589523 != nil:
    section.add "prettyPrint", valid_589523
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

proc call*(call_589525: Call_FusiontablesTemplatePatch_589512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an existing template. This method supports patch semantics.
  ## 
  let valid = call_589525.validator(path, query, header, formData, body)
  let scheme = call_589525.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589525.url(scheme.get, call_589525.host, call_589525.base,
                         call_589525.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589525, url, valid)

proc call*(call_589526: Call_FusiontablesTemplatePatch_589512; tableId: string;
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
  var path_589527 = newJObject()
  var query_589528 = newJObject()
  var body_589529 = newJObject()
  add(path_589527, "tableId", newJString(tableId))
  add(query_589528, "fields", newJString(fields))
  add(query_589528, "quotaUser", newJString(quotaUser))
  add(query_589528, "alt", newJString(alt))
  add(path_589527, "templateId", newJInt(templateId))
  add(query_589528, "oauth_token", newJString(oauthToken))
  add(query_589528, "userIp", newJString(userIp))
  add(query_589528, "key", newJString(key))
  if body != nil:
    body_589529 = body
  add(query_589528, "prettyPrint", newJBool(prettyPrint))
  result = call_589526.call(path_589527, query_589528, nil, nil, body_589529)

var fusiontablesTemplatePatch* = Call_FusiontablesTemplatePatch_589512(
    name: "fusiontablesTemplatePatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplatePatch_589513,
    base: "/fusiontables/v1", url: url_FusiontablesTemplatePatch_589514,
    schemes: {Scheme.Https})
type
  Call_FusiontablesTemplateDelete_589496 = ref object of OpenApiRestCall_588457
proc url_FusiontablesTemplateDelete_589498(protocol: Scheme; host: string;
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

proc validate_FusiontablesTemplateDelete_589497(path: JsonNode; query: JsonNode;
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
  var valid_589499 = path.getOrDefault("tableId")
  valid_589499 = validateParameter(valid_589499, JString, required = true,
                                 default = nil)
  if valid_589499 != nil:
    section.add "tableId", valid_589499
  var valid_589500 = path.getOrDefault("templateId")
  valid_589500 = validateParameter(valid_589500, JInt, required = true, default = nil)
  if valid_589500 != nil:
    section.add "templateId", valid_589500
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
  var valid_589501 = query.getOrDefault("fields")
  valid_589501 = validateParameter(valid_589501, JString, required = false,
                                 default = nil)
  if valid_589501 != nil:
    section.add "fields", valid_589501
  var valid_589502 = query.getOrDefault("quotaUser")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = nil)
  if valid_589502 != nil:
    section.add "quotaUser", valid_589502
  var valid_589503 = query.getOrDefault("alt")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = newJString("json"))
  if valid_589503 != nil:
    section.add "alt", valid_589503
  var valid_589504 = query.getOrDefault("oauth_token")
  valid_589504 = validateParameter(valid_589504, JString, required = false,
                                 default = nil)
  if valid_589504 != nil:
    section.add "oauth_token", valid_589504
  var valid_589505 = query.getOrDefault("userIp")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "userIp", valid_589505
  var valid_589506 = query.getOrDefault("key")
  valid_589506 = validateParameter(valid_589506, JString, required = false,
                                 default = nil)
  if valid_589506 != nil:
    section.add "key", valid_589506
  var valid_589507 = query.getOrDefault("prettyPrint")
  valid_589507 = validateParameter(valid_589507, JBool, required = false,
                                 default = newJBool(true))
  if valid_589507 != nil:
    section.add "prettyPrint", valid_589507
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589508: Call_FusiontablesTemplateDelete_589496; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a template
  ## 
  let valid = call_589508.validator(path, query, header, formData, body)
  let scheme = call_589508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589508.url(scheme.get, call_589508.host, call_589508.base,
                         call_589508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589508, url, valid)

proc call*(call_589509: Call_FusiontablesTemplateDelete_589496; tableId: string;
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
  var path_589510 = newJObject()
  var query_589511 = newJObject()
  add(path_589510, "tableId", newJString(tableId))
  add(query_589511, "fields", newJString(fields))
  add(query_589511, "quotaUser", newJString(quotaUser))
  add(query_589511, "alt", newJString(alt))
  add(path_589510, "templateId", newJInt(templateId))
  add(query_589511, "oauth_token", newJString(oauthToken))
  add(query_589511, "userIp", newJString(userIp))
  add(query_589511, "key", newJString(key))
  add(query_589511, "prettyPrint", newJBool(prettyPrint))
  result = call_589509.call(path_589510, query_589511, nil, nil, nil)

var fusiontablesTemplateDelete* = Call_FusiontablesTemplateDelete_589496(
    name: "fusiontablesTemplateDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/tables/{tableId}/templates/{templateId}",
    validator: validate_FusiontablesTemplateDelete_589497,
    base: "/fusiontables/v1", url: url_FusiontablesTemplateDelete_589498,
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
