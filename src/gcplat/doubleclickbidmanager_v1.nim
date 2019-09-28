
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: DoubleClick Bid Manager
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## API for viewing and managing your reports in DoubleClick Bid Manager.
## 
## https://developers.google.com/bid-manager/
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "doubleclickbidmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DoubleclickbidmanagerLineitemsDownloadlineitems_579676 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerLineitemsDownloadlineitems_579678(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsDownloadlineitems_579677(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves line items in CSV format. TrueView line items are not supported.
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
  var valid_579790 = query.getOrDefault("fields")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "fields", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579805 = query.getOrDefault("alt")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = newJString("json"))
  if valid_579805 != nil:
    section.add "alt", valid_579805
  var valid_579806 = query.getOrDefault("oauth_token")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "oauth_token", valid_579806
  var valid_579807 = query.getOrDefault("userIp")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "userIp", valid_579807
  var valid_579808 = query.getOrDefault("key")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "key", valid_579808
  var valid_579809 = query.getOrDefault("prettyPrint")
  valid_579809 = validateParameter(valid_579809, JBool, required = false,
                                 default = newJBool(true))
  if valid_579809 != nil:
    section.add "prettyPrint", valid_579809
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

proc call*(call_579833: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_579676;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_579833.validator(path, query, header, formData, body)
  let scheme = call_579833.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579833.url(scheme.get, call_579833.host, call_579833.base,
                         call_579833.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579833, url, valid)

proc call*(call_579904: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_579676;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerLineitemsDownloadlineitems
  ## Retrieves line items in CSV format. TrueView line items are not supported.
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
  var query_579905 = newJObject()
  var body_579907 = newJObject()
  add(query_579905, "fields", newJString(fields))
  add(query_579905, "quotaUser", newJString(quotaUser))
  add(query_579905, "alt", newJString(alt))
  add(query_579905, "oauth_token", newJString(oauthToken))
  add(query_579905, "userIp", newJString(userIp))
  add(query_579905, "key", newJString(key))
  if body != nil:
    body_579907 = body
  add(query_579905, "prettyPrint", newJBool(prettyPrint))
  result = call_579904.call(nil, query_579905, nil, nil, body_579907)

var doubleclickbidmanagerLineitemsDownloadlineitems* = Call_DoubleclickbidmanagerLineitemsDownloadlineitems_579676(
    name: "doubleclickbidmanagerLineitemsDownloadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/downloadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsDownloadlineitems_579677,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsDownloadlineitems_579678,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerLineitemsUploadlineitems_579946 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerLineitemsUploadlineitems_579948(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsUploadlineitems_579947(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Uploads line items in CSV format. TrueView line items are not supported.
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
  var valid_579949 = query.getOrDefault("fields")
  valid_579949 = validateParameter(valid_579949, JString, required = false,
                                 default = nil)
  if valid_579949 != nil:
    section.add "fields", valid_579949
  var valid_579950 = query.getOrDefault("quotaUser")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "quotaUser", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("userIp")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "userIp", valid_579953
  var valid_579954 = query.getOrDefault("key")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "key", valid_579954
  var valid_579955 = query.getOrDefault("prettyPrint")
  valid_579955 = validateParameter(valid_579955, JBool, required = false,
                                 default = newJBool(true))
  if valid_579955 != nil:
    section.add "prettyPrint", valid_579955
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

proc call*(call_579957: Call_DoubleclickbidmanagerLineitemsUploadlineitems_579946;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_DoubleclickbidmanagerLineitemsUploadlineitems_579946;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerLineitemsUploadlineitems
  ## Uploads line items in CSV format. TrueView line items are not supported.
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
  var query_579959 = newJObject()
  var body_579960 = newJObject()
  add(query_579959, "fields", newJString(fields))
  add(query_579959, "quotaUser", newJString(quotaUser))
  add(query_579959, "alt", newJString(alt))
  add(query_579959, "oauth_token", newJString(oauthToken))
  add(query_579959, "userIp", newJString(userIp))
  add(query_579959, "key", newJString(key))
  if body != nil:
    body_579960 = body
  add(query_579959, "prettyPrint", newJBool(prettyPrint))
  result = call_579958.call(nil, query_579959, nil, nil, body_579960)

var doubleclickbidmanagerLineitemsUploadlineitems* = Call_DoubleclickbidmanagerLineitemsUploadlineitems_579946(
    name: "doubleclickbidmanagerLineitemsUploadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/uploadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsUploadlineitems_579947,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsUploadlineitems_579948,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesListqueries_579961 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerQueriesListqueries_579963(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerQueriesListqueries_579962(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves stored queries.
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
  var valid_579964 = query.getOrDefault("fields")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "fields", valid_579964
  var valid_579965 = query.getOrDefault("quotaUser")
  valid_579965 = validateParameter(valid_579965, JString, required = false,
                                 default = nil)
  if valid_579965 != nil:
    section.add "quotaUser", valid_579965
  var valid_579966 = query.getOrDefault("alt")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = newJString("json"))
  if valid_579966 != nil:
    section.add "alt", valid_579966
  var valid_579967 = query.getOrDefault("oauth_token")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "oauth_token", valid_579967
  var valid_579968 = query.getOrDefault("userIp")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userIp", valid_579968
  var valid_579969 = query.getOrDefault("key")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "key", valid_579969
  var valid_579970 = query.getOrDefault("prettyPrint")
  valid_579970 = validateParameter(valid_579970, JBool, required = false,
                                 default = newJBool(true))
  if valid_579970 != nil:
    section.add "prettyPrint", valid_579970
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579971: Call_DoubleclickbidmanagerQueriesListqueries_579961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored queries.
  ## 
  let valid = call_579971.validator(path, query, header, formData, body)
  let scheme = call_579971.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579971.url(scheme.get, call_579971.host, call_579971.base,
                         call_579971.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579971, url, valid)

proc call*(call_579972: Call_DoubleclickbidmanagerQueriesListqueries_579961;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesListqueries
  ## Retrieves stored queries.
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
  var query_579973 = newJObject()
  add(query_579973, "fields", newJString(fields))
  add(query_579973, "quotaUser", newJString(quotaUser))
  add(query_579973, "alt", newJString(alt))
  add(query_579973, "oauth_token", newJString(oauthToken))
  add(query_579973, "userIp", newJString(userIp))
  add(query_579973, "key", newJString(key))
  add(query_579973, "prettyPrint", newJBool(prettyPrint))
  result = call_579972.call(nil, query_579973, nil, nil, nil)

var doubleclickbidmanagerQueriesListqueries* = Call_DoubleclickbidmanagerQueriesListqueries_579961(
    name: "doubleclickbidmanagerQueriesListqueries", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries",
    validator: validate_DoubleclickbidmanagerQueriesListqueries_579962,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesListqueries_579963,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerReportsListreports_579974 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerReportsListreports_579976(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/queries/"),
               (kind: VariableSegment, value: "queryId"),
               (kind: ConstantSegment, value: "/reports")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerReportsListreports_579975(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves stored reports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : Query ID with which the reports are associated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_579991 = path.getOrDefault("queryId")
  valid_579991 = validateParameter(valid_579991, JString, required = true,
                                 default = nil)
  if valid_579991 != nil:
    section.add "queryId", valid_579991
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
  var valid_579992 = query.getOrDefault("fields")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "fields", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("alt")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = newJString("json"))
  if valid_579994 != nil:
    section.add "alt", valid_579994
  var valid_579995 = query.getOrDefault("oauth_token")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "oauth_token", valid_579995
  var valid_579996 = query.getOrDefault("userIp")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "userIp", valid_579996
  var valid_579997 = query.getOrDefault("key")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "key", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579999: Call_DoubleclickbidmanagerReportsListreports_579974;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored reports.
  ## 
  let valid = call_579999.validator(path, query, header, formData, body)
  let scheme = call_579999.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579999.url(scheme.get, call_579999.host, call_579999.base,
                         call_579999.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579999, url, valid)

proc call*(call_580000: Call_DoubleclickbidmanagerReportsListreports_579974;
          queryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerReportsListreports
  ## Retrieves stored reports.
  ##   queryId: string (required)
  ##          : Query ID with which the reports are associated.
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
  var path_580001 = newJObject()
  var query_580002 = newJObject()
  add(path_580001, "queryId", newJString(queryId))
  add(query_580002, "fields", newJString(fields))
  add(query_580002, "quotaUser", newJString(quotaUser))
  add(query_580002, "alt", newJString(alt))
  add(query_580002, "oauth_token", newJString(oauthToken))
  add(query_580002, "userIp", newJString(userIp))
  add(query_580002, "key", newJString(key))
  add(query_580002, "prettyPrint", newJBool(prettyPrint))
  result = call_580000.call(path_580001, query_580002, nil, nil, nil)

var doubleclickbidmanagerReportsListreports* = Call_DoubleclickbidmanagerReportsListreports_579974(
    name: "doubleclickbidmanagerReportsListreports", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries/{queryId}/reports",
    validator: validate_DoubleclickbidmanagerReportsListreports_579975,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerReportsListreports_579976,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesCreatequery_580003 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerQueriesCreatequery_580005(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerQueriesCreatequery_580004(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a query.
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
  var valid_580006 = query.getOrDefault("fields")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "fields", valid_580006
  var valid_580007 = query.getOrDefault("quotaUser")
  valid_580007 = validateParameter(valid_580007, JString, required = false,
                                 default = nil)
  if valid_580007 != nil:
    section.add "quotaUser", valid_580007
  var valid_580008 = query.getOrDefault("alt")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = newJString("json"))
  if valid_580008 != nil:
    section.add "alt", valid_580008
  var valid_580009 = query.getOrDefault("oauth_token")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = nil)
  if valid_580009 != nil:
    section.add "oauth_token", valid_580009
  var valid_580010 = query.getOrDefault("userIp")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "userIp", valid_580010
  var valid_580011 = query.getOrDefault("key")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "key", valid_580011
  var valid_580012 = query.getOrDefault("prettyPrint")
  valid_580012 = validateParameter(valid_580012, JBool, required = false,
                                 default = newJBool(true))
  if valid_580012 != nil:
    section.add "prettyPrint", valid_580012
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

proc call*(call_580014: Call_DoubleclickbidmanagerQueriesCreatequery_580003;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a query.
  ## 
  let valid = call_580014.validator(path, query, header, formData, body)
  let scheme = call_580014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580014.url(scheme.get, call_580014.host, call_580014.base,
                         call_580014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580014, url, valid)

proc call*(call_580015: Call_DoubleclickbidmanagerQueriesCreatequery_580003;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesCreatequery
  ## Creates a query.
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
  var query_580016 = newJObject()
  var body_580017 = newJObject()
  add(query_580016, "fields", newJString(fields))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "key", newJString(key))
  if body != nil:
    body_580017 = body
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  result = call_580015.call(nil, query_580016, nil, nil, body_580017)

var doubleclickbidmanagerQueriesCreatequery* = Call_DoubleclickbidmanagerQueriesCreatequery_580003(
    name: "doubleclickbidmanagerQueriesCreatequery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_DoubleclickbidmanagerQueriesCreatequery_580004,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesCreatequery_580005,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesRunquery_580033 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerQueriesRunquery_580035(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/query/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesRunquery_580034(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Runs a stored query to generate a report.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : Query ID to run.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_580036 = path.getOrDefault("queryId")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "queryId", valid_580036
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
  var valid_580037 = query.getOrDefault("fields")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "fields", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("userIp")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "userIp", valid_580041
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("prettyPrint")
  valid_580043 = validateParameter(valid_580043, JBool, required = false,
                                 default = newJBool(true))
  if valid_580043 != nil:
    section.add "prettyPrint", valid_580043
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

proc call*(call_580045: Call_DoubleclickbidmanagerQueriesRunquery_580033;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a stored query to generate a report.
  ## 
  let valid = call_580045.validator(path, query, header, formData, body)
  let scheme = call_580045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580045.url(scheme.get, call_580045.host, call_580045.base,
                         call_580045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580045, url, valid)

proc call*(call_580046: Call_DoubleclickbidmanagerQueriesRunquery_580033;
          queryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesRunquery
  ## Runs a stored query to generate a report.
  ##   queryId: string (required)
  ##          : Query ID to run.
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
  var path_580047 = newJObject()
  var query_580048 = newJObject()
  var body_580049 = newJObject()
  add(path_580047, "queryId", newJString(queryId))
  add(query_580048, "fields", newJString(fields))
  add(query_580048, "quotaUser", newJString(quotaUser))
  add(query_580048, "alt", newJString(alt))
  add(query_580048, "oauth_token", newJString(oauthToken))
  add(query_580048, "userIp", newJString(userIp))
  add(query_580048, "key", newJString(key))
  if body != nil:
    body_580049 = body
  add(query_580048, "prettyPrint", newJBool(prettyPrint))
  result = call_580046.call(path_580047, query_580048, nil, nil, body_580049)

var doubleclickbidmanagerQueriesRunquery* = Call_DoubleclickbidmanagerQueriesRunquery_580033(
    name: "doubleclickbidmanagerQueriesRunquery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesRunquery_580034,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesRunquery_580035, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesGetquery_580018 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerQueriesGetquery_580020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/query/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesGetquery_580019(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a stored query.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : Query ID to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_580021 = path.getOrDefault("queryId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "queryId", valid_580021
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
  var valid_580022 = query.getOrDefault("fields")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "fields", valid_580022
  var valid_580023 = query.getOrDefault("quotaUser")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "quotaUser", valid_580023
  var valid_580024 = query.getOrDefault("alt")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = newJString("json"))
  if valid_580024 != nil:
    section.add "alt", valid_580024
  var valid_580025 = query.getOrDefault("oauth_token")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "oauth_token", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("key")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "key", valid_580027
  var valid_580028 = query.getOrDefault("prettyPrint")
  valid_580028 = validateParameter(valid_580028, JBool, required = false,
                                 default = newJBool(true))
  if valid_580028 != nil:
    section.add "prettyPrint", valid_580028
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580029: Call_DoubleclickbidmanagerQueriesGetquery_580018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a stored query.
  ## 
  let valid = call_580029.validator(path, query, header, formData, body)
  let scheme = call_580029.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580029.url(scheme.get, call_580029.host, call_580029.base,
                         call_580029.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580029, url, valid)

proc call*(call_580030: Call_DoubleclickbidmanagerQueriesGetquery_580018;
          queryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesGetquery
  ## Retrieves a stored query.
  ##   queryId: string (required)
  ##          : Query ID to retrieve.
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
  var path_580031 = newJObject()
  var query_580032 = newJObject()
  add(path_580031, "queryId", newJString(queryId))
  add(query_580032, "fields", newJString(fields))
  add(query_580032, "quotaUser", newJString(quotaUser))
  add(query_580032, "alt", newJString(alt))
  add(query_580032, "oauth_token", newJString(oauthToken))
  add(query_580032, "userIp", newJString(userIp))
  add(query_580032, "key", newJString(key))
  add(query_580032, "prettyPrint", newJBool(prettyPrint))
  result = call_580030.call(path_580031, query_580032, nil, nil, nil)

var doubleclickbidmanagerQueriesGetquery* = Call_DoubleclickbidmanagerQueriesGetquery_580018(
    name: "doubleclickbidmanagerQueriesGetquery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesGetquery_580019,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesGetquery_580020, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesDeletequery_580050 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerQueriesDeletequery_580052(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "queryId" in path, "`queryId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/query/"),
               (kind: VariableSegment, value: "queryId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesDeletequery_580051(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a stored query as well as the associated stored reports.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   queryId: JString (required)
  ##          : Query ID to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `queryId` field"
  var valid_580053 = path.getOrDefault("queryId")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "queryId", valid_580053
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
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("userIp")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "userIp", valid_580058
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("prettyPrint")
  valid_580060 = validateParameter(valid_580060, JBool, required = false,
                                 default = newJBool(true))
  if valid_580060 != nil:
    section.add "prettyPrint", valid_580060
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580061: Call_DoubleclickbidmanagerQueriesDeletequery_580050;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a stored query as well as the associated stored reports.
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_DoubleclickbidmanagerQueriesDeletequery_580050;
          queryId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerQueriesDeletequery
  ## Deletes a stored query as well as the associated stored reports.
  ##   queryId: string (required)
  ##          : Query ID to delete.
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
  var path_580063 = newJObject()
  var query_580064 = newJObject()
  add(path_580063, "queryId", newJString(queryId))
  add(query_580064, "fields", newJString(fields))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(query_580064, "alt", newJString(alt))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(query_580064, "userIp", newJString(userIp))
  add(query_580064, "key", newJString(key))
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  result = call_580062.call(path_580063, query_580064, nil, nil, nil)

var doubleclickbidmanagerQueriesDeletequery* = Call_DoubleclickbidmanagerQueriesDeletequery_580050(
    name: "doubleclickbidmanagerQueriesDeletequery", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesDeletequery_580051,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesDeletequery_580052,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerSdfDownload_580065 = ref object of OpenApiRestCall_579408
proc url_DoubleclickbidmanagerSdfDownload_580067(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerSdfDownload_580066(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves entities in SDF format.
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
  var valid_580068 = query.getOrDefault("fields")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "fields", valid_580068
  var valid_580069 = query.getOrDefault("quotaUser")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "quotaUser", valid_580069
  var valid_580070 = query.getOrDefault("alt")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = newJString("json"))
  if valid_580070 != nil:
    section.add "alt", valid_580070
  var valid_580071 = query.getOrDefault("oauth_token")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "oauth_token", valid_580071
  var valid_580072 = query.getOrDefault("userIp")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "userIp", valid_580072
  var valid_580073 = query.getOrDefault("key")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "key", valid_580073
  var valid_580074 = query.getOrDefault("prettyPrint")
  valid_580074 = validateParameter(valid_580074, JBool, required = false,
                                 default = newJBool(true))
  if valid_580074 != nil:
    section.add "prettyPrint", valid_580074
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

proc call*(call_580076: Call_DoubleclickbidmanagerSdfDownload_580065;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves entities in SDF format.
  ## 
  let valid = call_580076.validator(path, query, header, formData, body)
  let scheme = call_580076.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580076.url(scheme.get, call_580076.host, call_580076.base,
                         call_580076.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580076, url, valid)

proc call*(call_580077: Call_DoubleclickbidmanagerSdfDownload_580065;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## doubleclickbidmanagerSdfDownload
  ## Retrieves entities in SDF format.
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
  var query_580078 = newJObject()
  var body_580079 = newJObject()
  add(query_580078, "fields", newJString(fields))
  add(query_580078, "quotaUser", newJString(quotaUser))
  add(query_580078, "alt", newJString(alt))
  add(query_580078, "oauth_token", newJString(oauthToken))
  add(query_580078, "userIp", newJString(userIp))
  add(query_580078, "key", newJString(key))
  if body != nil:
    body_580079 = body
  add(query_580078, "prettyPrint", newJBool(prettyPrint))
  result = call_580077.call(nil, query_580078, nil, nil, body_580079)

var doubleclickbidmanagerSdfDownload* = Call_DoubleclickbidmanagerSdfDownload_580065(
    name: "doubleclickbidmanagerSdfDownload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sdf/download",
    validator: validate_DoubleclickbidmanagerSdfDownload_580066,
    base: "/doubleclickbidmanager/v1", url: url_DoubleclickbidmanagerSdfDownload_580067,
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
