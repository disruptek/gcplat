
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

  OpenApiRestCall_588441 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588441](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588441): Option[Scheme] {.used.} =
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
  gcpServiceName = "doubleclickbidmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DoubleclickbidmanagerLineitemsDownloadlineitems_588709 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerLineitemsDownloadlineitems_588711(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsDownloadlineitems_588710(
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
  var valid_588823 = query.getOrDefault("fields")
  valid_588823 = validateParameter(valid_588823, JString, required = false,
                                 default = nil)
  if valid_588823 != nil:
    section.add "fields", valid_588823
  var valid_588824 = query.getOrDefault("quotaUser")
  valid_588824 = validateParameter(valid_588824, JString, required = false,
                                 default = nil)
  if valid_588824 != nil:
    section.add "quotaUser", valid_588824
  var valid_588838 = query.getOrDefault("alt")
  valid_588838 = validateParameter(valid_588838, JString, required = false,
                                 default = newJString("json"))
  if valid_588838 != nil:
    section.add "alt", valid_588838
  var valid_588839 = query.getOrDefault("oauth_token")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "oauth_token", valid_588839
  var valid_588840 = query.getOrDefault("userIp")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "userIp", valid_588840
  var valid_588841 = query.getOrDefault("key")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "key", valid_588841
  var valid_588842 = query.getOrDefault("prettyPrint")
  valid_588842 = validateParameter(valid_588842, JBool, required = false,
                                 default = newJBool(true))
  if valid_588842 != nil:
    section.add "prettyPrint", valid_588842
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

proc call*(call_588866: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_588709;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_588866.validator(path, query, header, formData, body)
  let scheme = call_588866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588866.url(scheme.get, call_588866.host, call_588866.base,
                         call_588866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588866, url, valid)

proc call*(call_588937: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_588709;
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
  var query_588938 = newJObject()
  var body_588940 = newJObject()
  add(query_588938, "fields", newJString(fields))
  add(query_588938, "quotaUser", newJString(quotaUser))
  add(query_588938, "alt", newJString(alt))
  add(query_588938, "oauth_token", newJString(oauthToken))
  add(query_588938, "userIp", newJString(userIp))
  add(query_588938, "key", newJString(key))
  if body != nil:
    body_588940 = body
  add(query_588938, "prettyPrint", newJBool(prettyPrint))
  result = call_588937.call(nil, query_588938, nil, nil, body_588940)

var doubleclickbidmanagerLineitemsDownloadlineitems* = Call_DoubleclickbidmanagerLineitemsDownloadlineitems_588709(
    name: "doubleclickbidmanagerLineitemsDownloadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/downloadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsDownloadlineitems_588710,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsDownloadlineitems_588711,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerLineitemsUploadlineitems_588979 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerLineitemsUploadlineitems_588981(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsUploadlineitems_588980(
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
  var valid_588982 = query.getOrDefault("fields")
  valid_588982 = validateParameter(valid_588982, JString, required = false,
                                 default = nil)
  if valid_588982 != nil:
    section.add "fields", valid_588982
  var valid_588983 = query.getOrDefault("quotaUser")
  valid_588983 = validateParameter(valid_588983, JString, required = false,
                                 default = nil)
  if valid_588983 != nil:
    section.add "quotaUser", valid_588983
  var valid_588984 = query.getOrDefault("alt")
  valid_588984 = validateParameter(valid_588984, JString, required = false,
                                 default = newJString("json"))
  if valid_588984 != nil:
    section.add "alt", valid_588984
  var valid_588985 = query.getOrDefault("oauth_token")
  valid_588985 = validateParameter(valid_588985, JString, required = false,
                                 default = nil)
  if valid_588985 != nil:
    section.add "oauth_token", valid_588985
  var valid_588986 = query.getOrDefault("userIp")
  valid_588986 = validateParameter(valid_588986, JString, required = false,
                                 default = nil)
  if valid_588986 != nil:
    section.add "userIp", valid_588986
  var valid_588987 = query.getOrDefault("key")
  valid_588987 = validateParameter(valid_588987, JString, required = false,
                                 default = nil)
  if valid_588987 != nil:
    section.add "key", valid_588987
  var valid_588988 = query.getOrDefault("prettyPrint")
  valid_588988 = validateParameter(valid_588988, JBool, required = false,
                                 default = newJBool(true))
  if valid_588988 != nil:
    section.add "prettyPrint", valid_588988
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

proc call*(call_588990: Call_DoubleclickbidmanagerLineitemsUploadlineitems_588979;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_588990.validator(path, query, header, formData, body)
  let scheme = call_588990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588990.url(scheme.get, call_588990.host, call_588990.base,
                         call_588990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588990, url, valid)

proc call*(call_588991: Call_DoubleclickbidmanagerLineitemsUploadlineitems_588979;
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
  var query_588992 = newJObject()
  var body_588993 = newJObject()
  add(query_588992, "fields", newJString(fields))
  add(query_588992, "quotaUser", newJString(quotaUser))
  add(query_588992, "alt", newJString(alt))
  add(query_588992, "oauth_token", newJString(oauthToken))
  add(query_588992, "userIp", newJString(userIp))
  add(query_588992, "key", newJString(key))
  if body != nil:
    body_588993 = body
  add(query_588992, "prettyPrint", newJBool(prettyPrint))
  result = call_588991.call(nil, query_588992, nil, nil, body_588993)

var doubleclickbidmanagerLineitemsUploadlineitems* = Call_DoubleclickbidmanagerLineitemsUploadlineitems_588979(
    name: "doubleclickbidmanagerLineitemsUploadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/uploadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsUploadlineitems_588980,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsUploadlineitems_588981,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesListqueries_588994 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerQueriesListqueries_588996(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerQueriesListqueries_588995(path: JsonNode;
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
  var valid_588997 = query.getOrDefault("fields")
  valid_588997 = validateParameter(valid_588997, JString, required = false,
                                 default = nil)
  if valid_588997 != nil:
    section.add "fields", valid_588997
  var valid_588998 = query.getOrDefault("quotaUser")
  valid_588998 = validateParameter(valid_588998, JString, required = false,
                                 default = nil)
  if valid_588998 != nil:
    section.add "quotaUser", valid_588998
  var valid_588999 = query.getOrDefault("alt")
  valid_588999 = validateParameter(valid_588999, JString, required = false,
                                 default = newJString("json"))
  if valid_588999 != nil:
    section.add "alt", valid_588999
  var valid_589000 = query.getOrDefault("oauth_token")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "oauth_token", valid_589000
  var valid_589001 = query.getOrDefault("userIp")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "userIp", valid_589001
  var valid_589002 = query.getOrDefault("key")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = nil)
  if valid_589002 != nil:
    section.add "key", valid_589002
  var valid_589003 = query.getOrDefault("prettyPrint")
  valid_589003 = validateParameter(valid_589003, JBool, required = false,
                                 default = newJBool(true))
  if valid_589003 != nil:
    section.add "prettyPrint", valid_589003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589004: Call_DoubleclickbidmanagerQueriesListqueries_588994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored queries.
  ## 
  let valid = call_589004.validator(path, query, header, formData, body)
  let scheme = call_589004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589004.url(scheme.get, call_589004.host, call_589004.base,
                         call_589004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589004, url, valid)

proc call*(call_589005: Call_DoubleclickbidmanagerQueriesListqueries_588994;
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
  var query_589006 = newJObject()
  add(query_589006, "fields", newJString(fields))
  add(query_589006, "quotaUser", newJString(quotaUser))
  add(query_589006, "alt", newJString(alt))
  add(query_589006, "oauth_token", newJString(oauthToken))
  add(query_589006, "userIp", newJString(userIp))
  add(query_589006, "key", newJString(key))
  add(query_589006, "prettyPrint", newJBool(prettyPrint))
  result = call_589005.call(nil, query_589006, nil, nil, nil)

var doubleclickbidmanagerQueriesListqueries* = Call_DoubleclickbidmanagerQueriesListqueries_588994(
    name: "doubleclickbidmanagerQueriesListqueries", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries",
    validator: validate_DoubleclickbidmanagerQueriesListqueries_588995,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesListqueries_588996,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerReportsListreports_589007 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerReportsListreports_589009(protocol: Scheme;
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

proc validate_DoubleclickbidmanagerReportsListreports_589008(path: JsonNode;
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
  var valid_589024 = path.getOrDefault("queryId")
  valid_589024 = validateParameter(valid_589024, JString, required = true,
                                 default = nil)
  if valid_589024 != nil:
    section.add "queryId", valid_589024
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
  var valid_589025 = query.getOrDefault("fields")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = nil)
  if valid_589025 != nil:
    section.add "fields", valid_589025
  var valid_589026 = query.getOrDefault("quotaUser")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "quotaUser", valid_589026
  var valid_589027 = query.getOrDefault("alt")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = newJString("json"))
  if valid_589027 != nil:
    section.add "alt", valid_589027
  var valid_589028 = query.getOrDefault("oauth_token")
  valid_589028 = validateParameter(valid_589028, JString, required = false,
                                 default = nil)
  if valid_589028 != nil:
    section.add "oauth_token", valid_589028
  var valid_589029 = query.getOrDefault("userIp")
  valid_589029 = validateParameter(valid_589029, JString, required = false,
                                 default = nil)
  if valid_589029 != nil:
    section.add "userIp", valid_589029
  var valid_589030 = query.getOrDefault("key")
  valid_589030 = validateParameter(valid_589030, JString, required = false,
                                 default = nil)
  if valid_589030 != nil:
    section.add "key", valid_589030
  var valid_589031 = query.getOrDefault("prettyPrint")
  valid_589031 = validateParameter(valid_589031, JBool, required = false,
                                 default = newJBool(true))
  if valid_589031 != nil:
    section.add "prettyPrint", valid_589031
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589032: Call_DoubleclickbidmanagerReportsListreports_589007;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored reports.
  ## 
  let valid = call_589032.validator(path, query, header, formData, body)
  let scheme = call_589032.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589032.url(scheme.get, call_589032.host, call_589032.base,
                         call_589032.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589032, url, valid)

proc call*(call_589033: Call_DoubleclickbidmanagerReportsListreports_589007;
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
  var path_589034 = newJObject()
  var query_589035 = newJObject()
  add(path_589034, "queryId", newJString(queryId))
  add(query_589035, "fields", newJString(fields))
  add(query_589035, "quotaUser", newJString(quotaUser))
  add(query_589035, "alt", newJString(alt))
  add(query_589035, "oauth_token", newJString(oauthToken))
  add(query_589035, "userIp", newJString(userIp))
  add(query_589035, "key", newJString(key))
  add(query_589035, "prettyPrint", newJBool(prettyPrint))
  result = call_589033.call(path_589034, query_589035, nil, nil, nil)

var doubleclickbidmanagerReportsListreports* = Call_DoubleclickbidmanagerReportsListreports_589007(
    name: "doubleclickbidmanagerReportsListreports", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries/{queryId}/reports",
    validator: validate_DoubleclickbidmanagerReportsListreports_589008,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerReportsListreports_589009,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesCreatequery_589036 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerQueriesCreatequery_589038(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerQueriesCreatequery_589037(path: JsonNode;
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
  var valid_589039 = query.getOrDefault("fields")
  valid_589039 = validateParameter(valid_589039, JString, required = false,
                                 default = nil)
  if valid_589039 != nil:
    section.add "fields", valid_589039
  var valid_589040 = query.getOrDefault("quotaUser")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "quotaUser", valid_589040
  var valid_589041 = query.getOrDefault("alt")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = newJString("json"))
  if valid_589041 != nil:
    section.add "alt", valid_589041
  var valid_589042 = query.getOrDefault("oauth_token")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = nil)
  if valid_589042 != nil:
    section.add "oauth_token", valid_589042
  var valid_589043 = query.getOrDefault("userIp")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "userIp", valid_589043
  var valid_589044 = query.getOrDefault("key")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "key", valid_589044
  var valid_589045 = query.getOrDefault("prettyPrint")
  valid_589045 = validateParameter(valid_589045, JBool, required = false,
                                 default = newJBool(true))
  if valid_589045 != nil:
    section.add "prettyPrint", valid_589045
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

proc call*(call_589047: Call_DoubleclickbidmanagerQueriesCreatequery_589036;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a query.
  ## 
  let valid = call_589047.validator(path, query, header, formData, body)
  let scheme = call_589047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589047.url(scheme.get, call_589047.host, call_589047.base,
                         call_589047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589047, url, valid)

proc call*(call_589048: Call_DoubleclickbidmanagerQueriesCreatequery_589036;
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
  var query_589049 = newJObject()
  var body_589050 = newJObject()
  add(query_589049, "fields", newJString(fields))
  add(query_589049, "quotaUser", newJString(quotaUser))
  add(query_589049, "alt", newJString(alt))
  add(query_589049, "oauth_token", newJString(oauthToken))
  add(query_589049, "userIp", newJString(userIp))
  add(query_589049, "key", newJString(key))
  if body != nil:
    body_589050 = body
  add(query_589049, "prettyPrint", newJBool(prettyPrint))
  result = call_589048.call(nil, query_589049, nil, nil, body_589050)

var doubleclickbidmanagerQueriesCreatequery* = Call_DoubleclickbidmanagerQueriesCreatequery_589036(
    name: "doubleclickbidmanagerQueriesCreatequery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_DoubleclickbidmanagerQueriesCreatequery_589037,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesCreatequery_589038,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesRunquery_589066 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerQueriesRunquery_589068(protocol: Scheme;
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

proc validate_DoubleclickbidmanagerQueriesRunquery_589067(path: JsonNode;
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
  var valid_589069 = path.getOrDefault("queryId")
  valid_589069 = validateParameter(valid_589069, JString, required = true,
                                 default = nil)
  if valid_589069 != nil:
    section.add "queryId", valid_589069
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
  var valid_589070 = query.getOrDefault("fields")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "fields", valid_589070
  var valid_589071 = query.getOrDefault("quotaUser")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "quotaUser", valid_589071
  var valid_589072 = query.getOrDefault("alt")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("json"))
  if valid_589072 != nil:
    section.add "alt", valid_589072
  var valid_589073 = query.getOrDefault("oauth_token")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "oauth_token", valid_589073
  var valid_589074 = query.getOrDefault("userIp")
  valid_589074 = validateParameter(valid_589074, JString, required = false,
                                 default = nil)
  if valid_589074 != nil:
    section.add "userIp", valid_589074
  var valid_589075 = query.getOrDefault("key")
  valid_589075 = validateParameter(valid_589075, JString, required = false,
                                 default = nil)
  if valid_589075 != nil:
    section.add "key", valid_589075
  var valid_589076 = query.getOrDefault("prettyPrint")
  valid_589076 = validateParameter(valid_589076, JBool, required = false,
                                 default = newJBool(true))
  if valid_589076 != nil:
    section.add "prettyPrint", valid_589076
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

proc call*(call_589078: Call_DoubleclickbidmanagerQueriesRunquery_589066;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a stored query to generate a report.
  ## 
  let valid = call_589078.validator(path, query, header, formData, body)
  let scheme = call_589078.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589078.url(scheme.get, call_589078.host, call_589078.base,
                         call_589078.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589078, url, valid)

proc call*(call_589079: Call_DoubleclickbidmanagerQueriesRunquery_589066;
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
  var path_589080 = newJObject()
  var query_589081 = newJObject()
  var body_589082 = newJObject()
  add(path_589080, "queryId", newJString(queryId))
  add(query_589081, "fields", newJString(fields))
  add(query_589081, "quotaUser", newJString(quotaUser))
  add(query_589081, "alt", newJString(alt))
  add(query_589081, "oauth_token", newJString(oauthToken))
  add(query_589081, "userIp", newJString(userIp))
  add(query_589081, "key", newJString(key))
  if body != nil:
    body_589082 = body
  add(query_589081, "prettyPrint", newJBool(prettyPrint))
  result = call_589079.call(path_589080, query_589081, nil, nil, body_589082)

var doubleclickbidmanagerQueriesRunquery* = Call_DoubleclickbidmanagerQueriesRunquery_589066(
    name: "doubleclickbidmanagerQueriesRunquery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesRunquery_589067,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesRunquery_589068, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesGetquery_589051 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerQueriesGetquery_589053(protocol: Scheme;
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

proc validate_DoubleclickbidmanagerQueriesGetquery_589052(path: JsonNode;
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
  var valid_589054 = path.getOrDefault("queryId")
  valid_589054 = validateParameter(valid_589054, JString, required = true,
                                 default = nil)
  if valid_589054 != nil:
    section.add "queryId", valid_589054
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
  var valid_589055 = query.getOrDefault("fields")
  valid_589055 = validateParameter(valid_589055, JString, required = false,
                                 default = nil)
  if valid_589055 != nil:
    section.add "fields", valid_589055
  var valid_589056 = query.getOrDefault("quotaUser")
  valid_589056 = validateParameter(valid_589056, JString, required = false,
                                 default = nil)
  if valid_589056 != nil:
    section.add "quotaUser", valid_589056
  var valid_589057 = query.getOrDefault("alt")
  valid_589057 = validateParameter(valid_589057, JString, required = false,
                                 default = newJString("json"))
  if valid_589057 != nil:
    section.add "alt", valid_589057
  var valid_589058 = query.getOrDefault("oauth_token")
  valid_589058 = validateParameter(valid_589058, JString, required = false,
                                 default = nil)
  if valid_589058 != nil:
    section.add "oauth_token", valid_589058
  var valid_589059 = query.getOrDefault("userIp")
  valid_589059 = validateParameter(valid_589059, JString, required = false,
                                 default = nil)
  if valid_589059 != nil:
    section.add "userIp", valid_589059
  var valid_589060 = query.getOrDefault("key")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "key", valid_589060
  var valid_589061 = query.getOrDefault("prettyPrint")
  valid_589061 = validateParameter(valid_589061, JBool, required = false,
                                 default = newJBool(true))
  if valid_589061 != nil:
    section.add "prettyPrint", valid_589061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589062: Call_DoubleclickbidmanagerQueriesGetquery_589051;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a stored query.
  ## 
  let valid = call_589062.validator(path, query, header, formData, body)
  let scheme = call_589062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589062.url(scheme.get, call_589062.host, call_589062.base,
                         call_589062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589062, url, valid)

proc call*(call_589063: Call_DoubleclickbidmanagerQueriesGetquery_589051;
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
  var path_589064 = newJObject()
  var query_589065 = newJObject()
  add(path_589064, "queryId", newJString(queryId))
  add(query_589065, "fields", newJString(fields))
  add(query_589065, "quotaUser", newJString(quotaUser))
  add(query_589065, "alt", newJString(alt))
  add(query_589065, "oauth_token", newJString(oauthToken))
  add(query_589065, "userIp", newJString(userIp))
  add(query_589065, "key", newJString(key))
  add(query_589065, "prettyPrint", newJBool(prettyPrint))
  result = call_589063.call(path_589064, query_589065, nil, nil, nil)

var doubleclickbidmanagerQueriesGetquery* = Call_DoubleclickbidmanagerQueriesGetquery_589051(
    name: "doubleclickbidmanagerQueriesGetquery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesGetquery_589052,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesGetquery_589053, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesDeletequery_589083 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerQueriesDeletequery_589085(protocol: Scheme;
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

proc validate_DoubleclickbidmanagerQueriesDeletequery_589084(path: JsonNode;
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
  var valid_589086 = path.getOrDefault("queryId")
  valid_589086 = validateParameter(valid_589086, JString, required = true,
                                 default = nil)
  if valid_589086 != nil:
    section.add "queryId", valid_589086
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
  var valid_589087 = query.getOrDefault("fields")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "fields", valid_589087
  var valid_589088 = query.getOrDefault("quotaUser")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "quotaUser", valid_589088
  var valid_589089 = query.getOrDefault("alt")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = newJString("json"))
  if valid_589089 != nil:
    section.add "alt", valid_589089
  var valid_589090 = query.getOrDefault("oauth_token")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "oauth_token", valid_589090
  var valid_589091 = query.getOrDefault("userIp")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "userIp", valid_589091
  var valid_589092 = query.getOrDefault("key")
  valid_589092 = validateParameter(valid_589092, JString, required = false,
                                 default = nil)
  if valid_589092 != nil:
    section.add "key", valid_589092
  var valid_589093 = query.getOrDefault("prettyPrint")
  valid_589093 = validateParameter(valid_589093, JBool, required = false,
                                 default = newJBool(true))
  if valid_589093 != nil:
    section.add "prettyPrint", valid_589093
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589094: Call_DoubleclickbidmanagerQueriesDeletequery_589083;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a stored query as well as the associated stored reports.
  ## 
  let valid = call_589094.validator(path, query, header, formData, body)
  let scheme = call_589094.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589094.url(scheme.get, call_589094.host, call_589094.base,
                         call_589094.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589094, url, valid)

proc call*(call_589095: Call_DoubleclickbidmanagerQueriesDeletequery_589083;
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
  var path_589096 = newJObject()
  var query_589097 = newJObject()
  add(path_589096, "queryId", newJString(queryId))
  add(query_589097, "fields", newJString(fields))
  add(query_589097, "quotaUser", newJString(quotaUser))
  add(query_589097, "alt", newJString(alt))
  add(query_589097, "oauth_token", newJString(oauthToken))
  add(query_589097, "userIp", newJString(userIp))
  add(query_589097, "key", newJString(key))
  add(query_589097, "prettyPrint", newJBool(prettyPrint))
  result = call_589095.call(path_589096, query_589097, nil, nil, nil)

var doubleclickbidmanagerQueriesDeletequery* = Call_DoubleclickbidmanagerQueriesDeletequery_589083(
    name: "doubleclickbidmanagerQueriesDeletequery", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesDeletequery_589084,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesDeletequery_589085,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerSdfDownload_589098 = ref object of OpenApiRestCall_588441
proc url_DoubleclickbidmanagerSdfDownload_589100(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerSdfDownload_589099(path: JsonNode;
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
  var valid_589101 = query.getOrDefault("fields")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "fields", valid_589101
  var valid_589102 = query.getOrDefault("quotaUser")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "quotaUser", valid_589102
  var valid_589103 = query.getOrDefault("alt")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = newJString("json"))
  if valid_589103 != nil:
    section.add "alt", valid_589103
  var valid_589104 = query.getOrDefault("oauth_token")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "oauth_token", valid_589104
  var valid_589105 = query.getOrDefault("userIp")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "userIp", valid_589105
  var valid_589106 = query.getOrDefault("key")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "key", valid_589106
  var valid_589107 = query.getOrDefault("prettyPrint")
  valid_589107 = validateParameter(valid_589107, JBool, required = false,
                                 default = newJBool(true))
  if valid_589107 != nil:
    section.add "prettyPrint", valid_589107
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

proc call*(call_589109: Call_DoubleclickbidmanagerSdfDownload_589098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves entities in SDF format.
  ## 
  let valid = call_589109.validator(path, query, header, formData, body)
  let scheme = call_589109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589109.url(scheme.get, call_589109.host, call_589109.base,
                         call_589109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589109, url, valid)

proc call*(call_589110: Call_DoubleclickbidmanagerSdfDownload_589098;
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
  var query_589111 = newJObject()
  var body_589112 = newJObject()
  add(query_589111, "fields", newJString(fields))
  add(query_589111, "quotaUser", newJString(quotaUser))
  add(query_589111, "alt", newJString(alt))
  add(query_589111, "oauth_token", newJString(oauthToken))
  add(query_589111, "userIp", newJString(userIp))
  add(query_589111, "key", newJString(key))
  if body != nil:
    body_589112 = body
  add(query_589111, "prettyPrint", newJBool(prettyPrint))
  result = call_589110.call(nil, query_589111, nil, nil, body_589112)

var doubleclickbidmanagerSdfDownload* = Call_DoubleclickbidmanagerSdfDownload_589098(
    name: "doubleclickbidmanagerSdfDownload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sdf/download",
    validator: validate_DoubleclickbidmanagerSdfDownload_589099,
    base: "/doubleclickbidmanager/v1", url: url_DoubleclickbidmanagerSdfDownload_589100,
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
