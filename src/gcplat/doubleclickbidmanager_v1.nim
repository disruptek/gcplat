
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

  OpenApiRestCall_578339 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578339](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578339): Option[Scheme] {.used.} =
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
  gcpServiceName = "doubleclickbidmanager"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_DoubleclickbidmanagerLineitemsDownloadlineitems_578609 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerLineitemsDownloadlineitems_578611(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsDownloadlineitems_578610(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves line items in CSV format. TrueView line items are not supported.
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
  var valid_578723 = query.getOrDefault("key")
  valid_578723 = validateParameter(valid_578723, JString, required = false,
                                 default = nil)
  if valid_578723 != nil:
    section.add "key", valid_578723
  var valid_578737 = query.getOrDefault("prettyPrint")
  valid_578737 = validateParameter(valid_578737, JBool, required = false,
                                 default = newJBool(true))
  if valid_578737 != nil:
    section.add "prettyPrint", valid_578737
  var valid_578738 = query.getOrDefault("oauth_token")
  valid_578738 = validateParameter(valid_578738, JString, required = false,
                                 default = nil)
  if valid_578738 != nil:
    section.add "oauth_token", valid_578738
  var valid_578739 = query.getOrDefault("alt")
  valid_578739 = validateParameter(valid_578739, JString, required = false,
                                 default = newJString("json"))
  if valid_578739 != nil:
    section.add "alt", valid_578739
  var valid_578740 = query.getOrDefault("userIp")
  valid_578740 = validateParameter(valid_578740, JString, required = false,
                                 default = nil)
  if valid_578740 != nil:
    section.add "userIp", valid_578740
  var valid_578741 = query.getOrDefault("quotaUser")
  valid_578741 = validateParameter(valid_578741, JString, required = false,
                                 default = nil)
  if valid_578741 != nil:
    section.add "quotaUser", valid_578741
  var valid_578742 = query.getOrDefault("fields")
  valid_578742 = validateParameter(valid_578742, JString, required = false,
                                 default = nil)
  if valid_578742 != nil:
    section.add "fields", valid_578742
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

proc call*(call_578766: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_578609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_578766.validator(path, query, header, formData, body)
  let scheme = call_578766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578766.url(scheme.get, call_578766.host, call_578766.base,
                         call_578766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578766, url, valid)

proc call*(call_578837: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_578609;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclickbidmanagerLineitemsDownloadlineitems
  ## Retrieves line items in CSV format. TrueView line items are not supported.
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
  var query_578838 = newJObject()
  var body_578840 = newJObject()
  add(query_578838, "key", newJString(key))
  add(query_578838, "prettyPrint", newJBool(prettyPrint))
  add(query_578838, "oauth_token", newJString(oauthToken))
  add(query_578838, "alt", newJString(alt))
  add(query_578838, "userIp", newJString(userIp))
  add(query_578838, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578840 = body
  add(query_578838, "fields", newJString(fields))
  result = call_578837.call(nil, query_578838, nil, nil, body_578840)

var doubleclickbidmanagerLineitemsDownloadlineitems* = Call_DoubleclickbidmanagerLineitemsDownloadlineitems_578609(
    name: "doubleclickbidmanagerLineitemsDownloadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/downloadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsDownloadlineitems_578610,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsDownloadlineitems_578611,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerLineitemsUploadlineitems_578879 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerLineitemsUploadlineitems_578881(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsUploadlineitems_578880(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Uploads line items in CSV format. TrueView line items are not supported.
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
  var valid_578882 = query.getOrDefault("key")
  valid_578882 = validateParameter(valid_578882, JString, required = false,
                                 default = nil)
  if valid_578882 != nil:
    section.add "key", valid_578882
  var valid_578883 = query.getOrDefault("prettyPrint")
  valid_578883 = validateParameter(valid_578883, JBool, required = false,
                                 default = newJBool(true))
  if valid_578883 != nil:
    section.add "prettyPrint", valid_578883
  var valid_578884 = query.getOrDefault("oauth_token")
  valid_578884 = validateParameter(valid_578884, JString, required = false,
                                 default = nil)
  if valid_578884 != nil:
    section.add "oauth_token", valid_578884
  var valid_578885 = query.getOrDefault("alt")
  valid_578885 = validateParameter(valid_578885, JString, required = false,
                                 default = newJString("json"))
  if valid_578885 != nil:
    section.add "alt", valid_578885
  var valid_578886 = query.getOrDefault("userIp")
  valid_578886 = validateParameter(valid_578886, JString, required = false,
                                 default = nil)
  if valid_578886 != nil:
    section.add "userIp", valid_578886
  var valid_578887 = query.getOrDefault("quotaUser")
  valid_578887 = validateParameter(valid_578887, JString, required = false,
                                 default = nil)
  if valid_578887 != nil:
    section.add "quotaUser", valid_578887
  var valid_578888 = query.getOrDefault("fields")
  valid_578888 = validateParameter(valid_578888, JString, required = false,
                                 default = nil)
  if valid_578888 != nil:
    section.add "fields", valid_578888
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

proc call*(call_578890: Call_DoubleclickbidmanagerLineitemsUploadlineitems_578879;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_578890.validator(path, query, header, formData, body)
  let scheme = call_578890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578890.url(scheme.get, call_578890.host, call_578890.base,
                         call_578890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578890, url, valid)

proc call*(call_578891: Call_DoubleclickbidmanagerLineitemsUploadlineitems_578879;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclickbidmanagerLineitemsUploadlineitems
  ## Uploads line items in CSV format. TrueView line items are not supported.
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
  var query_578892 = newJObject()
  var body_578893 = newJObject()
  add(query_578892, "key", newJString(key))
  add(query_578892, "prettyPrint", newJBool(prettyPrint))
  add(query_578892, "oauth_token", newJString(oauthToken))
  add(query_578892, "alt", newJString(alt))
  add(query_578892, "userIp", newJString(userIp))
  add(query_578892, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578893 = body
  add(query_578892, "fields", newJString(fields))
  result = call_578891.call(nil, query_578892, nil, nil, body_578893)

var doubleclickbidmanagerLineitemsUploadlineitems* = Call_DoubleclickbidmanagerLineitemsUploadlineitems_578879(
    name: "doubleclickbidmanagerLineitemsUploadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/uploadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsUploadlineitems_578880,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsUploadlineitems_578881,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesListqueries_578894 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerQueriesListqueries_578896(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerQueriesListqueries_578895(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves stored queries.
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
  var valid_578897 = query.getOrDefault("key")
  valid_578897 = validateParameter(valid_578897, JString, required = false,
                                 default = nil)
  if valid_578897 != nil:
    section.add "key", valid_578897
  var valid_578898 = query.getOrDefault("prettyPrint")
  valid_578898 = validateParameter(valid_578898, JBool, required = false,
                                 default = newJBool(true))
  if valid_578898 != nil:
    section.add "prettyPrint", valid_578898
  var valid_578899 = query.getOrDefault("oauth_token")
  valid_578899 = validateParameter(valid_578899, JString, required = false,
                                 default = nil)
  if valid_578899 != nil:
    section.add "oauth_token", valid_578899
  var valid_578900 = query.getOrDefault("alt")
  valid_578900 = validateParameter(valid_578900, JString, required = false,
                                 default = newJString("json"))
  if valid_578900 != nil:
    section.add "alt", valid_578900
  var valid_578901 = query.getOrDefault("userIp")
  valid_578901 = validateParameter(valid_578901, JString, required = false,
                                 default = nil)
  if valid_578901 != nil:
    section.add "userIp", valid_578901
  var valid_578902 = query.getOrDefault("quotaUser")
  valid_578902 = validateParameter(valid_578902, JString, required = false,
                                 default = nil)
  if valid_578902 != nil:
    section.add "quotaUser", valid_578902
  var valid_578903 = query.getOrDefault("fields")
  valid_578903 = validateParameter(valid_578903, JString, required = false,
                                 default = nil)
  if valid_578903 != nil:
    section.add "fields", valid_578903
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578904: Call_DoubleclickbidmanagerQueriesListqueries_578894;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored queries.
  ## 
  let valid = call_578904.validator(path, query, header, formData, body)
  let scheme = call_578904.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578904.url(scheme.get, call_578904.host, call_578904.base,
                         call_578904.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578904, url, valid)

proc call*(call_578905: Call_DoubleclickbidmanagerQueriesListqueries_578894;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## doubleclickbidmanagerQueriesListqueries
  ## Retrieves stored queries.
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
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_578906 = newJObject()
  add(query_578906, "key", newJString(key))
  add(query_578906, "prettyPrint", newJBool(prettyPrint))
  add(query_578906, "oauth_token", newJString(oauthToken))
  add(query_578906, "alt", newJString(alt))
  add(query_578906, "userIp", newJString(userIp))
  add(query_578906, "quotaUser", newJString(quotaUser))
  add(query_578906, "fields", newJString(fields))
  result = call_578905.call(nil, query_578906, nil, nil, nil)

var doubleclickbidmanagerQueriesListqueries* = Call_DoubleclickbidmanagerQueriesListqueries_578894(
    name: "doubleclickbidmanagerQueriesListqueries", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries",
    validator: validate_DoubleclickbidmanagerQueriesListqueries_578895,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesListqueries_578896,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerReportsListreports_578907 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerReportsListreports_578909(protocol: Scheme;
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

proc validate_DoubleclickbidmanagerReportsListreports_578908(path: JsonNode;
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
  var valid_578924 = path.getOrDefault("queryId")
  valid_578924 = validateParameter(valid_578924, JString, required = true,
                                 default = nil)
  if valid_578924 != nil:
    section.add "queryId", valid_578924
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
  var valid_578925 = query.getOrDefault("key")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "key", valid_578925
  var valid_578926 = query.getOrDefault("prettyPrint")
  valid_578926 = validateParameter(valid_578926, JBool, required = false,
                                 default = newJBool(true))
  if valid_578926 != nil:
    section.add "prettyPrint", valid_578926
  var valid_578927 = query.getOrDefault("oauth_token")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "oauth_token", valid_578927
  var valid_578928 = query.getOrDefault("alt")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = newJString("json"))
  if valid_578928 != nil:
    section.add "alt", valid_578928
  var valid_578929 = query.getOrDefault("userIp")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = nil)
  if valid_578929 != nil:
    section.add "userIp", valid_578929
  var valid_578930 = query.getOrDefault("quotaUser")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "quotaUser", valid_578930
  var valid_578931 = query.getOrDefault("fields")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = nil)
  if valid_578931 != nil:
    section.add "fields", valid_578931
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578932: Call_DoubleclickbidmanagerReportsListreports_578907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored reports.
  ## 
  let valid = call_578932.validator(path, query, header, formData, body)
  let scheme = call_578932.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578932.url(scheme.get, call_578932.host, call_578932.base,
                         call_578932.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578932, url, valid)

proc call*(call_578933: Call_DoubleclickbidmanagerReportsListreports_578907;
          queryId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## doubleclickbidmanagerReportsListreports
  ## Retrieves stored reports.
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
  ##   queryId: string (required)
  ##          : Query ID with which the reports are associated.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578934 = newJObject()
  var query_578935 = newJObject()
  add(query_578935, "key", newJString(key))
  add(query_578935, "prettyPrint", newJBool(prettyPrint))
  add(query_578935, "oauth_token", newJString(oauthToken))
  add(query_578935, "alt", newJString(alt))
  add(query_578935, "userIp", newJString(userIp))
  add(query_578935, "quotaUser", newJString(quotaUser))
  add(path_578934, "queryId", newJString(queryId))
  add(query_578935, "fields", newJString(fields))
  result = call_578933.call(path_578934, query_578935, nil, nil, nil)

var doubleclickbidmanagerReportsListreports* = Call_DoubleclickbidmanagerReportsListreports_578907(
    name: "doubleclickbidmanagerReportsListreports", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries/{queryId}/reports",
    validator: validate_DoubleclickbidmanagerReportsListreports_578908,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerReportsListreports_578909,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesCreatequery_578936 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerQueriesCreatequery_578938(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerQueriesCreatequery_578937(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a query.
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
  var valid_578939 = query.getOrDefault("key")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "key", valid_578939
  var valid_578940 = query.getOrDefault("prettyPrint")
  valid_578940 = validateParameter(valid_578940, JBool, required = false,
                                 default = newJBool(true))
  if valid_578940 != nil:
    section.add "prettyPrint", valid_578940
  var valid_578941 = query.getOrDefault("oauth_token")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "oauth_token", valid_578941
  var valid_578942 = query.getOrDefault("alt")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = newJString("json"))
  if valid_578942 != nil:
    section.add "alt", valid_578942
  var valid_578943 = query.getOrDefault("userIp")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "userIp", valid_578943
  var valid_578944 = query.getOrDefault("quotaUser")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "quotaUser", valid_578944
  var valid_578945 = query.getOrDefault("fields")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "fields", valid_578945
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

proc call*(call_578947: Call_DoubleclickbidmanagerQueriesCreatequery_578936;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a query.
  ## 
  let valid = call_578947.validator(path, query, header, formData, body)
  let scheme = call_578947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578947.url(scheme.get, call_578947.host, call_578947.base,
                         call_578947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578947, url, valid)

proc call*(call_578948: Call_DoubleclickbidmanagerQueriesCreatequery_578936;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclickbidmanagerQueriesCreatequery
  ## Creates a query.
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
  var query_578949 = newJObject()
  var body_578950 = newJObject()
  add(query_578949, "key", newJString(key))
  add(query_578949, "prettyPrint", newJBool(prettyPrint))
  add(query_578949, "oauth_token", newJString(oauthToken))
  add(query_578949, "alt", newJString(alt))
  add(query_578949, "userIp", newJString(userIp))
  add(query_578949, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578950 = body
  add(query_578949, "fields", newJString(fields))
  result = call_578948.call(nil, query_578949, nil, nil, body_578950)

var doubleclickbidmanagerQueriesCreatequery* = Call_DoubleclickbidmanagerQueriesCreatequery_578936(
    name: "doubleclickbidmanagerQueriesCreatequery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_DoubleclickbidmanagerQueriesCreatequery_578937,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesCreatequery_578938,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesRunquery_578966 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerQueriesRunquery_578968(protocol: Scheme;
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

proc validate_DoubleclickbidmanagerQueriesRunquery_578967(path: JsonNode;
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
  var valid_578969 = path.getOrDefault("queryId")
  valid_578969 = validateParameter(valid_578969, JString, required = true,
                                 default = nil)
  if valid_578969 != nil:
    section.add "queryId", valid_578969
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
  var valid_578970 = query.getOrDefault("key")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = nil)
  if valid_578970 != nil:
    section.add "key", valid_578970
  var valid_578971 = query.getOrDefault("prettyPrint")
  valid_578971 = validateParameter(valid_578971, JBool, required = false,
                                 default = newJBool(true))
  if valid_578971 != nil:
    section.add "prettyPrint", valid_578971
  var valid_578972 = query.getOrDefault("oauth_token")
  valid_578972 = validateParameter(valid_578972, JString, required = false,
                                 default = nil)
  if valid_578972 != nil:
    section.add "oauth_token", valid_578972
  var valid_578973 = query.getOrDefault("alt")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = newJString("json"))
  if valid_578973 != nil:
    section.add "alt", valid_578973
  var valid_578974 = query.getOrDefault("userIp")
  valid_578974 = validateParameter(valid_578974, JString, required = false,
                                 default = nil)
  if valid_578974 != nil:
    section.add "userIp", valid_578974
  var valid_578975 = query.getOrDefault("quotaUser")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "quotaUser", valid_578975
  var valid_578976 = query.getOrDefault("fields")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "fields", valid_578976
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

proc call*(call_578978: Call_DoubleclickbidmanagerQueriesRunquery_578966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a stored query to generate a report.
  ## 
  let valid = call_578978.validator(path, query, header, formData, body)
  let scheme = call_578978.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578978.url(scheme.get, call_578978.host, call_578978.base,
                         call_578978.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578978, url, valid)

proc call*(call_578979: Call_DoubleclickbidmanagerQueriesRunquery_578966;
          queryId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclickbidmanagerQueriesRunquery
  ## Runs a stored query to generate a report.
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
  ##   queryId: string (required)
  ##          : Query ID to run.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578980 = newJObject()
  var query_578981 = newJObject()
  var body_578982 = newJObject()
  add(query_578981, "key", newJString(key))
  add(query_578981, "prettyPrint", newJBool(prettyPrint))
  add(query_578981, "oauth_token", newJString(oauthToken))
  add(query_578981, "alt", newJString(alt))
  add(query_578981, "userIp", newJString(userIp))
  add(query_578981, "quotaUser", newJString(quotaUser))
  add(path_578980, "queryId", newJString(queryId))
  if body != nil:
    body_578982 = body
  add(query_578981, "fields", newJString(fields))
  result = call_578979.call(path_578980, query_578981, nil, nil, body_578982)

var doubleclickbidmanagerQueriesRunquery* = Call_DoubleclickbidmanagerQueriesRunquery_578966(
    name: "doubleclickbidmanagerQueriesRunquery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesRunquery_578967,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesRunquery_578968, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesGetquery_578951 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerQueriesGetquery_578953(protocol: Scheme;
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

proc validate_DoubleclickbidmanagerQueriesGetquery_578952(path: JsonNode;
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
  var valid_578954 = path.getOrDefault("queryId")
  valid_578954 = validateParameter(valid_578954, JString, required = true,
                                 default = nil)
  if valid_578954 != nil:
    section.add "queryId", valid_578954
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
  var valid_578955 = query.getOrDefault("key")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "key", valid_578955
  var valid_578956 = query.getOrDefault("prettyPrint")
  valid_578956 = validateParameter(valid_578956, JBool, required = false,
                                 default = newJBool(true))
  if valid_578956 != nil:
    section.add "prettyPrint", valid_578956
  var valid_578957 = query.getOrDefault("oauth_token")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "oauth_token", valid_578957
  var valid_578958 = query.getOrDefault("alt")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = newJString("json"))
  if valid_578958 != nil:
    section.add "alt", valid_578958
  var valid_578959 = query.getOrDefault("userIp")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "userIp", valid_578959
  var valid_578960 = query.getOrDefault("quotaUser")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "quotaUser", valid_578960
  var valid_578961 = query.getOrDefault("fields")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "fields", valid_578961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578962: Call_DoubleclickbidmanagerQueriesGetquery_578951;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a stored query.
  ## 
  let valid = call_578962.validator(path, query, header, formData, body)
  let scheme = call_578962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578962.url(scheme.get, call_578962.host, call_578962.base,
                         call_578962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578962, url, valid)

proc call*(call_578963: Call_DoubleclickbidmanagerQueriesGetquery_578951;
          queryId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## doubleclickbidmanagerQueriesGetquery
  ## Retrieves a stored query.
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
  ##   queryId: string (required)
  ##          : Query ID to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578964 = newJObject()
  var query_578965 = newJObject()
  add(query_578965, "key", newJString(key))
  add(query_578965, "prettyPrint", newJBool(prettyPrint))
  add(query_578965, "oauth_token", newJString(oauthToken))
  add(query_578965, "alt", newJString(alt))
  add(query_578965, "userIp", newJString(userIp))
  add(query_578965, "quotaUser", newJString(quotaUser))
  add(path_578964, "queryId", newJString(queryId))
  add(query_578965, "fields", newJString(fields))
  result = call_578963.call(path_578964, query_578965, nil, nil, nil)

var doubleclickbidmanagerQueriesGetquery* = Call_DoubleclickbidmanagerQueriesGetquery_578951(
    name: "doubleclickbidmanagerQueriesGetquery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesGetquery_578952,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesGetquery_578953, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesDeletequery_578983 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerQueriesDeletequery_578985(protocol: Scheme;
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

proc validate_DoubleclickbidmanagerQueriesDeletequery_578984(path: JsonNode;
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
  var valid_578986 = path.getOrDefault("queryId")
  valid_578986 = validateParameter(valid_578986, JString, required = true,
                                 default = nil)
  if valid_578986 != nil:
    section.add "queryId", valid_578986
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
  var valid_578987 = query.getOrDefault("key")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "key", valid_578987
  var valid_578988 = query.getOrDefault("prettyPrint")
  valid_578988 = validateParameter(valid_578988, JBool, required = false,
                                 default = newJBool(true))
  if valid_578988 != nil:
    section.add "prettyPrint", valid_578988
  var valid_578989 = query.getOrDefault("oauth_token")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "oauth_token", valid_578989
  var valid_578990 = query.getOrDefault("alt")
  valid_578990 = validateParameter(valid_578990, JString, required = false,
                                 default = newJString("json"))
  if valid_578990 != nil:
    section.add "alt", valid_578990
  var valid_578991 = query.getOrDefault("userIp")
  valid_578991 = validateParameter(valid_578991, JString, required = false,
                                 default = nil)
  if valid_578991 != nil:
    section.add "userIp", valid_578991
  var valid_578992 = query.getOrDefault("quotaUser")
  valid_578992 = validateParameter(valid_578992, JString, required = false,
                                 default = nil)
  if valid_578992 != nil:
    section.add "quotaUser", valid_578992
  var valid_578993 = query.getOrDefault("fields")
  valid_578993 = validateParameter(valid_578993, JString, required = false,
                                 default = nil)
  if valid_578993 != nil:
    section.add "fields", valid_578993
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578994: Call_DoubleclickbidmanagerQueriesDeletequery_578983;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a stored query as well as the associated stored reports.
  ## 
  let valid = call_578994.validator(path, query, header, formData, body)
  let scheme = call_578994.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578994.url(scheme.get, call_578994.host, call_578994.base,
                         call_578994.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578994, url, valid)

proc call*(call_578995: Call_DoubleclickbidmanagerQueriesDeletequery_578983;
          queryId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## doubleclickbidmanagerQueriesDeletequery
  ## Deletes a stored query as well as the associated stored reports.
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
  ##   queryId: string (required)
  ##          : Query ID to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_578996 = newJObject()
  var query_578997 = newJObject()
  add(query_578997, "key", newJString(key))
  add(query_578997, "prettyPrint", newJBool(prettyPrint))
  add(query_578997, "oauth_token", newJString(oauthToken))
  add(query_578997, "alt", newJString(alt))
  add(query_578997, "userIp", newJString(userIp))
  add(query_578997, "quotaUser", newJString(quotaUser))
  add(path_578996, "queryId", newJString(queryId))
  add(query_578997, "fields", newJString(fields))
  result = call_578995.call(path_578996, query_578997, nil, nil, nil)

var doubleclickbidmanagerQueriesDeletequery* = Call_DoubleclickbidmanagerQueriesDeletequery_578983(
    name: "doubleclickbidmanagerQueriesDeletequery", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesDeletequery_578984,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesDeletequery_578985,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerSdfDownload_578998 = ref object of OpenApiRestCall_578339
proc url_DoubleclickbidmanagerSdfDownload_579000(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DoubleclickbidmanagerSdfDownload_578999(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves entities in SDF format.
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
  var valid_579001 = query.getOrDefault("key")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "key", valid_579001
  var valid_579002 = query.getOrDefault("prettyPrint")
  valid_579002 = validateParameter(valid_579002, JBool, required = false,
                                 default = newJBool(true))
  if valid_579002 != nil:
    section.add "prettyPrint", valid_579002
  var valid_579003 = query.getOrDefault("oauth_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "oauth_token", valid_579003
  var valid_579004 = query.getOrDefault("alt")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = newJString("json"))
  if valid_579004 != nil:
    section.add "alt", valid_579004
  var valid_579005 = query.getOrDefault("userIp")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "userIp", valid_579005
  var valid_579006 = query.getOrDefault("quotaUser")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "quotaUser", valid_579006
  var valid_579007 = query.getOrDefault("fields")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "fields", valid_579007
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

proc call*(call_579009: Call_DoubleclickbidmanagerSdfDownload_578998;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves entities in SDF format.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_DoubleclickbidmanagerSdfDownload_578998;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## doubleclickbidmanagerSdfDownload
  ## Retrieves entities in SDF format.
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
  var query_579011 = newJObject()
  var body_579012 = newJObject()
  add(query_579011, "key", newJString(key))
  add(query_579011, "prettyPrint", newJBool(prettyPrint))
  add(query_579011, "oauth_token", newJString(oauthToken))
  add(query_579011, "alt", newJString(alt))
  add(query_579011, "userIp", newJString(userIp))
  add(query_579011, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579012 = body
  add(query_579011, "fields", newJString(fields))
  result = call_579010.call(nil, query_579011, nil, nil, body_579012)

var doubleclickbidmanagerSdfDownload* = Call_DoubleclickbidmanagerSdfDownload_578998(
    name: "doubleclickbidmanagerSdfDownload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sdf/download",
    validator: validate_DoubleclickbidmanagerSdfDownload_578999,
    base: "/doubleclickbidmanager/v1", url: url_DoubleclickbidmanagerSdfDownload_579000,
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
