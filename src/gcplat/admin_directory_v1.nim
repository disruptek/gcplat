
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578364 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578364](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578364): Option[Scheme] {.used.} =
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
  Call_AdminChannelsStop_578634 = ref object of OpenApiRestCall_578364
proc url_AdminChannelsStop_578636(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdminChannelsStop_578635(path: JsonNode; query: JsonNode;
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
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("alt")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("json"))
  if valid_578764 != nil:
    section.add "alt", valid_578764
  var valid_578765 = query.getOrDefault("userIp")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = nil)
  if valid_578765 != nil:
    section.add "userIp", valid_578765
  var valid_578766 = query.getOrDefault("quotaUser")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "quotaUser", valid_578766
  var valid_578767 = query.getOrDefault("fields")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "fields", valid_578767
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

proc call*(call_578791: Call_AdminChannelsStop_578634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_578791.validator(path, query, header, formData, body)
  let scheme = call_578791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578791.url(scheme.get, call_578791.host, call_578791.base,
                         call_578791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578791, url, valid)

proc call*(call_578862: Call_AdminChannelsStop_578634; key: string = "";
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
  var query_578863 = newJObject()
  var body_578865 = newJObject()
  add(query_578863, "key", newJString(key))
  add(query_578863, "prettyPrint", newJBool(prettyPrint))
  add(query_578863, "oauth_token", newJString(oauthToken))
  add(query_578863, "alt", newJString(alt))
  add(query_578863, "userIp", newJString(userIp))
  add(query_578863, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_578865 = resource
  add(query_578863, "fields", newJString(fields))
  result = call_578862.call(nil, query_578863, nil, nil, body_578865)

var adminChannelsStop* = Call_AdminChannelsStop_578634(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/directory_v1/channels/stop",
    validator: validate_AdminChannelsStop_578635, base: "/admin/directory/v1",
    url: url_AdminChannelsStop_578636, schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesList_578904 = ref object of OpenApiRestCall_578364
proc url_DirectoryChromeosdevicesList_578906(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesList_578905(path: JsonNode; query: JsonNode;
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
  var valid_578921 = path.getOrDefault("customerId")
  valid_578921 = validateParameter(valid_578921, JString, required = true,
                                 default = nil)
  if valid_578921 != nil:
    section.add "customerId", valid_578921
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
  var valid_578922 = query.getOrDefault("key")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "key", valid_578922
  var valid_578923 = query.getOrDefault("orgUnitPath")
  valid_578923 = validateParameter(valid_578923, JString, required = false,
                                 default = nil)
  if valid_578923 != nil:
    section.add "orgUnitPath", valid_578923
  var valid_578924 = query.getOrDefault("prettyPrint")
  valid_578924 = validateParameter(valid_578924, JBool, required = false,
                                 default = newJBool(true))
  if valid_578924 != nil:
    section.add "prettyPrint", valid_578924
  var valid_578925 = query.getOrDefault("oauth_token")
  valid_578925 = validateParameter(valid_578925, JString, required = false,
                                 default = nil)
  if valid_578925 != nil:
    section.add "oauth_token", valid_578925
  var valid_578926 = query.getOrDefault("alt")
  valid_578926 = validateParameter(valid_578926, JString, required = false,
                                 default = newJString("json"))
  if valid_578926 != nil:
    section.add "alt", valid_578926
  var valid_578927 = query.getOrDefault("userIp")
  valid_578927 = validateParameter(valid_578927, JString, required = false,
                                 default = nil)
  if valid_578927 != nil:
    section.add "userIp", valid_578927
  var valid_578928 = query.getOrDefault("quotaUser")
  valid_578928 = validateParameter(valid_578928, JString, required = false,
                                 default = nil)
  if valid_578928 != nil:
    section.add "quotaUser", valid_578928
  var valid_578929 = query.getOrDefault("orderBy")
  valid_578929 = validateParameter(valid_578929, JString, required = false,
                                 default = newJString("annotatedLocation"))
  if valid_578929 != nil:
    section.add "orderBy", valid_578929
  var valid_578930 = query.getOrDefault("pageToken")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "pageToken", valid_578930
  var valid_578931 = query.getOrDefault("sortOrder")
  valid_578931 = validateParameter(valid_578931, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_578931 != nil:
    section.add "sortOrder", valid_578931
  var valid_578932 = query.getOrDefault("query")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "query", valid_578932
  var valid_578933 = query.getOrDefault("projection")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_578933 != nil:
    section.add "projection", valid_578933
  var valid_578934 = query.getOrDefault("fields")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = nil)
  if valid_578934 != nil:
    section.add "fields", valid_578934
  var valid_578936 = query.getOrDefault("maxResults")
  valid_578936 = validateParameter(valid_578936, JInt, required = false,
                                 default = newJInt(100))
  if valid_578936 != nil:
    section.add "maxResults", valid_578936
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578937: Call_DirectoryChromeosdevicesList_578904; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Chrome OS Devices of a customer (paginated)
  ## 
  let valid = call_578937.validator(path, query, header, formData, body)
  let scheme = call_578937.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578937.url(scheme.get, call_578937.host, call_578937.base,
                         call_578937.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578937, url, valid)

proc call*(call_578938: Call_DirectoryChromeosdevicesList_578904;
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
  var path_578939 = newJObject()
  var query_578940 = newJObject()
  add(query_578940, "key", newJString(key))
  add(query_578940, "orgUnitPath", newJString(orgUnitPath))
  add(query_578940, "prettyPrint", newJBool(prettyPrint))
  add(query_578940, "oauth_token", newJString(oauthToken))
  add(query_578940, "alt", newJString(alt))
  add(query_578940, "userIp", newJString(userIp))
  add(query_578940, "quotaUser", newJString(quotaUser))
  add(query_578940, "orderBy", newJString(orderBy))
  add(query_578940, "pageToken", newJString(pageToken))
  add(query_578940, "sortOrder", newJString(sortOrder))
  add(path_578939, "customerId", newJString(customerId))
  add(query_578940, "query", newJString(query))
  add(query_578940, "projection", newJString(projection))
  add(query_578940, "fields", newJString(fields))
  add(query_578940, "maxResults", newJInt(maxResults))
  result = call_578938.call(path_578939, query_578940, nil, nil, nil)

var directoryChromeosdevicesList* = Call_DirectoryChromeosdevicesList_578904(
    name: "directoryChromeosdevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/chromeos",
    validator: validate_DirectoryChromeosdevicesList_578905,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesList_578906,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesMoveDevicesToOu_578941 = ref object of OpenApiRestCall_578364
proc url_DirectoryChromeosdevicesMoveDevicesToOu_578943(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesMoveDevicesToOu_578942(path: JsonNode;
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
  var valid_578944 = path.getOrDefault("customerId")
  valid_578944 = validateParameter(valid_578944, JString, required = true,
                                 default = nil)
  if valid_578944 != nil:
    section.add "customerId", valid_578944
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
  var valid_578945 = query.getOrDefault("key")
  valid_578945 = validateParameter(valid_578945, JString, required = false,
                                 default = nil)
  if valid_578945 != nil:
    section.add "key", valid_578945
  assert query != nil,
        "query argument is necessary due to required `orgUnitPath` field"
  var valid_578946 = query.getOrDefault("orgUnitPath")
  valid_578946 = validateParameter(valid_578946, JString, required = true,
                                 default = nil)
  if valid_578946 != nil:
    section.add "orgUnitPath", valid_578946
  var valid_578947 = query.getOrDefault("prettyPrint")
  valid_578947 = validateParameter(valid_578947, JBool, required = false,
                                 default = newJBool(true))
  if valid_578947 != nil:
    section.add "prettyPrint", valid_578947
  var valid_578948 = query.getOrDefault("oauth_token")
  valid_578948 = validateParameter(valid_578948, JString, required = false,
                                 default = nil)
  if valid_578948 != nil:
    section.add "oauth_token", valid_578948
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
  var valid_578952 = query.getOrDefault("fields")
  valid_578952 = validateParameter(valid_578952, JString, required = false,
                                 default = nil)
  if valid_578952 != nil:
    section.add "fields", valid_578952
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

proc call*(call_578954: Call_DirectoryChromeosdevicesMoveDevicesToOu_578941;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Move or insert multiple Chrome OS Devices to organizational unit
  ## 
  let valid = call_578954.validator(path, query, header, formData, body)
  let scheme = call_578954.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578954.url(scheme.get, call_578954.host, call_578954.base,
                         call_578954.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578954, url, valid)

proc call*(call_578955: Call_DirectoryChromeosdevicesMoveDevicesToOu_578941;
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
  var path_578956 = newJObject()
  var query_578957 = newJObject()
  var body_578958 = newJObject()
  add(query_578957, "key", newJString(key))
  add(query_578957, "orgUnitPath", newJString(orgUnitPath))
  add(query_578957, "prettyPrint", newJBool(prettyPrint))
  add(query_578957, "oauth_token", newJString(oauthToken))
  add(query_578957, "alt", newJString(alt))
  add(query_578957, "userIp", newJString(userIp))
  add(query_578957, "quotaUser", newJString(quotaUser))
  add(path_578956, "customerId", newJString(customerId))
  if body != nil:
    body_578958 = body
  add(query_578957, "fields", newJString(fields))
  result = call_578955.call(path_578956, query_578957, nil, nil, body_578958)

var directoryChromeosdevicesMoveDevicesToOu* = Call_DirectoryChromeosdevicesMoveDevicesToOu_578941(
    name: "directoryChromeosdevicesMoveDevicesToOu", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/moveDevicesToOu",
    validator: validate_DirectoryChromeosdevicesMoveDevicesToOu_578942,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesMoveDevicesToOu_578943,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesUpdate_578976 = ref object of OpenApiRestCall_578364
proc url_DirectoryChromeosdevicesUpdate_578978(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesUpdate_578977(path: JsonNode;
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
  var valid_578979 = path.getOrDefault("customerId")
  valid_578979 = validateParameter(valid_578979, JString, required = true,
                                 default = nil)
  if valid_578979 != nil:
    section.add "customerId", valid_578979
  var valid_578980 = path.getOrDefault("deviceId")
  valid_578980 = validateParameter(valid_578980, JString, required = true,
                                 default = nil)
  if valid_578980 != nil:
    section.add "deviceId", valid_578980
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
  var valid_578981 = query.getOrDefault("key")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "key", valid_578981
  var valid_578982 = query.getOrDefault("prettyPrint")
  valid_578982 = validateParameter(valid_578982, JBool, required = false,
                                 default = newJBool(true))
  if valid_578982 != nil:
    section.add "prettyPrint", valid_578982
  var valid_578983 = query.getOrDefault("oauth_token")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "oauth_token", valid_578983
  var valid_578984 = query.getOrDefault("alt")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = newJString("json"))
  if valid_578984 != nil:
    section.add "alt", valid_578984
  var valid_578985 = query.getOrDefault("userIp")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "userIp", valid_578985
  var valid_578986 = query.getOrDefault("quotaUser")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "quotaUser", valid_578986
  var valid_578987 = query.getOrDefault("projection")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_578987 != nil:
    section.add "projection", valid_578987
  var valid_578988 = query.getOrDefault("fields")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "fields", valid_578988
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

proc call*(call_578990: Call_DirectoryChromeosdevicesUpdate_578976; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device
  ## 
  let valid = call_578990.validator(path, query, header, formData, body)
  let scheme = call_578990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578990.url(scheme.get, call_578990.host, call_578990.base,
                         call_578990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578990, url, valid)

proc call*(call_578991: Call_DirectoryChromeosdevicesUpdate_578976;
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
  var path_578992 = newJObject()
  var query_578993 = newJObject()
  var body_578994 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "userIp", newJString(userIp))
  add(query_578993, "quotaUser", newJString(quotaUser))
  add(path_578992, "customerId", newJString(customerId))
  if body != nil:
    body_578994 = body
  add(query_578993, "projection", newJString(projection))
  add(query_578993, "fields", newJString(fields))
  add(path_578992, "deviceId", newJString(deviceId))
  result = call_578991.call(path_578992, query_578993, nil, nil, body_578994)

var directoryChromeosdevicesUpdate* = Call_DirectoryChromeosdevicesUpdate_578976(
    name: "directoryChromeosdevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesUpdate_578977,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesUpdate_578978,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesGet_578959 = ref object of OpenApiRestCall_578364
proc url_DirectoryChromeosdevicesGet_578961(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesGet_578960(path: JsonNode; query: JsonNode;
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
  var valid_578962 = path.getOrDefault("customerId")
  valid_578962 = validateParameter(valid_578962, JString, required = true,
                                 default = nil)
  if valid_578962 != nil:
    section.add "customerId", valid_578962
  var valid_578963 = path.getOrDefault("deviceId")
  valid_578963 = validateParameter(valid_578963, JString, required = true,
                                 default = nil)
  if valid_578963 != nil:
    section.add "deviceId", valid_578963
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
  var valid_578964 = query.getOrDefault("key")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "key", valid_578964
  var valid_578965 = query.getOrDefault("prettyPrint")
  valid_578965 = validateParameter(valid_578965, JBool, required = false,
                                 default = newJBool(true))
  if valid_578965 != nil:
    section.add "prettyPrint", valid_578965
  var valid_578966 = query.getOrDefault("oauth_token")
  valid_578966 = validateParameter(valid_578966, JString, required = false,
                                 default = nil)
  if valid_578966 != nil:
    section.add "oauth_token", valid_578966
  var valid_578967 = query.getOrDefault("alt")
  valid_578967 = validateParameter(valid_578967, JString, required = false,
                                 default = newJString("json"))
  if valid_578967 != nil:
    section.add "alt", valid_578967
  var valid_578968 = query.getOrDefault("userIp")
  valid_578968 = validateParameter(valid_578968, JString, required = false,
                                 default = nil)
  if valid_578968 != nil:
    section.add "userIp", valid_578968
  var valid_578969 = query.getOrDefault("quotaUser")
  valid_578969 = validateParameter(valid_578969, JString, required = false,
                                 default = nil)
  if valid_578969 != nil:
    section.add "quotaUser", valid_578969
  var valid_578970 = query.getOrDefault("projection")
  valid_578970 = validateParameter(valid_578970, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_578970 != nil:
    section.add "projection", valid_578970
  var valid_578971 = query.getOrDefault("fields")
  valid_578971 = validateParameter(valid_578971, JString, required = false,
                                 default = nil)
  if valid_578971 != nil:
    section.add "fields", valid_578971
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578972: Call_DirectoryChromeosdevicesGet_578959; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Chrome OS Device
  ## 
  let valid = call_578972.validator(path, query, header, formData, body)
  let scheme = call_578972.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578972.url(scheme.get, call_578972.host, call_578972.base,
                         call_578972.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578972, url, valid)

proc call*(call_578973: Call_DirectoryChromeosdevicesGet_578959;
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
  var path_578974 = newJObject()
  var query_578975 = newJObject()
  add(query_578975, "key", newJString(key))
  add(query_578975, "prettyPrint", newJBool(prettyPrint))
  add(query_578975, "oauth_token", newJString(oauthToken))
  add(query_578975, "alt", newJString(alt))
  add(query_578975, "userIp", newJString(userIp))
  add(query_578975, "quotaUser", newJString(quotaUser))
  add(path_578974, "customerId", newJString(customerId))
  add(query_578975, "projection", newJString(projection))
  add(query_578975, "fields", newJString(fields))
  add(path_578974, "deviceId", newJString(deviceId))
  result = call_578973.call(path_578974, query_578975, nil, nil, nil)

var directoryChromeosdevicesGet* = Call_DirectoryChromeosdevicesGet_578959(
    name: "directoryChromeosdevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesGet_578960,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesGet_578961,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesPatch_578995 = ref object of OpenApiRestCall_578364
proc url_DirectoryChromeosdevicesPatch_578997(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesPatch_578996(path: JsonNode; query: JsonNode;
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
  var valid_578998 = path.getOrDefault("customerId")
  valid_578998 = validateParameter(valid_578998, JString, required = true,
                                 default = nil)
  if valid_578998 != nil:
    section.add "customerId", valid_578998
  var valid_578999 = path.getOrDefault("deviceId")
  valid_578999 = validateParameter(valid_578999, JString, required = true,
                                 default = nil)
  if valid_578999 != nil:
    section.add "deviceId", valid_578999
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
  var valid_579000 = query.getOrDefault("key")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "key", valid_579000
  var valid_579001 = query.getOrDefault("prettyPrint")
  valid_579001 = validateParameter(valid_579001, JBool, required = false,
                                 default = newJBool(true))
  if valid_579001 != nil:
    section.add "prettyPrint", valid_579001
  var valid_579002 = query.getOrDefault("oauth_token")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "oauth_token", valid_579002
  var valid_579003 = query.getOrDefault("alt")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("json"))
  if valid_579003 != nil:
    section.add "alt", valid_579003
  var valid_579004 = query.getOrDefault("userIp")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "userIp", valid_579004
  var valid_579005 = query.getOrDefault("quotaUser")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "quotaUser", valid_579005
  var valid_579006 = query.getOrDefault("projection")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579006 != nil:
    section.add "projection", valid_579006
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

proc call*(call_579009: Call_DirectoryChromeosdevicesPatch_578995; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device. This method supports patch semantics.
  ## 
  let valid = call_579009.validator(path, query, header, formData, body)
  let scheme = call_579009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579009.url(scheme.get, call_579009.host, call_579009.base,
                         call_579009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579009, url, valid)

proc call*(call_579010: Call_DirectoryChromeosdevicesPatch_578995;
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
  var path_579011 = newJObject()
  var query_579012 = newJObject()
  var body_579013 = newJObject()
  add(query_579012, "key", newJString(key))
  add(query_579012, "prettyPrint", newJBool(prettyPrint))
  add(query_579012, "oauth_token", newJString(oauthToken))
  add(query_579012, "alt", newJString(alt))
  add(query_579012, "userIp", newJString(userIp))
  add(query_579012, "quotaUser", newJString(quotaUser))
  add(path_579011, "customerId", newJString(customerId))
  if body != nil:
    body_579013 = body
  add(query_579012, "projection", newJString(projection))
  add(query_579012, "fields", newJString(fields))
  add(path_579011, "deviceId", newJString(deviceId))
  result = call_579010.call(path_579011, query_579012, nil, nil, body_579013)

var directoryChromeosdevicesPatch* = Call_DirectoryChromeosdevicesPatch_578995(
    name: "directoryChromeosdevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesPatch_578996,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesPatch_578997,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesAction_579014 = ref object of OpenApiRestCall_578364
proc url_DirectoryChromeosdevicesAction_579016(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryChromeosdevicesAction_579015(path: JsonNode;
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
  var valid_579017 = path.getOrDefault("customerId")
  valid_579017 = validateParameter(valid_579017, JString, required = true,
                                 default = nil)
  if valid_579017 != nil:
    section.add "customerId", valid_579017
  var valid_579018 = path.getOrDefault("resourceId")
  valid_579018 = validateParameter(valid_579018, JString, required = true,
                                 default = nil)
  if valid_579018 != nil:
    section.add "resourceId", valid_579018
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
  var valid_579019 = query.getOrDefault("key")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = nil)
  if valid_579019 != nil:
    section.add "key", valid_579019
  var valid_579020 = query.getOrDefault("prettyPrint")
  valid_579020 = validateParameter(valid_579020, JBool, required = false,
                                 default = newJBool(true))
  if valid_579020 != nil:
    section.add "prettyPrint", valid_579020
  var valid_579021 = query.getOrDefault("oauth_token")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "oauth_token", valid_579021
  var valid_579022 = query.getOrDefault("alt")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = newJString("json"))
  if valid_579022 != nil:
    section.add "alt", valid_579022
  var valid_579023 = query.getOrDefault("userIp")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "userIp", valid_579023
  var valid_579024 = query.getOrDefault("quotaUser")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "quotaUser", valid_579024
  var valid_579025 = query.getOrDefault("fields")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "fields", valid_579025
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

proc call*(call_579027: Call_DirectoryChromeosdevicesAction_579014; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Chrome OS Device
  ## 
  let valid = call_579027.validator(path, query, header, formData, body)
  let scheme = call_579027.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579027.url(scheme.get, call_579027.host, call_579027.base,
                         call_579027.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579027, url, valid)

proc call*(call_579028: Call_DirectoryChromeosdevicesAction_579014;
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
  var path_579029 = newJObject()
  var query_579030 = newJObject()
  var body_579031 = newJObject()
  add(query_579030, "key", newJString(key))
  add(query_579030, "prettyPrint", newJBool(prettyPrint))
  add(query_579030, "oauth_token", newJString(oauthToken))
  add(query_579030, "alt", newJString(alt))
  add(query_579030, "userIp", newJString(userIp))
  add(query_579030, "quotaUser", newJString(quotaUser))
  add(path_579029, "customerId", newJString(customerId))
  if body != nil:
    body_579031 = body
  add(path_579029, "resourceId", newJString(resourceId))
  add(query_579030, "fields", newJString(fields))
  result = call_579028.call(path_579029, query_579030, nil, nil, body_579031)

var directoryChromeosdevicesAction* = Call_DirectoryChromeosdevicesAction_579014(
    name: "directoryChromeosdevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{resourceId}/action",
    validator: validate_DirectoryChromeosdevicesAction_579015,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesAction_579016,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesList_579032 = ref object of OpenApiRestCall_578364
proc url_DirectoryMobiledevicesList_579034(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMobiledevicesList_579033(path: JsonNode; query: JsonNode;
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
  var valid_579035 = path.getOrDefault("customerId")
  valid_579035 = validateParameter(valid_579035, JString, required = true,
                                 default = nil)
  if valid_579035 != nil:
    section.add "customerId", valid_579035
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
  var valid_579036 = query.getOrDefault("key")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "key", valid_579036
  var valid_579037 = query.getOrDefault("prettyPrint")
  valid_579037 = validateParameter(valid_579037, JBool, required = false,
                                 default = newJBool(true))
  if valid_579037 != nil:
    section.add "prettyPrint", valid_579037
  var valid_579038 = query.getOrDefault("oauth_token")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = nil)
  if valid_579038 != nil:
    section.add "oauth_token", valid_579038
  var valid_579039 = query.getOrDefault("alt")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = newJString("json"))
  if valid_579039 != nil:
    section.add "alt", valid_579039
  var valid_579040 = query.getOrDefault("userIp")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "userIp", valid_579040
  var valid_579041 = query.getOrDefault("quotaUser")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "quotaUser", valid_579041
  var valid_579042 = query.getOrDefault("orderBy")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("deviceId"))
  if valid_579042 != nil:
    section.add "orderBy", valid_579042
  var valid_579043 = query.getOrDefault("pageToken")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "pageToken", valid_579043
  var valid_579044 = query.getOrDefault("sortOrder")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_579044 != nil:
    section.add "sortOrder", valid_579044
  var valid_579045 = query.getOrDefault("query")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "query", valid_579045
  var valid_579046 = query.getOrDefault("projection")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579046 != nil:
    section.add "projection", valid_579046
  var valid_579047 = query.getOrDefault("fields")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "fields", valid_579047
  var valid_579048 = query.getOrDefault("maxResults")
  valid_579048 = validateParameter(valid_579048, JInt, required = false,
                                 default = newJInt(100))
  if valid_579048 != nil:
    section.add "maxResults", valid_579048
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579049: Call_DirectoryMobiledevicesList_579032; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Mobile Devices of a customer (paginated)
  ## 
  let valid = call_579049.validator(path, query, header, formData, body)
  let scheme = call_579049.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579049.url(scheme.get, call_579049.host, call_579049.base,
                         call_579049.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579049, url, valid)

proc call*(call_579050: Call_DirectoryMobiledevicesList_579032; customerId: string;
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
  var path_579051 = newJObject()
  var query_579052 = newJObject()
  add(query_579052, "key", newJString(key))
  add(query_579052, "prettyPrint", newJBool(prettyPrint))
  add(query_579052, "oauth_token", newJString(oauthToken))
  add(query_579052, "alt", newJString(alt))
  add(query_579052, "userIp", newJString(userIp))
  add(query_579052, "quotaUser", newJString(quotaUser))
  add(query_579052, "orderBy", newJString(orderBy))
  add(query_579052, "pageToken", newJString(pageToken))
  add(query_579052, "sortOrder", newJString(sortOrder))
  add(path_579051, "customerId", newJString(customerId))
  add(query_579052, "query", newJString(query))
  add(query_579052, "projection", newJString(projection))
  add(query_579052, "fields", newJString(fields))
  add(query_579052, "maxResults", newJInt(maxResults))
  result = call_579050.call(path_579051, query_579052, nil, nil, nil)

var directoryMobiledevicesList* = Call_DirectoryMobiledevicesList_579032(
    name: "directoryMobiledevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/mobile",
    validator: validate_DirectoryMobiledevicesList_579033,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesList_579034,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesGet_579053 = ref object of OpenApiRestCall_578364
proc url_DirectoryMobiledevicesGet_579055(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMobiledevicesGet_579054(path: JsonNode; query: JsonNode;
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
  var valid_579056 = path.getOrDefault("customerId")
  valid_579056 = validateParameter(valid_579056, JString, required = true,
                                 default = nil)
  if valid_579056 != nil:
    section.add "customerId", valid_579056
  var valid_579057 = path.getOrDefault("resourceId")
  valid_579057 = validateParameter(valid_579057, JString, required = true,
                                 default = nil)
  if valid_579057 != nil:
    section.add "resourceId", valid_579057
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
  var valid_579058 = query.getOrDefault("key")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "key", valid_579058
  var valid_579059 = query.getOrDefault("prettyPrint")
  valid_579059 = validateParameter(valid_579059, JBool, required = false,
                                 default = newJBool(true))
  if valid_579059 != nil:
    section.add "prettyPrint", valid_579059
  var valid_579060 = query.getOrDefault("oauth_token")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "oauth_token", valid_579060
  var valid_579061 = query.getOrDefault("alt")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = newJString("json"))
  if valid_579061 != nil:
    section.add "alt", valid_579061
  var valid_579062 = query.getOrDefault("userIp")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "userIp", valid_579062
  var valid_579063 = query.getOrDefault("quotaUser")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "quotaUser", valid_579063
  var valid_579064 = query.getOrDefault("projection")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_579064 != nil:
    section.add "projection", valid_579064
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
  if body != nil:
    result.add "body", body

proc call*(call_579066: Call_DirectoryMobiledevicesGet_579053; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Mobile Device
  ## 
  let valid = call_579066.validator(path, query, header, formData, body)
  let scheme = call_579066.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579066.url(scheme.get, call_579066.host, call_579066.base,
                         call_579066.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579066, url, valid)

proc call*(call_579067: Call_DirectoryMobiledevicesGet_579053; customerId: string;
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
  var path_579068 = newJObject()
  var query_579069 = newJObject()
  add(query_579069, "key", newJString(key))
  add(query_579069, "prettyPrint", newJBool(prettyPrint))
  add(query_579069, "oauth_token", newJString(oauthToken))
  add(query_579069, "alt", newJString(alt))
  add(query_579069, "userIp", newJString(userIp))
  add(query_579069, "quotaUser", newJString(quotaUser))
  add(path_579068, "customerId", newJString(customerId))
  add(query_579069, "projection", newJString(projection))
  add(path_579068, "resourceId", newJString(resourceId))
  add(query_579069, "fields", newJString(fields))
  result = call_579067.call(path_579068, query_579069, nil, nil, nil)

var directoryMobiledevicesGet* = Call_DirectoryMobiledevicesGet_579053(
    name: "directoryMobiledevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesGet_579054,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesGet_579055,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesDelete_579070 = ref object of OpenApiRestCall_578364
proc url_DirectoryMobiledevicesDelete_579072(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMobiledevicesDelete_579071(path: JsonNode; query: JsonNode;
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
  var valid_579073 = path.getOrDefault("customerId")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "customerId", valid_579073
  var valid_579074 = path.getOrDefault("resourceId")
  valid_579074 = validateParameter(valid_579074, JString, required = true,
                                 default = nil)
  if valid_579074 != nil:
    section.add "resourceId", valid_579074
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
  var valid_579075 = query.getOrDefault("key")
  valid_579075 = validateParameter(valid_579075, JString, required = false,
                                 default = nil)
  if valid_579075 != nil:
    section.add "key", valid_579075
  var valid_579076 = query.getOrDefault("prettyPrint")
  valid_579076 = validateParameter(valid_579076, JBool, required = false,
                                 default = newJBool(true))
  if valid_579076 != nil:
    section.add "prettyPrint", valid_579076
  var valid_579077 = query.getOrDefault("oauth_token")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = nil)
  if valid_579077 != nil:
    section.add "oauth_token", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("userIp")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "userIp", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("fields")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "fields", valid_579081
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579082: Call_DirectoryMobiledevicesDelete_579070; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Mobile Device
  ## 
  let valid = call_579082.validator(path, query, header, formData, body)
  let scheme = call_579082.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579082.url(scheme.get, call_579082.host, call_579082.base,
                         call_579082.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579082, url, valid)

proc call*(call_579083: Call_DirectoryMobiledevicesDelete_579070;
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
  var path_579084 = newJObject()
  var query_579085 = newJObject()
  add(query_579085, "key", newJString(key))
  add(query_579085, "prettyPrint", newJBool(prettyPrint))
  add(query_579085, "oauth_token", newJString(oauthToken))
  add(query_579085, "alt", newJString(alt))
  add(query_579085, "userIp", newJString(userIp))
  add(query_579085, "quotaUser", newJString(quotaUser))
  add(path_579084, "customerId", newJString(customerId))
  add(path_579084, "resourceId", newJString(resourceId))
  add(query_579085, "fields", newJString(fields))
  result = call_579083.call(path_579084, query_579085, nil, nil, nil)

var directoryMobiledevicesDelete* = Call_DirectoryMobiledevicesDelete_579070(
    name: "directoryMobiledevicesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesDelete_579071,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesDelete_579072,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesAction_579086 = ref object of OpenApiRestCall_578364
proc url_DirectoryMobiledevicesAction_579088(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMobiledevicesAction_579087(path: JsonNode; query: JsonNode;
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
  var valid_579089 = path.getOrDefault("customerId")
  valid_579089 = validateParameter(valid_579089, JString, required = true,
                                 default = nil)
  if valid_579089 != nil:
    section.add "customerId", valid_579089
  var valid_579090 = path.getOrDefault("resourceId")
  valid_579090 = validateParameter(valid_579090, JString, required = true,
                                 default = nil)
  if valid_579090 != nil:
    section.add "resourceId", valid_579090
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
  var valid_579091 = query.getOrDefault("key")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "key", valid_579091
  var valid_579092 = query.getOrDefault("prettyPrint")
  valid_579092 = validateParameter(valid_579092, JBool, required = false,
                                 default = newJBool(true))
  if valid_579092 != nil:
    section.add "prettyPrint", valid_579092
  var valid_579093 = query.getOrDefault("oauth_token")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "oauth_token", valid_579093
  var valid_579094 = query.getOrDefault("alt")
  valid_579094 = validateParameter(valid_579094, JString, required = false,
                                 default = newJString("json"))
  if valid_579094 != nil:
    section.add "alt", valid_579094
  var valid_579095 = query.getOrDefault("userIp")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "userIp", valid_579095
  var valid_579096 = query.getOrDefault("quotaUser")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = nil)
  if valid_579096 != nil:
    section.add "quotaUser", valid_579096
  var valid_579097 = query.getOrDefault("fields")
  valid_579097 = validateParameter(valid_579097, JString, required = false,
                                 default = nil)
  if valid_579097 != nil:
    section.add "fields", valid_579097
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

proc call*(call_579099: Call_DirectoryMobiledevicesAction_579086; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Mobile Device
  ## 
  let valid = call_579099.validator(path, query, header, formData, body)
  let scheme = call_579099.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579099.url(scheme.get, call_579099.host, call_579099.base,
                         call_579099.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579099, url, valid)

proc call*(call_579100: Call_DirectoryMobiledevicesAction_579086;
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
  var path_579101 = newJObject()
  var query_579102 = newJObject()
  var body_579103 = newJObject()
  add(query_579102, "key", newJString(key))
  add(query_579102, "prettyPrint", newJBool(prettyPrint))
  add(query_579102, "oauth_token", newJString(oauthToken))
  add(query_579102, "alt", newJString(alt))
  add(query_579102, "userIp", newJString(userIp))
  add(query_579102, "quotaUser", newJString(quotaUser))
  add(path_579101, "customerId", newJString(customerId))
  if body != nil:
    body_579103 = body
  add(path_579101, "resourceId", newJString(resourceId))
  add(query_579102, "fields", newJString(fields))
  result = call_579100.call(path_579101, query_579102, nil, nil, body_579103)

var directoryMobiledevicesAction* = Call_DirectoryMobiledevicesAction_579086(
    name: "directoryMobiledevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}/action",
    validator: validate_DirectoryMobiledevicesAction_579087,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesAction_579088,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsInsert_579121 = ref object of OpenApiRestCall_578364
proc url_DirectoryOrgunitsInsert_579123(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryOrgunitsInsert_579122(path: JsonNode; query: JsonNode;
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
  var valid_579124 = path.getOrDefault("customerId")
  valid_579124 = validateParameter(valid_579124, JString, required = true,
                                 default = nil)
  if valid_579124 != nil:
    section.add "customerId", valid_579124
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
  var valid_579125 = query.getOrDefault("key")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "key", valid_579125
  var valid_579126 = query.getOrDefault("prettyPrint")
  valid_579126 = validateParameter(valid_579126, JBool, required = false,
                                 default = newJBool(true))
  if valid_579126 != nil:
    section.add "prettyPrint", valid_579126
  var valid_579127 = query.getOrDefault("oauth_token")
  valid_579127 = validateParameter(valid_579127, JString, required = false,
                                 default = nil)
  if valid_579127 != nil:
    section.add "oauth_token", valid_579127
  var valid_579128 = query.getOrDefault("alt")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = newJString("json"))
  if valid_579128 != nil:
    section.add "alt", valid_579128
  var valid_579129 = query.getOrDefault("userIp")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "userIp", valid_579129
  var valid_579130 = query.getOrDefault("quotaUser")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "quotaUser", valid_579130
  var valid_579131 = query.getOrDefault("fields")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "fields", valid_579131
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

proc call*(call_579133: Call_DirectoryOrgunitsInsert_579121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add organizational unit
  ## 
  let valid = call_579133.validator(path, query, header, formData, body)
  let scheme = call_579133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579133.url(scheme.get, call_579133.host, call_579133.base,
                         call_579133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579133, url, valid)

proc call*(call_579134: Call_DirectoryOrgunitsInsert_579121; customerId: string;
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
  var path_579135 = newJObject()
  var query_579136 = newJObject()
  var body_579137 = newJObject()
  add(query_579136, "key", newJString(key))
  add(query_579136, "prettyPrint", newJBool(prettyPrint))
  add(query_579136, "oauth_token", newJString(oauthToken))
  add(query_579136, "alt", newJString(alt))
  add(query_579136, "userIp", newJString(userIp))
  add(query_579136, "quotaUser", newJString(quotaUser))
  add(path_579135, "customerId", newJString(customerId))
  if body != nil:
    body_579137 = body
  add(query_579136, "fields", newJString(fields))
  result = call_579134.call(path_579135, query_579136, nil, nil, body_579137)

var directoryOrgunitsInsert* = Call_DirectoryOrgunitsInsert_579121(
    name: "directoryOrgunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsInsert_579122,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsInsert_579123,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsList_579104 = ref object of OpenApiRestCall_578364
proc url_DirectoryOrgunitsList_579106(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryOrgunitsList_579105(path: JsonNode; query: JsonNode;
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
  var valid_579107 = path.getOrDefault("customerId")
  valid_579107 = validateParameter(valid_579107, JString, required = true,
                                 default = nil)
  if valid_579107 != nil:
    section.add "customerId", valid_579107
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
  var valid_579108 = query.getOrDefault("key")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "key", valid_579108
  var valid_579109 = query.getOrDefault("orgUnitPath")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = newJString(""))
  if valid_579109 != nil:
    section.add "orgUnitPath", valid_579109
  var valid_579110 = query.getOrDefault("prettyPrint")
  valid_579110 = validateParameter(valid_579110, JBool, required = false,
                                 default = newJBool(true))
  if valid_579110 != nil:
    section.add "prettyPrint", valid_579110
  var valid_579111 = query.getOrDefault("oauth_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "oauth_token", valid_579111
  var valid_579112 = query.getOrDefault("alt")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = newJString("json"))
  if valid_579112 != nil:
    section.add "alt", valid_579112
  var valid_579113 = query.getOrDefault("userIp")
  valid_579113 = validateParameter(valid_579113, JString, required = false,
                                 default = nil)
  if valid_579113 != nil:
    section.add "userIp", valid_579113
  var valid_579114 = query.getOrDefault("quotaUser")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "quotaUser", valid_579114
  var valid_579115 = query.getOrDefault("type")
  valid_579115 = validateParameter(valid_579115, JString, required = false,
                                 default = newJString("all"))
  if valid_579115 != nil:
    section.add "type", valid_579115
  var valid_579116 = query.getOrDefault("fields")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "fields", valid_579116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579117: Call_DirectoryOrgunitsList_579104; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all organizational units
  ## 
  let valid = call_579117.validator(path, query, header, formData, body)
  let scheme = call_579117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579117.url(scheme.get, call_579117.host, call_579117.base,
                         call_579117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579117, url, valid)

proc call*(call_579118: Call_DirectoryOrgunitsList_579104; customerId: string;
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
  var path_579119 = newJObject()
  var query_579120 = newJObject()
  add(query_579120, "key", newJString(key))
  add(query_579120, "orgUnitPath", newJString(orgUnitPath))
  add(query_579120, "prettyPrint", newJBool(prettyPrint))
  add(query_579120, "oauth_token", newJString(oauthToken))
  add(query_579120, "alt", newJString(alt))
  add(query_579120, "userIp", newJString(userIp))
  add(query_579120, "quotaUser", newJString(quotaUser))
  add(query_579120, "type", newJString(`type`))
  add(path_579119, "customerId", newJString(customerId))
  add(query_579120, "fields", newJString(fields))
  result = call_579118.call(path_579119, query_579120, nil, nil, nil)

var directoryOrgunitsList* = Call_DirectoryOrgunitsList_579104(
    name: "directoryOrgunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsList_579105, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsList_579106, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsUpdate_579154 = ref object of OpenApiRestCall_578364
proc url_DirectoryOrgunitsUpdate_579156(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryOrgunitsUpdate_579155(path: JsonNode; query: JsonNode;
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
  var valid_579157 = path.getOrDefault("orgUnitPath")
  valid_579157 = validateParameter(valid_579157, JString, required = true,
                                 default = nil)
  if valid_579157 != nil:
    section.add "orgUnitPath", valid_579157
  var valid_579158 = path.getOrDefault("customerId")
  valid_579158 = validateParameter(valid_579158, JString, required = true,
                                 default = nil)
  if valid_579158 != nil:
    section.add "customerId", valid_579158
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
  var valid_579159 = query.getOrDefault("key")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = nil)
  if valid_579159 != nil:
    section.add "key", valid_579159
  var valid_579160 = query.getOrDefault("prettyPrint")
  valid_579160 = validateParameter(valid_579160, JBool, required = false,
                                 default = newJBool(true))
  if valid_579160 != nil:
    section.add "prettyPrint", valid_579160
  var valid_579161 = query.getOrDefault("oauth_token")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = nil)
  if valid_579161 != nil:
    section.add "oauth_token", valid_579161
  var valid_579162 = query.getOrDefault("alt")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = newJString("json"))
  if valid_579162 != nil:
    section.add "alt", valid_579162
  var valid_579163 = query.getOrDefault("userIp")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "userIp", valid_579163
  var valid_579164 = query.getOrDefault("quotaUser")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "quotaUser", valid_579164
  var valid_579165 = query.getOrDefault("fields")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "fields", valid_579165
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

proc call*(call_579167: Call_DirectoryOrgunitsUpdate_579154; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit
  ## 
  let valid = call_579167.validator(path, query, header, formData, body)
  let scheme = call_579167.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579167.url(scheme.get, call_579167.host, call_579167.base,
                         call_579167.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579167, url, valid)

proc call*(call_579168: Call_DirectoryOrgunitsUpdate_579154; orgUnitPath: string;
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
  var path_579169 = newJObject()
  var query_579170 = newJObject()
  var body_579171 = newJObject()
  add(query_579170, "key", newJString(key))
  add(path_579169, "orgUnitPath", newJString(orgUnitPath))
  add(query_579170, "prettyPrint", newJBool(prettyPrint))
  add(query_579170, "oauth_token", newJString(oauthToken))
  add(query_579170, "alt", newJString(alt))
  add(query_579170, "userIp", newJString(userIp))
  add(query_579170, "quotaUser", newJString(quotaUser))
  add(path_579169, "customerId", newJString(customerId))
  if body != nil:
    body_579171 = body
  add(query_579170, "fields", newJString(fields))
  result = call_579168.call(path_579169, query_579170, nil, nil, body_579171)

var directoryOrgunitsUpdate* = Call_DirectoryOrgunitsUpdate_579154(
    name: "directoryOrgunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsUpdate_579155,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsUpdate_579156,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsGet_579138 = ref object of OpenApiRestCall_578364
proc url_DirectoryOrgunitsGet_579140(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryOrgunitsGet_579139(path: JsonNode; query: JsonNode;
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
  var valid_579141 = path.getOrDefault("orgUnitPath")
  valid_579141 = validateParameter(valid_579141, JString, required = true,
                                 default = nil)
  if valid_579141 != nil:
    section.add "orgUnitPath", valid_579141
  var valid_579142 = path.getOrDefault("customerId")
  valid_579142 = validateParameter(valid_579142, JString, required = true,
                                 default = nil)
  if valid_579142 != nil:
    section.add "customerId", valid_579142
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
  var valid_579143 = query.getOrDefault("key")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "key", valid_579143
  var valid_579144 = query.getOrDefault("prettyPrint")
  valid_579144 = validateParameter(valid_579144, JBool, required = false,
                                 default = newJBool(true))
  if valid_579144 != nil:
    section.add "prettyPrint", valid_579144
  var valid_579145 = query.getOrDefault("oauth_token")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "oauth_token", valid_579145
  var valid_579146 = query.getOrDefault("alt")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = newJString("json"))
  if valid_579146 != nil:
    section.add "alt", valid_579146
  var valid_579147 = query.getOrDefault("userIp")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "userIp", valid_579147
  var valid_579148 = query.getOrDefault("quotaUser")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = nil)
  if valid_579148 != nil:
    section.add "quotaUser", valid_579148
  var valid_579149 = query.getOrDefault("fields")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "fields", valid_579149
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579150: Call_DirectoryOrgunitsGet_579138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Organization Unit
  ## 
  let valid = call_579150.validator(path, query, header, formData, body)
  let scheme = call_579150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579150.url(scheme.get, call_579150.host, call_579150.base,
                         call_579150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579150, url, valid)

proc call*(call_579151: Call_DirectoryOrgunitsGet_579138; orgUnitPath: string;
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
  var path_579152 = newJObject()
  var query_579153 = newJObject()
  add(query_579153, "key", newJString(key))
  add(path_579152, "orgUnitPath", newJString(orgUnitPath))
  add(query_579153, "prettyPrint", newJBool(prettyPrint))
  add(query_579153, "oauth_token", newJString(oauthToken))
  add(query_579153, "alt", newJString(alt))
  add(query_579153, "userIp", newJString(userIp))
  add(query_579153, "quotaUser", newJString(quotaUser))
  add(path_579152, "customerId", newJString(customerId))
  add(query_579153, "fields", newJString(fields))
  result = call_579151.call(path_579152, query_579153, nil, nil, nil)

var directoryOrgunitsGet* = Call_DirectoryOrgunitsGet_579138(
    name: "directoryOrgunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsGet_579139, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsGet_579140, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsPatch_579188 = ref object of OpenApiRestCall_578364
proc url_DirectoryOrgunitsPatch_579190(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryOrgunitsPatch_579189(path: JsonNode; query: JsonNode;
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
  var valid_579191 = path.getOrDefault("orgUnitPath")
  valid_579191 = validateParameter(valid_579191, JString, required = true,
                                 default = nil)
  if valid_579191 != nil:
    section.add "orgUnitPath", valid_579191
  var valid_579192 = path.getOrDefault("customerId")
  valid_579192 = validateParameter(valid_579192, JString, required = true,
                                 default = nil)
  if valid_579192 != nil:
    section.add "customerId", valid_579192
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
  var valid_579193 = query.getOrDefault("key")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "key", valid_579193
  var valid_579194 = query.getOrDefault("prettyPrint")
  valid_579194 = validateParameter(valid_579194, JBool, required = false,
                                 default = newJBool(true))
  if valid_579194 != nil:
    section.add "prettyPrint", valid_579194
  var valid_579195 = query.getOrDefault("oauth_token")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "oauth_token", valid_579195
  var valid_579196 = query.getOrDefault("alt")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = newJString("json"))
  if valid_579196 != nil:
    section.add "alt", valid_579196
  var valid_579197 = query.getOrDefault("userIp")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "userIp", valid_579197
  var valid_579198 = query.getOrDefault("quotaUser")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "quotaUser", valid_579198
  var valid_579199 = query.getOrDefault("fields")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "fields", valid_579199
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

proc call*(call_579201: Call_DirectoryOrgunitsPatch_579188; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit. This method supports patch semantics.
  ## 
  let valid = call_579201.validator(path, query, header, formData, body)
  let scheme = call_579201.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579201.url(scheme.get, call_579201.host, call_579201.base,
                         call_579201.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579201, url, valid)

proc call*(call_579202: Call_DirectoryOrgunitsPatch_579188; orgUnitPath: string;
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
  var path_579203 = newJObject()
  var query_579204 = newJObject()
  var body_579205 = newJObject()
  add(query_579204, "key", newJString(key))
  add(path_579203, "orgUnitPath", newJString(orgUnitPath))
  add(query_579204, "prettyPrint", newJBool(prettyPrint))
  add(query_579204, "oauth_token", newJString(oauthToken))
  add(query_579204, "alt", newJString(alt))
  add(query_579204, "userIp", newJString(userIp))
  add(query_579204, "quotaUser", newJString(quotaUser))
  add(path_579203, "customerId", newJString(customerId))
  if body != nil:
    body_579205 = body
  add(query_579204, "fields", newJString(fields))
  result = call_579202.call(path_579203, query_579204, nil, nil, body_579205)

var directoryOrgunitsPatch* = Call_DirectoryOrgunitsPatch_579188(
    name: "directoryOrgunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsPatch_579189,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsPatch_579190,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsDelete_579172 = ref object of OpenApiRestCall_578364
proc url_DirectoryOrgunitsDelete_579174(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryOrgunitsDelete_579173(path: JsonNode; query: JsonNode;
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
  var valid_579175 = path.getOrDefault("orgUnitPath")
  valid_579175 = validateParameter(valid_579175, JString, required = true,
                                 default = nil)
  if valid_579175 != nil:
    section.add "orgUnitPath", valid_579175
  var valid_579176 = path.getOrDefault("customerId")
  valid_579176 = validateParameter(valid_579176, JString, required = true,
                                 default = nil)
  if valid_579176 != nil:
    section.add "customerId", valid_579176
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
  var valid_579177 = query.getOrDefault("key")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "key", valid_579177
  var valid_579178 = query.getOrDefault("prettyPrint")
  valid_579178 = validateParameter(valid_579178, JBool, required = false,
                                 default = newJBool(true))
  if valid_579178 != nil:
    section.add "prettyPrint", valid_579178
  var valid_579179 = query.getOrDefault("oauth_token")
  valid_579179 = validateParameter(valid_579179, JString, required = false,
                                 default = nil)
  if valid_579179 != nil:
    section.add "oauth_token", valid_579179
  var valid_579180 = query.getOrDefault("alt")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = newJString("json"))
  if valid_579180 != nil:
    section.add "alt", valid_579180
  var valid_579181 = query.getOrDefault("userIp")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = nil)
  if valid_579181 != nil:
    section.add "userIp", valid_579181
  var valid_579182 = query.getOrDefault("quotaUser")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = nil)
  if valid_579182 != nil:
    section.add "quotaUser", valid_579182
  var valid_579183 = query.getOrDefault("fields")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "fields", valid_579183
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579184: Call_DirectoryOrgunitsDelete_579172; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove Organization Unit
  ## 
  let valid = call_579184.validator(path, query, header, formData, body)
  let scheme = call_579184.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579184.url(scheme.get, call_579184.host, call_579184.base,
                         call_579184.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579184, url, valid)

proc call*(call_579185: Call_DirectoryOrgunitsDelete_579172; orgUnitPath: string;
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
  var path_579186 = newJObject()
  var query_579187 = newJObject()
  add(query_579187, "key", newJString(key))
  add(path_579186, "orgUnitPath", newJString(orgUnitPath))
  add(query_579187, "prettyPrint", newJBool(prettyPrint))
  add(query_579187, "oauth_token", newJString(oauthToken))
  add(query_579187, "alt", newJString(alt))
  add(query_579187, "userIp", newJString(userIp))
  add(query_579187, "quotaUser", newJString(quotaUser))
  add(path_579186, "customerId", newJString(customerId))
  add(query_579187, "fields", newJString(fields))
  result = call_579185.call(path_579186, query_579187, nil, nil, nil)

var directoryOrgunitsDelete* = Call_DirectoryOrgunitsDelete_579172(
    name: "directoryOrgunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsDelete_579173,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsDelete_579174,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasInsert_579221 = ref object of OpenApiRestCall_578364
proc url_DirectorySchemasInsert_579223(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectorySchemasInsert_579222(path: JsonNode; query: JsonNode;
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
  var valid_579224 = path.getOrDefault("customerId")
  valid_579224 = validateParameter(valid_579224, JString, required = true,
                                 default = nil)
  if valid_579224 != nil:
    section.add "customerId", valid_579224
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
  var valid_579225 = query.getOrDefault("key")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "key", valid_579225
  var valid_579226 = query.getOrDefault("prettyPrint")
  valid_579226 = validateParameter(valid_579226, JBool, required = false,
                                 default = newJBool(true))
  if valid_579226 != nil:
    section.add "prettyPrint", valid_579226
  var valid_579227 = query.getOrDefault("oauth_token")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "oauth_token", valid_579227
  var valid_579228 = query.getOrDefault("alt")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = newJString("json"))
  if valid_579228 != nil:
    section.add "alt", valid_579228
  var valid_579229 = query.getOrDefault("userIp")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "userIp", valid_579229
  var valid_579230 = query.getOrDefault("quotaUser")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "quotaUser", valid_579230
  var valid_579231 = query.getOrDefault("fields")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "fields", valid_579231
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

proc call*(call_579233: Call_DirectorySchemasInsert_579221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create schema.
  ## 
  let valid = call_579233.validator(path, query, header, formData, body)
  let scheme = call_579233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579233.url(scheme.get, call_579233.host, call_579233.base,
                         call_579233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579233, url, valid)

proc call*(call_579234: Call_DirectorySchemasInsert_579221; customerId: string;
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
  var path_579235 = newJObject()
  var query_579236 = newJObject()
  var body_579237 = newJObject()
  add(query_579236, "key", newJString(key))
  add(query_579236, "prettyPrint", newJBool(prettyPrint))
  add(query_579236, "oauth_token", newJString(oauthToken))
  add(query_579236, "alt", newJString(alt))
  add(query_579236, "userIp", newJString(userIp))
  add(query_579236, "quotaUser", newJString(quotaUser))
  add(path_579235, "customerId", newJString(customerId))
  if body != nil:
    body_579237 = body
  add(query_579236, "fields", newJString(fields))
  result = call_579234.call(path_579235, query_579236, nil, nil, body_579237)

var directorySchemasInsert* = Call_DirectorySchemasInsert_579221(
    name: "directorySchemasInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasInsert_579222,
    base: "/admin/directory/v1", url: url_DirectorySchemasInsert_579223,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasList_579206 = ref object of OpenApiRestCall_578364
proc url_DirectorySchemasList_579208(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectorySchemasList_579207(path: JsonNode; query: JsonNode;
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
  var valid_579209 = path.getOrDefault("customerId")
  valid_579209 = validateParameter(valid_579209, JString, required = true,
                                 default = nil)
  if valid_579209 != nil:
    section.add "customerId", valid_579209
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
  var valid_579210 = query.getOrDefault("key")
  valid_579210 = validateParameter(valid_579210, JString, required = false,
                                 default = nil)
  if valid_579210 != nil:
    section.add "key", valid_579210
  var valid_579211 = query.getOrDefault("prettyPrint")
  valid_579211 = validateParameter(valid_579211, JBool, required = false,
                                 default = newJBool(true))
  if valid_579211 != nil:
    section.add "prettyPrint", valid_579211
  var valid_579212 = query.getOrDefault("oauth_token")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = nil)
  if valid_579212 != nil:
    section.add "oauth_token", valid_579212
  var valid_579213 = query.getOrDefault("alt")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = newJString("json"))
  if valid_579213 != nil:
    section.add "alt", valid_579213
  var valid_579214 = query.getOrDefault("userIp")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "userIp", valid_579214
  var valid_579215 = query.getOrDefault("quotaUser")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "quotaUser", valid_579215
  var valid_579216 = query.getOrDefault("fields")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "fields", valid_579216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579217: Call_DirectorySchemasList_579206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all schemas for a customer
  ## 
  let valid = call_579217.validator(path, query, header, formData, body)
  let scheme = call_579217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579217.url(scheme.get, call_579217.host, call_579217.base,
                         call_579217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579217, url, valid)

proc call*(call_579218: Call_DirectorySchemasList_579206; customerId: string;
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
  var path_579219 = newJObject()
  var query_579220 = newJObject()
  add(query_579220, "key", newJString(key))
  add(query_579220, "prettyPrint", newJBool(prettyPrint))
  add(query_579220, "oauth_token", newJString(oauthToken))
  add(query_579220, "alt", newJString(alt))
  add(query_579220, "userIp", newJString(userIp))
  add(query_579220, "quotaUser", newJString(quotaUser))
  add(path_579219, "customerId", newJString(customerId))
  add(query_579220, "fields", newJString(fields))
  result = call_579218.call(path_579219, query_579220, nil, nil, nil)

var directorySchemasList* = Call_DirectorySchemasList_579206(
    name: "directorySchemasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasList_579207, base: "/admin/directory/v1",
    url: url_DirectorySchemasList_579208, schemes: {Scheme.Https})
type
  Call_DirectorySchemasUpdate_579254 = ref object of OpenApiRestCall_578364
proc url_DirectorySchemasUpdate_579256(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectorySchemasUpdate_579255(path: JsonNode; query: JsonNode;
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
  var valid_579257 = path.getOrDefault("schemaKey")
  valid_579257 = validateParameter(valid_579257, JString, required = true,
                                 default = nil)
  if valid_579257 != nil:
    section.add "schemaKey", valid_579257
  var valid_579258 = path.getOrDefault("customerId")
  valid_579258 = validateParameter(valid_579258, JString, required = true,
                                 default = nil)
  if valid_579258 != nil:
    section.add "customerId", valid_579258
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
  var valid_579259 = query.getOrDefault("key")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "key", valid_579259
  var valid_579260 = query.getOrDefault("prettyPrint")
  valid_579260 = validateParameter(valid_579260, JBool, required = false,
                                 default = newJBool(true))
  if valid_579260 != nil:
    section.add "prettyPrint", valid_579260
  var valid_579261 = query.getOrDefault("oauth_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "oauth_token", valid_579261
  var valid_579262 = query.getOrDefault("alt")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = newJString("json"))
  if valid_579262 != nil:
    section.add "alt", valid_579262
  var valid_579263 = query.getOrDefault("userIp")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = nil)
  if valid_579263 != nil:
    section.add "userIp", valid_579263
  var valid_579264 = query.getOrDefault("quotaUser")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "quotaUser", valid_579264
  var valid_579265 = query.getOrDefault("fields")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = nil)
  if valid_579265 != nil:
    section.add "fields", valid_579265
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

proc call*(call_579267: Call_DirectorySchemasUpdate_579254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema
  ## 
  let valid = call_579267.validator(path, query, header, formData, body)
  let scheme = call_579267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579267.url(scheme.get, call_579267.host, call_579267.base,
                         call_579267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579267, url, valid)

proc call*(call_579268: Call_DirectorySchemasUpdate_579254; schemaKey: string;
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
  var path_579269 = newJObject()
  var query_579270 = newJObject()
  var body_579271 = newJObject()
  add(query_579270, "key", newJString(key))
  add(query_579270, "prettyPrint", newJBool(prettyPrint))
  add(query_579270, "oauth_token", newJString(oauthToken))
  add(path_579269, "schemaKey", newJString(schemaKey))
  add(query_579270, "alt", newJString(alt))
  add(query_579270, "userIp", newJString(userIp))
  add(query_579270, "quotaUser", newJString(quotaUser))
  add(path_579269, "customerId", newJString(customerId))
  if body != nil:
    body_579271 = body
  add(query_579270, "fields", newJString(fields))
  result = call_579268.call(path_579269, query_579270, nil, nil, body_579271)

var directorySchemasUpdate* = Call_DirectorySchemasUpdate_579254(
    name: "directorySchemasUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasUpdate_579255,
    base: "/admin/directory/v1", url: url_DirectorySchemasUpdate_579256,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasGet_579238 = ref object of OpenApiRestCall_578364
proc url_DirectorySchemasGet_579240(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectorySchemasGet_579239(path: JsonNode; query: JsonNode;
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
  var valid_579241 = path.getOrDefault("schemaKey")
  valid_579241 = validateParameter(valid_579241, JString, required = true,
                                 default = nil)
  if valid_579241 != nil:
    section.add "schemaKey", valid_579241
  var valid_579242 = path.getOrDefault("customerId")
  valid_579242 = validateParameter(valid_579242, JString, required = true,
                                 default = nil)
  if valid_579242 != nil:
    section.add "customerId", valid_579242
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
  var valid_579243 = query.getOrDefault("key")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "key", valid_579243
  var valid_579244 = query.getOrDefault("prettyPrint")
  valid_579244 = validateParameter(valid_579244, JBool, required = false,
                                 default = newJBool(true))
  if valid_579244 != nil:
    section.add "prettyPrint", valid_579244
  var valid_579245 = query.getOrDefault("oauth_token")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = nil)
  if valid_579245 != nil:
    section.add "oauth_token", valid_579245
  var valid_579246 = query.getOrDefault("alt")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = newJString("json"))
  if valid_579246 != nil:
    section.add "alt", valid_579246
  var valid_579247 = query.getOrDefault("userIp")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "userIp", valid_579247
  var valid_579248 = query.getOrDefault("quotaUser")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "quotaUser", valid_579248
  var valid_579249 = query.getOrDefault("fields")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "fields", valid_579249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579250: Call_DirectorySchemasGet_579238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve schema
  ## 
  let valid = call_579250.validator(path, query, header, formData, body)
  let scheme = call_579250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579250.url(scheme.get, call_579250.host, call_579250.base,
                         call_579250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579250, url, valid)

proc call*(call_579251: Call_DirectorySchemasGet_579238; schemaKey: string;
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
  var path_579252 = newJObject()
  var query_579253 = newJObject()
  add(query_579253, "key", newJString(key))
  add(query_579253, "prettyPrint", newJBool(prettyPrint))
  add(query_579253, "oauth_token", newJString(oauthToken))
  add(path_579252, "schemaKey", newJString(schemaKey))
  add(query_579253, "alt", newJString(alt))
  add(query_579253, "userIp", newJString(userIp))
  add(query_579253, "quotaUser", newJString(quotaUser))
  add(path_579252, "customerId", newJString(customerId))
  add(query_579253, "fields", newJString(fields))
  result = call_579251.call(path_579252, query_579253, nil, nil, nil)

var directorySchemasGet* = Call_DirectorySchemasGet_579238(
    name: "directorySchemasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasGet_579239, base: "/admin/directory/v1",
    url: url_DirectorySchemasGet_579240, schemes: {Scheme.Https})
type
  Call_DirectorySchemasPatch_579288 = ref object of OpenApiRestCall_578364
proc url_DirectorySchemasPatch_579290(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectorySchemasPatch_579289(path: JsonNode; query: JsonNode;
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
  var valid_579291 = path.getOrDefault("schemaKey")
  valid_579291 = validateParameter(valid_579291, JString, required = true,
                                 default = nil)
  if valid_579291 != nil:
    section.add "schemaKey", valid_579291
  var valid_579292 = path.getOrDefault("customerId")
  valid_579292 = validateParameter(valid_579292, JString, required = true,
                                 default = nil)
  if valid_579292 != nil:
    section.add "customerId", valid_579292
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
  var valid_579293 = query.getOrDefault("key")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "key", valid_579293
  var valid_579294 = query.getOrDefault("prettyPrint")
  valid_579294 = validateParameter(valid_579294, JBool, required = false,
                                 default = newJBool(true))
  if valid_579294 != nil:
    section.add "prettyPrint", valid_579294
  var valid_579295 = query.getOrDefault("oauth_token")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "oauth_token", valid_579295
  var valid_579296 = query.getOrDefault("alt")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = newJString("json"))
  if valid_579296 != nil:
    section.add "alt", valid_579296
  var valid_579297 = query.getOrDefault("userIp")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = nil)
  if valid_579297 != nil:
    section.add "userIp", valid_579297
  var valid_579298 = query.getOrDefault("quotaUser")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "quotaUser", valid_579298
  var valid_579299 = query.getOrDefault("fields")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "fields", valid_579299
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

proc call*(call_579301: Call_DirectorySchemasPatch_579288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema. This method supports patch semantics.
  ## 
  let valid = call_579301.validator(path, query, header, formData, body)
  let scheme = call_579301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579301.url(scheme.get, call_579301.host, call_579301.base,
                         call_579301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579301, url, valid)

proc call*(call_579302: Call_DirectorySchemasPatch_579288; schemaKey: string;
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
  var path_579303 = newJObject()
  var query_579304 = newJObject()
  var body_579305 = newJObject()
  add(query_579304, "key", newJString(key))
  add(query_579304, "prettyPrint", newJBool(prettyPrint))
  add(query_579304, "oauth_token", newJString(oauthToken))
  add(path_579303, "schemaKey", newJString(schemaKey))
  add(query_579304, "alt", newJString(alt))
  add(query_579304, "userIp", newJString(userIp))
  add(query_579304, "quotaUser", newJString(quotaUser))
  add(path_579303, "customerId", newJString(customerId))
  if body != nil:
    body_579305 = body
  add(query_579304, "fields", newJString(fields))
  result = call_579302.call(path_579303, query_579304, nil, nil, body_579305)

var directorySchemasPatch* = Call_DirectorySchemasPatch_579288(
    name: "directorySchemasPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasPatch_579289, base: "/admin/directory/v1",
    url: url_DirectorySchemasPatch_579290, schemes: {Scheme.Https})
type
  Call_DirectorySchemasDelete_579272 = ref object of OpenApiRestCall_578364
proc url_DirectorySchemasDelete_579274(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectorySchemasDelete_579273(path: JsonNode; query: JsonNode;
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
  var valid_579275 = path.getOrDefault("schemaKey")
  valid_579275 = validateParameter(valid_579275, JString, required = true,
                                 default = nil)
  if valid_579275 != nil:
    section.add "schemaKey", valid_579275
  var valid_579276 = path.getOrDefault("customerId")
  valid_579276 = validateParameter(valid_579276, JString, required = true,
                                 default = nil)
  if valid_579276 != nil:
    section.add "customerId", valid_579276
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
  var valid_579277 = query.getOrDefault("key")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "key", valid_579277
  var valid_579278 = query.getOrDefault("prettyPrint")
  valid_579278 = validateParameter(valid_579278, JBool, required = false,
                                 default = newJBool(true))
  if valid_579278 != nil:
    section.add "prettyPrint", valid_579278
  var valid_579279 = query.getOrDefault("oauth_token")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "oauth_token", valid_579279
  var valid_579280 = query.getOrDefault("alt")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = newJString("json"))
  if valid_579280 != nil:
    section.add "alt", valid_579280
  var valid_579281 = query.getOrDefault("userIp")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "userIp", valid_579281
  var valid_579282 = query.getOrDefault("quotaUser")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "quotaUser", valid_579282
  var valid_579283 = query.getOrDefault("fields")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "fields", valid_579283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579284: Call_DirectorySchemasDelete_579272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schema
  ## 
  let valid = call_579284.validator(path, query, header, formData, body)
  let scheme = call_579284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579284.url(scheme.get, call_579284.host, call_579284.base,
                         call_579284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579284, url, valid)

proc call*(call_579285: Call_DirectorySchemasDelete_579272; schemaKey: string;
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
  var path_579286 = newJObject()
  var query_579287 = newJObject()
  add(query_579287, "key", newJString(key))
  add(query_579287, "prettyPrint", newJBool(prettyPrint))
  add(query_579287, "oauth_token", newJString(oauthToken))
  add(path_579286, "schemaKey", newJString(schemaKey))
  add(query_579287, "alt", newJString(alt))
  add(query_579287, "userIp", newJString(userIp))
  add(query_579287, "quotaUser", newJString(quotaUser))
  add(path_579286, "customerId", newJString(customerId))
  add(query_579287, "fields", newJString(fields))
  result = call_579285.call(path_579286, query_579287, nil, nil, nil)

var directorySchemasDelete* = Call_DirectorySchemasDelete_579272(
    name: "directorySchemasDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasDelete_579273,
    base: "/admin/directory/v1", url: url_DirectorySchemasDelete_579274,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesInsert_579322 = ref object of OpenApiRestCall_578364
proc url_DirectoryDomainAliasesInsert_579324(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryDomainAliasesInsert_579323(path: JsonNode; query: JsonNode;
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
  var valid_579325 = path.getOrDefault("customer")
  valid_579325 = validateParameter(valid_579325, JString, required = true,
                                 default = nil)
  if valid_579325 != nil:
    section.add "customer", valid_579325
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
  var valid_579326 = query.getOrDefault("key")
  valid_579326 = validateParameter(valid_579326, JString, required = false,
                                 default = nil)
  if valid_579326 != nil:
    section.add "key", valid_579326
  var valid_579327 = query.getOrDefault("prettyPrint")
  valid_579327 = validateParameter(valid_579327, JBool, required = false,
                                 default = newJBool(true))
  if valid_579327 != nil:
    section.add "prettyPrint", valid_579327
  var valid_579328 = query.getOrDefault("oauth_token")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = nil)
  if valid_579328 != nil:
    section.add "oauth_token", valid_579328
  var valid_579329 = query.getOrDefault("alt")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = newJString("json"))
  if valid_579329 != nil:
    section.add "alt", valid_579329
  var valid_579330 = query.getOrDefault("userIp")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "userIp", valid_579330
  var valid_579331 = query.getOrDefault("quotaUser")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "quotaUser", valid_579331
  var valid_579332 = query.getOrDefault("fields")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "fields", valid_579332
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

proc call*(call_579334: Call_DirectoryDomainAliasesInsert_579322; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a Domain alias of the customer.
  ## 
  let valid = call_579334.validator(path, query, header, formData, body)
  let scheme = call_579334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579334.url(scheme.get, call_579334.host, call_579334.base,
                         call_579334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579334, url, valid)

proc call*(call_579335: Call_DirectoryDomainAliasesInsert_579322; customer: string;
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
  var path_579336 = newJObject()
  var query_579337 = newJObject()
  var body_579338 = newJObject()
  add(query_579337, "key", newJString(key))
  add(query_579337, "prettyPrint", newJBool(prettyPrint))
  add(query_579337, "oauth_token", newJString(oauthToken))
  add(path_579336, "customer", newJString(customer))
  add(query_579337, "alt", newJString(alt))
  add(query_579337, "userIp", newJString(userIp))
  add(query_579337, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579338 = body
  add(query_579337, "fields", newJString(fields))
  result = call_579335.call(path_579336, query_579337, nil, nil, body_579338)

var directoryDomainAliasesInsert* = Call_DirectoryDomainAliasesInsert_579322(
    name: "directoryDomainAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesInsert_579323,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesInsert_579324,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesList_579306 = ref object of OpenApiRestCall_578364
proc url_DirectoryDomainAliasesList_579308(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryDomainAliasesList_579307(path: JsonNode; query: JsonNode;
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
  var valid_579309 = path.getOrDefault("customer")
  valid_579309 = validateParameter(valid_579309, JString, required = true,
                                 default = nil)
  if valid_579309 != nil:
    section.add "customer", valid_579309
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
  var valid_579310 = query.getOrDefault("key")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "key", valid_579310
  var valid_579311 = query.getOrDefault("prettyPrint")
  valid_579311 = validateParameter(valid_579311, JBool, required = false,
                                 default = newJBool(true))
  if valid_579311 != nil:
    section.add "prettyPrint", valid_579311
  var valid_579312 = query.getOrDefault("oauth_token")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "oauth_token", valid_579312
  var valid_579313 = query.getOrDefault("alt")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = newJString("json"))
  if valid_579313 != nil:
    section.add "alt", valid_579313
  var valid_579314 = query.getOrDefault("userIp")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "userIp", valid_579314
  var valid_579315 = query.getOrDefault("quotaUser")
  valid_579315 = validateParameter(valid_579315, JString, required = false,
                                 default = nil)
  if valid_579315 != nil:
    section.add "quotaUser", valid_579315
  var valid_579316 = query.getOrDefault("parentDomainName")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "parentDomainName", valid_579316
  var valid_579317 = query.getOrDefault("fields")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = nil)
  if valid_579317 != nil:
    section.add "fields", valid_579317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579318: Call_DirectoryDomainAliasesList_579306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domain aliases of the customer.
  ## 
  let valid = call_579318.validator(path, query, header, formData, body)
  let scheme = call_579318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579318.url(scheme.get, call_579318.host, call_579318.base,
                         call_579318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579318, url, valid)

proc call*(call_579319: Call_DirectoryDomainAliasesList_579306; customer: string;
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
  var path_579320 = newJObject()
  var query_579321 = newJObject()
  add(query_579321, "key", newJString(key))
  add(query_579321, "prettyPrint", newJBool(prettyPrint))
  add(query_579321, "oauth_token", newJString(oauthToken))
  add(path_579320, "customer", newJString(customer))
  add(query_579321, "alt", newJString(alt))
  add(query_579321, "userIp", newJString(userIp))
  add(query_579321, "quotaUser", newJString(quotaUser))
  add(query_579321, "parentDomainName", newJString(parentDomainName))
  add(query_579321, "fields", newJString(fields))
  result = call_579319.call(path_579320, query_579321, nil, nil, nil)

var directoryDomainAliasesList* = Call_DirectoryDomainAliasesList_579306(
    name: "directoryDomainAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesList_579307,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesList_579308,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesGet_579339 = ref object of OpenApiRestCall_578364
proc url_DirectoryDomainAliasesGet_579341(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryDomainAliasesGet_579340(path: JsonNode; query: JsonNode;
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
  var valid_579342 = path.getOrDefault("customer")
  valid_579342 = validateParameter(valid_579342, JString, required = true,
                                 default = nil)
  if valid_579342 != nil:
    section.add "customer", valid_579342
  var valid_579343 = path.getOrDefault("domainAliasName")
  valid_579343 = validateParameter(valid_579343, JString, required = true,
                                 default = nil)
  if valid_579343 != nil:
    section.add "domainAliasName", valid_579343
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
  var valid_579344 = query.getOrDefault("key")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "key", valid_579344
  var valid_579345 = query.getOrDefault("prettyPrint")
  valid_579345 = validateParameter(valid_579345, JBool, required = false,
                                 default = newJBool(true))
  if valid_579345 != nil:
    section.add "prettyPrint", valid_579345
  var valid_579346 = query.getOrDefault("oauth_token")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "oauth_token", valid_579346
  var valid_579347 = query.getOrDefault("alt")
  valid_579347 = validateParameter(valid_579347, JString, required = false,
                                 default = newJString("json"))
  if valid_579347 != nil:
    section.add "alt", valid_579347
  var valid_579348 = query.getOrDefault("userIp")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "userIp", valid_579348
  var valid_579349 = query.getOrDefault("quotaUser")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = nil)
  if valid_579349 != nil:
    section.add "quotaUser", valid_579349
  var valid_579350 = query.getOrDefault("fields")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = nil)
  if valid_579350 != nil:
    section.add "fields", valid_579350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579351: Call_DirectoryDomainAliasesGet_579339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain alias of the customer.
  ## 
  let valid = call_579351.validator(path, query, header, formData, body)
  let scheme = call_579351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579351.url(scheme.get, call_579351.host, call_579351.base,
                         call_579351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579351, url, valid)

proc call*(call_579352: Call_DirectoryDomainAliasesGet_579339; customer: string;
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
  var path_579353 = newJObject()
  var query_579354 = newJObject()
  add(query_579354, "key", newJString(key))
  add(query_579354, "prettyPrint", newJBool(prettyPrint))
  add(query_579354, "oauth_token", newJString(oauthToken))
  add(path_579353, "customer", newJString(customer))
  add(query_579354, "alt", newJString(alt))
  add(query_579354, "userIp", newJString(userIp))
  add(query_579354, "quotaUser", newJString(quotaUser))
  add(path_579353, "domainAliasName", newJString(domainAliasName))
  add(query_579354, "fields", newJString(fields))
  result = call_579352.call(path_579353, query_579354, nil, nil, nil)

var directoryDomainAliasesGet* = Call_DirectoryDomainAliasesGet_579339(
    name: "directoryDomainAliasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesGet_579340,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesGet_579341,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesDelete_579355 = ref object of OpenApiRestCall_578364
proc url_DirectoryDomainAliasesDelete_579357(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryDomainAliasesDelete_579356(path: JsonNode; query: JsonNode;
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
  var valid_579358 = path.getOrDefault("customer")
  valid_579358 = validateParameter(valid_579358, JString, required = true,
                                 default = nil)
  if valid_579358 != nil:
    section.add "customer", valid_579358
  var valid_579359 = path.getOrDefault("domainAliasName")
  valid_579359 = validateParameter(valid_579359, JString, required = true,
                                 default = nil)
  if valid_579359 != nil:
    section.add "domainAliasName", valid_579359
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
  var valid_579360 = query.getOrDefault("key")
  valid_579360 = validateParameter(valid_579360, JString, required = false,
                                 default = nil)
  if valid_579360 != nil:
    section.add "key", valid_579360
  var valid_579361 = query.getOrDefault("prettyPrint")
  valid_579361 = validateParameter(valid_579361, JBool, required = false,
                                 default = newJBool(true))
  if valid_579361 != nil:
    section.add "prettyPrint", valid_579361
  var valid_579362 = query.getOrDefault("oauth_token")
  valid_579362 = validateParameter(valid_579362, JString, required = false,
                                 default = nil)
  if valid_579362 != nil:
    section.add "oauth_token", valid_579362
  var valid_579363 = query.getOrDefault("alt")
  valid_579363 = validateParameter(valid_579363, JString, required = false,
                                 default = newJString("json"))
  if valid_579363 != nil:
    section.add "alt", valid_579363
  var valid_579364 = query.getOrDefault("userIp")
  valid_579364 = validateParameter(valid_579364, JString, required = false,
                                 default = nil)
  if valid_579364 != nil:
    section.add "userIp", valid_579364
  var valid_579365 = query.getOrDefault("quotaUser")
  valid_579365 = validateParameter(valid_579365, JString, required = false,
                                 default = nil)
  if valid_579365 != nil:
    section.add "quotaUser", valid_579365
  var valid_579366 = query.getOrDefault("fields")
  valid_579366 = validateParameter(valid_579366, JString, required = false,
                                 default = nil)
  if valid_579366 != nil:
    section.add "fields", valid_579366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579367: Call_DirectoryDomainAliasesDelete_579355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Domain Alias of the customer.
  ## 
  let valid = call_579367.validator(path, query, header, formData, body)
  let scheme = call_579367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579367.url(scheme.get, call_579367.host, call_579367.base,
                         call_579367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579367, url, valid)

proc call*(call_579368: Call_DirectoryDomainAliasesDelete_579355; customer: string;
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
  var path_579369 = newJObject()
  var query_579370 = newJObject()
  add(query_579370, "key", newJString(key))
  add(query_579370, "prettyPrint", newJBool(prettyPrint))
  add(query_579370, "oauth_token", newJString(oauthToken))
  add(path_579369, "customer", newJString(customer))
  add(query_579370, "alt", newJString(alt))
  add(query_579370, "userIp", newJString(userIp))
  add(query_579370, "quotaUser", newJString(quotaUser))
  add(path_579369, "domainAliasName", newJString(domainAliasName))
  add(query_579370, "fields", newJString(fields))
  result = call_579368.call(path_579369, query_579370, nil, nil, nil)

var directoryDomainAliasesDelete* = Call_DirectoryDomainAliasesDelete_579355(
    name: "directoryDomainAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesDelete_579356,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesDelete_579357,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsInsert_579386 = ref object of OpenApiRestCall_578364
proc url_DirectoryDomainsInsert_579388(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryDomainsInsert_579387(path: JsonNode; query: JsonNode;
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
  var valid_579389 = path.getOrDefault("customer")
  valid_579389 = validateParameter(valid_579389, JString, required = true,
                                 default = nil)
  if valid_579389 != nil:
    section.add "customer", valid_579389
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
  var valid_579390 = query.getOrDefault("key")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "key", valid_579390
  var valid_579391 = query.getOrDefault("prettyPrint")
  valid_579391 = validateParameter(valid_579391, JBool, required = false,
                                 default = newJBool(true))
  if valid_579391 != nil:
    section.add "prettyPrint", valid_579391
  var valid_579392 = query.getOrDefault("oauth_token")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = nil)
  if valid_579392 != nil:
    section.add "oauth_token", valid_579392
  var valid_579393 = query.getOrDefault("alt")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = newJString("json"))
  if valid_579393 != nil:
    section.add "alt", valid_579393
  var valid_579394 = query.getOrDefault("userIp")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "userIp", valid_579394
  var valid_579395 = query.getOrDefault("quotaUser")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "quotaUser", valid_579395
  var valid_579396 = query.getOrDefault("fields")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "fields", valid_579396
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

proc call*(call_579398: Call_DirectoryDomainsInsert_579386; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a domain of the customer.
  ## 
  let valid = call_579398.validator(path, query, header, formData, body)
  let scheme = call_579398.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579398.url(scheme.get, call_579398.host, call_579398.base,
                         call_579398.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579398, url, valid)

proc call*(call_579399: Call_DirectoryDomainsInsert_579386; customer: string;
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
  var path_579400 = newJObject()
  var query_579401 = newJObject()
  var body_579402 = newJObject()
  add(query_579401, "key", newJString(key))
  add(query_579401, "prettyPrint", newJBool(prettyPrint))
  add(query_579401, "oauth_token", newJString(oauthToken))
  add(path_579400, "customer", newJString(customer))
  add(query_579401, "alt", newJString(alt))
  add(query_579401, "userIp", newJString(userIp))
  add(query_579401, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579402 = body
  add(query_579401, "fields", newJString(fields))
  result = call_579399.call(path_579400, query_579401, nil, nil, body_579402)

var directoryDomainsInsert* = Call_DirectoryDomainsInsert_579386(
    name: "directoryDomainsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsInsert_579387,
    base: "/admin/directory/v1", url: url_DirectoryDomainsInsert_579388,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsList_579371 = ref object of OpenApiRestCall_578364
proc url_DirectoryDomainsList_579373(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryDomainsList_579372(path: JsonNode; query: JsonNode;
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
  var valid_579374 = path.getOrDefault("customer")
  valid_579374 = validateParameter(valid_579374, JString, required = true,
                                 default = nil)
  if valid_579374 != nil:
    section.add "customer", valid_579374
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
  var valid_579375 = query.getOrDefault("key")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "key", valid_579375
  var valid_579376 = query.getOrDefault("prettyPrint")
  valid_579376 = validateParameter(valid_579376, JBool, required = false,
                                 default = newJBool(true))
  if valid_579376 != nil:
    section.add "prettyPrint", valid_579376
  var valid_579377 = query.getOrDefault("oauth_token")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "oauth_token", valid_579377
  var valid_579378 = query.getOrDefault("alt")
  valid_579378 = validateParameter(valid_579378, JString, required = false,
                                 default = newJString("json"))
  if valid_579378 != nil:
    section.add "alt", valid_579378
  var valid_579379 = query.getOrDefault("userIp")
  valid_579379 = validateParameter(valid_579379, JString, required = false,
                                 default = nil)
  if valid_579379 != nil:
    section.add "userIp", valid_579379
  var valid_579380 = query.getOrDefault("quotaUser")
  valid_579380 = validateParameter(valid_579380, JString, required = false,
                                 default = nil)
  if valid_579380 != nil:
    section.add "quotaUser", valid_579380
  var valid_579381 = query.getOrDefault("fields")
  valid_579381 = validateParameter(valid_579381, JString, required = false,
                                 default = nil)
  if valid_579381 != nil:
    section.add "fields", valid_579381
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579382: Call_DirectoryDomainsList_579371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domains of the customer.
  ## 
  let valid = call_579382.validator(path, query, header, formData, body)
  let scheme = call_579382.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579382.url(scheme.get, call_579382.host, call_579382.base,
                         call_579382.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579382, url, valid)

proc call*(call_579383: Call_DirectoryDomainsList_579371; customer: string;
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
  var path_579384 = newJObject()
  var query_579385 = newJObject()
  add(query_579385, "key", newJString(key))
  add(query_579385, "prettyPrint", newJBool(prettyPrint))
  add(query_579385, "oauth_token", newJString(oauthToken))
  add(path_579384, "customer", newJString(customer))
  add(query_579385, "alt", newJString(alt))
  add(query_579385, "userIp", newJString(userIp))
  add(query_579385, "quotaUser", newJString(quotaUser))
  add(query_579385, "fields", newJString(fields))
  result = call_579383.call(path_579384, query_579385, nil, nil, nil)

var directoryDomainsList* = Call_DirectoryDomainsList_579371(
    name: "directoryDomainsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsList_579372, base: "/admin/directory/v1",
    url: url_DirectoryDomainsList_579373, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsGet_579403 = ref object of OpenApiRestCall_578364
proc url_DirectoryDomainsGet_579405(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryDomainsGet_579404(path: JsonNode; query: JsonNode;
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
  var valid_579406 = path.getOrDefault("customer")
  valid_579406 = validateParameter(valid_579406, JString, required = true,
                                 default = nil)
  if valid_579406 != nil:
    section.add "customer", valid_579406
  var valid_579407 = path.getOrDefault("domainName")
  valid_579407 = validateParameter(valid_579407, JString, required = true,
                                 default = nil)
  if valid_579407 != nil:
    section.add "domainName", valid_579407
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
  var valid_579408 = query.getOrDefault("key")
  valid_579408 = validateParameter(valid_579408, JString, required = false,
                                 default = nil)
  if valid_579408 != nil:
    section.add "key", valid_579408
  var valid_579409 = query.getOrDefault("prettyPrint")
  valid_579409 = validateParameter(valid_579409, JBool, required = false,
                                 default = newJBool(true))
  if valid_579409 != nil:
    section.add "prettyPrint", valid_579409
  var valid_579410 = query.getOrDefault("oauth_token")
  valid_579410 = validateParameter(valid_579410, JString, required = false,
                                 default = nil)
  if valid_579410 != nil:
    section.add "oauth_token", valid_579410
  var valid_579411 = query.getOrDefault("alt")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = newJString("json"))
  if valid_579411 != nil:
    section.add "alt", valid_579411
  var valid_579412 = query.getOrDefault("userIp")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = nil)
  if valid_579412 != nil:
    section.add "userIp", valid_579412
  var valid_579413 = query.getOrDefault("quotaUser")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = nil)
  if valid_579413 != nil:
    section.add "quotaUser", valid_579413
  var valid_579414 = query.getOrDefault("fields")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "fields", valid_579414
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579415: Call_DirectoryDomainsGet_579403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain of the customer.
  ## 
  let valid = call_579415.validator(path, query, header, formData, body)
  let scheme = call_579415.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579415.url(scheme.get, call_579415.host, call_579415.base,
                         call_579415.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579415, url, valid)

proc call*(call_579416: Call_DirectoryDomainsGet_579403; customer: string;
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
  var path_579417 = newJObject()
  var query_579418 = newJObject()
  add(query_579418, "key", newJString(key))
  add(query_579418, "prettyPrint", newJBool(prettyPrint))
  add(query_579418, "oauth_token", newJString(oauthToken))
  add(path_579417, "customer", newJString(customer))
  add(query_579418, "alt", newJString(alt))
  add(query_579418, "userIp", newJString(userIp))
  add(query_579418, "quotaUser", newJString(quotaUser))
  add(path_579417, "domainName", newJString(domainName))
  add(query_579418, "fields", newJString(fields))
  result = call_579416.call(path_579417, query_579418, nil, nil, nil)

var directoryDomainsGet* = Call_DirectoryDomainsGet_579403(
    name: "directoryDomainsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsGet_579404, base: "/admin/directory/v1",
    url: url_DirectoryDomainsGet_579405, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsDelete_579419 = ref object of OpenApiRestCall_578364
proc url_DirectoryDomainsDelete_579421(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryDomainsDelete_579420(path: JsonNode; query: JsonNode;
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
  var valid_579422 = path.getOrDefault("customer")
  valid_579422 = validateParameter(valid_579422, JString, required = true,
                                 default = nil)
  if valid_579422 != nil:
    section.add "customer", valid_579422
  var valid_579423 = path.getOrDefault("domainName")
  valid_579423 = validateParameter(valid_579423, JString, required = true,
                                 default = nil)
  if valid_579423 != nil:
    section.add "domainName", valid_579423
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
  var valid_579424 = query.getOrDefault("key")
  valid_579424 = validateParameter(valid_579424, JString, required = false,
                                 default = nil)
  if valid_579424 != nil:
    section.add "key", valid_579424
  var valid_579425 = query.getOrDefault("prettyPrint")
  valid_579425 = validateParameter(valid_579425, JBool, required = false,
                                 default = newJBool(true))
  if valid_579425 != nil:
    section.add "prettyPrint", valid_579425
  var valid_579426 = query.getOrDefault("oauth_token")
  valid_579426 = validateParameter(valid_579426, JString, required = false,
                                 default = nil)
  if valid_579426 != nil:
    section.add "oauth_token", valid_579426
  var valid_579427 = query.getOrDefault("alt")
  valid_579427 = validateParameter(valid_579427, JString, required = false,
                                 default = newJString("json"))
  if valid_579427 != nil:
    section.add "alt", valid_579427
  var valid_579428 = query.getOrDefault("userIp")
  valid_579428 = validateParameter(valid_579428, JString, required = false,
                                 default = nil)
  if valid_579428 != nil:
    section.add "userIp", valid_579428
  var valid_579429 = query.getOrDefault("quotaUser")
  valid_579429 = validateParameter(valid_579429, JString, required = false,
                                 default = nil)
  if valid_579429 != nil:
    section.add "quotaUser", valid_579429
  var valid_579430 = query.getOrDefault("fields")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "fields", valid_579430
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579431: Call_DirectoryDomainsDelete_579419; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a domain of the customer.
  ## 
  let valid = call_579431.validator(path, query, header, formData, body)
  let scheme = call_579431.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579431.url(scheme.get, call_579431.host, call_579431.base,
                         call_579431.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579431, url, valid)

proc call*(call_579432: Call_DirectoryDomainsDelete_579419; customer: string;
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
  var path_579433 = newJObject()
  var query_579434 = newJObject()
  add(query_579434, "key", newJString(key))
  add(query_579434, "prettyPrint", newJBool(prettyPrint))
  add(query_579434, "oauth_token", newJString(oauthToken))
  add(path_579433, "customer", newJString(customer))
  add(query_579434, "alt", newJString(alt))
  add(query_579434, "userIp", newJString(userIp))
  add(query_579434, "quotaUser", newJString(quotaUser))
  add(path_579433, "domainName", newJString(domainName))
  add(query_579434, "fields", newJString(fields))
  result = call_579432.call(path_579433, query_579434, nil, nil, nil)

var directoryDomainsDelete* = Call_DirectoryDomainsDelete_579419(
    name: "directoryDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsDelete_579420,
    base: "/admin/directory/v1", url: url_DirectoryDomainsDelete_579421,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsList_579435 = ref object of OpenApiRestCall_578364
proc url_DirectoryNotificationsList_579437(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryNotificationsList_579436(path: JsonNode; query: JsonNode;
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
  var valid_579438 = path.getOrDefault("customer")
  valid_579438 = validateParameter(valid_579438, JString, required = true,
                                 default = nil)
  if valid_579438 != nil:
    section.add "customer", valid_579438
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
  var valid_579439 = query.getOrDefault("key")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "key", valid_579439
  var valid_579440 = query.getOrDefault("prettyPrint")
  valid_579440 = validateParameter(valid_579440, JBool, required = false,
                                 default = newJBool(true))
  if valid_579440 != nil:
    section.add "prettyPrint", valid_579440
  var valid_579441 = query.getOrDefault("oauth_token")
  valid_579441 = validateParameter(valid_579441, JString, required = false,
                                 default = nil)
  if valid_579441 != nil:
    section.add "oauth_token", valid_579441
  var valid_579442 = query.getOrDefault("alt")
  valid_579442 = validateParameter(valid_579442, JString, required = false,
                                 default = newJString("json"))
  if valid_579442 != nil:
    section.add "alt", valid_579442
  var valid_579443 = query.getOrDefault("userIp")
  valid_579443 = validateParameter(valid_579443, JString, required = false,
                                 default = nil)
  if valid_579443 != nil:
    section.add "userIp", valid_579443
  var valid_579444 = query.getOrDefault("quotaUser")
  valid_579444 = validateParameter(valid_579444, JString, required = false,
                                 default = nil)
  if valid_579444 != nil:
    section.add "quotaUser", valid_579444
  var valid_579445 = query.getOrDefault("pageToken")
  valid_579445 = validateParameter(valid_579445, JString, required = false,
                                 default = nil)
  if valid_579445 != nil:
    section.add "pageToken", valid_579445
  var valid_579446 = query.getOrDefault("fields")
  valid_579446 = validateParameter(valid_579446, JString, required = false,
                                 default = nil)
  if valid_579446 != nil:
    section.add "fields", valid_579446
  var valid_579447 = query.getOrDefault("language")
  valid_579447 = validateParameter(valid_579447, JString, required = false,
                                 default = nil)
  if valid_579447 != nil:
    section.add "language", valid_579447
  var valid_579448 = query.getOrDefault("maxResults")
  valid_579448 = validateParameter(valid_579448, JInt, required = false, default = nil)
  if valid_579448 != nil:
    section.add "maxResults", valid_579448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579449: Call_DirectoryNotificationsList_579435; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notifications.
  ## 
  let valid = call_579449.validator(path, query, header, formData, body)
  let scheme = call_579449.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579449.url(scheme.get, call_579449.host, call_579449.base,
                         call_579449.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579449, url, valid)

proc call*(call_579450: Call_DirectoryNotificationsList_579435; customer: string;
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
  var path_579451 = newJObject()
  var query_579452 = newJObject()
  add(query_579452, "key", newJString(key))
  add(query_579452, "prettyPrint", newJBool(prettyPrint))
  add(query_579452, "oauth_token", newJString(oauthToken))
  add(path_579451, "customer", newJString(customer))
  add(query_579452, "alt", newJString(alt))
  add(query_579452, "userIp", newJString(userIp))
  add(query_579452, "quotaUser", newJString(quotaUser))
  add(query_579452, "pageToken", newJString(pageToken))
  add(query_579452, "fields", newJString(fields))
  add(query_579452, "language", newJString(language))
  add(query_579452, "maxResults", newJInt(maxResults))
  result = call_579450.call(path_579451, query_579452, nil, nil, nil)

var directoryNotificationsList* = Call_DirectoryNotificationsList_579435(
    name: "directoryNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/notifications",
    validator: validate_DirectoryNotificationsList_579436,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsList_579437,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsUpdate_579469 = ref object of OpenApiRestCall_578364
proc url_DirectoryNotificationsUpdate_579471(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryNotificationsUpdate_579470(path: JsonNode; query: JsonNode;
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
  var valid_579472 = path.getOrDefault("notificationId")
  valid_579472 = validateParameter(valid_579472, JString, required = true,
                                 default = nil)
  if valid_579472 != nil:
    section.add "notificationId", valid_579472
  var valid_579473 = path.getOrDefault("customer")
  valid_579473 = validateParameter(valid_579473, JString, required = true,
                                 default = nil)
  if valid_579473 != nil:
    section.add "customer", valid_579473
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
  var valid_579474 = query.getOrDefault("key")
  valid_579474 = validateParameter(valid_579474, JString, required = false,
                                 default = nil)
  if valid_579474 != nil:
    section.add "key", valid_579474
  var valid_579475 = query.getOrDefault("prettyPrint")
  valid_579475 = validateParameter(valid_579475, JBool, required = false,
                                 default = newJBool(true))
  if valid_579475 != nil:
    section.add "prettyPrint", valid_579475
  var valid_579476 = query.getOrDefault("oauth_token")
  valid_579476 = validateParameter(valid_579476, JString, required = false,
                                 default = nil)
  if valid_579476 != nil:
    section.add "oauth_token", valid_579476
  var valid_579477 = query.getOrDefault("alt")
  valid_579477 = validateParameter(valid_579477, JString, required = false,
                                 default = newJString("json"))
  if valid_579477 != nil:
    section.add "alt", valid_579477
  var valid_579478 = query.getOrDefault("userIp")
  valid_579478 = validateParameter(valid_579478, JString, required = false,
                                 default = nil)
  if valid_579478 != nil:
    section.add "userIp", valid_579478
  var valid_579479 = query.getOrDefault("quotaUser")
  valid_579479 = validateParameter(valid_579479, JString, required = false,
                                 default = nil)
  if valid_579479 != nil:
    section.add "quotaUser", valid_579479
  var valid_579480 = query.getOrDefault("fields")
  valid_579480 = validateParameter(valid_579480, JString, required = false,
                                 default = nil)
  if valid_579480 != nil:
    section.add "fields", valid_579480
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

proc call*(call_579482: Call_DirectoryNotificationsUpdate_579469; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification.
  ## 
  let valid = call_579482.validator(path, query, header, formData, body)
  let scheme = call_579482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579482.url(scheme.get, call_579482.host, call_579482.base,
                         call_579482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579482, url, valid)

proc call*(call_579483: Call_DirectoryNotificationsUpdate_579469;
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
  var path_579484 = newJObject()
  var query_579485 = newJObject()
  var body_579486 = newJObject()
  add(query_579485, "key", newJString(key))
  add(query_579485, "prettyPrint", newJBool(prettyPrint))
  add(query_579485, "oauth_token", newJString(oauthToken))
  add(path_579484, "notificationId", newJString(notificationId))
  add(path_579484, "customer", newJString(customer))
  add(query_579485, "alt", newJString(alt))
  add(query_579485, "userIp", newJString(userIp))
  add(query_579485, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579486 = body
  add(query_579485, "fields", newJString(fields))
  result = call_579483.call(path_579484, query_579485, nil, nil, body_579486)

var directoryNotificationsUpdate* = Call_DirectoryNotificationsUpdate_579469(
    name: "directoryNotificationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsUpdate_579470,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsUpdate_579471,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsGet_579453 = ref object of OpenApiRestCall_578364
proc url_DirectoryNotificationsGet_579455(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryNotificationsGet_579454(path: JsonNode; query: JsonNode;
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
  var valid_579456 = path.getOrDefault("notificationId")
  valid_579456 = validateParameter(valid_579456, JString, required = true,
                                 default = nil)
  if valid_579456 != nil:
    section.add "notificationId", valid_579456
  var valid_579457 = path.getOrDefault("customer")
  valid_579457 = validateParameter(valid_579457, JString, required = true,
                                 default = nil)
  if valid_579457 != nil:
    section.add "customer", valid_579457
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
  var valid_579458 = query.getOrDefault("key")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "key", valid_579458
  var valid_579459 = query.getOrDefault("prettyPrint")
  valid_579459 = validateParameter(valid_579459, JBool, required = false,
                                 default = newJBool(true))
  if valid_579459 != nil:
    section.add "prettyPrint", valid_579459
  var valid_579460 = query.getOrDefault("oauth_token")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "oauth_token", valid_579460
  var valid_579461 = query.getOrDefault("alt")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = newJString("json"))
  if valid_579461 != nil:
    section.add "alt", valid_579461
  var valid_579462 = query.getOrDefault("userIp")
  valid_579462 = validateParameter(valid_579462, JString, required = false,
                                 default = nil)
  if valid_579462 != nil:
    section.add "userIp", valid_579462
  var valid_579463 = query.getOrDefault("quotaUser")
  valid_579463 = validateParameter(valid_579463, JString, required = false,
                                 default = nil)
  if valid_579463 != nil:
    section.add "quotaUser", valid_579463
  var valid_579464 = query.getOrDefault("fields")
  valid_579464 = validateParameter(valid_579464, JString, required = false,
                                 default = nil)
  if valid_579464 != nil:
    section.add "fields", valid_579464
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579465: Call_DirectoryNotificationsGet_579453; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a notification.
  ## 
  let valid = call_579465.validator(path, query, header, formData, body)
  let scheme = call_579465.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579465.url(scheme.get, call_579465.host, call_579465.base,
                         call_579465.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579465, url, valid)

proc call*(call_579466: Call_DirectoryNotificationsGet_579453;
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
  var path_579467 = newJObject()
  var query_579468 = newJObject()
  add(query_579468, "key", newJString(key))
  add(query_579468, "prettyPrint", newJBool(prettyPrint))
  add(query_579468, "oauth_token", newJString(oauthToken))
  add(path_579467, "notificationId", newJString(notificationId))
  add(path_579467, "customer", newJString(customer))
  add(query_579468, "alt", newJString(alt))
  add(query_579468, "userIp", newJString(userIp))
  add(query_579468, "quotaUser", newJString(quotaUser))
  add(query_579468, "fields", newJString(fields))
  result = call_579466.call(path_579467, query_579468, nil, nil, nil)

var directoryNotificationsGet* = Call_DirectoryNotificationsGet_579453(
    name: "directoryNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsGet_579454,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsGet_579455,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsPatch_579503 = ref object of OpenApiRestCall_578364
proc url_DirectoryNotificationsPatch_579505(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryNotificationsPatch_579504(path: JsonNode; query: JsonNode;
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
  var valid_579506 = path.getOrDefault("notificationId")
  valid_579506 = validateParameter(valid_579506, JString, required = true,
                                 default = nil)
  if valid_579506 != nil:
    section.add "notificationId", valid_579506
  var valid_579507 = path.getOrDefault("customer")
  valid_579507 = validateParameter(valid_579507, JString, required = true,
                                 default = nil)
  if valid_579507 != nil:
    section.add "customer", valid_579507
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
  var valid_579508 = query.getOrDefault("key")
  valid_579508 = validateParameter(valid_579508, JString, required = false,
                                 default = nil)
  if valid_579508 != nil:
    section.add "key", valid_579508
  var valid_579509 = query.getOrDefault("prettyPrint")
  valid_579509 = validateParameter(valid_579509, JBool, required = false,
                                 default = newJBool(true))
  if valid_579509 != nil:
    section.add "prettyPrint", valid_579509
  var valid_579510 = query.getOrDefault("oauth_token")
  valid_579510 = validateParameter(valid_579510, JString, required = false,
                                 default = nil)
  if valid_579510 != nil:
    section.add "oauth_token", valid_579510
  var valid_579511 = query.getOrDefault("alt")
  valid_579511 = validateParameter(valid_579511, JString, required = false,
                                 default = newJString("json"))
  if valid_579511 != nil:
    section.add "alt", valid_579511
  var valid_579512 = query.getOrDefault("userIp")
  valid_579512 = validateParameter(valid_579512, JString, required = false,
                                 default = nil)
  if valid_579512 != nil:
    section.add "userIp", valid_579512
  var valid_579513 = query.getOrDefault("quotaUser")
  valid_579513 = validateParameter(valid_579513, JString, required = false,
                                 default = nil)
  if valid_579513 != nil:
    section.add "quotaUser", valid_579513
  var valid_579514 = query.getOrDefault("fields")
  valid_579514 = validateParameter(valid_579514, JString, required = false,
                                 default = nil)
  if valid_579514 != nil:
    section.add "fields", valid_579514
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

proc call*(call_579516: Call_DirectoryNotificationsPatch_579503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification. This method supports patch semantics.
  ## 
  let valid = call_579516.validator(path, query, header, formData, body)
  let scheme = call_579516.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579516.url(scheme.get, call_579516.host, call_579516.base,
                         call_579516.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579516, url, valid)

proc call*(call_579517: Call_DirectoryNotificationsPatch_579503;
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
  var path_579518 = newJObject()
  var query_579519 = newJObject()
  var body_579520 = newJObject()
  add(query_579519, "key", newJString(key))
  add(query_579519, "prettyPrint", newJBool(prettyPrint))
  add(query_579519, "oauth_token", newJString(oauthToken))
  add(path_579518, "notificationId", newJString(notificationId))
  add(path_579518, "customer", newJString(customer))
  add(query_579519, "alt", newJString(alt))
  add(query_579519, "userIp", newJString(userIp))
  add(query_579519, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579520 = body
  add(query_579519, "fields", newJString(fields))
  result = call_579517.call(path_579518, query_579519, nil, nil, body_579520)

var directoryNotificationsPatch* = Call_DirectoryNotificationsPatch_579503(
    name: "directoryNotificationsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsPatch_579504,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsPatch_579505,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsDelete_579487 = ref object of OpenApiRestCall_578364
proc url_DirectoryNotificationsDelete_579489(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryNotificationsDelete_579488(path: JsonNode; query: JsonNode;
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
  var valid_579490 = path.getOrDefault("notificationId")
  valid_579490 = validateParameter(valid_579490, JString, required = true,
                                 default = nil)
  if valid_579490 != nil:
    section.add "notificationId", valid_579490
  var valid_579491 = path.getOrDefault("customer")
  valid_579491 = validateParameter(valid_579491, JString, required = true,
                                 default = nil)
  if valid_579491 != nil:
    section.add "customer", valid_579491
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
  var valid_579492 = query.getOrDefault("key")
  valid_579492 = validateParameter(valid_579492, JString, required = false,
                                 default = nil)
  if valid_579492 != nil:
    section.add "key", valid_579492
  var valid_579493 = query.getOrDefault("prettyPrint")
  valid_579493 = validateParameter(valid_579493, JBool, required = false,
                                 default = newJBool(true))
  if valid_579493 != nil:
    section.add "prettyPrint", valid_579493
  var valid_579494 = query.getOrDefault("oauth_token")
  valid_579494 = validateParameter(valid_579494, JString, required = false,
                                 default = nil)
  if valid_579494 != nil:
    section.add "oauth_token", valid_579494
  var valid_579495 = query.getOrDefault("alt")
  valid_579495 = validateParameter(valid_579495, JString, required = false,
                                 default = newJString("json"))
  if valid_579495 != nil:
    section.add "alt", valid_579495
  var valid_579496 = query.getOrDefault("userIp")
  valid_579496 = validateParameter(valid_579496, JString, required = false,
                                 default = nil)
  if valid_579496 != nil:
    section.add "userIp", valid_579496
  var valid_579497 = query.getOrDefault("quotaUser")
  valid_579497 = validateParameter(valid_579497, JString, required = false,
                                 default = nil)
  if valid_579497 != nil:
    section.add "quotaUser", valid_579497
  var valid_579498 = query.getOrDefault("fields")
  valid_579498 = validateParameter(valid_579498, JString, required = false,
                                 default = nil)
  if valid_579498 != nil:
    section.add "fields", valid_579498
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579499: Call_DirectoryNotificationsDelete_579487; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a notification
  ## 
  let valid = call_579499.validator(path, query, header, formData, body)
  let scheme = call_579499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579499.url(scheme.get, call_579499.host, call_579499.base,
                         call_579499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579499, url, valid)

proc call*(call_579500: Call_DirectoryNotificationsDelete_579487;
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
  var path_579501 = newJObject()
  var query_579502 = newJObject()
  add(query_579502, "key", newJString(key))
  add(query_579502, "prettyPrint", newJBool(prettyPrint))
  add(query_579502, "oauth_token", newJString(oauthToken))
  add(path_579501, "notificationId", newJString(notificationId))
  add(path_579501, "customer", newJString(customer))
  add(query_579502, "alt", newJString(alt))
  add(query_579502, "userIp", newJString(userIp))
  add(query_579502, "quotaUser", newJString(quotaUser))
  add(query_579502, "fields", newJString(fields))
  result = call_579500.call(path_579501, query_579502, nil, nil, nil)

var directoryNotificationsDelete* = Call_DirectoryNotificationsDelete_579487(
    name: "directoryNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsDelete_579488,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsDelete_579489,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsInsert_579538 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesBuildingsInsert_579540(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsInsert_579539(path: JsonNode;
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
  var valid_579541 = path.getOrDefault("customer")
  valid_579541 = validateParameter(valid_579541, JString, required = true,
                                 default = nil)
  if valid_579541 != nil:
    section.add "customer", valid_579541
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
  var valid_579542 = query.getOrDefault("key")
  valid_579542 = validateParameter(valid_579542, JString, required = false,
                                 default = nil)
  if valid_579542 != nil:
    section.add "key", valid_579542
  var valid_579543 = query.getOrDefault("prettyPrint")
  valid_579543 = validateParameter(valid_579543, JBool, required = false,
                                 default = newJBool(true))
  if valid_579543 != nil:
    section.add "prettyPrint", valid_579543
  var valid_579544 = query.getOrDefault("oauth_token")
  valid_579544 = validateParameter(valid_579544, JString, required = false,
                                 default = nil)
  if valid_579544 != nil:
    section.add "oauth_token", valid_579544
  var valid_579545 = query.getOrDefault("alt")
  valid_579545 = validateParameter(valid_579545, JString, required = false,
                                 default = newJString("json"))
  if valid_579545 != nil:
    section.add "alt", valid_579545
  var valid_579546 = query.getOrDefault("userIp")
  valid_579546 = validateParameter(valid_579546, JString, required = false,
                                 default = nil)
  if valid_579546 != nil:
    section.add "userIp", valid_579546
  var valid_579547 = query.getOrDefault("quotaUser")
  valid_579547 = validateParameter(valid_579547, JString, required = false,
                                 default = nil)
  if valid_579547 != nil:
    section.add "quotaUser", valid_579547
  var valid_579548 = query.getOrDefault("coordinatesSource")
  valid_579548 = validateParameter(valid_579548, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_579548 != nil:
    section.add "coordinatesSource", valid_579548
  var valid_579549 = query.getOrDefault("fields")
  valid_579549 = validateParameter(valid_579549, JString, required = false,
                                 default = nil)
  if valid_579549 != nil:
    section.add "fields", valid_579549
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

proc call*(call_579551: Call_DirectoryResourcesBuildingsInsert_579538;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a building.
  ## 
  let valid = call_579551.validator(path, query, header, formData, body)
  let scheme = call_579551.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579551.url(scheme.get, call_579551.host, call_579551.base,
                         call_579551.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579551, url, valid)

proc call*(call_579552: Call_DirectoryResourcesBuildingsInsert_579538;
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
  var path_579553 = newJObject()
  var query_579554 = newJObject()
  var body_579555 = newJObject()
  add(query_579554, "key", newJString(key))
  add(query_579554, "prettyPrint", newJBool(prettyPrint))
  add(query_579554, "oauth_token", newJString(oauthToken))
  add(path_579553, "customer", newJString(customer))
  add(query_579554, "alt", newJString(alt))
  add(query_579554, "userIp", newJString(userIp))
  add(query_579554, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579555 = body
  add(query_579554, "coordinatesSource", newJString(coordinatesSource))
  add(query_579554, "fields", newJString(fields))
  result = call_579552.call(path_579553, query_579554, nil, nil, body_579555)

var directoryResourcesBuildingsInsert* = Call_DirectoryResourcesBuildingsInsert_579538(
    name: "directoryResourcesBuildingsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsInsert_579539,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsInsert_579540,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsList_579521 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesBuildingsList_579523(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsList_579522(path: JsonNode;
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
  var valid_579524 = path.getOrDefault("customer")
  valid_579524 = validateParameter(valid_579524, JString, required = true,
                                 default = nil)
  if valid_579524 != nil:
    section.add "customer", valid_579524
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
  var valid_579525 = query.getOrDefault("key")
  valid_579525 = validateParameter(valid_579525, JString, required = false,
                                 default = nil)
  if valid_579525 != nil:
    section.add "key", valid_579525
  var valid_579526 = query.getOrDefault("prettyPrint")
  valid_579526 = validateParameter(valid_579526, JBool, required = false,
                                 default = newJBool(true))
  if valid_579526 != nil:
    section.add "prettyPrint", valid_579526
  var valid_579527 = query.getOrDefault("oauth_token")
  valid_579527 = validateParameter(valid_579527, JString, required = false,
                                 default = nil)
  if valid_579527 != nil:
    section.add "oauth_token", valid_579527
  var valid_579528 = query.getOrDefault("alt")
  valid_579528 = validateParameter(valid_579528, JString, required = false,
                                 default = newJString("json"))
  if valid_579528 != nil:
    section.add "alt", valid_579528
  var valid_579529 = query.getOrDefault("userIp")
  valid_579529 = validateParameter(valid_579529, JString, required = false,
                                 default = nil)
  if valid_579529 != nil:
    section.add "userIp", valid_579529
  var valid_579530 = query.getOrDefault("quotaUser")
  valid_579530 = validateParameter(valid_579530, JString, required = false,
                                 default = nil)
  if valid_579530 != nil:
    section.add "quotaUser", valid_579530
  var valid_579531 = query.getOrDefault("pageToken")
  valid_579531 = validateParameter(valid_579531, JString, required = false,
                                 default = nil)
  if valid_579531 != nil:
    section.add "pageToken", valid_579531
  var valid_579532 = query.getOrDefault("fields")
  valid_579532 = validateParameter(valid_579532, JString, required = false,
                                 default = nil)
  if valid_579532 != nil:
    section.add "fields", valid_579532
  var valid_579533 = query.getOrDefault("maxResults")
  valid_579533 = validateParameter(valid_579533, JInt, required = false, default = nil)
  if valid_579533 != nil:
    section.add "maxResults", valid_579533
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579534: Call_DirectoryResourcesBuildingsList_579521;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of buildings for an account.
  ## 
  let valid = call_579534.validator(path, query, header, formData, body)
  let scheme = call_579534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579534.url(scheme.get, call_579534.host, call_579534.base,
                         call_579534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579534, url, valid)

proc call*(call_579535: Call_DirectoryResourcesBuildingsList_579521;
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
  var path_579536 = newJObject()
  var query_579537 = newJObject()
  add(query_579537, "key", newJString(key))
  add(query_579537, "prettyPrint", newJBool(prettyPrint))
  add(query_579537, "oauth_token", newJString(oauthToken))
  add(path_579536, "customer", newJString(customer))
  add(query_579537, "alt", newJString(alt))
  add(query_579537, "userIp", newJString(userIp))
  add(query_579537, "quotaUser", newJString(quotaUser))
  add(query_579537, "pageToken", newJString(pageToken))
  add(query_579537, "fields", newJString(fields))
  add(query_579537, "maxResults", newJInt(maxResults))
  result = call_579535.call(path_579536, query_579537, nil, nil, nil)

var directoryResourcesBuildingsList* = Call_DirectoryResourcesBuildingsList_579521(
    name: "directoryResourcesBuildingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsList_579522,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsList_579523,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsUpdate_579572 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesBuildingsUpdate_579574(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsUpdate_579573(path: JsonNode;
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
  var valid_579575 = path.getOrDefault("customer")
  valid_579575 = validateParameter(valid_579575, JString, required = true,
                                 default = nil)
  if valid_579575 != nil:
    section.add "customer", valid_579575
  var valid_579576 = path.getOrDefault("buildingId")
  valid_579576 = validateParameter(valid_579576, JString, required = true,
                                 default = nil)
  if valid_579576 != nil:
    section.add "buildingId", valid_579576
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
  var valid_579577 = query.getOrDefault("key")
  valid_579577 = validateParameter(valid_579577, JString, required = false,
                                 default = nil)
  if valid_579577 != nil:
    section.add "key", valid_579577
  var valid_579578 = query.getOrDefault("prettyPrint")
  valid_579578 = validateParameter(valid_579578, JBool, required = false,
                                 default = newJBool(true))
  if valid_579578 != nil:
    section.add "prettyPrint", valid_579578
  var valid_579579 = query.getOrDefault("oauth_token")
  valid_579579 = validateParameter(valid_579579, JString, required = false,
                                 default = nil)
  if valid_579579 != nil:
    section.add "oauth_token", valid_579579
  var valid_579580 = query.getOrDefault("alt")
  valid_579580 = validateParameter(valid_579580, JString, required = false,
                                 default = newJString("json"))
  if valid_579580 != nil:
    section.add "alt", valid_579580
  var valid_579581 = query.getOrDefault("userIp")
  valid_579581 = validateParameter(valid_579581, JString, required = false,
                                 default = nil)
  if valid_579581 != nil:
    section.add "userIp", valid_579581
  var valid_579582 = query.getOrDefault("quotaUser")
  valid_579582 = validateParameter(valid_579582, JString, required = false,
                                 default = nil)
  if valid_579582 != nil:
    section.add "quotaUser", valid_579582
  var valid_579583 = query.getOrDefault("coordinatesSource")
  valid_579583 = validateParameter(valid_579583, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_579583 != nil:
    section.add "coordinatesSource", valid_579583
  var valid_579584 = query.getOrDefault("fields")
  valid_579584 = validateParameter(valid_579584, JString, required = false,
                                 default = nil)
  if valid_579584 != nil:
    section.add "fields", valid_579584
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

proc call*(call_579586: Call_DirectoryResourcesBuildingsUpdate_579572;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building.
  ## 
  let valid = call_579586.validator(path, query, header, formData, body)
  let scheme = call_579586.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579586.url(scheme.get, call_579586.host, call_579586.base,
                         call_579586.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579586, url, valid)

proc call*(call_579587: Call_DirectoryResourcesBuildingsUpdate_579572;
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
  var path_579588 = newJObject()
  var query_579589 = newJObject()
  var body_579590 = newJObject()
  add(query_579589, "key", newJString(key))
  add(query_579589, "prettyPrint", newJBool(prettyPrint))
  add(query_579589, "oauth_token", newJString(oauthToken))
  add(path_579588, "customer", newJString(customer))
  add(query_579589, "alt", newJString(alt))
  add(query_579589, "userIp", newJString(userIp))
  add(query_579589, "quotaUser", newJString(quotaUser))
  add(path_579588, "buildingId", newJString(buildingId))
  if body != nil:
    body_579590 = body
  add(query_579589, "coordinatesSource", newJString(coordinatesSource))
  add(query_579589, "fields", newJString(fields))
  result = call_579587.call(path_579588, query_579589, nil, nil, body_579590)

var directoryResourcesBuildingsUpdate* = Call_DirectoryResourcesBuildingsUpdate_579572(
    name: "directoryResourcesBuildingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsUpdate_579573,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsUpdate_579574,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsGet_579556 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesBuildingsGet_579558(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsGet_579557(path: JsonNode;
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
  var valid_579559 = path.getOrDefault("customer")
  valid_579559 = validateParameter(valid_579559, JString, required = true,
                                 default = nil)
  if valid_579559 != nil:
    section.add "customer", valid_579559
  var valid_579560 = path.getOrDefault("buildingId")
  valid_579560 = validateParameter(valid_579560, JString, required = true,
                                 default = nil)
  if valid_579560 != nil:
    section.add "buildingId", valid_579560
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
  var valid_579561 = query.getOrDefault("key")
  valid_579561 = validateParameter(valid_579561, JString, required = false,
                                 default = nil)
  if valid_579561 != nil:
    section.add "key", valid_579561
  var valid_579562 = query.getOrDefault("prettyPrint")
  valid_579562 = validateParameter(valid_579562, JBool, required = false,
                                 default = newJBool(true))
  if valid_579562 != nil:
    section.add "prettyPrint", valid_579562
  var valid_579563 = query.getOrDefault("oauth_token")
  valid_579563 = validateParameter(valid_579563, JString, required = false,
                                 default = nil)
  if valid_579563 != nil:
    section.add "oauth_token", valid_579563
  var valid_579564 = query.getOrDefault("alt")
  valid_579564 = validateParameter(valid_579564, JString, required = false,
                                 default = newJString("json"))
  if valid_579564 != nil:
    section.add "alt", valid_579564
  var valid_579565 = query.getOrDefault("userIp")
  valid_579565 = validateParameter(valid_579565, JString, required = false,
                                 default = nil)
  if valid_579565 != nil:
    section.add "userIp", valid_579565
  var valid_579566 = query.getOrDefault("quotaUser")
  valid_579566 = validateParameter(valid_579566, JString, required = false,
                                 default = nil)
  if valid_579566 != nil:
    section.add "quotaUser", valid_579566
  var valid_579567 = query.getOrDefault("fields")
  valid_579567 = validateParameter(valid_579567, JString, required = false,
                                 default = nil)
  if valid_579567 != nil:
    section.add "fields", valid_579567
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579568: Call_DirectoryResourcesBuildingsGet_579556; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a building.
  ## 
  let valid = call_579568.validator(path, query, header, formData, body)
  let scheme = call_579568.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579568.url(scheme.get, call_579568.host, call_579568.base,
                         call_579568.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579568, url, valid)

proc call*(call_579569: Call_DirectoryResourcesBuildingsGet_579556;
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
  var path_579570 = newJObject()
  var query_579571 = newJObject()
  add(query_579571, "key", newJString(key))
  add(query_579571, "prettyPrint", newJBool(prettyPrint))
  add(query_579571, "oauth_token", newJString(oauthToken))
  add(path_579570, "customer", newJString(customer))
  add(query_579571, "alt", newJString(alt))
  add(query_579571, "userIp", newJString(userIp))
  add(query_579571, "quotaUser", newJString(quotaUser))
  add(path_579570, "buildingId", newJString(buildingId))
  add(query_579571, "fields", newJString(fields))
  result = call_579569.call(path_579570, query_579571, nil, nil, nil)

var directoryResourcesBuildingsGet* = Call_DirectoryResourcesBuildingsGet_579556(
    name: "directoryResourcesBuildingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsGet_579557,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsGet_579558,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsPatch_579607 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesBuildingsPatch_579609(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsPatch_579608(path: JsonNode;
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
  var valid_579610 = path.getOrDefault("customer")
  valid_579610 = validateParameter(valid_579610, JString, required = true,
                                 default = nil)
  if valid_579610 != nil:
    section.add "customer", valid_579610
  var valid_579611 = path.getOrDefault("buildingId")
  valid_579611 = validateParameter(valid_579611, JString, required = true,
                                 default = nil)
  if valid_579611 != nil:
    section.add "buildingId", valid_579611
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
  var valid_579612 = query.getOrDefault("key")
  valid_579612 = validateParameter(valid_579612, JString, required = false,
                                 default = nil)
  if valid_579612 != nil:
    section.add "key", valid_579612
  var valid_579613 = query.getOrDefault("prettyPrint")
  valid_579613 = validateParameter(valid_579613, JBool, required = false,
                                 default = newJBool(true))
  if valid_579613 != nil:
    section.add "prettyPrint", valid_579613
  var valid_579614 = query.getOrDefault("oauth_token")
  valid_579614 = validateParameter(valid_579614, JString, required = false,
                                 default = nil)
  if valid_579614 != nil:
    section.add "oauth_token", valid_579614
  var valid_579615 = query.getOrDefault("alt")
  valid_579615 = validateParameter(valid_579615, JString, required = false,
                                 default = newJString("json"))
  if valid_579615 != nil:
    section.add "alt", valid_579615
  var valid_579616 = query.getOrDefault("userIp")
  valid_579616 = validateParameter(valid_579616, JString, required = false,
                                 default = nil)
  if valid_579616 != nil:
    section.add "userIp", valid_579616
  var valid_579617 = query.getOrDefault("quotaUser")
  valid_579617 = validateParameter(valid_579617, JString, required = false,
                                 default = nil)
  if valid_579617 != nil:
    section.add "quotaUser", valid_579617
  var valid_579618 = query.getOrDefault("coordinatesSource")
  valid_579618 = validateParameter(valid_579618, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_579618 != nil:
    section.add "coordinatesSource", valid_579618
  var valid_579619 = query.getOrDefault("fields")
  valid_579619 = validateParameter(valid_579619, JString, required = false,
                                 default = nil)
  if valid_579619 != nil:
    section.add "fields", valid_579619
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

proc call*(call_579621: Call_DirectoryResourcesBuildingsPatch_579607;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building. This method supports patch semantics.
  ## 
  let valid = call_579621.validator(path, query, header, formData, body)
  let scheme = call_579621.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579621.url(scheme.get, call_579621.host, call_579621.base,
                         call_579621.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579621, url, valid)

proc call*(call_579622: Call_DirectoryResourcesBuildingsPatch_579607;
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
  var path_579623 = newJObject()
  var query_579624 = newJObject()
  var body_579625 = newJObject()
  add(query_579624, "key", newJString(key))
  add(query_579624, "prettyPrint", newJBool(prettyPrint))
  add(query_579624, "oauth_token", newJString(oauthToken))
  add(path_579623, "customer", newJString(customer))
  add(query_579624, "alt", newJString(alt))
  add(query_579624, "userIp", newJString(userIp))
  add(query_579624, "quotaUser", newJString(quotaUser))
  add(path_579623, "buildingId", newJString(buildingId))
  if body != nil:
    body_579625 = body
  add(query_579624, "coordinatesSource", newJString(coordinatesSource))
  add(query_579624, "fields", newJString(fields))
  result = call_579622.call(path_579623, query_579624, nil, nil, body_579625)

var directoryResourcesBuildingsPatch* = Call_DirectoryResourcesBuildingsPatch_579607(
    name: "directoryResourcesBuildingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsPatch_579608,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsPatch_579609,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsDelete_579591 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesBuildingsDelete_579593(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesBuildingsDelete_579592(path: JsonNode;
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
  var valid_579594 = path.getOrDefault("customer")
  valid_579594 = validateParameter(valid_579594, JString, required = true,
                                 default = nil)
  if valid_579594 != nil:
    section.add "customer", valid_579594
  var valid_579595 = path.getOrDefault("buildingId")
  valid_579595 = validateParameter(valid_579595, JString, required = true,
                                 default = nil)
  if valid_579595 != nil:
    section.add "buildingId", valid_579595
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
  var valid_579596 = query.getOrDefault("key")
  valid_579596 = validateParameter(valid_579596, JString, required = false,
                                 default = nil)
  if valid_579596 != nil:
    section.add "key", valid_579596
  var valid_579597 = query.getOrDefault("prettyPrint")
  valid_579597 = validateParameter(valid_579597, JBool, required = false,
                                 default = newJBool(true))
  if valid_579597 != nil:
    section.add "prettyPrint", valid_579597
  var valid_579598 = query.getOrDefault("oauth_token")
  valid_579598 = validateParameter(valid_579598, JString, required = false,
                                 default = nil)
  if valid_579598 != nil:
    section.add "oauth_token", valid_579598
  var valid_579599 = query.getOrDefault("alt")
  valid_579599 = validateParameter(valid_579599, JString, required = false,
                                 default = newJString("json"))
  if valid_579599 != nil:
    section.add "alt", valid_579599
  var valid_579600 = query.getOrDefault("userIp")
  valid_579600 = validateParameter(valid_579600, JString, required = false,
                                 default = nil)
  if valid_579600 != nil:
    section.add "userIp", valid_579600
  var valid_579601 = query.getOrDefault("quotaUser")
  valid_579601 = validateParameter(valid_579601, JString, required = false,
                                 default = nil)
  if valid_579601 != nil:
    section.add "quotaUser", valid_579601
  var valid_579602 = query.getOrDefault("fields")
  valid_579602 = validateParameter(valid_579602, JString, required = false,
                                 default = nil)
  if valid_579602 != nil:
    section.add "fields", valid_579602
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579603: Call_DirectoryResourcesBuildingsDelete_579591;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a building.
  ## 
  let valid = call_579603.validator(path, query, header, formData, body)
  let scheme = call_579603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579603.url(scheme.get, call_579603.host, call_579603.base,
                         call_579603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579603, url, valid)

proc call*(call_579604: Call_DirectoryResourcesBuildingsDelete_579591;
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
  var path_579605 = newJObject()
  var query_579606 = newJObject()
  add(query_579606, "key", newJString(key))
  add(query_579606, "prettyPrint", newJBool(prettyPrint))
  add(query_579606, "oauth_token", newJString(oauthToken))
  add(path_579605, "customer", newJString(customer))
  add(query_579606, "alt", newJString(alt))
  add(query_579606, "userIp", newJString(userIp))
  add(query_579606, "quotaUser", newJString(quotaUser))
  add(path_579605, "buildingId", newJString(buildingId))
  add(query_579606, "fields", newJString(fields))
  result = call_579604.call(path_579605, query_579606, nil, nil, nil)

var directoryResourcesBuildingsDelete* = Call_DirectoryResourcesBuildingsDelete_579591(
    name: "directoryResourcesBuildingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsDelete_579592,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsDelete_579593,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsInsert_579645 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesCalendarsInsert_579647(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsInsert_579646(path: JsonNode;
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
  var valid_579648 = path.getOrDefault("customer")
  valid_579648 = validateParameter(valid_579648, JString, required = true,
                                 default = nil)
  if valid_579648 != nil:
    section.add "customer", valid_579648
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
  var valid_579649 = query.getOrDefault("key")
  valid_579649 = validateParameter(valid_579649, JString, required = false,
                                 default = nil)
  if valid_579649 != nil:
    section.add "key", valid_579649
  var valid_579650 = query.getOrDefault("prettyPrint")
  valid_579650 = validateParameter(valid_579650, JBool, required = false,
                                 default = newJBool(true))
  if valid_579650 != nil:
    section.add "prettyPrint", valid_579650
  var valid_579651 = query.getOrDefault("oauth_token")
  valid_579651 = validateParameter(valid_579651, JString, required = false,
                                 default = nil)
  if valid_579651 != nil:
    section.add "oauth_token", valid_579651
  var valid_579652 = query.getOrDefault("alt")
  valid_579652 = validateParameter(valid_579652, JString, required = false,
                                 default = newJString("json"))
  if valid_579652 != nil:
    section.add "alt", valid_579652
  var valid_579653 = query.getOrDefault("userIp")
  valid_579653 = validateParameter(valid_579653, JString, required = false,
                                 default = nil)
  if valid_579653 != nil:
    section.add "userIp", valid_579653
  var valid_579654 = query.getOrDefault("quotaUser")
  valid_579654 = validateParameter(valid_579654, JString, required = false,
                                 default = nil)
  if valid_579654 != nil:
    section.add "quotaUser", valid_579654
  var valid_579655 = query.getOrDefault("fields")
  valid_579655 = validateParameter(valid_579655, JString, required = false,
                                 default = nil)
  if valid_579655 != nil:
    section.add "fields", valid_579655
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

proc call*(call_579657: Call_DirectoryResourcesCalendarsInsert_579645;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a calendar resource.
  ## 
  let valid = call_579657.validator(path, query, header, formData, body)
  let scheme = call_579657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579657.url(scheme.get, call_579657.host, call_579657.base,
                         call_579657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579657, url, valid)

proc call*(call_579658: Call_DirectoryResourcesCalendarsInsert_579645;
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
  var path_579659 = newJObject()
  var query_579660 = newJObject()
  var body_579661 = newJObject()
  add(query_579660, "key", newJString(key))
  add(query_579660, "prettyPrint", newJBool(prettyPrint))
  add(query_579660, "oauth_token", newJString(oauthToken))
  add(path_579659, "customer", newJString(customer))
  add(query_579660, "alt", newJString(alt))
  add(query_579660, "userIp", newJString(userIp))
  add(query_579660, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579661 = body
  add(query_579660, "fields", newJString(fields))
  result = call_579658.call(path_579659, query_579660, nil, nil, body_579661)

var directoryResourcesCalendarsInsert* = Call_DirectoryResourcesCalendarsInsert_579645(
    name: "directoryResourcesCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsInsert_579646,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsInsert_579647,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsList_579626 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesCalendarsList_579628(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsList_579627(path: JsonNode;
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
  var valid_579629 = path.getOrDefault("customer")
  valid_579629 = validateParameter(valid_579629, JString, required = true,
                                 default = nil)
  if valid_579629 != nil:
    section.add "customer", valid_579629
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
  var valid_579630 = query.getOrDefault("key")
  valid_579630 = validateParameter(valid_579630, JString, required = false,
                                 default = nil)
  if valid_579630 != nil:
    section.add "key", valid_579630
  var valid_579631 = query.getOrDefault("prettyPrint")
  valid_579631 = validateParameter(valid_579631, JBool, required = false,
                                 default = newJBool(true))
  if valid_579631 != nil:
    section.add "prettyPrint", valid_579631
  var valid_579632 = query.getOrDefault("oauth_token")
  valid_579632 = validateParameter(valid_579632, JString, required = false,
                                 default = nil)
  if valid_579632 != nil:
    section.add "oauth_token", valid_579632
  var valid_579633 = query.getOrDefault("alt")
  valid_579633 = validateParameter(valid_579633, JString, required = false,
                                 default = newJString("json"))
  if valid_579633 != nil:
    section.add "alt", valid_579633
  var valid_579634 = query.getOrDefault("userIp")
  valid_579634 = validateParameter(valid_579634, JString, required = false,
                                 default = nil)
  if valid_579634 != nil:
    section.add "userIp", valid_579634
  var valid_579635 = query.getOrDefault("quotaUser")
  valid_579635 = validateParameter(valid_579635, JString, required = false,
                                 default = nil)
  if valid_579635 != nil:
    section.add "quotaUser", valid_579635
  var valid_579636 = query.getOrDefault("orderBy")
  valid_579636 = validateParameter(valid_579636, JString, required = false,
                                 default = nil)
  if valid_579636 != nil:
    section.add "orderBy", valid_579636
  var valid_579637 = query.getOrDefault("pageToken")
  valid_579637 = validateParameter(valid_579637, JString, required = false,
                                 default = nil)
  if valid_579637 != nil:
    section.add "pageToken", valid_579637
  var valid_579638 = query.getOrDefault("query")
  valid_579638 = validateParameter(valid_579638, JString, required = false,
                                 default = nil)
  if valid_579638 != nil:
    section.add "query", valid_579638
  var valid_579639 = query.getOrDefault("fields")
  valid_579639 = validateParameter(valid_579639, JString, required = false,
                                 default = nil)
  if valid_579639 != nil:
    section.add "fields", valid_579639
  var valid_579640 = query.getOrDefault("maxResults")
  valid_579640 = validateParameter(valid_579640, JInt, required = false, default = nil)
  if valid_579640 != nil:
    section.add "maxResults", valid_579640
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579641: Call_DirectoryResourcesCalendarsList_579626;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of calendar resources for an account.
  ## 
  let valid = call_579641.validator(path, query, header, formData, body)
  let scheme = call_579641.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579641.url(scheme.get, call_579641.host, call_579641.base,
                         call_579641.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579641, url, valid)

proc call*(call_579642: Call_DirectoryResourcesCalendarsList_579626;
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
  var path_579643 = newJObject()
  var query_579644 = newJObject()
  add(query_579644, "key", newJString(key))
  add(query_579644, "prettyPrint", newJBool(prettyPrint))
  add(query_579644, "oauth_token", newJString(oauthToken))
  add(path_579643, "customer", newJString(customer))
  add(query_579644, "alt", newJString(alt))
  add(query_579644, "userIp", newJString(userIp))
  add(query_579644, "quotaUser", newJString(quotaUser))
  add(query_579644, "orderBy", newJString(orderBy))
  add(query_579644, "pageToken", newJString(pageToken))
  add(query_579644, "query", newJString(query))
  add(query_579644, "fields", newJString(fields))
  add(query_579644, "maxResults", newJInt(maxResults))
  result = call_579642.call(path_579643, query_579644, nil, nil, nil)

var directoryResourcesCalendarsList* = Call_DirectoryResourcesCalendarsList_579626(
    name: "directoryResourcesCalendarsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsList_579627,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsList_579628,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsUpdate_579678 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesCalendarsUpdate_579680(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsUpdate_579679(path: JsonNode;
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
  var valid_579681 = path.getOrDefault("customer")
  valid_579681 = validateParameter(valid_579681, JString, required = true,
                                 default = nil)
  if valid_579681 != nil:
    section.add "customer", valid_579681
  var valid_579682 = path.getOrDefault("calendarResourceId")
  valid_579682 = validateParameter(valid_579682, JString, required = true,
                                 default = nil)
  if valid_579682 != nil:
    section.add "calendarResourceId", valid_579682
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
  var valid_579683 = query.getOrDefault("key")
  valid_579683 = validateParameter(valid_579683, JString, required = false,
                                 default = nil)
  if valid_579683 != nil:
    section.add "key", valid_579683
  var valid_579684 = query.getOrDefault("prettyPrint")
  valid_579684 = validateParameter(valid_579684, JBool, required = false,
                                 default = newJBool(true))
  if valid_579684 != nil:
    section.add "prettyPrint", valid_579684
  var valid_579685 = query.getOrDefault("oauth_token")
  valid_579685 = validateParameter(valid_579685, JString, required = false,
                                 default = nil)
  if valid_579685 != nil:
    section.add "oauth_token", valid_579685
  var valid_579686 = query.getOrDefault("alt")
  valid_579686 = validateParameter(valid_579686, JString, required = false,
                                 default = newJString("json"))
  if valid_579686 != nil:
    section.add "alt", valid_579686
  var valid_579687 = query.getOrDefault("userIp")
  valid_579687 = validateParameter(valid_579687, JString, required = false,
                                 default = nil)
  if valid_579687 != nil:
    section.add "userIp", valid_579687
  var valid_579688 = query.getOrDefault("quotaUser")
  valid_579688 = validateParameter(valid_579688, JString, required = false,
                                 default = nil)
  if valid_579688 != nil:
    section.add "quotaUser", valid_579688
  var valid_579689 = query.getOrDefault("fields")
  valid_579689 = validateParameter(valid_579689, JString, required = false,
                                 default = nil)
  if valid_579689 != nil:
    section.add "fields", valid_579689
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

proc call*(call_579691: Call_DirectoryResourcesCalendarsUpdate_579678;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
  ## 
  let valid = call_579691.validator(path, query, header, formData, body)
  let scheme = call_579691.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579691.url(scheme.get, call_579691.host, call_579691.base,
                         call_579691.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579691, url, valid)

proc call*(call_579692: Call_DirectoryResourcesCalendarsUpdate_579678;
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
  var path_579693 = newJObject()
  var query_579694 = newJObject()
  var body_579695 = newJObject()
  add(query_579694, "key", newJString(key))
  add(query_579694, "prettyPrint", newJBool(prettyPrint))
  add(query_579694, "oauth_token", newJString(oauthToken))
  add(path_579693, "customer", newJString(customer))
  add(query_579694, "alt", newJString(alt))
  add(query_579694, "userIp", newJString(userIp))
  add(query_579694, "quotaUser", newJString(quotaUser))
  add(path_579693, "calendarResourceId", newJString(calendarResourceId))
  if body != nil:
    body_579695 = body
  add(query_579694, "fields", newJString(fields))
  result = call_579692.call(path_579693, query_579694, nil, nil, body_579695)

var directoryResourcesCalendarsUpdate* = Call_DirectoryResourcesCalendarsUpdate_579678(
    name: "directoryResourcesCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsUpdate_579679,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsUpdate_579680,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsGet_579662 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesCalendarsGet_579664(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsGet_579663(path: JsonNode;
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
  var valid_579665 = path.getOrDefault("customer")
  valid_579665 = validateParameter(valid_579665, JString, required = true,
                                 default = nil)
  if valid_579665 != nil:
    section.add "customer", valid_579665
  var valid_579666 = path.getOrDefault("calendarResourceId")
  valid_579666 = validateParameter(valid_579666, JString, required = true,
                                 default = nil)
  if valid_579666 != nil:
    section.add "calendarResourceId", valid_579666
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
  var valid_579667 = query.getOrDefault("key")
  valid_579667 = validateParameter(valid_579667, JString, required = false,
                                 default = nil)
  if valid_579667 != nil:
    section.add "key", valid_579667
  var valid_579668 = query.getOrDefault("prettyPrint")
  valid_579668 = validateParameter(valid_579668, JBool, required = false,
                                 default = newJBool(true))
  if valid_579668 != nil:
    section.add "prettyPrint", valid_579668
  var valid_579669 = query.getOrDefault("oauth_token")
  valid_579669 = validateParameter(valid_579669, JString, required = false,
                                 default = nil)
  if valid_579669 != nil:
    section.add "oauth_token", valid_579669
  var valid_579670 = query.getOrDefault("alt")
  valid_579670 = validateParameter(valid_579670, JString, required = false,
                                 default = newJString("json"))
  if valid_579670 != nil:
    section.add "alt", valid_579670
  var valid_579671 = query.getOrDefault("userIp")
  valid_579671 = validateParameter(valid_579671, JString, required = false,
                                 default = nil)
  if valid_579671 != nil:
    section.add "userIp", valid_579671
  var valid_579672 = query.getOrDefault("quotaUser")
  valid_579672 = validateParameter(valid_579672, JString, required = false,
                                 default = nil)
  if valid_579672 != nil:
    section.add "quotaUser", valid_579672
  var valid_579673 = query.getOrDefault("fields")
  valid_579673 = validateParameter(valid_579673, JString, required = false,
                                 default = nil)
  if valid_579673 != nil:
    section.add "fields", valid_579673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579674: Call_DirectoryResourcesCalendarsGet_579662; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a calendar resource.
  ## 
  let valid = call_579674.validator(path, query, header, formData, body)
  let scheme = call_579674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579674.url(scheme.get, call_579674.host, call_579674.base,
                         call_579674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579674, url, valid)

proc call*(call_579675: Call_DirectoryResourcesCalendarsGet_579662;
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
  var path_579676 = newJObject()
  var query_579677 = newJObject()
  add(query_579677, "key", newJString(key))
  add(query_579677, "prettyPrint", newJBool(prettyPrint))
  add(query_579677, "oauth_token", newJString(oauthToken))
  add(path_579676, "customer", newJString(customer))
  add(query_579677, "alt", newJString(alt))
  add(query_579677, "userIp", newJString(userIp))
  add(query_579677, "quotaUser", newJString(quotaUser))
  add(path_579676, "calendarResourceId", newJString(calendarResourceId))
  add(query_579677, "fields", newJString(fields))
  result = call_579675.call(path_579676, query_579677, nil, nil, nil)

var directoryResourcesCalendarsGet* = Call_DirectoryResourcesCalendarsGet_579662(
    name: "directoryResourcesCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsGet_579663,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsGet_579664,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsPatch_579712 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesCalendarsPatch_579714(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsPatch_579713(path: JsonNode;
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
  var valid_579715 = path.getOrDefault("customer")
  valid_579715 = validateParameter(valid_579715, JString, required = true,
                                 default = nil)
  if valid_579715 != nil:
    section.add "customer", valid_579715
  var valid_579716 = path.getOrDefault("calendarResourceId")
  valid_579716 = validateParameter(valid_579716, JString, required = true,
                                 default = nil)
  if valid_579716 != nil:
    section.add "calendarResourceId", valid_579716
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
  var valid_579717 = query.getOrDefault("key")
  valid_579717 = validateParameter(valid_579717, JString, required = false,
                                 default = nil)
  if valid_579717 != nil:
    section.add "key", valid_579717
  var valid_579718 = query.getOrDefault("prettyPrint")
  valid_579718 = validateParameter(valid_579718, JBool, required = false,
                                 default = newJBool(true))
  if valid_579718 != nil:
    section.add "prettyPrint", valid_579718
  var valid_579719 = query.getOrDefault("oauth_token")
  valid_579719 = validateParameter(valid_579719, JString, required = false,
                                 default = nil)
  if valid_579719 != nil:
    section.add "oauth_token", valid_579719
  var valid_579720 = query.getOrDefault("alt")
  valid_579720 = validateParameter(valid_579720, JString, required = false,
                                 default = newJString("json"))
  if valid_579720 != nil:
    section.add "alt", valid_579720
  var valid_579721 = query.getOrDefault("userIp")
  valid_579721 = validateParameter(valid_579721, JString, required = false,
                                 default = nil)
  if valid_579721 != nil:
    section.add "userIp", valid_579721
  var valid_579722 = query.getOrDefault("quotaUser")
  valid_579722 = validateParameter(valid_579722, JString, required = false,
                                 default = nil)
  if valid_579722 != nil:
    section.add "quotaUser", valid_579722
  var valid_579723 = query.getOrDefault("fields")
  valid_579723 = validateParameter(valid_579723, JString, required = false,
                                 default = nil)
  if valid_579723 != nil:
    section.add "fields", valid_579723
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

proc call*(call_579725: Call_DirectoryResourcesCalendarsPatch_579712;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
  ## 
  let valid = call_579725.validator(path, query, header, formData, body)
  let scheme = call_579725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579725.url(scheme.get, call_579725.host, call_579725.base,
                         call_579725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579725, url, valid)

proc call*(call_579726: Call_DirectoryResourcesCalendarsPatch_579712;
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
  var path_579727 = newJObject()
  var query_579728 = newJObject()
  var body_579729 = newJObject()
  add(query_579728, "key", newJString(key))
  add(query_579728, "prettyPrint", newJBool(prettyPrint))
  add(query_579728, "oauth_token", newJString(oauthToken))
  add(path_579727, "customer", newJString(customer))
  add(query_579728, "alt", newJString(alt))
  add(query_579728, "userIp", newJString(userIp))
  add(query_579728, "quotaUser", newJString(quotaUser))
  add(path_579727, "calendarResourceId", newJString(calendarResourceId))
  if body != nil:
    body_579729 = body
  add(query_579728, "fields", newJString(fields))
  result = call_579726.call(path_579727, query_579728, nil, nil, body_579729)

var directoryResourcesCalendarsPatch* = Call_DirectoryResourcesCalendarsPatch_579712(
    name: "directoryResourcesCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsPatch_579713,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsPatch_579714,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsDelete_579696 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesCalendarsDelete_579698(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesCalendarsDelete_579697(path: JsonNode;
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
  var valid_579699 = path.getOrDefault("customer")
  valid_579699 = validateParameter(valid_579699, JString, required = true,
                                 default = nil)
  if valid_579699 != nil:
    section.add "customer", valid_579699
  var valid_579700 = path.getOrDefault("calendarResourceId")
  valid_579700 = validateParameter(valid_579700, JString, required = true,
                                 default = nil)
  if valid_579700 != nil:
    section.add "calendarResourceId", valid_579700
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
  var valid_579701 = query.getOrDefault("key")
  valid_579701 = validateParameter(valid_579701, JString, required = false,
                                 default = nil)
  if valid_579701 != nil:
    section.add "key", valid_579701
  var valid_579702 = query.getOrDefault("prettyPrint")
  valid_579702 = validateParameter(valid_579702, JBool, required = false,
                                 default = newJBool(true))
  if valid_579702 != nil:
    section.add "prettyPrint", valid_579702
  var valid_579703 = query.getOrDefault("oauth_token")
  valid_579703 = validateParameter(valid_579703, JString, required = false,
                                 default = nil)
  if valid_579703 != nil:
    section.add "oauth_token", valid_579703
  var valid_579704 = query.getOrDefault("alt")
  valid_579704 = validateParameter(valid_579704, JString, required = false,
                                 default = newJString("json"))
  if valid_579704 != nil:
    section.add "alt", valid_579704
  var valid_579705 = query.getOrDefault("userIp")
  valid_579705 = validateParameter(valid_579705, JString, required = false,
                                 default = nil)
  if valid_579705 != nil:
    section.add "userIp", valid_579705
  var valid_579706 = query.getOrDefault("quotaUser")
  valid_579706 = validateParameter(valid_579706, JString, required = false,
                                 default = nil)
  if valid_579706 != nil:
    section.add "quotaUser", valid_579706
  var valid_579707 = query.getOrDefault("fields")
  valid_579707 = validateParameter(valid_579707, JString, required = false,
                                 default = nil)
  if valid_579707 != nil:
    section.add "fields", valid_579707
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579708: Call_DirectoryResourcesCalendarsDelete_579696;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a calendar resource.
  ## 
  let valid = call_579708.validator(path, query, header, formData, body)
  let scheme = call_579708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579708.url(scheme.get, call_579708.host, call_579708.base,
                         call_579708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579708, url, valid)

proc call*(call_579709: Call_DirectoryResourcesCalendarsDelete_579696;
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
  var path_579710 = newJObject()
  var query_579711 = newJObject()
  add(query_579711, "key", newJString(key))
  add(query_579711, "prettyPrint", newJBool(prettyPrint))
  add(query_579711, "oauth_token", newJString(oauthToken))
  add(path_579710, "customer", newJString(customer))
  add(query_579711, "alt", newJString(alt))
  add(query_579711, "userIp", newJString(userIp))
  add(query_579711, "quotaUser", newJString(quotaUser))
  add(path_579710, "calendarResourceId", newJString(calendarResourceId))
  add(query_579711, "fields", newJString(fields))
  result = call_579709.call(path_579710, query_579711, nil, nil, nil)

var directoryResourcesCalendarsDelete* = Call_DirectoryResourcesCalendarsDelete_579696(
    name: "directoryResourcesCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsDelete_579697,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsDelete_579698,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesInsert_579747 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesFeaturesInsert_579749(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesInsert_579748(path: JsonNode;
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
  var valid_579750 = path.getOrDefault("customer")
  valid_579750 = validateParameter(valid_579750, JString, required = true,
                                 default = nil)
  if valid_579750 != nil:
    section.add "customer", valid_579750
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
  var valid_579751 = query.getOrDefault("key")
  valid_579751 = validateParameter(valid_579751, JString, required = false,
                                 default = nil)
  if valid_579751 != nil:
    section.add "key", valid_579751
  var valid_579752 = query.getOrDefault("prettyPrint")
  valid_579752 = validateParameter(valid_579752, JBool, required = false,
                                 default = newJBool(true))
  if valid_579752 != nil:
    section.add "prettyPrint", valid_579752
  var valid_579753 = query.getOrDefault("oauth_token")
  valid_579753 = validateParameter(valid_579753, JString, required = false,
                                 default = nil)
  if valid_579753 != nil:
    section.add "oauth_token", valid_579753
  var valid_579754 = query.getOrDefault("alt")
  valid_579754 = validateParameter(valid_579754, JString, required = false,
                                 default = newJString("json"))
  if valid_579754 != nil:
    section.add "alt", valid_579754
  var valid_579755 = query.getOrDefault("userIp")
  valid_579755 = validateParameter(valid_579755, JString, required = false,
                                 default = nil)
  if valid_579755 != nil:
    section.add "userIp", valid_579755
  var valid_579756 = query.getOrDefault("quotaUser")
  valid_579756 = validateParameter(valid_579756, JString, required = false,
                                 default = nil)
  if valid_579756 != nil:
    section.add "quotaUser", valid_579756
  var valid_579757 = query.getOrDefault("fields")
  valid_579757 = validateParameter(valid_579757, JString, required = false,
                                 default = nil)
  if valid_579757 != nil:
    section.add "fields", valid_579757
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

proc call*(call_579759: Call_DirectoryResourcesFeaturesInsert_579747;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a feature.
  ## 
  let valid = call_579759.validator(path, query, header, formData, body)
  let scheme = call_579759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579759.url(scheme.get, call_579759.host, call_579759.base,
                         call_579759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579759, url, valid)

proc call*(call_579760: Call_DirectoryResourcesFeaturesInsert_579747;
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
  var path_579761 = newJObject()
  var query_579762 = newJObject()
  var body_579763 = newJObject()
  add(query_579762, "key", newJString(key))
  add(query_579762, "prettyPrint", newJBool(prettyPrint))
  add(query_579762, "oauth_token", newJString(oauthToken))
  add(path_579761, "customer", newJString(customer))
  add(query_579762, "alt", newJString(alt))
  add(query_579762, "userIp", newJString(userIp))
  add(query_579762, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579763 = body
  add(query_579762, "fields", newJString(fields))
  result = call_579760.call(path_579761, query_579762, nil, nil, body_579763)

var directoryResourcesFeaturesInsert* = Call_DirectoryResourcesFeaturesInsert_579747(
    name: "directoryResourcesFeaturesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesInsert_579748,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesInsert_579749,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesList_579730 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesFeaturesList_579732(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesList_579731(path: JsonNode;
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
  var valid_579733 = path.getOrDefault("customer")
  valid_579733 = validateParameter(valid_579733, JString, required = true,
                                 default = nil)
  if valid_579733 != nil:
    section.add "customer", valid_579733
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
  var valid_579734 = query.getOrDefault("key")
  valid_579734 = validateParameter(valid_579734, JString, required = false,
                                 default = nil)
  if valid_579734 != nil:
    section.add "key", valid_579734
  var valid_579735 = query.getOrDefault("prettyPrint")
  valid_579735 = validateParameter(valid_579735, JBool, required = false,
                                 default = newJBool(true))
  if valid_579735 != nil:
    section.add "prettyPrint", valid_579735
  var valid_579736 = query.getOrDefault("oauth_token")
  valid_579736 = validateParameter(valid_579736, JString, required = false,
                                 default = nil)
  if valid_579736 != nil:
    section.add "oauth_token", valid_579736
  var valid_579737 = query.getOrDefault("alt")
  valid_579737 = validateParameter(valid_579737, JString, required = false,
                                 default = newJString("json"))
  if valid_579737 != nil:
    section.add "alt", valid_579737
  var valid_579738 = query.getOrDefault("userIp")
  valid_579738 = validateParameter(valid_579738, JString, required = false,
                                 default = nil)
  if valid_579738 != nil:
    section.add "userIp", valid_579738
  var valid_579739 = query.getOrDefault("quotaUser")
  valid_579739 = validateParameter(valid_579739, JString, required = false,
                                 default = nil)
  if valid_579739 != nil:
    section.add "quotaUser", valid_579739
  var valid_579740 = query.getOrDefault("pageToken")
  valid_579740 = validateParameter(valid_579740, JString, required = false,
                                 default = nil)
  if valid_579740 != nil:
    section.add "pageToken", valid_579740
  var valid_579741 = query.getOrDefault("fields")
  valid_579741 = validateParameter(valid_579741, JString, required = false,
                                 default = nil)
  if valid_579741 != nil:
    section.add "fields", valid_579741
  var valid_579742 = query.getOrDefault("maxResults")
  valid_579742 = validateParameter(valid_579742, JInt, required = false, default = nil)
  if valid_579742 != nil:
    section.add "maxResults", valid_579742
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579743: Call_DirectoryResourcesFeaturesList_579730; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of features for an account.
  ## 
  let valid = call_579743.validator(path, query, header, formData, body)
  let scheme = call_579743.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579743.url(scheme.get, call_579743.host, call_579743.base,
                         call_579743.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579743, url, valid)

proc call*(call_579744: Call_DirectoryResourcesFeaturesList_579730;
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
  var path_579745 = newJObject()
  var query_579746 = newJObject()
  add(query_579746, "key", newJString(key))
  add(query_579746, "prettyPrint", newJBool(prettyPrint))
  add(query_579746, "oauth_token", newJString(oauthToken))
  add(path_579745, "customer", newJString(customer))
  add(query_579746, "alt", newJString(alt))
  add(query_579746, "userIp", newJString(userIp))
  add(query_579746, "quotaUser", newJString(quotaUser))
  add(query_579746, "pageToken", newJString(pageToken))
  add(query_579746, "fields", newJString(fields))
  add(query_579746, "maxResults", newJInt(maxResults))
  result = call_579744.call(path_579745, query_579746, nil, nil, nil)

var directoryResourcesFeaturesList* = Call_DirectoryResourcesFeaturesList_579730(
    name: "directoryResourcesFeaturesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesList_579731,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesList_579732,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesUpdate_579780 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesFeaturesUpdate_579782(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesUpdate_579781(path: JsonNode;
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
  var valid_579783 = path.getOrDefault("featureKey")
  valid_579783 = validateParameter(valid_579783, JString, required = true,
                                 default = nil)
  if valid_579783 != nil:
    section.add "featureKey", valid_579783
  var valid_579784 = path.getOrDefault("customer")
  valid_579784 = validateParameter(valid_579784, JString, required = true,
                                 default = nil)
  if valid_579784 != nil:
    section.add "customer", valid_579784
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
  var valid_579785 = query.getOrDefault("key")
  valid_579785 = validateParameter(valid_579785, JString, required = false,
                                 default = nil)
  if valid_579785 != nil:
    section.add "key", valid_579785
  var valid_579786 = query.getOrDefault("prettyPrint")
  valid_579786 = validateParameter(valid_579786, JBool, required = false,
                                 default = newJBool(true))
  if valid_579786 != nil:
    section.add "prettyPrint", valid_579786
  var valid_579787 = query.getOrDefault("oauth_token")
  valid_579787 = validateParameter(valid_579787, JString, required = false,
                                 default = nil)
  if valid_579787 != nil:
    section.add "oauth_token", valid_579787
  var valid_579788 = query.getOrDefault("alt")
  valid_579788 = validateParameter(valid_579788, JString, required = false,
                                 default = newJString("json"))
  if valid_579788 != nil:
    section.add "alt", valid_579788
  var valid_579789 = query.getOrDefault("userIp")
  valid_579789 = validateParameter(valid_579789, JString, required = false,
                                 default = nil)
  if valid_579789 != nil:
    section.add "userIp", valid_579789
  var valid_579790 = query.getOrDefault("quotaUser")
  valid_579790 = validateParameter(valid_579790, JString, required = false,
                                 default = nil)
  if valid_579790 != nil:
    section.add "quotaUser", valid_579790
  var valid_579791 = query.getOrDefault("fields")
  valid_579791 = validateParameter(valid_579791, JString, required = false,
                                 default = nil)
  if valid_579791 != nil:
    section.add "fields", valid_579791
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

proc call*(call_579793: Call_DirectoryResourcesFeaturesUpdate_579780;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature.
  ## 
  let valid = call_579793.validator(path, query, header, formData, body)
  let scheme = call_579793.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579793.url(scheme.get, call_579793.host, call_579793.base,
                         call_579793.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579793, url, valid)

proc call*(call_579794: Call_DirectoryResourcesFeaturesUpdate_579780;
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
  var path_579795 = newJObject()
  var query_579796 = newJObject()
  var body_579797 = newJObject()
  add(query_579796, "key", newJString(key))
  add(query_579796, "prettyPrint", newJBool(prettyPrint))
  add(query_579796, "oauth_token", newJString(oauthToken))
  add(path_579795, "featureKey", newJString(featureKey))
  add(path_579795, "customer", newJString(customer))
  add(query_579796, "alt", newJString(alt))
  add(query_579796, "userIp", newJString(userIp))
  add(query_579796, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579797 = body
  add(query_579796, "fields", newJString(fields))
  result = call_579794.call(path_579795, query_579796, nil, nil, body_579797)

var directoryResourcesFeaturesUpdate* = Call_DirectoryResourcesFeaturesUpdate_579780(
    name: "directoryResourcesFeaturesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesUpdate_579781,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesUpdate_579782,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesGet_579764 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesFeaturesGet_579766(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesGet_579765(path: JsonNode; query: JsonNode;
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
  var valid_579767 = path.getOrDefault("featureKey")
  valid_579767 = validateParameter(valid_579767, JString, required = true,
                                 default = nil)
  if valid_579767 != nil:
    section.add "featureKey", valid_579767
  var valid_579768 = path.getOrDefault("customer")
  valid_579768 = validateParameter(valid_579768, JString, required = true,
                                 default = nil)
  if valid_579768 != nil:
    section.add "customer", valid_579768
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
  var valid_579769 = query.getOrDefault("key")
  valid_579769 = validateParameter(valid_579769, JString, required = false,
                                 default = nil)
  if valid_579769 != nil:
    section.add "key", valid_579769
  var valid_579770 = query.getOrDefault("prettyPrint")
  valid_579770 = validateParameter(valid_579770, JBool, required = false,
                                 default = newJBool(true))
  if valid_579770 != nil:
    section.add "prettyPrint", valid_579770
  var valid_579771 = query.getOrDefault("oauth_token")
  valid_579771 = validateParameter(valid_579771, JString, required = false,
                                 default = nil)
  if valid_579771 != nil:
    section.add "oauth_token", valid_579771
  var valid_579772 = query.getOrDefault("alt")
  valid_579772 = validateParameter(valid_579772, JString, required = false,
                                 default = newJString("json"))
  if valid_579772 != nil:
    section.add "alt", valid_579772
  var valid_579773 = query.getOrDefault("userIp")
  valid_579773 = validateParameter(valid_579773, JString, required = false,
                                 default = nil)
  if valid_579773 != nil:
    section.add "userIp", valid_579773
  var valid_579774 = query.getOrDefault("quotaUser")
  valid_579774 = validateParameter(valid_579774, JString, required = false,
                                 default = nil)
  if valid_579774 != nil:
    section.add "quotaUser", valid_579774
  var valid_579775 = query.getOrDefault("fields")
  valid_579775 = validateParameter(valid_579775, JString, required = false,
                                 default = nil)
  if valid_579775 != nil:
    section.add "fields", valid_579775
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579776: Call_DirectoryResourcesFeaturesGet_579764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a feature.
  ## 
  let valid = call_579776.validator(path, query, header, formData, body)
  let scheme = call_579776.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579776.url(scheme.get, call_579776.host, call_579776.base,
                         call_579776.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579776, url, valid)

proc call*(call_579777: Call_DirectoryResourcesFeaturesGet_579764;
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
  var path_579778 = newJObject()
  var query_579779 = newJObject()
  add(query_579779, "key", newJString(key))
  add(query_579779, "prettyPrint", newJBool(prettyPrint))
  add(query_579779, "oauth_token", newJString(oauthToken))
  add(path_579778, "featureKey", newJString(featureKey))
  add(path_579778, "customer", newJString(customer))
  add(query_579779, "alt", newJString(alt))
  add(query_579779, "userIp", newJString(userIp))
  add(query_579779, "quotaUser", newJString(quotaUser))
  add(query_579779, "fields", newJString(fields))
  result = call_579777.call(path_579778, query_579779, nil, nil, nil)

var directoryResourcesFeaturesGet* = Call_DirectoryResourcesFeaturesGet_579764(
    name: "directoryResourcesFeaturesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesGet_579765,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesGet_579766,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesPatch_579814 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesFeaturesPatch_579816(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesPatch_579815(path: JsonNode;
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
  var valid_579817 = path.getOrDefault("featureKey")
  valid_579817 = validateParameter(valid_579817, JString, required = true,
                                 default = nil)
  if valid_579817 != nil:
    section.add "featureKey", valid_579817
  var valid_579818 = path.getOrDefault("customer")
  valid_579818 = validateParameter(valid_579818, JString, required = true,
                                 default = nil)
  if valid_579818 != nil:
    section.add "customer", valid_579818
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
  var valid_579819 = query.getOrDefault("key")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "key", valid_579819
  var valid_579820 = query.getOrDefault("prettyPrint")
  valid_579820 = validateParameter(valid_579820, JBool, required = false,
                                 default = newJBool(true))
  if valid_579820 != nil:
    section.add "prettyPrint", valid_579820
  var valid_579821 = query.getOrDefault("oauth_token")
  valid_579821 = validateParameter(valid_579821, JString, required = false,
                                 default = nil)
  if valid_579821 != nil:
    section.add "oauth_token", valid_579821
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("userIp")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "userIp", valid_579823
  var valid_579824 = query.getOrDefault("quotaUser")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "quotaUser", valid_579824
  var valid_579825 = query.getOrDefault("fields")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "fields", valid_579825
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

proc call*(call_579827: Call_DirectoryResourcesFeaturesPatch_579814;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature. This method supports patch semantics.
  ## 
  let valid = call_579827.validator(path, query, header, formData, body)
  let scheme = call_579827.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579827.url(scheme.get, call_579827.host, call_579827.base,
                         call_579827.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579827, url, valid)

proc call*(call_579828: Call_DirectoryResourcesFeaturesPatch_579814;
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
  var path_579829 = newJObject()
  var query_579830 = newJObject()
  var body_579831 = newJObject()
  add(query_579830, "key", newJString(key))
  add(query_579830, "prettyPrint", newJBool(prettyPrint))
  add(query_579830, "oauth_token", newJString(oauthToken))
  add(path_579829, "featureKey", newJString(featureKey))
  add(path_579829, "customer", newJString(customer))
  add(query_579830, "alt", newJString(alt))
  add(query_579830, "userIp", newJString(userIp))
  add(query_579830, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579831 = body
  add(query_579830, "fields", newJString(fields))
  result = call_579828.call(path_579829, query_579830, nil, nil, body_579831)

var directoryResourcesFeaturesPatch* = Call_DirectoryResourcesFeaturesPatch_579814(
    name: "directoryResourcesFeaturesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesPatch_579815,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesPatch_579816,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesDelete_579798 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesFeaturesDelete_579800(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesDelete_579799(path: JsonNode;
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
  var valid_579801 = path.getOrDefault("featureKey")
  valid_579801 = validateParameter(valid_579801, JString, required = true,
                                 default = nil)
  if valid_579801 != nil:
    section.add "featureKey", valid_579801
  var valid_579802 = path.getOrDefault("customer")
  valid_579802 = validateParameter(valid_579802, JString, required = true,
                                 default = nil)
  if valid_579802 != nil:
    section.add "customer", valid_579802
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
  var valid_579803 = query.getOrDefault("key")
  valid_579803 = validateParameter(valid_579803, JString, required = false,
                                 default = nil)
  if valid_579803 != nil:
    section.add "key", valid_579803
  var valid_579804 = query.getOrDefault("prettyPrint")
  valid_579804 = validateParameter(valid_579804, JBool, required = false,
                                 default = newJBool(true))
  if valid_579804 != nil:
    section.add "prettyPrint", valid_579804
  var valid_579805 = query.getOrDefault("oauth_token")
  valid_579805 = validateParameter(valid_579805, JString, required = false,
                                 default = nil)
  if valid_579805 != nil:
    section.add "oauth_token", valid_579805
  var valid_579806 = query.getOrDefault("alt")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = newJString("json"))
  if valid_579806 != nil:
    section.add "alt", valid_579806
  var valid_579807 = query.getOrDefault("userIp")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "userIp", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579809 = query.getOrDefault("fields")
  valid_579809 = validateParameter(valid_579809, JString, required = false,
                                 default = nil)
  if valid_579809 != nil:
    section.add "fields", valid_579809
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579810: Call_DirectoryResourcesFeaturesDelete_579798;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a feature.
  ## 
  let valid = call_579810.validator(path, query, header, formData, body)
  let scheme = call_579810.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579810.url(scheme.get, call_579810.host, call_579810.base,
                         call_579810.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579810, url, valid)

proc call*(call_579811: Call_DirectoryResourcesFeaturesDelete_579798;
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
  var path_579812 = newJObject()
  var query_579813 = newJObject()
  add(query_579813, "key", newJString(key))
  add(query_579813, "prettyPrint", newJBool(prettyPrint))
  add(query_579813, "oauth_token", newJString(oauthToken))
  add(path_579812, "featureKey", newJString(featureKey))
  add(path_579812, "customer", newJString(customer))
  add(query_579813, "alt", newJString(alt))
  add(query_579813, "userIp", newJString(userIp))
  add(query_579813, "quotaUser", newJString(quotaUser))
  add(query_579813, "fields", newJString(fields))
  result = call_579811.call(path_579812, query_579813, nil, nil, nil)

var directoryResourcesFeaturesDelete* = Call_DirectoryResourcesFeaturesDelete_579798(
    name: "directoryResourcesFeaturesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesDelete_579799,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesDelete_579800,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesRename_579832 = ref object of OpenApiRestCall_578364
proc url_DirectoryResourcesFeaturesRename_579834(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryResourcesFeaturesRename_579833(path: JsonNode;
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
  var valid_579835 = path.getOrDefault("customer")
  valid_579835 = validateParameter(valid_579835, JString, required = true,
                                 default = nil)
  if valid_579835 != nil:
    section.add "customer", valid_579835
  var valid_579836 = path.getOrDefault("oldName")
  valid_579836 = validateParameter(valid_579836, JString, required = true,
                                 default = nil)
  if valid_579836 != nil:
    section.add "oldName", valid_579836
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
  var valid_579837 = query.getOrDefault("key")
  valid_579837 = validateParameter(valid_579837, JString, required = false,
                                 default = nil)
  if valid_579837 != nil:
    section.add "key", valid_579837
  var valid_579838 = query.getOrDefault("prettyPrint")
  valid_579838 = validateParameter(valid_579838, JBool, required = false,
                                 default = newJBool(true))
  if valid_579838 != nil:
    section.add "prettyPrint", valid_579838
  var valid_579839 = query.getOrDefault("oauth_token")
  valid_579839 = validateParameter(valid_579839, JString, required = false,
                                 default = nil)
  if valid_579839 != nil:
    section.add "oauth_token", valid_579839
  var valid_579840 = query.getOrDefault("alt")
  valid_579840 = validateParameter(valid_579840, JString, required = false,
                                 default = newJString("json"))
  if valid_579840 != nil:
    section.add "alt", valid_579840
  var valid_579841 = query.getOrDefault("userIp")
  valid_579841 = validateParameter(valid_579841, JString, required = false,
                                 default = nil)
  if valid_579841 != nil:
    section.add "userIp", valid_579841
  var valid_579842 = query.getOrDefault("quotaUser")
  valid_579842 = validateParameter(valid_579842, JString, required = false,
                                 default = nil)
  if valid_579842 != nil:
    section.add "quotaUser", valid_579842
  var valid_579843 = query.getOrDefault("fields")
  valid_579843 = validateParameter(valid_579843, JString, required = false,
                                 default = nil)
  if valid_579843 != nil:
    section.add "fields", valid_579843
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

proc call*(call_579845: Call_DirectoryResourcesFeaturesRename_579832;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a feature.
  ## 
  let valid = call_579845.validator(path, query, header, formData, body)
  let scheme = call_579845.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579845.url(scheme.get, call_579845.host, call_579845.base,
                         call_579845.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579845, url, valid)

proc call*(call_579846: Call_DirectoryResourcesFeaturesRename_579832;
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
  var path_579847 = newJObject()
  var query_579848 = newJObject()
  var body_579849 = newJObject()
  add(query_579848, "key", newJString(key))
  add(query_579848, "prettyPrint", newJBool(prettyPrint))
  add(query_579848, "oauth_token", newJString(oauthToken))
  add(path_579847, "customer", newJString(customer))
  add(query_579848, "alt", newJString(alt))
  add(query_579848, "userIp", newJString(userIp))
  add(query_579848, "quotaUser", newJString(quotaUser))
  add(path_579847, "oldName", newJString(oldName))
  if body != nil:
    body_579849 = body
  add(query_579848, "fields", newJString(fields))
  result = call_579846.call(path_579847, query_579848, nil, nil, body_579849)

var directoryResourcesFeaturesRename* = Call_DirectoryResourcesFeaturesRename_579832(
    name: "directoryResourcesFeaturesRename", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{oldName}/rename",
    validator: validate_DirectoryResourcesFeaturesRename_579833,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesRename_579834,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsInsert_579869 = ref object of OpenApiRestCall_578364
proc url_DirectoryRoleAssignmentsInsert_579871(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRoleAssignmentsInsert_579870(path: JsonNode;
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
  var valid_579872 = path.getOrDefault("customer")
  valid_579872 = validateParameter(valid_579872, JString, required = true,
                                 default = nil)
  if valid_579872 != nil:
    section.add "customer", valid_579872
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
  var valid_579873 = query.getOrDefault("key")
  valid_579873 = validateParameter(valid_579873, JString, required = false,
                                 default = nil)
  if valid_579873 != nil:
    section.add "key", valid_579873
  var valid_579874 = query.getOrDefault("prettyPrint")
  valid_579874 = validateParameter(valid_579874, JBool, required = false,
                                 default = newJBool(true))
  if valid_579874 != nil:
    section.add "prettyPrint", valid_579874
  var valid_579875 = query.getOrDefault("oauth_token")
  valid_579875 = validateParameter(valid_579875, JString, required = false,
                                 default = nil)
  if valid_579875 != nil:
    section.add "oauth_token", valid_579875
  var valid_579876 = query.getOrDefault("alt")
  valid_579876 = validateParameter(valid_579876, JString, required = false,
                                 default = newJString("json"))
  if valid_579876 != nil:
    section.add "alt", valid_579876
  var valid_579877 = query.getOrDefault("userIp")
  valid_579877 = validateParameter(valid_579877, JString, required = false,
                                 default = nil)
  if valid_579877 != nil:
    section.add "userIp", valid_579877
  var valid_579878 = query.getOrDefault("quotaUser")
  valid_579878 = validateParameter(valid_579878, JString, required = false,
                                 default = nil)
  if valid_579878 != nil:
    section.add "quotaUser", valid_579878
  var valid_579879 = query.getOrDefault("fields")
  valid_579879 = validateParameter(valid_579879, JString, required = false,
                                 default = nil)
  if valid_579879 != nil:
    section.add "fields", valid_579879
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

proc call*(call_579881: Call_DirectoryRoleAssignmentsInsert_579869; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment.
  ## 
  let valid = call_579881.validator(path, query, header, formData, body)
  let scheme = call_579881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579881.url(scheme.get, call_579881.host, call_579881.base,
                         call_579881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579881, url, valid)

proc call*(call_579882: Call_DirectoryRoleAssignmentsInsert_579869;
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
  var path_579883 = newJObject()
  var query_579884 = newJObject()
  var body_579885 = newJObject()
  add(query_579884, "key", newJString(key))
  add(query_579884, "prettyPrint", newJBool(prettyPrint))
  add(query_579884, "oauth_token", newJString(oauthToken))
  add(path_579883, "customer", newJString(customer))
  add(query_579884, "alt", newJString(alt))
  add(query_579884, "userIp", newJString(userIp))
  add(query_579884, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579885 = body
  add(query_579884, "fields", newJString(fields))
  result = call_579882.call(path_579883, query_579884, nil, nil, body_579885)

var directoryRoleAssignmentsInsert* = Call_DirectoryRoleAssignmentsInsert_579869(
    name: "directoryRoleAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsInsert_579870,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsInsert_579871,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsList_579850 = ref object of OpenApiRestCall_578364
proc url_DirectoryRoleAssignmentsList_579852(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRoleAssignmentsList_579851(path: JsonNode; query: JsonNode;
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
  var valid_579853 = path.getOrDefault("customer")
  valid_579853 = validateParameter(valid_579853, JString, required = true,
                                 default = nil)
  if valid_579853 != nil:
    section.add "customer", valid_579853
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
  var valid_579854 = query.getOrDefault("key")
  valid_579854 = validateParameter(valid_579854, JString, required = false,
                                 default = nil)
  if valid_579854 != nil:
    section.add "key", valid_579854
  var valid_579855 = query.getOrDefault("prettyPrint")
  valid_579855 = validateParameter(valid_579855, JBool, required = false,
                                 default = newJBool(true))
  if valid_579855 != nil:
    section.add "prettyPrint", valid_579855
  var valid_579856 = query.getOrDefault("oauth_token")
  valid_579856 = validateParameter(valid_579856, JString, required = false,
                                 default = nil)
  if valid_579856 != nil:
    section.add "oauth_token", valid_579856
  var valid_579857 = query.getOrDefault("alt")
  valid_579857 = validateParameter(valid_579857, JString, required = false,
                                 default = newJString("json"))
  if valid_579857 != nil:
    section.add "alt", valid_579857
  var valid_579858 = query.getOrDefault("userIp")
  valid_579858 = validateParameter(valid_579858, JString, required = false,
                                 default = nil)
  if valid_579858 != nil:
    section.add "userIp", valid_579858
  var valid_579859 = query.getOrDefault("quotaUser")
  valid_579859 = validateParameter(valid_579859, JString, required = false,
                                 default = nil)
  if valid_579859 != nil:
    section.add "quotaUser", valid_579859
  var valid_579860 = query.getOrDefault("userKey")
  valid_579860 = validateParameter(valid_579860, JString, required = false,
                                 default = nil)
  if valid_579860 != nil:
    section.add "userKey", valid_579860
  var valid_579861 = query.getOrDefault("pageToken")
  valid_579861 = validateParameter(valid_579861, JString, required = false,
                                 default = nil)
  if valid_579861 != nil:
    section.add "pageToken", valid_579861
  var valid_579862 = query.getOrDefault("roleId")
  valid_579862 = validateParameter(valid_579862, JString, required = false,
                                 default = nil)
  if valid_579862 != nil:
    section.add "roleId", valid_579862
  var valid_579863 = query.getOrDefault("fields")
  valid_579863 = validateParameter(valid_579863, JString, required = false,
                                 default = nil)
  if valid_579863 != nil:
    section.add "fields", valid_579863
  var valid_579864 = query.getOrDefault("maxResults")
  valid_579864 = validateParameter(valid_579864, JInt, required = false, default = nil)
  if valid_579864 != nil:
    section.add "maxResults", valid_579864
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579865: Call_DirectoryRoleAssignmentsList_579850; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all roleAssignments.
  ## 
  let valid = call_579865.validator(path, query, header, formData, body)
  let scheme = call_579865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579865.url(scheme.get, call_579865.host, call_579865.base,
                         call_579865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579865, url, valid)

proc call*(call_579866: Call_DirectoryRoleAssignmentsList_579850; customer: string;
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
  var path_579867 = newJObject()
  var query_579868 = newJObject()
  add(query_579868, "key", newJString(key))
  add(query_579868, "prettyPrint", newJBool(prettyPrint))
  add(query_579868, "oauth_token", newJString(oauthToken))
  add(path_579867, "customer", newJString(customer))
  add(query_579868, "alt", newJString(alt))
  add(query_579868, "userIp", newJString(userIp))
  add(query_579868, "quotaUser", newJString(quotaUser))
  add(query_579868, "userKey", newJString(userKey))
  add(query_579868, "pageToken", newJString(pageToken))
  add(query_579868, "roleId", newJString(roleId))
  add(query_579868, "fields", newJString(fields))
  add(query_579868, "maxResults", newJInt(maxResults))
  result = call_579866.call(path_579867, query_579868, nil, nil, nil)

var directoryRoleAssignmentsList* = Call_DirectoryRoleAssignmentsList_579850(
    name: "directoryRoleAssignmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsList_579851,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsList_579852,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsGet_579886 = ref object of OpenApiRestCall_578364
proc url_DirectoryRoleAssignmentsGet_579888(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRoleAssignmentsGet_579887(path: JsonNode; query: JsonNode;
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
  var valid_579889 = path.getOrDefault("customer")
  valid_579889 = validateParameter(valid_579889, JString, required = true,
                                 default = nil)
  if valid_579889 != nil:
    section.add "customer", valid_579889
  var valid_579890 = path.getOrDefault("roleAssignmentId")
  valid_579890 = validateParameter(valid_579890, JString, required = true,
                                 default = nil)
  if valid_579890 != nil:
    section.add "roleAssignmentId", valid_579890
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
  var valid_579891 = query.getOrDefault("key")
  valid_579891 = validateParameter(valid_579891, JString, required = false,
                                 default = nil)
  if valid_579891 != nil:
    section.add "key", valid_579891
  var valid_579892 = query.getOrDefault("prettyPrint")
  valid_579892 = validateParameter(valid_579892, JBool, required = false,
                                 default = newJBool(true))
  if valid_579892 != nil:
    section.add "prettyPrint", valid_579892
  var valid_579893 = query.getOrDefault("oauth_token")
  valid_579893 = validateParameter(valid_579893, JString, required = false,
                                 default = nil)
  if valid_579893 != nil:
    section.add "oauth_token", valid_579893
  var valid_579894 = query.getOrDefault("alt")
  valid_579894 = validateParameter(valid_579894, JString, required = false,
                                 default = newJString("json"))
  if valid_579894 != nil:
    section.add "alt", valid_579894
  var valid_579895 = query.getOrDefault("userIp")
  valid_579895 = validateParameter(valid_579895, JString, required = false,
                                 default = nil)
  if valid_579895 != nil:
    section.add "userIp", valid_579895
  var valid_579896 = query.getOrDefault("quotaUser")
  valid_579896 = validateParameter(valid_579896, JString, required = false,
                                 default = nil)
  if valid_579896 != nil:
    section.add "quotaUser", valid_579896
  var valid_579897 = query.getOrDefault("fields")
  valid_579897 = validateParameter(valid_579897, JString, required = false,
                                 default = nil)
  if valid_579897 != nil:
    section.add "fields", valid_579897
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579898: Call_DirectoryRoleAssignmentsGet_579886; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a role assignment.
  ## 
  let valid = call_579898.validator(path, query, header, formData, body)
  let scheme = call_579898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579898.url(scheme.get, call_579898.host, call_579898.base,
                         call_579898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579898, url, valid)

proc call*(call_579899: Call_DirectoryRoleAssignmentsGet_579886; customer: string;
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
  var path_579900 = newJObject()
  var query_579901 = newJObject()
  add(query_579901, "key", newJString(key))
  add(query_579901, "prettyPrint", newJBool(prettyPrint))
  add(query_579901, "oauth_token", newJString(oauthToken))
  add(path_579900, "customer", newJString(customer))
  add(query_579901, "alt", newJString(alt))
  add(query_579901, "userIp", newJString(userIp))
  add(query_579901, "quotaUser", newJString(quotaUser))
  add(path_579900, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_579901, "fields", newJString(fields))
  result = call_579899.call(path_579900, query_579901, nil, nil, nil)

var directoryRoleAssignmentsGet* = Call_DirectoryRoleAssignmentsGet_579886(
    name: "directoryRoleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsGet_579887,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsGet_579888,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsDelete_579902 = ref object of OpenApiRestCall_578364
proc url_DirectoryRoleAssignmentsDelete_579904(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRoleAssignmentsDelete_579903(path: JsonNode;
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
  var valid_579905 = path.getOrDefault("customer")
  valid_579905 = validateParameter(valid_579905, JString, required = true,
                                 default = nil)
  if valid_579905 != nil:
    section.add "customer", valid_579905
  var valid_579906 = path.getOrDefault("roleAssignmentId")
  valid_579906 = validateParameter(valid_579906, JString, required = true,
                                 default = nil)
  if valid_579906 != nil:
    section.add "roleAssignmentId", valid_579906
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
  if body != nil:
    result.add "body", body

proc call*(call_579914: Call_DirectoryRoleAssignmentsDelete_579902; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_579914.validator(path, query, header, formData, body)
  let scheme = call_579914.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579914.url(scheme.get, call_579914.host, call_579914.base,
                         call_579914.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579914, url, valid)

proc call*(call_579915: Call_DirectoryRoleAssignmentsDelete_579902;
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
  var path_579916 = newJObject()
  var query_579917 = newJObject()
  add(query_579917, "key", newJString(key))
  add(query_579917, "prettyPrint", newJBool(prettyPrint))
  add(query_579917, "oauth_token", newJString(oauthToken))
  add(path_579916, "customer", newJString(customer))
  add(query_579917, "alt", newJString(alt))
  add(query_579917, "userIp", newJString(userIp))
  add(query_579917, "quotaUser", newJString(quotaUser))
  add(path_579916, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_579917, "fields", newJString(fields))
  result = call_579915.call(path_579916, query_579917, nil, nil, nil)

var directoryRoleAssignmentsDelete* = Call_DirectoryRoleAssignmentsDelete_579902(
    name: "directoryRoleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsDelete_579903,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsDelete_579904,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesInsert_579935 = ref object of OpenApiRestCall_578364
proc url_DirectoryRolesInsert_579937(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRolesInsert_579936(path: JsonNode; query: JsonNode;
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
  var valid_579938 = path.getOrDefault("customer")
  valid_579938 = validateParameter(valid_579938, JString, required = true,
                                 default = nil)
  if valid_579938 != nil:
    section.add "customer", valid_579938
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
  var valid_579939 = query.getOrDefault("key")
  valid_579939 = validateParameter(valid_579939, JString, required = false,
                                 default = nil)
  if valid_579939 != nil:
    section.add "key", valid_579939
  var valid_579940 = query.getOrDefault("prettyPrint")
  valid_579940 = validateParameter(valid_579940, JBool, required = false,
                                 default = newJBool(true))
  if valid_579940 != nil:
    section.add "prettyPrint", valid_579940
  var valid_579941 = query.getOrDefault("oauth_token")
  valid_579941 = validateParameter(valid_579941, JString, required = false,
                                 default = nil)
  if valid_579941 != nil:
    section.add "oauth_token", valid_579941
  var valid_579942 = query.getOrDefault("alt")
  valid_579942 = validateParameter(valid_579942, JString, required = false,
                                 default = newJString("json"))
  if valid_579942 != nil:
    section.add "alt", valid_579942
  var valid_579943 = query.getOrDefault("userIp")
  valid_579943 = validateParameter(valid_579943, JString, required = false,
                                 default = nil)
  if valid_579943 != nil:
    section.add "userIp", valid_579943
  var valid_579944 = query.getOrDefault("quotaUser")
  valid_579944 = validateParameter(valid_579944, JString, required = false,
                                 default = nil)
  if valid_579944 != nil:
    section.add "quotaUser", valid_579944
  var valid_579945 = query.getOrDefault("fields")
  valid_579945 = validateParameter(valid_579945, JString, required = false,
                                 default = nil)
  if valid_579945 != nil:
    section.add "fields", valid_579945
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

proc call*(call_579947: Call_DirectoryRolesInsert_579935; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role.
  ## 
  let valid = call_579947.validator(path, query, header, formData, body)
  let scheme = call_579947.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579947.url(scheme.get, call_579947.host, call_579947.base,
                         call_579947.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579947, url, valid)

proc call*(call_579948: Call_DirectoryRolesInsert_579935; customer: string;
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
  var path_579949 = newJObject()
  var query_579950 = newJObject()
  var body_579951 = newJObject()
  add(query_579950, "key", newJString(key))
  add(query_579950, "prettyPrint", newJBool(prettyPrint))
  add(query_579950, "oauth_token", newJString(oauthToken))
  add(path_579949, "customer", newJString(customer))
  add(query_579950, "alt", newJString(alt))
  add(query_579950, "userIp", newJString(userIp))
  add(query_579950, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579951 = body
  add(query_579950, "fields", newJString(fields))
  result = call_579948.call(path_579949, query_579950, nil, nil, body_579951)

var directoryRolesInsert* = Call_DirectoryRolesInsert_579935(
    name: "directoryRolesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesInsert_579936, base: "/admin/directory/v1",
    url: url_DirectoryRolesInsert_579937, schemes: {Scheme.Https})
type
  Call_DirectoryRolesList_579918 = ref object of OpenApiRestCall_578364
proc url_DirectoryRolesList_579920(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRolesList_579919(path: JsonNode; query: JsonNode;
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
  var valid_579921 = path.getOrDefault("customer")
  valid_579921 = validateParameter(valid_579921, JString, required = true,
                                 default = nil)
  if valid_579921 != nil:
    section.add "customer", valid_579921
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
  var valid_579928 = query.getOrDefault("pageToken")
  valid_579928 = validateParameter(valid_579928, JString, required = false,
                                 default = nil)
  if valid_579928 != nil:
    section.add "pageToken", valid_579928
  var valid_579929 = query.getOrDefault("fields")
  valid_579929 = validateParameter(valid_579929, JString, required = false,
                                 default = nil)
  if valid_579929 != nil:
    section.add "fields", valid_579929
  var valid_579930 = query.getOrDefault("maxResults")
  valid_579930 = validateParameter(valid_579930, JInt, required = false, default = nil)
  if valid_579930 != nil:
    section.add "maxResults", valid_579930
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579931: Call_DirectoryRolesList_579918; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all the roles in a domain.
  ## 
  let valid = call_579931.validator(path, query, header, formData, body)
  let scheme = call_579931.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579931.url(scheme.get, call_579931.host, call_579931.base,
                         call_579931.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579931, url, valid)

proc call*(call_579932: Call_DirectoryRolesList_579918; customer: string;
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
  var path_579933 = newJObject()
  var query_579934 = newJObject()
  add(query_579934, "key", newJString(key))
  add(query_579934, "prettyPrint", newJBool(prettyPrint))
  add(query_579934, "oauth_token", newJString(oauthToken))
  add(path_579933, "customer", newJString(customer))
  add(query_579934, "alt", newJString(alt))
  add(query_579934, "userIp", newJString(userIp))
  add(query_579934, "quotaUser", newJString(quotaUser))
  add(query_579934, "pageToken", newJString(pageToken))
  add(query_579934, "fields", newJString(fields))
  add(query_579934, "maxResults", newJInt(maxResults))
  result = call_579932.call(path_579933, query_579934, nil, nil, nil)

var directoryRolesList* = Call_DirectoryRolesList_579918(
    name: "directoryRolesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesList_579919, base: "/admin/directory/v1",
    url: url_DirectoryRolesList_579920, schemes: {Scheme.Https})
type
  Call_DirectoryPrivilegesList_579952 = ref object of OpenApiRestCall_578364
proc url_DirectoryPrivilegesList_579954(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryPrivilegesList_579953(path: JsonNode; query: JsonNode;
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
  var valid_579955 = path.getOrDefault("customer")
  valid_579955 = validateParameter(valid_579955, JString, required = true,
                                 default = nil)
  if valid_579955 != nil:
    section.add "customer", valid_579955
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
  var valid_579956 = query.getOrDefault("key")
  valid_579956 = validateParameter(valid_579956, JString, required = false,
                                 default = nil)
  if valid_579956 != nil:
    section.add "key", valid_579956
  var valid_579957 = query.getOrDefault("prettyPrint")
  valid_579957 = validateParameter(valid_579957, JBool, required = false,
                                 default = newJBool(true))
  if valid_579957 != nil:
    section.add "prettyPrint", valid_579957
  var valid_579958 = query.getOrDefault("oauth_token")
  valid_579958 = validateParameter(valid_579958, JString, required = false,
                                 default = nil)
  if valid_579958 != nil:
    section.add "oauth_token", valid_579958
  var valid_579959 = query.getOrDefault("alt")
  valid_579959 = validateParameter(valid_579959, JString, required = false,
                                 default = newJString("json"))
  if valid_579959 != nil:
    section.add "alt", valid_579959
  var valid_579960 = query.getOrDefault("userIp")
  valid_579960 = validateParameter(valid_579960, JString, required = false,
                                 default = nil)
  if valid_579960 != nil:
    section.add "userIp", valid_579960
  var valid_579961 = query.getOrDefault("quotaUser")
  valid_579961 = validateParameter(valid_579961, JString, required = false,
                                 default = nil)
  if valid_579961 != nil:
    section.add "quotaUser", valid_579961
  var valid_579962 = query.getOrDefault("fields")
  valid_579962 = validateParameter(valid_579962, JString, required = false,
                                 default = nil)
  if valid_579962 != nil:
    section.add "fields", valid_579962
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579963: Call_DirectoryPrivilegesList_579952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all privileges for a customer.
  ## 
  let valid = call_579963.validator(path, query, header, formData, body)
  let scheme = call_579963.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579963.url(scheme.get, call_579963.host, call_579963.base,
                         call_579963.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579963, url, valid)

proc call*(call_579964: Call_DirectoryPrivilegesList_579952; customer: string;
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
  var path_579965 = newJObject()
  var query_579966 = newJObject()
  add(query_579966, "key", newJString(key))
  add(query_579966, "prettyPrint", newJBool(prettyPrint))
  add(query_579966, "oauth_token", newJString(oauthToken))
  add(path_579965, "customer", newJString(customer))
  add(query_579966, "alt", newJString(alt))
  add(query_579966, "userIp", newJString(userIp))
  add(query_579966, "quotaUser", newJString(quotaUser))
  add(query_579966, "fields", newJString(fields))
  result = call_579964.call(path_579965, query_579966, nil, nil, nil)

var directoryPrivilegesList* = Call_DirectoryPrivilegesList_579952(
    name: "directoryPrivilegesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roles/ALL/privileges",
    validator: validate_DirectoryPrivilegesList_579953,
    base: "/admin/directory/v1", url: url_DirectoryPrivilegesList_579954,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesUpdate_579983 = ref object of OpenApiRestCall_578364
proc url_DirectoryRolesUpdate_579985(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRolesUpdate_579984(path: JsonNode; query: JsonNode;
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
  var valid_579986 = path.getOrDefault("customer")
  valid_579986 = validateParameter(valid_579986, JString, required = true,
                                 default = nil)
  if valid_579986 != nil:
    section.add "customer", valid_579986
  var valid_579987 = path.getOrDefault("roleId")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "roleId", valid_579987
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
  var valid_579988 = query.getOrDefault("key")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "key", valid_579988
  var valid_579989 = query.getOrDefault("prettyPrint")
  valid_579989 = validateParameter(valid_579989, JBool, required = false,
                                 default = newJBool(true))
  if valid_579989 != nil:
    section.add "prettyPrint", valid_579989
  var valid_579990 = query.getOrDefault("oauth_token")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "oauth_token", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("userIp")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "userIp", valid_579992
  var valid_579993 = query.getOrDefault("quotaUser")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "quotaUser", valid_579993
  var valid_579994 = query.getOrDefault("fields")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "fields", valid_579994
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

proc call*(call_579996: Call_DirectoryRolesUpdate_579983; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role.
  ## 
  let valid = call_579996.validator(path, query, header, formData, body)
  let scheme = call_579996.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579996.url(scheme.get, call_579996.host, call_579996.base,
                         call_579996.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579996, url, valid)

proc call*(call_579997: Call_DirectoryRolesUpdate_579983; customer: string;
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
  var path_579998 = newJObject()
  var query_579999 = newJObject()
  var body_580000 = newJObject()
  add(query_579999, "key", newJString(key))
  add(query_579999, "prettyPrint", newJBool(prettyPrint))
  add(query_579999, "oauth_token", newJString(oauthToken))
  add(path_579998, "customer", newJString(customer))
  add(query_579999, "alt", newJString(alt))
  add(query_579999, "userIp", newJString(userIp))
  add(query_579999, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580000 = body
  add(query_579999, "fields", newJString(fields))
  add(path_579998, "roleId", newJString(roleId))
  result = call_579997.call(path_579998, query_579999, nil, nil, body_580000)

var directoryRolesUpdate* = Call_DirectoryRolesUpdate_579983(
    name: "directoryRolesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesUpdate_579984, base: "/admin/directory/v1",
    url: url_DirectoryRolesUpdate_579985, schemes: {Scheme.Https})
type
  Call_DirectoryRolesGet_579967 = ref object of OpenApiRestCall_578364
proc url_DirectoryRolesGet_579969(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRolesGet_579968(path: JsonNode; query: JsonNode;
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
  var valid_579970 = path.getOrDefault("customer")
  valid_579970 = validateParameter(valid_579970, JString, required = true,
                                 default = nil)
  if valid_579970 != nil:
    section.add "customer", valid_579970
  var valid_579971 = path.getOrDefault("roleId")
  valid_579971 = validateParameter(valid_579971, JString, required = true,
                                 default = nil)
  if valid_579971 != nil:
    section.add "roleId", valid_579971
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
  var valid_579972 = query.getOrDefault("key")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "key", valid_579972
  var valid_579973 = query.getOrDefault("prettyPrint")
  valid_579973 = validateParameter(valid_579973, JBool, required = false,
                                 default = newJBool(true))
  if valid_579973 != nil:
    section.add "prettyPrint", valid_579973
  var valid_579974 = query.getOrDefault("oauth_token")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "oauth_token", valid_579974
  var valid_579975 = query.getOrDefault("alt")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = newJString("json"))
  if valid_579975 != nil:
    section.add "alt", valid_579975
  var valid_579976 = query.getOrDefault("userIp")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "userIp", valid_579976
  var valid_579977 = query.getOrDefault("quotaUser")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "quotaUser", valid_579977
  var valid_579978 = query.getOrDefault("fields")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = nil)
  if valid_579978 != nil:
    section.add "fields", valid_579978
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579979: Call_DirectoryRolesGet_579967; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a role.
  ## 
  let valid = call_579979.validator(path, query, header, formData, body)
  let scheme = call_579979.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579979.url(scheme.get, call_579979.host, call_579979.base,
                         call_579979.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579979, url, valid)

proc call*(call_579980: Call_DirectoryRolesGet_579967; customer: string;
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
  var path_579981 = newJObject()
  var query_579982 = newJObject()
  add(query_579982, "key", newJString(key))
  add(query_579982, "prettyPrint", newJBool(prettyPrint))
  add(query_579982, "oauth_token", newJString(oauthToken))
  add(path_579981, "customer", newJString(customer))
  add(query_579982, "alt", newJString(alt))
  add(query_579982, "userIp", newJString(userIp))
  add(query_579982, "quotaUser", newJString(quotaUser))
  add(query_579982, "fields", newJString(fields))
  add(path_579981, "roleId", newJString(roleId))
  result = call_579980.call(path_579981, query_579982, nil, nil, nil)

var directoryRolesGet* = Call_DirectoryRolesGet_579967(name: "directoryRolesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesGet_579968, base: "/admin/directory/v1",
    url: url_DirectoryRolesGet_579969, schemes: {Scheme.Https})
type
  Call_DirectoryRolesPatch_580017 = ref object of OpenApiRestCall_578364
proc url_DirectoryRolesPatch_580019(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRolesPatch_580018(path: JsonNode; query: JsonNode;
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
  var valid_580020 = path.getOrDefault("customer")
  valid_580020 = validateParameter(valid_580020, JString, required = true,
                                 default = nil)
  if valid_580020 != nil:
    section.add "customer", valid_580020
  var valid_580021 = path.getOrDefault("roleId")
  valid_580021 = validateParameter(valid_580021, JString, required = true,
                                 default = nil)
  if valid_580021 != nil:
    section.add "roleId", valid_580021
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
  var valid_580022 = query.getOrDefault("key")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "key", valid_580022
  var valid_580023 = query.getOrDefault("prettyPrint")
  valid_580023 = validateParameter(valid_580023, JBool, required = false,
                                 default = newJBool(true))
  if valid_580023 != nil:
    section.add "prettyPrint", valid_580023
  var valid_580024 = query.getOrDefault("oauth_token")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "oauth_token", valid_580024
  var valid_580025 = query.getOrDefault("alt")
  valid_580025 = validateParameter(valid_580025, JString, required = false,
                                 default = newJString("json"))
  if valid_580025 != nil:
    section.add "alt", valid_580025
  var valid_580026 = query.getOrDefault("userIp")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "userIp", valid_580026
  var valid_580027 = query.getOrDefault("quotaUser")
  valid_580027 = validateParameter(valid_580027, JString, required = false,
                                 default = nil)
  if valid_580027 != nil:
    section.add "quotaUser", valid_580027
  var valid_580028 = query.getOrDefault("fields")
  valid_580028 = validateParameter(valid_580028, JString, required = false,
                                 default = nil)
  if valid_580028 != nil:
    section.add "fields", valid_580028
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

proc call*(call_580030: Call_DirectoryRolesPatch_580017; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role. This method supports patch semantics.
  ## 
  let valid = call_580030.validator(path, query, header, formData, body)
  let scheme = call_580030.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580030.url(scheme.get, call_580030.host, call_580030.base,
                         call_580030.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580030, url, valid)

proc call*(call_580031: Call_DirectoryRolesPatch_580017; customer: string;
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
  var path_580032 = newJObject()
  var query_580033 = newJObject()
  var body_580034 = newJObject()
  add(query_580033, "key", newJString(key))
  add(query_580033, "prettyPrint", newJBool(prettyPrint))
  add(query_580033, "oauth_token", newJString(oauthToken))
  add(path_580032, "customer", newJString(customer))
  add(query_580033, "alt", newJString(alt))
  add(query_580033, "userIp", newJString(userIp))
  add(query_580033, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580034 = body
  add(query_580033, "fields", newJString(fields))
  add(path_580032, "roleId", newJString(roleId))
  result = call_580031.call(path_580032, query_580033, nil, nil, body_580034)

var directoryRolesPatch* = Call_DirectoryRolesPatch_580017(
    name: "directoryRolesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesPatch_580018, base: "/admin/directory/v1",
    url: url_DirectoryRolesPatch_580019, schemes: {Scheme.Https})
type
  Call_DirectoryRolesDelete_580001 = ref object of OpenApiRestCall_578364
proc url_DirectoryRolesDelete_580003(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryRolesDelete_580002(path: JsonNode; query: JsonNode;
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
  var valid_580004 = path.getOrDefault("customer")
  valid_580004 = validateParameter(valid_580004, JString, required = true,
                                 default = nil)
  if valid_580004 != nil:
    section.add "customer", valid_580004
  var valid_580005 = path.getOrDefault("roleId")
  valid_580005 = validateParameter(valid_580005, JString, required = true,
                                 default = nil)
  if valid_580005 != nil:
    section.add "roleId", valid_580005
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
  var valid_580012 = query.getOrDefault("fields")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "fields", valid_580012
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580013: Call_DirectoryRolesDelete_580001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role.
  ## 
  let valid = call_580013.validator(path, query, header, formData, body)
  let scheme = call_580013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580013.url(scheme.get, call_580013.host, call_580013.base,
                         call_580013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580013, url, valid)

proc call*(call_580014: Call_DirectoryRolesDelete_580001; customer: string;
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
  var path_580015 = newJObject()
  var query_580016 = newJObject()
  add(query_580016, "key", newJString(key))
  add(query_580016, "prettyPrint", newJBool(prettyPrint))
  add(query_580016, "oauth_token", newJString(oauthToken))
  add(path_580015, "customer", newJString(customer))
  add(query_580016, "alt", newJString(alt))
  add(query_580016, "userIp", newJString(userIp))
  add(query_580016, "quotaUser", newJString(quotaUser))
  add(query_580016, "fields", newJString(fields))
  add(path_580015, "roleId", newJString(roleId))
  result = call_580014.call(path_580015, query_580016, nil, nil, nil)

var directoryRolesDelete* = Call_DirectoryRolesDelete_580001(
    name: "directoryRolesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesDelete_580002, base: "/admin/directory/v1",
    url: url_DirectoryRolesDelete_580003, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersUpdate_580050 = ref object of OpenApiRestCall_578364
proc url_DirectoryCustomersUpdate_580052(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryCustomersUpdate_580051(path: JsonNode; query: JsonNode;
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
  var valid_580053 = path.getOrDefault("customerKey")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "customerKey", valid_580053
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
  var valid_580054 = query.getOrDefault("key")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "key", valid_580054
  var valid_580055 = query.getOrDefault("prettyPrint")
  valid_580055 = validateParameter(valid_580055, JBool, required = false,
                                 default = newJBool(true))
  if valid_580055 != nil:
    section.add "prettyPrint", valid_580055
  var valid_580056 = query.getOrDefault("oauth_token")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "oauth_token", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("userIp")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "userIp", valid_580058
  var valid_580059 = query.getOrDefault("quotaUser")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "quotaUser", valid_580059
  var valid_580060 = query.getOrDefault("fields")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "fields", valid_580060
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

proc call*(call_580062: Call_DirectoryCustomersUpdate_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer.
  ## 
  let valid = call_580062.validator(path, query, header, formData, body)
  let scheme = call_580062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580062.url(scheme.get, call_580062.host, call_580062.base,
                         call_580062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580062, url, valid)

proc call*(call_580063: Call_DirectoryCustomersUpdate_580050; customerKey: string;
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
  var path_580064 = newJObject()
  var query_580065 = newJObject()
  var body_580066 = newJObject()
  add(query_580065, "key", newJString(key))
  add(query_580065, "prettyPrint", newJBool(prettyPrint))
  add(query_580065, "oauth_token", newJString(oauthToken))
  add(query_580065, "alt", newJString(alt))
  add(query_580065, "userIp", newJString(userIp))
  add(query_580065, "quotaUser", newJString(quotaUser))
  add(path_580064, "customerKey", newJString(customerKey))
  if body != nil:
    body_580066 = body
  add(query_580065, "fields", newJString(fields))
  result = call_580063.call(path_580064, query_580065, nil, nil, body_580066)

var directoryCustomersUpdate* = Call_DirectoryCustomersUpdate_580050(
    name: "directoryCustomersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersUpdate_580051,
    base: "/admin/directory/v1", url: url_DirectoryCustomersUpdate_580052,
    schemes: {Scheme.Https})
type
  Call_DirectoryCustomersGet_580035 = ref object of OpenApiRestCall_578364
proc url_DirectoryCustomersGet_580037(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryCustomersGet_580036(path: JsonNode; query: JsonNode;
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
  var valid_580038 = path.getOrDefault("customerKey")
  valid_580038 = validateParameter(valid_580038, JString, required = true,
                                 default = nil)
  if valid_580038 != nil:
    section.add "customerKey", valid_580038
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
  var valid_580039 = query.getOrDefault("key")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "key", valid_580039
  var valid_580040 = query.getOrDefault("prettyPrint")
  valid_580040 = validateParameter(valid_580040, JBool, required = false,
                                 default = newJBool(true))
  if valid_580040 != nil:
    section.add "prettyPrint", valid_580040
  var valid_580041 = query.getOrDefault("oauth_token")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "oauth_token", valid_580041
  var valid_580042 = query.getOrDefault("alt")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("json"))
  if valid_580042 != nil:
    section.add "alt", valid_580042
  var valid_580043 = query.getOrDefault("userIp")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "userIp", valid_580043
  var valid_580044 = query.getOrDefault("quotaUser")
  valid_580044 = validateParameter(valid_580044, JString, required = false,
                                 default = nil)
  if valid_580044 != nil:
    section.add "quotaUser", valid_580044
  var valid_580045 = query.getOrDefault("fields")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "fields", valid_580045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580046: Call_DirectoryCustomersGet_580035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a customer.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_DirectoryCustomersGet_580035; customerKey: string;
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
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  add(query_580049, "key", newJString(key))
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "userIp", newJString(userIp))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(path_580048, "customerKey", newJString(customerKey))
  add(query_580049, "fields", newJString(fields))
  result = call_580047.call(path_580048, query_580049, nil, nil, nil)

var directoryCustomersGet* = Call_DirectoryCustomersGet_580035(
    name: "directoryCustomersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersGet_580036, base: "/admin/directory/v1",
    url: url_DirectoryCustomersGet_580037, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersPatch_580067 = ref object of OpenApiRestCall_578364
proc url_DirectoryCustomersPatch_580069(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryCustomersPatch_580068(path: JsonNode; query: JsonNode;
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
  var valid_580070 = path.getOrDefault("customerKey")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "customerKey", valid_580070
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
  var valid_580071 = query.getOrDefault("key")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "key", valid_580071
  var valid_580072 = query.getOrDefault("prettyPrint")
  valid_580072 = validateParameter(valid_580072, JBool, required = false,
                                 default = newJBool(true))
  if valid_580072 != nil:
    section.add "prettyPrint", valid_580072
  var valid_580073 = query.getOrDefault("oauth_token")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "oauth_token", valid_580073
  var valid_580074 = query.getOrDefault("alt")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = newJString("json"))
  if valid_580074 != nil:
    section.add "alt", valid_580074
  var valid_580075 = query.getOrDefault("userIp")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "userIp", valid_580075
  var valid_580076 = query.getOrDefault("quotaUser")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "quotaUser", valid_580076
  var valid_580077 = query.getOrDefault("fields")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "fields", valid_580077
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

proc call*(call_580079: Call_DirectoryCustomersPatch_580067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer. This method supports patch semantics.
  ## 
  let valid = call_580079.validator(path, query, header, formData, body)
  let scheme = call_580079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580079.url(scheme.get, call_580079.host, call_580079.base,
                         call_580079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580079, url, valid)

proc call*(call_580080: Call_DirectoryCustomersPatch_580067; customerKey: string;
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
  var path_580081 = newJObject()
  var query_580082 = newJObject()
  var body_580083 = newJObject()
  add(query_580082, "key", newJString(key))
  add(query_580082, "prettyPrint", newJBool(prettyPrint))
  add(query_580082, "oauth_token", newJString(oauthToken))
  add(query_580082, "alt", newJString(alt))
  add(query_580082, "userIp", newJString(userIp))
  add(query_580082, "quotaUser", newJString(quotaUser))
  add(path_580081, "customerKey", newJString(customerKey))
  if body != nil:
    body_580083 = body
  add(query_580082, "fields", newJString(fields))
  result = call_580080.call(path_580081, query_580082, nil, nil, body_580083)

var directoryCustomersPatch* = Call_DirectoryCustomersPatch_580067(
    name: "directoryCustomersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersPatch_580068,
    base: "/admin/directory/v1", url: url_DirectoryCustomersPatch_580069,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsInsert_580105 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsInsert_580107(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryGroupsInsert_580106(path: JsonNode; query: JsonNode;
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
  var valid_580108 = query.getOrDefault("key")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "key", valid_580108
  var valid_580109 = query.getOrDefault("prettyPrint")
  valid_580109 = validateParameter(valid_580109, JBool, required = false,
                                 default = newJBool(true))
  if valid_580109 != nil:
    section.add "prettyPrint", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("alt")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = newJString("json"))
  if valid_580111 != nil:
    section.add "alt", valid_580111
  var valid_580112 = query.getOrDefault("userIp")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "userIp", valid_580112
  var valid_580113 = query.getOrDefault("quotaUser")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "quotaUser", valid_580113
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
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

proc call*(call_580116: Call_DirectoryGroupsInsert_580105; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Group
  ## 
  let valid = call_580116.validator(path, query, header, formData, body)
  let scheme = call_580116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580116.url(scheme.get, call_580116.host, call_580116.base,
                         call_580116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580116, url, valid)

proc call*(call_580117: Call_DirectoryGroupsInsert_580105; key: string = "";
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
  var query_580118 = newJObject()
  var body_580119 = newJObject()
  add(query_580118, "key", newJString(key))
  add(query_580118, "prettyPrint", newJBool(prettyPrint))
  add(query_580118, "oauth_token", newJString(oauthToken))
  add(query_580118, "alt", newJString(alt))
  add(query_580118, "userIp", newJString(userIp))
  add(query_580118, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580119 = body
  add(query_580118, "fields", newJString(fields))
  result = call_580117.call(nil, query_580118, nil, nil, body_580119)

var directoryGroupsInsert* = Call_DirectoryGroupsInsert_580105(
    name: "directoryGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsInsert_580106, base: "/admin/directory/v1",
    url: url_DirectoryGroupsInsert_580107, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsList_580084 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsList_580086(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryGroupsList_580085(path: JsonNode; query: JsonNode;
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
  var valid_580087 = query.getOrDefault("key")
  valid_580087 = validateParameter(valid_580087, JString, required = false,
                                 default = nil)
  if valid_580087 != nil:
    section.add "key", valid_580087
  var valid_580088 = query.getOrDefault("prettyPrint")
  valid_580088 = validateParameter(valid_580088, JBool, required = false,
                                 default = newJBool(true))
  if valid_580088 != nil:
    section.add "prettyPrint", valid_580088
  var valid_580089 = query.getOrDefault("oauth_token")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "oauth_token", valid_580089
  var valid_580090 = query.getOrDefault("domain")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "domain", valid_580090
  var valid_580091 = query.getOrDefault("alt")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("json"))
  if valid_580091 != nil:
    section.add "alt", valid_580091
  var valid_580092 = query.getOrDefault("userIp")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "userIp", valid_580092
  var valid_580093 = query.getOrDefault("quotaUser")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "quotaUser", valid_580093
  var valid_580094 = query.getOrDefault("userKey")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "userKey", valid_580094
  var valid_580095 = query.getOrDefault("orderBy")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = newJString("email"))
  if valid_580095 != nil:
    section.add "orderBy", valid_580095
  var valid_580096 = query.getOrDefault("pageToken")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "pageToken", valid_580096
  var valid_580097 = query.getOrDefault("sortOrder")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_580097 != nil:
    section.add "sortOrder", valid_580097
  var valid_580098 = query.getOrDefault("query")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "query", valid_580098
  var valid_580099 = query.getOrDefault("customer")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "customer", valid_580099
  var valid_580100 = query.getOrDefault("fields")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "fields", valid_580100
  var valid_580101 = query.getOrDefault("maxResults")
  valid_580101 = validateParameter(valid_580101, JInt, required = false,
                                 default = newJInt(200))
  if valid_580101 != nil:
    section.add "maxResults", valid_580101
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580102: Call_DirectoryGroupsList_580084; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
  ## 
  let valid = call_580102.validator(path, query, header, formData, body)
  let scheme = call_580102.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580102.url(scheme.get, call_580102.host, call_580102.base,
                         call_580102.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580102, url, valid)

proc call*(call_580103: Call_DirectoryGroupsList_580084; key: string = "";
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
  var query_580104 = newJObject()
  add(query_580104, "key", newJString(key))
  add(query_580104, "prettyPrint", newJBool(prettyPrint))
  add(query_580104, "oauth_token", newJString(oauthToken))
  add(query_580104, "domain", newJString(domain))
  add(query_580104, "alt", newJString(alt))
  add(query_580104, "userIp", newJString(userIp))
  add(query_580104, "quotaUser", newJString(quotaUser))
  add(query_580104, "userKey", newJString(userKey))
  add(query_580104, "orderBy", newJString(orderBy))
  add(query_580104, "pageToken", newJString(pageToken))
  add(query_580104, "sortOrder", newJString(sortOrder))
  add(query_580104, "query", newJString(query))
  add(query_580104, "customer", newJString(customer))
  add(query_580104, "fields", newJString(fields))
  add(query_580104, "maxResults", newJInt(maxResults))
  result = call_580103.call(nil, query_580104, nil, nil, nil)

var directoryGroupsList* = Call_DirectoryGroupsList_580084(
    name: "directoryGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsList_580085, base: "/admin/directory/v1",
    url: url_DirectoryGroupsList_580086, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsUpdate_580135 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsUpdate_580137(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryGroupsUpdate_580136(path: JsonNode; query: JsonNode;
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
  var valid_580138 = path.getOrDefault("groupKey")
  valid_580138 = validateParameter(valid_580138, JString, required = true,
                                 default = nil)
  if valid_580138 != nil:
    section.add "groupKey", valid_580138
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
  var valid_580139 = query.getOrDefault("key")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "key", valid_580139
  var valid_580140 = query.getOrDefault("prettyPrint")
  valid_580140 = validateParameter(valid_580140, JBool, required = false,
                                 default = newJBool(true))
  if valid_580140 != nil:
    section.add "prettyPrint", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("alt")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = newJString("json"))
  if valid_580142 != nil:
    section.add "alt", valid_580142
  var valid_580143 = query.getOrDefault("userIp")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "userIp", valid_580143
  var valid_580144 = query.getOrDefault("quotaUser")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "quotaUser", valid_580144
  var valid_580145 = query.getOrDefault("fields")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "fields", valid_580145
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

proc call*(call_580147: Call_DirectoryGroupsUpdate_580135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group
  ## 
  let valid = call_580147.validator(path, query, header, formData, body)
  let scheme = call_580147.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580147.url(scheme.get, call_580147.host, call_580147.base,
                         call_580147.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580147, url, valid)

proc call*(call_580148: Call_DirectoryGroupsUpdate_580135; groupKey: string;
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
  var path_580149 = newJObject()
  var query_580150 = newJObject()
  var body_580151 = newJObject()
  add(query_580150, "key", newJString(key))
  add(query_580150, "prettyPrint", newJBool(prettyPrint))
  add(query_580150, "oauth_token", newJString(oauthToken))
  add(query_580150, "alt", newJString(alt))
  add(query_580150, "userIp", newJString(userIp))
  add(query_580150, "quotaUser", newJString(quotaUser))
  add(path_580149, "groupKey", newJString(groupKey))
  if body != nil:
    body_580151 = body
  add(query_580150, "fields", newJString(fields))
  result = call_580148.call(path_580149, query_580150, nil, nil, body_580151)

var directoryGroupsUpdate* = Call_DirectoryGroupsUpdate_580135(
    name: "directoryGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsUpdate_580136, base: "/admin/directory/v1",
    url: url_DirectoryGroupsUpdate_580137, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsGet_580120 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsGet_580122(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryGroupsGet_580121(path: JsonNode; query: JsonNode;
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
  var valid_580123 = path.getOrDefault("groupKey")
  valid_580123 = validateParameter(valid_580123, JString, required = true,
                                 default = nil)
  if valid_580123 != nil:
    section.add "groupKey", valid_580123
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
  var valid_580124 = query.getOrDefault("key")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "key", valid_580124
  var valid_580125 = query.getOrDefault("prettyPrint")
  valid_580125 = validateParameter(valid_580125, JBool, required = false,
                                 default = newJBool(true))
  if valid_580125 != nil:
    section.add "prettyPrint", valid_580125
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("alt")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = newJString("json"))
  if valid_580127 != nil:
    section.add "alt", valid_580127
  var valid_580128 = query.getOrDefault("userIp")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "userIp", valid_580128
  var valid_580129 = query.getOrDefault("quotaUser")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "quotaUser", valid_580129
  var valid_580130 = query.getOrDefault("fields")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "fields", valid_580130
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580131: Call_DirectoryGroupsGet_580120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_DirectoryGroupsGet_580120; groupKey: string;
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
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  add(query_580134, "key", newJString(key))
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "userIp", newJString(userIp))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(path_580133, "groupKey", newJString(groupKey))
  add(query_580134, "fields", newJString(fields))
  result = call_580132.call(path_580133, query_580134, nil, nil, nil)

var directoryGroupsGet* = Call_DirectoryGroupsGet_580120(
    name: "directoryGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsGet_580121, base: "/admin/directory/v1",
    url: url_DirectoryGroupsGet_580122, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsPatch_580167 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsPatch_580169(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryGroupsPatch_580168(path: JsonNode; query: JsonNode;
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
  var valid_580170 = path.getOrDefault("groupKey")
  valid_580170 = validateParameter(valid_580170, JString, required = true,
                                 default = nil)
  if valid_580170 != nil:
    section.add "groupKey", valid_580170
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
  var valid_580171 = query.getOrDefault("key")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "key", valid_580171
  var valid_580172 = query.getOrDefault("prettyPrint")
  valid_580172 = validateParameter(valid_580172, JBool, required = false,
                                 default = newJBool(true))
  if valid_580172 != nil:
    section.add "prettyPrint", valid_580172
  var valid_580173 = query.getOrDefault("oauth_token")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = nil)
  if valid_580173 != nil:
    section.add "oauth_token", valid_580173
  var valid_580174 = query.getOrDefault("alt")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = newJString("json"))
  if valid_580174 != nil:
    section.add "alt", valid_580174
  var valid_580175 = query.getOrDefault("userIp")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "userIp", valid_580175
  var valid_580176 = query.getOrDefault("quotaUser")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "quotaUser", valid_580176
  var valid_580177 = query.getOrDefault("fields")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "fields", valid_580177
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

proc call*(call_580179: Call_DirectoryGroupsPatch_580167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group. This method supports patch semantics.
  ## 
  let valid = call_580179.validator(path, query, header, formData, body)
  let scheme = call_580179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580179.url(scheme.get, call_580179.host, call_580179.base,
                         call_580179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580179, url, valid)

proc call*(call_580180: Call_DirectoryGroupsPatch_580167; groupKey: string;
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
  var path_580181 = newJObject()
  var query_580182 = newJObject()
  var body_580183 = newJObject()
  add(query_580182, "key", newJString(key))
  add(query_580182, "prettyPrint", newJBool(prettyPrint))
  add(query_580182, "oauth_token", newJString(oauthToken))
  add(query_580182, "alt", newJString(alt))
  add(query_580182, "userIp", newJString(userIp))
  add(query_580182, "quotaUser", newJString(quotaUser))
  add(path_580181, "groupKey", newJString(groupKey))
  if body != nil:
    body_580183 = body
  add(query_580182, "fields", newJString(fields))
  result = call_580180.call(path_580181, query_580182, nil, nil, body_580183)

var directoryGroupsPatch* = Call_DirectoryGroupsPatch_580167(
    name: "directoryGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsPatch_580168, base: "/admin/directory/v1",
    url: url_DirectoryGroupsPatch_580169, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsDelete_580152 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsDelete_580154(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryGroupsDelete_580153(path: JsonNode; query: JsonNode;
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
  var valid_580155 = path.getOrDefault("groupKey")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "groupKey", valid_580155
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
  var valid_580156 = query.getOrDefault("key")
  valid_580156 = validateParameter(valid_580156, JString, required = false,
                                 default = nil)
  if valid_580156 != nil:
    section.add "key", valid_580156
  var valid_580157 = query.getOrDefault("prettyPrint")
  valid_580157 = validateParameter(valid_580157, JBool, required = false,
                                 default = newJBool(true))
  if valid_580157 != nil:
    section.add "prettyPrint", valid_580157
  var valid_580158 = query.getOrDefault("oauth_token")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "oauth_token", valid_580158
  var valid_580159 = query.getOrDefault("alt")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("json"))
  if valid_580159 != nil:
    section.add "alt", valid_580159
  var valid_580160 = query.getOrDefault("userIp")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "userIp", valid_580160
  var valid_580161 = query.getOrDefault("quotaUser")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "quotaUser", valid_580161
  var valid_580162 = query.getOrDefault("fields")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "fields", valid_580162
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580163: Call_DirectoryGroupsDelete_580152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group
  ## 
  let valid = call_580163.validator(path, query, header, formData, body)
  let scheme = call_580163.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580163.url(scheme.get, call_580163.host, call_580163.base,
                         call_580163.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580163, url, valid)

proc call*(call_580164: Call_DirectoryGroupsDelete_580152; groupKey: string;
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
  var path_580165 = newJObject()
  var query_580166 = newJObject()
  add(query_580166, "key", newJString(key))
  add(query_580166, "prettyPrint", newJBool(prettyPrint))
  add(query_580166, "oauth_token", newJString(oauthToken))
  add(query_580166, "alt", newJString(alt))
  add(query_580166, "userIp", newJString(userIp))
  add(query_580166, "quotaUser", newJString(quotaUser))
  add(path_580165, "groupKey", newJString(groupKey))
  add(query_580166, "fields", newJString(fields))
  result = call_580164.call(path_580165, query_580166, nil, nil, nil)

var directoryGroupsDelete* = Call_DirectoryGroupsDelete_580152(
    name: "directoryGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsDelete_580153, base: "/admin/directory/v1",
    url: url_DirectoryGroupsDelete_580154, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesInsert_580199 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsAliasesInsert_580201(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryGroupsAliasesInsert_580200(path: JsonNode; query: JsonNode;
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
  var valid_580202 = path.getOrDefault("groupKey")
  valid_580202 = validateParameter(valid_580202, JString, required = true,
                                 default = nil)
  if valid_580202 != nil:
    section.add "groupKey", valid_580202
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
  var valid_580203 = query.getOrDefault("key")
  valid_580203 = validateParameter(valid_580203, JString, required = false,
                                 default = nil)
  if valid_580203 != nil:
    section.add "key", valid_580203
  var valid_580204 = query.getOrDefault("prettyPrint")
  valid_580204 = validateParameter(valid_580204, JBool, required = false,
                                 default = newJBool(true))
  if valid_580204 != nil:
    section.add "prettyPrint", valid_580204
  var valid_580205 = query.getOrDefault("oauth_token")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "oauth_token", valid_580205
  var valid_580206 = query.getOrDefault("alt")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = newJString("json"))
  if valid_580206 != nil:
    section.add "alt", valid_580206
  var valid_580207 = query.getOrDefault("userIp")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = nil)
  if valid_580207 != nil:
    section.add "userIp", valid_580207
  var valid_580208 = query.getOrDefault("quotaUser")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "quotaUser", valid_580208
  var valid_580209 = query.getOrDefault("fields")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "fields", valid_580209
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

proc call*(call_580211: Call_DirectoryGroupsAliasesInsert_580199; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the group
  ## 
  let valid = call_580211.validator(path, query, header, formData, body)
  let scheme = call_580211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580211.url(scheme.get, call_580211.host, call_580211.base,
                         call_580211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580211, url, valid)

proc call*(call_580212: Call_DirectoryGroupsAliasesInsert_580199; groupKey: string;
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
  var path_580213 = newJObject()
  var query_580214 = newJObject()
  var body_580215 = newJObject()
  add(query_580214, "key", newJString(key))
  add(query_580214, "prettyPrint", newJBool(prettyPrint))
  add(query_580214, "oauth_token", newJString(oauthToken))
  add(query_580214, "alt", newJString(alt))
  add(query_580214, "userIp", newJString(userIp))
  add(query_580214, "quotaUser", newJString(quotaUser))
  add(path_580213, "groupKey", newJString(groupKey))
  if body != nil:
    body_580215 = body
  add(query_580214, "fields", newJString(fields))
  result = call_580212.call(path_580213, query_580214, nil, nil, body_580215)

var directoryGroupsAliasesInsert* = Call_DirectoryGroupsAliasesInsert_580199(
    name: "directoryGroupsAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesInsert_580200,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesInsert_580201,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesList_580184 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsAliasesList_580186(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryGroupsAliasesList_580185(path: JsonNode; query: JsonNode;
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
  var valid_580187 = path.getOrDefault("groupKey")
  valid_580187 = validateParameter(valid_580187, JString, required = true,
                                 default = nil)
  if valid_580187 != nil:
    section.add "groupKey", valid_580187
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
  var valid_580188 = query.getOrDefault("key")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "key", valid_580188
  var valid_580189 = query.getOrDefault("prettyPrint")
  valid_580189 = validateParameter(valid_580189, JBool, required = false,
                                 default = newJBool(true))
  if valid_580189 != nil:
    section.add "prettyPrint", valid_580189
  var valid_580190 = query.getOrDefault("oauth_token")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "oauth_token", valid_580190
  var valid_580191 = query.getOrDefault("alt")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = newJString("json"))
  if valid_580191 != nil:
    section.add "alt", valid_580191
  var valid_580192 = query.getOrDefault("userIp")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "userIp", valid_580192
  var valid_580193 = query.getOrDefault("quotaUser")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = nil)
  if valid_580193 != nil:
    section.add "quotaUser", valid_580193
  var valid_580194 = query.getOrDefault("fields")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "fields", valid_580194
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580195: Call_DirectoryGroupsAliasesList_580184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a group
  ## 
  let valid = call_580195.validator(path, query, header, formData, body)
  let scheme = call_580195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580195.url(scheme.get, call_580195.host, call_580195.base,
                         call_580195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580195, url, valid)

proc call*(call_580196: Call_DirectoryGroupsAliasesList_580184; groupKey: string;
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
  var path_580197 = newJObject()
  var query_580198 = newJObject()
  add(query_580198, "key", newJString(key))
  add(query_580198, "prettyPrint", newJBool(prettyPrint))
  add(query_580198, "oauth_token", newJString(oauthToken))
  add(query_580198, "alt", newJString(alt))
  add(query_580198, "userIp", newJString(userIp))
  add(query_580198, "quotaUser", newJString(quotaUser))
  add(path_580197, "groupKey", newJString(groupKey))
  add(query_580198, "fields", newJString(fields))
  result = call_580196.call(path_580197, query_580198, nil, nil, nil)

var directoryGroupsAliasesList* = Call_DirectoryGroupsAliasesList_580184(
    name: "directoryGroupsAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesList_580185,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesList_580186,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesDelete_580216 = ref object of OpenApiRestCall_578364
proc url_DirectoryGroupsAliasesDelete_580218(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryGroupsAliasesDelete_580217(path: JsonNode; query: JsonNode;
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
  var valid_580219 = path.getOrDefault("groupKey")
  valid_580219 = validateParameter(valid_580219, JString, required = true,
                                 default = nil)
  if valid_580219 != nil:
    section.add "groupKey", valid_580219
  var valid_580220 = path.getOrDefault("alias")
  valid_580220 = validateParameter(valid_580220, JString, required = true,
                                 default = nil)
  if valid_580220 != nil:
    section.add "alias", valid_580220
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
  var valid_580221 = query.getOrDefault("key")
  valid_580221 = validateParameter(valid_580221, JString, required = false,
                                 default = nil)
  if valid_580221 != nil:
    section.add "key", valid_580221
  var valid_580222 = query.getOrDefault("prettyPrint")
  valid_580222 = validateParameter(valid_580222, JBool, required = false,
                                 default = newJBool(true))
  if valid_580222 != nil:
    section.add "prettyPrint", valid_580222
  var valid_580223 = query.getOrDefault("oauth_token")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "oauth_token", valid_580223
  var valid_580224 = query.getOrDefault("alt")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("json"))
  if valid_580224 != nil:
    section.add "alt", valid_580224
  var valid_580225 = query.getOrDefault("userIp")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "userIp", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("fields")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "fields", valid_580227
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580228: Call_DirectoryGroupsAliasesDelete_580216; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the group
  ## 
  let valid = call_580228.validator(path, query, header, formData, body)
  let scheme = call_580228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580228.url(scheme.get, call_580228.host, call_580228.base,
                         call_580228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580228, url, valid)

proc call*(call_580229: Call_DirectoryGroupsAliasesDelete_580216; groupKey: string;
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
  var path_580230 = newJObject()
  var query_580231 = newJObject()
  add(query_580231, "key", newJString(key))
  add(query_580231, "prettyPrint", newJBool(prettyPrint))
  add(query_580231, "oauth_token", newJString(oauthToken))
  add(query_580231, "alt", newJString(alt))
  add(query_580231, "userIp", newJString(userIp))
  add(query_580231, "quotaUser", newJString(quotaUser))
  add(path_580230, "groupKey", newJString(groupKey))
  add(path_580230, "alias", newJString(alias))
  add(query_580231, "fields", newJString(fields))
  result = call_580229.call(path_580230, query_580231, nil, nil, nil)

var directoryGroupsAliasesDelete* = Call_DirectoryGroupsAliasesDelete_580216(
    name: "directoryGroupsAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases/{alias}",
    validator: validate_DirectoryGroupsAliasesDelete_580217,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesDelete_580218,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersHasMember_580232 = ref object of OpenApiRestCall_578364
proc url_DirectoryMembersHasMember_580234(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMembersHasMember_580233(path: JsonNode; query: JsonNode;
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
  var valid_580235 = path.getOrDefault("groupKey")
  valid_580235 = validateParameter(valid_580235, JString, required = true,
                                 default = nil)
  if valid_580235 != nil:
    section.add "groupKey", valid_580235
  var valid_580236 = path.getOrDefault("memberKey")
  valid_580236 = validateParameter(valid_580236, JString, required = true,
                                 default = nil)
  if valid_580236 != nil:
    section.add "memberKey", valid_580236
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
  var valid_580237 = query.getOrDefault("key")
  valid_580237 = validateParameter(valid_580237, JString, required = false,
                                 default = nil)
  if valid_580237 != nil:
    section.add "key", valid_580237
  var valid_580238 = query.getOrDefault("prettyPrint")
  valid_580238 = validateParameter(valid_580238, JBool, required = false,
                                 default = newJBool(true))
  if valid_580238 != nil:
    section.add "prettyPrint", valid_580238
  var valid_580239 = query.getOrDefault("oauth_token")
  valid_580239 = validateParameter(valid_580239, JString, required = false,
                                 default = nil)
  if valid_580239 != nil:
    section.add "oauth_token", valid_580239
  var valid_580240 = query.getOrDefault("alt")
  valid_580240 = validateParameter(valid_580240, JString, required = false,
                                 default = newJString("json"))
  if valid_580240 != nil:
    section.add "alt", valid_580240
  var valid_580241 = query.getOrDefault("userIp")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "userIp", valid_580241
  var valid_580242 = query.getOrDefault("quotaUser")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "quotaUser", valid_580242
  var valid_580243 = query.getOrDefault("fields")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "fields", valid_580243
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580244: Call_DirectoryMembersHasMember_580232; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
  ## 
  let valid = call_580244.validator(path, query, header, formData, body)
  let scheme = call_580244.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580244.url(scheme.get, call_580244.host, call_580244.base,
                         call_580244.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580244, url, valid)

proc call*(call_580245: Call_DirectoryMembersHasMember_580232; groupKey: string;
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
  var path_580246 = newJObject()
  var query_580247 = newJObject()
  add(query_580247, "key", newJString(key))
  add(query_580247, "prettyPrint", newJBool(prettyPrint))
  add(query_580247, "oauth_token", newJString(oauthToken))
  add(query_580247, "alt", newJString(alt))
  add(query_580247, "userIp", newJString(userIp))
  add(query_580247, "quotaUser", newJString(quotaUser))
  add(path_580246, "groupKey", newJString(groupKey))
  add(path_580246, "memberKey", newJString(memberKey))
  add(query_580247, "fields", newJString(fields))
  result = call_580245.call(path_580246, query_580247, nil, nil, nil)

var directoryMembersHasMember* = Call_DirectoryMembersHasMember_580232(
    name: "directoryMembersHasMember", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/hasMember/{memberKey}",
    validator: validate_DirectoryMembersHasMember_580233,
    base: "/admin/directory/v1", url: url_DirectoryMembersHasMember_580234,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersInsert_580267 = ref object of OpenApiRestCall_578364
proc url_DirectoryMembersInsert_580269(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMembersInsert_580268(path: JsonNode; query: JsonNode;
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
  var valid_580270 = path.getOrDefault("groupKey")
  valid_580270 = validateParameter(valid_580270, JString, required = true,
                                 default = nil)
  if valid_580270 != nil:
    section.add "groupKey", valid_580270
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
  var valid_580271 = query.getOrDefault("key")
  valid_580271 = validateParameter(valid_580271, JString, required = false,
                                 default = nil)
  if valid_580271 != nil:
    section.add "key", valid_580271
  var valid_580272 = query.getOrDefault("prettyPrint")
  valid_580272 = validateParameter(valid_580272, JBool, required = false,
                                 default = newJBool(true))
  if valid_580272 != nil:
    section.add "prettyPrint", valid_580272
  var valid_580273 = query.getOrDefault("oauth_token")
  valid_580273 = validateParameter(valid_580273, JString, required = false,
                                 default = nil)
  if valid_580273 != nil:
    section.add "oauth_token", valid_580273
  var valid_580274 = query.getOrDefault("alt")
  valid_580274 = validateParameter(valid_580274, JString, required = false,
                                 default = newJString("json"))
  if valid_580274 != nil:
    section.add "alt", valid_580274
  var valid_580275 = query.getOrDefault("userIp")
  valid_580275 = validateParameter(valid_580275, JString, required = false,
                                 default = nil)
  if valid_580275 != nil:
    section.add "userIp", valid_580275
  var valid_580276 = query.getOrDefault("quotaUser")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "quotaUser", valid_580276
  var valid_580277 = query.getOrDefault("fields")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "fields", valid_580277
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

proc call*(call_580279: Call_DirectoryMembersInsert_580267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add user to the specified group.
  ## 
  let valid = call_580279.validator(path, query, header, formData, body)
  let scheme = call_580279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580279.url(scheme.get, call_580279.host, call_580279.base,
                         call_580279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580279, url, valid)

proc call*(call_580280: Call_DirectoryMembersInsert_580267; groupKey: string;
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
  var path_580281 = newJObject()
  var query_580282 = newJObject()
  var body_580283 = newJObject()
  add(query_580282, "key", newJString(key))
  add(query_580282, "prettyPrint", newJBool(prettyPrint))
  add(query_580282, "oauth_token", newJString(oauthToken))
  add(query_580282, "alt", newJString(alt))
  add(query_580282, "userIp", newJString(userIp))
  add(query_580282, "quotaUser", newJString(quotaUser))
  add(path_580281, "groupKey", newJString(groupKey))
  if body != nil:
    body_580283 = body
  add(query_580282, "fields", newJString(fields))
  result = call_580280.call(path_580281, query_580282, nil, nil, body_580283)

var directoryMembersInsert* = Call_DirectoryMembersInsert_580267(
    name: "directoryMembersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersInsert_580268,
    base: "/admin/directory/v1", url: url_DirectoryMembersInsert_580269,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersList_580248 = ref object of OpenApiRestCall_578364
proc url_DirectoryMembersList_580250(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMembersList_580249(path: JsonNode; query: JsonNode;
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
  var valid_580251 = path.getOrDefault("groupKey")
  valid_580251 = validateParameter(valid_580251, JString, required = true,
                                 default = nil)
  if valid_580251 != nil:
    section.add "groupKey", valid_580251
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
  var valid_580254 = query.getOrDefault("oauth_token")
  valid_580254 = validateParameter(valid_580254, JString, required = false,
                                 default = nil)
  if valid_580254 != nil:
    section.add "oauth_token", valid_580254
  var valid_580255 = query.getOrDefault("includeDerivedMembership")
  valid_580255 = validateParameter(valid_580255, JBool, required = false, default = nil)
  if valid_580255 != nil:
    section.add "includeDerivedMembership", valid_580255
  var valid_580256 = query.getOrDefault("roles")
  valid_580256 = validateParameter(valid_580256, JString, required = false,
                                 default = nil)
  if valid_580256 != nil:
    section.add "roles", valid_580256
  var valid_580257 = query.getOrDefault("alt")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = newJString("json"))
  if valid_580257 != nil:
    section.add "alt", valid_580257
  var valid_580258 = query.getOrDefault("userIp")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "userIp", valid_580258
  var valid_580259 = query.getOrDefault("quotaUser")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "quotaUser", valid_580259
  var valid_580260 = query.getOrDefault("pageToken")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "pageToken", valid_580260
  var valid_580261 = query.getOrDefault("fields")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "fields", valid_580261
  var valid_580262 = query.getOrDefault("maxResults")
  valid_580262 = validateParameter(valid_580262, JInt, required = false,
                                 default = newJInt(200))
  if valid_580262 != nil:
    section.add "maxResults", valid_580262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580263: Call_DirectoryMembersList_580248; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all members in a group (paginated)
  ## 
  let valid = call_580263.validator(path, query, header, formData, body)
  let scheme = call_580263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580263.url(scheme.get, call_580263.host, call_580263.base,
                         call_580263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580263, url, valid)

proc call*(call_580264: Call_DirectoryMembersList_580248; groupKey: string;
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
  var path_580265 = newJObject()
  var query_580266 = newJObject()
  add(query_580266, "key", newJString(key))
  add(query_580266, "prettyPrint", newJBool(prettyPrint))
  add(query_580266, "oauth_token", newJString(oauthToken))
  add(query_580266, "includeDerivedMembership", newJBool(includeDerivedMembership))
  add(query_580266, "roles", newJString(roles))
  add(query_580266, "alt", newJString(alt))
  add(query_580266, "userIp", newJString(userIp))
  add(query_580266, "quotaUser", newJString(quotaUser))
  add(query_580266, "pageToken", newJString(pageToken))
  add(path_580265, "groupKey", newJString(groupKey))
  add(query_580266, "fields", newJString(fields))
  add(query_580266, "maxResults", newJInt(maxResults))
  result = call_580264.call(path_580265, query_580266, nil, nil, nil)

var directoryMembersList* = Call_DirectoryMembersList_580248(
    name: "directoryMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersList_580249, base: "/admin/directory/v1",
    url: url_DirectoryMembersList_580250, schemes: {Scheme.Https})
type
  Call_DirectoryMembersUpdate_580300 = ref object of OpenApiRestCall_578364
proc url_DirectoryMembersUpdate_580302(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMembersUpdate_580301(path: JsonNode; query: JsonNode;
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
  var valid_580303 = path.getOrDefault("groupKey")
  valid_580303 = validateParameter(valid_580303, JString, required = true,
                                 default = nil)
  if valid_580303 != nil:
    section.add "groupKey", valid_580303
  var valid_580304 = path.getOrDefault("memberKey")
  valid_580304 = validateParameter(valid_580304, JString, required = true,
                                 default = nil)
  if valid_580304 != nil:
    section.add "memberKey", valid_580304
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
  var valid_580305 = query.getOrDefault("key")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "key", valid_580305
  var valid_580306 = query.getOrDefault("prettyPrint")
  valid_580306 = validateParameter(valid_580306, JBool, required = false,
                                 default = newJBool(true))
  if valid_580306 != nil:
    section.add "prettyPrint", valid_580306
  var valid_580307 = query.getOrDefault("oauth_token")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "oauth_token", valid_580307
  var valid_580308 = query.getOrDefault("alt")
  valid_580308 = validateParameter(valid_580308, JString, required = false,
                                 default = newJString("json"))
  if valid_580308 != nil:
    section.add "alt", valid_580308
  var valid_580309 = query.getOrDefault("userIp")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "userIp", valid_580309
  var valid_580310 = query.getOrDefault("quotaUser")
  valid_580310 = validateParameter(valid_580310, JString, required = false,
                                 default = nil)
  if valid_580310 != nil:
    section.add "quotaUser", valid_580310
  var valid_580311 = query.getOrDefault("fields")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "fields", valid_580311
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

proc call*(call_580313: Call_DirectoryMembersUpdate_580300; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group.
  ## 
  let valid = call_580313.validator(path, query, header, formData, body)
  let scheme = call_580313.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580313.url(scheme.get, call_580313.host, call_580313.base,
                         call_580313.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580313, url, valid)

proc call*(call_580314: Call_DirectoryMembersUpdate_580300; groupKey: string;
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
  var path_580315 = newJObject()
  var query_580316 = newJObject()
  var body_580317 = newJObject()
  add(query_580316, "key", newJString(key))
  add(query_580316, "prettyPrint", newJBool(prettyPrint))
  add(query_580316, "oauth_token", newJString(oauthToken))
  add(query_580316, "alt", newJString(alt))
  add(query_580316, "userIp", newJString(userIp))
  add(query_580316, "quotaUser", newJString(quotaUser))
  add(path_580315, "groupKey", newJString(groupKey))
  if body != nil:
    body_580317 = body
  add(path_580315, "memberKey", newJString(memberKey))
  add(query_580316, "fields", newJString(fields))
  result = call_580314.call(path_580315, query_580316, nil, nil, body_580317)

var directoryMembersUpdate* = Call_DirectoryMembersUpdate_580300(
    name: "directoryMembersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersUpdate_580301,
    base: "/admin/directory/v1", url: url_DirectoryMembersUpdate_580302,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersGet_580284 = ref object of OpenApiRestCall_578364
proc url_DirectoryMembersGet_580286(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMembersGet_580285(path: JsonNode; query: JsonNode;
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
  var valid_580287 = path.getOrDefault("groupKey")
  valid_580287 = validateParameter(valid_580287, JString, required = true,
                                 default = nil)
  if valid_580287 != nil:
    section.add "groupKey", valid_580287
  var valid_580288 = path.getOrDefault("memberKey")
  valid_580288 = validateParameter(valid_580288, JString, required = true,
                                 default = nil)
  if valid_580288 != nil:
    section.add "memberKey", valid_580288
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
  var valid_580291 = query.getOrDefault("oauth_token")
  valid_580291 = validateParameter(valid_580291, JString, required = false,
                                 default = nil)
  if valid_580291 != nil:
    section.add "oauth_token", valid_580291
  var valid_580292 = query.getOrDefault("alt")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = newJString("json"))
  if valid_580292 != nil:
    section.add "alt", valid_580292
  var valid_580293 = query.getOrDefault("userIp")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "userIp", valid_580293
  var valid_580294 = query.getOrDefault("quotaUser")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = nil)
  if valid_580294 != nil:
    section.add "quotaUser", valid_580294
  var valid_580295 = query.getOrDefault("fields")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "fields", valid_580295
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580296: Call_DirectoryMembersGet_580284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group Member
  ## 
  let valid = call_580296.validator(path, query, header, formData, body)
  let scheme = call_580296.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580296.url(scheme.get, call_580296.host, call_580296.base,
                         call_580296.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580296, url, valid)

proc call*(call_580297: Call_DirectoryMembersGet_580284; groupKey: string;
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
  var path_580298 = newJObject()
  var query_580299 = newJObject()
  add(query_580299, "key", newJString(key))
  add(query_580299, "prettyPrint", newJBool(prettyPrint))
  add(query_580299, "oauth_token", newJString(oauthToken))
  add(query_580299, "alt", newJString(alt))
  add(query_580299, "userIp", newJString(userIp))
  add(query_580299, "quotaUser", newJString(quotaUser))
  add(path_580298, "groupKey", newJString(groupKey))
  add(path_580298, "memberKey", newJString(memberKey))
  add(query_580299, "fields", newJString(fields))
  result = call_580297.call(path_580298, query_580299, nil, nil, nil)

var directoryMembersGet* = Call_DirectoryMembersGet_580284(
    name: "directoryMembersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersGet_580285, base: "/admin/directory/v1",
    url: url_DirectoryMembersGet_580286, schemes: {Scheme.Https})
type
  Call_DirectoryMembersPatch_580334 = ref object of OpenApiRestCall_578364
proc url_DirectoryMembersPatch_580336(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMembersPatch_580335(path: JsonNode; query: JsonNode;
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
  var valid_580337 = path.getOrDefault("groupKey")
  valid_580337 = validateParameter(valid_580337, JString, required = true,
                                 default = nil)
  if valid_580337 != nil:
    section.add "groupKey", valid_580337
  var valid_580338 = path.getOrDefault("memberKey")
  valid_580338 = validateParameter(valid_580338, JString, required = true,
                                 default = nil)
  if valid_580338 != nil:
    section.add "memberKey", valid_580338
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
  var valid_580339 = query.getOrDefault("key")
  valid_580339 = validateParameter(valid_580339, JString, required = false,
                                 default = nil)
  if valid_580339 != nil:
    section.add "key", valid_580339
  var valid_580340 = query.getOrDefault("prettyPrint")
  valid_580340 = validateParameter(valid_580340, JBool, required = false,
                                 default = newJBool(true))
  if valid_580340 != nil:
    section.add "prettyPrint", valid_580340
  var valid_580341 = query.getOrDefault("oauth_token")
  valid_580341 = validateParameter(valid_580341, JString, required = false,
                                 default = nil)
  if valid_580341 != nil:
    section.add "oauth_token", valid_580341
  var valid_580342 = query.getOrDefault("alt")
  valid_580342 = validateParameter(valid_580342, JString, required = false,
                                 default = newJString("json"))
  if valid_580342 != nil:
    section.add "alt", valid_580342
  var valid_580343 = query.getOrDefault("userIp")
  valid_580343 = validateParameter(valid_580343, JString, required = false,
                                 default = nil)
  if valid_580343 != nil:
    section.add "userIp", valid_580343
  var valid_580344 = query.getOrDefault("quotaUser")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "quotaUser", valid_580344
  var valid_580345 = query.getOrDefault("fields")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "fields", valid_580345
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

proc call*(call_580347: Call_DirectoryMembersPatch_580334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group. This method supports patch semantics.
  ## 
  let valid = call_580347.validator(path, query, header, formData, body)
  let scheme = call_580347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580347.url(scheme.get, call_580347.host, call_580347.base,
                         call_580347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580347, url, valid)

proc call*(call_580348: Call_DirectoryMembersPatch_580334; groupKey: string;
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
  var path_580349 = newJObject()
  var query_580350 = newJObject()
  var body_580351 = newJObject()
  add(query_580350, "key", newJString(key))
  add(query_580350, "prettyPrint", newJBool(prettyPrint))
  add(query_580350, "oauth_token", newJString(oauthToken))
  add(query_580350, "alt", newJString(alt))
  add(query_580350, "userIp", newJString(userIp))
  add(query_580350, "quotaUser", newJString(quotaUser))
  add(path_580349, "groupKey", newJString(groupKey))
  if body != nil:
    body_580351 = body
  add(path_580349, "memberKey", newJString(memberKey))
  add(query_580350, "fields", newJString(fields))
  result = call_580348.call(path_580349, query_580350, nil, nil, body_580351)

var directoryMembersPatch* = Call_DirectoryMembersPatch_580334(
    name: "directoryMembersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersPatch_580335, base: "/admin/directory/v1",
    url: url_DirectoryMembersPatch_580336, schemes: {Scheme.Https})
type
  Call_DirectoryMembersDelete_580318 = ref object of OpenApiRestCall_578364
proc url_DirectoryMembersDelete_580320(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryMembersDelete_580319(path: JsonNode; query: JsonNode;
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
  var valid_580321 = path.getOrDefault("groupKey")
  valid_580321 = validateParameter(valid_580321, JString, required = true,
                                 default = nil)
  if valid_580321 != nil:
    section.add "groupKey", valid_580321
  var valid_580322 = path.getOrDefault("memberKey")
  valid_580322 = validateParameter(valid_580322, JString, required = true,
                                 default = nil)
  if valid_580322 != nil:
    section.add "memberKey", valid_580322
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
  var valid_580323 = query.getOrDefault("key")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = nil)
  if valid_580323 != nil:
    section.add "key", valid_580323
  var valid_580324 = query.getOrDefault("prettyPrint")
  valid_580324 = validateParameter(valid_580324, JBool, required = false,
                                 default = newJBool(true))
  if valid_580324 != nil:
    section.add "prettyPrint", valid_580324
  var valid_580325 = query.getOrDefault("oauth_token")
  valid_580325 = validateParameter(valid_580325, JString, required = false,
                                 default = nil)
  if valid_580325 != nil:
    section.add "oauth_token", valid_580325
  var valid_580326 = query.getOrDefault("alt")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = newJString("json"))
  if valid_580326 != nil:
    section.add "alt", valid_580326
  var valid_580327 = query.getOrDefault("userIp")
  valid_580327 = validateParameter(valid_580327, JString, required = false,
                                 default = nil)
  if valid_580327 != nil:
    section.add "userIp", valid_580327
  var valid_580328 = query.getOrDefault("quotaUser")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "quotaUser", valid_580328
  var valid_580329 = query.getOrDefault("fields")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "fields", valid_580329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580330: Call_DirectoryMembersDelete_580318; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove membership.
  ## 
  let valid = call_580330.validator(path, query, header, formData, body)
  let scheme = call_580330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580330.url(scheme.get, call_580330.host, call_580330.base,
                         call_580330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580330, url, valid)

proc call*(call_580331: Call_DirectoryMembersDelete_580318; groupKey: string;
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
  var path_580332 = newJObject()
  var query_580333 = newJObject()
  add(query_580333, "key", newJString(key))
  add(query_580333, "prettyPrint", newJBool(prettyPrint))
  add(query_580333, "oauth_token", newJString(oauthToken))
  add(query_580333, "alt", newJString(alt))
  add(query_580333, "userIp", newJString(userIp))
  add(query_580333, "quotaUser", newJString(quotaUser))
  add(path_580332, "groupKey", newJString(groupKey))
  add(path_580332, "memberKey", newJString(memberKey))
  add(query_580333, "fields", newJString(fields))
  result = call_580331.call(path_580332, query_580333, nil, nil, nil)

var directoryMembersDelete* = Call_DirectoryMembersDelete_580318(
    name: "directoryMembersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersDelete_580319,
    base: "/admin/directory/v1", url: url_DirectoryMembersDelete_580320,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsGetSettings_580352 = ref object of OpenApiRestCall_578364
proc url_DirectoryResolvedAppAccessSettingsGetSettings_580354(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsGetSettings_580353(
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
  var valid_580355 = query.getOrDefault("key")
  valid_580355 = validateParameter(valid_580355, JString, required = false,
                                 default = nil)
  if valid_580355 != nil:
    section.add "key", valid_580355
  var valid_580356 = query.getOrDefault("prettyPrint")
  valid_580356 = validateParameter(valid_580356, JBool, required = false,
                                 default = newJBool(true))
  if valid_580356 != nil:
    section.add "prettyPrint", valid_580356
  var valid_580357 = query.getOrDefault("oauth_token")
  valid_580357 = validateParameter(valid_580357, JString, required = false,
                                 default = nil)
  if valid_580357 != nil:
    section.add "oauth_token", valid_580357
  var valid_580358 = query.getOrDefault("alt")
  valid_580358 = validateParameter(valid_580358, JString, required = false,
                                 default = newJString("json"))
  if valid_580358 != nil:
    section.add "alt", valid_580358
  var valid_580359 = query.getOrDefault("userIp")
  valid_580359 = validateParameter(valid_580359, JString, required = false,
                                 default = nil)
  if valid_580359 != nil:
    section.add "userIp", valid_580359
  var valid_580360 = query.getOrDefault("quotaUser")
  valid_580360 = validateParameter(valid_580360, JString, required = false,
                                 default = nil)
  if valid_580360 != nil:
    section.add "quotaUser", valid_580360
  var valid_580361 = query.getOrDefault("fields")
  valid_580361 = validateParameter(valid_580361, JString, required = false,
                                 default = nil)
  if valid_580361 != nil:
    section.add "fields", valid_580361
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580362: Call_DirectoryResolvedAppAccessSettingsGetSettings_580352;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves resolved app access settings of the logged in user.
  ## 
  let valid = call_580362.validator(path, query, header, formData, body)
  let scheme = call_580362.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580362.url(scheme.get, call_580362.host, call_580362.base,
                         call_580362.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580362, url, valid)

proc call*(call_580363: Call_DirectoryResolvedAppAccessSettingsGetSettings_580352;
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
  var query_580364 = newJObject()
  add(query_580364, "key", newJString(key))
  add(query_580364, "prettyPrint", newJBool(prettyPrint))
  add(query_580364, "oauth_token", newJString(oauthToken))
  add(query_580364, "alt", newJString(alt))
  add(query_580364, "userIp", newJString(userIp))
  add(query_580364, "quotaUser", newJString(quotaUser))
  add(query_580364, "fields", newJString(fields))
  result = call_580363.call(nil, query_580364, nil, nil, nil)

var directoryResolvedAppAccessSettingsGetSettings* = Call_DirectoryResolvedAppAccessSettingsGetSettings_580352(
    name: "directoryResolvedAppAccessSettingsGetSettings",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/resolvedappaccesssettings",
    validator: validate_DirectoryResolvedAppAccessSettingsGetSettings_580353,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsGetSettings_580354,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsListTrustedApps_580365 = ref object of OpenApiRestCall_578364
proc url_DirectoryResolvedAppAccessSettingsListTrustedApps_580367(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsListTrustedApps_580366(
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
  var valid_580368 = query.getOrDefault("key")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "key", valid_580368
  var valid_580369 = query.getOrDefault("prettyPrint")
  valid_580369 = validateParameter(valid_580369, JBool, required = false,
                                 default = newJBool(true))
  if valid_580369 != nil:
    section.add "prettyPrint", valid_580369
  var valid_580370 = query.getOrDefault("oauth_token")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "oauth_token", valid_580370
  var valid_580371 = query.getOrDefault("alt")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = newJString("json"))
  if valid_580371 != nil:
    section.add "alt", valid_580371
  var valid_580372 = query.getOrDefault("userIp")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "userIp", valid_580372
  var valid_580373 = query.getOrDefault("quotaUser")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "quotaUser", valid_580373
  var valid_580374 = query.getOrDefault("fields")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = nil)
  if valid_580374 != nil:
    section.add "fields", valid_580374
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580375: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_580365;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of apps trusted by the admin of the logged in user.
  ## 
  let valid = call_580375.validator(path, query, header, formData, body)
  let scheme = call_580375.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580375.url(scheme.get, call_580375.host, call_580375.base,
                         call_580375.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580375, url, valid)

proc call*(call_580376: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_580365;
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
  var query_580377 = newJObject()
  add(query_580377, "key", newJString(key))
  add(query_580377, "prettyPrint", newJBool(prettyPrint))
  add(query_580377, "oauth_token", newJString(oauthToken))
  add(query_580377, "alt", newJString(alt))
  add(query_580377, "userIp", newJString(userIp))
  add(query_580377, "quotaUser", newJString(quotaUser))
  add(query_580377, "fields", newJString(fields))
  result = call_580376.call(nil, query_580377, nil, nil, nil)

var directoryResolvedAppAccessSettingsListTrustedApps* = Call_DirectoryResolvedAppAccessSettingsListTrustedApps_580365(
    name: "directoryResolvedAppAccessSettingsListTrustedApps",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/trustedapps",
    validator: validate_DirectoryResolvedAppAccessSettingsListTrustedApps_580366,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsListTrustedApps_580367,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersInsert_580403 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersInsert_580405(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersInsert_580404(path: JsonNode; query: JsonNode;
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
  var valid_580406 = query.getOrDefault("key")
  valid_580406 = validateParameter(valid_580406, JString, required = false,
                                 default = nil)
  if valid_580406 != nil:
    section.add "key", valid_580406
  var valid_580407 = query.getOrDefault("prettyPrint")
  valid_580407 = validateParameter(valid_580407, JBool, required = false,
                                 default = newJBool(true))
  if valid_580407 != nil:
    section.add "prettyPrint", valid_580407
  var valid_580408 = query.getOrDefault("oauth_token")
  valid_580408 = validateParameter(valid_580408, JString, required = false,
                                 default = nil)
  if valid_580408 != nil:
    section.add "oauth_token", valid_580408
  var valid_580409 = query.getOrDefault("alt")
  valid_580409 = validateParameter(valid_580409, JString, required = false,
                                 default = newJString("json"))
  if valid_580409 != nil:
    section.add "alt", valid_580409
  var valid_580410 = query.getOrDefault("userIp")
  valid_580410 = validateParameter(valid_580410, JString, required = false,
                                 default = nil)
  if valid_580410 != nil:
    section.add "userIp", valid_580410
  var valid_580411 = query.getOrDefault("quotaUser")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "quotaUser", valid_580411
  var valid_580412 = query.getOrDefault("fields")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "fields", valid_580412
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

proc call*(call_580414: Call_DirectoryUsersInsert_580403; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## create user.
  ## 
  let valid = call_580414.validator(path, query, header, formData, body)
  let scheme = call_580414.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580414.url(scheme.get, call_580414.host, call_580414.base,
                         call_580414.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580414, url, valid)

proc call*(call_580415: Call_DirectoryUsersInsert_580403; key: string = "";
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
  var query_580416 = newJObject()
  var body_580417 = newJObject()
  add(query_580416, "key", newJString(key))
  add(query_580416, "prettyPrint", newJBool(prettyPrint))
  add(query_580416, "oauth_token", newJString(oauthToken))
  add(query_580416, "alt", newJString(alt))
  add(query_580416, "userIp", newJString(userIp))
  add(query_580416, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580417 = body
  add(query_580416, "fields", newJString(fields))
  result = call_580415.call(nil, query_580416, nil, nil, body_580417)

var directoryUsersInsert* = Call_DirectoryUsersInsert_580403(
    name: "directoryUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersInsert_580404, base: "/admin/directory/v1",
    url: url_DirectoryUsersInsert_580405, schemes: {Scheme.Https})
type
  Call_DirectoryUsersList_580378 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersList_580380(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersList_580379(path: JsonNode; query: JsonNode;
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
  var valid_580381 = query.getOrDefault("key")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "key", valid_580381
  var valid_580382 = query.getOrDefault("prettyPrint")
  valid_580382 = validateParameter(valid_580382, JBool, required = false,
                                 default = newJBool(true))
  if valid_580382 != nil:
    section.add "prettyPrint", valid_580382
  var valid_580383 = query.getOrDefault("oauth_token")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = nil)
  if valid_580383 != nil:
    section.add "oauth_token", valid_580383
  var valid_580384 = query.getOrDefault("domain")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "domain", valid_580384
  var valid_580385 = query.getOrDefault("event")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = newJString("add"))
  if valid_580385 != nil:
    section.add "event", valid_580385
  var valid_580386 = query.getOrDefault("viewType")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_580386 != nil:
    section.add "viewType", valid_580386
  var valid_580387 = query.getOrDefault("alt")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = newJString("json"))
  if valid_580387 != nil:
    section.add "alt", valid_580387
  var valid_580388 = query.getOrDefault("userIp")
  valid_580388 = validateParameter(valid_580388, JString, required = false,
                                 default = nil)
  if valid_580388 != nil:
    section.add "userIp", valid_580388
  var valid_580389 = query.getOrDefault("quotaUser")
  valid_580389 = validateParameter(valid_580389, JString, required = false,
                                 default = nil)
  if valid_580389 != nil:
    section.add "quotaUser", valid_580389
  var valid_580390 = query.getOrDefault("orderBy")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = newJString("email"))
  if valid_580390 != nil:
    section.add "orderBy", valid_580390
  var valid_580391 = query.getOrDefault("pageToken")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "pageToken", valid_580391
  var valid_580392 = query.getOrDefault("customFieldMask")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "customFieldMask", valid_580392
  var valid_580393 = query.getOrDefault("sortOrder")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_580393 != nil:
    section.add "sortOrder", valid_580393
  var valid_580394 = query.getOrDefault("query")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "query", valid_580394
  var valid_580395 = query.getOrDefault("customer")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "customer", valid_580395
  var valid_580396 = query.getOrDefault("projection")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = newJString("basic"))
  if valid_580396 != nil:
    section.add "projection", valid_580396
  var valid_580397 = query.getOrDefault("fields")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "fields", valid_580397
  var valid_580398 = query.getOrDefault("showDeleted")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "showDeleted", valid_580398
  var valid_580399 = query.getOrDefault("maxResults")
  valid_580399 = validateParameter(valid_580399, JInt, required = false,
                                 default = newJInt(100))
  if valid_580399 != nil:
    section.add "maxResults", valid_580399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580400: Call_DirectoryUsersList_580378; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve either deleted users or all users in a domain (paginated)
  ## 
  let valid = call_580400.validator(path, query, header, formData, body)
  let scheme = call_580400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580400.url(scheme.get, call_580400.host, call_580400.base,
                         call_580400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580400, url, valid)

proc call*(call_580401: Call_DirectoryUsersList_580378; key: string = "";
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
  var query_580402 = newJObject()
  add(query_580402, "key", newJString(key))
  add(query_580402, "prettyPrint", newJBool(prettyPrint))
  add(query_580402, "oauth_token", newJString(oauthToken))
  add(query_580402, "domain", newJString(domain))
  add(query_580402, "event", newJString(event))
  add(query_580402, "viewType", newJString(viewType))
  add(query_580402, "alt", newJString(alt))
  add(query_580402, "userIp", newJString(userIp))
  add(query_580402, "quotaUser", newJString(quotaUser))
  add(query_580402, "orderBy", newJString(orderBy))
  add(query_580402, "pageToken", newJString(pageToken))
  add(query_580402, "customFieldMask", newJString(customFieldMask))
  add(query_580402, "sortOrder", newJString(sortOrder))
  add(query_580402, "query", newJString(query))
  add(query_580402, "customer", newJString(customer))
  add(query_580402, "projection", newJString(projection))
  add(query_580402, "fields", newJString(fields))
  add(query_580402, "showDeleted", newJString(showDeleted))
  add(query_580402, "maxResults", newJInt(maxResults))
  result = call_580401.call(nil, query_580402, nil, nil, nil)

var directoryUsersList* = Call_DirectoryUsersList_580378(
    name: "directoryUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersList_580379, base: "/admin/directory/v1",
    url: url_DirectoryUsersList_580380, schemes: {Scheme.Https})
type
  Call_DirectoryUsersWatch_580418 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersWatch_580420(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersWatch_580419(path: JsonNode; query: JsonNode;
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
  var valid_580421 = query.getOrDefault("key")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "key", valid_580421
  var valid_580422 = query.getOrDefault("prettyPrint")
  valid_580422 = validateParameter(valid_580422, JBool, required = false,
                                 default = newJBool(true))
  if valid_580422 != nil:
    section.add "prettyPrint", valid_580422
  var valid_580423 = query.getOrDefault("oauth_token")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "oauth_token", valid_580423
  var valid_580424 = query.getOrDefault("domain")
  valid_580424 = validateParameter(valid_580424, JString, required = false,
                                 default = nil)
  if valid_580424 != nil:
    section.add "domain", valid_580424
  var valid_580425 = query.getOrDefault("event")
  valid_580425 = validateParameter(valid_580425, JString, required = false,
                                 default = newJString("add"))
  if valid_580425 != nil:
    section.add "event", valid_580425
  var valid_580426 = query.getOrDefault("viewType")
  valid_580426 = validateParameter(valid_580426, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_580426 != nil:
    section.add "viewType", valid_580426
  var valid_580427 = query.getOrDefault("alt")
  valid_580427 = validateParameter(valid_580427, JString, required = false,
                                 default = newJString("json"))
  if valid_580427 != nil:
    section.add "alt", valid_580427
  var valid_580428 = query.getOrDefault("userIp")
  valid_580428 = validateParameter(valid_580428, JString, required = false,
                                 default = nil)
  if valid_580428 != nil:
    section.add "userIp", valid_580428
  var valid_580429 = query.getOrDefault("quotaUser")
  valid_580429 = validateParameter(valid_580429, JString, required = false,
                                 default = nil)
  if valid_580429 != nil:
    section.add "quotaUser", valid_580429
  var valid_580430 = query.getOrDefault("orderBy")
  valid_580430 = validateParameter(valid_580430, JString, required = false,
                                 default = newJString("email"))
  if valid_580430 != nil:
    section.add "orderBy", valid_580430
  var valid_580431 = query.getOrDefault("pageToken")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "pageToken", valid_580431
  var valid_580432 = query.getOrDefault("customFieldMask")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "customFieldMask", valid_580432
  var valid_580433 = query.getOrDefault("sortOrder")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_580433 != nil:
    section.add "sortOrder", valid_580433
  var valid_580434 = query.getOrDefault("query")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "query", valid_580434
  var valid_580435 = query.getOrDefault("customer")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "customer", valid_580435
  var valid_580436 = query.getOrDefault("projection")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = newJString("basic"))
  if valid_580436 != nil:
    section.add "projection", valid_580436
  var valid_580437 = query.getOrDefault("fields")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = nil)
  if valid_580437 != nil:
    section.add "fields", valid_580437
  var valid_580438 = query.getOrDefault("showDeleted")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "showDeleted", valid_580438
  var valid_580439 = query.getOrDefault("maxResults")
  valid_580439 = validateParameter(valid_580439, JInt, required = false,
                                 default = newJInt(100))
  if valid_580439 != nil:
    section.add "maxResults", valid_580439
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

proc call*(call_580441: Call_DirectoryUsersWatch_580418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in users list
  ## 
  let valid = call_580441.validator(path, query, header, formData, body)
  let scheme = call_580441.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580441.url(scheme.get, call_580441.host, call_580441.base,
                         call_580441.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580441, url, valid)

proc call*(call_580442: Call_DirectoryUsersWatch_580418; key: string = "";
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
  var query_580443 = newJObject()
  var body_580444 = newJObject()
  add(query_580443, "key", newJString(key))
  add(query_580443, "prettyPrint", newJBool(prettyPrint))
  add(query_580443, "oauth_token", newJString(oauthToken))
  add(query_580443, "domain", newJString(domain))
  add(query_580443, "event", newJString(event))
  add(query_580443, "viewType", newJString(viewType))
  add(query_580443, "alt", newJString(alt))
  add(query_580443, "userIp", newJString(userIp))
  add(query_580443, "quotaUser", newJString(quotaUser))
  add(query_580443, "orderBy", newJString(orderBy))
  add(query_580443, "pageToken", newJString(pageToken))
  add(query_580443, "customFieldMask", newJString(customFieldMask))
  add(query_580443, "sortOrder", newJString(sortOrder))
  add(query_580443, "query", newJString(query))
  add(query_580443, "customer", newJString(customer))
  if resource != nil:
    body_580444 = resource
  add(query_580443, "projection", newJString(projection))
  add(query_580443, "fields", newJString(fields))
  add(query_580443, "showDeleted", newJString(showDeleted))
  add(query_580443, "maxResults", newJInt(maxResults))
  result = call_580442.call(nil, query_580443, nil, nil, body_580444)

var directoryUsersWatch* = Call_DirectoryUsersWatch_580418(
    name: "directoryUsersWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/watch",
    validator: validate_DirectoryUsersWatch_580419, base: "/admin/directory/v1",
    url: url_DirectoryUsersWatch_580420, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUpdate_580463 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersUpdate_580465(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersUpdate_580464(path: JsonNode; query: JsonNode;
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
  var valid_580466 = path.getOrDefault("userKey")
  valid_580466 = validateParameter(valid_580466, JString, required = true,
                                 default = nil)
  if valid_580466 != nil:
    section.add "userKey", valid_580466
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
  var valid_580467 = query.getOrDefault("key")
  valid_580467 = validateParameter(valid_580467, JString, required = false,
                                 default = nil)
  if valid_580467 != nil:
    section.add "key", valid_580467
  var valid_580468 = query.getOrDefault("prettyPrint")
  valid_580468 = validateParameter(valid_580468, JBool, required = false,
                                 default = newJBool(true))
  if valid_580468 != nil:
    section.add "prettyPrint", valid_580468
  var valid_580469 = query.getOrDefault("oauth_token")
  valid_580469 = validateParameter(valid_580469, JString, required = false,
                                 default = nil)
  if valid_580469 != nil:
    section.add "oauth_token", valid_580469
  var valid_580470 = query.getOrDefault("alt")
  valid_580470 = validateParameter(valid_580470, JString, required = false,
                                 default = newJString("json"))
  if valid_580470 != nil:
    section.add "alt", valid_580470
  var valid_580471 = query.getOrDefault("userIp")
  valid_580471 = validateParameter(valid_580471, JString, required = false,
                                 default = nil)
  if valid_580471 != nil:
    section.add "userIp", valid_580471
  var valid_580472 = query.getOrDefault("quotaUser")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "quotaUser", valid_580472
  var valid_580473 = query.getOrDefault("fields")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "fields", valid_580473
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

proc call*(call_580475: Call_DirectoryUsersUpdate_580463; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user
  ## 
  let valid = call_580475.validator(path, query, header, formData, body)
  let scheme = call_580475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580475.url(scheme.get, call_580475.host, call_580475.base,
                         call_580475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580475, url, valid)

proc call*(call_580476: Call_DirectoryUsersUpdate_580463; userKey: string;
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
  var path_580477 = newJObject()
  var query_580478 = newJObject()
  var body_580479 = newJObject()
  add(query_580478, "key", newJString(key))
  add(query_580478, "prettyPrint", newJBool(prettyPrint))
  add(query_580478, "oauth_token", newJString(oauthToken))
  add(query_580478, "alt", newJString(alt))
  add(query_580478, "userIp", newJString(userIp))
  add(query_580478, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580479 = body
  add(query_580478, "fields", newJString(fields))
  add(path_580477, "userKey", newJString(userKey))
  result = call_580476.call(path_580477, query_580478, nil, nil, body_580479)

var directoryUsersUpdate* = Call_DirectoryUsersUpdate_580463(
    name: "directoryUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersUpdate_580464, base: "/admin/directory/v1",
    url: url_DirectoryUsersUpdate_580465, schemes: {Scheme.Https})
type
  Call_DirectoryUsersGet_580445 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersGet_580447(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersGet_580446(path: JsonNode; query: JsonNode;
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
  var valid_580448 = path.getOrDefault("userKey")
  valid_580448 = validateParameter(valid_580448, JString, required = true,
                                 default = nil)
  if valid_580448 != nil:
    section.add "userKey", valid_580448
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
  var valid_580452 = query.getOrDefault("viewType")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_580452 != nil:
    section.add "viewType", valid_580452
  var valid_580453 = query.getOrDefault("alt")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = newJString("json"))
  if valid_580453 != nil:
    section.add "alt", valid_580453
  var valid_580454 = query.getOrDefault("userIp")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = nil)
  if valid_580454 != nil:
    section.add "userIp", valid_580454
  var valid_580455 = query.getOrDefault("quotaUser")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "quotaUser", valid_580455
  var valid_580456 = query.getOrDefault("customFieldMask")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "customFieldMask", valid_580456
  var valid_580457 = query.getOrDefault("projection")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = newJString("basic"))
  if valid_580457 != nil:
    section.add "projection", valid_580457
  var valid_580458 = query.getOrDefault("fields")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "fields", valid_580458
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580459: Call_DirectoryUsersGet_580445; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## retrieve user
  ## 
  let valid = call_580459.validator(path, query, header, formData, body)
  let scheme = call_580459.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580459.url(scheme.get, call_580459.host, call_580459.base,
                         call_580459.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580459, url, valid)

proc call*(call_580460: Call_DirectoryUsersGet_580445; userKey: string;
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
  var path_580461 = newJObject()
  var query_580462 = newJObject()
  add(query_580462, "key", newJString(key))
  add(query_580462, "prettyPrint", newJBool(prettyPrint))
  add(query_580462, "oauth_token", newJString(oauthToken))
  add(query_580462, "viewType", newJString(viewType))
  add(query_580462, "alt", newJString(alt))
  add(query_580462, "userIp", newJString(userIp))
  add(query_580462, "quotaUser", newJString(quotaUser))
  add(query_580462, "customFieldMask", newJString(customFieldMask))
  add(query_580462, "projection", newJString(projection))
  add(query_580462, "fields", newJString(fields))
  add(path_580461, "userKey", newJString(userKey))
  result = call_580460.call(path_580461, query_580462, nil, nil, nil)

var directoryUsersGet* = Call_DirectoryUsersGet_580445(name: "directoryUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersGet_580446, base: "/admin/directory/v1",
    url: url_DirectoryUsersGet_580447, schemes: {Scheme.Https})
type
  Call_DirectoryUsersPatch_580495 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersPatch_580497(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersPatch_580496(path: JsonNode; query: JsonNode;
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
  var valid_580498 = path.getOrDefault("userKey")
  valid_580498 = validateParameter(valid_580498, JString, required = true,
                                 default = nil)
  if valid_580498 != nil:
    section.add "userKey", valid_580498
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

proc call*(call_580507: Call_DirectoryUsersPatch_580495; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user. This method supports patch semantics.
  ## 
  let valid = call_580507.validator(path, query, header, formData, body)
  let scheme = call_580507.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580507.url(scheme.get, call_580507.host, call_580507.base,
                         call_580507.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580507, url, valid)

proc call*(call_580508: Call_DirectoryUsersPatch_580495; userKey: string;
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
  var path_580509 = newJObject()
  var query_580510 = newJObject()
  var body_580511 = newJObject()
  add(query_580510, "key", newJString(key))
  add(query_580510, "prettyPrint", newJBool(prettyPrint))
  add(query_580510, "oauth_token", newJString(oauthToken))
  add(query_580510, "alt", newJString(alt))
  add(query_580510, "userIp", newJString(userIp))
  add(query_580510, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580511 = body
  add(query_580510, "fields", newJString(fields))
  add(path_580509, "userKey", newJString(userKey))
  result = call_580508.call(path_580509, query_580510, nil, nil, body_580511)

var directoryUsersPatch* = Call_DirectoryUsersPatch_580495(
    name: "directoryUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersPatch_580496, base: "/admin/directory/v1",
    url: url_DirectoryUsersPatch_580497, schemes: {Scheme.Https})
type
  Call_DirectoryUsersDelete_580480 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersDelete_580482(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersDelete_580481(path: JsonNode; query: JsonNode;
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
  var valid_580483 = path.getOrDefault("userKey")
  valid_580483 = validateParameter(valid_580483, JString, required = true,
                                 default = nil)
  if valid_580483 != nil:
    section.add "userKey", valid_580483
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
  var valid_580484 = query.getOrDefault("key")
  valid_580484 = validateParameter(valid_580484, JString, required = false,
                                 default = nil)
  if valid_580484 != nil:
    section.add "key", valid_580484
  var valid_580485 = query.getOrDefault("prettyPrint")
  valid_580485 = validateParameter(valid_580485, JBool, required = false,
                                 default = newJBool(true))
  if valid_580485 != nil:
    section.add "prettyPrint", valid_580485
  var valid_580486 = query.getOrDefault("oauth_token")
  valid_580486 = validateParameter(valid_580486, JString, required = false,
                                 default = nil)
  if valid_580486 != nil:
    section.add "oauth_token", valid_580486
  var valid_580487 = query.getOrDefault("alt")
  valid_580487 = validateParameter(valid_580487, JString, required = false,
                                 default = newJString("json"))
  if valid_580487 != nil:
    section.add "alt", valid_580487
  var valid_580488 = query.getOrDefault("userIp")
  valid_580488 = validateParameter(valid_580488, JString, required = false,
                                 default = nil)
  if valid_580488 != nil:
    section.add "userIp", valid_580488
  var valid_580489 = query.getOrDefault("quotaUser")
  valid_580489 = validateParameter(valid_580489, JString, required = false,
                                 default = nil)
  if valid_580489 != nil:
    section.add "quotaUser", valid_580489
  var valid_580490 = query.getOrDefault("fields")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "fields", valid_580490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580491: Call_DirectoryUsersDelete_580480; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user
  ## 
  let valid = call_580491.validator(path, query, header, formData, body)
  let scheme = call_580491.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580491.url(scheme.get, call_580491.host, call_580491.base,
                         call_580491.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580491, url, valid)

proc call*(call_580492: Call_DirectoryUsersDelete_580480; userKey: string;
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
  var path_580493 = newJObject()
  var query_580494 = newJObject()
  add(query_580494, "key", newJString(key))
  add(query_580494, "prettyPrint", newJBool(prettyPrint))
  add(query_580494, "oauth_token", newJString(oauthToken))
  add(query_580494, "alt", newJString(alt))
  add(query_580494, "userIp", newJString(userIp))
  add(query_580494, "quotaUser", newJString(quotaUser))
  add(query_580494, "fields", newJString(fields))
  add(path_580493, "userKey", newJString(userKey))
  result = call_580492.call(path_580493, query_580494, nil, nil, nil)

var directoryUsersDelete* = Call_DirectoryUsersDelete_580480(
    name: "directoryUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersDelete_580481, base: "/admin/directory/v1",
    url: url_DirectoryUsersDelete_580482, schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesInsert_580528 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersAliasesInsert_580530(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersAliasesInsert_580529(path: JsonNode; query: JsonNode;
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
  var valid_580531 = path.getOrDefault("userKey")
  valid_580531 = validateParameter(valid_580531, JString, required = true,
                                 default = nil)
  if valid_580531 != nil:
    section.add "userKey", valid_580531
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
  var valid_580532 = query.getOrDefault("key")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "key", valid_580532
  var valid_580533 = query.getOrDefault("prettyPrint")
  valid_580533 = validateParameter(valid_580533, JBool, required = false,
                                 default = newJBool(true))
  if valid_580533 != nil:
    section.add "prettyPrint", valid_580533
  var valid_580534 = query.getOrDefault("oauth_token")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "oauth_token", valid_580534
  var valid_580535 = query.getOrDefault("alt")
  valid_580535 = validateParameter(valid_580535, JString, required = false,
                                 default = newJString("json"))
  if valid_580535 != nil:
    section.add "alt", valid_580535
  var valid_580536 = query.getOrDefault("userIp")
  valid_580536 = validateParameter(valid_580536, JString, required = false,
                                 default = nil)
  if valid_580536 != nil:
    section.add "userIp", valid_580536
  var valid_580537 = query.getOrDefault("quotaUser")
  valid_580537 = validateParameter(valid_580537, JString, required = false,
                                 default = nil)
  if valid_580537 != nil:
    section.add "quotaUser", valid_580537
  var valid_580538 = query.getOrDefault("fields")
  valid_580538 = validateParameter(valid_580538, JString, required = false,
                                 default = nil)
  if valid_580538 != nil:
    section.add "fields", valid_580538
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

proc call*(call_580540: Call_DirectoryUsersAliasesInsert_580528; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the user
  ## 
  let valid = call_580540.validator(path, query, header, formData, body)
  let scheme = call_580540.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580540.url(scheme.get, call_580540.host, call_580540.base,
                         call_580540.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580540, url, valid)

proc call*(call_580541: Call_DirectoryUsersAliasesInsert_580528; userKey: string;
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
  var path_580542 = newJObject()
  var query_580543 = newJObject()
  var body_580544 = newJObject()
  add(query_580543, "key", newJString(key))
  add(query_580543, "prettyPrint", newJBool(prettyPrint))
  add(query_580543, "oauth_token", newJString(oauthToken))
  add(query_580543, "alt", newJString(alt))
  add(query_580543, "userIp", newJString(userIp))
  add(query_580543, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580544 = body
  add(query_580543, "fields", newJString(fields))
  add(path_580542, "userKey", newJString(userKey))
  result = call_580541.call(path_580542, query_580543, nil, nil, body_580544)

var directoryUsersAliasesInsert* = Call_DirectoryUsersAliasesInsert_580528(
    name: "directoryUsersAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesInsert_580529,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesInsert_580530,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesList_580512 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersAliasesList_580514(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersAliasesList_580513(path: JsonNode; query: JsonNode;
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
  var valid_580515 = path.getOrDefault("userKey")
  valid_580515 = validateParameter(valid_580515, JString, required = true,
                                 default = nil)
  if valid_580515 != nil:
    section.add "userKey", valid_580515
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
  var valid_580516 = query.getOrDefault("key")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "key", valid_580516
  var valid_580517 = query.getOrDefault("prettyPrint")
  valid_580517 = validateParameter(valid_580517, JBool, required = false,
                                 default = newJBool(true))
  if valid_580517 != nil:
    section.add "prettyPrint", valid_580517
  var valid_580518 = query.getOrDefault("oauth_token")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "oauth_token", valid_580518
  var valid_580519 = query.getOrDefault("event")
  valid_580519 = validateParameter(valid_580519, JString, required = false,
                                 default = newJString("add"))
  if valid_580519 != nil:
    section.add "event", valid_580519
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

proc call*(call_580524: Call_DirectoryUsersAliasesList_580512; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a user
  ## 
  let valid = call_580524.validator(path, query, header, formData, body)
  let scheme = call_580524.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580524.url(scheme.get, call_580524.host, call_580524.base,
                         call_580524.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580524, url, valid)

proc call*(call_580525: Call_DirectoryUsersAliasesList_580512; userKey: string;
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
  var path_580526 = newJObject()
  var query_580527 = newJObject()
  add(query_580527, "key", newJString(key))
  add(query_580527, "prettyPrint", newJBool(prettyPrint))
  add(query_580527, "oauth_token", newJString(oauthToken))
  add(query_580527, "event", newJString(event))
  add(query_580527, "alt", newJString(alt))
  add(query_580527, "userIp", newJString(userIp))
  add(query_580527, "quotaUser", newJString(quotaUser))
  add(query_580527, "fields", newJString(fields))
  add(path_580526, "userKey", newJString(userKey))
  result = call_580525.call(path_580526, query_580527, nil, nil, nil)

var directoryUsersAliasesList* = Call_DirectoryUsersAliasesList_580512(
    name: "directoryUsersAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesList_580513,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesList_580514,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesWatch_580545 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersAliasesWatch_580547(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersAliasesWatch_580546(path: JsonNode; query: JsonNode;
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
  var valid_580548 = path.getOrDefault("userKey")
  valid_580548 = validateParameter(valid_580548, JString, required = true,
                                 default = nil)
  if valid_580548 != nil:
    section.add "userKey", valid_580548
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
  var valid_580549 = query.getOrDefault("key")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "key", valid_580549
  var valid_580550 = query.getOrDefault("prettyPrint")
  valid_580550 = validateParameter(valid_580550, JBool, required = false,
                                 default = newJBool(true))
  if valid_580550 != nil:
    section.add "prettyPrint", valid_580550
  var valid_580551 = query.getOrDefault("oauth_token")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "oauth_token", valid_580551
  var valid_580552 = query.getOrDefault("event")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = newJString("add"))
  if valid_580552 != nil:
    section.add "event", valid_580552
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
  var valid_580556 = query.getOrDefault("fields")
  valid_580556 = validateParameter(valid_580556, JString, required = false,
                                 default = nil)
  if valid_580556 != nil:
    section.add "fields", valid_580556
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

proc call*(call_580558: Call_DirectoryUsersAliasesWatch_580545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in user aliases list
  ## 
  let valid = call_580558.validator(path, query, header, formData, body)
  let scheme = call_580558.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580558.url(scheme.get, call_580558.host, call_580558.base,
                         call_580558.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580558, url, valid)

proc call*(call_580559: Call_DirectoryUsersAliasesWatch_580545; userKey: string;
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
  var path_580560 = newJObject()
  var query_580561 = newJObject()
  var body_580562 = newJObject()
  add(query_580561, "key", newJString(key))
  add(query_580561, "prettyPrint", newJBool(prettyPrint))
  add(query_580561, "oauth_token", newJString(oauthToken))
  add(query_580561, "event", newJString(event))
  add(query_580561, "alt", newJString(alt))
  add(query_580561, "userIp", newJString(userIp))
  add(query_580561, "quotaUser", newJString(quotaUser))
  if resource != nil:
    body_580562 = resource
  add(query_580561, "fields", newJString(fields))
  add(path_580560, "userKey", newJString(userKey))
  result = call_580559.call(path_580560, query_580561, nil, nil, body_580562)

var directoryUsersAliasesWatch* = Call_DirectoryUsersAliasesWatch_580545(
    name: "directoryUsersAliasesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/watch",
    validator: validate_DirectoryUsersAliasesWatch_580546,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesWatch_580547,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesDelete_580563 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersAliasesDelete_580565(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersAliasesDelete_580564(path: JsonNode; query: JsonNode;
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
  var valid_580566 = path.getOrDefault("alias")
  valid_580566 = validateParameter(valid_580566, JString, required = true,
                                 default = nil)
  if valid_580566 != nil:
    section.add "alias", valid_580566
  var valid_580567 = path.getOrDefault("userKey")
  valid_580567 = validateParameter(valid_580567, JString, required = true,
                                 default = nil)
  if valid_580567 != nil:
    section.add "userKey", valid_580567
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
  var valid_580568 = query.getOrDefault("key")
  valid_580568 = validateParameter(valid_580568, JString, required = false,
                                 default = nil)
  if valid_580568 != nil:
    section.add "key", valid_580568
  var valid_580569 = query.getOrDefault("prettyPrint")
  valid_580569 = validateParameter(valid_580569, JBool, required = false,
                                 default = newJBool(true))
  if valid_580569 != nil:
    section.add "prettyPrint", valid_580569
  var valid_580570 = query.getOrDefault("oauth_token")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "oauth_token", valid_580570
  var valid_580571 = query.getOrDefault("alt")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = newJString("json"))
  if valid_580571 != nil:
    section.add "alt", valid_580571
  var valid_580572 = query.getOrDefault("userIp")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "userIp", valid_580572
  var valid_580573 = query.getOrDefault("quotaUser")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = nil)
  if valid_580573 != nil:
    section.add "quotaUser", valid_580573
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
  if body != nil:
    result.add "body", body

proc call*(call_580575: Call_DirectoryUsersAliasesDelete_580563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the user
  ## 
  let valid = call_580575.validator(path, query, header, formData, body)
  let scheme = call_580575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580575.url(scheme.get, call_580575.host, call_580575.base,
                         call_580575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580575, url, valid)

proc call*(call_580576: Call_DirectoryUsersAliasesDelete_580563; alias: string;
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
  var path_580577 = newJObject()
  var query_580578 = newJObject()
  add(query_580578, "key", newJString(key))
  add(query_580578, "prettyPrint", newJBool(prettyPrint))
  add(query_580578, "oauth_token", newJString(oauthToken))
  add(query_580578, "alt", newJString(alt))
  add(query_580578, "userIp", newJString(userIp))
  add(query_580578, "quotaUser", newJString(quotaUser))
  add(path_580577, "alias", newJString(alias))
  add(query_580578, "fields", newJString(fields))
  add(path_580577, "userKey", newJString(userKey))
  result = call_580576.call(path_580577, query_580578, nil, nil, nil)

var directoryUsersAliasesDelete* = Call_DirectoryUsersAliasesDelete_580563(
    name: "directoryUsersAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/{alias}",
    validator: validate_DirectoryUsersAliasesDelete_580564,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesDelete_580565,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsList_580579 = ref object of OpenApiRestCall_578364
proc url_DirectoryAspsList_580581(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryAspsList_580580(path: JsonNode; query: JsonNode;
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
  var valid_580582 = path.getOrDefault("userKey")
  valid_580582 = validateParameter(valid_580582, JString, required = true,
                                 default = nil)
  if valid_580582 != nil:
    section.add "userKey", valid_580582
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
  var valid_580583 = query.getOrDefault("key")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "key", valid_580583
  var valid_580584 = query.getOrDefault("prettyPrint")
  valid_580584 = validateParameter(valid_580584, JBool, required = false,
                                 default = newJBool(true))
  if valid_580584 != nil:
    section.add "prettyPrint", valid_580584
  var valid_580585 = query.getOrDefault("oauth_token")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "oauth_token", valid_580585
  var valid_580586 = query.getOrDefault("alt")
  valid_580586 = validateParameter(valid_580586, JString, required = false,
                                 default = newJString("json"))
  if valid_580586 != nil:
    section.add "alt", valid_580586
  var valid_580587 = query.getOrDefault("userIp")
  valid_580587 = validateParameter(valid_580587, JString, required = false,
                                 default = nil)
  if valid_580587 != nil:
    section.add "userIp", valid_580587
  var valid_580588 = query.getOrDefault("quotaUser")
  valid_580588 = validateParameter(valid_580588, JString, required = false,
                                 default = nil)
  if valid_580588 != nil:
    section.add "quotaUser", valid_580588
  var valid_580589 = query.getOrDefault("fields")
  valid_580589 = validateParameter(valid_580589, JString, required = false,
                                 default = nil)
  if valid_580589 != nil:
    section.add "fields", valid_580589
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580590: Call_DirectoryAspsList_580579; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the ASPs issued by a user.
  ## 
  let valid = call_580590.validator(path, query, header, formData, body)
  let scheme = call_580590.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580590.url(scheme.get, call_580590.host, call_580590.base,
                         call_580590.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580590, url, valid)

proc call*(call_580591: Call_DirectoryAspsList_580579; userKey: string;
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
  var path_580592 = newJObject()
  var query_580593 = newJObject()
  add(query_580593, "key", newJString(key))
  add(query_580593, "prettyPrint", newJBool(prettyPrint))
  add(query_580593, "oauth_token", newJString(oauthToken))
  add(query_580593, "alt", newJString(alt))
  add(query_580593, "userIp", newJString(userIp))
  add(query_580593, "quotaUser", newJString(quotaUser))
  add(query_580593, "fields", newJString(fields))
  add(path_580592, "userKey", newJString(userKey))
  result = call_580591.call(path_580592, query_580593, nil, nil, nil)

var directoryAspsList* = Call_DirectoryAspsList_580579(name: "directoryAspsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps", validator: validate_DirectoryAspsList_580580,
    base: "/admin/directory/v1", url: url_DirectoryAspsList_580581,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsGet_580594 = ref object of OpenApiRestCall_578364
proc url_DirectoryAspsGet_580596(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryAspsGet_580595(path: JsonNode; query: JsonNode;
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
  var valid_580597 = path.getOrDefault("codeId")
  valid_580597 = validateParameter(valid_580597, JInt, required = true, default = nil)
  if valid_580597 != nil:
    section.add "codeId", valid_580597
  var valid_580598 = path.getOrDefault("userKey")
  valid_580598 = validateParameter(valid_580598, JString, required = true,
                                 default = nil)
  if valid_580598 != nil:
    section.add "userKey", valid_580598
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
  var valid_580599 = query.getOrDefault("key")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "key", valid_580599
  var valid_580600 = query.getOrDefault("prettyPrint")
  valid_580600 = validateParameter(valid_580600, JBool, required = false,
                                 default = newJBool(true))
  if valid_580600 != nil:
    section.add "prettyPrint", valid_580600
  var valid_580601 = query.getOrDefault("oauth_token")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "oauth_token", valid_580601
  var valid_580602 = query.getOrDefault("alt")
  valid_580602 = validateParameter(valid_580602, JString, required = false,
                                 default = newJString("json"))
  if valid_580602 != nil:
    section.add "alt", valid_580602
  var valid_580603 = query.getOrDefault("userIp")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "userIp", valid_580603
  var valid_580604 = query.getOrDefault("quotaUser")
  valid_580604 = validateParameter(valid_580604, JString, required = false,
                                 default = nil)
  if valid_580604 != nil:
    section.add "quotaUser", valid_580604
  var valid_580605 = query.getOrDefault("fields")
  valid_580605 = validateParameter(valid_580605, JString, required = false,
                                 default = nil)
  if valid_580605 != nil:
    section.add "fields", valid_580605
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580606: Call_DirectoryAspsGet_580594; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an ASP issued by a user.
  ## 
  let valid = call_580606.validator(path, query, header, formData, body)
  let scheme = call_580606.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580606.url(scheme.get, call_580606.host, call_580606.base,
                         call_580606.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580606, url, valid)

proc call*(call_580607: Call_DirectoryAspsGet_580594; codeId: int; userKey: string;
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
  var path_580608 = newJObject()
  var query_580609 = newJObject()
  add(query_580609, "key", newJString(key))
  add(query_580609, "prettyPrint", newJBool(prettyPrint))
  add(query_580609, "oauth_token", newJString(oauthToken))
  add(path_580608, "codeId", newJInt(codeId))
  add(query_580609, "alt", newJString(alt))
  add(query_580609, "userIp", newJString(userIp))
  add(query_580609, "quotaUser", newJString(quotaUser))
  add(query_580609, "fields", newJString(fields))
  add(path_580608, "userKey", newJString(userKey))
  result = call_580607.call(path_580608, query_580609, nil, nil, nil)

var directoryAspsGet* = Call_DirectoryAspsGet_580594(name: "directoryAspsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps/{codeId}", validator: validate_DirectoryAspsGet_580595,
    base: "/admin/directory/v1", url: url_DirectoryAspsGet_580596,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsDelete_580610 = ref object of OpenApiRestCall_578364
proc url_DirectoryAspsDelete_580612(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryAspsDelete_580611(path: JsonNode; query: JsonNode;
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
  var valid_580613 = path.getOrDefault("codeId")
  valid_580613 = validateParameter(valid_580613, JInt, required = true, default = nil)
  if valid_580613 != nil:
    section.add "codeId", valid_580613
  var valid_580614 = path.getOrDefault("userKey")
  valid_580614 = validateParameter(valid_580614, JString, required = true,
                                 default = nil)
  if valid_580614 != nil:
    section.add "userKey", valid_580614
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
  var valid_580615 = query.getOrDefault("key")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = nil)
  if valid_580615 != nil:
    section.add "key", valid_580615
  var valid_580616 = query.getOrDefault("prettyPrint")
  valid_580616 = validateParameter(valid_580616, JBool, required = false,
                                 default = newJBool(true))
  if valid_580616 != nil:
    section.add "prettyPrint", valid_580616
  var valid_580617 = query.getOrDefault("oauth_token")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "oauth_token", valid_580617
  var valid_580618 = query.getOrDefault("alt")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = newJString("json"))
  if valid_580618 != nil:
    section.add "alt", valid_580618
  var valid_580619 = query.getOrDefault("userIp")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "userIp", valid_580619
  var valid_580620 = query.getOrDefault("quotaUser")
  valid_580620 = validateParameter(valid_580620, JString, required = false,
                                 default = nil)
  if valid_580620 != nil:
    section.add "quotaUser", valid_580620
  var valid_580621 = query.getOrDefault("fields")
  valid_580621 = validateParameter(valid_580621, JString, required = false,
                                 default = nil)
  if valid_580621 != nil:
    section.add "fields", valid_580621
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580622: Call_DirectoryAspsDelete_580610; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an ASP issued by a user.
  ## 
  let valid = call_580622.validator(path, query, header, formData, body)
  let scheme = call_580622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580622.url(scheme.get, call_580622.host, call_580622.base,
                         call_580622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580622, url, valid)

proc call*(call_580623: Call_DirectoryAspsDelete_580610; codeId: int;
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
  var path_580624 = newJObject()
  var query_580625 = newJObject()
  add(query_580625, "key", newJString(key))
  add(query_580625, "prettyPrint", newJBool(prettyPrint))
  add(query_580625, "oauth_token", newJString(oauthToken))
  add(path_580624, "codeId", newJInt(codeId))
  add(query_580625, "alt", newJString(alt))
  add(query_580625, "userIp", newJString(userIp))
  add(query_580625, "quotaUser", newJString(quotaUser))
  add(query_580625, "fields", newJString(fields))
  add(path_580624, "userKey", newJString(userKey))
  result = call_580623.call(path_580624, query_580625, nil, nil, nil)

var directoryAspsDelete* = Call_DirectoryAspsDelete_580610(
    name: "directoryAspsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/asps/{codeId}",
    validator: validate_DirectoryAspsDelete_580611, base: "/admin/directory/v1",
    url: url_DirectoryAspsDelete_580612, schemes: {Scheme.Https})
type
  Call_DirectoryUsersMakeAdmin_580626 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersMakeAdmin_580628(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersMakeAdmin_580627(path: JsonNode; query: JsonNode;
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
  var valid_580629 = path.getOrDefault("userKey")
  valid_580629 = validateParameter(valid_580629, JString, required = true,
                                 default = nil)
  if valid_580629 != nil:
    section.add "userKey", valid_580629
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
  var valid_580630 = query.getOrDefault("key")
  valid_580630 = validateParameter(valid_580630, JString, required = false,
                                 default = nil)
  if valid_580630 != nil:
    section.add "key", valid_580630
  var valid_580631 = query.getOrDefault("prettyPrint")
  valid_580631 = validateParameter(valid_580631, JBool, required = false,
                                 default = newJBool(true))
  if valid_580631 != nil:
    section.add "prettyPrint", valid_580631
  var valid_580632 = query.getOrDefault("oauth_token")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "oauth_token", valid_580632
  var valid_580633 = query.getOrDefault("alt")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = newJString("json"))
  if valid_580633 != nil:
    section.add "alt", valid_580633
  var valid_580634 = query.getOrDefault("userIp")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = nil)
  if valid_580634 != nil:
    section.add "userIp", valid_580634
  var valid_580635 = query.getOrDefault("quotaUser")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "quotaUser", valid_580635
  var valid_580636 = query.getOrDefault("fields")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "fields", valid_580636
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

proc call*(call_580638: Call_DirectoryUsersMakeAdmin_580626; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## change admin status of a user
  ## 
  let valid = call_580638.validator(path, query, header, formData, body)
  let scheme = call_580638.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580638.url(scheme.get, call_580638.host, call_580638.base,
                         call_580638.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580638, url, valid)

proc call*(call_580639: Call_DirectoryUsersMakeAdmin_580626; userKey: string;
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
  var path_580640 = newJObject()
  var query_580641 = newJObject()
  var body_580642 = newJObject()
  add(query_580641, "key", newJString(key))
  add(query_580641, "prettyPrint", newJBool(prettyPrint))
  add(query_580641, "oauth_token", newJString(oauthToken))
  add(query_580641, "alt", newJString(alt))
  add(query_580641, "userIp", newJString(userIp))
  add(query_580641, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580642 = body
  add(query_580641, "fields", newJString(fields))
  add(path_580640, "userKey", newJString(userKey))
  result = call_580639.call(path_580640, query_580641, nil, nil, body_580642)

var directoryUsersMakeAdmin* = Call_DirectoryUsersMakeAdmin_580626(
    name: "directoryUsersMakeAdmin", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/makeAdmin",
    validator: validate_DirectoryUsersMakeAdmin_580627,
    base: "/admin/directory/v1", url: url_DirectoryUsersMakeAdmin_580628,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosUpdate_580658 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersPhotosUpdate_580660(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersPhotosUpdate_580659(path: JsonNode; query: JsonNode;
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
  var valid_580661 = path.getOrDefault("userKey")
  valid_580661 = validateParameter(valid_580661, JString, required = true,
                                 default = nil)
  if valid_580661 != nil:
    section.add "userKey", valid_580661
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
  var valid_580662 = query.getOrDefault("key")
  valid_580662 = validateParameter(valid_580662, JString, required = false,
                                 default = nil)
  if valid_580662 != nil:
    section.add "key", valid_580662
  var valid_580663 = query.getOrDefault("prettyPrint")
  valid_580663 = validateParameter(valid_580663, JBool, required = false,
                                 default = newJBool(true))
  if valid_580663 != nil:
    section.add "prettyPrint", valid_580663
  var valid_580664 = query.getOrDefault("oauth_token")
  valid_580664 = validateParameter(valid_580664, JString, required = false,
                                 default = nil)
  if valid_580664 != nil:
    section.add "oauth_token", valid_580664
  var valid_580665 = query.getOrDefault("alt")
  valid_580665 = validateParameter(valid_580665, JString, required = false,
                                 default = newJString("json"))
  if valid_580665 != nil:
    section.add "alt", valid_580665
  var valid_580666 = query.getOrDefault("userIp")
  valid_580666 = validateParameter(valid_580666, JString, required = false,
                                 default = nil)
  if valid_580666 != nil:
    section.add "userIp", valid_580666
  var valid_580667 = query.getOrDefault("quotaUser")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "quotaUser", valid_580667
  var valid_580668 = query.getOrDefault("fields")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "fields", valid_580668
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

proc call*(call_580670: Call_DirectoryUsersPhotosUpdate_580658; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user
  ## 
  let valid = call_580670.validator(path, query, header, formData, body)
  let scheme = call_580670.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580670.url(scheme.get, call_580670.host, call_580670.base,
                         call_580670.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580670, url, valid)

proc call*(call_580671: Call_DirectoryUsersPhotosUpdate_580658; userKey: string;
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
  var path_580672 = newJObject()
  var query_580673 = newJObject()
  var body_580674 = newJObject()
  add(query_580673, "key", newJString(key))
  add(query_580673, "prettyPrint", newJBool(prettyPrint))
  add(query_580673, "oauth_token", newJString(oauthToken))
  add(query_580673, "alt", newJString(alt))
  add(query_580673, "userIp", newJString(userIp))
  add(query_580673, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580674 = body
  add(query_580673, "fields", newJString(fields))
  add(path_580672, "userKey", newJString(userKey))
  result = call_580671.call(path_580672, query_580673, nil, nil, body_580674)

var directoryUsersPhotosUpdate* = Call_DirectoryUsersPhotosUpdate_580658(
    name: "directoryUsersPhotosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosUpdate_580659,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosUpdate_580660,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosGet_580643 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersPhotosGet_580645(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersPhotosGet_580644(path: JsonNode; query: JsonNode;
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
  var valid_580646 = path.getOrDefault("userKey")
  valid_580646 = validateParameter(valid_580646, JString, required = true,
                                 default = nil)
  if valid_580646 != nil:
    section.add "userKey", valid_580646
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
  var valid_580647 = query.getOrDefault("key")
  valid_580647 = validateParameter(valid_580647, JString, required = false,
                                 default = nil)
  if valid_580647 != nil:
    section.add "key", valid_580647
  var valid_580648 = query.getOrDefault("prettyPrint")
  valid_580648 = validateParameter(valid_580648, JBool, required = false,
                                 default = newJBool(true))
  if valid_580648 != nil:
    section.add "prettyPrint", valid_580648
  var valid_580649 = query.getOrDefault("oauth_token")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "oauth_token", valid_580649
  var valid_580650 = query.getOrDefault("alt")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = newJString("json"))
  if valid_580650 != nil:
    section.add "alt", valid_580650
  var valid_580651 = query.getOrDefault("userIp")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = nil)
  if valid_580651 != nil:
    section.add "userIp", valid_580651
  var valid_580652 = query.getOrDefault("quotaUser")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "quotaUser", valid_580652
  var valid_580653 = query.getOrDefault("fields")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "fields", valid_580653
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580654: Call_DirectoryUsersPhotosGet_580643; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve photo of a user
  ## 
  let valid = call_580654.validator(path, query, header, formData, body)
  let scheme = call_580654.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580654.url(scheme.get, call_580654.host, call_580654.base,
                         call_580654.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580654, url, valid)

proc call*(call_580655: Call_DirectoryUsersPhotosGet_580643; userKey: string;
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
  var path_580656 = newJObject()
  var query_580657 = newJObject()
  add(query_580657, "key", newJString(key))
  add(query_580657, "prettyPrint", newJBool(prettyPrint))
  add(query_580657, "oauth_token", newJString(oauthToken))
  add(query_580657, "alt", newJString(alt))
  add(query_580657, "userIp", newJString(userIp))
  add(query_580657, "quotaUser", newJString(quotaUser))
  add(query_580657, "fields", newJString(fields))
  add(path_580656, "userKey", newJString(userKey))
  result = call_580655.call(path_580656, query_580657, nil, nil, nil)

var directoryUsersPhotosGet* = Call_DirectoryUsersPhotosGet_580643(
    name: "directoryUsersPhotosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosGet_580644,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosGet_580645,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosPatch_580690 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersPhotosPatch_580692(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersPhotosPatch_580691(path: JsonNode; query: JsonNode;
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
  var valid_580693 = path.getOrDefault("userKey")
  valid_580693 = validateParameter(valid_580693, JString, required = true,
                                 default = nil)
  if valid_580693 != nil:
    section.add "userKey", valid_580693
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
  var valid_580694 = query.getOrDefault("key")
  valid_580694 = validateParameter(valid_580694, JString, required = false,
                                 default = nil)
  if valid_580694 != nil:
    section.add "key", valid_580694
  var valid_580695 = query.getOrDefault("prettyPrint")
  valid_580695 = validateParameter(valid_580695, JBool, required = false,
                                 default = newJBool(true))
  if valid_580695 != nil:
    section.add "prettyPrint", valid_580695
  var valid_580696 = query.getOrDefault("oauth_token")
  valid_580696 = validateParameter(valid_580696, JString, required = false,
                                 default = nil)
  if valid_580696 != nil:
    section.add "oauth_token", valid_580696
  var valid_580697 = query.getOrDefault("alt")
  valid_580697 = validateParameter(valid_580697, JString, required = false,
                                 default = newJString("json"))
  if valid_580697 != nil:
    section.add "alt", valid_580697
  var valid_580698 = query.getOrDefault("userIp")
  valid_580698 = validateParameter(valid_580698, JString, required = false,
                                 default = nil)
  if valid_580698 != nil:
    section.add "userIp", valid_580698
  var valid_580699 = query.getOrDefault("quotaUser")
  valid_580699 = validateParameter(valid_580699, JString, required = false,
                                 default = nil)
  if valid_580699 != nil:
    section.add "quotaUser", valid_580699
  var valid_580700 = query.getOrDefault("fields")
  valid_580700 = validateParameter(valid_580700, JString, required = false,
                                 default = nil)
  if valid_580700 != nil:
    section.add "fields", valid_580700
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

proc call*(call_580702: Call_DirectoryUsersPhotosPatch_580690; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user. This method supports patch semantics.
  ## 
  let valid = call_580702.validator(path, query, header, formData, body)
  let scheme = call_580702.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580702.url(scheme.get, call_580702.host, call_580702.base,
                         call_580702.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580702, url, valid)

proc call*(call_580703: Call_DirectoryUsersPhotosPatch_580690; userKey: string;
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
  var path_580704 = newJObject()
  var query_580705 = newJObject()
  var body_580706 = newJObject()
  add(query_580705, "key", newJString(key))
  add(query_580705, "prettyPrint", newJBool(prettyPrint))
  add(query_580705, "oauth_token", newJString(oauthToken))
  add(query_580705, "alt", newJString(alt))
  add(query_580705, "userIp", newJString(userIp))
  add(query_580705, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580706 = body
  add(query_580705, "fields", newJString(fields))
  add(path_580704, "userKey", newJString(userKey))
  result = call_580703.call(path_580704, query_580705, nil, nil, body_580706)

var directoryUsersPhotosPatch* = Call_DirectoryUsersPhotosPatch_580690(
    name: "directoryUsersPhotosPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosPatch_580691,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosPatch_580692,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosDelete_580675 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersPhotosDelete_580677(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersPhotosDelete_580676(path: JsonNode; query: JsonNode;
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
  var valid_580678 = path.getOrDefault("userKey")
  valid_580678 = validateParameter(valid_580678, JString, required = true,
                                 default = nil)
  if valid_580678 != nil:
    section.add "userKey", valid_580678
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
  var valid_580679 = query.getOrDefault("key")
  valid_580679 = validateParameter(valid_580679, JString, required = false,
                                 default = nil)
  if valid_580679 != nil:
    section.add "key", valid_580679
  var valid_580680 = query.getOrDefault("prettyPrint")
  valid_580680 = validateParameter(valid_580680, JBool, required = false,
                                 default = newJBool(true))
  if valid_580680 != nil:
    section.add "prettyPrint", valid_580680
  var valid_580681 = query.getOrDefault("oauth_token")
  valid_580681 = validateParameter(valid_580681, JString, required = false,
                                 default = nil)
  if valid_580681 != nil:
    section.add "oauth_token", valid_580681
  var valid_580682 = query.getOrDefault("alt")
  valid_580682 = validateParameter(valid_580682, JString, required = false,
                                 default = newJString("json"))
  if valid_580682 != nil:
    section.add "alt", valid_580682
  var valid_580683 = query.getOrDefault("userIp")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "userIp", valid_580683
  var valid_580684 = query.getOrDefault("quotaUser")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "quotaUser", valid_580684
  var valid_580685 = query.getOrDefault("fields")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = nil)
  if valid_580685 != nil:
    section.add "fields", valid_580685
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580686: Call_DirectoryUsersPhotosDelete_580675; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove photos for the user
  ## 
  let valid = call_580686.validator(path, query, header, formData, body)
  let scheme = call_580686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580686.url(scheme.get, call_580686.host, call_580686.base,
                         call_580686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580686, url, valid)

proc call*(call_580687: Call_DirectoryUsersPhotosDelete_580675; userKey: string;
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
  var path_580688 = newJObject()
  var query_580689 = newJObject()
  add(query_580689, "key", newJString(key))
  add(query_580689, "prettyPrint", newJBool(prettyPrint))
  add(query_580689, "oauth_token", newJString(oauthToken))
  add(query_580689, "alt", newJString(alt))
  add(query_580689, "userIp", newJString(userIp))
  add(query_580689, "quotaUser", newJString(quotaUser))
  add(query_580689, "fields", newJString(fields))
  add(path_580688, "userKey", newJString(userKey))
  result = call_580687.call(path_580688, query_580689, nil, nil, nil)

var directoryUsersPhotosDelete* = Call_DirectoryUsersPhotosDelete_580675(
    name: "directoryUsersPhotosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosDelete_580676,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosDelete_580677,
    schemes: {Scheme.Https})
type
  Call_DirectoryTokensList_580707 = ref object of OpenApiRestCall_578364
proc url_DirectoryTokensList_580709(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryTokensList_580708(path: JsonNode; query: JsonNode;
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
  var valid_580710 = path.getOrDefault("userKey")
  valid_580710 = validateParameter(valid_580710, JString, required = true,
                                 default = nil)
  if valid_580710 != nil:
    section.add "userKey", valid_580710
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
  var valid_580711 = query.getOrDefault("key")
  valid_580711 = validateParameter(valid_580711, JString, required = false,
                                 default = nil)
  if valid_580711 != nil:
    section.add "key", valid_580711
  var valid_580712 = query.getOrDefault("prettyPrint")
  valid_580712 = validateParameter(valid_580712, JBool, required = false,
                                 default = newJBool(true))
  if valid_580712 != nil:
    section.add "prettyPrint", valid_580712
  var valid_580713 = query.getOrDefault("oauth_token")
  valid_580713 = validateParameter(valid_580713, JString, required = false,
                                 default = nil)
  if valid_580713 != nil:
    section.add "oauth_token", valid_580713
  var valid_580714 = query.getOrDefault("alt")
  valid_580714 = validateParameter(valid_580714, JString, required = false,
                                 default = newJString("json"))
  if valid_580714 != nil:
    section.add "alt", valid_580714
  var valid_580715 = query.getOrDefault("userIp")
  valid_580715 = validateParameter(valid_580715, JString, required = false,
                                 default = nil)
  if valid_580715 != nil:
    section.add "userIp", valid_580715
  var valid_580716 = query.getOrDefault("quotaUser")
  valid_580716 = validateParameter(valid_580716, JString, required = false,
                                 default = nil)
  if valid_580716 != nil:
    section.add "quotaUser", valid_580716
  var valid_580717 = query.getOrDefault("fields")
  valid_580717 = validateParameter(valid_580717, JString, required = false,
                                 default = nil)
  if valid_580717 != nil:
    section.add "fields", valid_580717
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580718: Call_DirectoryTokensList_580707; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the set of tokens specified user has issued to 3rd party applications.
  ## 
  let valid = call_580718.validator(path, query, header, formData, body)
  let scheme = call_580718.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580718.url(scheme.get, call_580718.host, call_580718.base,
                         call_580718.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580718, url, valid)

proc call*(call_580719: Call_DirectoryTokensList_580707; userKey: string;
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
  var path_580720 = newJObject()
  var query_580721 = newJObject()
  add(query_580721, "key", newJString(key))
  add(query_580721, "prettyPrint", newJBool(prettyPrint))
  add(query_580721, "oauth_token", newJString(oauthToken))
  add(query_580721, "alt", newJString(alt))
  add(query_580721, "userIp", newJString(userIp))
  add(query_580721, "quotaUser", newJString(quotaUser))
  add(query_580721, "fields", newJString(fields))
  add(path_580720, "userKey", newJString(userKey))
  result = call_580719.call(path_580720, query_580721, nil, nil, nil)

var directoryTokensList* = Call_DirectoryTokensList_580707(
    name: "directoryTokensList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens",
    validator: validate_DirectoryTokensList_580708, base: "/admin/directory/v1",
    url: url_DirectoryTokensList_580709, schemes: {Scheme.Https})
type
  Call_DirectoryTokensGet_580722 = ref object of OpenApiRestCall_578364
proc url_DirectoryTokensGet_580724(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryTokensGet_580723(path: JsonNode; query: JsonNode;
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
  var valid_580725 = path.getOrDefault("clientId")
  valid_580725 = validateParameter(valid_580725, JString, required = true,
                                 default = nil)
  if valid_580725 != nil:
    section.add "clientId", valid_580725
  var valid_580726 = path.getOrDefault("userKey")
  valid_580726 = validateParameter(valid_580726, JString, required = true,
                                 default = nil)
  if valid_580726 != nil:
    section.add "userKey", valid_580726
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
  var valid_580727 = query.getOrDefault("key")
  valid_580727 = validateParameter(valid_580727, JString, required = false,
                                 default = nil)
  if valid_580727 != nil:
    section.add "key", valid_580727
  var valid_580728 = query.getOrDefault("prettyPrint")
  valid_580728 = validateParameter(valid_580728, JBool, required = false,
                                 default = newJBool(true))
  if valid_580728 != nil:
    section.add "prettyPrint", valid_580728
  var valid_580729 = query.getOrDefault("oauth_token")
  valid_580729 = validateParameter(valid_580729, JString, required = false,
                                 default = nil)
  if valid_580729 != nil:
    section.add "oauth_token", valid_580729
  var valid_580730 = query.getOrDefault("alt")
  valid_580730 = validateParameter(valid_580730, JString, required = false,
                                 default = newJString("json"))
  if valid_580730 != nil:
    section.add "alt", valid_580730
  var valid_580731 = query.getOrDefault("userIp")
  valid_580731 = validateParameter(valid_580731, JString, required = false,
                                 default = nil)
  if valid_580731 != nil:
    section.add "userIp", valid_580731
  var valid_580732 = query.getOrDefault("quotaUser")
  valid_580732 = validateParameter(valid_580732, JString, required = false,
                                 default = nil)
  if valid_580732 != nil:
    section.add "quotaUser", valid_580732
  var valid_580733 = query.getOrDefault("fields")
  valid_580733 = validateParameter(valid_580733, JString, required = false,
                                 default = nil)
  if valid_580733 != nil:
    section.add "fields", valid_580733
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580734: Call_DirectoryTokensGet_580722; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an access token issued by a user.
  ## 
  let valid = call_580734.validator(path, query, header, formData, body)
  let scheme = call_580734.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580734.url(scheme.get, call_580734.host, call_580734.base,
                         call_580734.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580734, url, valid)

proc call*(call_580735: Call_DirectoryTokensGet_580722; clientId: string;
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
  var path_580736 = newJObject()
  var query_580737 = newJObject()
  add(query_580737, "key", newJString(key))
  add(path_580736, "clientId", newJString(clientId))
  add(query_580737, "prettyPrint", newJBool(prettyPrint))
  add(query_580737, "oauth_token", newJString(oauthToken))
  add(query_580737, "alt", newJString(alt))
  add(query_580737, "userIp", newJString(userIp))
  add(query_580737, "quotaUser", newJString(quotaUser))
  add(query_580737, "fields", newJString(fields))
  add(path_580736, "userKey", newJString(userKey))
  result = call_580735.call(path_580736, query_580737, nil, nil, nil)

var directoryTokensGet* = Call_DirectoryTokensGet_580722(
    name: "directoryTokensGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensGet_580723, base: "/admin/directory/v1",
    url: url_DirectoryTokensGet_580724, schemes: {Scheme.Https})
type
  Call_DirectoryTokensDelete_580738 = ref object of OpenApiRestCall_578364
proc url_DirectoryTokensDelete_580740(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryTokensDelete_580739(path: JsonNode; query: JsonNode;
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
  var valid_580741 = path.getOrDefault("clientId")
  valid_580741 = validateParameter(valid_580741, JString, required = true,
                                 default = nil)
  if valid_580741 != nil:
    section.add "clientId", valid_580741
  var valid_580742 = path.getOrDefault("userKey")
  valid_580742 = validateParameter(valid_580742, JString, required = true,
                                 default = nil)
  if valid_580742 != nil:
    section.add "userKey", valid_580742
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
  var valid_580743 = query.getOrDefault("key")
  valid_580743 = validateParameter(valid_580743, JString, required = false,
                                 default = nil)
  if valid_580743 != nil:
    section.add "key", valid_580743
  var valid_580744 = query.getOrDefault("prettyPrint")
  valid_580744 = validateParameter(valid_580744, JBool, required = false,
                                 default = newJBool(true))
  if valid_580744 != nil:
    section.add "prettyPrint", valid_580744
  var valid_580745 = query.getOrDefault("oauth_token")
  valid_580745 = validateParameter(valid_580745, JString, required = false,
                                 default = nil)
  if valid_580745 != nil:
    section.add "oauth_token", valid_580745
  var valid_580746 = query.getOrDefault("alt")
  valid_580746 = validateParameter(valid_580746, JString, required = false,
                                 default = newJString("json"))
  if valid_580746 != nil:
    section.add "alt", valid_580746
  var valid_580747 = query.getOrDefault("userIp")
  valid_580747 = validateParameter(valid_580747, JString, required = false,
                                 default = nil)
  if valid_580747 != nil:
    section.add "userIp", valid_580747
  var valid_580748 = query.getOrDefault("quotaUser")
  valid_580748 = validateParameter(valid_580748, JString, required = false,
                                 default = nil)
  if valid_580748 != nil:
    section.add "quotaUser", valid_580748
  var valid_580749 = query.getOrDefault("fields")
  valid_580749 = validateParameter(valid_580749, JString, required = false,
                                 default = nil)
  if valid_580749 != nil:
    section.add "fields", valid_580749
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580750: Call_DirectoryTokensDelete_580738; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all access tokens issued by a user for an application.
  ## 
  let valid = call_580750.validator(path, query, header, formData, body)
  let scheme = call_580750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580750.url(scheme.get, call_580750.host, call_580750.base,
                         call_580750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580750, url, valid)

proc call*(call_580751: Call_DirectoryTokensDelete_580738; clientId: string;
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
  var path_580752 = newJObject()
  var query_580753 = newJObject()
  add(query_580753, "key", newJString(key))
  add(path_580752, "clientId", newJString(clientId))
  add(query_580753, "prettyPrint", newJBool(prettyPrint))
  add(query_580753, "oauth_token", newJString(oauthToken))
  add(query_580753, "alt", newJString(alt))
  add(query_580753, "userIp", newJString(userIp))
  add(query_580753, "quotaUser", newJString(quotaUser))
  add(query_580753, "fields", newJString(fields))
  add(path_580752, "userKey", newJString(userKey))
  result = call_580751.call(path_580752, query_580753, nil, nil, nil)

var directoryTokensDelete* = Call_DirectoryTokensDelete_580738(
    name: "directoryTokensDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensDelete_580739, base: "/admin/directory/v1",
    url: url_DirectoryTokensDelete_580740, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUndelete_580754 = ref object of OpenApiRestCall_578364
proc url_DirectoryUsersUndelete_580756(protocol: Scheme; host: string; base: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryUsersUndelete_580755(path: JsonNode; query: JsonNode;
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
  var valid_580757 = path.getOrDefault("userKey")
  valid_580757 = validateParameter(valid_580757, JString, required = true,
                                 default = nil)
  if valid_580757 != nil:
    section.add "userKey", valid_580757
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
  var valid_580758 = query.getOrDefault("key")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "key", valid_580758
  var valid_580759 = query.getOrDefault("prettyPrint")
  valid_580759 = validateParameter(valid_580759, JBool, required = false,
                                 default = newJBool(true))
  if valid_580759 != nil:
    section.add "prettyPrint", valid_580759
  var valid_580760 = query.getOrDefault("oauth_token")
  valid_580760 = validateParameter(valid_580760, JString, required = false,
                                 default = nil)
  if valid_580760 != nil:
    section.add "oauth_token", valid_580760
  var valid_580761 = query.getOrDefault("alt")
  valid_580761 = validateParameter(valid_580761, JString, required = false,
                                 default = newJString("json"))
  if valid_580761 != nil:
    section.add "alt", valid_580761
  var valid_580762 = query.getOrDefault("userIp")
  valid_580762 = validateParameter(valid_580762, JString, required = false,
                                 default = nil)
  if valid_580762 != nil:
    section.add "userIp", valid_580762
  var valid_580763 = query.getOrDefault("quotaUser")
  valid_580763 = validateParameter(valid_580763, JString, required = false,
                                 default = nil)
  if valid_580763 != nil:
    section.add "quotaUser", valid_580763
  var valid_580764 = query.getOrDefault("fields")
  valid_580764 = validateParameter(valid_580764, JString, required = false,
                                 default = nil)
  if valid_580764 != nil:
    section.add "fields", valid_580764
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

proc call*(call_580766: Call_DirectoryUsersUndelete_580754; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted user
  ## 
  let valid = call_580766.validator(path, query, header, formData, body)
  let scheme = call_580766.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580766.url(scheme.get, call_580766.host, call_580766.base,
                         call_580766.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580766, url, valid)

proc call*(call_580767: Call_DirectoryUsersUndelete_580754; userKey: string;
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
  var path_580768 = newJObject()
  var query_580769 = newJObject()
  var body_580770 = newJObject()
  add(query_580769, "key", newJString(key))
  add(query_580769, "prettyPrint", newJBool(prettyPrint))
  add(query_580769, "oauth_token", newJString(oauthToken))
  add(query_580769, "alt", newJString(alt))
  add(query_580769, "userIp", newJString(userIp))
  add(query_580769, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_580770 = body
  add(query_580769, "fields", newJString(fields))
  add(path_580768, "userKey", newJString(userKey))
  result = call_580767.call(path_580768, query_580769, nil, nil, body_580770)

var directoryUsersUndelete* = Call_DirectoryUsersUndelete_580754(
    name: "directoryUsersUndelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/undelete",
    validator: validate_DirectoryUsersUndelete_580755,
    base: "/admin/directory/v1", url: url_DirectoryUsersUndelete_580756,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesList_580771 = ref object of OpenApiRestCall_578364
proc url_DirectoryVerificationCodesList_580773(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryVerificationCodesList_580772(path: JsonNode;
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
  var valid_580774 = path.getOrDefault("userKey")
  valid_580774 = validateParameter(valid_580774, JString, required = true,
                                 default = nil)
  if valid_580774 != nil:
    section.add "userKey", valid_580774
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
  var valid_580775 = query.getOrDefault("key")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "key", valid_580775
  var valid_580776 = query.getOrDefault("prettyPrint")
  valid_580776 = validateParameter(valid_580776, JBool, required = false,
                                 default = newJBool(true))
  if valid_580776 != nil:
    section.add "prettyPrint", valid_580776
  var valid_580777 = query.getOrDefault("oauth_token")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "oauth_token", valid_580777
  var valid_580778 = query.getOrDefault("alt")
  valid_580778 = validateParameter(valid_580778, JString, required = false,
                                 default = newJString("json"))
  if valid_580778 != nil:
    section.add "alt", valid_580778
  var valid_580779 = query.getOrDefault("userIp")
  valid_580779 = validateParameter(valid_580779, JString, required = false,
                                 default = nil)
  if valid_580779 != nil:
    section.add "userIp", valid_580779
  var valid_580780 = query.getOrDefault("quotaUser")
  valid_580780 = validateParameter(valid_580780, JString, required = false,
                                 default = nil)
  if valid_580780 != nil:
    section.add "quotaUser", valid_580780
  var valid_580781 = query.getOrDefault("fields")
  valid_580781 = validateParameter(valid_580781, JString, required = false,
                                 default = nil)
  if valid_580781 != nil:
    section.add "fields", valid_580781
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580782: Call_DirectoryVerificationCodesList_580771; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current set of valid backup verification codes for the specified user.
  ## 
  let valid = call_580782.validator(path, query, header, formData, body)
  let scheme = call_580782.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580782.url(scheme.get, call_580782.host, call_580782.base,
                         call_580782.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580782, url, valid)

proc call*(call_580783: Call_DirectoryVerificationCodesList_580771;
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
  var path_580784 = newJObject()
  var query_580785 = newJObject()
  add(query_580785, "key", newJString(key))
  add(query_580785, "prettyPrint", newJBool(prettyPrint))
  add(query_580785, "oauth_token", newJString(oauthToken))
  add(query_580785, "alt", newJString(alt))
  add(query_580785, "userIp", newJString(userIp))
  add(query_580785, "quotaUser", newJString(quotaUser))
  add(query_580785, "fields", newJString(fields))
  add(path_580784, "userKey", newJString(userKey))
  result = call_580783.call(path_580784, query_580785, nil, nil, nil)

var directoryVerificationCodesList* = Call_DirectoryVerificationCodesList_580771(
    name: "directoryVerificationCodesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/verificationCodes",
    validator: validate_DirectoryVerificationCodesList_580772,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesList_580773,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesGenerate_580786 = ref object of OpenApiRestCall_578364
proc url_DirectoryVerificationCodesGenerate_580788(protocol: Scheme; host: string;
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
  result.path = base & hydrated.get

proc validate_DirectoryVerificationCodesGenerate_580787(path: JsonNode;
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
  var valid_580789 = path.getOrDefault("userKey")
  valid_580789 = validateParameter(valid_580789, JString, required = true,
                                 default = nil)
  if valid_580789 != nil:
    section.add "userKey", valid_580789
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
  var valid_580790 = query.getOrDefault("key")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = nil)
  if valid_580790 != nil:
    section.add "key", valid_580790
  var valid_580791 = query.getOrDefault("prettyPrint")
  valid_580791 = validateParameter(valid_580791, JBool, required = false,
                                 default = newJBool(true))
  if valid_580791 != nil:
    section.add "prettyPrint", valid_580791
  var valid_580792 = query.getOrDefault("oauth_token")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "oauth_token", valid_580792
  var valid_580793 = query.getOrDefault("alt")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = newJString("json"))
  if valid_580793 != nil:
    section.add "alt", valid_580793
  var valid_580794 = query.getOrDefault("userIp")
  valid_580794 = validateParameter(valid_580794, JString, required = false,
                                 default = nil)
  if valid_580794 != nil:
    section.add "userIp", valid_580794
  var valid_580795 = query.getOrDefault("quotaUser")
  valid_580795 = validateParameter(valid_580795, JString, required = false,
                                 default = nil)
  if valid_580795 != nil:
    section.add "quotaUser", valid_580795
  var valid_580796 = query.getOrDefault("fields")
  valid_580796 = validateParameter(valid_580796, JString, required = false,
                                 default = nil)
  if valid_580796 != nil:
    section.add "fields", valid_580796
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580797: Call_DirectoryVerificationCodesGenerate_580786;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate new backup verification codes for the user.
  ## 
  let valid = call_580797.validator(path, query, header, formData, body)
  let scheme = call_580797.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580797.url(scheme.get, call_580797.host, call_580797.base,
                         call_580797.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580797, url, valid)

proc call*(call_580798: Call_DirectoryVerificationCodesGenerate_580786;
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
  var path_580799 = newJObject()
  var query_580800 = newJObject()
  add(query_580800, "key", newJString(key))
  add(query_580800, "prettyPrint", newJBool(prettyPrint))
  add(query_580800, "oauth_token", newJString(oauthToken))
  add(query_580800, "alt", newJString(alt))
  add(query_580800, "userIp", newJString(userIp))
  add(query_580800, "quotaUser", newJString(quotaUser))
  add(query_580800, "fields", newJString(fields))
  add(path_580799, "userKey", newJString(userKey))
  result = call_580798.call(path_580799, query_580800, nil, nil, nil)

var directoryVerificationCodesGenerate* = Call_DirectoryVerificationCodesGenerate_580786(
    name: "directoryVerificationCodesGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/generate",
    validator: validate_DirectoryVerificationCodesGenerate_580787,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesGenerate_580788,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesInvalidate_580801 = ref object of OpenApiRestCall_578364
proc url_DirectoryVerificationCodesInvalidate_580803(protocol: Scheme;
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
  result.path = base & hydrated.get

proc validate_DirectoryVerificationCodesInvalidate_580802(path: JsonNode;
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
  var valid_580804 = path.getOrDefault("userKey")
  valid_580804 = validateParameter(valid_580804, JString, required = true,
                                 default = nil)
  if valid_580804 != nil:
    section.add "userKey", valid_580804
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
  var valid_580805 = query.getOrDefault("key")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "key", valid_580805
  var valid_580806 = query.getOrDefault("prettyPrint")
  valid_580806 = validateParameter(valid_580806, JBool, required = false,
                                 default = newJBool(true))
  if valid_580806 != nil:
    section.add "prettyPrint", valid_580806
  var valid_580807 = query.getOrDefault("oauth_token")
  valid_580807 = validateParameter(valid_580807, JString, required = false,
                                 default = nil)
  if valid_580807 != nil:
    section.add "oauth_token", valid_580807
  var valid_580808 = query.getOrDefault("alt")
  valid_580808 = validateParameter(valid_580808, JString, required = false,
                                 default = newJString("json"))
  if valid_580808 != nil:
    section.add "alt", valid_580808
  var valid_580809 = query.getOrDefault("userIp")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = nil)
  if valid_580809 != nil:
    section.add "userIp", valid_580809
  var valid_580810 = query.getOrDefault("quotaUser")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "quotaUser", valid_580810
  var valid_580811 = query.getOrDefault("fields")
  valid_580811 = validateParameter(valid_580811, JString, required = false,
                                 default = nil)
  if valid_580811 != nil:
    section.add "fields", valid_580811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580812: Call_DirectoryVerificationCodesInvalidate_580801;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invalidate the current backup verification codes for the user.
  ## 
  let valid = call_580812.validator(path, query, header, formData, body)
  let scheme = call_580812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580812.url(scheme.get, call_580812.host, call_580812.base,
                         call_580812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580812, url, valid)

proc call*(call_580813: Call_DirectoryVerificationCodesInvalidate_580801;
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
  var path_580814 = newJObject()
  var query_580815 = newJObject()
  add(query_580815, "key", newJString(key))
  add(query_580815, "prettyPrint", newJBool(prettyPrint))
  add(query_580815, "oauth_token", newJString(oauthToken))
  add(query_580815, "alt", newJString(alt))
  add(query_580815, "userIp", newJString(userIp))
  add(query_580815, "quotaUser", newJString(quotaUser))
  add(query_580815, "fields", newJString(fields))
  add(path_580814, "userKey", newJString(userKey))
  result = call_580813.call(path_580814, query_580815, nil, nil, nil)

var directoryVerificationCodesInvalidate* = Call_DirectoryVerificationCodesInvalidate_580801(
    name: "directoryVerificationCodesInvalidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/invalidate",
    validator: validate_DirectoryVerificationCodesInvalidate_580802,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesInvalidate_580803,
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
