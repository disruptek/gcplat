
import
  json, options, hashes, uri, strutils, rest, os, uri, strutils, times, httpcore,
  httpclient, asyncdispatch, jwt

## auto-generated via openapi macro
## title: Admin Directory
## version: directory_v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Manages enterprise resources such as users and groups, administrative notifications, security features, and more.
## 
## https://developers.google.com/admin-sdk/directory/
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

  OpenApiRestCall_579389 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579389](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579389): Option[Scheme] {.used.} =
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
  gcpServiceName = "admin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdminChannelsStop_579659 = ref object of OpenApiRestCall_579389
proc url_AdminChannelsStop_579661(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_AdminChannelsStop_579660(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
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
  var valid_579773 = query.getOrDefault("key")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "key", valid_579773
  var valid_579787 = query.getOrDefault("prettyPrint")
  valid_579787 = validateParameter(valid_579787, JBool, required = false,
                                 default = newJBool(true))
  if valid_579787 != nil:
    section.add "prettyPrint", valid_579787
  var valid_579788 = query.getOrDefault("oauth_token")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = nil)
  if valid_579788 != nil:
    section.add "oauth_token", valid_579788
  var valid_579789 = query.getOrDefault("alt")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = newJString("json"))
  if valid_579789 != nil:
    section.add "alt", valid_579789
  var valid_579790 = query.getOrDefault("userIp")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "userIp", valid_579790
  var valid_579791 = query.getOrDefault("quotaUser")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "quotaUser", valid_579791
  var valid_579792 = query.getOrDefault("fields")
  valid_579792 = validateParameter(valid_579792, JString, required = false,
                                 default = nil)
  if valid_579792 != nil:
    section.add "fields", valid_579792
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_579816: Call_AdminChannelsStop_579659; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_579816.validator(path, query, header, formData, body)
  let scheme = call_579816.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579816.url(scheme.get, call_579816.host, call_579816.base,
                         call_579816.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579816, url, valid)

proc call*(call_579887: Call_AdminChannelsStop_579659; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; resource: JsonNode = nil;
          fields: string = ""): Recallable =
  ## adminChannelsStop
  ## Stop watching resources through this channel
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
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var query_579888 = newJObject()
  var body_579890 = newJObject()
  add(query_579888, "key", newJString(key))
  add(query_579888, "prettyPrint", newJBool(prettyPrint))
  add(query_579888, "oauth_token", newJString(oauthToken))
  add(query_579888, "alt", newJString(alt))
  add(query_579888, "userIp", newJString(userIp))
  add(query_579888, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_579890 = resource
  add(query_579888, "fields", newJString(fields))
  result = call_579887.call(nil, query_579888, nil, nil, body_579890)

var adminChannelsStop* = Call_AdminChannelsStop_579659(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/directory_v1/channels/stop",
    validator: validate_AdminChannelsStop_579660, base: "/admin/directory/v1",
    url: url_AdminChannelsStop_579661, schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesList_579929 = ref object of OpenApiRestCall_579389
proc url_DirectoryChromeosdevicesList_579931(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/chromeos")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesList_579930(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve all Chrome OS Devices of a customer (paginated)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_579946 = path.getOrDefault("customerId")
  valid_579946 = validateParameter(valid_579946, JString, required = true,
                                 default = nil)
  if valid_579946 != nil:
    section.add "customerId", valid_579946
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: JString
  ##              : Full path of the organizational unit or its ID
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
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   query: JString
  ##        : Search string in the format given at http://support.google.com/chromeos/a/bin/answer.py?answer=1698333
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Max allowed value is 200.
  section = newJObject()
  var valid_579947 = query.getOrDefault("key")
  valid_579947 = validateParameter(valid_579947, JString, required = false,
                                 default = nil)
  if valid_579947 != nil:
    section.add "key", valid_579947
  var valid_579948 = query.getOrDefault("orgUnitPath")
  valid_579948 = validateParameter(valid_579948, JString, required = false,
                                 default = nil)
  if valid_579948 != nil:
    section.add "orgUnitPath", valid_579948
  var valid_579949 = query.getOrDefault("prettyPrint")
  valid_579949 = validateParameter(valid_579949, JBool, required = false,
                                 default = newJBool(true))
  if valid_579949 != nil:
    section.add "prettyPrint", valid_579949
  var valid_579950 = query.getOrDefault("oauth_token")
  valid_579950 = validateParameter(valid_579950, JString, required = false,
                                 default = nil)
  if valid_579950 != nil:
    section.add "oauth_token", valid_579950
  var valid_579951 = query.getOrDefault("alt")
  valid_579951 = validateParameter(valid_579951, JString, required = false,
                                 default = newJString("json"))
  if valid_579951 != nil:
    section.add "alt", valid_579951
  var valid_579952 = query.getOrDefault("userIp")
  valid_579952 = validateParameter(valid_579952, JString, required = false,
                                 default = nil)
  if valid_579952 != nil:
    section.add "userIp", valid_579952
  var valid_579953 = query.getOrDefault("quotaUser")
  valid_579953 = validateParameter(valid_579953, JString, required = false,
                                 default = nil)
  if valid_579953 != nil:
    section.add "quotaUser", valid_579953
  var valid_579954 = query.getOrDefault("orderBy")
  valid_579954 = validateParameter(valid_579954, JString, required = false,
                                 default = newJString("annotatedLocation"))
  if valid_579954 != nil:
    section.add "orderBy", valid_579954
  var valid_579955 = query.getOrDefault("pageToken")
  valid_579955 = validateParameter(valid_579955, JString, required = false,
                                 default = nil)
  if valid_579955 != nil:
    section.add "pageToken", valid_579955
  var valid_579956 = query.getOrDefault("sortOrder")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_579956 != nil:
    section.add "sortOrder", valid_579956
  var valid_579957 = query.getOrDefault("query")
  valid_579957 = validateParameter(valid_579957, JString, required = false,
                                 default = nil)
  if valid_579957 != nil:
    section.add "query", valid_579957
  var valid_579958 = query.getOrDefault("projection")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579958 != nil:
    section.add "projection", valid_579958
  var valid_579959 = query.getOrDefault("fields")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = nil)
  if valid_579959 != nil:
    section.add "fields", valid_579959
  var valid_579961 = query.getOrDefault("maxResults")
  valid_579961 = validateParameter(valid_579961, JInt, required = false,
                                 default = newJInt(100))
  if valid_579961 != nil:
    section.add "maxResults", valid_579961
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579962: Call_DirectoryChromeosdevicesList_579929; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Chrome OS Devices of a customer (paginated)
  ## 
  let valid = call_579962.validator(path, query, header, formData, body)
  let scheme = call_579962.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579962.url(scheme.get, call_579962.host, call_579962.base,
                         call_579962.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579962, url, valid)

proc call*(call_579963: Call_DirectoryChromeosdevicesList_579929;
          customerId: string; key: string = ""; orgUnitPath: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = "";
          orderBy: string = "annotatedLocation"; pageToken: string = "";
          sortOrder: string = "ASCENDING"; query: string = "";
          projection: string = "BASIC"; fields: string = ""; maxResults: int = 100): Recallable =
  ## directoryChromeosdevicesList
  ## Retrieve all Chrome OS Devices of a customer (paginated)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: string
  ##              : Full path of the organizational unit or its ID
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
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   query: string
  ##        : Search string in the format given at http://support.google.com/chromeos/a/bin/answer.py?answer=1698333
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return. Max allowed value is 200.
  var path_579964 = newJObject()
  var query_579965 = newJObject()
  add(query_579965, "key", newJString(key))
  add(query_579965, "orgUnitPath", newJString(orgUnitPath))
  add(query_579965, "prettyPrint", newJBool(prettyPrint))
  add(query_579965, "oauth_token", newJString(oauthToken))
  add(query_579965, "alt", newJString(alt))
  add(query_579965, "userIp", newJString(userIp))
  add(query_579965, "quotaUser", newJString(quotaUser))
  add(query_579965, "orderBy", newJString(orderBy))
  add(query_579965, "pageToken", newJString(pageToken))
  add(query_579965, "sortOrder", newJString(sortOrder))
  add(path_579964, "customerId", newJString(customerId))
  add(query_579965, "query", newJString(query))
  add(query_579965, "projection", newJString(projection))
  add(query_579965, "fields", newJString(fields))
  add(query_579965, "maxResults", newJInt(maxResults))
  result = call_579963.call(path_579964, query_579965, nil, nil, nil)

var directoryChromeosdevicesList* = Call_DirectoryChromeosdevicesList_579929(
    name: "directoryChromeosdevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/chromeos",
    validator: validate_DirectoryChromeosdevicesList_579930,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesList_579931,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesMoveDevicesToOu_579966 = ref object of OpenApiRestCall_579389
proc url_DirectoryChromeosdevicesMoveDevicesToOu_579968(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"), (kind: ConstantSegment,
        value: "/devices/chromeos/moveDevicesToOu")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesMoveDevicesToOu_579967(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Move or insert multiple Chrome OS Devices to organizational unit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_579969 = path.getOrDefault("customerId")
  valid_579969 = validateParameter(valid_579969, JString, required = true,
                                 default = nil)
  if valid_579969 != nil:
    section.add "customerId", valid_579969
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: JString (required)
  ##              : Full path of the target organizational unit or its ID
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
  var valid_579970 = query.getOrDefault("key")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "key", valid_579970
  assert query != nil,
        "query argument is necessary due to required `orgUnitPath` field"
  var valid_579971 = query.getOrDefault("orgUnitPath")
  valid_579971 = validateParameter(valid_579971, JString, required = true,
                                 default = nil)
  if valid_579971 != nil:
    section.add "orgUnitPath", valid_579971
  var valid_579972 = query.getOrDefault("prettyPrint")
  valid_579972 = validateParameter(valid_579972, JBool, required = false,
                                 default = newJBool(true))
  if valid_579972 != nil:
    section.add "prettyPrint", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("alt")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = newJString("json"))
  if valid_579974 != nil:
    section.add "alt", valid_579974
  var valid_579975 = query.getOrDefault("userIp")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "userIp", valid_579975
  var valid_579976 = query.getOrDefault("quotaUser")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "quotaUser", valid_579976
  var valid_579977 = query.getOrDefault("fields")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "fields", valid_579977
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

proc call*(call_579979: Call_DirectoryChromeosdevicesMoveDevicesToOu_579966;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Move or insert multiple Chrome OS Devices to organizational unit
  ## 
  let valid = call_579979.validator(path, query, header, formData, body)
  let scheme = call_579979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579979.url(scheme.get, call_579979.host, call_579979.base,
                         call_579979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579979, url, valid)

proc call*(call_579980: Call_DirectoryChromeosdevicesMoveDevicesToOu_579966;
          orgUnitPath: string; customerId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryChromeosdevicesMoveDevicesToOu
  ## Move or insert multiple Chrome OS Devices to organizational unit
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: string (required)
  ##              : Full path of the target organizational unit or its ID
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_579981 = newJObject()
  var query_579982 = newJObject()
  var body_579983 = newJObject()
  add(query_579982, "key", newJString(key))
  add(query_579982, "orgUnitPath", newJString(orgUnitPath))
  add(query_579982, "prettyPrint", newJBool(prettyPrint))
  add(query_579982, "oauth_token", newJString(oauthToken))
  add(query_579982, "alt", newJString(alt))
  add(query_579982, "userIp", newJString(userIp))
  add(query_579982, "quotaUser", newJString(quotaUser))
  add(path_579981, "customerId", newJString(customerId))
  if body != nil:
    body_579983 = body
  add(query_579982, "fields", newJString(fields))
  result = call_579980.call(path_579981, query_579982, nil, nil, body_579983)

var directoryChromeosdevicesMoveDevicesToOu* = Call_DirectoryChromeosdevicesMoveDevicesToOu_579966(
    name: "directoryChromeosdevicesMoveDevicesToOu", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/moveDevicesToOu",
    validator: validate_DirectoryChromeosdevicesMoveDevicesToOu_579967,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesMoveDevicesToOu_579968,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesUpdate_580001 = ref object of OpenApiRestCall_579389
proc url_DirectoryChromeosdevicesUpdate_580003(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/chromeos/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesUpdate_580002(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Chrome OS Device
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  ##   deviceId: JString (required)
  ##           : Immutable ID of Chrome OS Device
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580004 = path.getOrDefault("customerId")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "customerId", valid_580004
  var valid_580005 = path.getOrDefault("deviceId")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "deviceId", valid_580005
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
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580006 = query.getOrDefault("key")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "key", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("oauth_token")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "oauth_token", valid_580008
  var valid_580009 = query.getOrDefault("alt")
  valid_580009 = validateParameter(valid_580009, JString, required = false,
                                 default = newJString("json"))
  if valid_580009 != nil:
    section.add "alt", valid_580009
  var valid_580010 = query.getOrDefault("userIp")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "userIp", valid_580010
  var valid_580011 = query.getOrDefault("quotaUser")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "quotaUser", valid_580011
  var valid_580012 = query.getOrDefault("projection")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580012 != nil:
    section.add "projection", valid_580012
  var valid_580013 = query.getOrDefault("fields")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "fields", valid_580013
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

proc call*(call_580015: Call_DirectoryChromeosdevicesUpdate_580001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device
  ## 
  let valid = call_580015.validator(path, query, header, formData, body)
  let scheme = call_580015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580015.url(scheme.get, call_580015.host, call_580015.base,
                         call_580015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580015, url, valid)

proc call*(call_580016: Call_DirectoryChromeosdevicesUpdate_580001;
          customerId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          projection: string = "BASIC"; fields: string = ""): Recallable =
  ## directoryChromeosdevicesUpdate
  ## Update Chrome OS Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : Immutable ID of Chrome OS Device
  var path_580017 = newJObject()
  var query_580018 = newJObject()
  var body_580019 = newJObject()
  add(query_580018, "key", newJString(key))
  add(query_580018, "prettyPrint", newJBool(prettyPrint))
  add(query_580018, "oauth_token", newJString(oauthToken))
  add(query_580018, "alt", newJString(alt))
  add(query_580018, "userIp", newJString(userIp))
  add(query_580018, "quotaUser", newJString(quotaUser))
  add(path_580017, "customerId", newJString(customerId))
  if body != nil:
    body_580019 = body
  add(query_580018, "projection", newJString(projection))
  add(query_580018, "fields", newJString(fields))
  add(path_580017, "deviceId", newJString(deviceId))
  result = call_580016.call(path_580017, query_580018, nil, nil, body_580019)

var directoryChromeosdevicesUpdate* = Call_DirectoryChromeosdevicesUpdate_580001(
    name: "directoryChromeosdevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesUpdate_580002,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesUpdate_580003,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesGet_579984 = ref object of OpenApiRestCall_579389
proc url_DirectoryChromeosdevicesGet_579986(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/chromeos/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesGet_579985(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve Chrome OS Device
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  ##   deviceId: JString (required)
  ##           : Immutable ID of Chrome OS Device
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_579987 = path.getOrDefault("customerId")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "customerId", valid_579987
  var valid_579988 = path.getOrDefault("deviceId")
  valid_579988 = validateParameter(valid_579988, JString, required = true,
                                 default = nil)
  if valid_579988 != nil:
    section.add "deviceId", valid_579988
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
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
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
  var valid_579991 = query.getOrDefault("oauth_token")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = nil)
  if valid_579991 != nil:
    section.add "oauth_token", valid_579991
  var valid_579992 = query.getOrDefault("alt")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = newJString("json"))
  if valid_579992 != nil:
    section.add "alt", valid_579992
  var valid_579993 = query.getOrDefault("userIp")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "userIp", valid_579993
  var valid_579994 = query.getOrDefault("quotaUser")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "quotaUser", valid_579994
  var valid_579995 = query.getOrDefault("projection")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579995 != nil:
    section.add "projection", valid_579995
  var valid_579996 = query.getOrDefault("fields")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "fields", valid_579996
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579997: Call_DirectoryChromeosdevicesGet_579984; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Chrome OS Device
  ## 
  let valid = call_579997.validator(path, query, header, formData, body)
  let scheme = call_579997.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579997.url(scheme.get, call_579997.host, call_579997.base,
                         call_579997.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579997, url, valid)

proc call*(call_579998: Call_DirectoryChromeosdevicesGet_579984;
          customerId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; projection: string = "BASIC";
          fields: string = ""): Recallable =
  ## directoryChromeosdevicesGet
  ## Retrieve Chrome OS Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : Immutable ID of Chrome OS Device
  var path_579999 = newJObject()
  var query_580000 = newJObject()
  add(query_580000, "key", newJString(key))
  add(query_580000, "prettyPrint", newJBool(prettyPrint))
  add(query_580000, "oauth_token", newJString(oauthToken))
  add(query_580000, "alt", newJString(alt))
  add(query_580000, "userIp", newJString(userIp))
  add(query_580000, "quotaUser", newJString(quotaUser))
  add(path_579999, "customerId", newJString(customerId))
  add(query_580000, "projection", newJString(projection))
  add(query_580000, "fields", newJString(fields))
  add(path_579999, "deviceId", newJString(deviceId))
  result = call_579998.call(path_579999, query_580000, nil, nil, nil)

var directoryChromeosdevicesGet* = Call_DirectoryChromeosdevicesGet_579984(
    name: "directoryChromeosdevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesGet_579985,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesGet_579986,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesPatch_580020 = ref object of OpenApiRestCall_579389
proc url_DirectoryChromeosdevicesPatch_580022(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "deviceId" in path, "`deviceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/chromeos/"),
               (kind: VariableSegment, value: "deviceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesPatch_580021(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Chrome OS Device. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  ##   deviceId: JString (required)
  ##           : Immutable ID of Chrome OS Device
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580023 = path.getOrDefault("customerId")
  valid_580023 = validateParameter(valid_580023, JString, required = true,
                                 default = nil)
  if valid_580023 != nil:
    section.add "customerId", valid_580023
  var valid_580024 = path.getOrDefault("deviceId")
  valid_580024 = validateParameter(valid_580024, JString, required = true,
                                 default = nil)
  if valid_580024 != nil:
    section.add "deviceId", valid_580024
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
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580025 = query.getOrDefault("key")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = nil)
  if valid_580025 != nil:
    section.add "key", valid_580025
  var valid_580026 = query.getOrDefault("prettyPrint")
  valid_580026 = validateParameter(valid_580026, JBool, required = false,
                                 default = newJBool(true))
  if valid_580026 != nil:
    section.add "prettyPrint", valid_580026
  var valid_580027 = query.getOrDefault("oauth_token")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "oauth_token", valid_580027
  var valid_580028 = query.getOrDefault("alt")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = newJString("json"))
  if valid_580028 != nil:
    section.add "alt", valid_580028
  var valid_580029 = query.getOrDefault("userIp")
  valid_580029 = validateParameter(valid_580029, JString, required = false,
                                 default = nil)
  if valid_580029 != nil:
    section.add "userIp", valid_580029
  var valid_580030 = query.getOrDefault("quotaUser")
  valid_580030 = validateParameter(valid_580030, JString, required = false,
                                 default = nil)
  if valid_580030 != nil:
    section.add "quotaUser", valid_580030
  var valid_580031 = query.getOrDefault("projection")
  valid_580031 = validateParameter(valid_580031, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580031 != nil:
    section.add "projection", valid_580031
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

proc call*(call_580034: Call_DirectoryChromeosdevicesPatch_580020; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device. This method supports patch semantics.
  ## 
  let valid = call_580034.validator(path, query, header, formData, body)
  let scheme = call_580034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580034.url(scheme.get, call_580034.host, call_580034.base,
                         call_580034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580034, url, valid)

proc call*(call_580035: Call_DirectoryChromeosdevicesPatch_580020;
          customerId: string; deviceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          projection: string = "BASIC"; fields: string = ""): Recallable =
  ## directoryChromeosdevicesPatch
  ## Update Chrome OS Device. This method supports patch semantics.
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   deviceId: string (required)
  ##           : Immutable ID of Chrome OS Device
  var path_580036 = newJObject()
  var query_580037 = newJObject()
  var body_580038 = newJObject()
  add(query_580037, "key", newJString(key))
  add(query_580037, "prettyPrint", newJBool(prettyPrint))
  add(query_580037, "oauth_token", newJString(oauthToken))
  add(query_580037, "alt", newJString(alt))
  add(query_580037, "userIp", newJString(userIp))
  add(query_580037, "quotaUser", newJString(quotaUser))
  add(path_580036, "customerId", newJString(customerId))
  if body != nil:
    body_580038 = body
  add(query_580037, "projection", newJString(projection))
  add(query_580037, "fields", newJString(fields))
  add(path_580036, "deviceId", newJString(deviceId))
  result = call_580035.call(path_580036, query_580037, nil, nil, body_580038)

var directoryChromeosdevicesPatch* = Call_DirectoryChromeosdevicesPatch_580020(
    name: "directoryChromeosdevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesPatch_580021,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesPatch_580022,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesAction_580039 = ref object of OpenApiRestCall_579389
proc url_DirectoryChromeosdevicesAction_580041(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/chromeos/"),
               (kind: VariableSegment, value: "resourceId"),
               (kind: ConstantSegment, value: "/action")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesAction_580040(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Take action on Chrome OS Device
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  ##   resourceId: JString (required)
  ##             : Immutable ID of Chrome OS Device
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580042 = path.getOrDefault("customerId")
  valid_580042 = validateParameter(valid_580042, JString, required = true,
                                 default = nil)
  if valid_580042 != nil:
    section.add "customerId", valid_580042
  var valid_580043 = path.getOrDefault("resourceId")
  valid_580043 = validateParameter(valid_580043, JString, required = true,
                                 default = nil)
  if valid_580043 != nil:
    section.add "resourceId", valid_580043
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
  var valid_580044 = query.getOrDefault("key")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "key", valid_580044
  var valid_580045 = query.getOrDefault("prettyPrint")
  valid_580045 = validateParameter(valid_580045, JBool, required = false,
                                 default = newJBool(true))
  if valid_580045 != nil:
    section.add "prettyPrint", valid_580045
  var valid_580046 = query.getOrDefault("oauth_token")
  valid_580046 = validateParameter(valid_580046, JString, required = false,
                                 default = nil)
  if valid_580046 != nil:
    section.add "oauth_token", valid_580046
  var valid_580047 = query.getOrDefault("alt")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = newJString("json"))
  if valid_580047 != nil:
    section.add "alt", valid_580047
  var valid_580048 = query.getOrDefault("userIp")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "userIp", valid_580048
  var valid_580049 = query.getOrDefault("quotaUser")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = nil)
  if valid_580049 != nil:
    section.add "quotaUser", valid_580049
  var valid_580050 = query.getOrDefault("fields")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "fields", valid_580050
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

proc call*(call_580052: Call_DirectoryChromeosdevicesAction_580039; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Chrome OS Device
  ## 
  let valid = call_580052.validator(path, query, header, formData, body)
  let scheme = call_580052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580052.url(scheme.get, call_580052.host, call_580052.base,
                         call_580052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580052, url, valid)

proc call*(call_580053: Call_DirectoryChromeosdevicesAction_580039;
          customerId: string; resourceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryChromeosdevicesAction
  ## Take action on Chrome OS Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   resourceId: string (required)
  ##             : Immutable ID of Chrome OS Device
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580054 = newJObject()
  var query_580055 = newJObject()
  var body_580056 = newJObject()
  add(query_580055, "key", newJString(key))
  add(query_580055, "prettyPrint", newJBool(prettyPrint))
  add(query_580055, "oauth_token", newJString(oauthToken))
  add(query_580055, "alt", newJString(alt))
  add(query_580055, "userIp", newJString(userIp))
  add(query_580055, "quotaUser", newJString(quotaUser))
  add(path_580054, "customerId", newJString(customerId))
  if body != nil:
    body_580056 = body
  add(path_580054, "resourceId", newJString(resourceId))
  add(query_580055, "fields", newJString(fields))
  result = call_580053.call(path_580054, query_580055, nil, nil, body_580056)

var directoryChromeosdevicesAction* = Call_DirectoryChromeosdevicesAction_580039(
    name: "directoryChromeosdevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{resourceId}/action",
    validator: validate_DirectoryChromeosdevicesAction_580040,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesAction_580041,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesList_580057 = ref object of OpenApiRestCall_579389
proc url_DirectoryMobiledevicesList_580059(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/mobile")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMobiledevicesList_580058(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve all Mobile Devices of a customer (paginated)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580060 = path.getOrDefault("customerId")
  valid_580060 = validateParameter(valid_580060, JString, required = true,
                                 default = nil)
  if valid_580060 != nil:
    section.add "customerId", valid_580060
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
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   query: JString
  ##        : Search string in the format given at http://support.google.com/a/bin/answer.py?answer=1408863#search
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Max allowed value is 100.
  section = newJObject()
  var valid_580061 = query.getOrDefault("key")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "key", valid_580061
  var valid_580062 = query.getOrDefault("prettyPrint")
  valid_580062 = validateParameter(valid_580062, JBool, required = false,
                                 default = newJBool(true))
  if valid_580062 != nil:
    section.add "prettyPrint", valid_580062
  var valid_580063 = query.getOrDefault("oauth_token")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "oauth_token", valid_580063
  var valid_580064 = query.getOrDefault("alt")
  valid_580064 = validateParameter(valid_580064, JString, required = false,
                                 default = newJString("json"))
  if valid_580064 != nil:
    section.add "alt", valid_580064
  var valid_580065 = query.getOrDefault("userIp")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "userIp", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("orderBy")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("deviceId"))
  if valid_580067 != nil:
    section.add "orderBy", valid_580067
  var valid_580068 = query.getOrDefault("pageToken")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "pageToken", valid_580068
  var valid_580069 = query.getOrDefault("sortOrder")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_580069 != nil:
    section.add "sortOrder", valid_580069
  var valid_580070 = query.getOrDefault("query")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "query", valid_580070
  var valid_580071 = query.getOrDefault("projection")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580071 != nil:
    section.add "projection", valid_580071
  var valid_580072 = query.getOrDefault("fields")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "fields", valid_580072
  var valid_580073 = query.getOrDefault("maxResults")
  valid_580073 = validateParameter(valid_580073, JInt, required = false,
                                 default = newJInt(100))
  if valid_580073 != nil:
    section.add "maxResults", valid_580073
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580074: Call_DirectoryMobiledevicesList_580057; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Mobile Devices of a customer (paginated)
  ## 
  let valid = call_580074.validator(path, query, header, formData, body)
  let scheme = call_580074.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580074.url(scheme.get, call_580074.host, call_580074.base,
                         call_580074.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580074, url, valid)

proc call*(call_580075: Call_DirectoryMobiledevicesList_580057; customerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          orderBy: string = "deviceId"; pageToken: string = "";
          sortOrder: string = "ASCENDING"; query: string = "";
          projection: string = "BASIC"; fields: string = ""; maxResults: int = 100): Recallable =
  ## directoryMobiledevicesList
  ## Retrieve all Mobile Devices of a customer (paginated)
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
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   query: string
  ##        : Search string in the format given at http://support.google.com/a/bin/answer.py?answer=1408863#search
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return. Max allowed value is 100.
  var path_580076 = newJObject()
  var query_580077 = newJObject()
  add(query_580077, "key", newJString(key))
  add(query_580077, "prettyPrint", newJBool(prettyPrint))
  add(query_580077, "oauth_token", newJString(oauthToken))
  add(query_580077, "alt", newJString(alt))
  add(query_580077, "userIp", newJString(userIp))
  add(query_580077, "quotaUser", newJString(quotaUser))
  add(query_580077, "orderBy", newJString(orderBy))
  add(query_580077, "pageToken", newJString(pageToken))
  add(query_580077, "sortOrder", newJString(sortOrder))
  add(path_580076, "customerId", newJString(customerId))
  add(query_580077, "query", newJString(query))
  add(query_580077, "projection", newJString(projection))
  add(query_580077, "fields", newJString(fields))
  add(query_580077, "maxResults", newJInt(maxResults))
  result = call_580075.call(path_580076, query_580077, nil, nil, nil)

var directoryMobiledevicesList* = Call_DirectoryMobiledevicesList_580057(
    name: "directoryMobiledevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/mobile",
    validator: validate_DirectoryMobiledevicesList_580058,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesList_580059,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesGet_580078 = ref object of OpenApiRestCall_579389
proc url_DirectoryMobiledevicesGet_580080(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/mobile/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMobiledevicesGet_580079(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve Mobile Device
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  ##   resourceId: JString (required)
  ##             : Immutable ID of Mobile Device
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580081 = path.getOrDefault("customerId")
  valid_580081 = validateParameter(valid_580081, JString, required = true,
                                 default = nil)
  if valid_580081 != nil:
    section.add "customerId", valid_580081
  var valid_580082 = path.getOrDefault("resourceId")
  valid_580082 = validateParameter(valid_580082, JString, required = true,
                                 default = nil)
  if valid_580082 != nil:
    section.add "resourceId", valid_580082
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
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580083 = query.getOrDefault("key")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "key", valid_580083
  var valid_580084 = query.getOrDefault("prettyPrint")
  valid_580084 = validateParameter(valid_580084, JBool, required = false,
                                 default = newJBool(true))
  if valid_580084 != nil:
    section.add "prettyPrint", valid_580084
  var valid_580085 = query.getOrDefault("oauth_token")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "oauth_token", valid_580085
  var valid_580086 = query.getOrDefault("alt")
  valid_580086 = validateParameter(valid_580086, JString, required = false,
                                 default = newJString("json"))
  if valid_580086 != nil:
    section.add "alt", valid_580086
  var valid_580087 = query.getOrDefault("userIp")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "userIp", valid_580087
  var valid_580088 = query.getOrDefault("quotaUser")
  valid_580088 = validateParameter(valid_580088, JString, required = false,
                                 default = nil)
  if valid_580088 != nil:
    section.add "quotaUser", valid_580088
  var valid_580089 = query.getOrDefault("projection")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580089 != nil:
    section.add "projection", valid_580089
  var valid_580090 = query.getOrDefault("fields")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "fields", valid_580090
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580091: Call_DirectoryMobiledevicesGet_580078; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Mobile Device
  ## 
  let valid = call_580091.validator(path, query, header, formData, body)
  let scheme = call_580091.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580091.url(scheme.get, call_580091.host, call_580091.base,
                         call_580091.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580091, url, valid)

proc call*(call_580092: Call_DirectoryMobiledevicesGet_580078; customerId: string;
          resourceId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; projection: string = "BASIC"; fields: string = ""): Recallable =
  ## directoryMobiledevicesGet
  ## Retrieve Mobile Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   resourceId: string (required)
  ##             : Immutable ID of Mobile Device
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580093 = newJObject()
  var query_580094 = newJObject()
  add(query_580094, "key", newJString(key))
  add(query_580094, "prettyPrint", newJBool(prettyPrint))
  add(query_580094, "oauth_token", newJString(oauthToken))
  add(query_580094, "alt", newJString(alt))
  add(query_580094, "userIp", newJString(userIp))
  add(query_580094, "quotaUser", newJString(quotaUser))
  add(path_580093, "customerId", newJString(customerId))
  add(query_580094, "projection", newJString(projection))
  add(path_580093, "resourceId", newJString(resourceId))
  add(query_580094, "fields", newJString(fields))
  result = call_580092.call(path_580093, query_580094, nil, nil, nil)

var directoryMobiledevicesGet* = Call_DirectoryMobiledevicesGet_580078(
    name: "directoryMobiledevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesGet_580079,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesGet_580080,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesDelete_580095 = ref object of OpenApiRestCall_579389
proc url_DirectoryMobiledevicesDelete_580097(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/mobile/"),
               (kind: VariableSegment, value: "resourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMobiledevicesDelete_580096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Mobile Device
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  ##   resourceId: JString (required)
  ##             : Immutable ID of Mobile Device
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580098 = path.getOrDefault("customerId")
  valid_580098 = validateParameter(valid_580098, JString, required = true,
                                 default = nil)
  if valid_580098 != nil:
    section.add "customerId", valid_580098
  var valid_580099 = path.getOrDefault("resourceId")
  valid_580099 = validateParameter(valid_580099, JString, required = true,
                                 default = nil)
  if valid_580099 != nil:
    section.add "resourceId", valid_580099
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
  var valid_580100 = query.getOrDefault("key")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "key", valid_580100
  var valid_580101 = query.getOrDefault("prettyPrint")
  valid_580101 = validateParameter(valid_580101, JBool, required = false,
                                 default = newJBool(true))
  if valid_580101 != nil:
    section.add "prettyPrint", valid_580101
  var valid_580102 = query.getOrDefault("oauth_token")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "oauth_token", valid_580102
  var valid_580103 = query.getOrDefault("alt")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("json"))
  if valid_580103 != nil:
    section.add "alt", valid_580103
  var valid_580104 = query.getOrDefault("userIp")
  valid_580104 = validateParameter(valid_580104, JString, required = false,
                                 default = nil)
  if valid_580104 != nil:
    section.add "userIp", valid_580104
  var valid_580105 = query.getOrDefault("quotaUser")
  valid_580105 = validateParameter(valid_580105, JString, required = false,
                                 default = nil)
  if valid_580105 != nil:
    section.add "quotaUser", valid_580105
  var valid_580106 = query.getOrDefault("fields")
  valid_580106 = validateParameter(valid_580106, JString, required = false,
                                 default = nil)
  if valid_580106 != nil:
    section.add "fields", valid_580106
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580107: Call_DirectoryMobiledevicesDelete_580095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Mobile Device
  ## 
  let valid = call_580107.validator(path, query, header, formData, body)
  let scheme = call_580107.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580107.url(scheme.get, call_580107.host, call_580107.base,
                         call_580107.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580107, url, valid)

proc call*(call_580108: Call_DirectoryMobiledevicesDelete_580095;
          customerId: string; resourceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryMobiledevicesDelete
  ## Delete Mobile Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   resourceId: string (required)
  ##             : Immutable ID of Mobile Device
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580109 = newJObject()
  var query_580110 = newJObject()
  add(query_580110, "key", newJString(key))
  add(query_580110, "prettyPrint", newJBool(prettyPrint))
  add(query_580110, "oauth_token", newJString(oauthToken))
  add(query_580110, "alt", newJString(alt))
  add(query_580110, "userIp", newJString(userIp))
  add(query_580110, "quotaUser", newJString(quotaUser))
  add(path_580109, "customerId", newJString(customerId))
  add(path_580109, "resourceId", newJString(resourceId))
  add(query_580110, "fields", newJString(fields))
  result = call_580108.call(path_580109, query_580110, nil, nil, nil)

var directoryMobiledevicesDelete* = Call_DirectoryMobiledevicesDelete_580095(
    name: "directoryMobiledevicesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesDelete_580096,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesDelete_580097,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesAction_580111 = ref object of OpenApiRestCall_579389
proc url_DirectoryMobiledevicesAction_580113(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "resourceId" in path, "`resourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/devices/mobile/"),
               (kind: VariableSegment, value: "resourceId"),
               (kind: ConstantSegment, value: "/action")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMobiledevicesAction_580112(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Take action on Mobile Device
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  ##   resourceId: JString (required)
  ##             : Immutable ID of Mobile Device
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580114 = path.getOrDefault("customerId")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "customerId", valid_580114
  var valid_580115 = path.getOrDefault("resourceId")
  valid_580115 = validateParameter(valid_580115, JString, required = true,
                                 default = nil)
  if valid_580115 != nil:
    section.add "resourceId", valid_580115
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
  var valid_580118 = query.getOrDefault("oauth_token")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "oauth_token", valid_580118
  var valid_580119 = query.getOrDefault("alt")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = newJString("json"))
  if valid_580119 != nil:
    section.add "alt", valid_580119
  var valid_580120 = query.getOrDefault("userIp")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "userIp", valid_580120
  var valid_580121 = query.getOrDefault("quotaUser")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "quotaUser", valid_580121
  var valid_580122 = query.getOrDefault("fields")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "fields", valid_580122
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

proc call*(call_580124: Call_DirectoryMobiledevicesAction_580111; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Mobile Device
  ## 
  let valid = call_580124.validator(path, query, header, formData, body)
  let scheme = call_580124.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580124.url(scheme.get, call_580124.host, call_580124.base,
                         call_580124.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580124, url, valid)

proc call*(call_580125: Call_DirectoryMobiledevicesAction_580111;
          customerId: string; resourceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryMobiledevicesAction
  ## Take action on Mobile Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   resourceId: string (required)
  ##             : Immutable ID of Mobile Device
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580126 = newJObject()
  var query_580127 = newJObject()
  var body_580128 = newJObject()
  add(query_580127, "key", newJString(key))
  add(query_580127, "prettyPrint", newJBool(prettyPrint))
  add(query_580127, "oauth_token", newJString(oauthToken))
  add(query_580127, "alt", newJString(alt))
  add(query_580127, "userIp", newJString(userIp))
  add(query_580127, "quotaUser", newJString(quotaUser))
  add(path_580126, "customerId", newJString(customerId))
  if body != nil:
    body_580128 = body
  add(path_580126, "resourceId", newJString(resourceId))
  add(query_580127, "fields", newJString(fields))
  result = call_580125.call(path_580126, query_580127, nil, nil, body_580128)

var directoryMobiledevicesAction* = Call_DirectoryMobiledevicesAction_580111(
    name: "directoryMobiledevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}/action",
    validator: validate_DirectoryMobiledevicesAction_580112,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesAction_580113,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsInsert_580146 = ref object of OpenApiRestCall_579389
proc url_DirectoryOrgunitsInsert_580148(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/orgunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryOrgunitsInsert_580147(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add organizational unit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580149 = path.getOrDefault("customerId")
  valid_580149 = validateParameter(valid_580149, JString, required = true,
                                 default = nil)
  if valid_580149 != nil:
    section.add "customerId", valid_580149
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
  var valid_580150 = query.getOrDefault("key")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "key", valid_580150
  var valid_580151 = query.getOrDefault("prettyPrint")
  valid_580151 = validateParameter(valid_580151, JBool, required = false,
                                 default = newJBool(true))
  if valid_580151 != nil:
    section.add "prettyPrint", valid_580151
  var valid_580152 = query.getOrDefault("oauth_token")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "oauth_token", valid_580152
  var valid_580153 = query.getOrDefault("alt")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = newJString("json"))
  if valid_580153 != nil:
    section.add "alt", valid_580153
  var valid_580154 = query.getOrDefault("userIp")
  valid_580154 = validateParameter(valid_580154, JString, required = false,
                                 default = nil)
  if valid_580154 != nil:
    section.add "userIp", valid_580154
  var valid_580155 = query.getOrDefault("quotaUser")
  valid_580155 = validateParameter(valid_580155, JString, required = false,
                                 default = nil)
  if valid_580155 != nil:
    section.add "quotaUser", valid_580155
  var valid_580156 = query.getOrDefault("fields")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "fields", valid_580156
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

proc call*(call_580158: Call_DirectoryOrgunitsInsert_580146; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add organizational unit
  ## 
  let valid = call_580158.validator(path, query, header, formData, body)
  let scheme = call_580158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580158.url(scheme.get, call_580158.host, call_580158.base,
                         call_580158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580158, url, valid)

proc call*(call_580159: Call_DirectoryOrgunitsInsert_580146; customerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryOrgunitsInsert
  ## Add organizational unit
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580160 = newJObject()
  var query_580161 = newJObject()
  var body_580162 = newJObject()
  add(query_580161, "key", newJString(key))
  add(query_580161, "prettyPrint", newJBool(prettyPrint))
  add(query_580161, "oauth_token", newJString(oauthToken))
  add(query_580161, "alt", newJString(alt))
  add(query_580161, "userIp", newJString(userIp))
  add(query_580161, "quotaUser", newJString(quotaUser))
  add(path_580160, "customerId", newJString(customerId))
  if body != nil:
    body_580162 = body
  add(query_580161, "fields", newJString(fields))
  result = call_580159.call(path_580160, query_580161, nil, nil, body_580162)

var directoryOrgunitsInsert* = Call_DirectoryOrgunitsInsert_580146(
    name: "directoryOrgunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsInsert_580147,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsInsert_580148,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsList_580129 = ref object of OpenApiRestCall_579389
proc url_DirectoryOrgunitsList_580131(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/orgunits")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryOrgunitsList_580130(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve all organizational units
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580132 = path.getOrDefault("customerId")
  valid_580132 = validateParameter(valid_580132, JString, required = true,
                                 default = nil)
  if valid_580132 != nil:
    section.add "customerId", valid_580132
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: JString
  ##              : the URL-encoded organizational unit's path or its ID
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
  ##   type: JString
  ##       : Whether to return all sub-organizations or just immediate children
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580133 = query.getOrDefault("key")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "key", valid_580133
  var valid_580134 = query.getOrDefault("orgUnitPath")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString(""))
  if valid_580134 != nil:
    section.add "orgUnitPath", valid_580134
  var valid_580135 = query.getOrDefault("prettyPrint")
  valid_580135 = validateParameter(valid_580135, JBool, required = false,
                                 default = newJBool(true))
  if valid_580135 != nil:
    section.add "prettyPrint", valid_580135
  var valid_580136 = query.getOrDefault("oauth_token")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "oauth_token", valid_580136
  var valid_580137 = query.getOrDefault("alt")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = newJString("json"))
  if valid_580137 != nil:
    section.add "alt", valid_580137
  var valid_580138 = query.getOrDefault("userIp")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "userIp", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("type")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("all"))
  if valid_580140 != nil:
    section.add "type", valid_580140
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580142: Call_DirectoryOrgunitsList_580129; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all organizational units
  ## 
  let valid = call_580142.validator(path, query, header, formData, body)
  let scheme = call_580142.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580142.url(scheme.get, call_580142.host, call_580142.base,
                         call_580142.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580142, url, valid)

proc call*(call_580143: Call_DirectoryOrgunitsList_580129; customerId: string;
          key: string = ""; orgUnitPath: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; `type`: string = "all"; fields: string = ""): Recallable =
  ## directoryOrgunitsList
  ## Retrieve all organizational units
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: string
  ##              : the URL-encoded organizational unit's path or its ID
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
  ##   type: string
  ##       : Whether to return all sub-organizations or just immediate children
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580144 = newJObject()
  var query_580145 = newJObject()
  add(query_580145, "key", newJString(key))
  add(query_580145, "orgUnitPath", newJString(orgUnitPath))
  add(query_580145, "prettyPrint", newJBool(prettyPrint))
  add(query_580145, "oauth_token", newJString(oauthToken))
  add(query_580145, "alt", newJString(alt))
  add(query_580145, "userIp", newJString(userIp))
  add(query_580145, "quotaUser", newJString(quotaUser))
  add(query_580145, "type", newJString(`type`))
  add(path_580144, "customerId", newJString(customerId))
  add(query_580145, "fields", newJString(fields))
  result = call_580143.call(path_580144, query_580145, nil, nil, nil)

var directoryOrgunitsList* = Call_DirectoryOrgunitsList_580129(
    name: "directoryOrgunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsList_580130, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsList_580131, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsUpdate_580179 = ref object of OpenApiRestCall_579389
proc url_DirectoryOrgunitsUpdate_580181(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "orgUnitPath" in path, "`orgUnitPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/orgunits/"),
               (kind: VariableSegment, value: "orgUnitPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryOrgunitsUpdate_580180(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Organization Unit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orgUnitPath: JString (required)
  ##              : Full path of the organization unit or its Id
  ##   customerId: JString (required)
  ##             : Immutable id of the Google Apps account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `orgUnitPath` field"
  var valid_580182 = path.getOrDefault("orgUnitPath")
  valid_580182 = validateParameter(valid_580182, JString, required = true,
                                 default = nil)
  if valid_580182 != nil:
    section.add "orgUnitPath", valid_580182
  var valid_580183 = path.getOrDefault("customerId")
  valid_580183 = validateParameter(valid_580183, JString, required = true,
                                 default = nil)
  if valid_580183 != nil:
    section.add "customerId", valid_580183
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
  var valid_580184 = query.getOrDefault("key")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "key", valid_580184
  var valid_580185 = query.getOrDefault("prettyPrint")
  valid_580185 = validateParameter(valid_580185, JBool, required = false,
                                 default = newJBool(true))
  if valid_580185 != nil:
    section.add "prettyPrint", valid_580185
  var valid_580186 = query.getOrDefault("oauth_token")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "oauth_token", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("userIp")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "userIp", valid_580188
  var valid_580189 = query.getOrDefault("quotaUser")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "quotaUser", valid_580189
  var valid_580190 = query.getOrDefault("fields")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "fields", valid_580190
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

proc call*(call_580192: Call_DirectoryOrgunitsUpdate_580179; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit
  ## 
  let valid = call_580192.validator(path, query, header, formData, body)
  let scheme = call_580192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580192.url(scheme.get, call_580192.host, call_580192.base,
                         call_580192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580192, url, valid)

proc call*(call_580193: Call_DirectoryOrgunitsUpdate_580179; orgUnitPath: string;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryOrgunitsUpdate
  ## Update Organization Unit
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: string (required)
  ##              : Full path of the organization unit or its Id
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
  ##   customerId: string (required)
  ##             : Immutable id of the Google Apps account
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580194 = newJObject()
  var query_580195 = newJObject()
  var body_580196 = newJObject()
  add(query_580195, "key", newJString(key))
  add(path_580194, "orgUnitPath", newJString(orgUnitPath))
  add(query_580195, "prettyPrint", newJBool(prettyPrint))
  add(query_580195, "oauth_token", newJString(oauthToken))
  add(query_580195, "alt", newJString(alt))
  add(query_580195, "userIp", newJString(userIp))
  add(query_580195, "quotaUser", newJString(quotaUser))
  add(path_580194, "customerId", newJString(customerId))
  if body != nil:
    body_580196 = body
  add(query_580195, "fields", newJString(fields))
  result = call_580193.call(path_580194, query_580195, nil, nil, body_580196)

var directoryOrgunitsUpdate* = Call_DirectoryOrgunitsUpdate_580179(
    name: "directoryOrgunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsUpdate_580180,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsUpdate_580181,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsGet_580163 = ref object of OpenApiRestCall_579389
proc url_DirectoryOrgunitsGet_580165(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "orgUnitPath" in path, "`orgUnitPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/orgunits/"),
               (kind: VariableSegment, value: "orgUnitPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryOrgunitsGet_580164(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve Organization Unit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orgUnitPath: JString (required)
  ##              : Full path of the organization unit or its Id
  ##   customerId: JString (required)
  ##             : Immutable id of the Google Apps account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `orgUnitPath` field"
  var valid_580166 = path.getOrDefault("orgUnitPath")
  valid_580166 = validateParameter(valid_580166, JString, required = true,
                                 default = nil)
  if valid_580166 != nil:
    section.add "orgUnitPath", valid_580166
  var valid_580167 = path.getOrDefault("customerId")
  valid_580167 = validateParameter(valid_580167, JString, required = true,
                                 default = nil)
  if valid_580167 != nil:
    section.add "customerId", valid_580167
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
  var valid_580168 = query.getOrDefault("key")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = nil)
  if valid_580168 != nil:
    section.add "key", valid_580168
  var valid_580169 = query.getOrDefault("prettyPrint")
  valid_580169 = validateParameter(valid_580169, JBool, required = false,
                                 default = newJBool(true))
  if valid_580169 != nil:
    section.add "prettyPrint", valid_580169
  var valid_580170 = query.getOrDefault("oauth_token")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "oauth_token", valid_580170
  var valid_580171 = query.getOrDefault("alt")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = newJString("json"))
  if valid_580171 != nil:
    section.add "alt", valid_580171
  var valid_580172 = query.getOrDefault("userIp")
  valid_580172 = validateParameter(valid_580172, JString, required = false,
                                 default = nil)
  if valid_580172 != nil:
    section.add "userIp", valid_580172
  var valid_580173 = query.getOrDefault("quotaUser")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "quotaUser", valid_580173
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580175: Call_DirectoryOrgunitsGet_580163; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Organization Unit
  ## 
  let valid = call_580175.validator(path, query, header, formData, body)
  let scheme = call_580175.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580175.url(scheme.get, call_580175.host, call_580175.base,
                         call_580175.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580175, url, valid)

proc call*(call_580176: Call_DirectoryOrgunitsGet_580163; orgUnitPath: string;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryOrgunitsGet
  ## Retrieve Organization Unit
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: string (required)
  ##              : Full path of the organization unit or its Id
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
  ##   customerId: string (required)
  ##             : Immutable id of the Google Apps account
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580177 = newJObject()
  var query_580178 = newJObject()
  add(query_580178, "key", newJString(key))
  add(path_580177, "orgUnitPath", newJString(orgUnitPath))
  add(query_580178, "prettyPrint", newJBool(prettyPrint))
  add(query_580178, "oauth_token", newJString(oauthToken))
  add(query_580178, "alt", newJString(alt))
  add(query_580178, "userIp", newJString(userIp))
  add(query_580178, "quotaUser", newJString(quotaUser))
  add(path_580177, "customerId", newJString(customerId))
  add(query_580178, "fields", newJString(fields))
  result = call_580176.call(path_580177, query_580178, nil, nil, nil)

var directoryOrgunitsGet* = Call_DirectoryOrgunitsGet_580163(
    name: "directoryOrgunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsGet_580164, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsGet_580165, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsPatch_580213 = ref object of OpenApiRestCall_579389
proc url_DirectoryOrgunitsPatch_580215(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "orgUnitPath" in path, "`orgUnitPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/orgunits/"),
               (kind: VariableSegment, value: "orgUnitPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryOrgunitsPatch_580214(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Organization Unit. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orgUnitPath: JString (required)
  ##              : Full path of the organization unit or its Id
  ##   customerId: JString (required)
  ##             : Immutable id of the Google Apps account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `orgUnitPath` field"
  var valid_580216 = path.getOrDefault("orgUnitPath")
  valid_580216 = validateParameter(valid_580216, JString, required = true,
                                 default = nil)
  if valid_580216 != nil:
    section.add "orgUnitPath", valid_580216
  var valid_580217 = path.getOrDefault("customerId")
  valid_580217 = validateParameter(valid_580217, JString, required = true,
                                 default = nil)
  if valid_580217 != nil:
    section.add "customerId", valid_580217
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
  var valid_580218 = query.getOrDefault("key")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "key", valid_580218
  var valid_580219 = query.getOrDefault("prettyPrint")
  valid_580219 = validateParameter(valid_580219, JBool, required = false,
                                 default = newJBool(true))
  if valid_580219 != nil:
    section.add "prettyPrint", valid_580219
  var valid_580220 = query.getOrDefault("oauth_token")
  valid_580220 = validateParameter(valid_580220, JString, required = false,
                                 default = nil)
  if valid_580220 != nil:
    section.add "oauth_token", valid_580220
  var valid_580221 = query.getOrDefault("alt")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = newJString("json"))
  if valid_580221 != nil:
    section.add "alt", valid_580221
  var valid_580222 = query.getOrDefault("userIp")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "userIp", valid_580222
  var valid_580223 = query.getOrDefault("quotaUser")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "quotaUser", valid_580223
  var valid_580224 = query.getOrDefault("fields")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = nil)
  if valid_580224 != nil:
    section.add "fields", valid_580224
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

proc call*(call_580226: Call_DirectoryOrgunitsPatch_580213; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit. This method supports patch semantics.
  ## 
  let valid = call_580226.validator(path, query, header, formData, body)
  let scheme = call_580226.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580226.url(scheme.get, call_580226.host, call_580226.base,
                         call_580226.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580226, url, valid)

proc call*(call_580227: Call_DirectoryOrgunitsPatch_580213; orgUnitPath: string;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryOrgunitsPatch
  ## Update Organization Unit. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: string (required)
  ##              : Full path of the organization unit or its Id
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
  ##   customerId: string (required)
  ##             : Immutable id of the Google Apps account
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580228 = newJObject()
  var query_580229 = newJObject()
  var body_580230 = newJObject()
  add(query_580229, "key", newJString(key))
  add(path_580228, "orgUnitPath", newJString(orgUnitPath))
  add(query_580229, "prettyPrint", newJBool(prettyPrint))
  add(query_580229, "oauth_token", newJString(oauthToken))
  add(query_580229, "alt", newJString(alt))
  add(query_580229, "userIp", newJString(userIp))
  add(query_580229, "quotaUser", newJString(quotaUser))
  add(path_580228, "customerId", newJString(customerId))
  if body != nil:
    body_580230 = body
  add(query_580229, "fields", newJString(fields))
  result = call_580227.call(path_580228, query_580229, nil, nil, body_580230)

var directoryOrgunitsPatch* = Call_DirectoryOrgunitsPatch_580213(
    name: "directoryOrgunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsPatch_580214,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsPatch_580215,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsDelete_580197 = ref object of OpenApiRestCall_579389
proc url_DirectoryOrgunitsDelete_580199(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "orgUnitPath" in path, "`orgUnitPath` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/orgunits/"),
               (kind: VariableSegment, value: "orgUnitPath")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryOrgunitsDelete_580198(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove Organization Unit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   orgUnitPath: JString (required)
  ##              : Full path of the organization unit or its Id
  ##   customerId: JString (required)
  ##             : Immutable id of the Google Apps account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `orgUnitPath` field"
  var valid_580200 = path.getOrDefault("orgUnitPath")
  valid_580200 = validateParameter(valid_580200, JString, required = true,
                                 default = nil)
  if valid_580200 != nil:
    section.add "orgUnitPath", valid_580200
  var valid_580201 = path.getOrDefault("customerId")
  valid_580201 = validateParameter(valid_580201, JString, required = true,
                                 default = nil)
  if valid_580201 != nil:
    section.add "customerId", valid_580201
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
  var valid_580202 = query.getOrDefault("key")
  valid_580202 = validateParameter(valid_580202, JString, required = false,
                                 default = nil)
  if valid_580202 != nil:
    section.add "key", valid_580202
  var valid_580203 = query.getOrDefault("prettyPrint")
  valid_580203 = validateParameter(valid_580203, JBool, required = false,
                                 default = newJBool(true))
  if valid_580203 != nil:
    section.add "prettyPrint", valid_580203
  var valid_580204 = query.getOrDefault("oauth_token")
  valid_580204 = validateParameter(valid_580204, JString, required = false,
                                 default = nil)
  if valid_580204 != nil:
    section.add "oauth_token", valid_580204
  var valid_580205 = query.getOrDefault("alt")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = newJString("json"))
  if valid_580205 != nil:
    section.add "alt", valid_580205
  var valid_580206 = query.getOrDefault("userIp")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "userIp", valid_580206
  var valid_580207 = query.getOrDefault("quotaUser")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "quotaUser", valid_580207
  var valid_580208 = query.getOrDefault("fields")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "fields", valid_580208
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580209: Call_DirectoryOrgunitsDelete_580197; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove Organization Unit
  ## 
  let valid = call_580209.validator(path, query, header, formData, body)
  let scheme = call_580209.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580209.url(scheme.get, call_580209.host, call_580209.base,
                         call_580209.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580209, url, valid)

proc call*(call_580210: Call_DirectoryOrgunitsDelete_580197; orgUnitPath: string;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryOrgunitsDelete
  ## Remove Organization Unit
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   orgUnitPath: string (required)
  ##              : Full path of the organization unit or its Id
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
  ##   customerId: string (required)
  ##             : Immutable id of the Google Apps account
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580211 = newJObject()
  var query_580212 = newJObject()
  add(query_580212, "key", newJString(key))
  add(path_580211, "orgUnitPath", newJString(orgUnitPath))
  add(query_580212, "prettyPrint", newJBool(prettyPrint))
  add(query_580212, "oauth_token", newJString(oauthToken))
  add(query_580212, "alt", newJString(alt))
  add(query_580212, "userIp", newJString(userIp))
  add(query_580212, "quotaUser", newJString(quotaUser))
  add(path_580211, "customerId", newJString(customerId))
  add(query_580212, "fields", newJString(fields))
  result = call_580210.call(path_580211, query_580212, nil, nil, nil)

var directoryOrgunitsDelete* = Call_DirectoryOrgunitsDelete_580197(
    name: "directoryOrgunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsDelete_580198,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsDelete_580199,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasInsert_580246 = ref object of OpenApiRestCall_579389
proc url_DirectorySchemasInsert_580248(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/schemas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectorySchemasInsert_580247(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create schema.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580249 = path.getOrDefault("customerId")
  valid_580249 = validateParameter(valid_580249, JString, required = true,
                                 default = nil)
  if valid_580249 != nil:
    section.add "customerId", valid_580249
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
  var valid_580250 = query.getOrDefault("key")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = nil)
  if valid_580250 != nil:
    section.add "key", valid_580250
  var valid_580251 = query.getOrDefault("prettyPrint")
  valid_580251 = validateParameter(valid_580251, JBool, required = false,
                                 default = newJBool(true))
  if valid_580251 != nil:
    section.add "prettyPrint", valid_580251
  var valid_580252 = query.getOrDefault("oauth_token")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "oauth_token", valid_580252
  var valid_580253 = query.getOrDefault("alt")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = newJString("json"))
  if valid_580253 != nil:
    section.add "alt", valid_580253
  var valid_580254 = query.getOrDefault("userIp")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "userIp", valid_580254
  var valid_580255 = query.getOrDefault("quotaUser")
  valid_580255 = validateParameter(valid_580255, JString, required = false,
                                 default = nil)
  if valid_580255 != nil:
    section.add "quotaUser", valid_580255
  var valid_580256 = query.getOrDefault("fields")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "fields", valid_580256
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

proc call*(call_580258: Call_DirectorySchemasInsert_580246; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create schema.
  ## 
  let valid = call_580258.validator(path, query, header, formData, body)
  let scheme = call_580258.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580258.url(scheme.get, call_580258.host, call_580258.base,
                         call_580258.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580258, url, valid)

proc call*(call_580259: Call_DirectorySchemasInsert_580246; customerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directorySchemasInsert
  ## Create schema.
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580260 = newJObject()
  var query_580261 = newJObject()
  var body_580262 = newJObject()
  add(query_580261, "key", newJString(key))
  add(query_580261, "prettyPrint", newJBool(prettyPrint))
  add(query_580261, "oauth_token", newJString(oauthToken))
  add(query_580261, "alt", newJString(alt))
  add(query_580261, "userIp", newJString(userIp))
  add(query_580261, "quotaUser", newJString(quotaUser))
  add(path_580260, "customerId", newJString(customerId))
  if body != nil:
    body_580262 = body
  add(query_580261, "fields", newJString(fields))
  result = call_580259.call(path_580260, query_580261, nil, nil, body_580262)

var directorySchemasInsert* = Call_DirectorySchemasInsert_580246(
    name: "directorySchemasInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasInsert_580247,
    base: "/admin/directory/v1", url: url_DirectorySchemasInsert_580248,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasList_580231 = ref object of OpenApiRestCall_579389
proc url_DirectorySchemasList_580233(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/schemas")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectorySchemasList_580232(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve all schemas for a customer
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_580234 = path.getOrDefault("customerId")
  valid_580234 = validateParameter(valid_580234, JString, required = true,
                                 default = nil)
  if valid_580234 != nil:
    section.add "customerId", valid_580234
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
  var valid_580235 = query.getOrDefault("key")
  valid_580235 = validateParameter(valid_580235, JString, required = false,
                                 default = nil)
  if valid_580235 != nil:
    section.add "key", valid_580235
  var valid_580236 = query.getOrDefault("prettyPrint")
  valid_580236 = validateParameter(valid_580236, JBool, required = false,
                                 default = newJBool(true))
  if valid_580236 != nil:
    section.add "prettyPrint", valid_580236
  var valid_580237 = query.getOrDefault("oauth_token")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "oauth_token", valid_580237
  var valid_580238 = query.getOrDefault("alt")
  valid_580238 = validateParameter(valid_580238, JString, required = false,
                                 default = newJString("json"))
  if valid_580238 != nil:
    section.add "alt", valid_580238
  var valid_580239 = query.getOrDefault("userIp")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "userIp", valid_580239
  var valid_580240 = query.getOrDefault("quotaUser")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = nil)
  if valid_580240 != nil:
    section.add "quotaUser", valid_580240
  var valid_580241 = query.getOrDefault("fields")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "fields", valid_580241
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580242: Call_DirectorySchemasList_580231; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all schemas for a customer
  ## 
  let valid = call_580242.validator(path, query, header, formData, body)
  let scheme = call_580242.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580242.url(scheme.get, call_580242.host, call_580242.base,
                         call_580242.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580242, url, valid)

proc call*(call_580243: Call_DirectorySchemasList_580231; customerId: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directorySchemasList
  ## Retrieve all schemas for a customer
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580244 = newJObject()
  var query_580245 = newJObject()
  add(query_580245, "key", newJString(key))
  add(query_580245, "prettyPrint", newJBool(prettyPrint))
  add(query_580245, "oauth_token", newJString(oauthToken))
  add(query_580245, "alt", newJString(alt))
  add(query_580245, "userIp", newJString(userIp))
  add(query_580245, "quotaUser", newJString(quotaUser))
  add(path_580244, "customerId", newJString(customerId))
  add(query_580245, "fields", newJString(fields))
  result = call_580243.call(path_580244, query_580245, nil, nil, nil)

var directorySchemasList* = Call_DirectorySchemasList_580231(
    name: "directorySchemasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasList_580232, base: "/admin/directory/v1",
    url: url_DirectorySchemasList_580233, schemes: {Scheme.Https})
type
  Call_DirectorySchemasUpdate_580279 = ref object of OpenApiRestCall_579389
proc url_DirectorySchemasUpdate_580281(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "schemaKey" in path, "`schemaKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectorySchemasUpdate_580280(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update schema
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaKey: JString (required)
  ##            : Name or immutable ID of the schema.
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `schemaKey` field"
  var valid_580282 = path.getOrDefault("schemaKey")
  valid_580282 = validateParameter(valid_580282, JString, required = true,
                                 default = nil)
  if valid_580282 != nil:
    section.add "schemaKey", valid_580282
  var valid_580283 = path.getOrDefault("customerId")
  valid_580283 = validateParameter(valid_580283, JString, required = true,
                                 default = nil)
  if valid_580283 != nil:
    section.add "customerId", valid_580283
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
  var valid_580284 = query.getOrDefault("key")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "key", valid_580284
  var valid_580285 = query.getOrDefault("prettyPrint")
  valid_580285 = validateParameter(valid_580285, JBool, required = false,
                                 default = newJBool(true))
  if valid_580285 != nil:
    section.add "prettyPrint", valid_580285
  var valid_580286 = query.getOrDefault("oauth_token")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "oauth_token", valid_580286
  var valid_580287 = query.getOrDefault("alt")
  valid_580287 = validateParameter(valid_580287, JString, required = false,
                                 default = newJString("json"))
  if valid_580287 != nil:
    section.add "alt", valid_580287
  var valid_580288 = query.getOrDefault("userIp")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "userIp", valid_580288
  var valid_580289 = query.getOrDefault("quotaUser")
  valid_580289 = validateParameter(valid_580289, JString, required = false,
                                 default = nil)
  if valid_580289 != nil:
    section.add "quotaUser", valid_580289
  var valid_580290 = query.getOrDefault("fields")
  valid_580290 = validateParameter(valid_580290, JString, required = false,
                                 default = nil)
  if valid_580290 != nil:
    section.add "fields", valid_580290
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

proc call*(call_580292: Call_DirectorySchemasUpdate_580279; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema
  ## 
  let valid = call_580292.validator(path, query, header, formData, body)
  let scheme = call_580292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580292.url(scheme.get, call_580292.host, call_580292.base,
                         call_580292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580292, url, valid)

proc call*(call_580293: Call_DirectorySchemasUpdate_580279; schemaKey: string;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directorySchemasUpdate
  ## Update schema
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   schemaKey: string (required)
  ##            : Name or immutable ID of the schema.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580294 = newJObject()
  var query_580295 = newJObject()
  var body_580296 = newJObject()
  add(query_580295, "key", newJString(key))
  add(query_580295, "prettyPrint", newJBool(prettyPrint))
  add(query_580295, "oauth_token", newJString(oauthToken))
  add(path_580294, "schemaKey", newJString(schemaKey))
  add(query_580295, "alt", newJString(alt))
  add(query_580295, "userIp", newJString(userIp))
  add(query_580295, "quotaUser", newJString(quotaUser))
  add(path_580294, "customerId", newJString(customerId))
  if body != nil:
    body_580296 = body
  add(query_580295, "fields", newJString(fields))
  result = call_580293.call(path_580294, query_580295, nil, nil, body_580296)

var directorySchemasUpdate* = Call_DirectorySchemasUpdate_580279(
    name: "directorySchemasUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasUpdate_580280,
    base: "/admin/directory/v1", url: url_DirectorySchemasUpdate_580281,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasGet_580263 = ref object of OpenApiRestCall_579389
proc url_DirectorySchemasGet_580265(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "schemaKey" in path, "`schemaKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectorySchemasGet_580264(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve schema
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaKey: JString (required)
  ##            : Name or immutable ID of the schema
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `schemaKey` field"
  var valid_580266 = path.getOrDefault("schemaKey")
  valid_580266 = validateParameter(valid_580266, JString, required = true,
                                 default = nil)
  if valid_580266 != nil:
    section.add "schemaKey", valid_580266
  var valid_580267 = path.getOrDefault("customerId")
  valid_580267 = validateParameter(valid_580267, JString, required = true,
                                 default = nil)
  if valid_580267 != nil:
    section.add "customerId", valid_580267
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
  var valid_580268 = query.getOrDefault("key")
  valid_580268 = validateParameter(valid_580268, JString, required = false,
                                 default = nil)
  if valid_580268 != nil:
    section.add "key", valid_580268
  var valid_580269 = query.getOrDefault("prettyPrint")
  valid_580269 = validateParameter(valid_580269, JBool, required = false,
                                 default = newJBool(true))
  if valid_580269 != nil:
    section.add "prettyPrint", valid_580269
  var valid_580270 = query.getOrDefault("oauth_token")
  valid_580270 = validateParameter(valid_580270, JString, required = false,
                                 default = nil)
  if valid_580270 != nil:
    section.add "oauth_token", valid_580270
  var valid_580271 = query.getOrDefault("alt")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = newJString("json"))
  if valid_580271 != nil:
    section.add "alt", valid_580271
  var valid_580272 = query.getOrDefault("userIp")
  valid_580272 = validateParameter(valid_580272, JString, required = false,
                                 default = nil)
  if valid_580272 != nil:
    section.add "userIp", valid_580272
  var valid_580273 = query.getOrDefault("quotaUser")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "quotaUser", valid_580273
  var valid_580274 = query.getOrDefault("fields")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = nil)
  if valid_580274 != nil:
    section.add "fields", valid_580274
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580275: Call_DirectorySchemasGet_580263; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve schema
  ## 
  let valid = call_580275.validator(path, query, header, formData, body)
  let scheme = call_580275.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580275.url(scheme.get, call_580275.host, call_580275.base,
                         call_580275.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580275, url, valid)

proc call*(call_580276: Call_DirectorySchemasGet_580263; schemaKey: string;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directorySchemasGet
  ## Retrieve schema
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   schemaKey: string (required)
  ##            : Name or immutable ID of the schema
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580277 = newJObject()
  var query_580278 = newJObject()
  add(query_580278, "key", newJString(key))
  add(query_580278, "prettyPrint", newJBool(prettyPrint))
  add(query_580278, "oauth_token", newJString(oauthToken))
  add(path_580277, "schemaKey", newJString(schemaKey))
  add(query_580278, "alt", newJString(alt))
  add(query_580278, "userIp", newJString(userIp))
  add(query_580278, "quotaUser", newJString(quotaUser))
  add(path_580277, "customerId", newJString(customerId))
  add(query_580278, "fields", newJString(fields))
  result = call_580276.call(path_580277, query_580278, nil, nil, nil)

var directorySchemasGet* = Call_DirectorySchemasGet_580263(
    name: "directorySchemasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasGet_580264, base: "/admin/directory/v1",
    url: url_DirectorySchemasGet_580265, schemes: {Scheme.Https})
type
  Call_DirectorySchemasPatch_580313 = ref object of OpenApiRestCall_579389
proc url_DirectorySchemasPatch_580315(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "schemaKey" in path, "`schemaKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectorySchemasPatch_580314(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update schema. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaKey: JString (required)
  ##            : Name or immutable ID of the schema.
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `schemaKey` field"
  var valid_580316 = path.getOrDefault("schemaKey")
  valid_580316 = validateParameter(valid_580316, JString, required = true,
                                 default = nil)
  if valid_580316 != nil:
    section.add "schemaKey", valid_580316
  var valid_580317 = path.getOrDefault("customerId")
  valid_580317 = validateParameter(valid_580317, JString, required = true,
                                 default = nil)
  if valid_580317 != nil:
    section.add "customerId", valid_580317
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
  var valid_580318 = query.getOrDefault("key")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "key", valid_580318
  var valid_580319 = query.getOrDefault("prettyPrint")
  valid_580319 = validateParameter(valid_580319, JBool, required = false,
                                 default = newJBool(true))
  if valid_580319 != nil:
    section.add "prettyPrint", valid_580319
  var valid_580320 = query.getOrDefault("oauth_token")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "oauth_token", valid_580320
  var valid_580321 = query.getOrDefault("alt")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = newJString("json"))
  if valid_580321 != nil:
    section.add "alt", valid_580321
  var valid_580322 = query.getOrDefault("userIp")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "userIp", valid_580322
  var valid_580323 = query.getOrDefault("quotaUser")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "quotaUser", valid_580323
  var valid_580324 = query.getOrDefault("fields")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "fields", valid_580324
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

proc call*(call_580326: Call_DirectorySchemasPatch_580313; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema. This method supports patch semantics.
  ## 
  let valid = call_580326.validator(path, query, header, formData, body)
  let scheme = call_580326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580326.url(scheme.get, call_580326.host, call_580326.base,
                         call_580326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580326, url, valid)

proc call*(call_580327: Call_DirectorySchemasPatch_580313; schemaKey: string;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directorySchemasPatch
  ## Update schema. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   schemaKey: string (required)
  ##            : Name or immutable ID of the schema.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580328 = newJObject()
  var query_580329 = newJObject()
  var body_580330 = newJObject()
  add(query_580329, "key", newJString(key))
  add(query_580329, "prettyPrint", newJBool(prettyPrint))
  add(query_580329, "oauth_token", newJString(oauthToken))
  add(path_580328, "schemaKey", newJString(schemaKey))
  add(query_580329, "alt", newJString(alt))
  add(query_580329, "userIp", newJString(userIp))
  add(query_580329, "quotaUser", newJString(quotaUser))
  add(path_580328, "customerId", newJString(customerId))
  if body != nil:
    body_580330 = body
  add(query_580329, "fields", newJString(fields))
  result = call_580327.call(path_580328, query_580329, nil, nil, body_580330)

var directorySchemasPatch* = Call_DirectorySchemasPatch_580313(
    name: "directorySchemasPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasPatch_580314, base: "/admin/directory/v1",
    url: url_DirectorySchemasPatch_580315, schemes: {Scheme.Https})
type
  Call_DirectorySchemasDelete_580297 = ref object of OpenApiRestCall_579389
proc url_DirectorySchemasDelete_580299(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerId" in path, "`customerId` is a required path parameter"
  assert "schemaKey" in path, "`schemaKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customerId"),
               (kind: ConstantSegment, value: "/schemas/"),
               (kind: VariableSegment, value: "schemaKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectorySchemasDelete_580298(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete schema
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   schemaKey: JString (required)
  ##            : Name or immutable ID of the schema
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `schemaKey` field"
  var valid_580300 = path.getOrDefault("schemaKey")
  valid_580300 = validateParameter(valid_580300, JString, required = true,
                                 default = nil)
  if valid_580300 != nil:
    section.add "schemaKey", valid_580300
  var valid_580301 = path.getOrDefault("customerId")
  valid_580301 = validateParameter(valid_580301, JString, required = true,
                                 default = nil)
  if valid_580301 != nil:
    section.add "customerId", valid_580301
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
  var valid_580302 = query.getOrDefault("key")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "key", valid_580302
  var valid_580303 = query.getOrDefault("prettyPrint")
  valid_580303 = validateParameter(valid_580303, JBool, required = false,
                                 default = newJBool(true))
  if valid_580303 != nil:
    section.add "prettyPrint", valid_580303
  var valid_580304 = query.getOrDefault("oauth_token")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "oauth_token", valid_580304
  var valid_580305 = query.getOrDefault("alt")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = newJString("json"))
  if valid_580305 != nil:
    section.add "alt", valid_580305
  var valid_580306 = query.getOrDefault("userIp")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = nil)
  if valid_580306 != nil:
    section.add "userIp", valid_580306
  var valid_580307 = query.getOrDefault("quotaUser")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "quotaUser", valid_580307
  var valid_580308 = query.getOrDefault("fields")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = nil)
  if valid_580308 != nil:
    section.add "fields", valid_580308
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580309: Call_DirectorySchemasDelete_580297; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schema
  ## 
  let valid = call_580309.validator(path, query, header, formData, body)
  let scheme = call_580309.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580309.url(scheme.get, call_580309.host, call_580309.base,
                         call_580309.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580309, url, valid)

proc call*(call_580310: Call_DirectorySchemasDelete_580297; schemaKey: string;
          customerId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directorySchemasDelete
  ## Delete schema
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   schemaKey: string (required)
  ##            : Name or immutable ID of the schema
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580311 = newJObject()
  var query_580312 = newJObject()
  add(query_580312, "key", newJString(key))
  add(query_580312, "prettyPrint", newJBool(prettyPrint))
  add(query_580312, "oauth_token", newJString(oauthToken))
  add(path_580311, "schemaKey", newJString(schemaKey))
  add(query_580312, "alt", newJString(alt))
  add(query_580312, "userIp", newJString(userIp))
  add(query_580312, "quotaUser", newJString(quotaUser))
  add(path_580311, "customerId", newJString(customerId))
  add(query_580312, "fields", newJString(fields))
  result = call_580310.call(path_580311, query_580312, nil, nil, nil)

var directorySchemasDelete* = Call_DirectorySchemasDelete_580297(
    name: "directorySchemasDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasDelete_580298,
    base: "/admin/directory/v1", url: url_DirectorySchemasDelete_580299,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesInsert_580347 = ref object of OpenApiRestCall_579389
proc url_DirectoryDomainAliasesInsert_580349(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/domainaliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryDomainAliasesInsert_580348(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a Domain alias of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580350 = path.getOrDefault("customer")
  valid_580350 = validateParameter(valid_580350, JString, required = true,
                                 default = nil)
  if valid_580350 != nil:
    section.add "customer", valid_580350
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
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("prettyPrint")
  valid_580352 = validateParameter(valid_580352, JBool, required = false,
                                 default = newJBool(true))
  if valid_580352 != nil:
    section.add "prettyPrint", valid_580352
  var valid_580353 = query.getOrDefault("oauth_token")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "oauth_token", valid_580353
  var valid_580354 = query.getOrDefault("alt")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = newJString("json"))
  if valid_580354 != nil:
    section.add "alt", valid_580354
  var valid_580355 = query.getOrDefault("userIp")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "userIp", valid_580355
  var valid_580356 = query.getOrDefault("quotaUser")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "quotaUser", valid_580356
  var valid_580357 = query.getOrDefault("fields")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "fields", valid_580357
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

proc call*(call_580359: Call_DirectoryDomainAliasesInsert_580347; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a Domain alias of the customer.
  ## 
  let valid = call_580359.validator(path, query, header, formData, body)
  let scheme = call_580359.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580359.url(scheme.get, call_580359.host, call_580359.base,
                         call_580359.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580359, url, valid)

proc call*(call_580360: Call_DirectoryDomainAliasesInsert_580347; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryDomainAliasesInsert
  ## Inserts a Domain alias of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580361 = newJObject()
  var query_580362 = newJObject()
  var body_580363 = newJObject()
  add(query_580362, "key", newJString(key))
  add(query_580362, "prettyPrint", newJBool(prettyPrint))
  add(query_580362, "oauth_token", newJString(oauthToken))
  add(path_580361, "customer", newJString(customer))
  add(query_580362, "alt", newJString(alt))
  add(query_580362, "userIp", newJString(userIp))
  add(query_580362, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580363 = body
  add(query_580362, "fields", newJString(fields))
  result = call_580360.call(path_580361, query_580362, nil, nil, body_580363)

var directoryDomainAliasesInsert* = Call_DirectoryDomainAliasesInsert_580347(
    name: "directoryDomainAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesInsert_580348,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesInsert_580349,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesList_580331 = ref object of OpenApiRestCall_579389
proc url_DirectoryDomainAliasesList_580333(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/domainaliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryDomainAliasesList_580332(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the domain aliases of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580334 = path.getOrDefault("customer")
  valid_580334 = validateParameter(valid_580334, JString, required = true,
                                 default = nil)
  if valid_580334 != nil:
    section.add "customer", valid_580334
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
  ##   parentDomainName: JString
  ##                   : Name of the parent domain for which domain aliases are to be fetched.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580335 = query.getOrDefault("key")
  valid_580335 = validateParameter(valid_580335, JString, required = false,
                                 default = nil)
  if valid_580335 != nil:
    section.add "key", valid_580335
  var valid_580336 = query.getOrDefault("prettyPrint")
  valid_580336 = validateParameter(valid_580336, JBool, required = false,
                                 default = newJBool(true))
  if valid_580336 != nil:
    section.add "prettyPrint", valid_580336
  var valid_580337 = query.getOrDefault("oauth_token")
  valid_580337 = validateParameter(valid_580337, JString, required = false,
                                 default = nil)
  if valid_580337 != nil:
    section.add "oauth_token", valid_580337
  var valid_580338 = query.getOrDefault("alt")
  valid_580338 = validateParameter(valid_580338, JString, required = false,
                                 default = newJString("json"))
  if valid_580338 != nil:
    section.add "alt", valid_580338
  var valid_580339 = query.getOrDefault("userIp")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "userIp", valid_580339
  var valid_580340 = query.getOrDefault("quotaUser")
  valid_580340 = validateParameter(valid_580340, JString, required = false,
                                 default = nil)
  if valid_580340 != nil:
    section.add "quotaUser", valid_580340
  var valid_580341 = query.getOrDefault("parentDomainName")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "parentDomainName", valid_580341
  var valid_580342 = query.getOrDefault("fields")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = nil)
  if valid_580342 != nil:
    section.add "fields", valid_580342
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580343: Call_DirectoryDomainAliasesList_580331; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domain aliases of the customer.
  ## 
  let valid = call_580343.validator(path, query, header, formData, body)
  let scheme = call_580343.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580343.url(scheme.get, call_580343.host, call_580343.base,
                         call_580343.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580343, url, valid)

proc call*(call_580344: Call_DirectoryDomainAliasesList_580331; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          parentDomainName: string = ""; fields: string = ""): Recallable =
  ## directoryDomainAliasesList
  ## Lists the domain aliases of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   parentDomainName: string
  ##                   : Name of the parent domain for which domain aliases are to be fetched.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580345 = newJObject()
  var query_580346 = newJObject()
  add(query_580346, "key", newJString(key))
  add(query_580346, "prettyPrint", newJBool(prettyPrint))
  add(query_580346, "oauth_token", newJString(oauthToken))
  add(path_580345, "customer", newJString(customer))
  add(query_580346, "alt", newJString(alt))
  add(query_580346, "userIp", newJString(userIp))
  add(query_580346, "quotaUser", newJString(quotaUser))
  add(query_580346, "parentDomainName", newJString(parentDomainName))
  add(query_580346, "fields", newJString(fields))
  result = call_580344.call(path_580345, query_580346, nil, nil, nil)

var directoryDomainAliasesList* = Call_DirectoryDomainAliasesList_580331(
    name: "directoryDomainAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesList_580332,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesList_580333,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesGet_580364 = ref object of OpenApiRestCall_579389
proc url_DirectoryDomainAliasesGet_580366(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "domainAliasName" in path, "`domainAliasName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/domainaliases/"),
               (kind: VariableSegment, value: "domainAliasName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryDomainAliasesGet_580365(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a domain alias of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   domainAliasName: JString (required)
  ##                  : Name of domain alias to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580367 = path.getOrDefault("customer")
  valid_580367 = validateParameter(valid_580367, JString, required = true,
                                 default = nil)
  if valid_580367 != nil:
    section.add "customer", valid_580367
  var valid_580368 = path.getOrDefault("domainAliasName")
  valid_580368 = validateParameter(valid_580368, JString, required = true,
                                 default = nil)
  if valid_580368 != nil:
    section.add "domainAliasName", valid_580368
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
  var valid_580369 = query.getOrDefault("key")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "key", valid_580369
  var valid_580370 = query.getOrDefault("prettyPrint")
  valid_580370 = validateParameter(valid_580370, JBool, required = false,
                                 default = newJBool(true))
  if valid_580370 != nil:
    section.add "prettyPrint", valid_580370
  var valid_580371 = query.getOrDefault("oauth_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "oauth_token", valid_580371
  var valid_580372 = query.getOrDefault("alt")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = newJString("json"))
  if valid_580372 != nil:
    section.add "alt", valid_580372
  var valid_580373 = query.getOrDefault("userIp")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "userIp", valid_580373
  var valid_580374 = query.getOrDefault("quotaUser")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "quotaUser", valid_580374
  var valid_580375 = query.getOrDefault("fields")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "fields", valid_580375
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580376: Call_DirectoryDomainAliasesGet_580364; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain alias of the customer.
  ## 
  let valid = call_580376.validator(path, query, header, formData, body)
  let scheme = call_580376.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580376.url(scheme.get, call_580376.host, call_580376.base,
                         call_580376.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580376, url, valid)

proc call*(call_580377: Call_DirectoryDomainAliasesGet_580364; customer: string;
          domainAliasName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryDomainAliasesGet
  ## Retrieves a domain alias of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   domainAliasName: string (required)
  ##                  : Name of domain alias to be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580378 = newJObject()
  var query_580379 = newJObject()
  add(query_580379, "key", newJString(key))
  add(query_580379, "prettyPrint", newJBool(prettyPrint))
  add(query_580379, "oauth_token", newJString(oauthToken))
  add(path_580378, "customer", newJString(customer))
  add(query_580379, "alt", newJString(alt))
  add(query_580379, "userIp", newJString(userIp))
  add(query_580379, "quotaUser", newJString(quotaUser))
  add(path_580378, "domainAliasName", newJString(domainAliasName))
  add(query_580379, "fields", newJString(fields))
  result = call_580377.call(path_580378, query_580379, nil, nil, nil)

var directoryDomainAliasesGet* = Call_DirectoryDomainAliasesGet_580364(
    name: "directoryDomainAliasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesGet_580365,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesGet_580366,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesDelete_580380 = ref object of OpenApiRestCall_579389
proc url_DirectoryDomainAliasesDelete_580382(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "domainAliasName" in path, "`domainAliasName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/domainaliases/"),
               (kind: VariableSegment, value: "domainAliasName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryDomainAliasesDelete_580381(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Domain Alias of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   domainAliasName: JString (required)
  ##                  : Name of domain alias to be retrieved.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580383 = path.getOrDefault("customer")
  valid_580383 = validateParameter(valid_580383, JString, required = true,
                                 default = nil)
  if valid_580383 != nil:
    section.add "customer", valid_580383
  var valid_580384 = path.getOrDefault("domainAliasName")
  valid_580384 = validateParameter(valid_580384, JString, required = true,
                                 default = nil)
  if valid_580384 != nil:
    section.add "domainAliasName", valid_580384
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
  var valid_580385 = query.getOrDefault("key")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "key", valid_580385
  var valid_580386 = query.getOrDefault("prettyPrint")
  valid_580386 = validateParameter(valid_580386, JBool, required = false,
                                 default = newJBool(true))
  if valid_580386 != nil:
    section.add "prettyPrint", valid_580386
  var valid_580387 = query.getOrDefault("oauth_token")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "oauth_token", valid_580387
  var valid_580388 = query.getOrDefault("alt")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = newJString("json"))
  if valid_580388 != nil:
    section.add "alt", valid_580388
  var valid_580389 = query.getOrDefault("userIp")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "userIp", valid_580389
  var valid_580390 = query.getOrDefault("quotaUser")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "quotaUser", valid_580390
  var valid_580391 = query.getOrDefault("fields")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "fields", valid_580391
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580392: Call_DirectoryDomainAliasesDelete_580380; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Domain Alias of the customer.
  ## 
  let valid = call_580392.validator(path, query, header, formData, body)
  let scheme = call_580392.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580392.url(scheme.get, call_580392.host, call_580392.base,
                         call_580392.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580392, url, valid)

proc call*(call_580393: Call_DirectoryDomainAliasesDelete_580380; customer: string;
          domainAliasName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryDomainAliasesDelete
  ## Deletes a Domain Alias of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   domainAliasName: string (required)
  ##                  : Name of domain alias to be retrieved.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580394 = newJObject()
  var query_580395 = newJObject()
  add(query_580395, "key", newJString(key))
  add(query_580395, "prettyPrint", newJBool(prettyPrint))
  add(query_580395, "oauth_token", newJString(oauthToken))
  add(path_580394, "customer", newJString(customer))
  add(query_580395, "alt", newJString(alt))
  add(query_580395, "userIp", newJString(userIp))
  add(query_580395, "quotaUser", newJString(quotaUser))
  add(path_580394, "domainAliasName", newJString(domainAliasName))
  add(query_580395, "fields", newJString(fields))
  result = call_580393.call(path_580394, query_580395, nil, nil, nil)

var directoryDomainAliasesDelete* = Call_DirectoryDomainAliasesDelete_580380(
    name: "directoryDomainAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesDelete_580381,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesDelete_580382,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsInsert_580411 = ref object of OpenApiRestCall_579389
proc url_DirectoryDomainsInsert_580413(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/domains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryDomainsInsert_580412(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a domain of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580414 = path.getOrDefault("customer")
  valid_580414 = validateParameter(valid_580414, JString, required = true,
                                 default = nil)
  if valid_580414 != nil:
    section.add "customer", valid_580414
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
  var valid_580415 = query.getOrDefault("key")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "key", valid_580415
  var valid_580416 = query.getOrDefault("prettyPrint")
  valid_580416 = validateParameter(valid_580416, JBool, required = false,
                                 default = newJBool(true))
  if valid_580416 != nil:
    section.add "prettyPrint", valid_580416
  var valid_580417 = query.getOrDefault("oauth_token")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "oauth_token", valid_580417
  var valid_580418 = query.getOrDefault("alt")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = newJString("json"))
  if valid_580418 != nil:
    section.add "alt", valid_580418
  var valid_580419 = query.getOrDefault("userIp")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "userIp", valid_580419
  var valid_580420 = query.getOrDefault("quotaUser")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "quotaUser", valid_580420
  var valid_580421 = query.getOrDefault("fields")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "fields", valid_580421
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

proc call*(call_580423: Call_DirectoryDomainsInsert_580411; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a domain of the customer.
  ## 
  let valid = call_580423.validator(path, query, header, formData, body)
  let scheme = call_580423.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580423.url(scheme.get, call_580423.host, call_580423.base,
                         call_580423.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580423, url, valid)

proc call*(call_580424: Call_DirectoryDomainsInsert_580411; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryDomainsInsert
  ## Inserts a domain of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580425 = newJObject()
  var query_580426 = newJObject()
  var body_580427 = newJObject()
  add(query_580426, "key", newJString(key))
  add(query_580426, "prettyPrint", newJBool(prettyPrint))
  add(query_580426, "oauth_token", newJString(oauthToken))
  add(path_580425, "customer", newJString(customer))
  add(query_580426, "alt", newJString(alt))
  add(query_580426, "userIp", newJString(userIp))
  add(query_580426, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580427 = body
  add(query_580426, "fields", newJString(fields))
  result = call_580424.call(path_580425, query_580426, nil, nil, body_580427)

var directoryDomainsInsert* = Call_DirectoryDomainsInsert_580411(
    name: "directoryDomainsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsInsert_580412,
    base: "/admin/directory/v1", url: url_DirectoryDomainsInsert_580413,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsList_580396 = ref object of OpenApiRestCall_579389
proc url_DirectoryDomainsList_580398(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/domains")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryDomainsList_580397(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the domains of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580399 = path.getOrDefault("customer")
  valid_580399 = validateParameter(valid_580399, JString, required = true,
                                 default = nil)
  if valid_580399 != nil:
    section.add "customer", valid_580399
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
  var valid_580400 = query.getOrDefault("key")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "key", valid_580400
  var valid_580401 = query.getOrDefault("prettyPrint")
  valid_580401 = validateParameter(valid_580401, JBool, required = false,
                                 default = newJBool(true))
  if valid_580401 != nil:
    section.add "prettyPrint", valid_580401
  var valid_580402 = query.getOrDefault("oauth_token")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "oauth_token", valid_580402
  var valid_580403 = query.getOrDefault("alt")
  valid_580403 = validateParameter(valid_580403, JString, required = false,
                                 default = newJString("json"))
  if valid_580403 != nil:
    section.add "alt", valid_580403
  var valid_580404 = query.getOrDefault("userIp")
  valid_580404 = validateParameter(valid_580404, JString, required = false,
                                 default = nil)
  if valid_580404 != nil:
    section.add "userIp", valid_580404
  var valid_580405 = query.getOrDefault("quotaUser")
  valid_580405 = validateParameter(valid_580405, JString, required = false,
                                 default = nil)
  if valid_580405 != nil:
    section.add "quotaUser", valid_580405
  var valid_580406 = query.getOrDefault("fields")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "fields", valid_580406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580407: Call_DirectoryDomainsList_580396; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domains of the customer.
  ## 
  let valid = call_580407.validator(path, query, header, formData, body)
  let scheme = call_580407.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580407.url(scheme.get, call_580407.host, call_580407.base,
                         call_580407.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580407, url, valid)

proc call*(call_580408: Call_DirectoryDomainsList_580396; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryDomainsList
  ## Lists the domains of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580409 = newJObject()
  var query_580410 = newJObject()
  add(query_580410, "key", newJString(key))
  add(query_580410, "prettyPrint", newJBool(prettyPrint))
  add(query_580410, "oauth_token", newJString(oauthToken))
  add(path_580409, "customer", newJString(customer))
  add(query_580410, "alt", newJString(alt))
  add(query_580410, "userIp", newJString(userIp))
  add(query_580410, "quotaUser", newJString(quotaUser))
  add(query_580410, "fields", newJString(fields))
  result = call_580408.call(path_580409, query_580410, nil, nil, nil)

var directoryDomainsList* = Call_DirectoryDomainsList_580396(
    name: "directoryDomainsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsList_580397, base: "/admin/directory/v1",
    url: url_DirectoryDomainsList_580398, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsGet_580428 = ref object of OpenApiRestCall_579389
proc url_DirectoryDomainsGet_580430(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/domains/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryDomainsGet_580429(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a domain of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   domainName: JString (required)
  ##             : Name of domain to be retrieved
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580431 = path.getOrDefault("customer")
  valid_580431 = validateParameter(valid_580431, JString, required = true,
                                 default = nil)
  if valid_580431 != nil:
    section.add "customer", valid_580431
  var valid_580432 = path.getOrDefault("domainName")
  valid_580432 = validateParameter(valid_580432, JString, required = true,
                                 default = nil)
  if valid_580432 != nil:
    section.add "domainName", valid_580432
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
  var valid_580433 = query.getOrDefault("key")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = nil)
  if valid_580433 != nil:
    section.add "key", valid_580433
  var valid_580434 = query.getOrDefault("prettyPrint")
  valid_580434 = validateParameter(valid_580434, JBool, required = false,
                                 default = newJBool(true))
  if valid_580434 != nil:
    section.add "prettyPrint", valid_580434
  var valid_580435 = query.getOrDefault("oauth_token")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "oauth_token", valid_580435
  var valid_580436 = query.getOrDefault("alt")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = newJString("json"))
  if valid_580436 != nil:
    section.add "alt", valid_580436
  var valid_580437 = query.getOrDefault("userIp")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "userIp", valid_580437
  var valid_580438 = query.getOrDefault("quotaUser")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "quotaUser", valid_580438
  var valid_580439 = query.getOrDefault("fields")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "fields", valid_580439
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580440: Call_DirectoryDomainsGet_580428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain of the customer.
  ## 
  let valid = call_580440.validator(path, query, header, formData, body)
  let scheme = call_580440.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580440.url(scheme.get, call_580440.host, call_580440.base,
                         call_580440.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580440, url, valid)

proc call*(call_580441: Call_DirectoryDomainsGet_580428; customer: string;
          domainName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryDomainsGet
  ## Retrieves a domain of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   domainName: string (required)
  ##             : Name of domain to be retrieved
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580442 = newJObject()
  var query_580443 = newJObject()
  add(query_580443, "key", newJString(key))
  add(query_580443, "prettyPrint", newJBool(prettyPrint))
  add(query_580443, "oauth_token", newJString(oauthToken))
  add(path_580442, "customer", newJString(customer))
  add(query_580443, "alt", newJString(alt))
  add(query_580443, "userIp", newJString(userIp))
  add(query_580443, "quotaUser", newJString(quotaUser))
  add(path_580442, "domainName", newJString(domainName))
  add(query_580443, "fields", newJString(fields))
  result = call_580441.call(path_580442, query_580443, nil, nil, nil)

var directoryDomainsGet* = Call_DirectoryDomainsGet_580428(
    name: "directoryDomainsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsGet_580429, base: "/admin/directory/v1",
    url: url_DirectoryDomainsGet_580430, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsDelete_580444 = ref object of OpenApiRestCall_579389
proc url_DirectoryDomainsDelete_580446(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "domainName" in path, "`domainName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/domains/"),
               (kind: VariableSegment, value: "domainName")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryDomainsDelete_580445(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a domain of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   domainName: JString (required)
  ##             : Name of domain to be deleted
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580447 = path.getOrDefault("customer")
  valid_580447 = validateParameter(valid_580447, JString, required = true,
                                 default = nil)
  if valid_580447 != nil:
    section.add "customer", valid_580447
  var valid_580448 = path.getOrDefault("domainName")
  valid_580448 = validateParameter(valid_580448, JString, required = true,
                                 default = nil)
  if valid_580448 != nil:
    section.add "domainName", valid_580448
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
  var valid_580449 = query.getOrDefault("key")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "key", valid_580449
  var valid_580450 = query.getOrDefault("prettyPrint")
  valid_580450 = validateParameter(valid_580450, JBool, required = false,
                                 default = newJBool(true))
  if valid_580450 != nil:
    section.add "prettyPrint", valid_580450
  var valid_580451 = query.getOrDefault("oauth_token")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "oauth_token", valid_580451
  var valid_580452 = query.getOrDefault("alt")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = newJString("json"))
  if valid_580452 != nil:
    section.add "alt", valid_580452
  var valid_580453 = query.getOrDefault("userIp")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "userIp", valid_580453
  var valid_580454 = query.getOrDefault("quotaUser")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "quotaUser", valid_580454
  var valid_580455 = query.getOrDefault("fields")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "fields", valid_580455
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580456: Call_DirectoryDomainsDelete_580444; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a domain of the customer.
  ## 
  let valid = call_580456.validator(path, query, header, formData, body)
  let scheme = call_580456.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580456.url(scheme.get, call_580456.host, call_580456.base,
                         call_580456.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580456, url, valid)

proc call*(call_580457: Call_DirectoryDomainsDelete_580444; customer: string;
          domainName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryDomainsDelete
  ## Deletes a domain of the customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   domainName: string (required)
  ##             : Name of domain to be deleted
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580458 = newJObject()
  var query_580459 = newJObject()
  add(query_580459, "key", newJString(key))
  add(query_580459, "prettyPrint", newJBool(prettyPrint))
  add(query_580459, "oauth_token", newJString(oauthToken))
  add(path_580458, "customer", newJString(customer))
  add(query_580459, "alt", newJString(alt))
  add(query_580459, "userIp", newJString(userIp))
  add(query_580459, "quotaUser", newJString(quotaUser))
  add(path_580458, "domainName", newJString(domainName))
  add(query_580459, "fields", newJString(fields))
  result = call_580457.call(path_580458, query_580459, nil, nil, nil)

var directoryDomainsDelete* = Call_DirectoryDomainsDelete_580444(
    name: "directoryDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsDelete_580445,
    base: "/admin/directory/v1", url: url_DirectoryDomainsDelete_580446,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsList_580460 = ref object of OpenApiRestCall_579389
proc url_DirectoryNotificationsList_580462(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/notifications")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryNotificationsList_580461(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of notifications.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580463 = path.getOrDefault("customer")
  valid_580463 = validateParameter(valid_580463, JString, required = true,
                                 default = nil)
  if valid_580463 != nil:
    section.add "customer", valid_580463
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
  ##            : The token to specify the page of results to retrieve.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: JString
  ##           : The ISO 639-1 code of the language notifications are returned in. The default is English (en).
  ##   maxResults: JInt
  ##             : Maximum number of notifications to return per page. The default is 100.
  section = newJObject()
  var valid_580464 = query.getOrDefault("key")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "key", valid_580464
  var valid_580465 = query.getOrDefault("prettyPrint")
  valid_580465 = validateParameter(valid_580465, JBool, required = false,
                                 default = newJBool(true))
  if valid_580465 != nil:
    section.add "prettyPrint", valid_580465
  var valid_580466 = query.getOrDefault("oauth_token")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "oauth_token", valid_580466
  var valid_580467 = query.getOrDefault("alt")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = newJString("json"))
  if valid_580467 != nil:
    section.add "alt", valid_580467
  var valid_580468 = query.getOrDefault("userIp")
  valid_580468 = validateParameter(valid_580468, JString, required = false,
                                 default = nil)
  if valid_580468 != nil:
    section.add "userIp", valid_580468
  var valid_580469 = query.getOrDefault("quotaUser")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "quotaUser", valid_580469
  var valid_580470 = query.getOrDefault("pageToken")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = nil)
  if valid_580470 != nil:
    section.add "pageToken", valid_580470
  var valid_580471 = query.getOrDefault("fields")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "fields", valid_580471
  var valid_580472 = query.getOrDefault("language")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "language", valid_580472
  var valid_580473 = query.getOrDefault("maxResults")
  valid_580473 = validateParameter(valid_580473, JInt, required = false, default = nil)
  if valid_580473 != nil:
    section.add "maxResults", valid_580473
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580474: Call_DirectoryNotificationsList_580460; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notifications.
  ## 
  let valid = call_580474.validator(path, query, header, formData, body)
  let scheme = call_580474.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580474.url(scheme.get, call_580474.host, call_580474.base,
                         call_580474.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580474, url, valid)

proc call*(call_580475: Call_DirectoryNotificationsList_580460; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; language: string = "";
          maxResults: int = 0): Recallable =
  ## directoryNotificationsList
  ## Retrieves a list of notifications.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : The token to specify the page of results to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   language: string
  ##           : The ISO 639-1 code of the language notifications are returned in. The default is English (en).
  ##   maxResults: int
  ##             : Maximum number of notifications to return per page. The default is 100.
  var path_580476 = newJObject()
  var query_580477 = newJObject()
  add(query_580477, "key", newJString(key))
  add(query_580477, "prettyPrint", newJBool(prettyPrint))
  add(query_580477, "oauth_token", newJString(oauthToken))
  add(path_580476, "customer", newJString(customer))
  add(query_580477, "alt", newJString(alt))
  add(query_580477, "userIp", newJString(userIp))
  add(query_580477, "quotaUser", newJString(quotaUser))
  add(query_580477, "pageToken", newJString(pageToken))
  add(query_580477, "fields", newJString(fields))
  add(query_580477, "language", newJString(language))
  add(query_580477, "maxResults", newJInt(maxResults))
  result = call_580475.call(path_580476, query_580477, nil, nil, nil)

var directoryNotificationsList* = Call_DirectoryNotificationsList_580460(
    name: "directoryNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/notifications",
    validator: validate_DirectoryNotificationsList_580461,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsList_580462,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsUpdate_580494 = ref object of OpenApiRestCall_579389
proc url_DirectoryNotificationsUpdate_580496(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "notificationId" in path, "`notificationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryNotificationsUpdate_580495(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   notificationId: JString (required)
  ##                 : The unique ID of the notification.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `notificationId` field"
  var valid_580497 = path.getOrDefault("notificationId")
  valid_580497 = validateParameter(valid_580497, JString, required = true,
                                 default = nil)
  if valid_580497 != nil:
    section.add "notificationId", valid_580497
  var valid_580498 = path.getOrDefault("customer")
  valid_580498 = validateParameter(valid_580498, JString, required = true,
                                 default = nil)
  if valid_580498 != nil:
    section.add "customer", valid_580498
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
  var valid_580499 = query.getOrDefault("key")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "key", valid_580499
  var valid_580500 = query.getOrDefault("prettyPrint")
  valid_580500 = validateParameter(valid_580500, JBool, required = false,
                                 default = newJBool(true))
  if valid_580500 != nil:
    section.add "prettyPrint", valid_580500
  var valid_580501 = query.getOrDefault("oauth_token")
  valid_580501 = validateParameter(valid_580501, JString, required = false,
                                 default = nil)
  if valid_580501 != nil:
    section.add "oauth_token", valid_580501
  var valid_580502 = query.getOrDefault("alt")
  valid_580502 = validateParameter(valid_580502, JString, required = false,
                                 default = newJString("json"))
  if valid_580502 != nil:
    section.add "alt", valid_580502
  var valid_580503 = query.getOrDefault("userIp")
  valid_580503 = validateParameter(valid_580503, JString, required = false,
                                 default = nil)
  if valid_580503 != nil:
    section.add "userIp", valid_580503
  var valid_580504 = query.getOrDefault("quotaUser")
  valid_580504 = validateParameter(valid_580504, JString, required = false,
                                 default = nil)
  if valid_580504 != nil:
    section.add "quotaUser", valid_580504
  var valid_580505 = query.getOrDefault("fields")
  valid_580505 = validateParameter(valid_580505, JString, required = false,
                                 default = nil)
  if valid_580505 != nil:
    section.add "fields", valid_580505
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

proc call*(call_580507: Call_DirectoryNotificationsUpdate_580494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification.
  ## 
  let valid = call_580507.validator(path, query, header, formData, body)
  let scheme = call_580507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580507.url(scheme.get, call_580507.host, call_580507.base,
                         call_580507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580507, url, valid)

proc call*(call_580508: Call_DirectoryNotificationsUpdate_580494;
          notificationId: string; customer: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryNotificationsUpdate
  ## Updates a notification.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   notificationId: string (required)
  ##                 : The unique ID of the notification.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580509 = newJObject()
  var query_580510 = newJObject()
  var body_580511 = newJObject()
  add(query_580510, "key", newJString(key))
  add(query_580510, "prettyPrint", newJBool(prettyPrint))
  add(query_580510, "oauth_token", newJString(oauthToken))
  add(path_580509, "notificationId", newJString(notificationId))
  add(path_580509, "customer", newJString(customer))
  add(query_580510, "alt", newJString(alt))
  add(query_580510, "userIp", newJString(userIp))
  add(query_580510, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580511 = body
  add(query_580510, "fields", newJString(fields))
  result = call_580508.call(path_580509, query_580510, nil, nil, body_580511)

var directoryNotificationsUpdate* = Call_DirectoryNotificationsUpdate_580494(
    name: "directoryNotificationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsUpdate_580495,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsUpdate_580496,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsGet_580478 = ref object of OpenApiRestCall_579389
proc url_DirectoryNotificationsGet_580480(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "notificationId" in path, "`notificationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryNotificationsGet_580479(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a notification.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   notificationId: JString (required)
  ##                 : The unique ID of the notification.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. The customerId is also returned as part of the Users resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `notificationId` field"
  var valid_580481 = path.getOrDefault("notificationId")
  valid_580481 = validateParameter(valid_580481, JString, required = true,
                                 default = nil)
  if valid_580481 != nil:
    section.add "notificationId", valid_580481
  var valid_580482 = path.getOrDefault("customer")
  valid_580482 = validateParameter(valid_580482, JString, required = true,
                                 default = nil)
  if valid_580482 != nil:
    section.add "customer", valid_580482
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
  var valid_580483 = query.getOrDefault("key")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "key", valid_580483
  var valid_580484 = query.getOrDefault("prettyPrint")
  valid_580484 = validateParameter(valid_580484, JBool, required = false,
                                 default = newJBool(true))
  if valid_580484 != nil:
    section.add "prettyPrint", valid_580484
  var valid_580485 = query.getOrDefault("oauth_token")
  valid_580485 = validateParameter(valid_580485, JString, required = false,
                                 default = nil)
  if valid_580485 != nil:
    section.add "oauth_token", valid_580485
  var valid_580486 = query.getOrDefault("alt")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = newJString("json"))
  if valid_580486 != nil:
    section.add "alt", valid_580486
  var valid_580487 = query.getOrDefault("userIp")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = nil)
  if valid_580487 != nil:
    section.add "userIp", valid_580487
  var valid_580488 = query.getOrDefault("quotaUser")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "quotaUser", valid_580488
  var valid_580489 = query.getOrDefault("fields")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "fields", valid_580489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580490: Call_DirectoryNotificationsGet_580478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a notification.
  ## 
  let valid = call_580490.validator(path, query, header, formData, body)
  let scheme = call_580490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580490.url(scheme.get, call_580490.host, call_580490.base,
                         call_580490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580490, url, valid)

proc call*(call_580491: Call_DirectoryNotificationsGet_580478;
          notificationId: string; customer: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryNotificationsGet
  ## Retrieves a notification.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   notificationId: string (required)
  ##                 : The unique ID of the notification.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. The customerId is also returned as part of the Users resource.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580492 = newJObject()
  var query_580493 = newJObject()
  add(query_580493, "key", newJString(key))
  add(query_580493, "prettyPrint", newJBool(prettyPrint))
  add(query_580493, "oauth_token", newJString(oauthToken))
  add(path_580492, "notificationId", newJString(notificationId))
  add(path_580492, "customer", newJString(customer))
  add(query_580493, "alt", newJString(alt))
  add(query_580493, "userIp", newJString(userIp))
  add(query_580493, "quotaUser", newJString(quotaUser))
  add(query_580493, "fields", newJString(fields))
  result = call_580491.call(path_580492, query_580493, nil, nil, nil)

var directoryNotificationsGet* = Call_DirectoryNotificationsGet_580478(
    name: "directoryNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsGet_580479,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsGet_580480,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsPatch_580528 = ref object of OpenApiRestCall_579389
proc url_DirectoryNotificationsPatch_580530(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "notificationId" in path, "`notificationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryNotificationsPatch_580529(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a notification. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   notificationId: JString (required)
  ##                 : The unique ID of the notification.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `notificationId` field"
  var valid_580531 = path.getOrDefault("notificationId")
  valid_580531 = validateParameter(valid_580531, JString, required = true,
                                 default = nil)
  if valid_580531 != nil:
    section.add "notificationId", valid_580531
  var valid_580532 = path.getOrDefault("customer")
  valid_580532 = validateParameter(valid_580532, JString, required = true,
                                 default = nil)
  if valid_580532 != nil:
    section.add "customer", valid_580532
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
  var valid_580533 = query.getOrDefault("key")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "key", valid_580533
  var valid_580534 = query.getOrDefault("prettyPrint")
  valid_580534 = validateParameter(valid_580534, JBool, required = false,
                                 default = newJBool(true))
  if valid_580534 != nil:
    section.add "prettyPrint", valid_580534
  var valid_580535 = query.getOrDefault("oauth_token")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = nil)
  if valid_580535 != nil:
    section.add "oauth_token", valid_580535
  var valid_580536 = query.getOrDefault("alt")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = newJString("json"))
  if valid_580536 != nil:
    section.add "alt", valid_580536
  var valid_580537 = query.getOrDefault("userIp")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "userIp", valid_580537
  var valid_580538 = query.getOrDefault("quotaUser")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "quotaUser", valid_580538
  var valid_580539 = query.getOrDefault("fields")
  valid_580539 = validateParameter(valid_580539, JString, required = false,
                                 default = nil)
  if valid_580539 != nil:
    section.add "fields", valid_580539
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

proc call*(call_580541: Call_DirectoryNotificationsPatch_580528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification. This method supports patch semantics.
  ## 
  let valid = call_580541.validator(path, query, header, formData, body)
  let scheme = call_580541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580541.url(scheme.get, call_580541.host, call_580541.base,
                         call_580541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580541, url, valid)

proc call*(call_580542: Call_DirectoryNotificationsPatch_580528;
          notificationId: string; customer: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryNotificationsPatch
  ## Updates a notification. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   notificationId: string (required)
  ##                 : The unique ID of the notification.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580543 = newJObject()
  var query_580544 = newJObject()
  var body_580545 = newJObject()
  add(query_580544, "key", newJString(key))
  add(query_580544, "prettyPrint", newJBool(prettyPrint))
  add(query_580544, "oauth_token", newJString(oauthToken))
  add(path_580543, "notificationId", newJString(notificationId))
  add(path_580543, "customer", newJString(customer))
  add(query_580544, "alt", newJString(alt))
  add(query_580544, "userIp", newJString(userIp))
  add(query_580544, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580545 = body
  add(query_580544, "fields", newJString(fields))
  result = call_580542.call(path_580543, query_580544, nil, nil, body_580545)

var directoryNotificationsPatch* = Call_DirectoryNotificationsPatch_580528(
    name: "directoryNotificationsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsPatch_580529,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsPatch_580530,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsDelete_580512 = ref object of OpenApiRestCall_579389
proc url_DirectoryNotificationsDelete_580514(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "notificationId" in path, "`notificationId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/notifications/"),
               (kind: VariableSegment, value: "notificationId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryNotificationsDelete_580513(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a notification
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   notificationId: JString (required)
  ##                 : The unique ID of the notification.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. The customerId is also returned as part of the Users resource.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `notificationId` field"
  var valid_580515 = path.getOrDefault("notificationId")
  valid_580515 = validateParameter(valid_580515, JString, required = true,
                                 default = nil)
  if valid_580515 != nil:
    section.add "notificationId", valid_580515
  var valid_580516 = path.getOrDefault("customer")
  valid_580516 = validateParameter(valid_580516, JString, required = true,
                                 default = nil)
  if valid_580516 != nil:
    section.add "customer", valid_580516
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
  var valid_580517 = query.getOrDefault("key")
  valid_580517 = validateParameter(valid_580517, JString, required = false,
                                 default = nil)
  if valid_580517 != nil:
    section.add "key", valid_580517
  var valid_580518 = query.getOrDefault("prettyPrint")
  valid_580518 = validateParameter(valid_580518, JBool, required = false,
                                 default = newJBool(true))
  if valid_580518 != nil:
    section.add "prettyPrint", valid_580518
  var valid_580519 = query.getOrDefault("oauth_token")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = nil)
  if valid_580519 != nil:
    section.add "oauth_token", valid_580519
  var valid_580520 = query.getOrDefault("alt")
  valid_580520 = validateParameter(valid_580520, JString, required = false,
                                 default = newJString("json"))
  if valid_580520 != nil:
    section.add "alt", valid_580520
  var valid_580521 = query.getOrDefault("userIp")
  valid_580521 = validateParameter(valid_580521, JString, required = false,
                                 default = nil)
  if valid_580521 != nil:
    section.add "userIp", valid_580521
  var valid_580522 = query.getOrDefault("quotaUser")
  valid_580522 = validateParameter(valid_580522, JString, required = false,
                                 default = nil)
  if valid_580522 != nil:
    section.add "quotaUser", valid_580522
  var valid_580523 = query.getOrDefault("fields")
  valid_580523 = validateParameter(valid_580523, JString, required = false,
                                 default = nil)
  if valid_580523 != nil:
    section.add "fields", valid_580523
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580524: Call_DirectoryNotificationsDelete_580512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a notification
  ## 
  let valid = call_580524.validator(path, query, header, formData, body)
  let scheme = call_580524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580524.url(scheme.get, call_580524.host, call_580524.base,
                         call_580524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580524, url, valid)

proc call*(call_580525: Call_DirectoryNotificationsDelete_580512;
          notificationId: string; customer: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryNotificationsDelete
  ## Deletes a notification
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   notificationId: string (required)
  ##                 : The unique ID of the notification.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. The customerId is also returned as part of the Users resource.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580526 = newJObject()
  var query_580527 = newJObject()
  add(query_580527, "key", newJString(key))
  add(query_580527, "prettyPrint", newJBool(prettyPrint))
  add(query_580527, "oauth_token", newJString(oauthToken))
  add(path_580526, "notificationId", newJString(notificationId))
  add(path_580526, "customer", newJString(customer))
  add(query_580527, "alt", newJString(alt))
  add(query_580527, "userIp", newJString(userIp))
  add(query_580527, "quotaUser", newJString(quotaUser))
  add(query_580527, "fields", newJString(fields))
  result = call_580525.call(path_580526, query_580527, nil, nil, nil)

var directoryNotificationsDelete* = Call_DirectoryNotificationsDelete_580512(
    name: "directoryNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsDelete_580513,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsDelete_580514,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsInsert_580563 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesBuildingsInsert_580565(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/buildings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsInsert_580564(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a building.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580566 = path.getOrDefault("customer")
  valid_580566 = validateParameter(valid_580566, JString, required = true,
                                 default = nil)
  if valid_580566 != nil:
    section.add "customer", valid_580566
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
  ##   coordinatesSource: JString
  ##                    : Source from which Building.coordinates are derived.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580567 = query.getOrDefault("key")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "key", valid_580567
  var valid_580568 = query.getOrDefault("prettyPrint")
  valid_580568 = validateParameter(valid_580568, JBool, required = false,
                                 default = newJBool(true))
  if valid_580568 != nil:
    section.add "prettyPrint", valid_580568
  var valid_580569 = query.getOrDefault("oauth_token")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "oauth_token", valid_580569
  var valid_580570 = query.getOrDefault("alt")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = newJString("json"))
  if valid_580570 != nil:
    section.add "alt", valid_580570
  var valid_580571 = query.getOrDefault("userIp")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "userIp", valid_580571
  var valid_580572 = query.getOrDefault("quotaUser")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "quotaUser", valid_580572
  var valid_580573 = query.getOrDefault("coordinatesSource")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_580573 != nil:
    section.add "coordinatesSource", valid_580573
  var valid_580574 = query.getOrDefault("fields")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "fields", valid_580574
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

proc call*(call_580576: Call_DirectoryResourcesBuildingsInsert_580563;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a building.
  ## 
  let valid = call_580576.validator(path, query, header, formData, body)
  let scheme = call_580576.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580576.url(scheme.get, call_580576.host, call_580576.base,
                         call_580576.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580576, url, valid)

proc call*(call_580577: Call_DirectoryResourcesBuildingsInsert_580563;
          customer: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil;
          coordinatesSource: string = "SOURCE_UNSPECIFIED"; fields: string = ""): Recallable =
  ## directoryResourcesBuildingsInsert
  ## Inserts a building.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   coordinatesSource: string
  ##                    : Source from which Building.coordinates are derived.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580578 = newJObject()
  var query_580579 = newJObject()
  var body_580580 = newJObject()
  add(query_580579, "key", newJString(key))
  add(query_580579, "prettyPrint", newJBool(prettyPrint))
  add(query_580579, "oauth_token", newJString(oauthToken))
  add(path_580578, "customer", newJString(customer))
  add(query_580579, "alt", newJString(alt))
  add(query_580579, "userIp", newJString(userIp))
  add(query_580579, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580580 = body
  add(query_580579, "coordinatesSource", newJString(coordinatesSource))
  add(query_580579, "fields", newJString(fields))
  result = call_580577.call(path_580578, query_580579, nil, nil, body_580580)

var directoryResourcesBuildingsInsert* = Call_DirectoryResourcesBuildingsInsert_580563(
    name: "directoryResourcesBuildingsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsInsert_580564,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsInsert_580565,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsList_580546 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesBuildingsList_580548(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/buildings")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsList_580547(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of buildings for an account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580549 = path.getOrDefault("customer")
  valid_580549 = validateParameter(valid_580549, JString, required = true,
                                 default = nil)
  if valid_580549 != nil:
    section.add "customer", valid_580549
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
  ##            : Token to specify the next page in the list.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_580550 = query.getOrDefault("key")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = nil)
  if valid_580550 != nil:
    section.add "key", valid_580550
  var valid_580551 = query.getOrDefault("prettyPrint")
  valid_580551 = validateParameter(valid_580551, JBool, required = false,
                                 default = newJBool(true))
  if valid_580551 != nil:
    section.add "prettyPrint", valid_580551
  var valid_580552 = query.getOrDefault("oauth_token")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "oauth_token", valid_580552
  var valid_580553 = query.getOrDefault("alt")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = newJString("json"))
  if valid_580553 != nil:
    section.add "alt", valid_580553
  var valid_580554 = query.getOrDefault("userIp")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "userIp", valid_580554
  var valid_580555 = query.getOrDefault("quotaUser")
  valid_580555 = validateParameter(valid_580555, JString, required = false,
                                 default = nil)
  if valid_580555 != nil:
    section.add "quotaUser", valid_580555
  var valid_580556 = query.getOrDefault("pageToken")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "pageToken", valid_580556
  var valid_580557 = query.getOrDefault("fields")
  valid_580557 = validateParameter(valid_580557, JString, required = false,
                                 default = nil)
  if valid_580557 != nil:
    section.add "fields", valid_580557
  var valid_580558 = query.getOrDefault("maxResults")
  valid_580558 = validateParameter(valid_580558, JInt, required = false, default = nil)
  if valid_580558 != nil:
    section.add "maxResults", valid_580558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580559: Call_DirectoryResourcesBuildingsList_580546;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of buildings for an account.
  ## 
  let valid = call_580559.validator(path, query, header, formData, body)
  let scheme = call_580559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580559.url(scheme.get, call_580559.host, call_580559.base,
                         call_580559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580559, url, valid)

proc call*(call_580560: Call_DirectoryResourcesBuildingsList_580546;
          customer: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## directoryResourcesBuildingsList
  ## Retrieves a list of buildings for an account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var path_580561 = newJObject()
  var query_580562 = newJObject()
  add(query_580562, "key", newJString(key))
  add(query_580562, "prettyPrint", newJBool(prettyPrint))
  add(query_580562, "oauth_token", newJString(oauthToken))
  add(path_580561, "customer", newJString(customer))
  add(query_580562, "alt", newJString(alt))
  add(query_580562, "userIp", newJString(userIp))
  add(query_580562, "quotaUser", newJString(quotaUser))
  add(query_580562, "pageToken", newJString(pageToken))
  add(query_580562, "fields", newJString(fields))
  add(query_580562, "maxResults", newJInt(maxResults))
  result = call_580560.call(path_580561, query_580562, nil, nil, nil)

var directoryResourcesBuildingsList* = Call_DirectoryResourcesBuildingsList_580546(
    name: "directoryResourcesBuildingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsList_580547,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsList_580548,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsUpdate_580597 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesBuildingsUpdate_580599(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "buildingId" in path, "`buildingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/buildings/"),
               (kind: VariableSegment, value: "buildingId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsUpdate_580598(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a building.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   buildingId: JString (required)
  ##             : The ID of the building to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580600 = path.getOrDefault("customer")
  valid_580600 = validateParameter(valid_580600, JString, required = true,
                                 default = nil)
  if valid_580600 != nil:
    section.add "customer", valid_580600
  var valid_580601 = path.getOrDefault("buildingId")
  valid_580601 = validateParameter(valid_580601, JString, required = true,
                                 default = nil)
  if valid_580601 != nil:
    section.add "buildingId", valid_580601
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
  ##   coordinatesSource: JString
  ##                    : Source from which Building.coordinates are derived.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580602 = query.getOrDefault("key")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = nil)
  if valid_580602 != nil:
    section.add "key", valid_580602
  var valid_580603 = query.getOrDefault("prettyPrint")
  valid_580603 = validateParameter(valid_580603, JBool, required = false,
                                 default = newJBool(true))
  if valid_580603 != nil:
    section.add "prettyPrint", valid_580603
  var valid_580604 = query.getOrDefault("oauth_token")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "oauth_token", valid_580604
  var valid_580605 = query.getOrDefault("alt")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = newJString("json"))
  if valid_580605 != nil:
    section.add "alt", valid_580605
  var valid_580606 = query.getOrDefault("userIp")
  valid_580606 = validateParameter(valid_580606, JString, required = false,
                                 default = nil)
  if valid_580606 != nil:
    section.add "userIp", valid_580606
  var valid_580607 = query.getOrDefault("quotaUser")
  valid_580607 = validateParameter(valid_580607, JString, required = false,
                                 default = nil)
  if valid_580607 != nil:
    section.add "quotaUser", valid_580607
  var valid_580608 = query.getOrDefault("coordinatesSource")
  valid_580608 = validateParameter(valid_580608, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_580608 != nil:
    section.add "coordinatesSource", valid_580608
  var valid_580609 = query.getOrDefault("fields")
  valid_580609 = validateParameter(valid_580609, JString, required = false,
                                 default = nil)
  if valid_580609 != nil:
    section.add "fields", valid_580609
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

proc call*(call_580611: Call_DirectoryResourcesBuildingsUpdate_580597;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building.
  ## 
  let valid = call_580611.validator(path, query, header, formData, body)
  let scheme = call_580611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580611.url(scheme.get, call_580611.host, call_580611.base,
                         call_580611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580611, url, valid)

proc call*(call_580612: Call_DirectoryResourcesBuildingsUpdate_580597;
          customer: string; buildingId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          coordinatesSource: string = "SOURCE_UNSPECIFIED"; fields: string = ""): Recallable =
  ## directoryResourcesBuildingsUpdate
  ## Updates a building.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   buildingId: string (required)
  ##             : The ID of the building to update.
  ##   body: JObject
  ##   coordinatesSource: string
  ##                    : Source from which Building.coordinates are derived.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580613 = newJObject()
  var query_580614 = newJObject()
  var body_580615 = newJObject()
  add(query_580614, "key", newJString(key))
  add(query_580614, "prettyPrint", newJBool(prettyPrint))
  add(query_580614, "oauth_token", newJString(oauthToken))
  add(path_580613, "customer", newJString(customer))
  add(query_580614, "alt", newJString(alt))
  add(query_580614, "userIp", newJString(userIp))
  add(query_580614, "quotaUser", newJString(quotaUser))
  add(path_580613, "buildingId", newJString(buildingId))
  if body != nil:
    body_580615 = body
  add(query_580614, "coordinatesSource", newJString(coordinatesSource))
  add(query_580614, "fields", newJString(fields))
  result = call_580612.call(path_580613, query_580614, nil, nil, body_580615)

var directoryResourcesBuildingsUpdate* = Call_DirectoryResourcesBuildingsUpdate_580597(
    name: "directoryResourcesBuildingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsUpdate_580598,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsUpdate_580599,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsGet_580581 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesBuildingsGet_580583(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "buildingId" in path, "`buildingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/buildings/"),
               (kind: VariableSegment, value: "buildingId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsGet_580582(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a building.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   buildingId: JString (required)
  ##             : The unique ID of the building to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580584 = path.getOrDefault("customer")
  valid_580584 = validateParameter(valid_580584, JString, required = true,
                                 default = nil)
  if valid_580584 != nil:
    section.add "customer", valid_580584
  var valid_580585 = path.getOrDefault("buildingId")
  valid_580585 = validateParameter(valid_580585, JString, required = true,
                                 default = nil)
  if valid_580585 != nil:
    section.add "buildingId", valid_580585
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
  var valid_580586 = query.getOrDefault("key")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = nil)
  if valid_580586 != nil:
    section.add "key", valid_580586
  var valid_580587 = query.getOrDefault("prettyPrint")
  valid_580587 = validateParameter(valid_580587, JBool, required = false,
                                 default = newJBool(true))
  if valid_580587 != nil:
    section.add "prettyPrint", valid_580587
  var valid_580588 = query.getOrDefault("oauth_token")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "oauth_token", valid_580588
  var valid_580589 = query.getOrDefault("alt")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = newJString("json"))
  if valid_580589 != nil:
    section.add "alt", valid_580589
  var valid_580590 = query.getOrDefault("userIp")
  valid_580590 = validateParameter(valid_580590, JString, required = false,
                                 default = nil)
  if valid_580590 != nil:
    section.add "userIp", valid_580590
  var valid_580591 = query.getOrDefault("quotaUser")
  valid_580591 = validateParameter(valid_580591, JString, required = false,
                                 default = nil)
  if valid_580591 != nil:
    section.add "quotaUser", valid_580591
  var valid_580592 = query.getOrDefault("fields")
  valid_580592 = validateParameter(valid_580592, JString, required = false,
                                 default = nil)
  if valid_580592 != nil:
    section.add "fields", valid_580592
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580593: Call_DirectoryResourcesBuildingsGet_580581; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a building.
  ## 
  let valid = call_580593.validator(path, query, header, formData, body)
  let scheme = call_580593.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580593.url(scheme.get, call_580593.host, call_580593.base,
                         call_580593.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580593, url, valid)

proc call*(call_580594: Call_DirectoryResourcesBuildingsGet_580581;
          customer: string; buildingId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryResourcesBuildingsGet
  ## Retrieves a building.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   buildingId: string (required)
  ##             : The unique ID of the building to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580595 = newJObject()
  var query_580596 = newJObject()
  add(query_580596, "key", newJString(key))
  add(query_580596, "prettyPrint", newJBool(prettyPrint))
  add(query_580596, "oauth_token", newJString(oauthToken))
  add(path_580595, "customer", newJString(customer))
  add(query_580596, "alt", newJString(alt))
  add(query_580596, "userIp", newJString(userIp))
  add(query_580596, "quotaUser", newJString(quotaUser))
  add(path_580595, "buildingId", newJString(buildingId))
  add(query_580596, "fields", newJString(fields))
  result = call_580594.call(path_580595, query_580596, nil, nil, nil)

var directoryResourcesBuildingsGet* = Call_DirectoryResourcesBuildingsGet_580581(
    name: "directoryResourcesBuildingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsGet_580582,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsGet_580583,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsPatch_580632 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesBuildingsPatch_580634(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "buildingId" in path, "`buildingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/buildings/"),
               (kind: VariableSegment, value: "buildingId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsPatch_580633(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a building. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   buildingId: JString (required)
  ##             : The ID of the building to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580635 = path.getOrDefault("customer")
  valid_580635 = validateParameter(valid_580635, JString, required = true,
                                 default = nil)
  if valid_580635 != nil:
    section.add "customer", valid_580635
  var valid_580636 = path.getOrDefault("buildingId")
  valid_580636 = validateParameter(valid_580636, JString, required = true,
                                 default = nil)
  if valid_580636 != nil:
    section.add "buildingId", valid_580636
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
  ##   coordinatesSource: JString
  ##                    : Source from which Building.coordinates are derived.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_580637 = query.getOrDefault("key")
  valid_580637 = validateParameter(valid_580637, JString, required = false,
                                 default = nil)
  if valid_580637 != nil:
    section.add "key", valid_580637
  var valid_580638 = query.getOrDefault("prettyPrint")
  valid_580638 = validateParameter(valid_580638, JBool, required = false,
                                 default = newJBool(true))
  if valid_580638 != nil:
    section.add "prettyPrint", valid_580638
  var valid_580639 = query.getOrDefault("oauth_token")
  valid_580639 = validateParameter(valid_580639, JString, required = false,
                                 default = nil)
  if valid_580639 != nil:
    section.add "oauth_token", valid_580639
  var valid_580640 = query.getOrDefault("alt")
  valid_580640 = validateParameter(valid_580640, JString, required = false,
                                 default = newJString("json"))
  if valid_580640 != nil:
    section.add "alt", valid_580640
  var valid_580641 = query.getOrDefault("userIp")
  valid_580641 = validateParameter(valid_580641, JString, required = false,
                                 default = nil)
  if valid_580641 != nil:
    section.add "userIp", valid_580641
  var valid_580642 = query.getOrDefault("quotaUser")
  valid_580642 = validateParameter(valid_580642, JString, required = false,
                                 default = nil)
  if valid_580642 != nil:
    section.add "quotaUser", valid_580642
  var valid_580643 = query.getOrDefault("coordinatesSource")
  valid_580643 = validateParameter(valid_580643, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_580643 != nil:
    section.add "coordinatesSource", valid_580643
  var valid_580644 = query.getOrDefault("fields")
  valid_580644 = validateParameter(valid_580644, JString, required = false,
                                 default = nil)
  if valid_580644 != nil:
    section.add "fields", valid_580644
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

proc call*(call_580646: Call_DirectoryResourcesBuildingsPatch_580632;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building. This method supports patch semantics.
  ## 
  let valid = call_580646.validator(path, query, header, formData, body)
  let scheme = call_580646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580646.url(scheme.get, call_580646.host, call_580646.base,
                         call_580646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580646, url, valid)

proc call*(call_580647: Call_DirectoryResourcesBuildingsPatch_580632;
          customer: string; buildingId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          coordinatesSource: string = "SOURCE_UNSPECIFIED"; fields: string = ""): Recallable =
  ## directoryResourcesBuildingsPatch
  ## Updates a building. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   buildingId: string (required)
  ##             : The ID of the building to update.
  ##   body: JObject
  ##   coordinatesSource: string
  ##                    : Source from which Building.coordinates are derived.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580648 = newJObject()
  var query_580649 = newJObject()
  var body_580650 = newJObject()
  add(query_580649, "key", newJString(key))
  add(query_580649, "prettyPrint", newJBool(prettyPrint))
  add(query_580649, "oauth_token", newJString(oauthToken))
  add(path_580648, "customer", newJString(customer))
  add(query_580649, "alt", newJString(alt))
  add(query_580649, "userIp", newJString(userIp))
  add(query_580649, "quotaUser", newJString(quotaUser))
  add(path_580648, "buildingId", newJString(buildingId))
  if body != nil:
    body_580650 = body
  add(query_580649, "coordinatesSource", newJString(coordinatesSource))
  add(query_580649, "fields", newJString(fields))
  result = call_580647.call(path_580648, query_580649, nil, nil, body_580650)

var directoryResourcesBuildingsPatch* = Call_DirectoryResourcesBuildingsPatch_580632(
    name: "directoryResourcesBuildingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsPatch_580633,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsPatch_580634,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsDelete_580616 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesBuildingsDelete_580618(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "buildingId" in path, "`buildingId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/buildings/"),
               (kind: VariableSegment, value: "buildingId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsDelete_580617(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a building.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   buildingId: JString (required)
  ##             : The ID of the building to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580619 = path.getOrDefault("customer")
  valid_580619 = validateParameter(valid_580619, JString, required = true,
                                 default = nil)
  if valid_580619 != nil:
    section.add "customer", valid_580619
  var valid_580620 = path.getOrDefault("buildingId")
  valid_580620 = validateParameter(valid_580620, JString, required = true,
                                 default = nil)
  if valid_580620 != nil:
    section.add "buildingId", valid_580620
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
  var valid_580621 = query.getOrDefault("key")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "key", valid_580621
  var valid_580622 = query.getOrDefault("prettyPrint")
  valid_580622 = validateParameter(valid_580622, JBool, required = false,
                                 default = newJBool(true))
  if valid_580622 != nil:
    section.add "prettyPrint", valid_580622
  var valid_580623 = query.getOrDefault("oauth_token")
  valid_580623 = validateParameter(valid_580623, JString, required = false,
                                 default = nil)
  if valid_580623 != nil:
    section.add "oauth_token", valid_580623
  var valid_580624 = query.getOrDefault("alt")
  valid_580624 = validateParameter(valid_580624, JString, required = false,
                                 default = newJString("json"))
  if valid_580624 != nil:
    section.add "alt", valid_580624
  var valid_580625 = query.getOrDefault("userIp")
  valid_580625 = validateParameter(valid_580625, JString, required = false,
                                 default = nil)
  if valid_580625 != nil:
    section.add "userIp", valid_580625
  var valid_580626 = query.getOrDefault("quotaUser")
  valid_580626 = validateParameter(valid_580626, JString, required = false,
                                 default = nil)
  if valid_580626 != nil:
    section.add "quotaUser", valid_580626
  var valid_580627 = query.getOrDefault("fields")
  valid_580627 = validateParameter(valid_580627, JString, required = false,
                                 default = nil)
  if valid_580627 != nil:
    section.add "fields", valid_580627
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580628: Call_DirectoryResourcesBuildingsDelete_580616;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a building.
  ## 
  let valid = call_580628.validator(path, query, header, formData, body)
  let scheme = call_580628.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580628.url(scheme.get, call_580628.host, call_580628.base,
                         call_580628.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580628, url, valid)

proc call*(call_580629: Call_DirectoryResourcesBuildingsDelete_580616;
          customer: string; buildingId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryResourcesBuildingsDelete
  ## Deletes a building.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   buildingId: string (required)
  ##             : The ID of the building to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580630 = newJObject()
  var query_580631 = newJObject()
  add(query_580631, "key", newJString(key))
  add(query_580631, "prettyPrint", newJBool(prettyPrint))
  add(query_580631, "oauth_token", newJString(oauthToken))
  add(path_580630, "customer", newJString(customer))
  add(query_580631, "alt", newJString(alt))
  add(query_580631, "userIp", newJString(userIp))
  add(query_580631, "quotaUser", newJString(quotaUser))
  add(path_580630, "buildingId", newJString(buildingId))
  add(query_580631, "fields", newJString(fields))
  result = call_580629.call(path_580630, query_580631, nil, nil, nil)

var directoryResourcesBuildingsDelete* = Call_DirectoryResourcesBuildingsDelete_580616(
    name: "directoryResourcesBuildingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsDelete_580617,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsDelete_580618,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsInsert_580670 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesCalendarsInsert_580672(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/calendars")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsInsert_580671(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a calendar resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580673 = path.getOrDefault("customer")
  valid_580673 = validateParameter(valid_580673, JString, required = true,
                                 default = nil)
  if valid_580673 != nil:
    section.add "customer", valid_580673
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
  var valid_580674 = query.getOrDefault("key")
  valid_580674 = validateParameter(valid_580674, JString, required = false,
                                 default = nil)
  if valid_580674 != nil:
    section.add "key", valid_580674
  var valid_580675 = query.getOrDefault("prettyPrint")
  valid_580675 = validateParameter(valid_580675, JBool, required = false,
                                 default = newJBool(true))
  if valid_580675 != nil:
    section.add "prettyPrint", valid_580675
  var valid_580676 = query.getOrDefault("oauth_token")
  valid_580676 = validateParameter(valid_580676, JString, required = false,
                                 default = nil)
  if valid_580676 != nil:
    section.add "oauth_token", valid_580676
  var valid_580677 = query.getOrDefault("alt")
  valid_580677 = validateParameter(valid_580677, JString, required = false,
                                 default = newJString("json"))
  if valid_580677 != nil:
    section.add "alt", valid_580677
  var valid_580678 = query.getOrDefault("userIp")
  valid_580678 = validateParameter(valid_580678, JString, required = false,
                                 default = nil)
  if valid_580678 != nil:
    section.add "userIp", valid_580678
  var valid_580679 = query.getOrDefault("quotaUser")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "quotaUser", valid_580679
  var valid_580680 = query.getOrDefault("fields")
  valid_580680 = validateParameter(valid_580680, JString, required = false,
                                 default = nil)
  if valid_580680 != nil:
    section.add "fields", valid_580680
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

proc call*(call_580682: Call_DirectoryResourcesCalendarsInsert_580670;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a calendar resource.
  ## 
  let valid = call_580682.validator(path, query, header, formData, body)
  let scheme = call_580682.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580682.url(scheme.get, call_580682.host, call_580682.base,
                         call_580682.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580682, url, valid)

proc call*(call_580683: Call_DirectoryResourcesCalendarsInsert_580670;
          customer: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryResourcesCalendarsInsert
  ## Inserts a calendar resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580684 = newJObject()
  var query_580685 = newJObject()
  var body_580686 = newJObject()
  add(query_580685, "key", newJString(key))
  add(query_580685, "prettyPrint", newJBool(prettyPrint))
  add(query_580685, "oauth_token", newJString(oauthToken))
  add(path_580684, "customer", newJString(customer))
  add(query_580685, "alt", newJString(alt))
  add(query_580685, "userIp", newJString(userIp))
  add(query_580685, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580686 = body
  add(query_580685, "fields", newJString(fields))
  result = call_580683.call(path_580684, query_580685, nil, nil, body_580686)

var directoryResourcesCalendarsInsert* = Call_DirectoryResourcesCalendarsInsert_580670(
    name: "directoryResourcesCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsInsert_580671,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsInsert_580672,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsList_580651 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesCalendarsList_580653(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/calendars")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsList_580652(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of calendar resources for an account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580654 = path.getOrDefault("customer")
  valid_580654 = validateParameter(valid_580654, JString, required = true,
                                 default = nil)
  if valid_580654 != nil:
    section.add "customer", valid_580654
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
  ##   orderBy: JString
  ##          : Field(s) to sort results by in either ascending or descending order. Supported fields include resourceId, resourceName, capacity, buildingId, and floorName. If no order is specified, defaults to ascending. Should be of the form "field [asc|desc], field [asc|desc], ...". For example buildingId, capacity desc would return results sorted first by buildingId in ascending order then by capacity in descending order.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   query: JString
  ##        : String query used to filter results. Should be of the form "field operator value" where field can be any of supported fields and operators can be any of supported operations. Operators include '=' for exact match and ':' for prefix match or HAS match where applicable. For prefix match, the value should always be followed by a *. Supported fields include generatedResourceName, name, buildingId, featureInstances.feature.name. For example buildingId=US-NYC-9TH AND featureInstances.feature.name:Phone.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_580655 = query.getOrDefault("key")
  valid_580655 = validateParameter(valid_580655, JString, required = false,
                                 default = nil)
  if valid_580655 != nil:
    section.add "key", valid_580655
  var valid_580656 = query.getOrDefault("prettyPrint")
  valid_580656 = validateParameter(valid_580656, JBool, required = false,
                                 default = newJBool(true))
  if valid_580656 != nil:
    section.add "prettyPrint", valid_580656
  var valid_580657 = query.getOrDefault("oauth_token")
  valid_580657 = validateParameter(valid_580657, JString, required = false,
                                 default = nil)
  if valid_580657 != nil:
    section.add "oauth_token", valid_580657
  var valid_580658 = query.getOrDefault("alt")
  valid_580658 = validateParameter(valid_580658, JString, required = false,
                                 default = newJString("json"))
  if valid_580658 != nil:
    section.add "alt", valid_580658
  var valid_580659 = query.getOrDefault("userIp")
  valid_580659 = validateParameter(valid_580659, JString, required = false,
                                 default = nil)
  if valid_580659 != nil:
    section.add "userIp", valid_580659
  var valid_580660 = query.getOrDefault("quotaUser")
  valid_580660 = validateParameter(valid_580660, JString, required = false,
                                 default = nil)
  if valid_580660 != nil:
    section.add "quotaUser", valid_580660
  var valid_580661 = query.getOrDefault("orderBy")
  valid_580661 = validateParameter(valid_580661, JString, required = false,
                                 default = nil)
  if valid_580661 != nil:
    section.add "orderBy", valid_580661
  var valid_580662 = query.getOrDefault("pageToken")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "pageToken", valid_580662
  var valid_580663 = query.getOrDefault("query")
  valid_580663 = validateParameter(valid_580663, JString, required = false,
                                 default = nil)
  if valid_580663 != nil:
    section.add "query", valid_580663
  var valid_580664 = query.getOrDefault("fields")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "fields", valid_580664
  var valid_580665 = query.getOrDefault("maxResults")
  valid_580665 = validateParameter(valid_580665, JInt, required = false, default = nil)
  if valid_580665 != nil:
    section.add "maxResults", valid_580665
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580666: Call_DirectoryResourcesCalendarsList_580651;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of calendar resources for an account.
  ## 
  let valid = call_580666.validator(path, query, header, formData, body)
  let scheme = call_580666.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580666.url(scheme.get, call_580666.host, call_580666.base,
                         call_580666.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580666, url, valid)

proc call*(call_580667: Call_DirectoryResourcesCalendarsList_580651;
          customer: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; orderBy: string = ""; pageToken: string = "";
          query: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## directoryResourcesCalendarsList
  ## Retrieves a list of calendar resources for an account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Field(s) to sort results by in either ascending or descending order. Supported fields include resourceId, resourceName, capacity, buildingId, and floorName. If no order is specified, defaults to ascending. Should be of the form "field [asc|desc], field [asc|desc], ...". For example buildingId, capacity desc would return results sorted first by buildingId in ascending order then by capacity in descending order.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   query: string
  ##        : String query used to filter results. Should be of the form "field operator value" where field can be any of supported fields and operators can be any of supported operations. Operators include '=' for exact match and ':' for prefix match or HAS match where applicable. For prefix match, the value should always be followed by a *. Supported fields include generatedResourceName, name, buildingId, featureInstances.feature.name. For example buildingId=US-NYC-9TH AND featureInstances.feature.name:Phone.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var path_580668 = newJObject()
  var query_580669 = newJObject()
  add(query_580669, "key", newJString(key))
  add(query_580669, "prettyPrint", newJBool(prettyPrint))
  add(query_580669, "oauth_token", newJString(oauthToken))
  add(path_580668, "customer", newJString(customer))
  add(query_580669, "alt", newJString(alt))
  add(query_580669, "userIp", newJString(userIp))
  add(query_580669, "quotaUser", newJString(quotaUser))
  add(query_580669, "orderBy", newJString(orderBy))
  add(query_580669, "pageToken", newJString(pageToken))
  add(query_580669, "query", newJString(query))
  add(query_580669, "fields", newJString(fields))
  add(query_580669, "maxResults", newJInt(maxResults))
  result = call_580667.call(path_580668, query_580669, nil, nil, nil)

var directoryResourcesCalendarsList* = Call_DirectoryResourcesCalendarsList_580651(
    name: "directoryResourcesCalendarsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsList_580652,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsList_580653,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsUpdate_580703 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesCalendarsUpdate_580705(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "calendarResourceId" in path,
        "`calendarResourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/calendars/"),
               (kind: VariableSegment, value: "calendarResourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsUpdate_580704(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   calendarResourceId: JString (required)
  ##                     : The unique ID of the calendar resource to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580706 = path.getOrDefault("customer")
  valid_580706 = validateParameter(valid_580706, JString, required = true,
                                 default = nil)
  if valid_580706 != nil:
    section.add "customer", valid_580706
  var valid_580707 = path.getOrDefault("calendarResourceId")
  valid_580707 = validateParameter(valid_580707, JString, required = true,
                                 default = nil)
  if valid_580707 != nil:
    section.add "calendarResourceId", valid_580707
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
  var valid_580708 = query.getOrDefault("key")
  valid_580708 = validateParameter(valid_580708, JString, required = false,
                                 default = nil)
  if valid_580708 != nil:
    section.add "key", valid_580708
  var valid_580709 = query.getOrDefault("prettyPrint")
  valid_580709 = validateParameter(valid_580709, JBool, required = false,
                                 default = newJBool(true))
  if valid_580709 != nil:
    section.add "prettyPrint", valid_580709
  var valid_580710 = query.getOrDefault("oauth_token")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "oauth_token", valid_580710
  var valid_580711 = query.getOrDefault("alt")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = newJString("json"))
  if valid_580711 != nil:
    section.add "alt", valid_580711
  var valid_580712 = query.getOrDefault("userIp")
  valid_580712 = validateParameter(valid_580712, JString, required = false,
                                 default = nil)
  if valid_580712 != nil:
    section.add "userIp", valid_580712
  var valid_580713 = query.getOrDefault("quotaUser")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "quotaUser", valid_580713
  var valid_580714 = query.getOrDefault("fields")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = nil)
  if valid_580714 != nil:
    section.add "fields", valid_580714
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

proc call*(call_580716: Call_DirectoryResourcesCalendarsUpdate_580703;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
  ## 
  let valid = call_580716.validator(path, query, header, formData, body)
  let scheme = call_580716.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580716.url(scheme.get, call_580716.host, call_580716.base,
                         call_580716.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580716, url, valid)

proc call*(call_580717: Call_DirectoryResourcesCalendarsUpdate_580703;
          customer: string; calendarResourceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryResourcesCalendarsUpdate
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   calendarResourceId: string (required)
  ##                     : The unique ID of the calendar resource to update.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580718 = newJObject()
  var query_580719 = newJObject()
  var body_580720 = newJObject()
  add(query_580719, "key", newJString(key))
  add(query_580719, "prettyPrint", newJBool(prettyPrint))
  add(query_580719, "oauth_token", newJString(oauthToken))
  add(path_580718, "customer", newJString(customer))
  add(query_580719, "alt", newJString(alt))
  add(query_580719, "userIp", newJString(userIp))
  add(query_580719, "quotaUser", newJString(quotaUser))
  add(path_580718, "calendarResourceId", newJString(calendarResourceId))
  if body != nil:
    body_580720 = body
  add(query_580719, "fields", newJString(fields))
  result = call_580717.call(path_580718, query_580719, nil, nil, body_580720)

var directoryResourcesCalendarsUpdate* = Call_DirectoryResourcesCalendarsUpdate_580703(
    name: "directoryResourcesCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsUpdate_580704,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsUpdate_580705,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsGet_580687 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesCalendarsGet_580689(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "calendarResourceId" in path,
        "`calendarResourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/calendars/"),
               (kind: VariableSegment, value: "calendarResourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsGet_580688(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a calendar resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   calendarResourceId: JString (required)
  ##                     : The unique ID of the calendar resource to retrieve.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580690 = path.getOrDefault("customer")
  valid_580690 = validateParameter(valid_580690, JString, required = true,
                                 default = nil)
  if valid_580690 != nil:
    section.add "customer", valid_580690
  var valid_580691 = path.getOrDefault("calendarResourceId")
  valid_580691 = validateParameter(valid_580691, JString, required = true,
                                 default = nil)
  if valid_580691 != nil:
    section.add "calendarResourceId", valid_580691
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
  var valid_580692 = query.getOrDefault("key")
  valid_580692 = validateParameter(valid_580692, JString, required = false,
                                 default = nil)
  if valid_580692 != nil:
    section.add "key", valid_580692
  var valid_580693 = query.getOrDefault("prettyPrint")
  valid_580693 = validateParameter(valid_580693, JBool, required = false,
                                 default = newJBool(true))
  if valid_580693 != nil:
    section.add "prettyPrint", valid_580693
  var valid_580694 = query.getOrDefault("oauth_token")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "oauth_token", valid_580694
  var valid_580695 = query.getOrDefault("alt")
  valid_580695 = validateParameter(valid_580695, JString, required = false,
                                 default = newJString("json"))
  if valid_580695 != nil:
    section.add "alt", valid_580695
  var valid_580696 = query.getOrDefault("userIp")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "userIp", valid_580696
  var valid_580697 = query.getOrDefault("quotaUser")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = nil)
  if valid_580697 != nil:
    section.add "quotaUser", valid_580697
  var valid_580698 = query.getOrDefault("fields")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "fields", valid_580698
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580699: Call_DirectoryResourcesCalendarsGet_580687; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a calendar resource.
  ## 
  let valid = call_580699.validator(path, query, header, formData, body)
  let scheme = call_580699.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580699.url(scheme.get, call_580699.host, call_580699.base,
                         call_580699.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580699, url, valid)

proc call*(call_580700: Call_DirectoryResourcesCalendarsGet_580687;
          customer: string; calendarResourceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryResourcesCalendarsGet
  ## Retrieves a calendar resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   calendarResourceId: string (required)
  ##                     : The unique ID of the calendar resource to retrieve.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580701 = newJObject()
  var query_580702 = newJObject()
  add(query_580702, "key", newJString(key))
  add(query_580702, "prettyPrint", newJBool(prettyPrint))
  add(query_580702, "oauth_token", newJString(oauthToken))
  add(path_580701, "customer", newJString(customer))
  add(query_580702, "alt", newJString(alt))
  add(query_580702, "userIp", newJString(userIp))
  add(query_580702, "quotaUser", newJString(quotaUser))
  add(path_580701, "calendarResourceId", newJString(calendarResourceId))
  add(query_580702, "fields", newJString(fields))
  result = call_580700.call(path_580701, query_580702, nil, nil, nil)

var directoryResourcesCalendarsGet* = Call_DirectoryResourcesCalendarsGet_580687(
    name: "directoryResourcesCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsGet_580688,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsGet_580689,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsPatch_580737 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesCalendarsPatch_580739(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "calendarResourceId" in path,
        "`calendarResourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/calendars/"),
               (kind: VariableSegment, value: "calendarResourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsPatch_580738(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   calendarResourceId: JString (required)
  ##                     : The unique ID of the calendar resource to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580740 = path.getOrDefault("customer")
  valid_580740 = validateParameter(valid_580740, JString, required = true,
                                 default = nil)
  if valid_580740 != nil:
    section.add "customer", valid_580740
  var valid_580741 = path.getOrDefault("calendarResourceId")
  valid_580741 = validateParameter(valid_580741, JString, required = true,
                                 default = nil)
  if valid_580741 != nil:
    section.add "calendarResourceId", valid_580741
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
  var valid_580742 = query.getOrDefault("key")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "key", valid_580742
  var valid_580743 = query.getOrDefault("prettyPrint")
  valid_580743 = validateParameter(valid_580743, JBool, required = false,
                                 default = newJBool(true))
  if valid_580743 != nil:
    section.add "prettyPrint", valid_580743
  var valid_580744 = query.getOrDefault("oauth_token")
  valid_580744 = validateParameter(valid_580744, JString, required = false,
                                 default = nil)
  if valid_580744 != nil:
    section.add "oauth_token", valid_580744
  var valid_580745 = query.getOrDefault("alt")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = newJString("json"))
  if valid_580745 != nil:
    section.add "alt", valid_580745
  var valid_580746 = query.getOrDefault("userIp")
  valid_580746 = validateParameter(valid_580746, JString, required = false,
                                 default = nil)
  if valid_580746 != nil:
    section.add "userIp", valid_580746
  var valid_580747 = query.getOrDefault("quotaUser")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "quotaUser", valid_580747
  var valid_580748 = query.getOrDefault("fields")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "fields", valid_580748
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

proc call*(call_580750: Call_DirectoryResourcesCalendarsPatch_580737;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
  ## 
  let valid = call_580750.validator(path, query, header, formData, body)
  let scheme = call_580750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580750.url(scheme.get, call_580750.host, call_580750.base,
                         call_580750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580750, url, valid)

proc call*(call_580751: Call_DirectoryResourcesCalendarsPatch_580737;
          customer: string; calendarResourceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryResourcesCalendarsPatch
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   calendarResourceId: string (required)
  ##                     : The unique ID of the calendar resource to update.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580752 = newJObject()
  var query_580753 = newJObject()
  var body_580754 = newJObject()
  add(query_580753, "key", newJString(key))
  add(query_580753, "prettyPrint", newJBool(prettyPrint))
  add(query_580753, "oauth_token", newJString(oauthToken))
  add(path_580752, "customer", newJString(customer))
  add(query_580753, "alt", newJString(alt))
  add(query_580753, "userIp", newJString(userIp))
  add(query_580753, "quotaUser", newJString(quotaUser))
  add(path_580752, "calendarResourceId", newJString(calendarResourceId))
  if body != nil:
    body_580754 = body
  add(query_580753, "fields", newJString(fields))
  result = call_580751.call(path_580752, query_580753, nil, nil, body_580754)

var directoryResourcesCalendarsPatch* = Call_DirectoryResourcesCalendarsPatch_580737(
    name: "directoryResourcesCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsPatch_580738,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsPatch_580739,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsDelete_580721 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesCalendarsDelete_580723(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "calendarResourceId" in path,
        "`calendarResourceId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/calendars/"),
               (kind: VariableSegment, value: "calendarResourceId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsDelete_580722(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a calendar resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   calendarResourceId: JString (required)
  ##                     : The unique ID of the calendar resource to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580724 = path.getOrDefault("customer")
  valid_580724 = validateParameter(valid_580724, JString, required = true,
                                 default = nil)
  if valid_580724 != nil:
    section.add "customer", valid_580724
  var valid_580725 = path.getOrDefault("calendarResourceId")
  valid_580725 = validateParameter(valid_580725, JString, required = true,
                                 default = nil)
  if valid_580725 != nil:
    section.add "calendarResourceId", valid_580725
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
  var valid_580726 = query.getOrDefault("key")
  valid_580726 = validateParameter(valid_580726, JString, required = false,
                                 default = nil)
  if valid_580726 != nil:
    section.add "key", valid_580726
  var valid_580727 = query.getOrDefault("prettyPrint")
  valid_580727 = validateParameter(valid_580727, JBool, required = false,
                                 default = newJBool(true))
  if valid_580727 != nil:
    section.add "prettyPrint", valid_580727
  var valid_580728 = query.getOrDefault("oauth_token")
  valid_580728 = validateParameter(valid_580728, JString, required = false,
                                 default = nil)
  if valid_580728 != nil:
    section.add "oauth_token", valid_580728
  var valid_580729 = query.getOrDefault("alt")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = newJString("json"))
  if valid_580729 != nil:
    section.add "alt", valid_580729
  var valid_580730 = query.getOrDefault("userIp")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = nil)
  if valid_580730 != nil:
    section.add "userIp", valid_580730
  var valid_580731 = query.getOrDefault("quotaUser")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "quotaUser", valid_580731
  var valid_580732 = query.getOrDefault("fields")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "fields", valid_580732
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580733: Call_DirectoryResourcesCalendarsDelete_580721;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a calendar resource.
  ## 
  let valid = call_580733.validator(path, query, header, formData, body)
  let scheme = call_580733.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580733.url(scheme.get, call_580733.host, call_580733.base,
                         call_580733.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580733, url, valid)

proc call*(call_580734: Call_DirectoryResourcesCalendarsDelete_580721;
          customer: string; calendarResourceId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryResourcesCalendarsDelete
  ## Deletes a calendar resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   calendarResourceId: string (required)
  ##                     : The unique ID of the calendar resource to delete.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580735 = newJObject()
  var query_580736 = newJObject()
  add(query_580736, "key", newJString(key))
  add(query_580736, "prettyPrint", newJBool(prettyPrint))
  add(query_580736, "oauth_token", newJString(oauthToken))
  add(path_580735, "customer", newJString(customer))
  add(query_580736, "alt", newJString(alt))
  add(query_580736, "userIp", newJString(userIp))
  add(query_580736, "quotaUser", newJString(quotaUser))
  add(path_580735, "calendarResourceId", newJString(calendarResourceId))
  add(query_580736, "fields", newJString(fields))
  result = call_580734.call(path_580735, query_580736, nil, nil, nil)

var directoryResourcesCalendarsDelete* = Call_DirectoryResourcesCalendarsDelete_580721(
    name: "directoryResourcesCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsDelete_580722,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsDelete_580723,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesInsert_580772 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesFeaturesInsert_580774(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/features")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesInsert_580773(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Inserts a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580775 = path.getOrDefault("customer")
  valid_580775 = validateParameter(valid_580775, JString, required = true,
                                 default = nil)
  if valid_580775 != nil:
    section.add "customer", valid_580775
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
  var valid_580776 = query.getOrDefault("key")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "key", valid_580776
  var valid_580777 = query.getOrDefault("prettyPrint")
  valid_580777 = validateParameter(valid_580777, JBool, required = false,
                                 default = newJBool(true))
  if valid_580777 != nil:
    section.add "prettyPrint", valid_580777
  var valid_580778 = query.getOrDefault("oauth_token")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = nil)
  if valid_580778 != nil:
    section.add "oauth_token", valid_580778
  var valid_580779 = query.getOrDefault("alt")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = newJString("json"))
  if valid_580779 != nil:
    section.add "alt", valid_580779
  var valid_580780 = query.getOrDefault("userIp")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "userIp", valid_580780
  var valid_580781 = query.getOrDefault("quotaUser")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "quotaUser", valid_580781
  var valid_580782 = query.getOrDefault("fields")
  valid_580782 = validateParameter(valid_580782, JString, required = false,
                                 default = nil)
  if valid_580782 != nil:
    section.add "fields", valid_580782
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

proc call*(call_580784: Call_DirectoryResourcesFeaturesInsert_580772;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a feature.
  ## 
  let valid = call_580784.validator(path, query, header, formData, body)
  let scheme = call_580784.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580784.url(scheme.get, call_580784.host, call_580784.base,
                         call_580784.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580784, url, valid)

proc call*(call_580785: Call_DirectoryResourcesFeaturesInsert_580772;
          customer: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryResourcesFeaturesInsert
  ## Inserts a feature.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580786 = newJObject()
  var query_580787 = newJObject()
  var body_580788 = newJObject()
  add(query_580787, "key", newJString(key))
  add(query_580787, "prettyPrint", newJBool(prettyPrint))
  add(query_580787, "oauth_token", newJString(oauthToken))
  add(path_580786, "customer", newJString(customer))
  add(query_580787, "alt", newJString(alt))
  add(query_580787, "userIp", newJString(userIp))
  add(query_580787, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580788 = body
  add(query_580787, "fields", newJString(fields))
  result = call_580785.call(path_580786, query_580787, nil, nil, body_580788)

var directoryResourcesFeaturesInsert* = Call_DirectoryResourcesFeaturesInsert_580772(
    name: "directoryResourcesFeaturesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesInsert_580773,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesInsert_580774,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesList_580755 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesFeaturesList_580757(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/features")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesList_580756(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of features for an account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580758 = path.getOrDefault("customer")
  valid_580758 = validateParameter(valid_580758, JString, required = true,
                                 default = nil)
  if valid_580758 != nil:
    section.add "customer", valid_580758
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
  ##            : Token to specify the next page in the list.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_580759 = query.getOrDefault("key")
  valid_580759 = validateParameter(valid_580759, JString, required = false,
                                 default = nil)
  if valid_580759 != nil:
    section.add "key", valid_580759
  var valid_580760 = query.getOrDefault("prettyPrint")
  valid_580760 = validateParameter(valid_580760, JBool, required = false,
                                 default = newJBool(true))
  if valid_580760 != nil:
    section.add "prettyPrint", valid_580760
  var valid_580761 = query.getOrDefault("oauth_token")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = nil)
  if valid_580761 != nil:
    section.add "oauth_token", valid_580761
  var valid_580762 = query.getOrDefault("alt")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = newJString("json"))
  if valid_580762 != nil:
    section.add "alt", valid_580762
  var valid_580763 = query.getOrDefault("userIp")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "userIp", valid_580763
  var valid_580764 = query.getOrDefault("quotaUser")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "quotaUser", valid_580764
  var valid_580765 = query.getOrDefault("pageToken")
  valid_580765 = validateParameter(valid_580765, JString, required = false,
                                 default = nil)
  if valid_580765 != nil:
    section.add "pageToken", valid_580765
  var valid_580766 = query.getOrDefault("fields")
  valid_580766 = validateParameter(valid_580766, JString, required = false,
                                 default = nil)
  if valid_580766 != nil:
    section.add "fields", valid_580766
  var valid_580767 = query.getOrDefault("maxResults")
  valid_580767 = validateParameter(valid_580767, JInt, required = false, default = nil)
  if valid_580767 != nil:
    section.add "maxResults", valid_580767
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580768: Call_DirectoryResourcesFeaturesList_580755; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of features for an account.
  ## 
  let valid = call_580768.validator(path, query, header, formData, body)
  let scheme = call_580768.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580768.url(scheme.get, call_580768.host, call_580768.base,
                         call_580768.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580768, url, valid)

proc call*(call_580769: Call_DirectoryResourcesFeaturesList_580755;
          customer: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; pageToken: string = ""; fields: string = "";
          maxResults: int = 0): Recallable =
  ## directoryResourcesFeaturesList
  ## Retrieves a list of features for an account.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var path_580770 = newJObject()
  var query_580771 = newJObject()
  add(query_580771, "key", newJString(key))
  add(query_580771, "prettyPrint", newJBool(prettyPrint))
  add(query_580771, "oauth_token", newJString(oauthToken))
  add(path_580770, "customer", newJString(customer))
  add(query_580771, "alt", newJString(alt))
  add(query_580771, "userIp", newJString(userIp))
  add(query_580771, "quotaUser", newJString(quotaUser))
  add(query_580771, "pageToken", newJString(pageToken))
  add(query_580771, "fields", newJString(fields))
  add(query_580771, "maxResults", newJInt(maxResults))
  result = call_580769.call(path_580770, query_580771, nil, nil, nil)

var directoryResourcesFeaturesList* = Call_DirectoryResourcesFeaturesList_580755(
    name: "directoryResourcesFeaturesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesList_580756,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesList_580757,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesUpdate_580805 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesFeaturesUpdate_580807(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "featureKey" in path, "`featureKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/features/"),
               (kind: VariableSegment, value: "featureKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesUpdate_580806(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureKey: JString (required)
  ##             : The unique ID of the feature to update.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureKey` field"
  var valid_580808 = path.getOrDefault("featureKey")
  valid_580808 = validateParameter(valid_580808, JString, required = true,
                                 default = nil)
  if valid_580808 != nil:
    section.add "featureKey", valid_580808
  var valid_580809 = path.getOrDefault("customer")
  valid_580809 = validateParameter(valid_580809, JString, required = true,
                                 default = nil)
  if valid_580809 != nil:
    section.add "customer", valid_580809
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
  var valid_580810 = query.getOrDefault("key")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "key", valid_580810
  var valid_580811 = query.getOrDefault("prettyPrint")
  valid_580811 = validateParameter(valid_580811, JBool, required = false,
                                 default = newJBool(true))
  if valid_580811 != nil:
    section.add "prettyPrint", valid_580811
  var valid_580812 = query.getOrDefault("oauth_token")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = nil)
  if valid_580812 != nil:
    section.add "oauth_token", valid_580812
  var valid_580813 = query.getOrDefault("alt")
  valid_580813 = validateParameter(valid_580813, JString, required = false,
                                 default = newJString("json"))
  if valid_580813 != nil:
    section.add "alt", valid_580813
  var valid_580814 = query.getOrDefault("userIp")
  valid_580814 = validateParameter(valid_580814, JString, required = false,
                                 default = nil)
  if valid_580814 != nil:
    section.add "userIp", valid_580814
  var valid_580815 = query.getOrDefault("quotaUser")
  valid_580815 = validateParameter(valid_580815, JString, required = false,
                                 default = nil)
  if valid_580815 != nil:
    section.add "quotaUser", valid_580815
  var valid_580816 = query.getOrDefault("fields")
  valid_580816 = validateParameter(valid_580816, JString, required = false,
                                 default = nil)
  if valid_580816 != nil:
    section.add "fields", valid_580816
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

proc call*(call_580818: Call_DirectoryResourcesFeaturesUpdate_580805;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature.
  ## 
  let valid = call_580818.validator(path, query, header, formData, body)
  let scheme = call_580818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580818.url(scheme.get, call_580818.host, call_580818.base,
                         call_580818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580818, url, valid)

proc call*(call_580819: Call_DirectoryResourcesFeaturesUpdate_580805;
          featureKey: string; customer: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryResourcesFeaturesUpdate
  ## Updates a feature.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   featureKey: string (required)
  ##             : The unique ID of the feature to update.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580820 = newJObject()
  var query_580821 = newJObject()
  var body_580822 = newJObject()
  add(query_580821, "key", newJString(key))
  add(query_580821, "prettyPrint", newJBool(prettyPrint))
  add(query_580821, "oauth_token", newJString(oauthToken))
  add(path_580820, "featureKey", newJString(featureKey))
  add(path_580820, "customer", newJString(customer))
  add(query_580821, "alt", newJString(alt))
  add(query_580821, "userIp", newJString(userIp))
  add(query_580821, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580822 = body
  add(query_580821, "fields", newJString(fields))
  result = call_580819.call(path_580820, query_580821, nil, nil, body_580822)

var directoryResourcesFeaturesUpdate* = Call_DirectoryResourcesFeaturesUpdate_580805(
    name: "directoryResourcesFeaturesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesUpdate_580806,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesUpdate_580807,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesGet_580789 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesFeaturesGet_580791(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "featureKey" in path, "`featureKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/features/"),
               (kind: VariableSegment, value: "featureKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesGet_580790(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureKey: JString (required)
  ##             : The unique ID of the feature to retrieve.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureKey` field"
  var valid_580792 = path.getOrDefault("featureKey")
  valid_580792 = validateParameter(valid_580792, JString, required = true,
                                 default = nil)
  if valid_580792 != nil:
    section.add "featureKey", valid_580792
  var valid_580793 = path.getOrDefault("customer")
  valid_580793 = validateParameter(valid_580793, JString, required = true,
                                 default = nil)
  if valid_580793 != nil:
    section.add "customer", valid_580793
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
  var valid_580794 = query.getOrDefault("key")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "key", valid_580794
  var valid_580795 = query.getOrDefault("prettyPrint")
  valid_580795 = validateParameter(valid_580795, JBool, required = false,
                                 default = newJBool(true))
  if valid_580795 != nil:
    section.add "prettyPrint", valid_580795
  var valid_580796 = query.getOrDefault("oauth_token")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "oauth_token", valid_580796
  var valid_580797 = query.getOrDefault("alt")
  valid_580797 = validateParameter(valid_580797, JString, required = false,
                                 default = newJString("json"))
  if valid_580797 != nil:
    section.add "alt", valid_580797
  var valid_580798 = query.getOrDefault("userIp")
  valid_580798 = validateParameter(valid_580798, JString, required = false,
                                 default = nil)
  if valid_580798 != nil:
    section.add "userIp", valid_580798
  var valid_580799 = query.getOrDefault("quotaUser")
  valid_580799 = validateParameter(valid_580799, JString, required = false,
                                 default = nil)
  if valid_580799 != nil:
    section.add "quotaUser", valid_580799
  var valid_580800 = query.getOrDefault("fields")
  valid_580800 = validateParameter(valid_580800, JString, required = false,
                                 default = nil)
  if valid_580800 != nil:
    section.add "fields", valid_580800
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580801: Call_DirectoryResourcesFeaturesGet_580789; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a feature.
  ## 
  let valid = call_580801.validator(path, query, header, formData, body)
  let scheme = call_580801.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580801.url(scheme.get, call_580801.host, call_580801.base,
                         call_580801.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580801, url, valid)

proc call*(call_580802: Call_DirectoryResourcesFeaturesGet_580789;
          featureKey: string; customer: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryResourcesFeaturesGet
  ## Retrieves a feature.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   featureKey: string (required)
  ##             : The unique ID of the feature to retrieve.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580803 = newJObject()
  var query_580804 = newJObject()
  add(query_580804, "key", newJString(key))
  add(query_580804, "prettyPrint", newJBool(prettyPrint))
  add(query_580804, "oauth_token", newJString(oauthToken))
  add(path_580803, "featureKey", newJString(featureKey))
  add(path_580803, "customer", newJString(customer))
  add(query_580804, "alt", newJString(alt))
  add(query_580804, "userIp", newJString(userIp))
  add(query_580804, "quotaUser", newJString(quotaUser))
  add(query_580804, "fields", newJString(fields))
  result = call_580802.call(path_580803, query_580804, nil, nil, nil)

var directoryResourcesFeaturesGet* = Call_DirectoryResourcesFeaturesGet_580789(
    name: "directoryResourcesFeaturesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesGet_580790,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesGet_580791,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesPatch_580839 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesFeaturesPatch_580841(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "featureKey" in path, "`featureKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/features/"),
               (kind: VariableSegment, value: "featureKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesPatch_580840(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a feature. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureKey: JString (required)
  ##             : The unique ID of the feature to update.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureKey` field"
  var valid_580842 = path.getOrDefault("featureKey")
  valid_580842 = validateParameter(valid_580842, JString, required = true,
                                 default = nil)
  if valid_580842 != nil:
    section.add "featureKey", valid_580842
  var valid_580843 = path.getOrDefault("customer")
  valid_580843 = validateParameter(valid_580843, JString, required = true,
                                 default = nil)
  if valid_580843 != nil:
    section.add "customer", valid_580843
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
  var valid_580844 = query.getOrDefault("key")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "key", valid_580844
  var valid_580845 = query.getOrDefault("prettyPrint")
  valid_580845 = validateParameter(valid_580845, JBool, required = false,
                                 default = newJBool(true))
  if valid_580845 != nil:
    section.add "prettyPrint", valid_580845
  var valid_580846 = query.getOrDefault("oauth_token")
  valid_580846 = validateParameter(valid_580846, JString, required = false,
                                 default = nil)
  if valid_580846 != nil:
    section.add "oauth_token", valid_580846
  var valid_580847 = query.getOrDefault("alt")
  valid_580847 = validateParameter(valid_580847, JString, required = false,
                                 default = newJString("json"))
  if valid_580847 != nil:
    section.add "alt", valid_580847
  var valid_580848 = query.getOrDefault("userIp")
  valid_580848 = validateParameter(valid_580848, JString, required = false,
                                 default = nil)
  if valid_580848 != nil:
    section.add "userIp", valid_580848
  var valid_580849 = query.getOrDefault("quotaUser")
  valid_580849 = validateParameter(valid_580849, JString, required = false,
                                 default = nil)
  if valid_580849 != nil:
    section.add "quotaUser", valid_580849
  var valid_580850 = query.getOrDefault("fields")
  valid_580850 = validateParameter(valid_580850, JString, required = false,
                                 default = nil)
  if valid_580850 != nil:
    section.add "fields", valid_580850
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

proc call*(call_580852: Call_DirectoryResourcesFeaturesPatch_580839;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature. This method supports patch semantics.
  ## 
  let valid = call_580852.validator(path, query, header, formData, body)
  let scheme = call_580852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580852.url(scheme.get, call_580852.host, call_580852.base,
                         call_580852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580852, url, valid)

proc call*(call_580853: Call_DirectoryResourcesFeaturesPatch_580839;
          featureKey: string; customer: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryResourcesFeaturesPatch
  ## Updates a feature. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   featureKey: string (required)
  ##             : The unique ID of the feature to update.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580854 = newJObject()
  var query_580855 = newJObject()
  var body_580856 = newJObject()
  add(query_580855, "key", newJString(key))
  add(query_580855, "prettyPrint", newJBool(prettyPrint))
  add(query_580855, "oauth_token", newJString(oauthToken))
  add(path_580854, "featureKey", newJString(featureKey))
  add(path_580854, "customer", newJString(customer))
  add(query_580855, "alt", newJString(alt))
  add(query_580855, "userIp", newJString(userIp))
  add(query_580855, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580856 = body
  add(query_580855, "fields", newJString(fields))
  result = call_580853.call(path_580854, query_580855, nil, nil, body_580856)

var directoryResourcesFeaturesPatch* = Call_DirectoryResourcesFeaturesPatch_580839(
    name: "directoryResourcesFeaturesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesPatch_580840,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesPatch_580841,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesDelete_580823 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesFeaturesDelete_580825(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "featureKey" in path, "`featureKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/features/"),
               (kind: VariableSegment, value: "featureKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesDelete_580824(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   featureKey: JString (required)
  ##             : The unique ID of the feature to delete.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `featureKey` field"
  var valid_580826 = path.getOrDefault("featureKey")
  valid_580826 = validateParameter(valid_580826, JString, required = true,
                                 default = nil)
  if valid_580826 != nil:
    section.add "featureKey", valid_580826
  var valid_580827 = path.getOrDefault("customer")
  valid_580827 = validateParameter(valid_580827, JString, required = true,
                                 default = nil)
  if valid_580827 != nil:
    section.add "customer", valid_580827
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
  var valid_580828 = query.getOrDefault("key")
  valid_580828 = validateParameter(valid_580828, JString, required = false,
                                 default = nil)
  if valid_580828 != nil:
    section.add "key", valid_580828
  var valid_580829 = query.getOrDefault("prettyPrint")
  valid_580829 = validateParameter(valid_580829, JBool, required = false,
                                 default = newJBool(true))
  if valid_580829 != nil:
    section.add "prettyPrint", valid_580829
  var valid_580830 = query.getOrDefault("oauth_token")
  valid_580830 = validateParameter(valid_580830, JString, required = false,
                                 default = nil)
  if valid_580830 != nil:
    section.add "oauth_token", valid_580830
  var valid_580831 = query.getOrDefault("alt")
  valid_580831 = validateParameter(valid_580831, JString, required = false,
                                 default = newJString("json"))
  if valid_580831 != nil:
    section.add "alt", valid_580831
  var valid_580832 = query.getOrDefault("userIp")
  valid_580832 = validateParameter(valid_580832, JString, required = false,
                                 default = nil)
  if valid_580832 != nil:
    section.add "userIp", valid_580832
  var valid_580833 = query.getOrDefault("quotaUser")
  valid_580833 = validateParameter(valid_580833, JString, required = false,
                                 default = nil)
  if valid_580833 != nil:
    section.add "quotaUser", valid_580833
  var valid_580834 = query.getOrDefault("fields")
  valid_580834 = validateParameter(valid_580834, JString, required = false,
                                 default = nil)
  if valid_580834 != nil:
    section.add "fields", valid_580834
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580835: Call_DirectoryResourcesFeaturesDelete_580823;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a feature.
  ## 
  let valid = call_580835.validator(path, query, header, formData, body)
  let scheme = call_580835.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580835.url(scheme.get, call_580835.host, call_580835.base,
                         call_580835.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580835, url, valid)

proc call*(call_580836: Call_DirectoryResourcesFeaturesDelete_580823;
          featureKey: string; customer: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryResourcesFeaturesDelete
  ## Deletes a feature.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   featureKey: string (required)
  ##             : The unique ID of the feature to delete.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580837 = newJObject()
  var query_580838 = newJObject()
  add(query_580838, "key", newJString(key))
  add(query_580838, "prettyPrint", newJBool(prettyPrint))
  add(query_580838, "oauth_token", newJString(oauthToken))
  add(path_580837, "featureKey", newJString(featureKey))
  add(path_580837, "customer", newJString(customer))
  add(query_580838, "alt", newJString(alt))
  add(query_580838, "userIp", newJString(userIp))
  add(query_580838, "quotaUser", newJString(quotaUser))
  add(query_580838, "fields", newJString(fields))
  result = call_580836.call(path_580837, query_580838, nil, nil, nil)

var directoryResourcesFeaturesDelete* = Call_DirectoryResourcesFeaturesDelete_580823(
    name: "directoryResourcesFeaturesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesDelete_580824,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesDelete_580825,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesRename_580857 = ref object of OpenApiRestCall_579389
proc url_DirectoryResourcesFeaturesRename_580859(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "oldName" in path, "`oldName` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/resources/features/"),
               (kind: VariableSegment, value: "oldName"),
               (kind: ConstantSegment, value: "/rename")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesRename_580858(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renames a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   oldName: JString (required)
  ##          : The unique ID of the feature to rename.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580860 = path.getOrDefault("customer")
  valid_580860 = validateParameter(valid_580860, JString, required = true,
                                 default = nil)
  if valid_580860 != nil:
    section.add "customer", valid_580860
  var valid_580861 = path.getOrDefault("oldName")
  valid_580861 = validateParameter(valid_580861, JString, required = true,
                                 default = nil)
  if valid_580861 != nil:
    section.add "oldName", valid_580861
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
  var valid_580862 = query.getOrDefault("key")
  valid_580862 = validateParameter(valid_580862, JString, required = false,
                                 default = nil)
  if valid_580862 != nil:
    section.add "key", valid_580862
  var valid_580863 = query.getOrDefault("prettyPrint")
  valid_580863 = validateParameter(valid_580863, JBool, required = false,
                                 default = newJBool(true))
  if valid_580863 != nil:
    section.add "prettyPrint", valid_580863
  var valid_580864 = query.getOrDefault("oauth_token")
  valid_580864 = validateParameter(valid_580864, JString, required = false,
                                 default = nil)
  if valid_580864 != nil:
    section.add "oauth_token", valid_580864
  var valid_580865 = query.getOrDefault("alt")
  valid_580865 = validateParameter(valid_580865, JString, required = false,
                                 default = newJString("json"))
  if valid_580865 != nil:
    section.add "alt", valid_580865
  var valid_580866 = query.getOrDefault("userIp")
  valid_580866 = validateParameter(valid_580866, JString, required = false,
                                 default = nil)
  if valid_580866 != nil:
    section.add "userIp", valid_580866
  var valid_580867 = query.getOrDefault("quotaUser")
  valid_580867 = validateParameter(valid_580867, JString, required = false,
                                 default = nil)
  if valid_580867 != nil:
    section.add "quotaUser", valid_580867
  var valid_580868 = query.getOrDefault("fields")
  valid_580868 = validateParameter(valid_580868, JString, required = false,
                                 default = nil)
  if valid_580868 != nil:
    section.add "fields", valid_580868
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

proc call*(call_580870: Call_DirectoryResourcesFeaturesRename_580857;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a feature.
  ## 
  let valid = call_580870.validator(path, query, header, formData, body)
  let scheme = call_580870.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580870.url(scheme.get, call_580870.host, call_580870.base,
                         call_580870.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580870, url, valid)

proc call*(call_580871: Call_DirectoryResourcesFeaturesRename_580857;
          customer: string; oldName: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryResourcesFeaturesRename
  ## Renames a feature.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   oldName: string (required)
  ##          : The unique ID of the feature to rename.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580872 = newJObject()
  var query_580873 = newJObject()
  var body_580874 = newJObject()
  add(query_580873, "key", newJString(key))
  add(query_580873, "prettyPrint", newJBool(prettyPrint))
  add(query_580873, "oauth_token", newJString(oauthToken))
  add(path_580872, "customer", newJString(customer))
  add(query_580873, "alt", newJString(alt))
  add(query_580873, "userIp", newJString(userIp))
  add(query_580873, "quotaUser", newJString(quotaUser))
  add(path_580872, "oldName", newJString(oldName))
  if body != nil:
    body_580874 = body
  add(query_580873, "fields", newJString(fields))
  result = call_580871.call(path_580872, query_580873, nil, nil, body_580874)

var directoryResourcesFeaturesRename* = Call_DirectoryResourcesFeaturesRename_580857(
    name: "directoryResourcesFeaturesRename", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{oldName}/rename",
    validator: validate_DirectoryResourcesFeaturesRename_580858,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesRename_580859,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsInsert_580894 = ref object of OpenApiRestCall_579389
proc url_DirectoryRoleAssignmentsInsert_580896(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roleassignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRoleAssignmentsInsert_580895(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a role assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580897 = path.getOrDefault("customer")
  valid_580897 = validateParameter(valid_580897, JString, required = true,
                                 default = nil)
  if valid_580897 != nil:
    section.add "customer", valid_580897
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
  var valid_580898 = query.getOrDefault("key")
  valid_580898 = validateParameter(valid_580898, JString, required = false,
                                 default = nil)
  if valid_580898 != nil:
    section.add "key", valid_580898
  var valid_580899 = query.getOrDefault("prettyPrint")
  valid_580899 = validateParameter(valid_580899, JBool, required = false,
                                 default = newJBool(true))
  if valid_580899 != nil:
    section.add "prettyPrint", valid_580899
  var valid_580900 = query.getOrDefault("oauth_token")
  valid_580900 = validateParameter(valid_580900, JString, required = false,
                                 default = nil)
  if valid_580900 != nil:
    section.add "oauth_token", valid_580900
  var valid_580901 = query.getOrDefault("alt")
  valid_580901 = validateParameter(valid_580901, JString, required = false,
                                 default = newJString("json"))
  if valid_580901 != nil:
    section.add "alt", valid_580901
  var valid_580902 = query.getOrDefault("userIp")
  valid_580902 = validateParameter(valid_580902, JString, required = false,
                                 default = nil)
  if valid_580902 != nil:
    section.add "userIp", valid_580902
  var valid_580903 = query.getOrDefault("quotaUser")
  valid_580903 = validateParameter(valid_580903, JString, required = false,
                                 default = nil)
  if valid_580903 != nil:
    section.add "quotaUser", valid_580903
  var valid_580904 = query.getOrDefault("fields")
  valid_580904 = validateParameter(valid_580904, JString, required = false,
                                 default = nil)
  if valid_580904 != nil:
    section.add "fields", valid_580904
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

proc call*(call_580906: Call_DirectoryRoleAssignmentsInsert_580894; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment.
  ## 
  let valid = call_580906.validator(path, query, header, formData, body)
  let scheme = call_580906.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580906.url(scheme.get, call_580906.host, call_580906.base,
                         call_580906.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580906, url, valid)

proc call*(call_580907: Call_DirectoryRoleAssignmentsInsert_580894;
          customer: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryRoleAssignmentsInsert
  ## Creates a role assignment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580908 = newJObject()
  var query_580909 = newJObject()
  var body_580910 = newJObject()
  add(query_580909, "key", newJString(key))
  add(query_580909, "prettyPrint", newJBool(prettyPrint))
  add(query_580909, "oauth_token", newJString(oauthToken))
  add(path_580908, "customer", newJString(customer))
  add(query_580909, "alt", newJString(alt))
  add(query_580909, "userIp", newJString(userIp))
  add(query_580909, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580910 = body
  add(query_580909, "fields", newJString(fields))
  result = call_580907.call(path_580908, query_580909, nil, nil, body_580910)

var directoryRoleAssignmentsInsert* = Call_DirectoryRoleAssignmentsInsert_580894(
    name: "directoryRoleAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsInsert_580895,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsInsert_580896,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsList_580875 = ref object of OpenApiRestCall_579389
proc url_DirectoryRoleAssignmentsList_580877(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roleassignments")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRoleAssignmentsList_580876(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a paginated list of all roleAssignments.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580878 = path.getOrDefault("customer")
  valid_580878 = validateParameter(valid_580878, JString, required = true,
                                 default = nil)
  if valid_580878 != nil:
    section.add "customer", valid_580878
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
  ##   userKey: JString
  ##          : The user's primary email address, alias email address, or unique user ID. If included in the request, returns role assignments only for this user.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   roleId: JString
  ##         : Immutable ID of a role. If included in the request, returns only role assignments containing this role ID.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_580879 = query.getOrDefault("key")
  valid_580879 = validateParameter(valid_580879, JString, required = false,
                                 default = nil)
  if valid_580879 != nil:
    section.add "key", valid_580879
  var valid_580880 = query.getOrDefault("prettyPrint")
  valid_580880 = validateParameter(valid_580880, JBool, required = false,
                                 default = newJBool(true))
  if valid_580880 != nil:
    section.add "prettyPrint", valid_580880
  var valid_580881 = query.getOrDefault("oauth_token")
  valid_580881 = validateParameter(valid_580881, JString, required = false,
                                 default = nil)
  if valid_580881 != nil:
    section.add "oauth_token", valid_580881
  var valid_580882 = query.getOrDefault("alt")
  valid_580882 = validateParameter(valid_580882, JString, required = false,
                                 default = newJString("json"))
  if valid_580882 != nil:
    section.add "alt", valid_580882
  var valid_580883 = query.getOrDefault("userIp")
  valid_580883 = validateParameter(valid_580883, JString, required = false,
                                 default = nil)
  if valid_580883 != nil:
    section.add "userIp", valid_580883
  var valid_580884 = query.getOrDefault("quotaUser")
  valid_580884 = validateParameter(valid_580884, JString, required = false,
                                 default = nil)
  if valid_580884 != nil:
    section.add "quotaUser", valid_580884
  var valid_580885 = query.getOrDefault("userKey")
  valid_580885 = validateParameter(valid_580885, JString, required = false,
                                 default = nil)
  if valid_580885 != nil:
    section.add "userKey", valid_580885
  var valid_580886 = query.getOrDefault("pageToken")
  valid_580886 = validateParameter(valid_580886, JString, required = false,
                                 default = nil)
  if valid_580886 != nil:
    section.add "pageToken", valid_580886
  var valid_580887 = query.getOrDefault("roleId")
  valid_580887 = validateParameter(valid_580887, JString, required = false,
                                 default = nil)
  if valid_580887 != nil:
    section.add "roleId", valid_580887
  var valid_580888 = query.getOrDefault("fields")
  valid_580888 = validateParameter(valid_580888, JString, required = false,
                                 default = nil)
  if valid_580888 != nil:
    section.add "fields", valid_580888
  var valid_580889 = query.getOrDefault("maxResults")
  valid_580889 = validateParameter(valid_580889, JInt, required = false, default = nil)
  if valid_580889 != nil:
    section.add "maxResults", valid_580889
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580890: Call_DirectoryRoleAssignmentsList_580875; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all roleAssignments.
  ## 
  let valid = call_580890.validator(path, query, header, formData, body)
  let scheme = call_580890.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580890.url(scheme.get, call_580890.host, call_580890.base,
                         call_580890.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580890, url, valid)

proc call*(call_580891: Call_DirectoryRoleAssignmentsList_580875; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userKey: string = ""; pageToken: string = ""; roleId: string = "";
          fields: string = ""; maxResults: int = 0): Recallable =
  ## directoryRoleAssignmentsList
  ## Retrieves a paginated list of all roleAssignments.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userKey: string
  ##          : The user's primary email address, alias email address, or unique user ID. If included in the request, returns role assignments only for this user.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   roleId: string
  ##         : Immutable ID of a role. If included in the request, returns only role assignments containing this role ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var path_580892 = newJObject()
  var query_580893 = newJObject()
  add(query_580893, "key", newJString(key))
  add(query_580893, "prettyPrint", newJBool(prettyPrint))
  add(query_580893, "oauth_token", newJString(oauthToken))
  add(path_580892, "customer", newJString(customer))
  add(query_580893, "alt", newJString(alt))
  add(query_580893, "userIp", newJString(userIp))
  add(query_580893, "quotaUser", newJString(quotaUser))
  add(query_580893, "userKey", newJString(userKey))
  add(query_580893, "pageToken", newJString(pageToken))
  add(query_580893, "roleId", newJString(roleId))
  add(query_580893, "fields", newJString(fields))
  add(query_580893, "maxResults", newJInt(maxResults))
  result = call_580891.call(path_580892, query_580893, nil, nil, nil)

var directoryRoleAssignmentsList* = Call_DirectoryRoleAssignmentsList_580875(
    name: "directoryRoleAssignmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsList_580876,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsList_580877,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsGet_580911 = ref object of OpenApiRestCall_579389
proc url_DirectoryRoleAssignmentsGet_580913(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "roleAssignmentId" in path,
        "`roleAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roleassignments/"),
               (kind: VariableSegment, value: "roleAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRoleAssignmentsGet_580912(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve a role assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   roleAssignmentId: JString (required)
  ##                   : Immutable ID of the role assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580914 = path.getOrDefault("customer")
  valid_580914 = validateParameter(valid_580914, JString, required = true,
                                 default = nil)
  if valid_580914 != nil:
    section.add "customer", valid_580914
  var valid_580915 = path.getOrDefault("roleAssignmentId")
  valid_580915 = validateParameter(valid_580915, JString, required = true,
                                 default = nil)
  if valid_580915 != nil:
    section.add "roleAssignmentId", valid_580915
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
  var valid_580916 = query.getOrDefault("key")
  valid_580916 = validateParameter(valid_580916, JString, required = false,
                                 default = nil)
  if valid_580916 != nil:
    section.add "key", valid_580916
  var valid_580917 = query.getOrDefault("prettyPrint")
  valid_580917 = validateParameter(valid_580917, JBool, required = false,
                                 default = newJBool(true))
  if valid_580917 != nil:
    section.add "prettyPrint", valid_580917
  var valid_580918 = query.getOrDefault("oauth_token")
  valid_580918 = validateParameter(valid_580918, JString, required = false,
                                 default = nil)
  if valid_580918 != nil:
    section.add "oauth_token", valid_580918
  var valid_580919 = query.getOrDefault("alt")
  valid_580919 = validateParameter(valid_580919, JString, required = false,
                                 default = newJString("json"))
  if valid_580919 != nil:
    section.add "alt", valid_580919
  var valid_580920 = query.getOrDefault("userIp")
  valid_580920 = validateParameter(valid_580920, JString, required = false,
                                 default = nil)
  if valid_580920 != nil:
    section.add "userIp", valid_580920
  var valid_580921 = query.getOrDefault("quotaUser")
  valid_580921 = validateParameter(valid_580921, JString, required = false,
                                 default = nil)
  if valid_580921 != nil:
    section.add "quotaUser", valid_580921
  var valid_580922 = query.getOrDefault("fields")
  valid_580922 = validateParameter(valid_580922, JString, required = false,
                                 default = nil)
  if valid_580922 != nil:
    section.add "fields", valid_580922
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580923: Call_DirectoryRoleAssignmentsGet_580911; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a role assignment.
  ## 
  let valid = call_580923.validator(path, query, header, formData, body)
  let scheme = call_580923.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580923.url(scheme.get, call_580923.host, call_580923.base,
                         call_580923.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580923, url, valid)

proc call*(call_580924: Call_DirectoryRoleAssignmentsGet_580911; customer: string;
          roleAssignmentId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryRoleAssignmentsGet
  ## Retrieve a role assignment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roleAssignmentId: string (required)
  ##                   : Immutable ID of the role assignment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580925 = newJObject()
  var query_580926 = newJObject()
  add(query_580926, "key", newJString(key))
  add(query_580926, "prettyPrint", newJBool(prettyPrint))
  add(query_580926, "oauth_token", newJString(oauthToken))
  add(path_580925, "customer", newJString(customer))
  add(query_580926, "alt", newJString(alt))
  add(query_580926, "userIp", newJString(userIp))
  add(query_580926, "quotaUser", newJString(quotaUser))
  add(path_580925, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_580926, "fields", newJString(fields))
  result = call_580924.call(path_580925, query_580926, nil, nil, nil)

var directoryRoleAssignmentsGet* = Call_DirectoryRoleAssignmentsGet_580911(
    name: "directoryRoleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsGet_580912,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsGet_580913,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsDelete_580927 = ref object of OpenApiRestCall_579389
proc url_DirectoryRoleAssignmentsDelete_580929(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "roleAssignmentId" in path,
        "`roleAssignmentId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roleassignments/"),
               (kind: VariableSegment, value: "roleAssignmentId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRoleAssignmentsDelete_580928(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a role assignment.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   roleAssignmentId: JString (required)
  ##                   : Immutable ID of the role assignment.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580930 = path.getOrDefault("customer")
  valid_580930 = validateParameter(valid_580930, JString, required = true,
                                 default = nil)
  if valid_580930 != nil:
    section.add "customer", valid_580930
  var valid_580931 = path.getOrDefault("roleAssignmentId")
  valid_580931 = validateParameter(valid_580931, JString, required = true,
                                 default = nil)
  if valid_580931 != nil:
    section.add "roleAssignmentId", valid_580931
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
  var valid_580932 = query.getOrDefault("key")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = nil)
  if valid_580932 != nil:
    section.add "key", valid_580932
  var valid_580933 = query.getOrDefault("prettyPrint")
  valid_580933 = validateParameter(valid_580933, JBool, required = false,
                                 default = newJBool(true))
  if valid_580933 != nil:
    section.add "prettyPrint", valid_580933
  var valid_580934 = query.getOrDefault("oauth_token")
  valid_580934 = validateParameter(valid_580934, JString, required = false,
                                 default = nil)
  if valid_580934 != nil:
    section.add "oauth_token", valid_580934
  var valid_580935 = query.getOrDefault("alt")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = newJString("json"))
  if valid_580935 != nil:
    section.add "alt", valid_580935
  var valid_580936 = query.getOrDefault("userIp")
  valid_580936 = validateParameter(valid_580936, JString, required = false,
                                 default = nil)
  if valid_580936 != nil:
    section.add "userIp", valid_580936
  var valid_580937 = query.getOrDefault("quotaUser")
  valid_580937 = validateParameter(valid_580937, JString, required = false,
                                 default = nil)
  if valid_580937 != nil:
    section.add "quotaUser", valid_580937
  var valid_580938 = query.getOrDefault("fields")
  valid_580938 = validateParameter(valid_580938, JString, required = false,
                                 default = nil)
  if valid_580938 != nil:
    section.add "fields", valid_580938
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580939: Call_DirectoryRoleAssignmentsDelete_580927; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_580939.validator(path, query, header, formData, body)
  let scheme = call_580939.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580939.url(scheme.get, call_580939.host, call_580939.base,
                         call_580939.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580939, url, valid)

proc call*(call_580940: Call_DirectoryRoleAssignmentsDelete_580927;
          customer: string; roleAssignmentId: string; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryRoleAssignmentsDelete
  ## Deletes a role assignment.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   roleAssignmentId: string (required)
  ##                   : Immutable ID of the role assignment.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580941 = newJObject()
  var query_580942 = newJObject()
  add(query_580942, "key", newJString(key))
  add(query_580942, "prettyPrint", newJBool(prettyPrint))
  add(query_580942, "oauth_token", newJString(oauthToken))
  add(path_580941, "customer", newJString(customer))
  add(query_580942, "alt", newJString(alt))
  add(query_580942, "userIp", newJString(userIp))
  add(query_580942, "quotaUser", newJString(quotaUser))
  add(path_580941, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_580942, "fields", newJString(fields))
  result = call_580940.call(path_580941, query_580942, nil, nil, nil)

var directoryRoleAssignmentsDelete* = Call_DirectoryRoleAssignmentsDelete_580927(
    name: "directoryRoleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsDelete_580928,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsDelete_580929,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesInsert_580960 = ref object of OpenApiRestCall_579389
proc url_DirectoryRolesInsert_580962(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRolesInsert_580961(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580963 = path.getOrDefault("customer")
  valid_580963 = validateParameter(valid_580963, JString, required = true,
                                 default = nil)
  if valid_580963 != nil:
    section.add "customer", valid_580963
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
  var valid_580964 = query.getOrDefault("key")
  valid_580964 = validateParameter(valid_580964, JString, required = false,
                                 default = nil)
  if valid_580964 != nil:
    section.add "key", valid_580964
  var valid_580965 = query.getOrDefault("prettyPrint")
  valid_580965 = validateParameter(valid_580965, JBool, required = false,
                                 default = newJBool(true))
  if valid_580965 != nil:
    section.add "prettyPrint", valid_580965
  var valid_580966 = query.getOrDefault("oauth_token")
  valid_580966 = validateParameter(valid_580966, JString, required = false,
                                 default = nil)
  if valid_580966 != nil:
    section.add "oauth_token", valid_580966
  var valid_580967 = query.getOrDefault("alt")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = newJString("json"))
  if valid_580967 != nil:
    section.add "alt", valid_580967
  var valid_580968 = query.getOrDefault("userIp")
  valid_580968 = validateParameter(valid_580968, JString, required = false,
                                 default = nil)
  if valid_580968 != nil:
    section.add "userIp", valid_580968
  var valid_580969 = query.getOrDefault("quotaUser")
  valid_580969 = validateParameter(valid_580969, JString, required = false,
                                 default = nil)
  if valid_580969 != nil:
    section.add "quotaUser", valid_580969
  var valid_580970 = query.getOrDefault("fields")
  valid_580970 = validateParameter(valid_580970, JString, required = false,
                                 default = nil)
  if valid_580970 != nil:
    section.add "fields", valid_580970
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

proc call*(call_580972: Call_DirectoryRolesInsert_580960; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role.
  ## 
  let valid = call_580972.validator(path, query, header, formData, body)
  let scheme = call_580972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580972.url(scheme.get, call_580972.host, call_580972.base,
                         call_580972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580972, url, valid)

proc call*(call_580973: Call_DirectoryRolesInsert_580960; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryRolesInsert
  ## Creates a role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580974 = newJObject()
  var query_580975 = newJObject()
  var body_580976 = newJObject()
  add(query_580975, "key", newJString(key))
  add(query_580975, "prettyPrint", newJBool(prettyPrint))
  add(query_580975, "oauth_token", newJString(oauthToken))
  add(path_580974, "customer", newJString(customer))
  add(query_580975, "alt", newJString(alt))
  add(query_580975, "userIp", newJString(userIp))
  add(query_580975, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580976 = body
  add(query_580975, "fields", newJString(fields))
  result = call_580973.call(path_580974, query_580975, nil, nil, body_580976)

var directoryRolesInsert* = Call_DirectoryRolesInsert_580960(
    name: "directoryRolesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesInsert_580961, base: "/admin/directory/v1",
    url: url_DirectoryRolesInsert_580962, schemes: {Scheme.Https})
type
  Call_DirectoryRolesList_580943 = ref object of OpenApiRestCall_579389
proc url_DirectoryRolesList_580945(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRolesList_580944(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a paginated list of all the roles in a domain.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580946 = path.getOrDefault("customer")
  valid_580946 = validateParameter(valid_580946, JString, required = true,
                                 default = nil)
  if valid_580946 != nil:
    section.add "customer", valid_580946
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
  ##            : Token to specify the next page in the list.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_580947 = query.getOrDefault("key")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = nil)
  if valid_580947 != nil:
    section.add "key", valid_580947
  var valid_580948 = query.getOrDefault("prettyPrint")
  valid_580948 = validateParameter(valid_580948, JBool, required = false,
                                 default = newJBool(true))
  if valid_580948 != nil:
    section.add "prettyPrint", valid_580948
  var valid_580949 = query.getOrDefault("oauth_token")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = nil)
  if valid_580949 != nil:
    section.add "oauth_token", valid_580949
  var valid_580950 = query.getOrDefault("alt")
  valid_580950 = validateParameter(valid_580950, JString, required = false,
                                 default = newJString("json"))
  if valid_580950 != nil:
    section.add "alt", valid_580950
  var valid_580951 = query.getOrDefault("userIp")
  valid_580951 = validateParameter(valid_580951, JString, required = false,
                                 default = nil)
  if valid_580951 != nil:
    section.add "userIp", valid_580951
  var valid_580952 = query.getOrDefault("quotaUser")
  valid_580952 = validateParameter(valid_580952, JString, required = false,
                                 default = nil)
  if valid_580952 != nil:
    section.add "quotaUser", valid_580952
  var valid_580953 = query.getOrDefault("pageToken")
  valid_580953 = validateParameter(valid_580953, JString, required = false,
                                 default = nil)
  if valid_580953 != nil:
    section.add "pageToken", valid_580953
  var valid_580954 = query.getOrDefault("fields")
  valid_580954 = validateParameter(valid_580954, JString, required = false,
                                 default = nil)
  if valid_580954 != nil:
    section.add "fields", valid_580954
  var valid_580955 = query.getOrDefault("maxResults")
  valid_580955 = validateParameter(valid_580955, JInt, required = false, default = nil)
  if valid_580955 != nil:
    section.add "maxResults", valid_580955
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580956: Call_DirectoryRolesList_580943; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all the roles in a domain.
  ## 
  let valid = call_580956.validator(path, query, header, formData, body)
  let scheme = call_580956.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580956.url(scheme.get, call_580956.host, call_580956.base,
                         call_580956.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580956, url, valid)

proc call*(call_580957: Call_DirectoryRolesList_580943; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 0): Recallable =
  ## directoryRolesList
  ## Retrieves a paginated list of all the roles in a domain.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var path_580958 = newJObject()
  var query_580959 = newJObject()
  add(query_580959, "key", newJString(key))
  add(query_580959, "prettyPrint", newJBool(prettyPrint))
  add(query_580959, "oauth_token", newJString(oauthToken))
  add(path_580958, "customer", newJString(customer))
  add(query_580959, "alt", newJString(alt))
  add(query_580959, "userIp", newJString(userIp))
  add(query_580959, "quotaUser", newJString(quotaUser))
  add(query_580959, "pageToken", newJString(pageToken))
  add(query_580959, "fields", newJString(fields))
  add(query_580959, "maxResults", newJInt(maxResults))
  result = call_580957.call(path_580958, query_580959, nil, nil, nil)

var directoryRolesList* = Call_DirectoryRolesList_580943(
    name: "directoryRolesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesList_580944, base: "/admin/directory/v1",
    url: url_DirectoryRolesList_580945, schemes: {Scheme.Https})
type
  Call_DirectoryPrivilegesList_580977 = ref object of OpenApiRestCall_579389
proc url_DirectoryPrivilegesList_580979(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roles/ALL/privileges")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryPrivilegesList_580978(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a paginated list of all privileges for a customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580980 = path.getOrDefault("customer")
  valid_580980 = validateParameter(valid_580980, JString, required = true,
                                 default = nil)
  if valid_580980 != nil:
    section.add "customer", valid_580980
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
  var valid_580981 = query.getOrDefault("key")
  valid_580981 = validateParameter(valid_580981, JString, required = false,
                                 default = nil)
  if valid_580981 != nil:
    section.add "key", valid_580981
  var valid_580982 = query.getOrDefault("prettyPrint")
  valid_580982 = validateParameter(valid_580982, JBool, required = false,
                                 default = newJBool(true))
  if valid_580982 != nil:
    section.add "prettyPrint", valid_580982
  var valid_580983 = query.getOrDefault("oauth_token")
  valid_580983 = validateParameter(valid_580983, JString, required = false,
                                 default = nil)
  if valid_580983 != nil:
    section.add "oauth_token", valid_580983
  var valid_580984 = query.getOrDefault("alt")
  valid_580984 = validateParameter(valid_580984, JString, required = false,
                                 default = newJString("json"))
  if valid_580984 != nil:
    section.add "alt", valid_580984
  var valid_580985 = query.getOrDefault("userIp")
  valid_580985 = validateParameter(valid_580985, JString, required = false,
                                 default = nil)
  if valid_580985 != nil:
    section.add "userIp", valid_580985
  var valid_580986 = query.getOrDefault("quotaUser")
  valid_580986 = validateParameter(valid_580986, JString, required = false,
                                 default = nil)
  if valid_580986 != nil:
    section.add "quotaUser", valid_580986
  var valid_580987 = query.getOrDefault("fields")
  valid_580987 = validateParameter(valid_580987, JString, required = false,
                                 default = nil)
  if valid_580987 != nil:
    section.add "fields", valid_580987
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580988: Call_DirectoryPrivilegesList_580977; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all privileges for a customer.
  ## 
  let valid = call_580988.validator(path, query, header, formData, body)
  let scheme = call_580988.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580988.url(scheme.get, call_580988.host, call_580988.base,
                         call_580988.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580988, url, valid)

proc call*(call_580989: Call_DirectoryPrivilegesList_580977; customer: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryPrivilegesList
  ## Retrieves a paginated list of all privileges for a customer.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_580990 = newJObject()
  var query_580991 = newJObject()
  add(query_580991, "key", newJString(key))
  add(query_580991, "prettyPrint", newJBool(prettyPrint))
  add(query_580991, "oauth_token", newJString(oauthToken))
  add(path_580990, "customer", newJString(customer))
  add(query_580991, "alt", newJString(alt))
  add(query_580991, "userIp", newJString(userIp))
  add(query_580991, "quotaUser", newJString(quotaUser))
  add(query_580991, "fields", newJString(fields))
  result = call_580989.call(path_580990, query_580991, nil, nil, nil)

var directoryPrivilegesList* = Call_DirectoryPrivilegesList_580977(
    name: "directoryPrivilegesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roles/ALL/privileges",
    validator: validate_DirectoryPrivilegesList_580978,
    base: "/admin/directory/v1", url: url_DirectoryPrivilegesList_580979,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesUpdate_581008 = ref object of OpenApiRestCall_579389
proc url_DirectoryRolesUpdate_581010(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRolesUpdate_581009(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   roleId: JString (required)
  ##         : Immutable ID of the role.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_581011 = path.getOrDefault("customer")
  valid_581011 = validateParameter(valid_581011, JString, required = true,
                                 default = nil)
  if valid_581011 != nil:
    section.add "customer", valid_581011
  var valid_581012 = path.getOrDefault("roleId")
  valid_581012 = validateParameter(valid_581012, JString, required = true,
                                 default = nil)
  if valid_581012 != nil:
    section.add "roleId", valid_581012
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
  var valid_581013 = query.getOrDefault("key")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "key", valid_581013
  var valid_581014 = query.getOrDefault("prettyPrint")
  valid_581014 = validateParameter(valid_581014, JBool, required = false,
                                 default = newJBool(true))
  if valid_581014 != nil:
    section.add "prettyPrint", valid_581014
  var valid_581015 = query.getOrDefault("oauth_token")
  valid_581015 = validateParameter(valid_581015, JString, required = false,
                                 default = nil)
  if valid_581015 != nil:
    section.add "oauth_token", valid_581015
  var valid_581016 = query.getOrDefault("alt")
  valid_581016 = validateParameter(valid_581016, JString, required = false,
                                 default = newJString("json"))
  if valid_581016 != nil:
    section.add "alt", valid_581016
  var valid_581017 = query.getOrDefault("userIp")
  valid_581017 = validateParameter(valid_581017, JString, required = false,
                                 default = nil)
  if valid_581017 != nil:
    section.add "userIp", valid_581017
  var valid_581018 = query.getOrDefault("quotaUser")
  valid_581018 = validateParameter(valid_581018, JString, required = false,
                                 default = nil)
  if valid_581018 != nil:
    section.add "quotaUser", valid_581018
  var valid_581019 = query.getOrDefault("fields")
  valid_581019 = validateParameter(valid_581019, JString, required = false,
                                 default = nil)
  if valid_581019 != nil:
    section.add "fields", valid_581019
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

proc call*(call_581021: Call_DirectoryRolesUpdate_581008; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role.
  ## 
  let valid = call_581021.validator(path, query, header, formData, body)
  let scheme = call_581021.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581021.url(scheme.get, call_581021.host, call_581021.base,
                         call_581021.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581021, url, valid)

proc call*(call_581022: Call_DirectoryRolesUpdate_581008; customer: string;
          roleId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryRolesUpdate
  ## Updates a role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   roleId: string (required)
  ##         : Immutable ID of the role.
  var path_581023 = newJObject()
  var query_581024 = newJObject()
  var body_581025 = newJObject()
  add(query_581024, "key", newJString(key))
  add(query_581024, "prettyPrint", newJBool(prettyPrint))
  add(query_581024, "oauth_token", newJString(oauthToken))
  add(path_581023, "customer", newJString(customer))
  add(query_581024, "alt", newJString(alt))
  add(query_581024, "userIp", newJString(userIp))
  add(query_581024, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581025 = body
  add(query_581024, "fields", newJString(fields))
  add(path_581023, "roleId", newJString(roleId))
  result = call_581022.call(path_581023, query_581024, nil, nil, body_581025)

var directoryRolesUpdate* = Call_DirectoryRolesUpdate_581008(
    name: "directoryRolesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesUpdate_581009, base: "/admin/directory/v1",
    url: url_DirectoryRolesUpdate_581010, schemes: {Scheme.Https})
type
  Call_DirectoryRolesGet_580992 = ref object of OpenApiRestCall_579389
proc url_DirectoryRolesGet_580994(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRolesGet_580993(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   roleId: JString (required)
  ##         : Immutable ID of the role.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_580995 = path.getOrDefault("customer")
  valid_580995 = validateParameter(valid_580995, JString, required = true,
                                 default = nil)
  if valid_580995 != nil:
    section.add "customer", valid_580995
  var valid_580996 = path.getOrDefault("roleId")
  valid_580996 = validateParameter(valid_580996, JString, required = true,
                                 default = nil)
  if valid_580996 != nil:
    section.add "roleId", valid_580996
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
  var valid_580997 = query.getOrDefault("key")
  valid_580997 = validateParameter(valid_580997, JString, required = false,
                                 default = nil)
  if valid_580997 != nil:
    section.add "key", valid_580997
  var valid_580998 = query.getOrDefault("prettyPrint")
  valid_580998 = validateParameter(valid_580998, JBool, required = false,
                                 default = newJBool(true))
  if valid_580998 != nil:
    section.add "prettyPrint", valid_580998
  var valid_580999 = query.getOrDefault("oauth_token")
  valid_580999 = validateParameter(valid_580999, JString, required = false,
                                 default = nil)
  if valid_580999 != nil:
    section.add "oauth_token", valid_580999
  var valid_581000 = query.getOrDefault("alt")
  valid_581000 = validateParameter(valid_581000, JString, required = false,
                                 default = newJString("json"))
  if valid_581000 != nil:
    section.add "alt", valid_581000
  var valid_581001 = query.getOrDefault("userIp")
  valid_581001 = validateParameter(valid_581001, JString, required = false,
                                 default = nil)
  if valid_581001 != nil:
    section.add "userIp", valid_581001
  var valid_581002 = query.getOrDefault("quotaUser")
  valid_581002 = validateParameter(valid_581002, JString, required = false,
                                 default = nil)
  if valid_581002 != nil:
    section.add "quotaUser", valid_581002
  var valid_581003 = query.getOrDefault("fields")
  valid_581003 = validateParameter(valid_581003, JString, required = false,
                                 default = nil)
  if valid_581003 != nil:
    section.add "fields", valid_581003
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581004: Call_DirectoryRolesGet_580992; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a role.
  ## 
  let valid = call_581004.validator(path, query, header, formData, body)
  let scheme = call_581004.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581004.url(scheme.get, call_581004.host, call_581004.base,
                         call_581004.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581004, url, valid)

proc call*(call_581005: Call_DirectoryRolesGet_580992; customer: string;
          roleId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryRolesGet
  ## Retrieves a role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   roleId: string (required)
  ##         : Immutable ID of the role.
  var path_581006 = newJObject()
  var query_581007 = newJObject()
  add(query_581007, "key", newJString(key))
  add(query_581007, "prettyPrint", newJBool(prettyPrint))
  add(query_581007, "oauth_token", newJString(oauthToken))
  add(path_581006, "customer", newJString(customer))
  add(query_581007, "alt", newJString(alt))
  add(query_581007, "userIp", newJString(userIp))
  add(query_581007, "quotaUser", newJString(quotaUser))
  add(query_581007, "fields", newJString(fields))
  add(path_581006, "roleId", newJString(roleId))
  result = call_581005.call(path_581006, query_581007, nil, nil, nil)

var directoryRolesGet* = Call_DirectoryRolesGet_580992(name: "directoryRolesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesGet_580993, base: "/admin/directory/v1",
    url: url_DirectoryRolesGet_580994, schemes: {Scheme.Https})
type
  Call_DirectoryRolesPatch_581042 = ref object of OpenApiRestCall_579389
proc url_DirectoryRolesPatch_581044(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRolesPatch_581043(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a role. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   roleId: JString (required)
  ##         : Immutable ID of the role.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_581045 = path.getOrDefault("customer")
  valid_581045 = validateParameter(valid_581045, JString, required = true,
                                 default = nil)
  if valid_581045 != nil:
    section.add "customer", valid_581045
  var valid_581046 = path.getOrDefault("roleId")
  valid_581046 = validateParameter(valid_581046, JString, required = true,
                                 default = nil)
  if valid_581046 != nil:
    section.add "roleId", valid_581046
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
  var valid_581047 = query.getOrDefault("key")
  valid_581047 = validateParameter(valid_581047, JString, required = false,
                                 default = nil)
  if valid_581047 != nil:
    section.add "key", valid_581047
  var valid_581048 = query.getOrDefault("prettyPrint")
  valid_581048 = validateParameter(valid_581048, JBool, required = false,
                                 default = newJBool(true))
  if valid_581048 != nil:
    section.add "prettyPrint", valid_581048
  var valid_581049 = query.getOrDefault("oauth_token")
  valid_581049 = validateParameter(valid_581049, JString, required = false,
                                 default = nil)
  if valid_581049 != nil:
    section.add "oauth_token", valid_581049
  var valid_581050 = query.getOrDefault("alt")
  valid_581050 = validateParameter(valid_581050, JString, required = false,
                                 default = newJString("json"))
  if valid_581050 != nil:
    section.add "alt", valid_581050
  var valid_581051 = query.getOrDefault("userIp")
  valid_581051 = validateParameter(valid_581051, JString, required = false,
                                 default = nil)
  if valid_581051 != nil:
    section.add "userIp", valid_581051
  var valid_581052 = query.getOrDefault("quotaUser")
  valid_581052 = validateParameter(valid_581052, JString, required = false,
                                 default = nil)
  if valid_581052 != nil:
    section.add "quotaUser", valid_581052
  var valid_581053 = query.getOrDefault("fields")
  valid_581053 = validateParameter(valid_581053, JString, required = false,
                                 default = nil)
  if valid_581053 != nil:
    section.add "fields", valid_581053
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

proc call*(call_581055: Call_DirectoryRolesPatch_581042; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role. This method supports patch semantics.
  ## 
  let valid = call_581055.validator(path, query, header, formData, body)
  let scheme = call_581055.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581055.url(scheme.get, call_581055.host, call_581055.base,
                         call_581055.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581055, url, valid)

proc call*(call_581056: Call_DirectoryRolesPatch_581042; customer: string;
          roleId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryRolesPatch
  ## Updates a role. This method supports patch semantics.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   roleId: string (required)
  ##         : Immutable ID of the role.
  var path_581057 = newJObject()
  var query_581058 = newJObject()
  var body_581059 = newJObject()
  add(query_581058, "key", newJString(key))
  add(query_581058, "prettyPrint", newJBool(prettyPrint))
  add(query_581058, "oauth_token", newJString(oauthToken))
  add(path_581057, "customer", newJString(customer))
  add(query_581058, "alt", newJString(alt))
  add(query_581058, "userIp", newJString(userIp))
  add(query_581058, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581059 = body
  add(query_581058, "fields", newJString(fields))
  add(path_581057, "roleId", newJString(roleId))
  result = call_581056.call(path_581057, query_581058, nil, nil, body_581059)

var directoryRolesPatch* = Call_DirectoryRolesPatch_581042(
    name: "directoryRolesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesPatch_581043, base: "/admin/directory/v1",
    url: url_DirectoryRolesPatch_581044, schemes: {Scheme.Https})
type
  Call_DirectoryRolesDelete_581026 = ref object of OpenApiRestCall_579389
proc url_DirectoryRolesDelete_581028(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customer" in path, "`customer` is a required path parameter"
  assert "roleId" in path, "`roleId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customer/"),
               (kind: VariableSegment, value: "customer"),
               (kind: ConstantSegment, value: "/roles/"),
               (kind: VariableSegment, value: "roleId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryRolesDelete_581027(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  ##   roleId: JString (required)
  ##         : Immutable ID of the role.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `customer` field"
  var valid_581029 = path.getOrDefault("customer")
  valid_581029 = validateParameter(valid_581029, JString, required = true,
                                 default = nil)
  if valid_581029 != nil:
    section.add "customer", valid_581029
  var valid_581030 = path.getOrDefault("roleId")
  valid_581030 = validateParameter(valid_581030, JString, required = true,
                                 default = nil)
  if valid_581030 != nil:
    section.add "roleId", valid_581030
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
  var valid_581031 = query.getOrDefault("key")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "key", valid_581031
  var valid_581032 = query.getOrDefault("prettyPrint")
  valid_581032 = validateParameter(valid_581032, JBool, required = false,
                                 default = newJBool(true))
  if valid_581032 != nil:
    section.add "prettyPrint", valid_581032
  var valid_581033 = query.getOrDefault("oauth_token")
  valid_581033 = validateParameter(valid_581033, JString, required = false,
                                 default = nil)
  if valid_581033 != nil:
    section.add "oauth_token", valid_581033
  var valid_581034 = query.getOrDefault("alt")
  valid_581034 = validateParameter(valid_581034, JString, required = false,
                                 default = newJString("json"))
  if valid_581034 != nil:
    section.add "alt", valid_581034
  var valid_581035 = query.getOrDefault("userIp")
  valid_581035 = validateParameter(valid_581035, JString, required = false,
                                 default = nil)
  if valid_581035 != nil:
    section.add "userIp", valid_581035
  var valid_581036 = query.getOrDefault("quotaUser")
  valid_581036 = validateParameter(valid_581036, JString, required = false,
                                 default = nil)
  if valid_581036 != nil:
    section.add "quotaUser", valid_581036
  var valid_581037 = query.getOrDefault("fields")
  valid_581037 = validateParameter(valid_581037, JString, required = false,
                                 default = nil)
  if valid_581037 != nil:
    section.add "fields", valid_581037
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581038: Call_DirectoryRolesDelete_581026; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role.
  ## 
  let valid = call_581038.validator(path, query, header, formData, body)
  let scheme = call_581038.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581038.url(scheme.get, call_581038.host, call_581038.base,
                         call_581038.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581038, url, valid)

proc call*(call_581039: Call_DirectoryRolesDelete_581026; customer: string;
          roleId: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryRolesDelete
  ## Deletes a role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   roleId: string (required)
  ##         : Immutable ID of the role.
  var path_581040 = newJObject()
  var query_581041 = newJObject()
  add(query_581041, "key", newJString(key))
  add(query_581041, "prettyPrint", newJBool(prettyPrint))
  add(query_581041, "oauth_token", newJString(oauthToken))
  add(path_581040, "customer", newJString(customer))
  add(query_581041, "alt", newJString(alt))
  add(query_581041, "userIp", newJString(userIp))
  add(query_581041, "quotaUser", newJString(quotaUser))
  add(query_581041, "fields", newJString(fields))
  add(path_581040, "roleId", newJString(roleId))
  result = call_581039.call(path_581040, query_581041, nil, nil, nil)

var directoryRolesDelete* = Call_DirectoryRolesDelete_581026(
    name: "directoryRolesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesDelete_581027, base: "/admin/directory/v1",
    url: url_DirectoryRolesDelete_581028, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersUpdate_581075 = ref object of OpenApiRestCall_579389
proc url_DirectoryCustomersUpdate_581077(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerKey" in path, "`customerKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryCustomersUpdate_581076(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerKey: JString (required)
  ##              : Id of the customer to be updated
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerKey` field"
  var valid_581078 = path.getOrDefault("customerKey")
  valid_581078 = validateParameter(valid_581078, JString, required = true,
                                 default = nil)
  if valid_581078 != nil:
    section.add "customerKey", valid_581078
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
  var valid_581079 = query.getOrDefault("key")
  valid_581079 = validateParameter(valid_581079, JString, required = false,
                                 default = nil)
  if valid_581079 != nil:
    section.add "key", valid_581079
  var valid_581080 = query.getOrDefault("prettyPrint")
  valid_581080 = validateParameter(valid_581080, JBool, required = false,
                                 default = newJBool(true))
  if valid_581080 != nil:
    section.add "prettyPrint", valid_581080
  var valid_581081 = query.getOrDefault("oauth_token")
  valid_581081 = validateParameter(valid_581081, JString, required = false,
                                 default = nil)
  if valid_581081 != nil:
    section.add "oauth_token", valid_581081
  var valid_581082 = query.getOrDefault("alt")
  valid_581082 = validateParameter(valid_581082, JString, required = false,
                                 default = newJString("json"))
  if valid_581082 != nil:
    section.add "alt", valid_581082
  var valid_581083 = query.getOrDefault("userIp")
  valid_581083 = validateParameter(valid_581083, JString, required = false,
                                 default = nil)
  if valid_581083 != nil:
    section.add "userIp", valid_581083
  var valid_581084 = query.getOrDefault("quotaUser")
  valid_581084 = validateParameter(valid_581084, JString, required = false,
                                 default = nil)
  if valid_581084 != nil:
    section.add "quotaUser", valid_581084
  var valid_581085 = query.getOrDefault("fields")
  valid_581085 = validateParameter(valid_581085, JString, required = false,
                                 default = nil)
  if valid_581085 != nil:
    section.add "fields", valid_581085
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

proc call*(call_581087: Call_DirectoryCustomersUpdate_581075; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer.
  ## 
  let valid = call_581087.validator(path, query, header, formData, body)
  let scheme = call_581087.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581087.url(scheme.get, call_581087.host, call_581087.base,
                         call_581087.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581087, url, valid)

proc call*(call_581088: Call_DirectoryCustomersUpdate_581075; customerKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryCustomersUpdate
  ## Updates a customer.
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
  ##   customerKey: string (required)
  ##              : Id of the customer to be updated
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581089 = newJObject()
  var query_581090 = newJObject()
  var body_581091 = newJObject()
  add(query_581090, "key", newJString(key))
  add(query_581090, "prettyPrint", newJBool(prettyPrint))
  add(query_581090, "oauth_token", newJString(oauthToken))
  add(query_581090, "alt", newJString(alt))
  add(query_581090, "userIp", newJString(userIp))
  add(query_581090, "quotaUser", newJString(quotaUser))
  add(path_581089, "customerKey", newJString(customerKey))
  if body != nil:
    body_581091 = body
  add(query_581090, "fields", newJString(fields))
  result = call_581088.call(path_581089, query_581090, nil, nil, body_581091)

var directoryCustomersUpdate* = Call_DirectoryCustomersUpdate_581075(
    name: "directoryCustomersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersUpdate_581076,
    base: "/admin/directory/v1", url: url_DirectoryCustomersUpdate_581077,
    schemes: {Scheme.Https})
type
  Call_DirectoryCustomersGet_581060 = ref object of OpenApiRestCall_579389
proc url_DirectoryCustomersGet_581062(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerKey" in path, "`customerKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryCustomersGet_581061(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerKey: JString (required)
  ##              : Id of the customer to be retrieved
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerKey` field"
  var valid_581063 = path.getOrDefault("customerKey")
  valid_581063 = validateParameter(valid_581063, JString, required = true,
                                 default = nil)
  if valid_581063 != nil:
    section.add "customerKey", valid_581063
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
  var valid_581064 = query.getOrDefault("key")
  valid_581064 = validateParameter(valid_581064, JString, required = false,
                                 default = nil)
  if valid_581064 != nil:
    section.add "key", valid_581064
  var valid_581065 = query.getOrDefault("prettyPrint")
  valid_581065 = validateParameter(valid_581065, JBool, required = false,
                                 default = newJBool(true))
  if valid_581065 != nil:
    section.add "prettyPrint", valid_581065
  var valid_581066 = query.getOrDefault("oauth_token")
  valid_581066 = validateParameter(valid_581066, JString, required = false,
                                 default = nil)
  if valid_581066 != nil:
    section.add "oauth_token", valid_581066
  var valid_581067 = query.getOrDefault("alt")
  valid_581067 = validateParameter(valid_581067, JString, required = false,
                                 default = newJString("json"))
  if valid_581067 != nil:
    section.add "alt", valid_581067
  var valid_581068 = query.getOrDefault("userIp")
  valid_581068 = validateParameter(valid_581068, JString, required = false,
                                 default = nil)
  if valid_581068 != nil:
    section.add "userIp", valid_581068
  var valid_581069 = query.getOrDefault("quotaUser")
  valid_581069 = validateParameter(valid_581069, JString, required = false,
                                 default = nil)
  if valid_581069 != nil:
    section.add "quotaUser", valid_581069
  var valid_581070 = query.getOrDefault("fields")
  valid_581070 = validateParameter(valid_581070, JString, required = false,
                                 default = nil)
  if valid_581070 != nil:
    section.add "fields", valid_581070
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581071: Call_DirectoryCustomersGet_581060; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a customer.
  ## 
  let valid = call_581071.validator(path, query, header, formData, body)
  let scheme = call_581071.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581071.url(scheme.get, call_581071.host, call_581071.base,
                         call_581071.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581071, url, valid)

proc call*(call_581072: Call_DirectoryCustomersGet_581060; customerKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryCustomersGet
  ## Retrieves a customer.
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
  ##   customerKey: string (required)
  ##              : Id of the customer to be retrieved
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581073 = newJObject()
  var query_581074 = newJObject()
  add(query_581074, "key", newJString(key))
  add(query_581074, "prettyPrint", newJBool(prettyPrint))
  add(query_581074, "oauth_token", newJString(oauthToken))
  add(query_581074, "alt", newJString(alt))
  add(query_581074, "userIp", newJString(userIp))
  add(query_581074, "quotaUser", newJString(quotaUser))
  add(path_581073, "customerKey", newJString(customerKey))
  add(query_581074, "fields", newJString(fields))
  result = call_581072.call(path_581073, query_581074, nil, nil, nil)

var directoryCustomersGet* = Call_DirectoryCustomersGet_581060(
    name: "directoryCustomersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersGet_581061, base: "/admin/directory/v1",
    url: url_DirectoryCustomersGet_581062, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersPatch_581092 = ref object of OpenApiRestCall_579389
proc url_DirectoryCustomersPatch_581094(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "customerKey" in path, "`customerKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/customers/"),
               (kind: VariableSegment, value: "customerKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryCustomersPatch_581093(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a customer. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerKey: JString (required)
  ##              : Id of the customer to be updated
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerKey` field"
  var valid_581095 = path.getOrDefault("customerKey")
  valid_581095 = validateParameter(valid_581095, JString, required = true,
                                 default = nil)
  if valid_581095 != nil:
    section.add "customerKey", valid_581095
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
  var valid_581096 = query.getOrDefault("key")
  valid_581096 = validateParameter(valid_581096, JString, required = false,
                                 default = nil)
  if valid_581096 != nil:
    section.add "key", valid_581096
  var valid_581097 = query.getOrDefault("prettyPrint")
  valid_581097 = validateParameter(valid_581097, JBool, required = false,
                                 default = newJBool(true))
  if valid_581097 != nil:
    section.add "prettyPrint", valid_581097
  var valid_581098 = query.getOrDefault("oauth_token")
  valid_581098 = validateParameter(valid_581098, JString, required = false,
                                 default = nil)
  if valid_581098 != nil:
    section.add "oauth_token", valid_581098
  var valid_581099 = query.getOrDefault("alt")
  valid_581099 = validateParameter(valid_581099, JString, required = false,
                                 default = newJString("json"))
  if valid_581099 != nil:
    section.add "alt", valid_581099
  var valid_581100 = query.getOrDefault("userIp")
  valid_581100 = validateParameter(valid_581100, JString, required = false,
                                 default = nil)
  if valid_581100 != nil:
    section.add "userIp", valid_581100
  var valid_581101 = query.getOrDefault("quotaUser")
  valid_581101 = validateParameter(valid_581101, JString, required = false,
                                 default = nil)
  if valid_581101 != nil:
    section.add "quotaUser", valid_581101
  var valid_581102 = query.getOrDefault("fields")
  valid_581102 = validateParameter(valid_581102, JString, required = false,
                                 default = nil)
  if valid_581102 != nil:
    section.add "fields", valid_581102
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

proc call*(call_581104: Call_DirectoryCustomersPatch_581092; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer. This method supports patch semantics.
  ## 
  let valid = call_581104.validator(path, query, header, formData, body)
  let scheme = call_581104.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581104.url(scheme.get, call_581104.host, call_581104.base,
                         call_581104.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581104, url, valid)

proc call*(call_581105: Call_DirectoryCustomersPatch_581092; customerKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryCustomersPatch
  ## Updates a customer. This method supports patch semantics.
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
  ##   customerKey: string (required)
  ##              : Id of the customer to be updated
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581106 = newJObject()
  var query_581107 = newJObject()
  var body_581108 = newJObject()
  add(query_581107, "key", newJString(key))
  add(query_581107, "prettyPrint", newJBool(prettyPrint))
  add(query_581107, "oauth_token", newJString(oauthToken))
  add(query_581107, "alt", newJString(alt))
  add(query_581107, "userIp", newJString(userIp))
  add(query_581107, "quotaUser", newJString(quotaUser))
  add(path_581106, "customerKey", newJString(customerKey))
  if body != nil:
    body_581108 = body
  add(query_581107, "fields", newJString(fields))
  result = call_581105.call(path_581106, query_581107, nil, nil, body_581108)

var directoryCustomersPatch* = Call_DirectoryCustomersPatch_581092(
    name: "directoryCustomersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersPatch_581093,
    base: "/admin/directory/v1", url: url_DirectoryCustomersPatch_581094,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsInsert_581130 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsInsert_581132(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DirectoryGroupsInsert_581131(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create Group
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
  var valid_581133 = query.getOrDefault("key")
  valid_581133 = validateParameter(valid_581133, JString, required = false,
                                 default = nil)
  if valid_581133 != nil:
    section.add "key", valid_581133
  var valid_581134 = query.getOrDefault("prettyPrint")
  valid_581134 = validateParameter(valid_581134, JBool, required = false,
                                 default = newJBool(true))
  if valid_581134 != nil:
    section.add "prettyPrint", valid_581134
  var valid_581135 = query.getOrDefault("oauth_token")
  valid_581135 = validateParameter(valid_581135, JString, required = false,
                                 default = nil)
  if valid_581135 != nil:
    section.add "oauth_token", valid_581135
  var valid_581136 = query.getOrDefault("alt")
  valid_581136 = validateParameter(valid_581136, JString, required = false,
                                 default = newJString("json"))
  if valid_581136 != nil:
    section.add "alt", valid_581136
  var valid_581137 = query.getOrDefault("userIp")
  valid_581137 = validateParameter(valid_581137, JString, required = false,
                                 default = nil)
  if valid_581137 != nil:
    section.add "userIp", valid_581137
  var valid_581138 = query.getOrDefault("quotaUser")
  valid_581138 = validateParameter(valid_581138, JString, required = false,
                                 default = nil)
  if valid_581138 != nil:
    section.add "quotaUser", valid_581138
  var valid_581139 = query.getOrDefault("fields")
  valid_581139 = validateParameter(valid_581139, JString, required = false,
                                 default = nil)
  if valid_581139 != nil:
    section.add "fields", valid_581139
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

proc call*(call_581141: Call_DirectoryGroupsInsert_581130; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Group
  ## 
  let valid = call_581141.validator(path, query, header, formData, body)
  let scheme = call_581141.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581141.url(scheme.get, call_581141.host, call_581141.base,
                         call_581141.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581141, url, valid)

proc call*(call_581142: Call_DirectoryGroupsInsert_581130; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryGroupsInsert
  ## Create Group
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
  var query_581143 = newJObject()
  var body_581144 = newJObject()
  add(query_581143, "key", newJString(key))
  add(query_581143, "prettyPrint", newJBool(prettyPrint))
  add(query_581143, "oauth_token", newJString(oauthToken))
  add(query_581143, "alt", newJString(alt))
  add(query_581143, "userIp", newJString(userIp))
  add(query_581143, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581144 = body
  add(query_581143, "fields", newJString(fields))
  result = call_581142.call(nil, query_581143, nil, nil, body_581144)

var directoryGroupsInsert* = Call_DirectoryGroupsInsert_581130(
    name: "directoryGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsInsert_581131, base: "/admin/directory/v1",
    url: url_DirectoryGroupsInsert_581132, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsList_581109 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsList_581111(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DirectoryGroupsList_581110(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
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
  ##   domain: JString
  ##         : Name of the domain. Fill this field to get groups from only this domain. To return all groups in a multi-domain fill customer field instead.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userKey: JString
  ##          : Email or immutable ID of the user if only those groups are to be listed, the given user is a member of. If it's an ID, it should match with the ID of the user object.
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   query: JString
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-groups
  ##   customer: JString
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all groups for a customer, fill this field instead of domain.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Max allowed value is 200.
  section = newJObject()
  var valid_581112 = query.getOrDefault("key")
  valid_581112 = validateParameter(valid_581112, JString, required = false,
                                 default = nil)
  if valid_581112 != nil:
    section.add "key", valid_581112
  var valid_581113 = query.getOrDefault("prettyPrint")
  valid_581113 = validateParameter(valid_581113, JBool, required = false,
                                 default = newJBool(true))
  if valid_581113 != nil:
    section.add "prettyPrint", valid_581113
  var valid_581114 = query.getOrDefault("oauth_token")
  valid_581114 = validateParameter(valid_581114, JString, required = false,
                                 default = nil)
  if valid_581114 != nil:
    section.add "oauth_token", valid_581114
  var valid_581115 = query.getOrDefault("domain")
  valid_581115 = validateParameter(valid_581115, JString, required = false,
                                 default = nil)
  if valid_581115 != nil:
    section.add "domain", valid_581115
  var valid_581116 = query.getOrDefault("alt")
  valid_581116 = validateParameter(valid_581116, JString, required = false,
                                 default = newJString("json"))
  if valid_581116 != nil:
    section.add "alt", valid_581116
  var valid_581117 = query.getOrDefault("userIp")
  valid_581117 = validateParameter(valid_581117, JString, required = false,
                                 default = nil)
  if valid_581117 != nil:
    section.add "userIp", valid_581117
  var valid_581118 = query.getOrDefault("quotaUser")
  valid_581118 = validateParameter(valid_581118, JString, required = false,
                                 default = nil)
  if valid_581118 != nil:
    section.add "quotaUser", valid_581118
  var valid_581119 = query.getOrDefault("userKey")
  valid_581119 = validateParameter(valid_581119, JString, required = false,
                                 default = nil)
  if valid_581119 != nil:
    section.add "userKey", valid_581119
  var valid_581120 = query.getOrDefault("orderBy")
  valid_581120 = validateParameter(valid_581120, JString, required = false,
                                 default = newJString("email"))
  if valid_581120 != nil:
    section.add "orderBy", valid_581120
  var valid_581121 = query.getOrDefault("pageToken")
  valid_581121 = validateParameter(valid_581121, JString, required = false,
                                 default = nil)
  if valid_581121 != nil:
    section.add "pageToken", valid_581121
  var valid_581122 = query.getOrDefault("sortOrder")
  valid_581122 = validateParameter(valid_581122, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_581122 != nil:
    section.add "sortOrder", valid_581122
  var valid_581123 = query.getOrDefault("query")
  valid_581123 = validateParameter(valid_581123, JString, required = false,
                                 default = nil)
  if valid_581123 != nil:
    section.add "query", valid_581123
  var valid_581124 = query.getOrDefault("customer")
  valid_581124 = validateParameter(valid_581124, JString, required = false,
                                 default = nil)
  if valid_581124 != nil:
    section.add "customer", valid_581124
  var valid_581125 = query.getOrDefault("fields")
  valid_581125 = validateParameter(valid_581125, JString, required = false,
                                 default = nil)
  if valid_581125 != nil:
    section.add "fields", valid_581125
  var valid_581126 = query.getOrDefault("maxResults")
  valid_581126 = validateParameter(valid_581126, JInt, required = false,
                                 default = newJInt(200))
  if valid_581126 != nil:
    section.add "maxResults", valid_581126
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581127: Call_DirectoryGroupsList_581109; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
  ## 
  let valid = call_581127.validator(path, query, header, formData, body)
  let scheme = call_581127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581127.url(scheme.get, call_581127.host, call_581127.base,
                         call_581127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581127, url, valid)

proc call*(call_581128: Call_DirectoryGroupsList_581109; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; domain: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          userKey: string = ""; orderBy: string = "email"; pageToken: string = "";
          sortOrder: string = "ASCENDING"; query: string = ""; customer: string = "";
          fields: string = ""; maxResults: int = 200): Recallable =
  ## directoryGroupsList
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   domain: string
  ##         : Name of the domain. Fill this field to get groups from only this domain. To return all groups in a multi-domain fill customer field instead.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   userKey: string
  ##          : Email or immutable ID of the user if only those groups are to be listed, the given user is a member of. If it's an ID, it should match with the ID of the user object.
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   query: string
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-groups
  ##   customer: string
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all groups for a customer, fill this field instead of domain.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return. Max allowed value is 200.
  var query_581129 = newJObject()
  add(query_581129, "key", newJString(key))
  add(query_581129, "prettyPrint", newJBool(prettyPrint))
  add(query_581129, "oauth_token", newJString(oauthToken))
  add(query_581129, "domain", newJString(domain))
  add(query_581129, "alt", newJString(alt))
  add(query_581129, "userIp", newJString(userIp))
  add(query_581129, "quotaUser", newJString(quotaUser))
  add(query_581129, "userKey", newJString(userKey))
  add(query_581129, "orderBy", newJString(orderBy))
  add(query_581129, "pageToken", newJString(pageToken))
  add(query_581129, "sortOrder", newJString(sortOrder))
  add(query_581129, "query", newJString(query))
  add(query_581129, "customer", newJString(customer))
  add(query_581129, "fields", newJString(fields))
  add(query_581129, "maxResults", newJInt(maxResults))
  result = call_581128.call(nil, query_581129, nil, nil, nil)

var directoryGroupsList* = Call_DirectoryGroupsList_581109(
    name: "directoryGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsList_581110, base: "/admin/directory/v1",
    url: url_DirectoryGroupsList_581111, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsUpdate_581160 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsUpdate_581162(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryGroupsUpdate_581161(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581163 = path.getOrDefault("groupKey")
  valid_581163 = validateParameter(valid_581163, JString, required = true,
                                 default = nil)
  if valid_581163 != nil:
    section.add "groupKey", valid_581163
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
  var valid_581164 = query.getOrDefault("key")
  valid_581164 = validateParameter(valid_581164, JString, required = false,
                                 default = nil)
  if valid_581164 != nil:
    section.add "key", valid_581164
  var valid_581165 = query.getOrDefault("prettyPrint")
  valid_581165 = validateParameter(valid_581165, JBool, required = false,
                                 default = newJBool(true))
  if valid_581165 != nil:
    section.add "prettyPrint", valid_581165
  var valid_581166 = query.getOrDefault("oauth_token")
  valid_581166 = validateParameter(valid_581166, JString, required = false,
                                 default = nil)
  if valid_581166 != nil:
    section.add "oauth_token", valid_581166
  var valid_581167 = query.getOrDefault("alt")
  valid_581167 = validateParameter(valid_581167, JString, required = false,
                                 default = newJString("json"))
  if valid_581167 != nil:
    section.add "alt", valid_581167
  var valid_581168 = query.getOrDefault("userIp")
  valid_581168 = validateParameter(valid_581168, JString, required = false,
                                 default = nil)
  if valid_581168 != nil:
    section.add "userIp", valid_581168
  var valid_581169 = query.getOrDefault("quotaUser")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = nil)
  if valid_581169 != nil:
    section.add "quotaUser", valid_581169
  var valid_581170 = query.getOrDefault("fields")
  valid_581170 = validateParameter(valid_581170, JString, required = false,
                                 default = nil)
  if valid_581170 != nil:
    section.add "fields", valid_581170
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

proc call*(call_581172: Call_DirectoryGroupsUpdate_581160; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group
  ## 
  let valid = call_581172.validator(path, query, header, formData, body)
  let scheme = call_581172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581172.url(scheme.get, call_581172.host, call_581172.base,
                         call_581172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581172, url, valid)

proc call*(call_581173: Call_DirectoryGroupsUpdate_581160; groupKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryGroupsUpdate
  ## Update Group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581174 = newJObject()
  var query_581175 = newJObject()
  var body_581176 = newJObject()
  add(query_581175, "key", newJString(key))
  add(query_581175, "prettyPrint", newJBool(prettyPrint))
  add(query_581175, "oauth_token", newJString(oauthToken))
  add(query_581175, "alt", newJString(alt))
  add(query_581175, "userIp", newJString(userIp))
  add(query_581175, "quotaUser", newJString(quotaUser))
  add(path_581174, "groupKey", newJString(groupKey))
  if body != nil:
    body_581176 = body
  add(query_581175, "fields", newJString(fields))
  result = call_581173.call(path_581174, query_581175, nil, nil, body_581176)

var directoryGroupsUpdate* = Call_DirectoryGroupsUpdate_581160(
    name: "directoryGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsUpdate_581161, base: "/admin/directory/v1",
    url: url_DirectoryGroupsUpdate_581162, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsGet_581145 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsGet_581147(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryGroupsGet_581146(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieve Group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581148 = path.getOrDefault("groupKey")
  valid_581148 = validateParameter(valid_581148, JString, required = true,
                                 default = nil)
  if valid_581148 != nil:
    section.add "groupKey", valid_581148
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
  var valid_581149 = query.getOrDefault("key")
  valid_581149 = validateParameter(valid_581149, JString, required = false,
                                 default = nil)
  if valid_581149 != nil:
    section.add "key", valid_581149
  var valid_581150 = query.getOrDefault("prettyPrint")
  valid_581150 = validateParameter(valid_581150, JBool, required = false,
                                 default = newJBool(true))
  if valid_581150 != nil:
    section.add "prettyPrint", valid_581150
  var valid_581151 = query.getOrDefault("oauth_token")
  valid_581151 = validateParameter(valid_581151, JString, required = false,
                                 default = nil)
  if valid_581151 != nil:
    section.add "oauth_token", valid_581151
  var valid_581152 = query.getOrDefault("alt")
  valid_581152 = validateParameter(valid_581152, JString, required = false,
                                 default = newJString("json"))
  if valid_581152 != nil:
    section.add "alt", valid_581152
  var valid_581153 = query.getOrDefault("userIp")
  valid_581153 = validateParameter(valid_581153, JString, required = false,
                                 default = nil)
  if valid_581153 != nil:
    section.add "userIp", valid_581153
  var valid_581154 = query.getOrDefault("quotaUser")
  valid_581154 = validateParameter(valid_581154, JString, required = false,
                                 default = nil)
  if valid_581154 != nil:
    section.add "quotaUser", valid_581154
  var valid_581155 = query.getOrDefault("fields")
  valid_581155 = validateParameter(valid_581155, JString, required = false,
                                 default = nil)
  if valid_581155 != nil:
    section.add "fields", valid_581155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581156: Call_DirectoryGroupsGet_581145; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group
  ## 
  let valid = call_581156.validator(path, query, header, formData, body)
  let scheme = call_581156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581156.url(scheme.get, call_581156.host, call_581156.base,
                         call_581156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581156, url, valid)

proc call*(call_581157: Call_DirectoryGroupsGet_581145; groupKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryGroupsGet
  ## Retrieve Group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581158 = newJObject()
  var query_581159 = newJObject()
  add(query_581159, "key", newJString(key))
  add(query_581159, "prettyPrint", newJBool(prettyPrint))
  add(query_581159, "oauth_token", newJString(oauthToken))
  add(query_581159, "alt", newJString(alt))
  add(query_581159, "userIp", newJString(userIp))
  add(query_581159, "quotaUser", newJString(quotaUser))
  add(path_581158, "groupKey", newJString(groupKey))
  add(query_581159, "fields", newJString(fields))
  result = call_581157.call(path_581158, query_581159, nil, nil, nil)

var directoryGroupsGet* = Call_DirectoryGroupsGet_581145(
    name: "directoryGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsGet_581146, base: "/admin/directory/v1",
    url: url_DirectoryGroupsGet_581147, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsPatch_581192 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsPatch_581194(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryGroupsPatch_581193(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Group. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581195 = path.getOrDefault("groupKey")
  valid_581195 = validateParameter(valid_581195, JString, required = true,
                                 default = nil)
  if valid_581195 != nil:
    section.add "groupKey", valid_581195
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
  var valid_581196 = query.getOrDefault("key")
  valid_581196 = validateParameter(valid_581196, JString, required = false,
                                 default = nil)
  if valid_581196 != nil:
    section.add "key", valid_581196
  var valid_581197 = query.getOrDefault("prettyPrint")
  valid_581197 = validateParameter(valid_581197, JBool, required = false,
                                 default = newJBool(true))
  if valid_581197 != nil:
    section.add "prettyPrint", valid_581197
  var valid_581198 = query.getOrDefault("oauth_token")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "oauth_token", valid_581198
  var valid_581199 = query.getOrDefault("alt")
  valid_581199 = validateParameter(valid_581199, JString, required = false,
                                 default = newJString("json"))
  if valid_581199 != nil:
    section.add "alt", valid_581199
  var valid_581200 = query.getOrDefault("userIp")
  valid_581200 = validateParameter(valid_581200, JString, required = false,
                                 default = nil)
  if valid_581200 != nil:
    section.add "userIp", valid_581200
  var valid_581201 = query.getOrDefault("quotaUser")
  valid_581201 = validateParameter(valid_581201, JString, required = false,
                                 default = nil)
  if valid_581201 != nil:
    section.add "quotaUser", valid_581201
  var valid_581202 = query.getOrDefault("fields")
  valid_581202 = validateParameter(valid_581202, JString, required = false,
                                 default = nil)
  if valid_581202 != nil:
    section.add "fields", valid_581202
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

proc call*(call_581204: Call_DirectoryGroupsPatch_581192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group. This method supports patch semantics.
  ## 
  let valid = call_581204.validator(path, query, header, formData, body)
  let scheme = call_581204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581204.url(scheme.get, call_581204.host, call_581204.base,
                         call_581204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581204, url, valid)

proc call*(call_581205: Call_DirectoryGroupsPatch_581192; groupKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryGroupsPatch
  ## Update Group. This method supports patch semantics.
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581206 = newJObject()
  var query_581207 = newJObject()
  var body_581208 = newJObject()
  add(query_581207, "key", newJString(key))
  add(query_581207, "prettyPrint", newJBool(prettyPrint))
  add(query_581207, "oauth_token", newJString(oauthToken))
  add(query_581207, "alt", newJString(alt))
  add(query_581207, "userIp", newJString(userIp))
  add(query_581207, "quotaUser", newJString(quotaUser))
  add(path_581206, "groupKey", newJString(groupKey))
  if body != nil:
    body_581208 = body
  add(query_581207, "fields", newJString(fields))
  result = call_581205.call(path_581206, query_581207, nil, nil, body_581208)

var directoryGroupsPatch* = Call_DirectoryGroupsPatch_581192(
    name: "directoryGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsPatch_581193, base: "/admin/directory/v1",
    url: url_DirectoryGroupsPatch_581194, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsDelete_581177 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsDelete_581179(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryGroupsDelete_581178(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete Group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581180 = path.getOrDefault("groupKey")
  valid_581180 = validateParameter(valid_581180, JString, required = true,
                                 default = nil)
  if valid_581180 != nil:
    section.add "groupKey", valid_581180
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
  var valid_581181 = query.getOrDefault("key")
  valid_581181 = validateParameter(valid_581181, JString, required = false,
                                 default = nil)
  if valid_581181 != nil:
    section.add "key", valid_581181
  var valid_581182 = query.getOrDefault("prettyPrint")
  valid_581182 = validateParameter(valid_581182, JBool, required = false,
                                 default = newJBool(true))
  if valid_581182 != nil:
    section.add "prettyPrint", valid_581182
  var valid_581183 = query.getOrDefault("oauth_token")
  valid_581183 = validateParameter(valid_581183, JString, required = false,
                                 default = nil)
  if valid_581183 != nil:
    section.add "oauth_token", valid_581183
  var valid_581184 = query.getOrDefault("alt")
  valid_581184 = validateParameter(valid_581184, JString, required = false,
                                 default = newJString("json"))
  if valid_581184 != nil:
    section.add "alt", valid_581184
  var valid_581185 = query.getOrDefault("userIp")
  valid_581185 = validateParameter(valid_581185, JString, required = false,
                                 default = nil)
  if valid_581185 != nil:
    section.add "userIp", valid_581185
  var valid_581186 = query.getOrDefault("quotaUser")
  valid_581186 = validateParameter(valid_581186, JString, required = false,
                                 default = nil)
  if valid_581186 != nil:
    section.add "quotaUser", valid_581186
  var valid_581187 = query.getOrDefault("fields")
  valid_581187 = validateParameter(valid_581187, JString, required = false,
                                 default = nil)
  if valid_581187 != nil:
    section.add "fields", valid_581187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581188: Call_DirectoryGroupsDelete_581177; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group
  ## 
  let valid = call_581188.validator(path, query, header, formData, body)
  let scheme = call_581188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581188.url(scheme.get, call_581188.host, call_581188.base,
                         call_581188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581188, url, valid)

proc call*(call_581189: Call_DirectoryGroupsDelete_581177; groupKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryGroupsDelete
  ## Delete Group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581190 = newJObject()
  var query_581191 = newJObject()
  add(query_581191, "key", newJString(key))
  add(query_581191, "prettyPrint", newJBool(prettyPrint))
  add(query_581191, "oauth_token", newJString(oauthToken))
  add(query_581191, "alt", newJString(alt))
  add(query_581191, "userIp", newJString(userIp))
  add(query_581191, "quotaUser", newJString(quotaUser))
  add(path_581190, "groupKey", newJString(groupKey))
  add(query_581191, "fields", newJString(fields))
  result = call_581189.call(path_581190, query_581191, nil, nil, nil)

var directoryGroupsDelete* = Call_DirectoryGroupsDelete_581177(
    name: "directoryGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsDelete_581178, base: "/admin/directory/v1",
    url: url_DirectoryGroupsDelete_581179, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesInsert_581224 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsAliasesInsert_581226(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/aliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryGroupsAliasesInsert_581225(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a alias for the group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581227 = path.getOrDefault("groupKey")
  valid_581227 = validateParameter(valid_581227, JString, required = true,
                                 default = nil)
  if valid_581227 != nil:
    section.add "groupKey", valid_581227
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
  var valid_581228 = query.getOrDefault("key")
  valid_581228 = validateParameter(valid_581228, JString, required = false,
                                 default = nil)
  if valid_581228 != nil:
    section.add "key", valid_581228
  var valid_581229 = query.getOrDefault("prettyPrint")
  valid_581229 = validateParameter(valid_581229, JBool, required = false,
                                 default = newJBool(true))
  if valid_581229 != nil:
    section.add "prettyPrint", valid_581229
  var valid_581230 = query.getOrDefault("oauth_token")
  valid_581230 = validateParameter(valid_581230, JString, required = false,
                                 default = nil)
  if valid_581230 != nil:
    section.add "oauth_token", valid_581230
  var valid_581231 = query.getOrDefault("alt")
  valid_581231 = validateParameter(valid_581231, JString, required = false,
                                 default = newJString("json"))
  if valid_581231 != nil:
    section.add "alt", valid_581231
  var valid_581232 = query.getOrDefault("userIp")
  valid_581232 = validateParameter(valid_581232, JString, required = false,
                                 default = nil)
  if valid_581232 != nil:
    section.add "userIp", valid_581232
  var valid_581233 = query.getOrDefault("quotaUser")
  valid_581233 = validateParameter(valid_581233, JString, required = false,
                                 default = nil)
  if valid_581233 != nil:
    section.add "quotaUser", valid_581233
  var valid_581234 = query.getOrDefault("fields")
  valid_581234 = validateParameter(valid_581234, JString, required = false,
                                 default = nil)
  if valid_581234 != nil:
    section.add "fields", valid_581234
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

proc call*(call_581236: Call_DirectoryGroupsAliasesInsert_581224; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the group
  ## 
  let valid = call_581236.validator(path, query, header, formData, body)
  let scheme = call_581236.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581236.url(scheme.get, call_581236.host, call_581236.base,
                         call_581236.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581236, url, valid)

proc call*(call_581237: Call_DirectoryGroupsAliasesInsert_581224; groupKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryGroupsAliasesInsert
  ## Add a alias for the group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581238 = newJObject()
  var query_581239 = newJObject()
  var body_581240 = newJObject()
  add(query_581239, "key", newJString(key))
  add(query_581239, "prettyPrint", newJBool(prettyPrint))
  add(query_581239, "oauth_token", newJString(oauthToken))
  add(query_581239, "alt", newJString(alt))
  add(query_581239, "userIp", newJString(userIp))
  add(query_581239, "quotaUser", newJString(quotaUser))
  add(path_581238, "groupKey", newJString(groupKey))
  if body != nil:
    body_581240 = body
  add(query_581239, "fields", newJString(fields))
  result = call_581237.call(path_581238, query_581239, nil, nil, body_581240)

var directoryGroupsAliasesInsert* = Call_DirectoryGroupsAliasesInsert_581224(
    name: "directoryGroupsAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesInsert_581225,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesInsert_581226,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesList_581209 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsAliasesList_581211(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/aliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryGroupsAliasesList_581210(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all aliases for a group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581212 = path.getOrDefault("groupKey")
  valid_581212 = validateParameter(valid_581212, JString, required = true,
                                 default = nil)
  if valid_581212 != nil:
    section.add "groupKey", valid_581212
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
  var valid_581213 = query.getOrDefault("key")
  valid_581213 = validateParameter(valid_581213, JString, required = false,
                                 default = nil)
  if valid_581213 != nil:
    section.add "key", valid_581213
  var valid_581214 = query.getOrDefault("prettyPrint")
  valid_581214 = validateParameter(valid_581214, JBool, required = false,
                                 default = newJBool(true))
  if valid_581214 != nil:
    section.add "prettyPrint", valid_581214
  var valid_581215 = query.getOrDefault("oauth_token")
  valid_581215 = validateParameter(valid_581215, JString, required = false,
                                 default = nil)
  if valid_581215 != nil:
    section.add "oauth_token", valid_581215
  var valid_581216 = query.getOrDefault("alt")
  valid_581216 = validateParameter(valid_581216, JString, required = false,
                                 default = newJString("json"))
  if valid_581216 != nil:
    section.add "alt", valid_581216
  var valid_581217 = query.getOrDefault("userIp")
  valid_581217 = validateParameter(valid_581217, JString, required = false,
                                 default = nil)
  if valid_581217 != nil:
    section.add "userIp", valid_581217
  var valid_581218 = query.getOrDefault("quotaUser")
  valid_581218 = validateParameter(valid_581218, JString, required = false,
                                 default = nil)
  if valid_581218 != nil:
    section.add "quotaUser", valid_581218
  var valid_581219 = query.getOrDefault("fields")
  valid_581219 = validateParameter(valid_581219, JString, required = false,
                                 default = nil)
  if valid_581219 != nil:
    section.add "fields", valid_581219
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581220: Call_DirectoryGroupsAliasesList_581209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a group
  ## 
  let valid = call_581220.validator(path, query, header, formData, body)
  let scheme = call_581220.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581220.url(scheme.get, call_581220.host, call_581220.base,
                         call_581220.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581220, url, valid)

proc call*(call_581221: Call_DirectoryGroupsAliasesList_581209; groupKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryGroupsAliasesList
  ## List all aliases for a group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581222 = newJObject()
  var query_581223 = newJObject()
  add(query_581223, "key", newJString(key))
  add(query_581223, "prettyPrint", newJBool(prettyPrint))
  add(query_581223, "oauth_token", newJString(oauthToken))
  add(query_581223, "alt", newJString(alt))
  add(query_581223, "userIp", newJString(userIp))
  add(query_581223, "quotaUser", newJString(quotaUser))
  add(path_581222, "groupKey", newJString(groupKey))
  add(query_581223, "fields", newJString(fields))
  result = call_581221.call(path_581222, query_581223, nil, nil, nil)

var directoryGroupsAliasesList* = Call_DirectoryGroupsAliasesList_581209(
    name: "directoryGroupsAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesList_581210,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesList_581211,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesDelete_581241 = ref object of OpenApiRestCall_579389
proc url_DirectoryGroupsAliasesDelete_581243(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/aliases/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryGroupsAliasesDelete_581242(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove a alias for the group
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  ##   alias: JString (required)
  ##        : The alias to be removed
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581244 = path.getOrDefault("groupKey")
  valid_581244 = validateParameter(valid_581244, JString, required = true,
                                 default = nil)
  if valid_581244 != nil:
    section.add "groupKey", valid_581244
  var valid_581245 = path.getOrDefault("alias")
  valid_581245 = validateParameter(valid_581245, JString, required = true,
                                 default = nil)
  if valid_581245 != nil:
    section.add "alias", valid_581245
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
  var valid_581246 = query.getOrDefault("key")
  valid_581246 = validateParameter(valid_581246, JString, required = false,
                                 default = nil)
  if valid_581246 != nil:
    section.add "key", valid_581246
  var valid_581247 = query.getOrDefault("prettyPrint")
  valid_581247 = validateParameter(valid_581247, JBool, required = false,
                                 default = newJBool(true))
  if valid_581247 != nil:
    section.add "prettyPrint", valid_581247
  var valid_581248 = query.getOrDefault("oauth_token")
  valid_581248 = validateParameter(valid_581248, JString, required = false,
                                 default = nil)
  if valid_581248 != nil:
    section.add "oauth_token", valid_581248
  var valid_581249 = query.getOrDefault("alt")
  valid_581249 = validateParameter(valid_581249, JString, required = false,
                                 default = newJString("json"))
  if valid_581249 != nil:
    section.add "alt", valid_581249
  var valid_581250 = query.getOrDefault("userIp")
  valid_581250 = validateParameter(valid_581250, JString, required = false,
                                 default = nil)
  if valid_581250 != nil:
    section.add "userIp", valid_581250
  var valid_581251 = query.getOrDefault("quotaUser")
  valid_581251 = validateParameter(valid_581251, JString, required = false,
                                 default = nil)
  if valid_581251 != nil:
    section.add "quotaUser", valid_581251
  var valid_581252 = query.getOrDefault("fields")
  valid_581252 = validateParameter(valid_581252, JString, required = false,
                                 default = nil)
  if valid_581252 != nil:
    section.add "fields", valid_581252
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581253: Call_DirectoryGroupsAliasesDelete_581241; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the group
  ## 
  let valid = call_581253.validator(path, query, header, formData, body)
  let scheme = call_581253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581253.url(scheme.get, call_581253.host, call_581253.base,
                         call_581253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581253, url, valid)

proc call*(call_581254: Call_DirectoryGroupsAliasesDelete_581241; groupKey: string;
          alias: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryGroupsAliasesDelete
  ## Remove a alias for the group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   alias: string (required)
  ##        : The alias to be removed
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581255 = newJObject()
  var query_581256 = newJObject()
  add(query_581256, "key", newJString(key))
  add(query_581256, "prettyPrint", newJBool(prettyPrint))
  add(query_581256, "oauth_token", newJString(oauthToken))
  add(query_581256, "alt", newJString(alt))
  add(query_581256, "userIp", newJString(userIp))
  add(query_581256, "quotaUser", newJString(quotaUser))
  add(path_581255, "groupKey", newJString(groupKey))
  add(path_581255, "alias", newJString(alias))
  add(query_581256, "fields", newJString(fields))
  result = call_581254.call(path_581255, query_581256, nil, nil, nil)

var directoryGroupsAliasesDelete* = Call_DirectoryGroupsAliasesDelete_581241(
    name: "directoryGroupsAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases/{alias}",
    validator: validate_DirectoryGroupsAliasesDelete_581242,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesDelete_581243,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersHasMember_581257 = ref object of OpenApiRestCall_579389
proc url_DirectoryMembersHasMember_581259(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  assert "memberKey" in path, "`memberKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/hasMember/"),
               (kind: VariableSegment, value: "memberKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMembersHasMember_581258(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Identifies the group in the API request. The value can be the group's email address, group alias, or the unique group ID.
  ##   memberKey: JString (required)
  ##            : Identifies the user member in the API request. The value can be the user's primary email address, alias, or unique ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581260 = path.getOrDefault("groupKey")
  valid_581260 = validateParameter(valid_581260, JString, required = true,
                                 default = nil)
  if valid_581260 != nil:
    section.add "groupKey", valid_581260
  var valid_581261 = path.getOrDefault("memberKey")
  valid_581261 = validateParameter(valid_581261, JString, required = true,
                                 default = nil)
  if valid_581261 != nil:
    section.add "memberKey", valid_581261
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
  var valid_581262 = query.getOrDefault("key")
  valid_581262 = validateParameter(valid_581262, JString, required = false,
                                 default = nil)
  if valid_581262 != nil:
    section.add "key", valid_581262
  var valid_581263 = query.getOrDefault("prettyPrint")
  valid_581263 = validateParameter(valid_581263, JBool, required = false,
                                 default = newJBool(true))
  if valid_581263 != nil:
    section.add "prettyPrint", valid_581263
  var valid_581264 = query.getOrDefault("oauth_token")
  valid_581264 = validateParameter(valid_581264, JString, required = false,
                                 default = nil)
  if valid_581264 != nil:
    section.add "oauth_token", valid_581264
  var valid_581265 = query.getOrDefault("alt")
  valid_581265 = validateParameter(valid_581265, JString, required = false,
                                 default = newJString("json"))
  if valid_581265 != nil:
    section.add "alt", valid_581265
  var valid_581266 = query.getOrDefault("userIp")
  valid_581266 = validateParameter(valid_581266, JString, required = false,
                                 default = nil)
  if valid_581266 != nil:
    section.add "userIp", valid_581266
  var valid_581267 = query.getOrDefault("quotaUser")
  valid_581267 = validateParameter(valid_581267, JString, required = false,
                                 default = nil)
  if valid_581267 != nil:
    section.add "quotaUser", valid_581267
  var valid_581268 = query.getOrDefault("fields")
  valid_581268 = validateParameter(valid_581268, JString, required = false,
                                 default = nil)
  if valid_581268 != nil:
    section.add "fields", valid_581268
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581269: Call_DirectoryMembersHasMember_581257; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
  ## 
  let valid = call_581269.validator(path, query, header, formData, body)
  let scheme = call_581269.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581269.url(scheme.get, call_581269.host, call_581269.base,
                         call_581269.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581269, url, valid)

proc call*(call_581270: Call_DirectoryMembersHasMember_581257; groupKey: string;
          memberKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryMembersHasMember
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
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
  ##   groupKey: string (required)
  ##           : Identifies the group in the API request. The value can be the group's email address, group alias, or the unique group ID.
  ##   memberKey: string (required)
  ##            : Identifies the user member in the API request. The value can be the user's primary email address, alias, or unique ID.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581271 = newJObject()
  var query_581272 = newJObject()
  add(query_581272, "key", newJString(key))
  add(query_581272, "prettyPrint", newJBool(prettyPrint))
  add(query_581272, "oauth_token", newJString(oauthToken))
  add(query_581272, "alt", newJString(alt))
  add(query_581272, "userIp", newJString(userIp))
  add(query_581272, "quotaUser", newJString(quotaUser))
  add(path_581271, "groupKey", newJString(groupKey))
  add(path_581271, "memberKey", newJString(memberKey))
  add(query_581272, "fields", newJString(fields))
  result = call_581270.call(path_581271, query_581272, nil, nil, nil)

var directoryMembersHasMember* = Call_DirectoryMembersHasMember_581257(
    name: "directoryMembersHasMember", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/hasMember/{memberKey}",
    validator: validate_DirectoryMembersHasMember_581258,
    base: "/admin/directory/v1", url: url_DirectoryMembersHasMember_581259,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersInsert_581292 = ref object of OpenApiRestCall_579389
proc url_DirectoryMembersInsert_581294(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/members")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMembersInsert_581293(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add user to the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581295 = path.getOrDefault("groupKey")
  valid_581295 = validateParameter(valid_581295, JString, required = true,
                                 default = nil)
  if valid_581295 != nil:
    section.add "groupKey", valid_581295
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
  var valid_581296 = query.getOrDefault("key")
  valid_581296 = validateParameter(valid_581296, JString, required = false,
                                 default = nil)
  if valid_581296 != nil:
    section.add "key", valid_581296
  var valid_581297 = query.getOrDefault("prettyPrint")
  valid_581297 = validateParameter(valid_581297, JBool, required = false,
                                 default = newJBool(true))
  if valid_581297 != nil:
    section.add "prettyPrint", valid_581297
  var valid_581298 = query.getOrDefault("oauth_token")
  valid_581298 = validateParameter(valid_581298, JString, required = false,
                                 default = nil)
  if valid_581298 != nil:
    section.add "oauth_token", valid_581298
  var valid_581299 = query.getOrDefault("alt")
  valid_581299 = validateParameter(valid_581299, JString, required = false,
                                 default = newJString("json"))
  if valid_581299 != nil:
    section.add "alt", valid_581299
  var valid_581300 = query.getOrDefault("userIp")
  valid_581300 = validateParameter(valid_581300, JString, required = false,
                                 default = nil)
  if valid_581300 != nil:
    section.add "userIp", valid_581300
  var valid_581301 = query.getOrDefault("quotaUser")
  valid_581301 = validateParameter(valid_581301, JString, required = false,
                                 default = nil)
  if valid_581301 != nil:
    section.add "quotaUser", valid_581301
  var valid_581302 = query.getOrDefault("fields")
  valid_581302 = validateParameter(valid_581302, JString, required = false,
                                 default = nil)
  if valid_581302 != nil:
    section.add "fields", valid_581302
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

proc call*(call_581304: Call_DirectoryMembersInsert_581292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add user to the specified group.
  ## 
  let valid = call_581304.validator(path, query, header, formData, body)
  let scheme = call_581304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581304.url(scheme.get, call_581304.host, call_581304.base,
                         call_581304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581304, url, valid)

proc call*(call_581305: Call_DirectoryMembersInsert_581292; groupKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryMembersInsert
  ## Add user to the specified group.
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   body: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581306 = newJObject()
  var query_581307 = newJObject()
  var body_581308 = newJObject()
  add(query_581307, "key", newJString(key))
  add(query_581307, "prettyPrint", newJBool(prettyPrint))
  add(query_581307, "oauth_token", newJString(oauthToken))
  add(query_581307, "alt", newJString(alt))
  add(query_581307, "userIp", newJString(userIp))
  add(query_581307, "quotaUser", newJString(quotaUser))
  add(path_581306, "groupKey", newJString(groupKey))
  if body != nil:
    body_581308 = body
  add(query_581307, "fields", newJString(fields))
  result = call_581305.call(path_581306, query_581307, nil, nil, body_581308)

var directoryMembersInsert* = Call_DirectoryMembersInsert_581292(
    name: "directoryMembersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersInsert_581293,
    base: "/admin/directory/v1", url: url_DirectoryMembersInsert_581294,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersList_581273 = ref object of OpenApiRestCall_579389
proc url_DirectoryMembersList_581275(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/members")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMembersList_581274(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve all members in a group (paginated)
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581276 = path.getOrDefault("groupKey")
  valid_581276 = validateParameter(valid_581276, JString, required = true,
                                 default = nil)
  if valid_581276 != nil:
    section.add "groupKey", valid_581276
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   includeDerivedMembership: JBool
  ##                           : Whether to list indirect memberships. Default: false.
  ##   roles: JString
  ##        : Comma separated role values to filter list results on.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Max allowed value is 200.
  section = newJObject()
  var valid_581277 = query.getOrDefault("key")
  valid_581277 = validateParameter(valid_581277, JString, required = false,
                                 default = nil)
  if valid_581277 != nil:
    section.add "key", valid_581277
  var valid_581278 = query.getOrDefault("prettyPrint")
  valid_581278 = validateParameter(valid_581278, JBool, required = false,
                                 default = newJBool(true))
  if valid_581278 != nil:
    section.add "prettyPrint", valid_581278
  var valid_581279 = query.getOrDefault("oauth_token")
  valid_581279 = validateParameter(valid_581279, JString, required = false,
                                 default = nil)
  if valid_581279 != nil:
    section.add "oauth_token", valid_581279
  var valid_581280 = query.getOrDefault("includeDerivedMembership")
  valid_581280 = validateParameter(valid_581280, JBool, required = false, default = nil)
  if valid_581280 != nil:
    section.add "includeDerivedMembership", valid_581280
  var valid_581281 = query.getOrDefault("roles")
  valid_581281 = validateParameter(valid_581281, JString, required = false,
                                 default = nil)
  if valid_581281 != nil:
    section.add "roles", valid_581281
  var valid_581282 = query.getOrDefault("alt")
  valid_581282 = validateParameter(valid_581282, JString, required = false,
                                 default = newJString("json"))
  if valid_581282 != nil:
    section.add "alt", valid_581282
  var valid_581283 = query.getOrDefault("userIp")
  valid_581283 = validateParameter(valid_581283, JString, required = false,
                                 default = nil)
  if valid_581283 != nil:
    section.add "userIp", valid_581283
  var valid_581284 = query.getOrDefault("quotaUser")
  valid_581284 = validateParameter(valid_581284, JString, required = false,
                                 default = nil)
  if valid_581284 != nil:
    section.add "quotaUser", valid_581284
  var valid_581285 = query.getOrDefault("pageToken")
  valid_581285 = validateParameter(valid_581285, JString, required = false,
                                 default = nil)
  if valid_581285 != nil:
    section.add "pageToken", valid_581285
  var valid_581286 = query.getOrDefault("fields")
  valid_581286 = validateParameter(valid_581286, JString, required = false,
                                 default = nil)
  if valid_581286 != nil:
    section.add "fields", valid_581286
  var valid_581287 = query.getOrDefault("maxResults")
  valid_581287 = validateParameter(valid_581287, JInt, required = false,
                                 default = newJInt(200))
  if valid_581287 != nil:
    section.add "maxResults", valid_581287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581288: Call_DirectoryMembersList_581273; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all members in a group (paginated)
  ## 
  let valid = call_581288.validator(path, query, header, formData, body)
  let scheme = call_581288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581288.url(scheme.get, call_581288.host, call_581288.base,
                         call_581288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581288, url, valid)

proc call*(call_581289: Call_DirectoryMembersList_581273; groupKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          includeDerivedMembership: bool = false; roles: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          pageToken: string = ""; fields: string = ""; maxResults: int = 200): Recallable =
  ## directoryMembersList
  ## Retrieve all members in a group (paginated)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   includeDerivedMembership: bool
  ##                           : Whether to list indirect memberships. Default: false.
  ##   roles: string
  ##        : Comma separated role values to filter list results on.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   maxResults: int
  ##             : Maximum number of results to return. Max allowed value is 200.
  var path_581290 = newJObject()
  var query_581291 = newJObject()
  add(query_581291, "key", newJString(key))
  add(query_581291, "prettyPrint", newJBool(prettyPrint))
  add(query_581291, "oauth_token", newJString(oauthToken))
  add(query_581291, "includeDerivedMembership", newJBool(includeDerivedMembership))
  add(query_581291, "roles", newJString(roles))
  add(query_581291, "alt", newJString(alt))
  add(query_581291, "userIp", newJString(userIp))
  add(query_581291, "quotaUser", newJString(quotaUser))
  add(query_581291, "pageToken", newJString(pageToken))
  add(path_581290, "groupKey", newJString(groupKey))
  add(query_581291, "fields", newJString(fields))
  add(query_581291, "maxResults", newJInt(maxResults))
  result = call_581289.call(path_581290, query_581291, nil, nil, nil)

var directoryMembersList* = Call_DirectoryMembersList_581273(
    name: "directoryMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersList_581274, base: "/admin/directory/v1",
    url: url_DirectoryMembersList_581275, schemes: {Scheme.Https})
type
  Call_DirectoryMembersUpdate_581325 = ref object of OpenApiRestCall_579389
proc url_DirectoryMembersUpdate_581327(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  assert "memberKey" in path, "`memberKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/members/"),
               (kind: VariableSegment, value: "memberKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMembersUpdate_581326(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update membership of a user in the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  ##   memberKey: JString (required)
  ##            : Email or immutable ID of the user. If ID, it should match with id of member object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581328 = path.getOrDefault("groupKey")
  valid_581328 = validateParameter(valid_581328, JString, required = true,
                                 default = nil)
  if valid_581328 != nil:
    section.add "groupKey", valid_581328
  var valid_581329 = path.getOrDefault("memberKey")
  valid_581329 = validateParameter(valid_581329, JString, required = true,
                                 default = nil)
  if valid_581329 != nil:
    section.add "memberKey", valid_581329
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
  var valid_581330 = query.getOrDefault("key")
  valid_581330 = validateParameter(valid_581330, JString, required = false,
                                 default = nil)
  if valid_581330 != nil:
    section.add "key", valid_581330
  var valid_581331 = query.getOrDefault("prettyPrint")
  valid_581331 = validateParameter(valid_581331, JBool, required = false,
                                 default = newJBool(true))
  if valid_581331 != nil:
    section.add "prettyPrint", valid_581331
  var valid_581332 = query.getOrDefault("oauth_token")
  valid_581332 = validateParameter(valid_581332, JString, required = false,
                                 default = nil)
  if valid_581332 != nil:
    section.add "oauth_token", valid_581332
  var valid_581333 = query.getOrDefault("alt")
  valid_581333 = validateParameter(valid_581333, JString, required = false,
                                 default = newJString("json"))
  if valid_581333 != nil:
    section.add "alt", valid_581333
  var valid_581334 = query.getOrDefault("userIp")
  valid_581334 = validateParameter(valid_581334, JString, required = false,
                                 default = nil)
  if valid_581334 != nil:
    section.add "userIp", valid_581334
  var valid_581335 = query.getOrDefault("quotaUser")
  valid_581335 = validateParameter(valid_581335, JString, required = false,
                                 default = nil)
  if valid_581335 != nil:
    section.add "quotaUser", valid_581335
  var valid_581336 = query.getOrDefault("fields")
  valid_581336 = validateParameter(valid_581336, JString, required = false,
                                 default = nil)
  if valid_581336 != nil:
    section.add "fields", valid_581336
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

proc call*(call_581338: Call_DirectoryMembersUpdate_581325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group.
  ## 
  let valid = call_581338.validator(path, query, header, formData, body)
  let scheme = call_581338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581338.url(scheme.get, call_581338.host, call_581338.base,
                         call_581338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581338, url, valid)

proc call*(call_581339: Call_DirectoryMembersUpdate_581325; groupKey: string;
          memberKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryMembersUpdate
  ## Update membership of a user in the specified group.
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  ##   body: JObject
  ##   memberKey: string (required)
  ##            : Email or immutable ID of the user. If ID, it should match with id of member object
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581340 = newJObject()
  var query_581341 = newJObject()
  var body_581342 = newJObject()
  add(query_581341, "key", newJString(key))
  add(query_581341, "prettyPrint", newJBool(prettyPrint))
  add(query_581341, "oauth_token", newJString(oauthToken))
  add(query_581341, "alt", newJString(alt))
  add(query_581341, "userIp", newJString(userIp))
  add(query_581341, "quotaUser", newJString(quotaUser))
  add(path_581340, "groupKey", newJString(groupKey))
  if body != nil:
    body_581342 = body
  add(path_581340, "memberKey", newJString(memberKey))
  add(query_581341, "fields", newJString(fields))
  result = call_581339.call(path_581340, query_581341, nil, nil, body_581342)

var directoryMembersUpdate* = Call_DirectoryMembersUpdate_581325(
    name: "directoryMembersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersUpdate_581326,
    base: "/admin/directory/v1", url: url_DirectoryMembersUpdate_581327,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersGet_581309 = ref object of OpenApiRestCall_579389
proc url_DirectoryMembersGet_581311(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  assert "memberKey" in path, "`memberKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/members/"),
               (kind: VariableSegment, value: "memberKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMembersGet_581310(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve Group Member
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  ##   memberKey: JString (required)
  ##            : Email or immutable ID of the member
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581312 = path.getOrDefault("groupKey")
  valid_581312 = validateParameter(valid_581312, JString, required = true,
                                 default = nil)
  if valid_581312 != nil:
    section.add "groupKey", valid_581312
  var valid_581313 = path.getOrDefault("memberKey")
  valid_581313 = validateParameter(valid_581313, JString, required = true,
                                 default = nil)
  if valid_581313 != nil:
    section.add "memberKey", valid_581313
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
  var valid_581314 = query.getOrDefault("key")
  valid_581314 = validateParameter(valid_581314, JString, required = false,
                                 default = nil)
  if valid_581314 != nil:
    section.add "key", valid_581314
  var valid_581315 = query.getOrDefault("prettyPrint")
  valid_581315 = validateParameter(valid_581315, JBool, required = false,
                                 default = newJBool(true))
  if valid_581315 != nil:
    section.add "prettyPrint", valid_581315
  var valid_581316 = query.getOrDefault("oauth_token")
  valid_581316 = validateParameter(valid_581316, JString, required = false,
                                 default = nil)
  if valid_581316 != nil:
    section.add "oauth_token", valid_581316
  var valid_581317 = query.getOrDefault("alt")
  valid_581317 = validateParameter(valid_581317, JString, required = false,
                                 default = newJString("json"))
  if valid_581317 != nil:
    section.add "alt", valid_581317
  var valid_581318 = query.getOrDefault("userIp")
  valid_581318 = validateParameter(valid_581318, JString, required = false,
                                 default = nil)
  if valid_581318 != nil:
    section.add "userIp", valid_581318
  var valid_581319 = query.getOrDefault("quotaUser")
  valid_581319 = validateParameter(valid_581319, JString, required = false,
                                 default = nil)
  if valid_581319 != nil:
    section.add "quotaUser", valid_581319
  var valid_581320 = query.getOrDefault("fields")
  valid_581320 = validateParameter(valid_581320, JString, required = false,
                                 default = nil)
  if valid_581320 != nil:
    section.add "fields", valid_581320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581321: Call_DirectoryMembersGet_581309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group Member
  ## 
  let valid = call_581321.validator(path, query, header, formData, body)
  let scheme = call_581321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581321.url(scheme.get, call_581321.host, call_581321.base,
                         call_581321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581321, url, valid)

proc call*(call_581322: Call_DirectoryMembersGet_581309; groupKey: string;
          memberKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryMembersGet
  ## Retrieve Group Member
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   memberKey: string (required)
  ##            : Email or immutable ID of the member
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581323 = newJObject()
  var query_581324 = newJObject()
  add(query_581324, "key", newJString(key))
  add(query_581324, "prettyPrint", newJBool(prettyPrint))
  add(query_581324, "oauth_token", newJString(oauthToken))
  add(query_581324, "alt", newJString(alt))
  add(query_581324, "userIp", newJString(userIp))
  add(query_581324, "quotaUser", newJString(quotaUser))
  add(path_581323, "groupKey", newJString(groupKey))
  add(path_581323, "memberKey", newJString(memberKey))
  add(query_581324, "fields", newJString(fields))
  result = call_581322.call(path_581323, query_581324, nil, nil, nil)

var directoryMembersGet* = Call_DirectoryMembersGet_581309(
    name: "directoryMembersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersGet_581310, base: "/admin/directory/v1",
    url: url_DirectoryMembersGet_581311, schemes: {Scheme.Https})
type
  Call_DirectoryMembersPatch_581359 = ref object of OpenApiRestCall_579389
proc url_DirectoryMembersPatch_581361(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  assert "memberKey" in path, "`memberKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/members/"),
               (kind: VariableSegment, value: "memberKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMembersPatch_581360(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update membership of a user in the specified group. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  ##   memberKey: JString (required)
  ##            : Email or immutable ID of the user. If ID, it should match with id of member object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581362 = path.getOrDefault("groupKey")
  valid_581362 = validateParameter(valid_581362, JString, required = true,
                                 default = nil)
  if valid_581362 != nil:
    section.add "groupKey", valid_581362
  var valid_581363 = path.getOrDefault("memberKey")
  valid_581363 = validateParameter(valid_581363, JString, required = true,
                                 default = nil)
  if valid_581363 != nil:
    section.add "memberKey", valid_581363
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
  var valid_581364 = query.getOrDefault("key")
  valid_581364 = validateParameter(valid_581364, JString, required = false,
                                 default = nil)
  if valid_581364 != nil:
    section.add "key", valid_581364
  var valid_581365 = query.getOrDefault("prettyPrint")
  valid_581365 = validateParameter(valid_581365, JBool, required = false,
                                 default = newJBool(true))
  if valid_581365 != nil:
    section.add "prettyPrint", valid_581365
  var valid_581366 = query.getOrDefault("oauth_token")
  valid_581366 = validateParameter(valid_581366, JString, required = false,
                                 default = nil)
  if valid_581366 != nil:
    section.add "oauth_token", valid_581366
  var valid_581367 = query.getOrDefault("alt")
  valid_581367 = validateParameter(valid_581367, JString, required = false,
                                 default = newJString("json"))
  if valid_581367 != nil:
    section.add "alt", valid_581367
  var valid_581368 = query.getOrDefault("userIp")
  valid_581368 = validateParameter(valid_581368, JString, required = false,
                                 default = nil)
  if valid_581368 != nil:
    section.add "userIp", valid_581368
  var valid_581369 = query.getOrDefault("quotaUser")
  valid_581369 = validateParameter(valid_581369, JString, required = false,
                                 default = nil)
  if valid_581369 != nil:
    section.add "quotaUser", valid_581369
  var valid_581370 = query.getOrDefault("fields")
  valid_581370 = validateParameter(valid_581370, JString, required = false,
                                 default = nil)
  if valid_581370 != nil:
    section.add "fields", valid_581370
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

proc call*(call_581372: Call_DirectoryMembersPatch_581359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group. This method supports patch semantics.
  ## 
  let valid = call_581372.validator(path, query, header, formData, body)
  let scheme = call_581372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581372.url(scheme.get, call_581372.host, call_581372.base,
                         call_581372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581372, url, valid)

proc call*(call_581373: Call_DirectoryMembersPatch_581359; groupKey: string;
          memberKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryMembersPatch
  ## Update membership of a user in the specified group. This method supports patch semantics.
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  ##   body: JObject
  ##   memberKey: string (required)
  ##            : Email or immutable ID of the user. If ID, it should match with id of member object
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581374 = newJObject()
  var query_581375 = newJObject()
  var body_581376 = newJObject()
  add(query_581375, "key", newJString(key))
  add(query_581375, "prettyPrint", newJBool(prettyPrint))
  add(query_581375, "oauth_token", newJString(oauthToken))
  add(query_581375, "alt", newJString(alt))
  add(query_581375, "userIp", newJString(userIp))
  add(query_581375, "quotaUser", newJString(quotaUser))
  add(path_581374, "groupKey", newJString(groupKey))
  if body != nil:
    body_581376 = body
  add(path_581374, "memberKey", newJString(memberKey))
  add(query_581375, "fields", newJString(fields))
  result = call_581373.call(path_581374, query_581375, nil, nil, body_581376)

var directoryMembersPatch* = Call_DirectoryMembersPatch_581359(
    name: "directoryMembersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersPatch_581360, base: "/admin/directory/v1",
    url: url_DirectoryMembersPatch_581361, schemes: {Scheme.Https})
type
  Call_DirectoryMembersDelete_581343 = ref object of OpenApiRestCall_579389
proc url_DirectoryMembersDelete_581345(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "groupKey" in path, "`groupKey` is a required path parameter"
  assert "memberKey" in path, "`memberKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/groups/"),
               (kind: VariableSegment, value: "groupKey"),
               (kind: ConstantSegment, value: "/members/"),
               (kind: VariableSegment, value: "memberKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryMembersDelete_581344(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  ##   memberKey: JString (required)
  ##            : Email or immutable ID of the member
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `groupKey` field"
  var valid_581346 = path.getOrDefault("groupKey")
  valid_581346 = validateParameter(valid_581346, JString, required = true,
                                 default = nil)
  if valid_581346 != nil:
    section.add "groupKey", valid_581346
  var valid_581347 = path.getOrDefault("memberKey")
  valid_581347 = validateParameter(valid_581347, JString, required = true,
                                 default = nil)
  if valid_581347 != nil:
    section.add "memberKey", valid_581347
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
  var valid_581348 = query.getOrDefault("key")
  valid_581348 = validateParameter(valid_581348, JString, required = false,
                                 default = nil)
  if valid_581348 != nil:
    section.add "key", valid_581348
  var valid_581349 = query.getOrDefault("prettyPrint")
  valid_581349 = validateParameter(valid_581349, JBool, required = false,
                                 default = newJBool(true))
  if valid_581349 != nil:
    section.add "prettyPrint", valid_581349
  var valid_581350 = query.getOrDefault("oauth_token")
  valid_581350 = validateParameter(valid_581350, JString, required = false,
                                 default = nil)
  if valid_581350 != nil:
    section.add "oauth_token", valid_581350
  var valid_581351 = query.getOrDefault("alt")
  valid_581351 = validateParameter(valid_581351, JString, required = false,
                                 default = newJString("json"))
  if valid_581351 != nil:
    section.add "alt", valid_581351
  var valid_581352 = query.getOrDefault("userIp")
  valid_581352 = validateParameter(valid_581352, JString, required = false,
                                 default = nil)
  if valid_581352 != nil:
    section.add "userIp", valid_581352
  var valid_581353 = query.getOrDefault("quotaUser")
  valid_581353 = validateParameter(valid_581353, JString, required = false,
                                 default = nil)
  if valid_581353 != nil:
    section.add "quotaUser", valid_581353
  var valid_581354 = query.getOrDefault("fields")
  valid_581354 = validateParameter(valid_581354, JString, required = false,
                                 default = nil)
  if valid_581354 != nil:
    section.add "fields", valid_581354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581355: Call_DirectoryMembersDelete_581343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove membership.
  ## 
  let valid = call_581355.validator(path, query, header, formData, body)
  let scheme = call_581355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581355.url(scheme.get, call_581355.host, call_581355.base,
                         call_581355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581355, url, valid)

proc call*(call_581356: Call_DirectoryMembersDelete_581343; groupKey: string;
          memberKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryMembersDelete
  ## Remove membership.
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   memberKey: string (required)
  ##            : Email or immutable ID of the member
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  var path_581357 = newJObject()
  var query_581358 = newJObject()
  add(query_581358, "key", newJString(key))
  add(query_581358, "prettyPrint", newJBool(prettyPrint))
  add(query_581358, "oauth_token", newJString(oauthToken))
  add(query_581358, "alt", newJString(alt))
  add(query_581358, "userIp", newJString(userIp))
  add(query_581358, "quotaUser", newJString(quotaUser))
  add(path_581357, "groupKey", newJString(groupKey))
  add(path_581357, "memberKey", newJString(memberKey))
  add(query_581358, "fields", newJString(fields))
  result = call_581356.call(path_581357, query_581358, nil, nil, nil)

var directoryMembersDelete* = Call_DirectoryMembersDelete_581343(
    name: "directoryMembersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersDelete_581344,
    base: "/admin/directory/v1", url: url_DirectoryMembersDelete_581345,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsGetSettings_581377 = ref object of OpenApiRestCall_579389
proc url_DirectoryResolvedAppAccessSettingsGetSettings_581379(protocol: Scheme;
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

proc validate_DirectoryResolvedAppAccessSettingsGetSettings_581378(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves resolved app access settings of the logged in user.
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
  var valid_581380 = query.getOrDefault("key")
  valid_581380 = validateParameter(valid_581380, JString, required = false,
                                 default = nil)
  if valid_581380 != nil:
    section.add "key", valid_581380
  var valid_581381 = query.getOrDefault("prettyPrint")
  valid_581381 = validateParameter(valid_581381, JBool, required = false,
                                 default = newJBool(true))
  if valid_581381 != nil:
    section.add "prettyPrint", valid_581381
  var valid_581382 = query.getOrDefault("oauth_token")
  valid_581382 = validateParameter(valid_581382, JString, required = false,
                                 default = nil)
  if valid_581382 != nil:
    section.add "oauth_token", valid_581382
  var valid_581383 = query.getOrDefault("alt")
  valid_581383 = validateParameter(valid_581383, JString, required = false,
                                 default = newJString("json"))
  if valid_581383 != nil:
    section.add "alt", valid_581383
  var valid_581384 = query.getOrDefault("userIp")
  valid_581384 = validateParameter(valid_581384, JString, required = false,
                                 default = nil)
  if valid_581384 != nil:
    section.add "userIp", valid_581384
  var valid_581385 = query.getOrDefault("quotaUser")
  valid_581385 = validateParameter(valid_581385, JString, required = false,
                                 default = nil)
  if valid_581385 != nil:
    section.add "quotaUser", valid_581385
  var valid_581386 = query.getOrDefault("fields")
  valid_581386 = validateParameter(valid_581386, JString, required = false,
                                 default = nil)
  if valid_581386 != nil:
    section.add "fields", valid_581386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581387: Call_DirectoryResolvedAppAccessSettingsGetSettings_581377;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves resolved app access settings of the logged in user.
  ## 
  let valid = call_581387.validator(path, query, header, formData, body)
  let scheme = call_581387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581387.url(scheme.get, call_581387.host, call_581387.base,
                         call_581387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581387, url, valid)

proc call*(call_581388: Call_DirectoryResolvedAppAccessSettingsGetSettings_581377;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryResolvedAppAccessSettingsGetSettings
  ## Retrieves resolved app access settings of the logged in user.
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
  var query_581389 = newJObject()
  add(query_581389, "key", newJString(key))
  add(query_581389, "prettyPrint", newJBool(prettyPrint))
  add(query_581389, "oauth_token", newJString(oauthToken))
  add(query_581389, "alt", newJString(alt))
  add(query_581389, "userIp", newJString(userIp))
  add(query_581389, "quotaUser", newJString(quotaUser))
  add(query_581389, "fields", newJString(fields))
  result = call_581388.call(nil, query_581389, nil, nil, nil)

var directoryResolvedAppAccessSettingsGetSettings* = Call_DirectoryResolvedAppAccessSettingsGetSettings_581377(
    name: "directoryResolvedAppAccessSettingsGetSettings",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/resolvedappaccesssettings",
    validator: validate_DirectoryResolvedAppAccessSettingsGetSettings_581378,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsGetSettings_581379,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsListTrustedApps_581390 = ref object of OpenApiRestCall_579389
proc url_DirectoryResolvedAppAccessSettingsListTrustedApps_581392(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsListTrustedApps_581391(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the list of apps trusted by the admin of the logged in user.
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
  var valid_581393 = query.getOrDefault("key")
  valid_581393 = validateParameter(valid_581393, JString, required = false,
                                 default = nil)
  if valid_581393 != nil:
    section.add "key", valid_581393
  var valid_581394 = query.getOrDefault("prettyPrint")
  valid_581394 = validateParameter(valid_581394, JBool, required = false,
                                 default = newJBool(true))
  if valid_581394 != nil:
    section.add "prettyPrint", valid_581394
  var valid_581395 = query.getOrDefault("oauth_token")
  valid_581395 = validateParameter(valid_581395, JString, required = false,
                                 default = nil)
  if valid_581395 != nil:
    section.add "oauth_token", valid_581395
  var valid_581396 = query.getOrDefault("alt")
  valid_581396 = validateParameter(valid_581396, JString, required = false,
                                 default = newJString("json"))
  if valid_581396 != nil:
    section.add "alt", valid_581396
  var valid_581397 = query.getOrDefault("userIp")
  valid_581397 = validateParameter(valid_581397, JString, required = false,
                                 default = nil)
  if valid_581397 != nil:
    section.add "userIp", valid_581397
  var valid_581398 = query.getOrDefault("quotaUser")
  valid_581398 = validateParameter(valid_581398, JString, required = false,
                                 default = nil)
  if valid_581398 != nil:
    section.add "quotaUser", valid_581398
  var valid_581399 = query.getOrDefault("fields")
  valid_581399 = validateParameter(valid_581399, JString, required = false,
                                 default = nil)
  if valid_581399 != nil:
    section.add "fields", valid_581399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581400: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_581390;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of apps trusted by the admin of the logged in user.
  ## 
  let valid = call_581400.validator(path, query, header, formData, body)
  let scheme = call_581400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581400.url(scheme.get, call_581400.host, call_581400.base,
                         call_581400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581400, url, valid)

proc call*(call_581401: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_581390;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryResolvedAppAccessSettingsListTrustedApps
  ## Retrieves the list of apps trusted by the admin of the logged in user.
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
  var query_581402 = newJObject()
  add(query_581402, "key", newJString(key))
  add(query_581402, "prettyPrint", newJBool(prettyPrint))
  add(query_581402, "oauth_token", newJString(oauthToken))
  add(query_581402, "alt", newJString(alt))
  add(query_581402, "userIp", newJString(userIp))
  add(query_581402, "quotaUser", newJString(quotaUser))
  add(query_581402, "fields", newJString(fields))
  result = call_581401.call(nil, query_581402, nil, nil, nil)

var directoryResolvedAppAccessSettingsListTrustedApps* = Call_DirectoryResolvedAppAccessSettingsListTrustedApps_581390(
    name: "directoryResolvedAppAccessSettingsListTrustedApps",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/trustedapps",
    validator: validate_DirectoryResolvedAppAccessSettingsListTrustedApps_581391,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsListTrustedApps_581392,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersInsert_581428 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersInsert_581430(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DirectoryUsersInsert_581429(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## create user.
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
  var valid_581431 = query.getOrDefault("key")
  valid_581431 = validateParameter(valid_581431, JString, required = false,
                                 default = nil)
  if valid_581431 != nil:
    section.add "key", valid_581431
  var valid_581432 = query.getOrDefault("prettyPrint")
  valid_581432 = validateParameter(valid_581432, JBool, required = false,
                                 default = newJBool(true))
  if valid_581432 != nil:
    section.add "prettyPrint", valid_581432
  var valid_581433 = query.getOrDefault("oauth_token")
  valid_581433 = validateParameter(valid_581433, JString, required = false,
                                 default = nil)
  if valid_581433 != nil:
    section.add "oauth_token", valid_581433
  var valid_581434 = query.getOrDefault("alt")
  valid_581434 = validateParameter(valid_581434, JString, required = false,
                                 default = newJString("json"))
  if valid_581434 != nil:
    section.add "alt", valid_581434
  var valid_581435 = query.getOrDefault("userIp")
  valid_581435 = validateParameter(valid_581435, JString, required = false,
                                 default = nil)
  if valid_581435 != nil:
    section.add "userIp", valid_581435
  var valid_581436 = query.getOrDefault("quotaUser")
  valid_581436 = validateParameter(valid_581436, JString, required = false,
                                 default = nil)
  if valid_581436 != nil:
    section.add "quotaUser", valid_581436
  var valid_581437 = query.getOrDefault("fields")
  valid_581437 = validateParameter(valid_581437, JString, required = false,
                                 default = nil)
  if valid_581437 != nil:
    section.add "fields", valid_581437
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

proc call*(call_581439: Call_DirectoryUsersInsert_581428; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## create user.
  ## 
  let valid = call_581439.validator(path, query, header, formData, body)
  let scheme = call_581439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581439.url(scheme.get, call_581439.host, call_581439.base,
                         call_581439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581439, url, valid)

proc call*(call_581440: Call_DirectoryUsersInsert_581428; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          fields: string = ""): Recallable =
  ## directoryUsersInsert
  ## create user.
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
  var query_581441 = newJObject()
  var body_581442 = newJObject()
  add(query_581441, "key", newJString(key))
  add(query_581441, "prettyPrint", newJBool(prettyPrint))
  add(query_581441, "oauth_token", newJString(oauthToken))
  add(query_581441, "alt", newJString(alt))
  add(query_581441, "userIp", newJString(userIp))
  add(query_581441, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581442 = body
  add(query_581441, "fields", newJString(fields))
  result = call_581440.call(nil, query_581441, nil, nil, body_581442)

var directoryUsersInsert* = Call_DirectoryUsersInsert_581428(
    name: "directoryUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersInsert_581429, base: "/admin/directory/v1",
    url: url_DirectoryUsersInsert_581430, schemes: {Scheme.Https})
type
  Call_DirectoryUsersList_581403 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersList_581405(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DirectoryUsersList_581404(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieve either deleted users or all users in a domain (paginated)
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
  ##   domain: JString
  ##         : Name of the domain. Fill this field to get users from only this domain. To return all users in a multi-domain fill customer field instead.
  ##   event: JString
  ##        : Event on which subscription is intended (if subscribing)
  ##   viewType: JString
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   customFieldMask: JString
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order.
  ##   query: JString
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-users
  ##   customer: JString
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all users for a customer, fill this field instead of domain.
  ##   projection: JString
  ##             : What subset of fields to fetch for this user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: JString
  ##              : If set to true, retrieves the list of deleted users. (Default: false)
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_581406 = query.getOrDefault("key")
  valid_581406 = validateParameter(valid_581406, JString, required = false,
                                 default = nil)
  if valid_581406 != nil:
    section.add "key", valid_581406
  var valid_581407 = query.getOrDefault("prettyPrint")
  valid_581407 = validateParameter(valid_581407, JBool, required = false,
                                 default = newJBool(true))
  if valid_581407 != nil:
    section.add "prettyPrint", valid_581407
  var valid_581408 = query.getOrDefault("oauth_token")
  valid_581408 = validateParameter(valid_581408, JString, required = false,
                                 default = nil)
  if valid_581408 != nil:
    section.add "oauth_token", valid_581408
  var valid_581409 = query.getOrDefault("domain")
  valid_581409 = validateParameter(valid_581409, JString, required = false,
                                 default = nil)
  if valid_581409 != nil:
    section.add "domain", valid_581409
  var valid_581410 = query.getOrDefault("event")
  valid_581410 = validateParameter(valid_581410, JString, required = false,
                                 default = newJString("add"))
  if valid_581410 != nil:
    section.add "event", valid_581410
  var valid_581411 = query.getOrDefault("viewType")
  valid_581411 = validateParameter(valid_581411, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_581411 != nil:
    section.add "viewType", valid_581411
  var valid_581412 = query.getOrDefault("alt")
  valid_581412 = validateParameter(valid_581412, JString, required = false,
                                 default = newJString("json"))
  if valid_581412 != nil:
    section.add "alt", valid_581412
  var valid_581413 = query.getOrDefault("userIp")
  valid_581413 = validateParameter(valid_581413, JString, required = false,
                                 default = nil)
  if valid_581413 != nil:
    section.add "userIp", valid_581413
  var valid_581414 = query.getOrDefault("quotaUser")
  valid_581414 = validateParameter(valid_581414, JString, required = false,
                                 default = nil)
  if valid_581414 != nil:
    section.add "quotaUser", valid_581414
  var valid_581415 = query.getOrDefault("orderBy")
  valid_581415 = validateParameter(valid_581415, JString, required = false,
                                 default = newJString("email"))
  if valid_581415 != nil:
    section.add "orderBy", valid_581415
  var valid_581416 = query.getOrDefault("pageToken")
  valid_581416 = validateParameter(valid_581416, JString, required = false,
                                 default = nil)
  if valid_581416 != nil:
    section.add "pageToken", valid_581416
  var valid_581417 = query.getOrDefault("customFieldMask")
  valid_581417 = validateParameter(valid_581417, JString, required = false,
                                 default = nil)
  if valid_581417 != nil:
    section.add "customFieldMask", valid_581417
  var valid_581418 = query.getOrDefault("sortOrder")
  valid_581418 = validateParameter(valid_581418, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_581418 != nil:
    section.add "sortOrder", valid_581418
  var valid_581419 = query.getOrDefault("query")
  valid_581419 = validateParameter(valid_581419, JString, required = false,
                                 default = nil)
  if valid_581419 != nil:
    section.add "query", valid_581419
  var valid_581420 = query.getOrDefault("customer")
  valid_581420 = validateParameter(valid_581420, JString, required = false,
                                 default = nil)
  if valid_581420 != nil:
    section.add "customer", valid_581420
  var valid_581421 = query.getOrDefault("projection")
  valid_581421 = validateParameter(valid_581421, JString, required = false,
                                 default = newJString("basic"))
  if valid_581421 != nil:
    section.add "projection", valid_581421
  var valid_581422 = query.getOrDefault("fields")
  valid_581422 = validateParameter(valid_581422, JString, required = false,
                                 default = nil)
  if valid_581422 != nil:
    section.add "fields", valid_581422
  var valid_581423 = query.getOrDefault("showDeleted")
  valid_581423 = validateParameter(valid_581423, JString, required = false,
                                 default = nil)
  if valid_581423 != nil:
    section.add "showDeleted", valid_581423
  var valid_581424 = query.getOrDefault("maxResults")
  valid_581424 = validateParameter(valid_581424, JInt, required = false,
                                 default = newJInt(100))
  if valid_581424 != nil:
    section.add "maxResults", valid_581424
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581425: Call_DirectoryUsersList_581403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve either deleted users or all users in a domain (paginated)
  ## 
  let valid = call_581425.validator(path, query, header, formData, body)
  let scheme = call_581425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581425.url(scheme.get, call_581425.host, call_581425.base,
                         call_581425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581425, url, valid)

proc call*(call_581426: Call_DirectoryUsersList_581403; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; domain: string = "";
          event: string = "add"; viewType: string = "admin_view"; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "email";
          pageToken: string = ""; customFieldMask: string = "";
          sortOrder: string = "ASCENDING"; query: string = ""; customer: string = "";
          projection: string = "basic"; fields: string = ""; showDeleted: string = "";
          maxResults: int = 100): Recallable =
  ## directoryUsersList
  ## Retrieve either deleted users or all users in a domain (paginated)
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   domain: string
  ##         : Name of the domain. Fill this field to get users from only this domain. To return all users in a multi-domain fill customer field instead.
  ##   event: string
  ##        : Event on which subscription is intended (if subscribing)
  ##   viewType: string
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   customFieldMask: string
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order.
  ##   query: string
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-users
  ##   customer: string
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all users for a customer, fill this field instead of domain.
  ##   projection: string
  ##             : What subset of fields to fetch for this user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: string
  ##              : If set to true, retrieves the list of deleted users. (Default: false)
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var query_581427 = newJObject()
  add(query_581427, "key", newJString(key))
  add(query_581427, "prettyPrint", newJBool(prettyPrint))
  add(query_581427, "oauth_token", newJString(oauthToken))
  add(query_581427, "domain", newJString(domain))
  add(query_581427, "event", newJString(event))
  add(query_581427, "viewType", newJString(viewType))
  add(query_581427, "alt", newJString(alt))
  add(query_581427, "userIp", newJString(userIp))
  add(query_581427, "quotaUser", newJString(quotaUser))
  add(query_581427, "orderBy", newJString(orderBy))
  add(query_581427, "pageToken", newJString(pageToken))
  add(query_581427, "customFieldMask", newJString(customFieldMask))
  add(query_581427, "sortOrder", newJString(sortOrder))
  add(query_581427, "query", newJString(query))
  add(query_581427, "customer", newJString(customer))
  add(query_581427, "projection", newJString(projection))
  add(query_581427, "fields", newJString(fields))
  add(query_581427, "showDeleted", newJString(showDeleted))
  add(query_581427, "maxResults", newJInt(maxResults))
  result = call_581426.call(nil, query_581427, nil, nil, nil)

var directoryUsersList* = Call_DirectoryUsersList_581403(
    name: "directoryUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersList_581404, base: "/admin/directory/v1",
    url: url_DirectoryUsersList_581405, schemes: {Scheme.Https})
type
  Call_DirectoryUsersWatch_581443 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersWatch_581445(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  if base ==
      "/" and
      route.startsWith "/":
    result.path = route
  else:
    result.path = base & route

proc validate_DirectoryUsersWatch_581444(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Watch for changes in users list
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
  ##   domain: JString
  ##         : Name of the domain. Fill this field to get users from only this domain. To return all users in a multi-domain fill customer field instead.
  ##   event: JString
  ##        : Event on which subscription is intended (if subscribing)
  ##   viewType: JString
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   customFieldMask: JString
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order.
  ##   query: JString
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-users
  ##   customer: JString
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all users for a customer, fill this field instead of domain.
  ##   projection: JString
  ##             : What subset of fields to fetch for this user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: JString
  ##              : If set to true, retrieves the list of deleted users. (Default: false)
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  section = newJObject()
  var valid_581446 = query.getOrDefault("key")
  valid_581446 = validateParameter(valid_581446, JString, required = false,
                                 default = nil)
  if valid_581446 != nil:
    section.add "key", valid_581446
  var valid_581447 = query.getOrDefault("prettyPrint")
  valid_581447 = validateParameter(valid_581447, JBool, required = false,
                                 default = newJBool(true))
  if valid_581447 != nil:
    section.add "prettyPrint", valid_581447
  var valid_581448 = query.getOrDefault("oauth_token")
  valid_581448 = validateParameter(valid_581448, JString, required = false,
                                 default = nil)
  if valid_581448 != nil:
    section.add "oauth_token", valid_581448
  var valid_581449 = query.getOrDefault("domain")
  valid_581449 = validateParameter(valid_581449, JString, required = false,
                                 default = nil)
  if valid_581449 != nil:
    section.add "domain", valid_581449
  var valid_581450 = query.getOrDefault("event")
  valid_581450 = validateParameter(valid_581450, JString, required = false,
                                 default = newJString("add"))
  if valid_581450 != nil:
    section.add "event", valid_581450
  var valid_581451 = query.getOrDefault("viewType")
  valid_581451 = validateParameter(valid_581451, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_581451 != nil:
    section.add "viewType", valid_581451
  var valid_581452 = query.getOrDefault("alt")
  valid_581452 = validateParameter(valid_581452, JString, required = false,
                                 default = newJString("json"))
  if valid_581452 != nil:
    section.add "alt", valid_581452
  var valid_581453 = query.getOrDefault("userIp")
  valid_581453 = validateParameter(valid_581453, JString, required = false,
                                 default = nil)
  if valid_581453 != nil:
    section.add "userIp", valid_581453
  var valid_581454 = query.getOrDefault("quotaUser")
  valid_581454 = validateParameter(valid_581454, JString, required = false,
                                 default = nil)
  if valid_581454 != nil:
    section.add "quotaUser", valid_581454
  var valid_581455 = query.getOrDefault("orderBy")
  valid_581455 = validateParameter(valid_581455, JString, required = false,
                                 default = newJString("email"))
  if valid_581455 != nil:
    section.add "orderBy", valid_581455
  var valid_581456 = query.getOrDefault("pageToken")
  valid_581456 = validateParameter(valid_581456, JString, required = false,
                                 default = nil)
  if valid_581456 != nil:
    section.add "pageToken", valid_581456
  var valid_581457 = query.getOrDefault("customFieldMask")
  valid_581457 = validateParameter(valid_581457, JString, required = false,
                                 default = nil)
  if valid_581457 != nil:
    section.add "customFieldMask", valid_581457
  var valid_581458 = query.getOrDefault("sortOrder")
  valid_581458 = validateParameter(valid_581458, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_581458 != nil:
    section.add "sortOrder", valid_581458
  var valid_581459 = query.getOrDefault("query")
  valid_581459 = validateParameter(valid_581459, JString, required = false,
                                 default = nil)
  if valid_581459 != nil:
    section.add "query", valid_581459
  var valid_581460 = query.getOrDefault("customer")
  valid_581460 = validateParameter(valid_581460, JString, required = false,
                                 default = nil)
  if valid_581460 != nil:
    section.add "customer", valid_581460
  var valid_581461 = query.getOrDefault("projection")
  valid_581461 = validateParameter(valid_581461, JString, required = false,
                                 default = newJString("basic"))
  if valid_581461 != nil:
    section.add "projection", valid_581461
  var valid_581462 = query.getOrDefault("fields")
  valid_581462 = validateParameter(valid_581462, JString, required = false,
                                 default = nil)
  if valid_581462 != nil:
    section.add "fields", valid_581462
  var valid_581463 = query.getOrDefault("showDeleted")
  valid_581463 = validateParameter(valid_581463, JString, required = false,
                                 default = nil)
  if valid_581463 != nil:
    section.add "showDeleted", valid_581463
  var valid_581464 = query.getOrDefault("maxResults")
  valid_581464 = validateParameter(valid_581464, JInt, required = false,
                                 default = newJInt(100))
  if valid_581464 != nil:
    section.add "maxResults", valid_581464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581466: Call_DirectoryUsersWatch_581443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in users list
  ## 
  let valid = call_581466.validator(path, query, header, formData, body)
  let scheme = call_581466.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581466.url(scheme.get, call_581466.host, call_581466.base,
                         call_581466.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581466, url, valid)

proc call*(call_581467: Call_DirectoryUsersWatch_581443; key: string = "";
          prettyPrint: bool = true; oauthToken: string = ""; domain: string = "";
          event: string = "add"; viewType: string = "admin_view"; alt: string = "json";
          userIp: string = ""; quotaUser: string = ""; orderBy: string = "email";
          pageToken: string = ""; customFieldMask: string = "";
          sortOrder: string = "ASCENDING"; query: string = ""; customer: string = "";
          resource: JsonNode = nil; projection: string = "basic"; fields: string = "";
          showDeleted: string = ""; maxResults: int = 100): Recallable =
  ## directoryUsersWatch
  ## Watch for changes in users list
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   domain: string
  ##         : Name of the domain. Fill this field to get users from only this domain. To return all users in a multi-domain fill customer field instead.
  ##   event: string
  ##        : Event on which subscription is intended (if subscribing)
  ##   viewType: string
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   customFieldMask: string
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order.
  ##   query: string
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-users
  ##   customer: string
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all users for a customer, fill this field instead of domain.
  ##   resource: JObject
  ##   projection: string
  ##             : What subset of fields to fetch for this user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   showDeleted: string
  ##              : If set to true, retrieves the list of deleted users. (Default: false)
  ##   maxResults: int
  ##             : Maximum number of results to return.
  var query_581468 = newJObject()
  var body_581469 = newJObject()
  add(query_581468, "key", newJString(key))
  add(query_581468, "prettyPrint", newJBool(prettyPrint))
  add(query_581468, "oauth_token", newJString(oauthToken))
  add(query_581468, "domain", newJString(domain))
  add(query_581468, "event", newJString(event))
  add(query_581468, "viewType", newJString(viewType))
  add(query_581468, "alt", newJString(alt))
  add(query_581468, "userIp", newJString(userIp))
  add(query_581468, "quotaUser", newJString(quotaUser))
  add(query_581468, "orderBy", newJString(orderBy))
  add(query_581468, "pageToken", newJString(pageToken))
  add(query_581468, "customFieldMask", newJString(customFieldMask))
  add(query_581468, "sortOrder", newJString(sortOrder))
  add(query_581468, "query", newJString(query))
  add(query_581468, "customer", newJString(customer))
  if resource != nil:
    body_581469 = resource
  add(query_581468, "projection", newJString(projection))
  add(query_581468, "fields", newJString(fields))
  add(query_581468, "showDeleted", newJString(showDeleted))
  add(query_581468, "maxResults", newJInt(maxResults))
  result = call_581467.call(nil, query_581468, nil, nil, body_581469)

var directoryUsersWatch* = Call_DirectoryUsersWatch_581443(
    name: "directoryUsersWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/watch",
    validator: validate_DirectoryUsersWatch_581444, base: "/admin/directory/v1",
    url: url_DirectoryUsersWatch_581445, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUpdate_581488 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersUpdate_581490(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersUpdate_581489(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## update user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user. If ID, it should match with id of user object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581491 = path.getOrDefault("userKey")
  valid_581491 = validateParameter(valid_581491, JString, required = true,
                                 default = nil)
  if valid_581491 != nil:
    section.add "userKey", valid_581491
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
  var valid_581492 = query.getOrDefault("key")
  valid_581492 = validateParameter(valid_581492, JString, required = false,
                                 default = nil)
  if valid_581492 != nil:
    section.add "key", valid_581492
  var valid_581493 = query.getOrDefault("prettyPrint")
  valid_581493 = validateParameter(valid_581493, JBool, required = false,
                                 default = newJBool(true))
  if valid_581493 != nil:
    section.add "prettyPrint", valid_581493
  var valid_581494 = query.getOrDefault("oauth_token")
  valid_581494 = validateParameter(valid_581494, JString, required = false,
                                 default = nil)
  if valid_581494 != nil:
    section.add "oauth_token", valid_581494
  var valid_581495 = query.getOrDefault("alt")
  valid_581495 = validateParameter(valid_581495, JString, required = false,
                                 default = newJString("json"))
  if valid_581495 != nil:
    section.add "alt", valid_581495
  var valid_581496 = query.getOrDefault("userIp")
  valid_581496 = validateParameter(valid_581496, JString, required = false,
                                 default = nil)
  if valid_581496 != nil:
    section.add "userIp", valid_581496
  var valid_581497 = query.getOrDefault("quotaUser")
  valid_581497 = validateParameter(valid_581497, JString, required = false,
                                 default = nil)
  if valid_581497 != nil:
    section.add "quotaUser", valid_581497
  var valid_581498 = query.getOrDefault("fields")
  valid_581498 = validateParameter(valid_581498, JString, required = false,
                                 default = nil)
  if valid_581498 != nil:
    section.add "fields", valid_581498
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

proc call*(call_581500: Call_DirectoryUsersUpdate_581488; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user
  ## 
  let valid = call_581500.validator(path, query, header, formData, body)
  let scheme = call_581500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581500.url(scheme.get, call_581500.host, call_581500.base,
                         call_581500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581500, url, valid)

proc call*(call_581501: Call_DirectoryUsersUpdate_581488; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryUsersUpdate
  ## update user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user. If ID, it should match with id of user object
  var path_581502 = newJObject()
  var query_581503 = newJObject()
  var body_581504 = newJObject()
  add(query_581503, "key", newJString(key))
  add(query_581503, "prettyPrint", newJBool(prettyPrint))
  add(query_581503, "oauth_token", newJString(oauthToken))
  add(query_581503, "alt", newJString(alt))
  add(query_581503, "userIp", newJString(userIp))
  add(query_581503, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581504 = body
  add(query_581503, "fields", newJString(fields))
  add(path_581502, "userKey", newJString(userKey))
  result = call_581501.call(path_581502, query_581503, nil, nil, body_581504)

var directoryUsersUpdate* = Call_DirectoryUsersUpdate_581488(
    name: "directoryUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersUpdate_581489, base: "/admin/directory/v1",
    url: url_DirectoryUsersUpdate_581490, schemes: {Scheme.Https})
type
  Call_DirectoryUsersGet_581470 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersGet_581472(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersGet_581471(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## retrieve user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581473 = path.getOrDefault("userKey")
  valid_581473 = validateParameter(valid_581473, JString, required = true,
                                 default = nil)
  if valid_581473 != nil:
    section.add "userKey", valid_581473
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   viewType: JString
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   customFieldMask: JString
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   projection: JString
  ##             : What subset of fields to fetch for this user.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581474 = query.getOrDefault("key")
  valid_581474 = validateParameter(valid_581474, JString, required = false,
                                 default = nil)
  if valid_581474 != nil:
    section.add "key", valid_581474
  var valid_581475 = query.getOrDefault("prettyPrint")
  valid_581475 = validateParameter(valid_581475, JBool, required = false,
                                 default = newJBool(true))
  if valid_581475 != nil:
    section.add "prettyPrint", valid_581475
  var valid_581476 = query.getOrDefault("oauth_token")
  valid_581476 = validateParameter(valid_581476, JString, required = false,
                                 default = nil)
  if valid_581476 != nil:
    section.add "oauth_token", valid_581476
  var valid_581477 = query.getOrDefault("viewType")
  valid_581477 = validateParameter(valid_581477, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_581477 != nil:
    section.add "viewType", valid_581477
  var valid_581478 = query.getOrDefault("alt")
  valid_581478 = validateParameter(valid_581478, JString, required = false,
                                 default = newJString("json"))
  if valid_581478 != nil:
    section.add "alt", valid_581478
  var valid_581479 = query.getOrDefault("userIp")
  valid_581479 = validateParameter(valid_581479, JString, required = false,
                                 default = nil)
  if valid_581479 != nil:
    section.add "userIp", valid_581479
  var valid_581480 = query.getOrDefault("quotaUser")
  valid_581480 = validateParameter(valid_581480, JString, required = false,
                                 default = nil)
  if valid_581480 != nil:
    section.add "quotaUser", valid_581480
  var valid_581481 = query.getOrDefault("customFieldMask")
  valid_581481 = validateParameter(valid_581481, JString, required = false,
                                 default = nil)
  if valid_581481 != nil:
    section.add "customFieldMask", valid_581481
  var valid_581482 = query.getOrDefault("projection")
  valid_581482 = validateParameter(valid_581482, JString, required = false,
                                 default = newJString("basic"))
  if valid_581482 != nil:
    section.add "projection", valid_581482
  var valid_581483 = query.getOrDefault("fields")
  valid_581483 = validateParameter(valid_581483, JString, required = false,
                                 default = nil)
  if valid_581483 != nil:
    section.add "fields", valid_581483
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581484: Call_DirectoryUsersGet_581470; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## retrieve user
  ## 
  let valid = call_581484.validator(path, query, header, formData, body)
  let scheme = call_581484.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581484.url(scheme.get, call_581484.host, call_581484.base,
                         call_581484.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581484, url, valid)

proc call*(call_581485: Call_DirectoryUsersGet_581470; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          viewType: string = "admin_view"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; customFieldMask: string = "";
          projection: string = "basic"; fields: string = ""): Recallable =
  ## directoryUsersGet
  ## retrieve user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   viewType: string
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   customFieldMask: string
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   projection: string
  ##             : What subset of fields to fetch for this user.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581486 = newJObject()
  var query_581487 = newJObject()
  add(query_581487, "key", newJString(key))
  add(query_581487, "prettyPrint", newJBool(prettyPrint))
  add(query_581487, "oauth_token", newJString(oauthToken))
  add(query_581487, "viewType", newJString(viewType))
  add(query_581487, "alt", newJString(alt))
  add(query_581487, "userIp", newJString(userIp))
  add(query_581487, "quotaUser", newJString(quotaUser))
  add(query_581487, "customFieldMask", newJString(customFieldMask))
  add(query_581487, "projection", newJString(projection))
  add(query_581487, "fields", newJString(fields))
  add(path_581486, "userKey", newJString(userKey))
  result = call_581485.call(path_581486, query_581487, nil, nil, nil)

var directoryUsersGet* = Call_DirectoryUsersGet_581470(name: "directoryUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersGet_581471, base: "/admin/directory/v1",
    url: url_DirectoryUsersGet_581472, schemes: {Scheme.Https})
type
  Call_DirectoryUsersPatch_581520 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersPatch_581522(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersPatch_581521(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## update user. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user. If ID, it should match with id of user object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581523 = path.getOrDefault("userKey")
  valid_581523 = validateParameter(valid_581523, JString, required = true,
                                 default = nil)
  if valid_581523 != nil:
    section.add "userKey", valid_581523
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
  var valid_581524 = query.getOrDefault("key")
  valid_581524 = validateParameter(valid_581524, JString, required = false,
                                 default = nil)
  if valid_581524 != nil:
    section.add "key", valid_581524
  var valid_581525 = query.getOrDefault("prettyPrint")
  valid_581525 = validateParameter(valid_581525, JBool, required = false,
                                 default = newJBool(true))
  if valid_581525 != nil:
    section.add "prettyPrint", valid_581525
  var valid_581526 = query.getOrDefault("oauth_token")
  valid_581526 = validateParameter(valid_581526, JString, required = false,
                                 default = nil)
  if valid_581526 != nil:
    section.add "oauth_token", valid_581526
  var valid_581527 = query.getOrDefault("alt")
  valid_581527 = validateParameter(valid_581527, JString, required = false,
                                 default = newJString("json"))
  if valid_581527 != nil:
    section.add "alt", valid_581527
  var valid_581528 = query.getOrDefault("userIp")
  valid_581528 = validateParameter(valid_581528, JString, required = false,
                                 default = nil)
  if valid_581528 != nil:
    section.add "userIp", valid_581528
  var valid_581529 = query.getOrDefault("quotaUser")
  valid_581529 = validateParameter(valid_581529, JString, required = false,
                                 default = nil)
  if valid_581529 != nil:
    section.add "quotaUser", valid_581529
  var valid_581530 = query.getOrDefault("fields")
  valid_581530 = validateParameter(valid_581530, JString, required = false,
                                 default = nil)
  if valid_581530 != nil:
    section.add "fields", valid_581530
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

proc call*(call_581532: Call_DirectoryUsersPatch_581520; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user. This method supports patch semantics.
  ## 
  let valid = call_581532.validator(path, query, header, formData, body)
  let scheme = call_581532.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581532.url(scheme.get, call_581532.host, call_581532.base,
                         call_581532.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581532, url, valid)

proc call*(call_581533: Call_DirectoryUsersPatch_581520; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryUsersPatch
  ## update user. This method supports patch semantics.
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user. If ID, it should match with id of user object
  var path_581534 = newJObject()
  var query_581535 = newJObject()
  var body_581536 = newJObject()
  add(query_581535, "key", newJString(key))
  add(query_581535, "prettyPrint", newJBool(prettyPrint))
  add(query_581535, "oauth_token", newJString(oauthToken))
  add(query_581535, "alt", newJString(alt))
  add(query_581535, "userIp", newJString(userIp))
  add(query_581535, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581536 = body
  add(query_581535, "fields", newJString(fields))
  add(path_581534, "userKey", newJString(userKey))
  result = call_581533.call(path_581534, query_581535, nil, nil, body_581536)

var directoryUsersPatch* = Call_DirectoryUsersPatch_581520(
    name: "directoryUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersPatch_581521, base: "/admin/directory/v1",
    url: url_DirectoryUsersPatch_581522, schemes: {Scheme.Https})
type
  Call_DirectoryUsersDelete_581505 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersDelete_581507(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersDelete_581506(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581508 = path.getOrDefault("userKey")
  valid_581508 = validateParameter(valid_581508, JString, required = true,
                                 default = nil)
  if valid_581508 != nil:
    section.add "userKey", valid_581508
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
  var valid_581509 = query.getOrDefault("key")
  valid_581509 = validateParameter(valid_581509, JString, required = false,
                                 default = nil)
  if valid_581509 != nil:
    section.add "key", valid_581509
  var valid_581510 = query.getOrDefault("prettyPrint")
  valid_581510 = validateParameter(valid_581510, JBool, required = false,
                                 default = newJBool(true))
  if valid_581510 != nil:
    section.add "prettyPrint", valid_581510
  var valid_581511 = query.getOrDefault("oauth_token")
  valid_581511 = validateParameter(valid_581511, JString, required = false,
                                 default = nil)
  if valid_581511 != nil:
    section.add "oauth_token", valid_581511
  var valid_581512 = query.getOrDefault("alt")
  valid_581512 = validateParameter(valid_581512, JString, required = false,
                                 default = newJString("json"))
  if valid_581512 != nil:
    section.add "alt", valid_581512
  var valid_581513 = query.getOrDefault("userIp")
  valid_581513 = validateParameter(valid_581513, JString, required = false,
                                 default = nil)
  if valid_581513 != nil:
    section.add "userIp", valid_581513
  var valid_581514 = query.getOrDefault("quotaUser")
  valid_581514 = validateParameter(valid_581514, JString, required = false,
                                 default = nil)
  if valid_581514 != nil:
    section.add "quotaUser", valid_581514
  var valid_581515 = query.getOrDefault("fields")
  valid_581515 = validateParameter(valid_581515, JString, required = false,
                                 default = nil)
  if valid_581515 != nil:
    section.add "fields", valid_581515
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581516: Call_DirectoryUsersDelete_581505; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user
  ## 
  let valid = call_581516.validator(path, query, header, formData, body)
  let scheme = call_581516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581516.url(scheme.get, call_581516.host, call_581516.base,
                         call_581516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581516, url, valid)

proc call*(call_581517: Call_DirectoryUsersDelete_581505; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryUsersDelete
  ## Delete user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581518 = newJObject()
  var query_581519 = newJObject()
  add(query_581519, "key", newJString(key))
  add(query_581519, "prettyPrint", newJBool(prettyPrint))
  add(query_581519, "oauth_token", newJString(oauthToken))
  add(query_581519, "alt", newJString(alt))
  add(query_581519, "userIp", newJString(userIp))
  add(query_581519, "quotaUser", newJString(quotaUser))
  add(query_581519, "fields", newJString(fields))
  add(path_581518, "userKey", newJString(userKey))
  result = call_581517.call(path_581518, query_581519, nil, nil, nil)

var directoryUsersDelete* = Call_DirectoryUsersDelete_581505(
    name: "directoryUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersDelete_581506, base: "/admin/directory/v1",
    url: url_DirectoryUsersDelete_581507, schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesInsert_581553 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersAliasesInsert_581555(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/aliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersAliasesInsert_581554(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a alias for the user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581556 = path.getOrDefault("userKey")
  valid_581556 = validateParameter(valid_581556, JString, required = true,
                                 default = nil)
  if valid_581556 != nil:
    section.add "userKey", valid_581556
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
  var valid_581557 = query.getOrDefault("key")
  valid_581557 = validateParameter(valid_581557, JString, required = false,
                                 default = nil)
  if valid_581557 != nil:
    section.add "key", valid_581557
  var valid_581558 = query.getOrDefault("prettyPrint")
  valid_581558 = validateParameter(valid_581558, JBool, required = false,
                                 default = newJBool(true))
  if valid_581558 != nil:
    section.add "prettyPrint", valid_581558
  var valid_581559 = query.getOrDefault("oauth_token")
  valid_581559 = validateParameter(valid_581559, JString, required = false,
                                 default = nil)
  if valid_581559 != nil:
    section.add "oauth_token", valid_581559
  var valid_581560 = query.getOrDefault("alt")
  valid_581560 = validateParameter(valid_581560, JString, required = false,
                                 default = newJString("json"))
  if valid_581560 != nil:
    section.add "alt", valid_581560
  var valid_581561 = query.getOrDefault("userIp")
  valid_581561 = validateParameter(valid_581561, JString, required = false,
                                 default = nil)
  if valid_581561 != nil:
    section.add "userIp", valid_581561
  var valid_581562 = query.getOrDefault("quotaUser")
  valid_581562 = validateParameter(valid_581562, JString, required = false,
                                 default = nil)
  if valid_581562 != nil:
    section.add "quotaUser", valid_581562
  var valid_581563 = query.getOrDefault("fields")
  valid_581563 = validateParameter(valid_581563, JString, required = false,
                                 default = nil)
  if valid_581563 != nil:
    section.add "fields", valid_581563
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

proc call*(call_581565: Call_DirectoryUsersAliasesInsert_581553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the user
  ## 
  let valid = call_581565.validator(path, query, header, formData, body)
  let scheme = call_581565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581565.url(scheme.get, call_581565.host, call_581565.base,
                         call_581565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581565, url, valid)

proc call*(call_581566: Call_DirectoryUsersAliasesInsert_581553; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryUsersAliasesInsert
  ## Add a alias for the user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581567 = newJObject()
  var query_581568 = newJObject()
  var body_581569 = newJObject()
  add(query_581568, "key", newJString(key))
  add(query_581568, "prettyPrint", newJBool(prettyPrint))
  add(query_581568, "oauth_token", newJString(oauthToken))
  add(query_581568, "alt", newJString(alt))
  add(query_581568, "userIp", newJString(userIp))
  add(query_581568, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581569 = body
  add(query_581568, "fields", newJString(fields))
  add(path_581567, "userKey", newJString(userKey))
  result = call_581566.call(path_581567, query_581568, nil, nil, body_581569)

var directoryUsersAliasesInsert* = Call_DirectoryUsersAliasesInsert_581553(
    name: "directoryUsersAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesInsert_581554,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesInsert_581555,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesList_581537 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersAliasesList_581539(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/aliases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersAliasesList_581538(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## List all aliases for a user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581540 = path.getOrDefault("userKey")
  valid_581540 = validateParameter(valid_581540, JString, required = true,
                                 default = nil)
  if valid_581540 != nil:
    section.add "userKey", valid_581540
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   event: JString
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581541 = query.getOrDefault("key")
  valid_581541 = validateParameter(valid_581541, JString, required = false,
                                 default = nil)
  if valid_581541 != nil:
    section.add "key", valid_581541
  var valid_581542 = query.getOrDefault("prettyPrint")
  valid_581542 = validateParameter(valid_581542, JBool, required = false,
                                 default = newJBool(true))
  if valid_581542 != nil:
    section.add "prettyPrint", valid_581542
  var valid_581543 = query.getOrDefault("oauth_token")
  valid_581543 = validateParameter(valid_581543, JString, required = false,
                                 default = nil)
  if valid_581543 != nil:
    section.add "oauth_token", valid_581543
  var valid_581544 = query.getOrDefault("event")
  valid_581544 = validateParameter(valid_581544, JString, required = false,
                                 default = newJString("add"))
  if valid_581544 != nil:
    section.add "event", valid_581544
  var valid_581545 = query.getOrDefault("alt")
  valid_581545 = validateParameter(valid_581545, JString, required = false,
                                 default = newJString("json"))
  if valid_581545 != nil:
    section.add "alt", valid_581545
  var valid_581546 = query.getOrDefault("userIp")
  valid_581546 = validateParameter(valid_581546, JString, required = false,
                                 default = nil)
  if valid_581546 != nil:
    section.add "userIp", valid_581546
  var valid_581547 = query.getOrDefault("quotaUser")
  valid_581547 = validateParameter(valid_581547, JString, required = false,
                                 default = nil)
  if valid_581547 != nil:
    section.add "quotaUser", valid_581547
  var valid_581548 = query.getOrDefault("fields")
  valid_581548 = validateParameter(valid_581548, JString, required = false,
                                 default = nil)
  if valid_581548 != nil:
    section.add "fields", valid_581548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581549: Call_DirectoryUsersAliasesList_581537; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a user
  ## 
  let valid = call_581549.validator(path, query, header, formData, body)
  let scheme = call_581549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581549.url(scheme.get, call_581549.host, call_581549.base,
                         call_581549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581549, url, valid)

proc call*(call_581550: Call_DirectoryUsersAliasesList_581537; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          event: string = "add"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryUsersAliasesList
  ## List all aliases for a user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   event: string
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581551 = newJObject()
  var query_581552 = newJObject()
  add(query_581552, "key", newJString(key))
  add(query_581552, "prettyPrint", newJBool(prettyPrint))
  add(query_581552, "oauth_token", newJString(oauthToken))
  add(query_581552, "event", newJString(event))
  add(query_581552, "alt", newJString(alt))
  add(query_581552, "userIp", newJString(userIp))
  add(query_581552, "quotaUser", newJString(quotaUser))
  add(query_581552, "fields", newJString(fields))
  add(path_581551, "userKey", newJString(userKey))
  result = call_581550.call(path_581551, query_581552, nil, nil, nil)

var directoryUsersAliasesList* = Call_DirectoryUsersAliasesList_581537(
    name: "directoryUsersAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesList_581538,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesList_581539,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesWatch_581570 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersAliasesWatch_581572(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/aliases/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersAliasesWatch_581571(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes in user aliases list
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581573 = path.getOrDefault("userKey")
  valid_581573 = validateParameter(valid_581573, JString, required = true,
                                 default = nil)
  if valid_581573 != nil:
    section.add "userKey", valid_581573
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   event: JString
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: JString
  ##      : Data format for the response.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  section = newJObject()
  var valid_581574 = query.getOrDefault("key")
  valid_581574 = validateParameter(valid_581574, JString, required = false,
                                 default = nil)
  if valid_581574 != nil:
    section.add "key", valid_581574
  var valid_581575 = query.getOrDefault("prettyPrint")
  valid_581575 = validateParameter(valid_581575, JBool, required = false,
                                 default = newJBool(true))
  if valid_581575 != nil:
    section.add "prettyPrint", valid_581575
  var valid_581576 = query.getOrDefault("oauth_token")
  valid_581576 = validateParameter(valid_581576, JString, required = false,
                                 default = nil)
  if valid_581576 != nil:
    section.add "oauth_token", valid_581576
  var valid_581577 = query.getOrDefault("event")
  valid_581577 = validateParameter(valid_581577, JString, required = false,
                                 default = newJString("add"))
  if valid_581577 != nil:
    section.add "event", valid_581577
  var valid_581578 = query.getOrDefault("alt")
  valid_581578 = validateParameter(valid_581578, JString, required = false,
                                 default = newJString("json"))
  if valid_581578 != nil:
    section.add "alt", valid_581578
  var valid_581579 = query.getOrDefault("userIp")
  valid_581579 = validateParameter(valid_581579, JString, required = false,
                                 default = nil)
  if valid_581579 != nil:
    section.add "userIp", valid_581579
  var valid_581580 = query.getOrDefault("quotaUser")
  valid_581580 = validateParameter(valid_581580, JString, required = false,
                                 default = nil)
  if valid_581580 != nil:
    section.add "quotaUser", valid_581580
  var valid_581581 = query.getOrDefault("fields")
  valid_581581 = validateParameter(valid_581581, JString, required = false,
                                 default = nil)
  if valid_581581 != nil:
    section.add "fields", valid_581581
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_581583: Call_DirectoryUsersAliasesWatch_581570; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in user aliases list
  ## 
  let valid = call_581583.validator(path, query, header, formData, body)
  let scheme = call_581583.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581583.url(scheme.get, call_581583.host, call_581583.base,
                         call_581583.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581583, url, valid)

proc call*(call_581584: Call_DirectoryUsersAliasesWatch_581570; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          event: string = "add"; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; resource: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryUsersAliasesWatch
  ## Watch for changes in user aliases list
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   event: string
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   resource: JObject
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581585 = newJObject()
  var query_581586 = newJObject()
  var body_581587 = newJObject()
  add(query_581586, "key", newJString(key))
  add(query_581586, "prettyPrint", newJBool(prettyPrint))
  add(query_581586, "oauth_token", newJString(oauthToken))
  add(query_581586, "event", newJString(event))
  add(query_581586, "alt", newJString(alt))
  add(query_581586, "userIp", newJString(userIp))
  add(query_581586, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_581587 = resource
  add(query_581586, "fields", newJString(fields))
  add(path_581585, "userKey", newJString(userKey))
  result = call_581584.call(path_581585, query_581586, nil, nil, body_581587)

var directoryUsersAliasesWatch* = Call_DirectoryUsersAliasesWatch_581570(
    name: "directoryUsersAliasesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/watch",
    validator: validate_DirectoryUsersAliasesWatch_581571,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesWatch_581572,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesDelete_581588 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersAliasesDelete_581590(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  assert "alias" in path, "`alias` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/aliases/"),
               (kind: VariableSegment, value: "alias")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersAliasesDelete_581589(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove a alias for the user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   alias: JString (required)
  ##        : The alias to be removed
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `alias` field"
  var valid_581591 = path.getOrDefault("alias")
  valid_581591 = validateParameter(valid_581591, JString, required = true,
                                 default = nil)
  if valid_581591 != nil:
    section.add "alias", valid_581591
  var valid_581592 = path.getOrDefault("userKey")
  valid_581592 = validateParameter(valid_581592, JString, required = true,
                                 default = nil)
  if valid_581592 != nil:
    section.add "userKey", valid_581592
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
  var valid_581593 = query.getOrDefault("key")
  valid_581593 = validateParameter(valid_581593, JString, required = false,
                                 default = nil)
  if valid_581593 != nil:
    section.add "key", valid_581593
  var valid_581594 = query.getOrDefault("prettyPrint")
  valid_581594 = validateParameter(valid_581594, JBool, required = false,
                                 default = newJBool(true))
  if valid_581594 != nil:
    section.add "prettyPrint", valid_581594
  var valid_581595 = query.getOrDefault("oauth_token")
  valid_581595 = validateParameter(valid_581595, JString, required = false,
                                 default = nil)
  if valid_581595 != nil:
    section.add "oauth_token", valid_581595
  var valid_581596 = query.getOrDefault("alt")
  valid_581596 = validateParameter(valid_581596, JString, required = false,
                                 default = newJString("json"))
  if valid_581596 != nil:
    section.add "alt", valid_581596
  var valid_581597 = query.getOrDefault("userIp")
  valid_581597 = validateParameter(valid_581597, JString, required = false,
                                 default = nil)
  if valid_581597 != nil:
    section.add "userIp", valid_581597
  var valid_581598 = query.getOrDefault("quotaUser")
  valid_581598 = validateParameter(valid_581598, JString, required = false,
                                 default = nil)
  if valid_581598 != nil:
    section.add "quotaUser", valid_581598
  var valid_581599 = query.getOrDefault("fields")
  valid_581599 = validateParameter(valid_581599, JString, required = false,
                                 default = nil)
  if valid_581599 != nil:
    section.add "fields", valid_581599
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581600: Call_DirectoryUsersAliasesDelete_581588; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the user
  ## 
  let valid = call_581600.validator(path, query, header, formData, body)
  let scheme = call_581600.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581600.url(scheme.get, call_581600.host, call_581600.base,
                         call_581600.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581600, url, valid)

proc call*(call_581601: Call_DirectoryUsersAliasesDelete_581588; alias: string;
          userKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryUsersAliasesDelete
  ## Remove a alias for the user
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
  ##   alias: string (required)
  ##        : The alias to be removed
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581602 = newJObject()
  var query_581603 = newJObject()
  add(query_581603, "key", newJString(key))
  add(query_581603, "prettyPrint", newJBool(prettyPrint))
  add(query_581603, "oauth_token", newJString(oauthToken))
  add(query_581603, "alt", newJString(alt))
  add(query_581603, "userIp", newJString(userIp))
  add(query_581603, "quotaUser", newJString(quotaUser))
  add(path_581602, "alias", newJString(alias))
  add(query_581603, "fields", newJString(fields))
  add(path_581602, "userKey", newJString(userKey))
  result = call_581601.call(path_581602, query_581603, nil, nil, nil)

var directoryUsersAliasesDelete* = Call_DirectoryUsersAliasesDelete_581588(
    name: "directoryUsersAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/{alias}",
    validator: validate_DirectoryUsersAliasesDelete_581589,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesDelete_581590,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsList_581604 = ref object of OpenApiRestCall_579389
proc url_DirectoryAspsList_581606(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/asps")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryAspsList_581605(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## List the ASPs issued by a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581607 = path.getOrDefault("userKey")
  valid_581607 = validateParameter(valid_581607, JString, required = true,
                                 default = nil)
  if valid_581607 != nil:
    section.add "userKey", valid_581607
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
  var valid_581608 = query.getOrDefault("key")
  valid_581608 = validateParameter(valid_581608, JString, required = false,
                                 default = nil)
  if valid_581608 != nil:
    section.add "key", valid_581608
  var valid_581609 = query.getOrDefault("prettyPrint")
  valid_581609 = validateParameter(valid_581609, JBool, required = false,
                                 default = newJBool(true))
  if valid_581609 != nil:
    section.add "prettyPrint", valid_581609
  var valid_581610 = query.getOrDefault("oauth_token")
  valid_581610 = validateParameter(valid_581610, JString, required = false,
                                 default = nil)
  if valid_581610 != nil:
    section.add "oauth_token", valid_581610
  var valid_581611 = query.getOrDefault("alt")
  valid_581611 = validateParameter(valid_581611, JString, required = false,
                                 default = newJString("json"))
  if valid_581611 != nil:
    section.add "alt", valid_581611
  var valid_581612 = query.getOrDefault("userIp")
  valid_581612 = validateParameter(valid_581612, JString, required = false,
                                 default = nil)
  if valid_581612 != nil:
    section.add "userIp", valid_581612
  var valid_581613 = query.getOrDefault("quotaUser")
  valid_581613 = validateParameter(valid_581613, JString, required = false,
                                 default = nil)
  if valid_581613 != nil:
    section.add "quotaUser", valid_581613
  var valid_581614 = query.getOrDefault("fields")
  valid_581614 = validateParameter(valid_581614, JString, required = false,
                                 default = nil)
  if valid_581614 != nil:
    section.add "fields", valid_581614
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581615: Call_DirectoryAspsList_581604; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the ASPs issued by a user.
  ## 
  let valid = call_581615.validator(path, query, header, formData, body)
  let scheme = call_581615.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581615.url(scheme.get, call_581615.host, call_581615.base,
                         call_581615.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581615, url, valid)

proc call*(call_581616: Call_DirectoryAspsList_581604; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryAspsList
  ## List the ASPs issued by a user.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  var path_581617 = newJObject()
  var query_581618 = newJObject()
  add(query_581618, "key", newJString(key))
  add(query_581618, "prettyPrint", newJBool(prettyPrint))
  add(query_581618, "oauth_token", newJString(oauthToken))
  add(query_581618, "alt", newJString(alt))
  add(query_581618, "userIp", newJString(userIp))
  add(query_581618, "quotaUser", newJString(quotaUser))
  add(query_581618, "fields", newJString(fields))
  add(path_581617, "userKey", newJString(userKey))
  result = call_581616.call(path_581617, query_581618, nil, nil, nil)

var directoryAspsList* = Call_DirectoryAspsList_581604(name: "directoryAspsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps", validator: validate_DirectoryAspsList_581605,
    base: "/admin/directory/v1", url: url_DirectoryAspsList_581606,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsGet_581619 = ref object of OpenApiRestCall_579389
proc url_DirectoryAspsGet_581621(protocol: Scheme; host: string; base: string;
                                route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  assert "codeId" in path, "`codeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/asps/"),
               (kind: VariableSegment, value: "codeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryAspsGet_581620(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get information about an ASP issued by a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   codeId: JInt (required)
  ##         : The unique ID of the ASP.
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `codeId` field"
  var valid_581622 = path.getOrDefault("codeId")
  valid_581622 = validateParameter(valid_581622, JInt, required = true, default = nil)
  if valid_581622 != nil:
    section.add "codeId", valid_581622
  var valid_581623 = path.getOrDefault("userKey")
  valid_581623 = validateParameter(valid_581623, JString, required = true,
                                 default = nil)
  if valid_581623 != nil:
    section.add "userKey", valid_581623
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
  var valid_581624 = query.getOrDefault("key")
  valid_581624 = validateParameter(valid_581624, JString, required = false,
                                 default = nil)
  if valid_581624 != nil:
    section.add "key", valid_581624
  var valid_581625 = query.getOrDefault("prettyPrint")
  valid_581625 = validateParameter(valid_581625, JBool, required = false,
                                 default = newJBool(true))
  if valid_581625 != nil:
    section.add "prettyPrint", valid_581625
  var valid_581626 = query.getOrDefault("oauth_token")
  valid_581626 = validateParameter(valid_581626, JString, required = false,
                                 default = nil)
  if valid_581626 != nil:
    section.add "oauth_token", valid_581626
  var valid_581627 = query.getOrDefault("alt")
  valid_581627 = validateParameter(valid_581627, JString, required = false,
                                 default = newJString("json"))
  if valid_581627 != nil:
    section.add "alt", valid_581627
  var valid_581628 = query.getOrDefault("userIp")
  valid_581628 = validateParameter(valid_581628, JString, required = false,
                                 default = nil)
  if valid_581628 != nil:
    section.add "userIp", valid_581628
  var valid_581629 = query.getOrDefault("quotaUser")
  valid_581629 = validateParameter(valid_581629, JString, required = false,
                                 default = nil)
  if valid_581629 != nil:
    section.add "quotaUser", valid_581629
  var valid_581630 = query.getOrDefault("fields")
  valid_581630 = validateParameter(valid_581630, JString, required = false,
                                 default = nil)
  if valid_581630 != nil:
    section.add "fields", valid_581630
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581631: Call_DirectoryAspsGet_581619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an ASP issued by a user.
  ## 
  let valid = call_581631.validator(path, query, header, formData, body)
  let scheme = call_581631.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581631.url(scheme.get, call_581631.host, call_581631.base,
                         call_581631.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581631, url, valid)

proc call*(call_581632: Call_DirectoryAspsGet_581619; codeId: int; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryAspsGet
  ## Get information about an ASP issued by a user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   codeId: int (required)
  ##         : The unique ID of the ASP.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  var path_581633 = newJObject()
  var query_581634 = newJObject()
  add(query_581634, "key", newJString(key))
  add(query_581634, "prettyPrint", newJBool(prettyPrint))
  add(query_581634, "oauth_token", newJString(oauthToken))
  add(path_581633, "codeId", newJInt(codeId))
  add(query_581634, "alt", newJString(alt))
  add(query_581634, "userIp", newJString(userIp))
  add(query_581634, "quotaUser", newJString(quotaUser))
  add(query_581634, "fields", newJString(fields))
  add(path_581633, "userKey", newJString(userKey))
  result = call_581632.call(path_581633, query_581634, nil, nil, nil)

var directoryAspsGet* = Call_DirectoryAspsGet_581619(name: "directoryAspsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps/{codeId}", validator: validate_DirectoryAspsGet_581620,
    base: "/admin/directory/v1", url: url_DirectoryAspsGet_581621,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsDelete_581635 = ref object of OpenApiRestCall_579389
proc url_DirectoryAspsDelete_581637(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  assert "codeId" in path, "`codeId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/asps/"),
               (kind: VariableSegment, value: "codeId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryAspsDelete_581636(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete an ASP issued by a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   codeId: JInt (required)
  ##         : The unique ID of the ASP to be deleted.
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `codeId` field"
  var valid_581638 = path.getOrDefault("codeId")
  valid_581638 = validateParameter(valid_581638, JInt, required = true, default = nil)
  if valid_581638 != nil:
    section.add "codeId", valid_581638
  var valid_581639 = path.getOrDefault("userKey")
  valid_581639 = validateParameter(valid_581639, JString, required = true,
                                 default = nil)
  if valid_581639 != nil:
    section.add "userKey", valid_581639
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
  var valid_581640 = query.getOrDefault("key")
  valid_581640 = validateParameter(valid_581640, JString, required = false,
                                 default = nil)
  if valid_581640 != nil:
    section.add "key", valid_581640
  var valid_581641 = query.getOrDefault("prettyPrint")
  valid_581641 = validateParameter(valid_581641, JBool, required = false,
                                 default = newJBool(true))
  if valid_581641 != nil:
    section.add "prettyPrint", valid_581641
  var valid_581642 = query.getOrDefault("oauth_token")
  valid_581642 = validateParameter(valid_581642, JString, required = false,
                                 default = nil)
  if valid_581642 != nil:
    section.add "oauth_token", valid_581642
  var valid_581643 = query.getOrDefault("alt")
  valid_581643 = validateParameter(valid_581643, JString, required = false,
                                 default = newJString("json"))
  if valid_581643 != nil:
    section.add "alt", valid_581643
  var valid_581644 = query.getOrDefault("userIp")
  valid_581644 = validateParameter(valid_581644, JString, required = false,
                                 default = nil)
  if valid_581644 != nil:
    section.add "userIp", valid_581644
  var valid_581645 = query.getOrDefault("quotaUser")
  valid_581645 = validateParameter(valid_581645, JString, required = false,
                                 default = nil)
  if valid_581645 != nil:
    section.add "quotaUser", valid_581645
  var valid_581646 = query.getOrDefault("fields")
  valid_581646 = validateParameter(valid_581646, JString, required = false,
                                 default = nil)
  if valid_581646 != nil:
    section.add "fields", valid_581646
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581647: Call_DirectoryAspsDelete_581635; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an ASP issued by a user.
  ## 
  let valid = call_581647.validator(path, query, header, formData, body)
  let scheme = call_581647.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581647.url(scheme.get, call_581647.host, call_581647.base,
                         call_581647.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581647, url, valid)

proc call*(call_581648: Call_DirectoryAspsDelete_581635; codeId: int;
          userKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryAspsDelete
  ## Delete an ASP issued by a user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   codeId: int (required)
  ##         : The unique ID of the ASP to be deleted.
  ##   alt: string
  ##      : Data format for the response.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  var path_581649 = newJObject()
  var query_581650 = newJObject()
  add(query_581650, "key", newJString(key))
  add(query_581650, "prettyPrint", newJBool(prettyPrint))
  add(query_581650, "oauth_token", newJString(oauthToken))
  add(path_581649, "codeId", newJInt(codeId))
  add(query_581650, "alt", newJString(alt))
  add(query_581650, "userIp", newJString(userIp))
  add(query_581650, "quotaUser", newJString(quotaUser))
  add(query_581650, "fields", newJString(fields))
  add(path_581649, "userKey", newJString(userKey))
  result = call_581648.call(path_581649, query_581650, nil, nil, nil)

var directoryAspsDelete* = Call_DirectoryAspsDelete_581635(
    name: "directoryAspsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/asps/{codeId}",
    validator: validate_DirectoryAspsDelete_581636, base: "/admin/directory/v1",
    url: url_DirectoryAspsDelete_581637, schemes: {Scheme.Https})
type
  Call_DirectoryUsersMakeAdmin_581651 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersMakeAdmin_581653(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/makeAdmin")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersMakeAdmin_581652(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## change admin status of a user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user as admin
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581654 = path.getOrDefault("userKey")
  valid_581654 = validateParameter(valid_581654, JString, required = true,
                                 default = nil)
  if valid_581654 != nil:
    section.add "userKey", valid_581654
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
  var valid_581655 = query.getOrDefault("key")
  valid_581655 = validateParameter(valid_581655, JString, required = false,
                                 default = nil)
  if valid_581655 != nil:
    section.add "key", valid_581655
  var valid_581656 = query.getOrDefault("prettyPrint")
  valid_581656 = validateParameter(valid_581656, JBool, required = false,
                                 default = newJBool(true))
  if valid_581656 != nil:
    section.add "prettyPrint", valid_581656
  var valid_581657 = query.getOrDefault("oauth_token")
  valid_581657 = validateParameter(valid_581657, JString, required = false,
                                 default = nil)
  if valid_581657 != nil:
    section.add "oauth_token", valid_581657
  var valid_581658 = query.getOrDefault("alt")
  valid_581658 = validateParameter(valid_581658, JString, required = false,
                                 default = newJString("json"))
  if valid_581658 != nil:
    section.add "alt", valid_581658
  var valid_581659 = query.getOrDefault("userIp")
  valid_581659 = validateParameter(valid_581659, JString, required = false,
                                 default = nil)
  if valid_581659 != nil:
    section.add "userIp", valid_581659
  var valid_581660 = query.getOrDefault("quotaUser")
  valid_581660 = validateParameter(valid_581660, JString, required = false,
                                 default = nil)
  if valid_581660 != nil:
    section.add "quotaUser", valid_581660
  var valid_581661 = query.getOrDefault("fields")
  valid_581661 = validateParameter(valid_581661, JString, required = false,
                                 default = nil)
  if valid_581661 != nil:
    section.add "fields", valid_581661
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

proc call*(call_581663: Call_DirectoryUsersMakeAdmin_581651; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## change admin status of a user
  ## 
  let valid = call_581663.validator(path, query, header, formData, body)
  let scheme = call_581663.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581663.url(scheme.get, call_581663.host, call_581663.base,
                         call_581663.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581663, url, valid)

proc call*(call_581664: Call_DirectoryUsersMakeAdmin_581651; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryUsersMakeAdmin
  ## change admin status of a user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user as admin
  var path_581665 = newJObject()
  var query_581666 = newJObject()
  var body_581667 = newJObject()
  add(query_581666, "key", newJString(key))
  add(query_581666, "prettyPrint", newJBool(prettyPrint))
  add(query_581666, "oauth_token", newJString(oauthToken))
  add(query_581666, "alt", newJString(alt))
  add(query_581666, "userIp", newJString(userIp))
  add(query_581666, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581667 = body
  add(query_581666, "fields", newJString(fields))
  add(path_581665, "userKey", newJString(userKey))
  result = call_581664.call(path_581665, query_581666, nil, nil, body_581667)

var directoryUsersMakeAdmin* = Call_DirectoryUsersMakeAdmin_581651(
    name: "directoryUsersMakeAdmin", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/makeAdmin",
    validator: validate_DirectoryUsersMakeAdmin_581652,
    base: "/admin/directory/v1", url: url_DirectoryUsersMakeAdmin_581653,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosUpdate_581683 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersPhotosUpdate_581685(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/photos/thumbnail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersPhotosUpdate_581684(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a photo for the user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581686 = path.getOrDefault("userKey")
  valid_581686 = validateParameter(valid_581686, JString, required = true,
                                 default = nil)
  if valid_581686 != nil:
    section.add "userKey", valid_581686
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
  var valid_581687 = query.getOrDefault("key")
  valid_581687 = validateParameter(valid_581687, JString, required = false,
                                 default = nil)
  if valid_581687 != nil:
    section.add "key", valid_581687
  var valid_581688 = query.getOrDefault("prettyPrint")
  valid_581688 = validateParameter(valid_581688, JBool, required = false,
                                 default = newJBool(true))
  if valid_581688 != nil:
    section.add "prettyPrint", valid_581688
  var valid_581689 = query.getOrDefault("oauth_token")
  valid_581689 = validateParameter(valid_581689, JString, required = false,
                                 default = nil)
  if valid_581689 != nil:
    section.add "oauth_token", valid_581689
  var valid_581690 = query.getOrDefault("alt")
  valid_581690 = validateParameter(valid_581690, JString, required = false,
                                 default = newJString("json"))
  if valid_581690 != nil:
    section.add "alt", valid_581690
  var valid_581691 = query.getOrDefault("userIp")
  valid_581691 = validateParameter(valid_581691, JString, required = false,
                                 default = nil)
  if valid_581691 != nil:
    section.add "userIp", valid_581691
  var valid_581692 = query.getOrDefault("quotaUser")
  valid_581692 = validateParameter(valid_581692, JString, required = false,
                                 default = nil)
  if valid_581692 != nil:
    section.add "quotaUser", valid_581692
  var valid_581693 = query.getOrDefault("fields")
  valid_581693 = validateParameter(valid_581693, JString, required = false,
                                 default = nil)
  if valid_581693 != nil:
    section.add "fields", valid_581693
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

proc call*(call_581695: Call_DirectoryUsersPhotosUpdate_581683; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user
  ## 
  let valid = call_581695.validator(path, query, header, formData, body)
  let scheme = call_581695.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581695.url(scheme.get, call_581695.host, call_581695.base,
                         call_581695.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581695, url, valid)

proc call*(call_581696: Call_DirectoryUsersPhotosUpdate_581683; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryUsersPhotosUpdate
  ## Add a photo for the user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581697 = newJObject()
  var query_581698 = newJObject()
  var body_581699 = newJObject()
  add(query_581698, "key", newJString(key))
  add(query_581698, "prettyPrint", newJBool(prettyPrint))
  add(query_581698, "oauth_token", newJString(oauthToken))
  add(query_581698, "alt", newJString(alt))
  add(query_581698, "userIp", newJString(userIp))
  add(query_581698, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581699 = body
  add(query_581698, "fields", newJString(fields))
  add(path_581697, "userKey", newJString(userKey))
  result = call_581696.call(path_581697, query_581698, nil, nil, body_581699)

var directoryUsersPhotosUpdate* = Call_DirectoryUsersPhotosUpdate_581683(
    name: "directoryUsersPhotosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosUpdate_581684,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosUpdate_581685,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosGet_581668 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersPhotosGet_581670(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/photos/thumbnail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersPhotosGet_581669(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve photo of a user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581671 = path.getOrDefault("userKey")
  valid_581671 = validateParameter(valid_581671, JString, required = true,
                                 default = nil)
  if valid_581671 != nil:
    section.add "userKey", valid_581671
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
  var valid_581672 = query.getOrDefault("key")
  valid_581672 = validateParameter(valid_581672, JString, required = false,
                                 default = nil)
  if valid_581672 != nil:
    section.add "key", valid_581672
  var valid_581673 = query.getOrDefault("prettyPrint")
  valid_581673 = validateParameter(valid_581673, JBool, required = false,
                                 default = newJBool(true))
  if valid_581673 != nil:
    section.add "prettyPrint", valid_581673
  var valid_581674 = query.getOrDefault("oauth_token")
  valid_581674 = validateParameter(valid_581674, JString, required = false,
                                 default = nil)
  if valid_581674 != nil:
    section.add "oauth_token", valid_581674
  var valid_581675 = query.getOrDefault("alt")
  valid_581675 = validateParameter(valid_581675, JString, required = false,
                                 default = newJString("json"))
  if valid_581675 != nil:
    section.add "alt", valid_581675
  var valid_581676 = query.getOrDefault("userIp")
  valid_581676 = validateParameter(valid_581676, JString, required = false,
                                 default = nil)
  if valid_581676 != nil:
    section.add "userIp", valid_581676
  var valid_581677 = query.getOrDefault("quotaUser")
  valid_581677 = validateParameter(valid_581677, JString, required = false,
                                 default = nil)
  if valid_581677 != nil:
    section.add "quotaUser", valid_581677
  var valid_581678 = query.getOrDefault("fields")
  valid_581678 = validateParameter(valid_581678, JString, required = false,
                                 default = nil)
  if valid_581678 != nil:
    section.add "fields", valid_581678
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581679: Call_DirectoryUsersPhotosGet_581668; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve photo of a user
  ## 
  let valid = call_581679.validator(path, query, header, formData, body)
  let scheme = call_581679.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581679.url(scheme.get, call_581679.host, call_581679.base,
                         call_581679.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581679, url, valid)

proc call*(call_581680: Call_DirectoryUsersPhotosGet_581668; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryUsersPhotosGet
  ## Retrieve photo of a user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581681 = newJObject()
  var query_581682 = newJObject()
  add(query_581682, "key", newJString(key))
  add(query_581682, "prettyPrint", newJBool(prettyPrint))
  add(query_581682, "oauth_token", newJString(oauthToken))
  add(query_581682, "alt", newJString(alt))
  add(query_581682, "userIp", newJString(userIp))
  add(query_581682, "quotaUser", newJString(quotaUser))
  add(query_581682, "fields", newJString(fields))
  add(path_581681, "userKey", newJString(userKey))
  result = call_581680.call(path_581681, query_581682, nil, nil, nil)

var directoryUsersPhotosGet* = Call_DirectoryUsersPhotosGet_581668(
    name: "directoryUsersPhotosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosGet_581669,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosGet_581670,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosPatch_581715 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersPhotosPatch_581717(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/photos/thumbnail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersPhotosPatch_581716(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Add a photo for the user. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581718 = path.getOrDefault("userKey")
  valid_581718 = validateParameter(valid_581718, JString, required = true,
                                 default = nil)
  if valid_581718 != nil:
    section.add "userKey", valid_581718
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
  var valid_581719 = query.getOrDefault("key")
  valid_581719 = validateParameter(valid_581719, JString, required = false,
                                 default = nil)
  if valid_581719 != nil:
    section.add "key", valid_581719
  var valid_581720 = query.getOrDefault("prettyPrint")
  valid_581720 = validateParameter(valid_581720, JBool, required = false,
                                 default = newJBool(true))
  if valid_581720 != nil:
    section.add "prettyPrint", valid_581720
  var valid_581721 = query.getOrDefault("oauth_token")
  valid_581721 = validateParameter(valid_581721, JString, required = false,
                                 default = nil)
  if valid_581721 != nil:
    section.add "oauth_token", valid_581721
  var valid_581722 = query.getOrDefault("alt")
  valid_581722 = validateParameter(valid_581722, JString, required = false,
                                 default = newJString("json"))
  if valid_581722 != nil:
    section.add "alt", valid_581722
  var valid_581723 = query.getOrDefault("userIp")
  valid_581723 = validateParameter(valid_581723, JString, required = false,
                                 default = nil)
  if valid_581723 != nil:
    section.add "userIp", valid_581723
  var valid_581724 = query.getOrDefault("quotaUser")
  valid_581724 = validateParameter(valid_581724, JString, required = false,
                                 default = nil)
  if valid_581724 != nil:
    section.add "quotaUser", valid_581724
  var valid_581725 = query.getOrDefault("fields")
  valid_581725 = validateParameter(valid_581725, JString, required = false,
                                 default = nil)
  if valid_581725 != nil:
    section.add "fields", valid_581725
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

proc call*(call_581727: Call_DirectoryUsersPhotosPatch_581715; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user. This method supports patch semantics.
  ## 
  let valid = call_581727.validator(path, query, header, formData, body)
  let scheme = call_581727.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581727.url(scheme.get, call_581727.host, call_581727.base,
                         call_581727.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581727, url, valid)

proc call*(call_581728: Call_DirectoryUsersPhotosPatch_581715; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryUsersPhotosPatch
  ## Add a photo for the user. This method supports patch semantics.
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581729 = newJObject()
  var query_581730 = newJObject()
  var body_581731 = newJObject()
  add(query_581730, "key", newJString(key))
  add(query_581730, "prettyPrint", newJBool(prettyPrint))
  add(query_581730, "oauth_token", newJString(oauthToken))
  add(query_581730, "alt", newJString(alt))
  add(query_581730, "userIp", newJString(userIp))
  add(query_581730, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581731 = body
  add(query_581730, "fields", newJString(fields))
  add(path_581729, "userKey", newJString(userKey))
  result = call_581728.call(path_581729, query_581730, nil, nil, body_581731)

var directoryUsersPhotosPatch* = Call_DirectoryUsersPhotosPatch_581715(
    name: "directoryUsersPhotosPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosPatch_581716,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosPatch_581717,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosDelete_581700 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersPhotosDelete_581702(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/photos/thumbnail")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersPhotosDelete_581701(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove photos for the user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581703 = path.getOrDefault("userKey")
  valid_581703 = validateParameter(valid_581703, JString, required = true,
                                 default = nil)
  if valid_581703 != nil:
    section.add "userKey", valid_581703
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
  var valid_581704 = query.getOrDefault("key")
  valid_581704 = validateParameter(valid_581704, JString, required = false,
                                 default = nil)
  if valid_581704 != nil:
    section.add "key", valid_581704
  var valid_581705 = query.getOrDefault("prettyPrint")
  valid_581705 = validateParameter(valid_581705, JBool, required = false,
                                 default = newJBool(true))
  if valid_581705 != nil:
    section.add "prettyPrint", valid_581705
  var valid_581706 = query.getOrDefault("oauth_token")
  valid_581706 = validateParameter(valid_581706, JString, required = false,
                                 default = nil)
  if valid_581706 != nil:
    section.add "oauth_token", valid_581706
  var valid_581707 = query.getOrDefault("alt")
  valid_581707 = validateParameter(valid_581707, JString, required = false,
                                 default = newJString("json"))
  if valid_581707 != nil:
    section.add "alt", valid_581707
  var valid_581708 = query.getOrDefault("userIp")
  valid_581708 = validateParameter(valid_581708, JString, required = false,
                                 default = nil)
  if valid_581708 != nil:
    section.add "userIp", valid_581708
  var valid_581709 = query.getOrDefault("quotaUser")
  valid_581709 = validateParameter(valid_581709, JString, required = false,
                                 default = nil)
  if valid_581709 != nil:
    section.add "quotaUser", valid_581709
  var valid_581710 = query.getOrDefault("fields")
  valid_581710 = validateParameter(valid_581710, JString, required = false,
                                 default = nil)
  if valid_581710 != nil:
    section.add "fields", valid_581710
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581711: Call_DirectoryUsersPhotosDelete_581700; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove photos for the user
  ## 
  let valid = call_581711.validator(path, query, header, formData, body)
  let scheme = call_581711.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581711.url(scheme.get, call_581711.host, call_581711.base,
                         call_581711.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581711, url, valid)

proc call*(call_581712: Call_DirectoryUsersPhotosDelete_581700; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryUsersPhotosDelete
  ## Remove photos for the user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581713 = newJObject()
  var query_581714 = newJObject()
  add(query_581714, "key", newJString(key))
  add(query_581714, "prettyPrint", newJBool(prettyPrint))
  add(query_581714, "oauth_token", newJString(oauthToken))
  add(query_581714, "alt", newJString(alt))
  add(query_581714, "userIp", newJString(userIp))
  add(query_581714, "quotaUser", newJString(quotaUser))
  add(query_581714, "fields", newJString(fields))
  add(path_581713, "userKey", newJString(userKey))
  result = call_581712.call(path_581713, query_581714, nil, nil, nil)

var directoryUsersPhotosDelete* = Call_DirectoryUsersPhotosDelete_581700(
    name: "directoryUsersPhotosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosDelete_581701,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosDelete_581702,
    schemes: {Scheme.Https})
type
  Call_DirectoryTokensList_581732 = ref object of OpenApiRestCall_579389
proc url_DirectoryTokensList_581734(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/tokens")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryTokensList_581733(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Returns the set of tokens specified user has issued to 3rd party applications.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581735 = path.getOrDefault("userKey")
  valid_581735 = validateParameter(valid_581735, JString, required = true,
                                 default = nil)
  if valid_581735 != nil:
    section.add "userKey", valid_581735
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
  var valid_581736 = query.getOrDefault("key")
  valid_581736 = validateParameter(valid_581736, JString, required = false,
                                 default = nil)
  if valid_581736 != nil:
    section.add "key", valid_581736
  var valid_581737 = query.getOrDefault("prettyPrint")
  valid_581737 = validateParameter(valid_581737, JBool, required = false,
                                 default = newJBool(true))
  if valid_581737 != nil:
    section.add "prettyPrint", valid_581737
  var valid_581738 = query.getOrDefault("oauth_token")
  valid_581738 = validateParameter(valid_581738, JString, required = false,
                                 default = nil)
  if valid_581738 != nil:
    section.add "oauth_token", valid_581738
  var valid_581739 = query.getOrDefault("alt")
  valid_581739 = validateParameter(valid_581739, JString, required = false,
                                 default = newJString("json"))
  if valid_581739 != nil:
    section.add "alt", valid_581739
  var valid_581740 = query.getOrDefault("userIp")
  valid_581740 = validateParameter(valid_581740, JString, required = false,
                                 default = nil)
  if valid_581740 != nil:
    section.add "userIp", valid_581740
  var valid_581741 = query.getOrDefault("quotaUser")
  valid_581741 = validateParameter(valid_581741, JString, required = false,
                                 default = nil)
  if valid_581741 != nil:
    section.add "quotaUser", valid_581741
  var valid_581742 = query.getOrDefault("fields")
  valid_581742 = validateParameter(valid_581742, JString, required = false,
                                 default = nil)
  if valid_581742 != nil:
    section.add "fields", valid_581742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581743: Call_DirectoryTokensList_581732; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the set of tokens specified user has issued to 3rd party applications.
  ## 
  let valid = call_581743.validator(path, query, header, formData, body)
  let scheme = call_581743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581743.url(scheme.get, call_581743.host, call_581743.base,
                         call_581743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581743, url, valid)

proc call*(call_581744: Call_DirectoryTokensList_581732; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          fields: string = ""): Recallable =
  ## directoryTokensList
  ## Returns the set of tokens specified user has issued to 3rd party applications.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  var path_581745 = newJObject()
  var query_581746 = newJObject()
  add(query_581746, "key", newJString(key))
  add(query_581746, "prettyPrint", newJBool(prettyPrint))
  add(query_581746, "oauth_token", newJString(oauthToken))
  add(query_581746, "alt", newJString(alt))
  add(query_581746, "userIp", newJString(userIp))
  add(query_581746, "quotaUser", newJString(quotaUser))
  add(query_581746, "fields", newJString(fields))
  add(path_581745, "userKey", newJString(userKey))
  result = call_581744.call(path_581745, query_581746, nil, nil, nil)

var directoryTokensList* = Call_DirectoryTokensList_581732(
    name: "directoryTokensList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens",
    validator: validate_DirectoryTokensList_581733, base: "/admin/directory/v1",
    url: url_DirectoryTokensList_581734, schemes: {Scheme.Https})
type
  Call_DirectoryTokensGet_581747 = ref object of OpenApiRestCall_579389
proc url_DirectoryTokensGet_581749(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  assert "clientId" in path, "`clientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "clientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryTokensGet_581748(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Get information about an access token issued by a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientId: JString (required)
  ##           : The Client ID of the application the token is issued to.
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `clientId` field"
  var valid_581750 = path.getOrDefault("clientId")
  valid_581750 = validateParameter(valid_581750, JString, required = true,
                                 default = nil)
  if valid_581750 != nil:
    section.add "clientId", valid_581750
  var valid_581751 = path.getOrDefault("userKey")
  valid_581751 = validateParameter(valid_581751, JString, required = true,
                                 default = nil)
  if valid_581751 != nil:
    section.add "userKey", valid_581751
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
  var valid_581752 = query.getOrDefault("key")
  valid_581752 = validateParameter(valid_581752, JString, required = false,
                                 default = nil)
  if valid_581752 != nil:
    section.add "key", valid_581752
  var valid_581753 = query.getOrDefault("prettyPrint")
  valid_581753 = validateParameter(valid_581753, JBool, required = false,
                                 default = newJBool(true))
  if valid_581753 != nil:
    section.add "prettyPrint", valid_581753
  var valid_581754 = query.getOrDefault("oauth_token")
  valid_581754 = validateParameter(valid_581754, JString, required = false,
                                 default = nil)
  if valid_581754 != nil:
    section.add "oauth_token", valid_581754
  var valid_581755 = query.getOrDefault("alt")
  valid_581755 = validateParameter(valid_581755, JString, required = false,
                                 default = newJString("json"))
  if valid_581755 != nil:
    section.add "alt", valid_581755
  var valid_581756 = query.getOrDefault("userIp")
  valid_581756 = validateParameter(valid_581756, JString, required = false,
                                 default = nil)
  if valid_581756 != nil:
    section.add "userIp", valid_581756
  var valid_581757 = query.getOrDefault("quotaUser")
  valid_581757 = validateParameter(valid_581757, JString, required = false,
                                 default = nil)
  if valid_581757 != nil:
    section.add "quotaUser", valid_581757
  var valid_581758 = query.getOrDefault("fields")
  valid_581758 = validateParameter(valid_581758, JString, required = false,
                                 default = nil)
  if valid_581758 != nil:
    section.add "fields", valid_581758
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581759: Call_DirectoryTokensGet_581747; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an access token issued by a user.
  ## 
  let valid = call_581759.validator(path, query, header, formData, body)
  let scheme = call_581759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581759.url(scheme.get, call_581759.host, call_581759.base,
                         call_581759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581759, url, valid)

proc call*(call_581760: Call_DirectoryTokensGet_581747; clientId: string;
          userKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryTokensGet
  ## Get information about an access token issued by a user.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientId: string (required)
  ##           : The Client ID of the application the token is issued to.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  var path_581761 = newJObject()
  var query_581762 = newJObject()
  add(query_581762, "key", newJString(key))
  add(path_581761, "clientId", newJString(clientId))
  add(query_581762, "prettyPrint", newJBool(prettyPrint))
  add(query_581762, "oauth_token", newJString(oauthToken))
  add(query_581762, "alt", newJString(alt))
  add(query_581762, "userIp", newJString(userIp))
  add(query_581762, "quotaUser", newJString(quotaUser))
  add(query_581762, "fields", newJString(fields))
  add(path_581761, "userKey", newJString(userKey))
  result = call_581760.call(path_581761, query_581762, nil, nil, nil)

var directoryTokensGet* = Call_DirectoryTokensGet_581747(
    name: "directoryTokensGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensGet_581748, base: "/admin/directory/v1",
    url: url_DirectoryTokensGet_581749, schemes: {Scheme.Https})
type
  Call_DirectoryTokensDelete_581763 = ref object of OpenApiRestCall_579389
proc url_DirectoryTokensDelete_581765(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  assert "clientId" in path, "`clientId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/tokens/"),
               (kind: VariableSegment, value: "clientId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryTokensDelete_581764(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Delete all access tokens issued by a user for an application.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   clientId: JString (required)
  ##           : The Client ID of the application the token is issued to.
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `clientId` field"
  var valid_581766 = path.getOrDefault("clientId")
  valid_581766 = validateParameter(valid_581766, JString, required = true,
                                 default = nil)
  if valid_581766 != nil:
    section.add "clientId", valid_581766
  var valid_581767 = path.getOrDefault("userKey")
  valid_581767 = validateParameter(valid_581767, JString, required = true,
                                 default = nil)
  if valid_581767 != nil:
    section.add "userKey", valid_581767
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
  var valid_581768 = query.getOrDefault("key")
  valid_581768 = validateParameter(valid_581768, JString, required = false,
                                 default = nil)
  if valid_581768 != nil:
    section.add "key", valid_581768
  var valid_581769 = query.getOrDefault("prettyPrint")
  valid_581769 = validateParameter(valid_581769, JBool, required = false,
                                 default = newJBool(true))
  if valid_581769 != nil:
    section.add "prettyPrint", valid_581769
  var valid_581770 = query.getOrDefault("oauth_token")
  valid_581770 = validateParameter(valid_581770, JString, required = false,
                                 default = nil)
  if valid_581770 != nil:
    section.add "oauth_token", valid_581770
  var valid_581771 = query.getOrDefault("alt")
  valid_581771 = validateParameter(valid_581771, JString, required = false,
                                 default = newJString("json"))
  if valid_581771 != nil:
    section.add "alt", valid_581771
  var valid_581772 = query.getOrDefault("userIp")
  valid_581772 = validateParameter(valid_581772, JString, required = false,
                                 default = nil)
  if valid_581772 != nil:
    section.add "userIp", valid_581772
  var valid_581773 = query.getOrDefault("quotaUser")
  valid_581773 = validateParameter(valid_581773, JString, required = false,
                                 default = nil)
  if valid_581773 != nil:
    section.add "quotaUser", valid_581773
  var valid_581774 = query.getOrDefault("fields")
  valid_581774 = validateParameter(valid_581774, JString, required = false,
                                 default = nil)
  if valid_581774 != nil:
    section.add "fields", valid_581774
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581775: Call_DirectoryTokensDelete_581763; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all access tokens issued by a user for an application.
  ## 
  let valid = call_581775.validator(path, query, header, formData, body)
  let scheme = call_581775.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581775.url(scheme.get, call_581775.host, call_581775.base,
                         call_581775.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581775, url, valid)

proc call*(call_581776: Call_DirectoryTokensDelete_581763; clientId: string;
          userKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryTokensDelete
  ## Delete all access tokens issued by a user for an application.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   clientId: string (required)
  ##           : The Client ID of the application the token is issued to.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  var path_581777 = newJObject()
  var query_581778 = newJObject()
  add(query_581778, "key", newJString(key))
  add(path_581777, "clientId", newJString(clientId))
  add(query_581778, "prettyPrint", newJBool(prettyPrint))
  add(query_581778, "oauth_token", newJString(oauthToken))
  add(query_581778, "alt", newJString(alt))
  add(query_581778, "userIp", newJString(userIp))
  add(query_581778, "quotaUser", newJString(quotaUser))
  add(query_581778, "fields", newJString(fields))
  add(path_581777, "userKey", newJString(userKey))
  result = call_581776.call(path_581777, query_581778, nil, nil, nil)

var directoryTokensDelete* = Call_DirectoryTokensDelete_581763(
    name: "directoryTokensDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensDelete_581764, base: "/admin/directory/v1",
    url: url_DirectoryTokensDelete_581765, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUndelete_581779 = ref object of OpenApiRestCall_579389
proc url_DirectoryUsersUndelete_581781(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/undelete")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryUsersUndelete_581780(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Undelete a deleted user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : The immutable id of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581782 = path.getOrDefault("userKey")
  valid_581782 = validateParameter(valid_581782, JString, required = true,
                                 default = nil)
  if valid_581782 != nil:
    section.add "userKey", valid_581782
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
  var valid_581783 = query.getOrDefault("key")
  valid_581783 = validateParameter(valid_581783, JString, required = false,
                                 default = nil)
  if valid_581783 != nil:
    section.add "key", valid_581783
  var valid_581784 = query.getOrDefault("prettyPrint")
  valid_581784 = validateParameter(valid_581784, JBool, required = false,
                                 default = newJBool(true))
  if valid_581784 != nil:
    section.add "prettyPrint", valid_581784
  var valid_581785 = query.getOrDefault("oauth_token")
  valid_581785 = validateParameter(valid_581785, JString, required = false,
                                 default = nil)
  if valid_581785 != nil:
    section.add "oauth_token", valid_581785
  var valid_581786 = query.getOrDefault("alt")
  valid_581786 = validateParameter(valid_581786, JString, required = false,
                                 default = newJString("json"))
  if valid_581786 != nil:
    section.add "alt", valid_581786
  var valid_581787 = query.getOrDefault("userIp")
  valid_581787 = validateParameter(valid_581787, JString, required = false,
                                 default = nil)
  if valid_581787 != nil:
    section.add "userIp", valid_581787
  var valid_581788 = query.getOrDefault("quotaUser")
  valid_581788 = validateParameter(valid_581788, JString, required = false,
                                 default = nil)
  if valid_581788 != nil:
    section.add "quotaUser", valid_581788
  var valid_581789 = query.getOrDefault("fields")
  valid_581789 = validateParameter(valid_581789, JString, required = false,
                                 default = nil)
  if valid_581789 != nil:
    section.add "fields", valid_581789
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

proc call*(call_581791: Call_DirectoryUsersUndelete_581779; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted user
  ## 
  let valid = call_581791.validator(path, query, header, formData, body)
  let scheme = call_581791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581791.url(scheme.get, call_581791.host, call_581791.base,
                         call_581791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581791, url, valid)

proc call*(call_581792: Call_DirectoryUsersUndelete_581779; userKey: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          alt: string = "json"; userIp: string = ""; quotaUser: string = "";
          body: JsonNode = nil; fields: string = ""): Recallable =
  ## directoryUsersUndelete
  ## Undelete a deleted user
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
  ##   userKey: string (required)
  ##          : The immutable id of the user
  var path_581793 = newJObject()
  var query_581794 = newJObject()
  var body_581795 = newJObject()
  add(query_581794, "key", newJString(key))
  add(query_581794, "prettyPrint", newJBool(prettyPrint))
  add(query_581794, "oauth_token", newJString(oauthToken))
  add(query_581794, "alt", newJString(alt))
  add(query_581794, "userIp", newJString(userIp))
  add(query_581794, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_581795 = body
  add(query_581794, "fields", newJString(fields))
  add(path_581793, "userKey", newJString(userKey))
  result = call_581792.call(path_581793, query_581794, nil, nil, body_581795)

var directoryUsersUndelete* = Call_DirectoryUsersUndelete_581779(
    name: "directoryUsersUndelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/undelete",
    validator: validate_DirectoryUsersUndelete_581780,
    base: "/admin/directory/v1", url: url_DirectoryUsersUndelete_581781,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesList_581796 = ref object of OpenApiRestCall_579389
proc url_DirectoryVerificationCodesList_581798(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/verificationCodes")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryVerificationCodesList_581797(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the current set of valid backup verification codes for the specified user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581799 = path.getOrDefault("userKey")
  valid_581799 = validateParameter(valid_581799, JString, required = true,
                                 default = nil)
  if valid_581799 != nil:
    section.add "userKey", valid_581799
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
  var valid_581800 = query.getOrDefault("key")
  valid_581800 = validateParameter(valid_581800, JString, required = false,
                                 default = nil)
  if valid_581800 != nil:
    section.add "key", valid_581800
  var valid_581801 = query.getOrDefault("prettyPrint")
  valid_581801 = validateParameter(valid_581801, JBool, required = false,
                                 default = newJBool(true))
  if valid_581801 != nil:
    section.add "prettyPrint", valid_581801
  var valid_581802 = query.getOrDefault("oauth_token")
  valid_581802 = validateParameter(valid_581802, JString, required = false,
                                 default = nil)
  if valid_581802 != nil:
    section.add "oauth_token", valid_581802
  var valid_581803 = query.getOrDefault("alt")
  valid_581803 = validateParameter(valid_581803, JString, required = false,
                                 default = newJString("json"))
  if valid_581803 != nil:
    section.add "alt", valid_581803
  var valid_581804 = query.getOrDefault("userIp")
  valid_581804 = validateParameter(valid_581804, JString, required = false,
                                 default = nil)
  if valid_581804 != nil:
    section.add "userIp", valid_581804
  var valid_581805 = query.getOrDefault("quotaUser")
  valid_581805 = validateParameter(valid_581805, JString, required = false,
                                 default = nil)
  if valid_581805 != nil:
    section.add "quotaUser", valid_581805
  var valid_581806 = query.getOrDefault("fields")
  valid_581806 = validateParameter(valid_581806, JString, required = false,
                                 default = nil)
  if valid_581806 != nil:
    section.add "fields", valid_581806
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581807: Call_DirectoryVerificationCodesList_581796; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current set of valid backup verification codes for the specified user.
  ## 
  let valid = call_581807.validator(path, query, header, formData, body)
  let scheme = call_581807.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581807.url(scheme.get, call_581807.host, call_581807.base,
                         call_581807.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581807, url, valid)

proc call*(call_581808: Call_DirectoryVerificationCodesList_581796;
          userKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryVerificationCodesList
  ## Returns the current set of valid backup verification codes for the specified user.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  var path_581809 = newJObject()
  var query_581810 = newJObject()
  add(query_581810, "key", newJString(key))
  add(query_581810, "prettyPrint", newJBool(prettyPrint))
  add(query_581810, "oauth_token", newJString(oauthToken))
  add(query_581810, "alt", newJString(alt))
  add(query_581810, "userIp", newJString(userIp))
  add(query_581810, "quotaUser", newJString(quotaUser))
  add(query_581810, "fields", newJString(fields))
  add(path_581809, "userKey", newJString(userKey))
  result = call_581808.call(path_581809, query_581810, nil, nil, nil)

var directoryVerificationCodesList* = Call_DirectoryVerificationCodesList_581796(
    name: "directoryVerificationCodesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/verificationCodes",
    validator: validate_DirectoryVerificationCodesList_581797,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesList_581798,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesGenerate_581811 = ref object of OpenApiRestCall_579389
proc url_DirectoryVerificationCodesGenerate_581813(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/verificationCodes/generate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryVerificationCodesGenerate_581812(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Generate new backup verification codes for the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581814 = path.getOrDefault("userKey")
  valid_581814 = validateParameter(valid_581814, JString, required = true,
                                 default = nil)
  if valid_581814 != nil:
    section.add "userKey", valid_581814
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
  var valid_581815 = query.getOrDefault("key")
  valid_581815 = validateParameter(valid_581815, JString, required = false,
                                 default = nil)
  if valid_581815 != nil:
    section.add "key", valid_581815
  var valid_581816 = query.getOrDefault("prettyPrint")
  valid_581816 = validateParameter(valid_581816, JBool, required = false,
                                 default = newJBool(true))
  if valid_581816 != nil:
    section.add "prettyPrint", valid_581816
  var valid_581817 = query.getOrDefault("oauth_token")
  valid_581817 = validateParameter(valid_581817, JString, required = false,
                                 default = nil)
  if valid_581817 != nil:
    section.add "oauth_token", valid_581817
  var valid_581818 = query.getOrDefault("alt")
  valid_581818 = validateParameter(valid_581818, JString, required = false,
                                 default = newJString("json"))
  if valid_581818 != nil:
    section.add "alt", valid_581818
  var valid_581819 = query.getOrDefault("userIp")
  valid_581819 = validateParameter(valid_581819, JString, required = false,
                                 default = nil)
  if valid_581819 != nil:
    section.add "userIp", valid_581819
  var valid_581820 = query.getOrDefault("quotaUser")
  valid_581820 = validateParameter(valid_581820, JString, required = false,
                                 default = nil)
  if valid_581820 != nil:
    section.add "quotaUser", valid_581820
  var valid_581821 = query.getOrDefault("fields")
  valid_581821 = validateParameter(valid_581821, JString, required = false,
                                 default = nil)
  if valid_581821 != nil:
    section.add "fields", valid_581821
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581822: Call_DirectoryVerificationCodesGenerate_581811;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate new backup verification codes for the user.
  ## 
  let valid = call_581822.validator(path, query, header, formData, body)
  let scheme = call_581822.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581822.url(scheme.get, call_581822.host, call_581822.base,
                         call_581822.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581822, url, valid)

proc call*(call_581823: Call_DirectoryVerificationCodesGenerate_581811;
          userKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryVerificationCodesGenerate
  ## Generate new backup verification codes for the user.
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581824 = newJObject()
  var query_581825 = newJObject()
  add(query_581825, "key", newJString(key))
  add(query_581825, "prettyPrint", newJBool(prettyPrint))
  add(query_581825, "oauth_token", newJString(oauthToken))
  add(query_581825, "alt", newJString(alt))
  add(query_581825, "userIp", newJString(userIp))
  add(query_581825, "quotaUser", newJString(quotaUser))
  add(query_581825, "fields", newJString(fields))
  add(path_581824, "userKey", newJString(userKey))
  result = call_581823.call(path_581824, query_581825, nil, nil, nil)

var directoryVerificationCodesGenerate* = Call_DirectoryVerificationCodesGenerate_581811(
    name: "directoryVerificationCodesGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/generate",
    validator: validate_DirectoryVerificationCodesGenerate_581812,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesGenerate_581813,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesInvalidate_581826 = ref object of OpenApiRestCall_579389
proc url_DirectoryVerificationCodesInvalidate_581828(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "userKey" in path, "`userKey` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/users/"),
               (kind: VariableSegment, value: "userKey"),
               (kind: ConstantSegment, value: "/verificationCodes/invalidate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  if base ==
      "/" and
      hydrated.get.startsWith "/":
    result.path = hydrated.get
  else:
    result.path = base & hydrated.get

proc validate_DirectoryVerificationCodesInvalidate_581827(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Invalidate the current backup verification codes for the user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_581829 = path.getOrDefault("userKey")
  valid_581829 = validateParameter(valid_581829, JString, required = true,
                                 default = nil)
  if valid_581829 != nil:
    section.add "userKey", valid_581829
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
  var valid_581830 = query.getOrDefault("key")
  valid_581830 = validateParameter(valid_581830, JString, required = false,
                                 default = nil)
  if valid_581830 != nil:
    section.add "key", valid_581830
  var valid_581831 = query.getOrDefault("prettyPrint")
  valid_581831 = validateParameter(valid_581831, JBool, required = false,
                                 default = newJBool(true))
  if valid_581831 != nil:
    section.add "prettyPrint", valid_581831
  var valid_581832 = query.getOrDefault("oauth_token")
  valid_581832 = validateParameter(valid_581832, JString, required = false,
                                 default = nil)
  if valid_581832 != nil:
    section.add "oauth_token", valid_581832
  var valid_581833 = query.getOrDefault("alt")
  valid_581833 = validateParameter(valid_581833, JString, required = false,
                                 default = newJString("json"))
  if valid_581833 != nil:
    section.add "alt", valid_581833
  var valid_581834 = query.getOrDefault("userIp")
  valid_581834 = validateParameter(valid_581834, JString, required = false,
                                 default = nil)
  if valid_581834 != nil:
    section.add "userIp", valid_581834
  var valid_581835 = query.getOrDefault("quotaUser")
  valid_581835 = validateParameter(valid_581835, JString, required = false,
                                 default = nil)
  if valid_581835 != nil:
    section.add "quotaUser", valid_581835
  var valid_581836 = query.getOrDefault("fields")
  valid_581836 = validateParameter(valid_581836, JString, required = false,
                                 default = nil)
  if valid_581836 != nil:
    section.add "fields", valid_581836
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581837: Call_DirectoryVerificationCodesInvalidate_581826;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invalidate the current backup verification codes for the user.
  ## 
  let valid = call_581837.validator(path, query, header, formData, body)
  let scheme = call_581837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581837.url(scheme.get, call_581837.host, call_581837.base,
                         call_581837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581837, url, valid)

proc call*(call_581838: Call_DirectoryVerificationCodesInvalidate_581826;
          userKey: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; alt: string = "json"; userIp: string = "";
          quotaUser: string = ""; fields: string = ""): Recallable =
  ## directoryVerificationCodesInvalidate
  ## Invalidate the current backup verification codes for the user.
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  var path_581839 = newJObject()
  var query_581840 = newJObject()
  add(query_581840, "key", newJString(key))
  add(query_581840, "prettyPrint", newJBool(prettyPrint))
  add(query_581840, "oauth_token", newJString(oauthToken))
  add(query_581840, "alt", newJString(alt))
  add(query_581840, "userIp", newJString(userIp))
  add(query_581840, "quotaUser", newJString(quotaUser))
  add(query_581840, "fields", newJString(fields))
  add(path_581839, "userKey", newJString(userKey))
  result = call_581838.call(path_581839, query_581840, nil, nil, nil)

var directoryVerificationCodesInvalidate* = Call_DirectoryVerificationCodesInvalidate_581826(
    name: "directoryVerificationCodesInvalidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/invalidate",
    validator: validate_DirectoryVerificationCodesInvalidate_581827,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesInvalidate_581828,
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
