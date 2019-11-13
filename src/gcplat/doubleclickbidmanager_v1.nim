
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

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

  OpenApiRestCall_579364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579364): Option[Scheme] {.used.} =
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
  Call_DoubleclickbidmanagerLineitemsDownloadlineitems_579634 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerLineitemsDownloadlineitems_579636(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsDownloadlineitems_579635(
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
  var valid_579748 = query.getOrDefault("key")
  valid_579748 = validateParameter(valid_579748, JString, required = false,
                                 default = nil)
  if valid_579748 != nil:
    section.add "key", valid_579748
  var valid_579762 = query.getOrDefault("prettyPrint")
  valid_579762 = validateParameter(valid_579762, JBool, required = false,
                                 default = newJBool(true))
  if valid_579762 != nil:
    section.add "prettyPrint", valid_579762
  var valid_579763 = query.getOrDefault("oauth_token")
  valid_579763 = validateParameter(valid_579763, JString, required = false,
                                 default = nil)
  if valid_579763 != nil:
    section.add "oauth_token", valid_579763
  var valid_579764 = query.getOrDefault("alt")
  valid_579764 = validateParameter(valid_579764, JString, required = false,
                                 default = newJString("json"))
  if valid_579764 != nil:
    section.add "alt", valid_579764
  var valid_579765 = query.getOrDefault("userIp")
  valid_579765 = validateParameter(valid_579765, JString, required = false,
                                 default = nil)
  if valid_579765 != nil:
    section.add "userIp", valid_579765
  var valid_579766 = query.getOrDefault("quotaUser")
  valid_579766 = validateParameter(valid_579766, JString, required = false,
                                 default = nil)
  if valid_579766 != nil:
    section.add "quotaUser", valid_579766
  var valid_579767 = query.getOrDefault("fields")
  valid_579767 = validateParameter(valid_579767, JString, required = false,
                                 default = nil)
  if valid_579767 != nil:
    section.add "fields", valid_579767
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

proc call*(call_579791: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_579634;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_579791.validator(path, query, header, formData, body)
  let scheme = call_579791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579791.url(scheme.get, call_579791.host, call_579791.base,
                         call_579791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579791, url, valid)

proc call*(call_579862: Call_DoubleclickbidmanagerLineitemsDownloadlineitems_579634;
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
  var query_579863 = newJObject()
  var body_579865 = newJObject()
  add(query_579863, "key", newJString(key))
  add(query_579863, "prettyPrint", newJBool(prettyPrint))
  add(query_579863, "oauth_token", newJString(oauthToken))
  add(query_579863, "alt", newJString(alt))
  add(query_579863, "userIp", newJString(userIp))
  add(query_579863, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579865 = body
  add(query_579863, "fields", newJString(fields))
  result = call_579862.call(nil, query_579863, nil, nil, body_579865)

var doubleclickbidmanagerLineitemsDownloadlineitems* = Call_DoubleclickbidmanagerLineitemsDownloadlineitems_579634(
    name: "doubleclickbidmanagerLineitemsDownloadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/downloadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsDownloadlineitems_579635,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsDownloadlineitems_579636,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerLineitemsUploadlineitems_579904 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerLineitemsUploadlineitems_579906(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DoubleclickbidmanagerLineitemsUploadlineitems_579905(
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
  var valid_579907 = query.getOrDefault("key")
  valid_579907 = validateParameter(valid_579907, JString, required = false,
                                 default = nil)
  if valid_579907 != nil:
    section.add "key", valid_579907
  var valid_579908 = query.getOrDefault("prettyPrint")
  valid_579908 = validateParameter(valid_579908, JBool, required = false,
                                 default = newJBool(true))
  if valid_579908 != nil:
    section.add "prettyPrint", valid_579908
  var valid_579909 = query.getOrDefault("oauth_token")
  valid_579909 = validateParameter(valid_579909, JString, required = false,
                                 default = nil)
  if valid_579909 != nil:
    section.add "oauth_token", valid_579909
  var valid_579910 = query.getOrDefault("alt")
  valid_579910 = validateParameter(valid_579910, JString, required = false,
                                 default = newJString("json"))
  if valid_579910 != nil:
    section.add "alt", valid_579910
  var valid_579911 = query.getOrDefault("userIp")
  valid_579911 = validateParameter(valid_579911, JString, required = false,
                                 default = nil)
  if valid_579911 != nil:
    section.add "userIp", valid_579911
  var valid_579912 = query.getOrDefault("quotaUser")
  valid_579912 = validateParameter(valid_579912, JString, required = false,
                                 default = nil)
  if valid_579912 != nil:
    section.add "quotaUser", valid_579912
  var valid_579913 = query.getOrDefault("fields")
  valid_579913 = validateParameter(valid_579913, JString, required = false,
                                 default = nil)
  if valid_579913 != nil:
    section.add "fields", valid_579913
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

proc call*(call_579915: Call_DoubleclickbidmanagerLineitemsUploadlineitems_579904;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Uploads line items in CSV format. TrueView line items are not supported.
  ## 
  let valid = call_579915.validator(path, query, header, formData, body)
  let scheme = call_579915.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579915.url(scheme.get, call_579915.host, call_579915.base,
                         call_579915.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579915, url, valid)

proc call*(call_579916: Call_DoubleclickbidmanagerLineitemsUploadlineitems_579904;
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
  var query_579917 = newJObject()
  var body_579918 = newJObject()
  add(query_579917, "key", newJString(key))
  add(query_579917, "prettyPrint", newJBool(prettyPrint))
  add(query_579917, "oauth_token", newJString(oauthToken))
  add(query_579917, "alt", newJString(alt))
  add(query_579917, "userIp", newJString(userIp))
  add(query_579917, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579918 = body
  add(query_579917, "fields", newJString(fields))
  result = call_579916.call(nil, query_579917, nil, nil, body_579918)

var doubleclickbidmanagerLineitemsUploadlineitems* = Call_DoubleclickbidmanagerLineitemsUploadlineitems_579904(
    name: "doubleclickbidmanagerLineitemsUploadlineitems",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/lineitems/uploadlineitems",
    validator: validate_DoubleclickbidmanagerLineitemsUploadlineitems_579905,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerLineitemsUploadlineitems_579906,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesListqueries_579919 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerQueriesListqueries_579921(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DoubleclickbidmanagerQueriesListqueries_579920(path: JsonNode;
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
  var valid_579922 = query.getOrDefault("key")
  valid_579922 = validateParameter(valid_579922, JString, required = false,
                                 default = nil)
  if valid_579922 != nil:
    section.add "key", valid_579922
  var valid_579923 = query.getOrDefault("prettyPrint")
  valid_579923 = validateParameter(valid_579923, JBool, required = false,
                                 default = newJBool(true))
  if valid_579923 != nil:
    section.add "prettyPrint", valid_579923
  var valid_579924 = query.getOrDefault("oauth_token")
  valid_579924 = validateParameter(valid_579924, JString, required = false,
                                 default = nil)
  if valid_579924 != nil:
    section.add "oauth_token", valid_579924
  var valid_579925 = query.getOrDefault("alt")
  valid_579925 = validateParameter(valid_579925, JString, required = false,
                                 default = newJString("json"))
  if valid_579925 != nil:
    section.add "alt", valid_579925
  var valid_579926 = query.getOrDefault("userIp")
  valid_579926 = validateParameter(valid_579926, JString, required = false,
                                 default = nil)
  if valid_579926 != nil:
    section.add "userIp", valid_579926
  var valid_579927 = query.getOrDefault("quotaUser")
  valid_579927 = validateParameter(valid_579927, JString, required = false,
                                 default = nil)
  if valid_579927 != nil:
    section.add "quotaUser", valid_579927
  var valid_579928 = query.getOrDefault("fields")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "fields", valid_579928
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579929: Call_DoubleclickbidmanagerQueriesListqueries_579919;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored queries.
  ## 
  let valid = call_579929.validator(path, query, header, formData, body)
  let scheme = call_579929.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579929.url(scheme.get, call_579929.host, call_579929.base,
                         call_579929.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579929, url, valid)

proc call*(call_579930: Call_DoubleclickbidmanagerQueriesListqueries_579919;
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
  var query_579931 = newJObject()
  add(query_579931, "key", newJString(key))
  add(query_579931, "prettyPrint", newJBool(prettyPrint))
  add(query_579931, "oauth_token", newJString(oauthToken))
  add(query_579931, "alt", newJString(alt))
  add(query_579931, "userIp", newJString(userIp))
  add(query_579931, "quotaUser", newJString(quotaUser))
  add(query_579931, "fields", newJString(fields))
  result = call_579930.call(nil, query_579931, nil, nil, nil)

var doubleclickbidmanagerQueriesListqueries* = Call_DoubleclickbidmanagerQueriesListqueries_579919(
    name: "doubleclickbidmanagerQueriesListqueries", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries",
    validator: validate_DoubleclickbidmanagerQueriesListqueries_579920,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesListqueries_579921,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerReportsListreports_579932 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerReportsListreports_579934(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerReportsListreports_579933(path: JsonNode;
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
  var valid_579949 = path.getOrDefault("queryId")
  valid_579949 = validateParameter(valid_579949, JString, required = true,
                                 default = nil)
  if valid_579949 != nil:
    section.add "queryId", valid_579949
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
  var valid_579950 = query.getOrDefault("key")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "key", valid_579950
  var valid_579951 = query.getOrDefault("prettyPrint")
  valid_579951 = validateParameter(valid_579951, JBool, required = false,
                                 default = newJBool(true))
  if valid_579951 != nil:
    section.add "prettyPrint", valid_579951
  var valid_579952 = query.getOrDefault("oauth_token")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "oauth_token", valid_579952
  var valid_579953 = query.getOrDefault("alt")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = newJString("json"))
  if valid_579953 != nil:
    section.add "alt", valid_579953
  var valid_579954 = query.getOrDefault("userIp")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = nil)
  if valid_579954 != nil:
    section.add "userIp", valid_579954
  var valid_579955 = query.getOrDefault("quotaUser")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "quotaUser", valid_579955
  var valid_579956 = query.getOrDefault("fields")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "fields", valid_579956
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579957: Call_DoubleclickbidmanagerReportsListreports_579932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves stored reports.
  ## 
  let valid = call_579957.validator(path, query, header, formData, body)
  let scheme = call_579957.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579957.url(scheme.get, call_579957.host, call_579957.base,
                         call_579957.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579957, url, valid)

proc call*(call_579958: Call_DoubleclickbidmanagerReportsListreports_579932;
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
  var path_579959 = newJObject()
  var query_579960 = newJObject()
  add(query_579960, "key", newJString(key))
  add(query_579960, "prettyPrint", newJBool(prettyPrint))
  add(query_579960, "oauth_token", newJString(oauthToken))
  add(query_579960, "alt", newJString(alt))
  add(query_579960, "userIp", newJString(userIp))
  add(query_579960, "quotaUser", newJString(quotaUser))
  add(path_579959, "queryId", newJString(queryId))
  add(query_579960, "fields", newJString(fields))
  result = call_579958.call(path_579959, query_579960, nil, nil, nil)

var doubleclickbidmanagerReportsListreports* = Call_DoubleclickbidmanagerReportsListreports_579932(
    name: "doubleclickbidmanagerReportsListreports", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/queries/{queryId}/reports",
    validator: validate_DoubleclickbidmanagerReportsListreports_579933,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerReportsListreports_579934,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesCreatequery_579961 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerQueriesCreatequery_579963(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DoubleclickbidmanagerQueriesCreatequery_579962(path: JsonNode;
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
  var valid_579964 = query.getOrDefault("key")
  valid_579964 = validateParameter(valid_579964, JString, required = false,
                                 default = nil)
  if valid_579964 != nil:
    section.add "key", valid_579964
  var valid_579965 = query.getOrDefault("prettyPrint")
  valid_579965 = validateParameter(valid_579965, JBool, required = false,
                                 default = newJBool(true))
  if valid_579965 != nil:
    section.add "prettyPrint", valid_579965
  var valid_579966 = query.getOrDefault("oauth_token")
  valid_579966 = validateParameter(valid_579966, JString, required = false,
                                 default = nil)
  if valid_579966 != nil:
    section.add "oauth_token", valid_579966
  var valid_579967 = query.getOrDefault("alt")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = newJString("json"))
  if valid_579967 != nil:
    section.add "alt", valid_579967
  var valid_579968 = query.getOrDefault("userIp")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "userIp", valid_579968
  var valid_579969 = query.getOrDefault("quotaUser")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "quotaUser", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
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

proc call*(call_579972: Call_DoubleclickbidmanagerQueriesCreatequery_579961;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a query.
  ## 
  let valid = call_579972.validator(path, query, header, formData, body)
  let scheme = call_579972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579972.url(scheme.get, call_579972.host, call_579972.base,
                         call_579972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579972, url, valid)

proc call*(call_579973: Call_DoubleclickbidmanagerQueriesCreatequery_579961;
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
  var query_579974 = newJObject()
  var body_579975 = newJObject()
  add(query_579974, "key", newJString(key))
  add(query_579974, "prettyPrint", newJBool(prettyPrint))
  add(query_579974, "oauth_token", newJString(oauthToken))
  add(query_579974, "alt", newJString(alt))
  add(query_579974, "userIp", newJString(userIp))
  add(query_579974, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579975 = body
  add(query_579974, "fields", newJString(fields))
  result = call_579973.call(nil, query_579974, nil, nil, body_579975)

var doubleclickbidmanagerQueriesCreatequery* = Call_DoubleclickbidmanagerQueriesCreatequery_579961(
    name: "doubleclickbidmanagerQueriesCreatequery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query",
    validator: validate_DoubleclickbidmanagerQueriesCreatequery_579962,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesCreatequery_579963,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesRunquery_579991 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerQueriesRunquery_579993(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesRunquery_579992(path: JsonNode;
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
  var valid_579994 = path.getOrDefault("queryId")
  valid_579994 = validateParameter(valid_579994, JString, required = true,
                                 default = nil)
  if valid_579994 != nil:
    section.add "queryId", valid_579994
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
  var valid_579995 = query.getOrDefault("key")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "key", valid_579995
  var valid_579996 = query.getOrDefault("prettyPrint")
  valid_579996 = validateParameter(valid_579996, JBool, required = false,
                                 default = newJBool(true))
  if valid_579996 != nil:
    section.add "prettyPrint", valid_579996
  var valid_579997 = query.getOrDefault("oauth_token")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "oauth_token", valid_579997
  var valid_579998 = query.getOrDefault("alt")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = newJString("json"))
  if valid_579998 != nil:
    section.add "alt", valid_579998
  var valid_579999 = query.getOrDefault("userIp")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "userIp", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("fields")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "fields", valid_580001
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

proc call*(call_580003: Call_DoubleclickbidmanagerQueriesRunquery_579991;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Runs a stored query to generate a report.
  ## 
  let valid = call_580003.validator(path, query, header, formData, body)
  let scheme = call_580003.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580003.url(scheme.get, call_580003.host, call_580003.base,
                         call_580003.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580003, url, valid)

proc call*(call_580004: Call_DoubleclickbidmanagerQueriesRunquery_579991;
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
  var path_580005 = newJObject()
  var query_580006 = newJObject()
  var body_580007 = newJObject()
  add(query_580006, "key", newJString(key))
  add(query_580006, "prettyPrint", newJBool(prettyPrint))
  add(query_580006, "oauth_token", newJString(oauthToken))
  add(query_580006, "alt", newJString(alt))
  add(query_580006, "userIp", newJString(userIp))
  add(query_580006, "quotaUser", newJString(quotaUser))
  add(path_580005, "queryId", newJString(queryId))
  if body != nil:
    body_580007 = body
  add(query_580006, "fields", newJString(fields))
  result = call_580004.call(path_580005, query_580006, nil, nil, body_580007)

var doubleclickbidmanagerQueriesRunquery* = Call_DoubleclickbidmanagerQueriesRunquery_579991(
    name: "doubleclickbidmanagerQueriesRunquery", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesRunquery_579992,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesRunquery_579993, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesGetquery_579976 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerQueriesGetquery_579978(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesGetquery_579977(path: JsonNode;
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
  var valid_579979 = path.getOrDefault("queryId")
  valid_579979 = validateParameter(valid_579979, JString, required = true,
                                 default = nil)
  if valid_579979 != nil:
    section.add "queryId", valid_579979
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
  var valid_579980 = query.getOrDefault("key")
  valid_579980 = validateParameter(valid_579980, JString, required = false,
                                 default = nil)
  if valid_579980 != nil:
    section.add "key", valid_579980
  var valid_579981 = query.getOrDefault("prettyPrint")
  valid_579981 = validateParameter(valid_579981, JBool, required = false,
                                 default = newJBool(true))
  if valid_579981 != nil:
    section.add "prettyPrint", valid_579981
  var valid_579982 = query.getOrDefault("oauth_token")
  valid_579982 = validateParameter(valid_579982, JString, required = false,
                                 default = nil)
  if valid_579982 != nil:
    section.add "oauth_token", valid_579982
  var valid_579983 = query.getOrDefault("alt")
  valid_579983 = validateParameter(valid_579983, JString, required = false,
                                 default = newJString("json"))
  if valid_579983 != nil:
    section.add "alt", valid_579983
  var valid_579984 = query.getOrDefault("userIp")
  valid_579984 = validateParameter(valid_579984, JString, required = false,
                                 default = nil)
  if valid_579984 != nil:
    section.add "userIp", valid_579984
  var valid_579985 = query.getOrDefault("quotaUser")
  valid_579985 = validateParameter(valid_579985, JString, required = false,
                                 default = nil)
  if valid_579985 != nil:
    section.add "quotaUser", valid_579985
  var valid_579986 = query.getOrDefault("fields")
  valid_579986 = validateParameter(valid_579986, JString, required = false,
                                 default = nil)
  if valid_579986 != nil:
    section.add "fields", valid_579986
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579987: Call_DoubleclickbidmanagerQueriesGetquery_579976;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a stored query.
  ## 
  let valid = call_579987.validator(path, query, header, formData, body)
  let scheme = call_579987.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579987.url(scheme.get, call_579987.host, call_579987.base,
                         call_579987.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579987, url, valid)

proc call*(call_579988: Call_DoubleclickbidmanagerQueriesGetquery_579976;
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
  var path_579989 = newJObject()
  var query_579990 = newJObject()
  add(query_579990, "key", newJString(key))
  add(query_579990, "prettyPrint", newJBool(prettyPrint))
  add(query_579990, "oauth_token", newJString(oauthToken))
  add(query_579990, "alt", newJString(alt))
  add(query_579990, "userIp", newJString(userIp))
  add(query_579990, "quotaUser", newJString(quotaUser))
  add(path_579989, "queryId", newJString(queryId))
  add(query_579990, "fields", newJString(fields))
  result = call_579988.call(path_579989, query_579990, nil, nil, nil)

var doubleclickbidmanagerQueriesGetquery* = Call_DoubleclickbidmanagerQueriesGetquery_579976(
    name: "doubleclickbidmanagerQueriesGetquery", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesGetquery_579977,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesGetquery_579978, schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerQueriesDeletequery_580008 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerQueriesDeletequery_580010(protocol: Scheme;
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
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DoubleclickbidmanagerQueriesDeletequery_580009(path: JsonNode;
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
  var valid_580011 = path.getOrDefault("queryId")
  valid_580011 = validateParameter(valid_580011, JString, required = true,
                                 default = nil)
  if valid_580011 != nil:
    section.add "queryId", valid_580011
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
  var valid_580012 = query.getOrDefault("key")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "key", valid_580012
  var valid_580013 = query.getOrDefault("prettyPrint")
  valid_580013 = validateParameter(valid_580013, JBool, required = false,
                                 default = newJBool(true))
  if valid_580013 != nil:
    section.add "prettyPrint", valid_580013
  var valid_580014 = query.getOrDefault("oauth_token")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "oauth_token", valid_580014
  var valid_580015 = query.getOrDefault("alt")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = newJString("json"))
  if valid_580015 != nil:
    section.add "alt", valid_580015
  var valid_580016 = query.getOrDefault("userIp")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "userIp", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("fields")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "fields", valid_580018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580019: Call_DoubleclickbidmanagerQueriesDeletequery_580008;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a stored query as well as the associated stored reports.
  ## 
  let valid = call_580019.validator(path, query, header, formData, body)
  let scheme = call_580019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580019.url(scheme.get, call_580019.host, call_580019.base,
                         call_580019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580019, url, valid)

proc call*(call_580020: Call_DoubleclickbidmanagerQueriesDeletequery_580008;
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
  var path_580021 = newJObject()
  var query_580022 = newJObject()
  add(query_580022, "key", newJString(key))
  add(query_580022, "prettyPrint", newJBool(prettyPrint))
  add(query_580022, "oauth_token", newJString(oauthToken))
  add(query_580022, "alt", newJString(alt))
  add(query_580022, "userIp", newJString(userIp))
  add(query_580022, "quotaUser", newJString(quotaUser))
  add(path_580021, "queryId", newJString(queryId))
  add(query_580022, "fields", newJString(fields))
  result = call_580020.call(path_580021, query_580022, nil, nil, nil)

var doubleclickbidmanagerQueriesDeletequery* = Call_DoubleclickbidmanagerQueriesDeletequery_580008(
    name: "doubleclickbidmanagerQueriesDeletequery", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/query/{queryId}",
    validator: validate_DoubleclickbidmanagerQueriesDeletequery_580009,
    base: "/doubleclickbidmanager/v1",
    url: url_DoubleclickbidmanagerQueriesDeletequery_580010,
    schemes: {Scheme.Https})
type
  Call_DoubleclickbidmanagerSdfDownload_580023 = ref object of OpenApiRestCall_579364
proc url_DoubleclickbidmanagerSdfDownload_580025(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DoubleclickbidmanagerSdfDownload_580024(path: JsonNode;
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
  var valid_580026 = query.getOrDefault("key")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "key", valid_580026
  var valid_580027 = query.getOrDefault("prettyPrint")
  valid_580027 = validateParameter(valid_580027, JBool, required = false,
                                 default = newJBool(true))
  if valid_580027 != nil:
    section.add "prettyPrint", valid_580027
  var valid_580028 = query.getOrDefault("oauth_token")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "oauth_token", valid_580028
  var valid_580029 = query.getOrDefault("alt")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = newJString("json"))
  if valid_580029 != nil:
    section.add "alt", valid_580029
  var valid_580030 = query.getOrDefault("userIp")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "userIp", valid_580030
  var valid_580031 = query.getOrDefault("quotaUser")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = nil)
  if valid_580031 != nil:
    section.add "quotaUser", valid_580031
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
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

proc call*(call_580034: Call_DoubleclickbidmanagerSdfDownload_580023;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves entities in SDF format.
  ## 
  let valid = call_580034.validator(path, query, header, formData, body)
  let scheme = call_580034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580034.url(scheme.get, call_580034.host, call_580034.base,
                         call_580034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580034, url, valid)

proc call*(call_580035: Call_DoubleclickbidmanagerSdfDownload_580023;
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
  var query_580036 = newJObject()
  var body_580037 = newJObject()
  add(query_580036, "key", newJString(key))
  add(query_580036, "prettyPrint", newJBool(prettyPrint))
  add(query_580036, "oauth_token", newJString(oauthToken))
  add(query_580036, "alt", newJString(alt))
  add(query_580036, "userIp", newJString(userIp))
  add(query_580036, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580037 = body
  add(query_580036, "fields", newJString(fields))
  result = call_580035.call(nil, query_580036, nil, nil, body_580037)

var doubleclickbidmanagerSdfDownload* = Call_DoubleclickbidmanagerSdfDownload_580023(
    name: "doubleclickbidmanagerSdfDownload", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/sdf/download",
    validator: validate_DoubleclickbidmanagerSdfDownload_580024,
    base: "/doubleclickbidmanager/v1", url: url_DoubleclickbidmanagerSdfDownload_580025,
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
