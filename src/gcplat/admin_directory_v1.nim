
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

  OpenApiRestCall_588466 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588466](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588466): Option[Scheme] {.used.} =
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
  gcpServiceName = "admin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdminChannelsStop_588734 = ref object of OpenApiRestCall_588466
proc url_AdminChannelsStop_588736(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdminChannelsStop_588735(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
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
  var valid_588848 = query.getOrDefault("fields")
  valid_588848 = validateParameter(valid_588848, JString, required = false,
                                 default = nil)
  if valid_588848 != nil:
    section.add "fields", valid_588848
  var valid_588849 = query.getOrDefault("quotaUser")
  valid_588849 = validateParameter(valid_588849, JString, required = false,
                                 default = nil)
  if valid_588849 != nil:
    section.add "quotaUser", valid_588849
  var valid_588863 = query.getOrDefault("alt")
  valid_588863 = validateParameter(valid_588863, JString, required = false,
                                 default = newJString("json"))
  if valid_588863 != nil:
    section.add "alt", valid_588863
  var valid_588864 = query.getOrDefault("oauth_token")
  valid_588864 = validateParameter(valid_588864, JString, required = false,
                                 default = nil)
  if valid_588864 != nil:
    section.add "oauth_token", valid_588864
  var valid_588865 = query.getOrDefault("userIp")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "userIp", valid_588865
  var valid_588866 = query.getOrDefault("key")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "key", valid_588866
  var valid_588867 = query.getOrDefault("prettyPrint")
  valid_588867 = validateParameter(valid_588867, JBool, required = false,
                                 default = newJBool(true))
  if valid_588867 != nil:
    section.add "prettyPrint", valid_588867
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

proc call*(call_588891: Call_AdminChannelsStop_588734; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_588891.validator(path, query, header, formData, body)
  let scheme = call_588891.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588891.url(scheme.get, call_588891.host, call_588891.base,
                         call_588891.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588891, url, valid)

proc call*(call_588962: Call_AdminChannelsStop_588734; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## adminChannelsStop
  ## Stop watching resources through this channel
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
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588963 = newJObject()
  var body_588965 = newJObject()
  add(query_588963, "fields", newJString(fields))
  add(query_588963, "quotaUser", newJString(quotaUser))
  add(query_588963, "alt", newJString(alt))
  add(query_588963, "oauth_token", newJString(oauthToken))
  add(query_588963, "userIp", newJString(userIp))
  add(query_588963, "key", newJString(key))
  if resource != nil:
    body_588965 = resource
  add(query_588963, "prettyPrint", newJBool(prettyPrint))
  result = call_588962.call(nil, query_588963, nil, nil, body_588965)

var adminChannelsStop* = Call_AdminChannelsStop_588734(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/directory_v1/channels/stop",
    validator: validate_AdminChannelsStop_588735, base: "/admin/directory/v1",
    url: url_AdminChannelsStop_588736, schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesList_589004 = ref object of OpenApiRestCall_588466
proc url_DirectoryChromeosdevicesList_589006(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesList_589005(path: JsonNode; query: JsonNode;
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
  var valid_589021 = path.getOrDefault("customerId")
  valid_589021 = validateParameter(valid_589021, JString, required = true,
                                 default = nil)
  if valid_589021 != nil:
    section.add "customerId", valid_589021
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   query: JString
  ##        : Search string in the format given at http://support.google.com/chromeos/a/bin/answer.py?answer=1698333
  ##   orgUnitPath: JString
  ##              : Full path of the organizational unit or its ID
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Max allowed value is 200.
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589022 = query.getOrDefault("fields")
  valid_589022 = validateParameter(valid_589022, JString, required = false,
                                 default = nil)
  if valid_589022 != nil:
    section.add "fields", valid_589022
  var valid_589023 = query.getOrDefault("pageToken")
  valid_589023 = validateParameter(valid_589023, JString, required = false,
                                 default = nil)
  if valid_589023 != nil:
    section.add "pageToken", valid_589023
  var valid_589024 = query.getOrDefault("quotaUser")
  valid_589024 = validateParameter(valid_589024, JString, required = false,
                                 default = nil)
  if valid_589024 != nil:
    section.add "quotaUser", valid_589024
  var valid_589025 = query.getOrDefault("alt")
  valid_589025 = validateParameter(valid_589025, JString, required = false,
                                 default = newJString("json"))
  if valid_589025 != nil:
    section.add "alt", valid_589025
  var valid_589026 = query.getOrDefault("query")
  valid_589026 = validateParameter(valid_589026, JString, required = false,
                                 default = nil)
  if valid_589026 != nil:
    section.add "query", valid_589026
  var valid_589027 = query.getOrDefault("orgUnitPath")
  valid_589027 = validateParameter(valid_589027, JString, required = false,
                                 default = nil)
  if valid_589027 != nil:
    section.add "orgUnitPath", valid_589027
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
  var valid_589031 = query.getOrDefault("maxResults")
  valid_589031 = validateParameter(valid_589031, JInt, required = false,
                                 default = newJInt(100))
  if valid_589031 != nil:
    section.add "maxResults", valid_589031
  var valid_589032 = query.getOrDefault("orderBy")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = newJString("annotatedLocation"))
  if valid_589032 != nil:
    section.add "orderBy", valid_589032
  var valid_589033 = query.getOrDefault("key")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = nil)
  if valid_589033 != nil:
    section.add "key", valid_589033
  var valid_589034 = query.getOrDefault("projection")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589034 != nil:
    section.add "projection", valid_589034
  var valid_589035 = query.getOrDefault("sortOrder")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_589035 != nil:
    section.add "sortOrder", valid_589035
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
  if body != nil:
    result.add "body", body

proc call*(call_589037: Call_DirectoryChromeosdevicesList_589004; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Chrome OS Devices of a customer (paginated)
  ## 
  let valid = call_589037.validator(path, query, header, formData, body)
  let scheme = call_589037.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589037.url(scheme.get, call_589037.host, call_589037.base,
                         call_589037.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589037, url, valid)

proc call*(call_589038: Call_DirectoryChromeosdevicesList_589004;
          customerId: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; query: string = "";
          orgUnitPath: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 100; orderBy: string = "annotatedLocation";
          key: string = ""; projection: string = "BASIC";
          sortOrder: string = "ASCENDING"; prettyPrint: bool = true): Recallable =
  ## directoryChromeosdevicesList
  ## Retrieve all Chrome OS Devices of a customer (paginated)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : Search string in the format given at http://support.google.com/chromeos/a/bin/answer.py?answer=1698333
  ##   orgUnitPath: string
  ##              : Full path of the organizational unit or its ID
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return. Max allowed value is 200.
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589039 = newJObject()
  var query_589040 = newJObject()
  add(query_589040, "fields", newJString(fields))
  add(query_589040, "pageToken", newJString(pageToken))
  add(query_589040, "quotaUser", newJString(quotaUser))
  add(query_589040, "alt", newJString(alt))
  add(query_589040, "query", newJString(query))
  add(query_589040, "orgUnitPath", newJString(orgUnitPath))
  add(query_589040, "oauth_token", newJString(oauthToken))
  add(query_589040, "userIp", newJString(userIp))
  add(query_589040, "maxResults", newJInt(maxResults))
  add(query_589040, "orderBy", newJString(orderBy))
  add(path_589039, "customerId", newJString(customerId))
  add(query_589040, "key", newJString(key))
  add(query_589040, "projection", newJString(projection))
  add(query_589040, "sortOrder", newJString(sortOrder))
  add(query_589040, "prettyPrint", newJBool(prettyPrint))
  result = call_589038.call(path_589039, query_589040, nil, nil, nil)

var directoryChromeosdevicesList* = Call_DirectoryChromeosdevicesList_589004(
    name: "directoryChromeosdevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/chromeos",
    validator: validate_DirectoryChromeosdevicesList_589005,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesList_589006,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesMoveDevicesToOu_589041 = ref object of OpenApiRestCall_588466
proc url_DirectoryChromeosdevicesMoveDevicesToOu_589043(protocol: Scheme;
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

proc validate_DirectoryChromeosdevicesMoveDevicesToOu_589042(path: JsonNode;
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
  var valid_589044 = path.getOrDefault("customerId")
  valid_589044 = validateParameter(valid_589044, JString, required = true,
                                 default = nil)
  if valid_589044 != nil:
    section.add "customerId", valid_589044
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   orgUnitPath: JString (required)
  ##              : Full path of the target organizational unit or its ID
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
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
  assert query != nil,
        "query argument is necessary due to required `orgUnitPath` field"
  var valid_589048 = query.getOrDefault("orgUnitPath")
  valid_589048 = validateParameter(valid_589048, JString, required = true,
                                 default = nil)
  if valid_589048 != nil:
    section.add "orgUnitPath", valid_589048
  var valid_589049 = query.getOrDefault("oauth_token")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = nil)
  if valid_589049 != nil:
    section.add "oauth_token", valid_589049
  var valid_589050 = query.getOrDefault("userIp")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "userIp", valid_589050
  var valid_589051 = query.getOrDefault("key")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "key", valid_589051
  var valid_589052 = query.getOrDefault("prettyPrint")
  valid_589052 = validateParameter(valid_589052, JBool, required = false,
                                 default = newJBool(true))
  if valid_589052 != nil:
    section.add "prettyPrint", valid_589052
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

proc call*(call_589054: Call_DirectoryChromeosdevicesMoveDevicesToOu_589041;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Move or insert multiple Chrome OS Devices to organizational unit
  ## 
  let valid = call_589054.validator(path, query, header, formData, body)
  let scheme = call_589054.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589054.url(scheme.get, call_589054.host, call_589054.base,
                         call_589054.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589054, url, valid)

proc call*(call_589055: Call_DirectoryChromeosdevicesMoveDevicesToOu_589041;
          orgUnitPath: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryChromeosdevicesMoveDevicesToOu
  ## Move or insert multiple Chrome OS Devices to organizational unit
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   orgUnitPath: string (required)
  ##              : Full path of the target organizational unit or its ID
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589056 = newJObject()
  var query_589057 = newJObject()
  var body_589058 = newJObject()
  add(query_589057, "fields", newJString(fields))
  add(query_589057, "quotaUser", newJString(quotaUser))
  add(query_589057, "alt", newJString(alt))
  add(query_589057, "orgUnitPath", newJString(orgUnitPath))
  add(query_589057, "oauth_token", newJString(oauthToken))
  add(query_589057, "userIp", newJString(userIp))
  add(path_589056, "customerId", newJString(customerId))
  add(query_589057, "key", newJString(key))
  if body != nil:
    body_589058 = body
  add(query_589057, "prettyPrint", newJBool(prettyPrint))
  result = call_589055.call(path_589056, query_589057, nil, nil, body_589058)

var directoryChromeosdevicesMoveDevicesToOu* = Call_DirectoryChromeosdevicesMoveDevicesToOu_589041(
    name: "directoryChromeosdevicesMoveDevicesToOu", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/moveDevicesToOu",
    validator: validate_DirectoryChromeosdevicesMoveDevicesToOu_589042,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesMoveDevicesToOu_589043,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesUpdate_589076 = ref object of OpenApiRestCall_588466
proc url_DirectoryChromeosdevicesUpdate_589078(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesUpdate_589077(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Chrome OS Device
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : Immutable ID of Chrome OS Device
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_589079 = path.getOrDefault("deviceId")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "deviceId", valid_589079
  var valid_589080 = path.getOrDefault("customerId")
  valid_589080 = validateParameter(valid_589080, JString, required = true,
                                 default = nil)
  if valid_589080 != nil:
    section.add "customerId", valid_589080
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
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589081 = query.getOrDefault("fields")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "fields", valid_589081
  var valid_589082 = query.getOrDefault("quotaUser")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = nil)
  if valid_589082 != nil:
    section.add "quotaUser", valid_589082
  var valid_589083 = query.getOrDefault("alt")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = newJString("json"))
  if valid_589083 != nil:
    section.add "alt", valid_589083
  var valid_589084 = query.getOrDefault("oauth_token")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "oauth_token", valid_589084
  var valid_589085 = query.getOrDefault("userIp")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "userIp", valid_589085
  var valid_589086 = query.getOrDefault("key")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = nil)
  if valid_589086 != nil:
    section.add "key", valid_589086
  var valid_589087 = query.getOrDefault("projection")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589087 != nil:
    section.add "projection", valid_589087
  var valid_589088 = query.getOrDefault("prettyPrint")
  valid_589088 = validateParameter(valid_589088, JBool, required = false,
                                 default = newJBool(true))
  if valid_589088 != nil:
    section.add "prettyPrint", valid_589088
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

proc call*(call_589090: Call_DirectoryChromeosdevicesUpdate_589076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device
  ## 
  let valid = call_589090.validator(path, query, header, formData, body)
  let scheme = call_589090.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589090.url(scheme.get, call_589090.host, call_589090.base,
                         call_589090.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589090, url, valid)

proc call*(call_589091: Call_DirectoryChromeosdevicesUpdate_589076;
          deviceId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; projection: string = "BASIC";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryChromeosdevicesUpdate
  ## Update Chrome OS Device
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : Immutable ID of Chrome OS Device
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589092 = newJObject()
  var query_589093 = newJObject()
  var body_589094 = newJObject()
  add(query_589093, "fields", newJString(fields))
  add(query_589093, "quotaUser", newJString(quotaUser))
  add(query_589093, "alt", newJString(alt))
  add(path_589092, "deviceId", newJString(deviceId))
  add(query_589093, "oauth_token", newJString(oauthToken))
  add(query_589093, "userIp", newJString(userIp))
  add(path_589092, "customerId", newJString(customerId))
  add(query_589093, "key", newJString(key))
  add(query_589093, "projection", newJString(projection))
  if body != nil:
    body_589094 = body
  add(query_589093, "prettyPrint", newJBool(prettyPrint))
  result = call_589091.call(path_589092, query_589093, nil, nil, body_589094)

var directoryChromeosdevicesUpdate* = Call_DirectoryChromeosdevicesUpdate_589076(
    name: "directoryChromeosdevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesUpdate_589077,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesUpdate_589078,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesGet_589059 = ref object of OpenApiRestCall_588466
proc url_DirectoryChromeosdevicesGet_589061(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesGet_589060(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve Chrome OS Device
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : Immutable ID of Chrome OS Device
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_589062 = path.getOrDefault("deviceId")
  valid_589062 = validateParameter(valid_589062, JString, required = true,
                                 default = nil)
  if valid_589062 != nil:
    section.add "deviceId", valid_589062
  var valid_589063 = path.getOrDefault("customerId")
  valid_589063 = validateParameter(valid_589063, JString, required = true,
                                 default = nil)
  if valid_589063 != nil:
    section.add "customerId", valid_589063
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
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589064 = query.getOrDefault("fields")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "fields", valid_589064
  var valid_589065 = query.getOrDefault("quotaUser")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "quotaUser", valid_589065
  var valid_589066 = query.getOrDefault("alt")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = newJString("json"))
  if valid_589066 != nil:
    section.add "alt", valid_589066
  var valid_589067 = query.getOrDefault("oauth_token")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "oauth_token", valid_589067
  var valid_589068 = query.getOrDefault("userIp")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "userIp", valid_589068
  var valid_589069 = query.getOrDefault("key")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "key", valid_589069
  var valid_589070 = query.getOrDefault("projection")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589070 != nil:
    section.add "projection", valid_589070
  var valid_589071 = query.getOrDefault("prettyPrint")
  valid_589071 = validateParameter(valid_589071, JBool, required = false,
                                 default = newJBool(true))
  if valid_589071 != nil:
    section.add "prettyPrint", valid_589071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589072: Call_DirectoryChromeosdevicesGet_589059; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Chrome OS Device
  ## 
  let valid = call_589072.validator(path, query, header, formData, body)
  let scheme = call_589072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589072.url(scheme.get, call_589072.host, call_589072.base,
                         call_589072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589072, url, valid)

proc call*(call_589073: Call_DirectoryChromeosdevicesGet_589059; deviceId: string;
          customerId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; projection: string = "BASIC"; prettyPrint: bool = true): Recallable =
  ## directoryChromeosdevicesGet
  ## Retrieve Chrome OS Device
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : Immutable ID of Chrome OS Device
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589074 = newJObject()
  var query_589075 = newJObject()
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(query_589075, "alt", newJString(alt))
  add(path_589074, "deviceId", newJString(deviceId))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "userIp", newJString(userIp))
  add(path_589074, "customerId", newJString(customerId))
  add(query_589075, "key", newJString(key))
  add(query_589075, "projection", newJString(projection))
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  result = call_589073.call(path_589074, query_589075, nil, nil, nil)

var directoryChromeosdevicesGet* = Call_DirectoryChromeosdevicesGet_589059(
    name: "directoryChromeosdevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesGet_589060,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesGet_589061,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesPatch_589095 = ref object of OpenApiRestCall_588466
proc url_DirectoryChromeosdevicesPatch_589097(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesPatch_589096(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Chrome OS Device. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   deviceId: JString (required)
  ##           : Immutable ID of Chrome OS Device
  ##   customerId: JString (required)
  ##             : Immutable ID of the G Suite account
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `deviceId` field"
  var valid_589098 = path.getOrDefault("deviceId")
  valid_589098 = validateParameter(valid_589098, JString, required = true,
                                 default = nil)
  if valid_589098 != nil:
    section.add "deviceId", valid_589098
  var valid_589099 = path.getOrDefault("customerId")
  valid_589099 = validateParameter(valid_589099, JString, required = true,
                                 default = nil)
  if valid_589099 != nil:
    section.add "customerId", valid_589099
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
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589100 = query.getOrDefault("fields")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = nil)
  if valid_589100 != nil:
    section.add "fields", valid_589100
  var valid_589101 = query.getOrDefault("quotaUser")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "quotaUser", valid_589101
  var valid_589102 = query.getOrDefault("alt")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = newJString("json"))
  if valid_589102 != nil:
    section.add "alt", valid_589102
  var valid_589103 = query.getOrDefault("oauth_token")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "oauth_token", valid_589103
  var valid_589104 = query.getOrDefault("userIp")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "userIp", valid_589104
  var valid_589105 = query.getOrDefault("key")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = nil)
  if valid_589105 != nil:
    section.add "key", valid_589105
  var valid_589106 = query.getOrDefault("projection")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589106 != nil:
    section.add "projection", valid_589106
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

proc call*(call_589109: Call_DirectoryChromeosdevicesPatch_589095; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device. This method supports patch semantics.
  ## 
  let valid = call_589109.validator(path, query, header, formData, body)
  let scheme = call_589109.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589109.url(scheme.get, call_589109.host, call_589109.base,
                         call_589109.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589109, url, valid)

proc call*(call_589110: Call_DirectoryChromeosdevicesPatch_589095;
          deviceId: string; customerId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; projection: string = "BASIC";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryChromeosdevicesPatch
  ## Update Chrome OS Device. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   deviceId: string (required)
  ##           : Immutable ID of Chrome OS Device
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589111 = newJObject()
  var query_589112 = newJObject()
  var body_589113 = newJObject()
  add(query_589112, "fields", newJString(fields))
  add(query_589112, "quotaUser", newJString(quotaUser))
  add(query_589112, "alt", newJString(alt))
  add(path_589111, "deviceId", newJString(deviceId))
  add(query_589112, "oauth_token", newJString(oauthToken))
  add(query_589112, "userIp", newJString(userIp))
  add(path_589111, "customerId", newJString(customerId))
  add(query_589112, "key", newJString(key))
  add(query_589112, "projection", newJString(projection))
  if body != nil:
    body_589113 = body
  add(query_589112, "prettyPrint", newJBool(prettyPrint))
  result = call_589110.call(path_589111, query_589112, nil, nil, body_589113)

var directoryChromeosdevicesPatch* = Call_DirectoryChromeosdevicesPatch_589095(
    name: "directoryChromeosdevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesPatch_589096,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesPatch_589097,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesAction_589114 = ref object of OpenApiRestCall_588466
proc url_DirectoryChromeosdevicesAction_589116(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesAction_589115(path: JsonNode;
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
  var valid_589117 = path.getOrDefault("customerId")
  valid_589117 = validateParameter(valid_589117, JString, required = true,
                                 default = nil)
  if valid_589117 != nil:
    section.add "customerId", valid_589117
  var valid_589118 = path.getOrDefault("resourceId")
  valid_589118 = validateParameter(valid_589118, JString, required = true,
                                 default = nil)
  if valid_589118 != nil:
    section.add "resourceId", valid_589118
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
  var valid_589119 = query.getOrDefault("fields")
  valid_589119 = validateParameter(valid_589119, JString, required = false,
                                 default = nil)
  if valid_589119 != nil:
    section.add "fields", valid_589119
  var valid_589120 = query.getOrDefault("quotaUser")
  valid_589120 = validateParameter(valid_589120, JString, required = false,
                                 default = nil)
  if valid_589120 != nil:
    section.add "quotaUser", valid_589120
  var valid_589121 = query.getOrDefault("alt")
  valid_589121 = validateParameter(valid_589121, JString, required = false,
                                 default = newJString("json"))
  if valid_589121 != nil:
    section.add "alt", valid_589121
  var valid_589122 = query.getOrDefault("oauth_token")
  valid_589122 = validateParameter(valid_589122, JString, required = false,
                                 default = nil)
  if valid_589122 != nil:
    section.add "oauth_token", valid_589122
  var valid_589123 = query.getOrDefault("userIp")
  valid_589123 = validateParameter(valid_589123, JString, required = false,
                                 default = nil)
  if valid_589123 != nil:
    section.add "userIp", valid_589123
  var valid_589124 = query.getOrDefault("key")
  valid_589124 = validateParameter(valid_589124, JString, required = false,
                                 default = nil)
  if valid_589124 != nil:
    section.add "key", valid_589124
  var valid_589125 = query.getOrDefault("prettyPrint")
  valid_589125 = validateParameter(valid_589125, JBool, required = false,
                                 default = newJBool(true))
  if valid_589125 != nil:
    section.add "prettyPrint", valid_589125
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

proc call*(call_589127: Call_DirectoryChromeosdevicesAction_589114; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Chrome OS Device
  ## 
  let valid = call_589127.validator(path, query, header, formData, body)
  let scheme = call_589127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589127.url(scheme.get, call_589127.host, call_589127.base,
                         call_589127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589127, url, valid)

proc call*(call_589128: Call_DirectoryChromeosdevicesAction_589114;
          customerId: string; resourceId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryChromeosdevicesAction
  ## Take action on Chrome OS Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
  ##             : Immutable ID of Chrome OS Device
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589129 = newJObject()
  var query_589130 = newJObject()
  var body_589131 = newJObject()
  add(query_589130, "fields", newJString(fields))
  add(query_589130, "quotaUser", newJString(quotaUser))
  add(query_589130, "alt", newJString(alt))
  add(query_589130, "oauth_token", newJString(oauthToken))
  add(query_589130, "userIp", newJString(userIp))
  add(path_589129, "customerId", newJString(customerId))
  add(query_589130, "key", newJString(key))
  add(path_589129, "resourceId", newJString(resourceId))
  if body != nil:
    body_589131 = body
  add(query_589130, "prettyPrint", newJBool(prettyPrint))
  result = call_589128.call(path_589129, query_589130, nil, nil, body_589131)

var directoryChromeosdevicesAction* = Call_DirectoryChromeosdevicesAction_589114(
    name: "directoryChromeosdevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{resourceId}/action",
    validator: validate_DirectoryChromeosdevicesAction_589115,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesAction_589116,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesList_589132 = ref object of OpenApiRestCall_588466
proc url_DirectoryMobiledevicesList_589134(protocol: Scheme; host: string;
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

proc validate_DirectoryMobiledevicesList_589133(path: JsonNode; query: JsonNode;
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
  var valid_589135 = path.getOrDefault("customerId")
  valid_589135 = validateParameter(valid_589135, JString, required = true,
                                 default = nil)
  if valid_589135 != nil:
    section.add "customerId", valid_589135
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   query: JString
  ##        : Search string in the format given at http://support.google.com/a/bin/answer.py?answer=1408863#search
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Max allowed value is 100.
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589136 = query.getOrDefault("fields")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "fields", valid_589136
  var valid_589137 = query.getOrDefault("pageToken")
  valid_589137 = validateParameter(valid_589137, JString, required = false,
                                 default = nil)
  if valid_589137 != nil:
    section.add "pageToken", valid_589137
  var valid_589138 = query.getOrDefault("quotaUser")
  valid_589138 = validateParameter(valid_589138, JString, required = false,
                                 default = nil)
  if valid_589138 != nil:
    section.add "quotaUser", valid_589138
  var valid_589139 = query.getOrDefault("alt")
  valid_589139 = validateParameter(valid_589139, JString, required = false,
                                 default = newJString("json"))
  if valid_589139 != nil:
    section.add "alt", valid_589139
  var valid_589140 = query.getOrDefault("query")
  valid_589140 = validateParameter(valid_589140, JString, required = false,
                                 default = nil)
  if valid_589140 != nil:
    section.add "query", valid_589140
  var valid_589141 = query.getOrDefault("oauth_token")
  valid_589141 = validateParameter(valid_589141, JString, required = false,
                                 default = nil)
  if valid_589141 != nil:
    section.add "oauth_token", valid_589141
  var valid_589142 = query.getOrDefault("userIp")
  valid_589142 = validateParameter(valid_589142, JString, required = false,
                                 default = nil)
  if valid_589142 != nil:
    section.add "userIp", valid_589142
  var valid_589143 = query.getOrDefault("maxResults")
  valid_589143 = validateParameter(valid_589143, JInt, required = false,
                                 default = newJInt(100))
  if valid_589143 != nil:
    section.add "maxResults", valid_589143
  var valid_589144 = query.getOrDefault("orderBy")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = newJString("deviceId"))
  if valid_589144 != nil:
    section.add "orderBy", valid_589144
  var valid_589145 = query.getOrDefault("key")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "key", valid_589145
  var valid_589146 = query.getOrDefault("projection")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589146 != nil:
    section.add "projection", valid_589146
  var valid_589147 = query.getOrDefault("sortOrder")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_589147 != nil:
    section.add "sortOrder", valid_589147
  var valid_589148 = query.getOrDefault("prettyPrint")
  valid_589148 = validateParameter(valid_589148, JBool, required = false,
                                 default = newJBool(true))
  if valid_589148 != nil:
    section.add "prettyPrint", valid_589148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589149: Call_DirectoryMobiledevicesList_589132; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Mobile Devices of a customer (paginated)
  ## 
  let valid = call_589149.validator(path, query, header, formData, body)
  let scheme = call_589149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589149.url(scheme.get, call_589149.host, call_589149.base,
                         call_589149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589149, url, valid)

proc call*(call_589150: Call_DirectoryMobiledevicesList_589132; customerId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; query: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 100; orderBy: string = "deviceId";
          key: string = ""; projection: string = "BASIC";
          sortOrder: string = "ASCENDING"; prettyPrint: bool = true): Recallable =
  ## directoryMobiledevicesList
  ## Retrieve all Mobile Devices of a customer (paginated)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : Search string in the format given at http://support.google.com/a/bin/answer.py?answer=1408863#search
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return. Max allowed value is 100.
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589151 = newJObject()
  var query_589152 = newJObject()
  add(query_589152, "fields", newJString(fields))
  add(query_589152, "pageToken", newJString(pageToken))
  add(query_589152, "quotaUser", newJString(quotaUser))
  add(query_589152, "alt", newJString(alt))
  add(query_589152, "query", newJString(query))
  add(query_589152, "oauth_token", newJString(oauthToken))
  add(query_589152, "userIp", newJString(userIp))
  add(query_589152, "maxResults", newJInt(maxResults))
  add(query_589152, "orderBy", newJString(orderBy))
  add(path_589151, "customerId", newJString(customerId))
  add(query_589152, "key", newJString(key))
  add(query_589152, "projection", newJString(projection))
  add(query_589152, "sortOrder", newJString(sortOrder))
  add(query_589152, "prettyPrint", newJBool(prettyPrint))
  result = call_589150.call(path_589151, query_589152, nil, nil, nil)

var directoryMobiledevicesList* = Call_DirectoryMobiledevicesList_589132(
    name: "directoryMobiledevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/mobile",
    validator: validate_DirectoryMobiledevicesList_589133,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesList_589134,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesGet_589153 = ref object of OpenApiRestCall_588466
proc url_DirectoryMobiledevicesGet_589155(protocol: Scheme; host: string;
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

proc validate_DirectoryMobiledevicesGet_589154(path: JsonNode; query: JsonNode;
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
  var valid_589156 = path.getOrDefault("customerId")
  valid_589156 = validateParameter(valid_589156, JString, required = true,
                                 default = nil)
  if valid_589156 != nil:
    section.add "customerId", valid_589156
  var valid_589157 = path.getOrDefault("resourceId")
  valid_589157 = validateParameter(valid_589157, JString, required = true,
                                 default = nil)
  if valid_589157 != nil:
    section.add "resourceId", valid_589157
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
  ##   projection: JString
  ##             : Restrict information returned to a set of selected fields.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589158 = query.getOrDefault("fields")
  valid_589158 = validateParameter(valid_589158, JString, required = false,
                                 default = nil)
  if valid_589158 != nil:
    section.add "fields", valid_589158
  var valid_589159 = query.getOrDefault("quotaUser")
  valid_589159 = validateParameter(valid_589159, JString, required = false,
                                 default = nil)
  if valid_589159 != nil:
    section.add "quotaUser", valid_589159
  var valid_589160 = query.getOrDefault("alt")
  valid_589160 = validateParameter(valid_589160, JString, required = false,
                                 default = newJString("json"))
  if valid_589160 != nil:
    section.add "alt", valid_589160
  var valid_589161 = query.getOrDefault("oauth_token")
  valid_589161 = validateParameter(valid_589161, JString, required = false,
                                 default = nil)
  if valid_589161 != nil:
    section.add "oauth_token", valid_589161
  var valid_589162 = query.getOrDefault("userIp")
  valid_589162 = validateParameter(valid_589162, JString, required = false,
                                 default = nil)
  if valid_589162 != nil:
    section.add "userIp", valid_589162
  var valid_589163 = query.getOrDefault("key")
  valid_589163 = validateParameter(valid_589163, JString, required = false,
                                 default = nil)
  if valid_589163 != nil:
    section.add "key", valid_589163
  var valid_589164 = query.getOrDefault("projection")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_589164 != nil:
    section.add "projection", valid_589164
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
  if body != nil:
    result.add "body", body

proc call*(call_589166: Call_DirectoryMobiledevicesGet_589153; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Mobile Device
  ## 
  let valid = call_589166.validator(path, query, header, formData, body)
  let scheme = call_589166.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589166.url(scheme.get, call_589166.host, call_589166.base,
                         call_589166.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589166, url, valid)

proc call*(call_589167: Call_DirectoryMobiledevicesGet_589153; customerId: string;
          resourceId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; projection: string = "BASIC"; prettyPrint: bool = true): Recallable =
  ## directoryMobiledevicesGet
  ## Retrieve Mobile Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
  ##             : Immutable ID of Mobile Device
  ##   projection: string
  ##             : Restrict information returned to a set of selected fields.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589168 = newJObject()
  var query_589169 = newJObject()
  add(query_589169, "fields", newJString(fields))
  add(query_589169, "quotaUser", newJString(quotaUser))
  add(query_589169, "alt", newJString(alt))
  add(query_589169, "oauth_token", newJString(oauthToken))
  add(query_589169, "userIp", newJString(userIp))
  add(path_589168, "customerId", newJString(customerId))
  add(query_589169, "key", newJString(key))
  add(path_589168, "resourceId", newJString(resourceId))
  add(query_589169, "projection", newJString(projection))
  add(query_589169, "prettyPrint", newJBool(prettyPrint))
  result = call_589167.call(path_589168, query_589169, nil, nil, nil)

var directoryMobiledevicesGet* = Call_DirectoryMobiledevicesGet_589153(
    name: "directoryMobiledevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesGet_589154,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesGet_589155,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesDelete_589170 = ref object of OpenApiRestCall_588466
proc url_DirectoryMobiledevicesDelete_589172(protocol: Scheme; host: string;
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

proc validate_DirectoryMobiledevicesDelete_589171(path: JsonNode; query: JsonNode;
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
  var valid_589173 = path.getOrDefault("customerId")
  valid_589173 = validateParameter(valid_589173, JString, required = true,
                                 default = nil)
  if valid_589173 != nil:
    section.add "customerId", valid_589173
  var valid_589174 = path.getOrDefault("resourceId")
  valid_589174 = validateParameter(valid_589174, JString, required = true,
                                 default = nil)
  if valid_589174 != nil:
    section.add "resourceId", valid_589174
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
  var valid_589175 = query.getOrDefault("fields")
  valid_589175 = validateParameter(valid_589175, JString, required = false,
                                 default = nil)
  if valid_589175 != nil:
    section.add "fields", valid_589175
  var valid_589176 = query.getOrDefault("quotaUser")
  valid_589176 = validateParameter(valid_589176, JString, required = false,
                                 default = nil)
  if valid_589176 != nil:
    section.add "quotaUser", valid_589176
  var valid_589177 = query.getOrDefault("alt")
  valid_589177 = validateParameter(valid_589177, JString, required = false,
                                 default = newJString("json"))
  if valid_589177 != nil:
    section.add "alt", valid_589177
  var valid_589178 = query.getOrDefault("oauth_token")
  valid_589178 = validateParameter(valid_589178, JString, required = false,
                                 default = nil)
  if valid_589178 != nil:
    section.add "oauth_token", valid_589178
  var valid_589179 = query.getOrDefault("userIp")
  valid_589179 = validateParameter(valid_589179, JString, required = false,
                                 default = nil)
  if valid_589179 != nil:
    section.add "userIp", valid_589179
  var valid_589180 = query.getOrDefault("key")
  valid_589180 = validateParameter(valid_589180, JString, required = false,
                                 default = nil)
  if valid_589180 != nil:
    section.add "key", valid_589180
  var valid_589181 = query.getOrDefault("prettyPrint")
  valid_589181 = validateParameter(valid_589181, JBool, required = false,
                                 default = newJBool(true))
  if valid_589181 != nil:
    section.add "prettyPrint", valid_589181
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589182: Call_DirectoryMobiledevicesDelete_589170; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Mobile Device
  ## 
  let valid = call_589182.validator(path, query, header, formData, body)
  let scheme = call_589182.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589182.url(scheme.get, call_589182.host, call_589182.base,
                         call_589182.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589182, url, valid)

proc call*(call_589183: Call_DirectoryMobiledevicesDelete_589170;
          customerId: string; resourceId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryMobiledevicesDelete
  ## Delete Mobile Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
  ##             : Immutable ID of Mobile Device
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589184 = newJObject()
  var query_589185 = newJObject()
  add(query_589185, "fields", newJString(fields))
  add(query_589185, "quotaUser", newJString(quotaUser))
  add(query_589185, "alt", newJString(alt))
  add(query_589185, "oauth_token", newJString(oauthToken))
  add(query_589185, "userIp", newJString(userIp))
  add(path_589184, "customerId", newJString(customerId))
  add(query_589185, "key", newJString(key))
  add(path_589184, "resourceId", newJString(resourceId))
  add(query_589185, "prettyPrint", newJBool(prettyPrint))
  result = call_589183.call(path_589184, query_589185, nil, nil, nil)

var directoryMobiledevicesDelete* = Call_DirectoryMobiledevicesDelete_589170(
    name: "directoryMobiledevicesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesDelete_589171,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesDelete_589172,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesAction_589186 = ref object of OpenApiRestCall_588466
proc url_DirectoryMobiledevicesAction_589188(protocol: Scheme; host: string;
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

proc validate_DirectoryMobiledevicesAction_589187(path: JsonNode; query: JsonNode;
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
  var valid_589189 = path.getOrDefault("customerId")
  valid_589189 = validateParameter(valid_589189, JString, required = true,
                                 default = nil)
  if valid_589189 != nil:
    section.add "customerId", valid_589189
  var valid_589190 = path.getOrDefault("resourceId")
  valid_589190 = validateParameter(valid_589190, JString, required = true,
                                 default = nil)
  if valid_589190 != nil:
    section.add "resourceId", valid_589190
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
  var valid_589191 = query.getOrDefault("fields")
  valid_589191 = validateParameter(valid_589191, JString, required = false,
                                 default = nil)
  if valid_589191 != nil:
    section.add "fields", valid_589191
  var valid_589192 = query.getOrDefault("quotaUser")
  valid_589192 = validateParameter(valid_589192, JString, required = false,
                                 default = nil)
  if valid_589192 != nil:
    section.add "quotaUser", valid_589192
  var valid_589193 = query.getOrDefault("alt")
  valid_589193 = validateParameter(valid_589193, JString, required = false,
                                 default = newJString("json"))
  if valid_589193 != nil:
    section.add "alt", valid_589193
  var valid_589194 = query.getOrDefault("oauth_token")
  valid_589194 = validateParameter(valid_589194, JString, required = false,
                                 default = nil)
  if valid_589194 != nil:
    section.add "oauth_token", valid_589194
  var valid_589195 = query.getOrDefault("userIp")
  valid_589195 = validateParameter(valid_589195, JString, required = false,
                                 default = nil)
  if valid_589195 != nil:
    section.add "userIp", valid_589195
  var valid_589196 = query.getOrDefault("key")
  valid_589196 = validateParameter(valid_589196, JString, required = false,
                                 default = nil)
  if valid_589196 != nil:
    section.add "key", valid_589196
  var valid_589197 = query.getOrDefault("prettyPrint")
  valid_589197 = validateParameter(valid_589197, JBool, required = false,
                                 default = newJBool(true))
  if valid_589197 != nil:
    section.add "prettyPrint", valid_589197
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

proc call*(call_589199: Call_DirectoryMobiledevicesAction_589186; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Mobile Device
  ## 
  let valid = call_589199.validator(path, query, header, formData, body)
  let scheme = call_589199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589199.url(scheme.get, call_589199.host, call_589199.base,
                         call_589199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589199, url, valid)

proc call*(call_589200: Call_DirectoryMobiledevicesAction_589186;
          customerId: string; resourceId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryMobiledevicesAction
  ## Take action on Mobile Device
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resourceId: string (required)
  ##             : Immutable ID of Mobile Device
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589201 = newJObject()
  var query_589202 = newJObject()
  var body_589203 = newJObject()
  add(query_589202, "fields", newJString(fields))
  add(query_589202, "quotaUser", newJString(quotaUser))
  add(query_589202, "alt", newJString(alt))
  add(query_589202, "oauth_token", newJString(oauthToken))
  add(query_589202, "userIp", newJString(userIp))
  add(path_589201, "customerId", newJString(customerId))
  add(query_589202, "key", newJString(key))
  add(path_589201, "resourceId", newJString(resourceId))
  if body != nil:
    body_589203 = body
  add(query_589202, "prettyPrint", newJBool(prettyPrint))
  result = call_589200.call(path_589201, query_589202, nil, nil, body_589203)

var directoryMobiledevicesAction* = Call_DirectoryMobiledevicesAction_589186(
    name: "directoryMobiledevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}/action",
    validator: validate_DirectoryMobiledevicesAction_589187,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesAction_589188,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsInsert_589221 = ref object of OpenApiRestCall_588466
proc url_DirectoryOrgunitsInsert_589223(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsInsert_589222(path: JsonNode; query: JsonNode;
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
  var valid_589224 = path.getOrDefault("customerId")
  valid_589224 = validateParameter(valid_589224, JString, required = true,
                                 default = nil)
  if valid_589224 != nil:
    section.add "customerId", valid_589224
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
  var valid_589225 = query.getOrDefault("fields")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "fields", valid_589225
  var valid_589226 = query.getOrDefault("quotaUser")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "quotaUser", valid_589226
  var valid_589227 = query.getOrDefault("alt")
  valid_589227 = validateParameter(valid_589227, JString, required = false,
                                 default = newJString("json"))
  if valid_589227 != nil:
    section.add "alt", valid_589227
  var valid_589228 = query.getOrDefault("oauth_token")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "oauth_token", valid_589228
  var valid_589229 = query.getOrDefault("userIp")
  valid_589229 = validateParameter(valid_589229, JString, required = false,
                                 default = nil)
  if valid_589229 != nil:
    section.add "userIp", valid_589229
  var valid_589230 = query.getOrDefault("key")
  valid_589230 = validateParameter(valid_589230, JString, required = false,
                                 default = nil)
  if valid_589230 != nil:
    section.add "key", valid_589230
  var valid_589231 = query.getOrDefault("prettyPrint")
  valid_589231 = validateParameter(valid_589231, JBool, required = false,
                                 default = newJBool(true))
  if valid_589231 != nil:
    section.add "prettyPrint", valid_589231
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

proc call*(call_589233: Call_DirectoryOrgunitsInsert_589221; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add organizational unit
  ## 
  let valid = call_589233.validator(path, query, header, formData, body)
  let scheme = call_589233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589233.url(scheme.get, call_589233.host, call_589233.base,
                         call_589233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589233, url, valid)

proc call*(call_589234: Call_DirectoryOrgunitsInsert_589221; customerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryOrgunitsInsert
  ## Add organizational unit
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589235 = newJObject()
  var query_589236 = newJObject()
  var body_589237 = newJObject()
  add(query_589236, "fields", newJString(fields))
  add(query_589236, "quotaUser", newJString(quotaUser))
  add(query_589236, "alt", newJString(alt))
  add(query_589236, "oauth_token", newJString(oauthToken))
  add(query_589236, "userIp", newJString(userIp))
  add(path_589235, "customerId", newJString(customerId))
  add(query_589236, "key", newJString(key))
  if body != nil:
    body_589237 = body
  add(query_589236, "prettyPrint", newJBool(prettyPrint))
  result = call_589234.call(path_589235, query_589236, nil, nil, body_589237)

var directoryOrgunitsInsert* = Call_DirectoryOrgunitsInsert_589221(
    name: "directoryOrgunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsInsert_589222,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsInsert_589223,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsList_589204 = ref object of OpenApiRestCall_588466
proc url_DirectoryOrgunitsList_589206(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsList_589205(path: JsonNode; query: JsonNode;
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
  var valid_589207 = path.getOrDefault("customerId")
  valid_589207 = validateParameter(valid_589207, JString, required = true,
                                 default = nil)
  if valid_589207 != nil:
    section.add "customerId", valid_589207
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   orgUnitPath: JString
  ##              : the URL-encoded organizational unit's path or its ID
  ##   type: JString
  ##       : Whether to return all sub-organizations or just immediate children
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589208 = query.getOrDefault("fields")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "fields", valid_589208
  var valid_589209 = query.getOrDefault("quotaUser")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "quotaUser", valid_589209
  var valid_589210 = query.getOrDefault("alt")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = newJString("json"))
  if valid_589210 != nil:
    section.add "alt", valid_589210
  var valid_589211 = query.getOrDefault("orgUnitPath")
  valid_589211 = validateParameter(valid_589211, JString, required = false,
                                 default = newJString(""))
  if valid_589211 != nil:
    section.add "orgUnitPath", valid_589211
  var valid_589212 = query.getOrDefault("type")
  valid_589212 = validateParameter(valid_589212, JString, required = false,
                                 default = newJString("all"))
  if valid_589212 != nil:
    section.add "type", valid_589212
  var valid_589213 = query.getOrDefault("oauth_token")
  valid_589213 = validateParameter(valid_589213, JString, required = false,
                                 default = nil)
  if valid_589213 != nil:
    section.add "oauth_token", valid_589213
  var valid_589214 = query.getOrDefault("userIp")
  valid_589214 = validateParameter(valid_589214, JString, required = false,
                                 default = nil)
  if valid_589214 != nil:
    section.add "userIp", valid_589214
  var valid_589215 = query.getOrDefault("key")
  valid_589215 = validateParameter(valid_589215, JString, required = false,
                                 default = nil)
  if valid_589215 != nil:
    section.add "key", valid_589215
  var valid_589216 = query.getOrDefault("prettyPrint")
  valid_589216 = validateParameter(valid_589216, JBool, required = false,
                                 default = newJBool(true))
  if valid_589216 != nil:
    section.add "prettyPrint", valid_589216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589217: Call_DirectoryOrgunitsList_589204; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all organizational units
  ## 
  let valid = call_589217.validator(path, query, header, formData, body)
  let scheme = call_589217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589217.url(scheme.get, call_589217.host, call_589217.base,
                         call_589217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589217, url, valid)

proc call*(call_589218: Call_DirectoryOrgunitsList_589204; customerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          orgUnitPath: string = ""; `type`: string = "all"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryOrgunitsList
  ## Retrieve all organizational units
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   orgUnitPath: string
  ##              : the URL-encoded organizational unit's path or its ID
  ##   type: string
  ##       : Whether to return all sub-organizations or just immediate children
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589219 = newJObject()
  var query_589220 = newJObject()
  add(query_589220, "fields", newJString(fields))
  add(query_589220, "quotaUser", newJString(quotaUser))
  add(query_589220, "alt", newJString(alt))
  add(query_589220, "orgUnitPath", newJString(orgUnitPath))
  add(query_589220, "type", newJString(`type`))
  add(query_589220, "oauth_token", newJString(oauthToken))
  add(query_589220, "userIp", newJString(userIp))
  add(path_589219, "customerId", newJString(customerId))
  add(query_589220, "key", newJString(key))
  add(query_589220, "prettyPrint", newJBool(prettyPrint))
  result = call_589218.call(path_589219, query_589220, nil, nil, nil)

var directoryOrgunitsList* = Call_DirectoryOrgunitsList_589204(
    name: "directoryOrgunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsList_589205, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsList_589206, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsUpdate_589254 = ref object of OpenApiRestCall_588466
proc url_DirectoryOrgunitsUpdate_589256(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsUpdate_589255(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Organization Unit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable id of the Google Apps account
  ##   orgUnitPath: JString (required)
  ##              : Full path of the organization unit or its Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_589257 = path.getOrDefault("customerId")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "customerId", valid_589257
  var valid_589258 = path.getOrDefault("orgUnitPath")
  valid_589258 = validateParameter(valid_589258, JString, required = true,
                                 default = nil)
  if valid_589258 != nil:
    section.add "orgUnitPath", valid_589258
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
  var valid_589259 = query.getOrDefault("fields")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "fields", valid_589259
  var valid_589260 = query.getOrDefault("quotaUser")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "quotaUser", valid_589260
  var valid_589261 = query.getOrDefault("alt")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = newJString("json"))
  if valid_589261 != nil:
    section.add "alt", valid_589261
  var valid_589262 = query.getOrDefault("oauth_token")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "oauth_token", valid_589262
  var valid_589263 = query.getOrDefault("userIp")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "userIp", valid_589263
  var valid_589264 = query.getOrDefault("key")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "key", valid_589264
  var valid_589265 = query.getOrDefault("prettyPrint")
  valid_589265 = validateParameter(valid_589265, JBool, required = false,
                                 default = newJBool(true))
  if valid_589265 != nil:
    section.add "prettyPrint", valid_589265
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

proc call*(call_589267: Call_DirectoryOrgunitsUpdate_589254; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit
  ## 
  let valid = call_589267.validator(path, query, header, formData, body)
  let scheme = call_589267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589267.url(scheme.get, call_589267.host, call_589267.base,
                         call_589267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589267, url, valid)

proc call*(call_589268: Call_DirectoryOrgunitsUpdate_589254; customerId: string;
          orgUnitPath: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryOrgunitsUpdate
  ## Update Organization Unit
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
  ##   customerId: string (required)
  ##             : Immutable id of the Google Apps account
  ##   orgUnitPath: string (required)
  ##              : Full path of the organization unit or its Id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589269 = newJObject()
  var query_589270 = newJObject()
  var body_589271 = newJObject()
  add(query_589270, "fields", newJString(fields))
  add(query_589270, "quotaUser", newJString(quotaUser))
  add(query_589270, "alt", newJString(alt))
  add(query_589270, "oauth_token", newJString(oauthToken))
  add(query_589270, "userIp", newJString(userIp))
  add(path_589269, "customerId", newJString(customerId))
  add(path_589269, "orgUnitPath", newJString(orgUnitPath))
  add(query_589270, "key", newJString(key))
  if body != nil:
    body_589271 = body
  add(query_589270, "prettyPrint", newJBool(prettyPrint))
  result = call_589268.call(path_589269, query_589270, nil, nil, body_589271)

var directoryOrgunitsUpdate* = Call_DirectoryOrgunitsUpdate_589254(
    name: "directoryOrgunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsUpdate_589255,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsUpdate_589256,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsGet_589238 = ref object of OpenApiRestCall_588466
proc url_DirectoryOrgunitsGet_589240(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsGet_589239(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieve Organization Unit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable id of the Google Apps account
  ##   orgUnitPath: JString (required)
  ##              : Full path of the organization unit or its Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_589241 = path.getOrDefault("customerId")
  valid_589241 = validateParameter(valid_589241, JString, required = true,
                                 default = nil)
  if valid_589241 != nil:
    section.add "customerId", valid_589241
  var valid_589242 = path.getOrDefault("orgUnitPath")
  valid_589242 = validateParameter(valid_589242, JString, required = true,
                                 default = nil)
  if valid_589242 != nil:
    section.add "orgUnitPath", valid_589242
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
  var valid_589243 = query.getOrDefault("fields")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "fields", valid_589243
  var valid_589244 = query.getOrDefault("quotaUser")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "quotaUser", valid_589244
  var valid_589245 = query.getOrDefault("alt")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = newJString("json"))
  if valid_589245 != nil:
    section.add "alt", valid_589245
  var valid_589246 = query.getOrDefault("oauth_token")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "oauth_token", valid_589246
  var valid_589247 = query.getOrDefault("userIp")
  valid_589247 = validateParameter(valid_589247, JString, required = false,
                                 default = nil)
  if valid_589247 != nil:
    section.add "userIp", valid_589247
  var valid_589248 = query.getOrDefault("key")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "key", valid_589248
  var valid_589249 = query.getOrDefault("prettyPrint")
  valid_589249 = validateParameter(valid_589249, JBool, required = false,
                                 default = newJBool(true))
  if valid_589249 != nil:
    section.add "prettyPrint", valid_589249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589250: Call_DirectoryOrgunitsGet_589238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Organization Unit
  ## 
  let valid = call_589250.validator(path, query, header, formData, body)
  let scheme = call_589250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589250.url(scheme.get, call_589250.host, call_589250.base,
                         call_589250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589250, url, valid)

proc call*(call_589251: Call_DirectoryOrgunitsGet_589238; customerId: string;
          orgUnitPath: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryOrgunitsGet
  ## Retrieve Organization Unit
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
  ##   customerId: string (required)
  ##             : Immutable id of the Google Apps account
  ##   orgUnitPath: string (required)
  ##              : Full path of the organization unit or its Id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589252 = newJObject()
  var query_589253 = newJObject()
  add(query_589253, "fields", newJString(fields))
  add(query_589253, "quotaUser", newJString(quotaUser))
  add(query_589253, "alt", newJString(alt))
  add(query_589253, "oauth_token", newJString(oauthToken))
  add(query_589253, "userIp", newJString(userIp))
  add(path_589252, "customerId", newJString(customerId))
  add(path_589252, "orgUnitPath", newJString(orgUnitPath))
  add(query_589253, "key", newJString(key))
  add(query_589253, "prettyPrint", newJBool(prettyPrint))
  result = call_589251.call(path_589252, query_589253, nil, nil, nil)

var directoryOrgunitsGet* = Call_DirectoryOrgunitsGet_589238(
    name: "directoryOrgunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsGet_589239, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsGet_589240, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsPatch_589288 = ref object of OpenApiRestCall_588466
proc url_DirectoryOrgunitsPatch_589290(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsPatch_589289(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update Organization Unit. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable id of the Google Apps account
  ##   orgUnitPath: JString (required)
  ##              : Full path of the organization unit or its Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_589291 = path.getOrDefault("customerId")
  valid_589291 = validateParameter(valid_589291, JString, required = true,
                                 default = nil)
  if valid_589291 != nil:
    section.add "customerId", valid_589291
  var valid_589292 = path.getOrDefault("orgUnitPath")
  valid_589292 = validateParameter(valid_589292, JString, required = true,
                                 default = nil)
  if valid_589292 != nil:
    section.add "orgUnitPath", valid_589292
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
  var valid_589293 = query.getOrDefault("fields")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "fields", valid_589293
  var valid_589294 = query.getOrDefault("quotaUser")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "quotaUser", valid_589294
  var valid_589295 = query.getOrDefault("alt")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = newJString("json"))
  if valid_589295 != nil:
    section.add "alt", valid_589295
  var valid_589296 = query.getOrDefault("oauth_token")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "oauth_token", valid_589296
  var valid_589297 = query.getOrDefault("userIp")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "userIp", valid_589297
  var valid_589298 = query.getOrDefault("key")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = nil)
  if valid_589298 != nil:
    section.add "key", valid_589298
  var valid_589299 = query.getOrDefault("prettyPrint")
  valid_589299 = validateParameter(valid_589299, JBool, required = false,
                                 default = newJBool(true))
  if valid_589299 != nil:
    section.add "prettyPrint", valid_589299
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

proc call*(call_589301: Call_DirectoryOrgunitsPatch_589288; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit. This method supports patch semantics.
  ## 
  let valid = call_589301.validator(path, query, header, formData, body)
  let scheme = call_589301.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589301.url(scheme.get, call_589301.host, call_589301.base,
                         call_589301.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589301, url, valid)

proc call*(call_589302: Call_DirectoryOrgunitsPatch_589288; customerId: string;
          orgUnitPath: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryOrgunitsPatch
  ## Update Organization Unit. This method supports patch semantics.
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
  ##   customerId: string (required)
  ##             : Immutable id of the Google Apps account
  ##   orgUnitPath: string (required)
  ##              : Full path of the organization unit or its Id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589303 = newJObject()
  var query_589304 = newJObject()
  var body_589305 = newJObject()
  add(query_589304, "fields", newJString(fields))
  add(query_589304, "quotaUser", newJString(quotaUser))
  add(query_589304, "alt", newJString(alt))
  add(query_589304, "oauth_token", newJString(oauthToken))
  add(query_589304, "userIp", newJString(userIp))
  add(path_589303, "customerId", newJString(customerId))
  add(path_589303, "orgUnitPath", newJString(orgUnitPath))
  add(query_589304, "key", newJString(key))
  if body != nil:
    body_589305 = body
  add(query_589304, "prettyPrint", newJBool(prettyPrint))
  result = call_589302.call(path_589303, query_589304, nil, nil, body_589305)

var directoryOrgunitsPatch* = Call_DirectoryOrgunitsPatch_589288(
    name: "directoryOrgunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsPatch_589289,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsPatch_589290,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsDelete_589272 = ref object of OpenApiRestCall_588466
proc url_DirectoryOrgunitsDelete_589274(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsDelete_589273(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove Organization Unit
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   customerId: JString (required)
  ##             : Immutable id of the Google Apps account
  ##   orgUnitPath: JString (required)
  ##              : Full path of the organization unit or its Id
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `customerId` field"
  var valid_589275 = path.getOrDefault("customerId")
  valid_589275 = validateParameter(valid_589275, JString, required = true,
                                 default = nil)
  if valid_589275 != nil:
    section.add "customerId", valid_589275
  var valid_589276 = path.getOrDefault("orgUnitPath")
  valid_589276 = validateParameter(valid_589276, JString, required = true,
                                 default = nil)
  if valid_589276 != nil:
    section.add "orgUnitPath", valid_589276
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
  var valid_589277 = query.getOrDefault("fields")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "fields", valid_589277
  var valid_589278 = query.getOrDefault("quotaUser")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "quotaUser", valid_589278
  var valid_589279 = query.getOrDefault("alt")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = newJString("json"))
  if valid_589279 != nil:
    section.add "alt", valid_589279
  var valid_589280 = query.getOrDefault("oauth_token")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = nil)
  if valid_589280 != nil:
    section.add "oauth_token", valid_589280
  var valid_589281 = query.getOrDefault("userIp")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "userIp", valid_589281
  var valid_589282 = query.getOrDefault("key")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "key", valid_589282
  var valid_589283 = query.getOrDefault("prettyPrint")
  valid_589283 = validateParameter(valid_589283, JBool, required = false,
                                 default = newJBool(true))
  if valid_589283 != nil:
    section.add "prettyPrint", valid_589283
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589284: Call_DirectoryOrgunitsDelete_589272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove Organization Unit
  ## 
  let valid = call_589284.validator(path, query, header, formData, body)
  let scheme = call_589284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589284.url(scheme.get, call_589284.host, call_589284.base,
                         call_589284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589284, url, valid)

proc call*(call_589285: Call_DirectoryOrgunitsDelete_589272; customerId: string;
          orgUnitPath: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryOrgunitsDelete
  ## Remove Organization Unit
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
  ##   customerId: string (required)
  ##             : Immutable id of the Google Apps account
  ##   orgUnitPath: string (required)
  ##              : Full path of the organization unit or its Id
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589286 = newJObject()
  var query_589287 = newJObject()
  add(query_589287, "fields", newJString(fields))
  add(query_589287, "quotaUser", newJString(quotaUser))
  add(query_589287, "alt", newJString(alt))
  add(query_589287, "oauth_token", newJString(oauthToken))
  add(query_589287, "userIp", newJString(userIp))
  add(path_589286, "customerId", newJString(customerId))
  add(path_589286, "orgUnitPath", newJString(orgUnitPath))
  add(query_589287, "key", newJString(key))
  add(query_589287, "prettyPrint", newJBool(prettyPrint))
  result = call_589285.call(path_589286, query_589287, nil, nil, nil)

var directoryOrgunitsDelete* = Call_DirectoryOrgunitsDelete_589272(
    name: "directoryOrgunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsDelete_589273,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsDelete_589274,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasInsert_589321 = ref object of OpenApiRestCall_588466
proc url_DirectorySchemasInsert_589323(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasInsert_589322(path: JsonNode; query: JsonNode;
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
  var valid_589324 = path.getOrDefault("customerId")
  valid_589324 = validateParameter(valid_589324, JString, required = true,
                                 default = nil)
  if valid_589324 != nil:
    section.add "customerId", valid_589324
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
  var valid_589325 = query.getOrDefault("fields")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "fields", valid_589325
  var valid_589326 = query.getOrDefault("quotaUser")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "quotaUser", valid_589326
  var valid_589327 = query.getOrDefault("alt")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = newJString("json"))
  if valid_589327 != nil:
    section.add "alt", valid_589327
  var valid_589328 = query.getOrDefault("oauth_token")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "oauth_token", valid_589328
  var valid_589329 = query.getOrDefault("userIp")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "userIp", valid_589329
  var valid_589330 = query.getOrDefault("key")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "key", valid_589330
  var valid_589331 = query.getOrDefault("prettyPrint")
  valid_589331 = validateParameter(valid_589331, JBool, required = false,
                                 default = newJBool(true))
  if valid_589331 != nil:
    section.add "prettyPrint", valid_589331
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

proc call*(call_589333: Call_DirectorySchemasInsert_589321; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create schema.
  ## 
  let valid = call_589333.validator(path, query, header, formData, body)
  let scheme = call_589333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589333.url(scheme.get, call_589333.host, call_589333.base,
                         call_589333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589333, url, valid)

proc call*(call_589334: Call_DirectorySchemasInsert_589321; customerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directorySchemasInsert
  ## Create schema.
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589335 = newJObject()
  var query_589336 = newJObject()
  var body_589337 = newJObject()
  add(query_589336, "fields", newJString(fields))
  add(query_589336, "quotaUser", newJString(quotaUser))
  add(query_589336, "alt", newJString(alt))
  add(query_589336, "oauth_token", newJString(oauthToken))
  add(query_589336, "userIp", newJString(userIp))
  add(path_589335, "customerId", newJString(customerId))
  add(query_589336, "key", newJString(key))
  if body != nil:
    body_589337 = body
  add(query_589336, "prettyPrint", newJBool(prettyPrint))
  result = call_589334.call(path_589335, query_589336, nil, nil, body_589337)

var directorySchemasInsert* = Call_DirectorySchemasInsert_589321(
    name: "directorySchemasInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasInsert_589322,
    base: "/admin/directory/v1", url: url_DirectorySchemasInsert_589323,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasList_589306 = ref object of OpenApiRestCall_588466
proc url_DirectorySchemasList_589308(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasList_589307(path: JsonNode; query: JsonNode;
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
  var valid_589309 = path.getOrDefault("customerId")
  valid_589309 = validateParameter(valid_589309, JString, required = true,
                                 default = nil)
  if valid_589309 != nil:
    section.add "customerId", valid_589309
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
  var valid_589310 = query.getOrDefault("fields")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "fields", valid_589310
  var valid_589311 = query.getOrDefault("quotaUser")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = nil)
  if valid_589311 != nil:
    section.add "quotaUser", valid_589311
  var valid_589312 = query.getOrDefault("alt")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = newJString("json"))
  if valid_589312 != nil:
    section.add "alt", valid_589312
  var valid_589313 = query.getOrDefault("oauth_token")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "oauth_token", valid_589313
  var valid_589314 = query.getOrDefault("userIp")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "userIp", valid_589314
  var valid_589315 = query.getOrDefault("key")
  valid_589315 = validateParameter(valid_589315, JString, required = false,
                                 default = nil)
  if valid_589315 != nil:
    section.add "key", valid_589315
  var valid_589316 = query.getOrDefault("prettyPrint")
  valid_589316 = validateParameter(valid_589316, JBool, required = false,
                                 default = newJBool(true))
  if valid_589316 != nil:
    section.add "prettyPrint", valid_589316
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589317: Call_DirectorySchemasList_589306; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all schemas for a customer
  ## 
  let valid = call_589317.validator(path, query, header, formData, body)
  let scheme = call_589317.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589317.url(scheme.get, call_589317.host, call_589317.base,
                         call_589317.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589317, url, valid)

proc call*(call_589318: Call_DirectorySchemasList_589306; customerId: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directorySchemasList
  ## Retrieve all schemas for a customer
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
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589319 = newJObject()
  var query_589320 = newJObject()
  add(query_589320, "fields", newJString(fields))
  add(query_589320, "quotaUser", newJString(quotaUser))
  add(query_589320, "alt", newJString(alt))
  add(query_589320, "oauth_token", newJString(oauthToken))
  add(query_589320, "userIp", newJString(userIp))
  add(path_589319, "customerId", newJString(customerId))
  add(query_589320, "key", newJString(key))
  add(query_589320, "prettyPrint", newJBool(prettyPrint))
  result = call_589318.call(path_589319, query_589320, nil, nil, nil)

var directorySchemasList* = Call_DirectorySchemasList_589306(
    name: "directorySchemasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasList_589307, base: "/admin/directory/v1",
    url: url_DirectorySchemasList_589308, schemes: {Scheme.Https})
type
  Call_DirectorySchemasUpdate_589354 = ref object of OpenApiRestCall_588466
proc url_DirectorySchemasUpdate_589356(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasUpdate_589355(path: JsonNode; query: JsonNode;
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
  var valid_589357 = path.getOrDefault("schemaKey")
  valid_589357 = validateParameter(valid_589357, JString, required = true,
                                 default = nil)
  if valid_589357 != nil:
    section.add "schemaKey", valid_589357
  var valid_589358 = path.getOrDefault("customerId")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "customerId", valid_589358
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
  var valid_589359 = query.getOrDefault("fields")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "fields", valid_589359
  var valid_589360 = query.getOrDefault("quotaUser")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "quotaUser", valid_589360
  var valid_589361 = query.getOrDefault("alt")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = newJString("json"))
  if valid_589361 != nil:
    section.add "alt", valid_589361
  var valid_589362 = query.getOrDefault("oauth_token")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "oauth_token", valid_589362
  var valid_589363 = query.getOrDefault("userIp")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = nil)
  if valid_589363 != nil:
    section.add "userIp", valid_589363
  var valid_589364 = query.getOrDefault("key")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "key", valid_589364
  var valid_589365 = query.getOrDefault("prettyPrint")
  valid_589365 = validateParameter(valid_589365, JBool, required = false,
                                 default = newJBool(true))
  if valid_589365 != nil:
    section.add "prettyPrint", valid_589365
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

proc call*(call_589367: Call_DirectorySchemasUpdate_589354; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema
  ## 
  let valid = call_589367.validator(path, query, header, formData, body)
  let scheme = call_589367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589367.url(scheme.get, call_589367.host, call_589367.base,
                         call_589367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589367, url, valid)

proc call*(call_589368: Call_DirectorySchemasUpdate_589354; schemaKey: string;
          customerId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directorySchemasUpdate
  ## Update schema
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   schemaKey: string (required)
  ##            : Name or immutable ID of the schema.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589369 = newJObject()
  var query_589370 = newJObject()
  var body_589371 = newJObject()
  add(query_589370, "fields", newJString(fields))
  add(query_589370, "quotaUser", newJString(quotaUser))
  add(query_589370, "alt", newJString(alt))
  add(path_589369, "schemaKey", newJString(schemaKey))
  add(query_589370, "oauth_token", newJString(oauthToken))
  add(query_589370, "userIp", newJString(userIp))
  add(path_589369, "customerId", newJString(customerId))
  add(query_589370, "key", newJString(key))
  if body != nil:
    body_589371 = body
  add(query_589370, "prettyPrint", newJBool(prettyPrint))
  result = call_589368.call(path_589369, query_589370, nil, nil, body_589371)

var directorySchemasUpdate* = Call_DirectorySchemasUpdate_589354(
    name: "directorySchemasUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasUpdate_589355,
    base: "/admin/directory/v1", url: url_DirectorySchemasUpdate_589356,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasGet_589338 = ref object of OpenApiRestCall_588466
proc url_DirectorySchemasGet_589340(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasGet_589339(path: JsonNode; query: JsonNode;
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
  var valid_589341 = path.getOrDefault("schemaKey")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "schemaKey", valid_589341
  var valid_589342 = path.getOrDefault("customerId")
  valid_589342 = validateParameter(valid_589342, JString, required = true,
                                 default = nil)
  if valid_589342 != nil:
    section.add "customerId", valid_589342
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
  var valid_589343 = query.getOrDefault("fields")
  valid_589343 = validateParameter(valid_589343, JString, required = false,
                                 default = nil)
  if valid_589343 != nil:
    section.add "fields", valid_589343
  var valid_589344 = query.getOrDefault("quotaUser")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "quotaUser", valid_589344
  var valid_589345 = query.getOrDefault("alt")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = newJString("json"))
  if valid_589345 != nil:
    section.add "alt", valid_589345
  var valid_589346 = query.getOrDefault("oauth_token")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = nil)
  if valid_589346 != nil:
    section.add "oauth_token", valid_589346
  var valid_589347 = query.getOrDefault("userIp")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "userIp", valid_589347
  var valid_589348 = query.getOrDefault("key")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "key", valid_589348
  var valid_589349 = query.getOrDefault("prettyPrint")
  valid_589349 = validateParameter(valid_589349, JBool, required = false,
                                 default = newJBool(true))
  if valid_589349 != nil:
    section.add "prettyPrint", valid_589349
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589350: Call_DirectorySchemasGet_589338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve schema
  ## 
  let valid = call_589350.validator(path, query, header, formData, body)
  let scheme = call_589350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589350.url(scheme.get, call_589350.host, call_589350.base,
                         call_589350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589350, url, valid)

proc call*(call_589351: Call_DirectorySchemasGet_589338; schemaKey: string;
          customerId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directorySchemasGet
  ## Retrieve schema
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   schemaKey: string (required)
  ##            : Name or immutable ID of the schema
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589352 = newJObject()
  var query_589353 = newJObject()
  add(query_589353, "fields", newJString(fields))
  add(query_589353, "quotaUser", newJString(quotaUser))
  add(query_589353, "alt", newJString(alt))
  add(path_589352, "schemaKey", newJString(schemaKey))
  add(query_589353, "oauth_token", newJString(oauthToken))
  add(query_589353, "userIp", newJString(userIp))
  add(path_589352, "customerId", newJString(customerId))
  add(query_589353, "key", newJString(key))
  add(query_589353, "prettyPrint", newJBool(prettyPrint))
  result = call_589351.call(path_589352, query_589353, nil, nil, nil)

var directorySchemasGet* = Call_DirectorySchemasGet_589338(
    name: "directorySchemasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasGet_589339, base: "/admin/directory/v1",
    url: url_DirectorySchemasGet_589340, schemes: {Scheme.Https})
type
  Call_DirectorySchemasPatch_589388 = ref object of OpenApiRestCall_588466
proc url_DirectorySchemasPatch_589390(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasPatch_589389(path: JsonNode; query: JsonNode;
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
  var valid_589391 = path.getOrDefault("schemaKey")
  valid_589391 = validateParameter(valid_589391, JString, required = true,
                                 default = nil)
  if valid_589391 != nil:
    section.add "schemaKey", valid_589391
  var valid_589392 = path.getOrDefault("customerId")
  valid_589392 = validateParameter(valid_589392, JString, required = true,
                                 default = nil)
  if valid_589392 != nil:
    section.add "customerId", valid_589392
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
  var valid_589393 = query.getOrDefault("fields")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = nil)
  if valid_589393 != nil:
    section.add "fields", valid_589393
  var valid_589394 = query.getOrDefault("quotaUser")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "quotaUser", valid_589394
  var valid_589395 = query.getOrDefault("alt")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = newJString("json"))
  if valid_589395 != nil:
    section.add "alt", valid_589395
  var valid_589396 = query.getOrDefault("oauth_token")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "oauth_token", valid_589396
  var valid_589397 = query.getOrDefault("userIp")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "userIp", valid_589397
  var valid_589398 = query.getOrDefault("key")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "key", valid_589398
  var valid_589399 = query.getOrDefault("prettyPrint")
  valid_589399 = validateParameter(valid_589399, JBool, required = false,
                                 default = newJBool(true))
  if valid_589399 != nil:
    section.add "prettyPrint", valid_589399
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

proc call*(call_589401: Call_DirectorySchemasPatch_589388; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema. This method supports patch semantics.
  ## 
  let valid = call_589401.validator(path, query, header, formData, body)
  let scheme = call_589401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589401.url(scheme.get, call_589401.host, call_589401.base,
                         call_589401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589401, url, valid)

proc call*(call_589402: Call_DirectorySchemasPatch_589388; schemaKey: string;
          customerId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directorySchemasPatch
  ## Update schema. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   schemaKey: string (required)
  ##            : Name or immutable ID of the schema.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589403 = newJObject()
  var query_589404 = newJObject()
  var body_589405 = newJObject()
  add(query_589404, "fields", newJString(fields))
  add(query_589404, "quotaUser", newJString(quotaUser))
  add(query_589404, "alt", newJString(alt))
  add(path_589403, "schemaKey", newJString(schemaKey))
  add(query_589404, "oauth_token", newJString(oauthToken))
  add(query_589404, "userIp", newJString(userIp))
  add(path_589403, "customerId", newJString(customerId))
  add(query_589404, "key", newJString(key))
  if body != nil:
    body_589405 = body
  add(query_589404, "prettyPrint", newJBool(prettyPrint))
  result = call_589402.call(path_589403, query_589404, nil, nil, body_589405)

var directorySchemasPatch* = Call_DirectorySchemasPatch_589388(
    name: "directorySchemasPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasPatch_589389, base: "/admin/directory/v1",
    url: url_DirectorySchemasPatch_589390, schemes: {Scheme.Https})
type
  Call_DirectorySchemasDelete_589372 = ref object of OpenApiRestCall_588466
proc url_DirectorySchemasDelete_589374(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasDelete_589373(path: JsonNode; query: JsonNode;
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
  var valid_589375 = path.getOrDefault("schemaKey")
  valid_589375 = validateParameter(valid_589375, JString, required = true,
                                 default = nil)
  if valid_589375 != nil:
    section.add "schemaKey", valid_589375
  var valid_589376 = path.getOrDefault("customerId")
  valid_589376 = validateParameter(valid_589376, JString, required = true,
                                 default = nil)
  if valid_589376 != nil:
    section.add "customerId", valid_589376
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
  var valid_589377 = query.getOrDefault("fields")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "fields", valid_589377
  var valid_589378 = query.getOrDefault("quotaUser")
  valid_589378 = validateParameter(valid_589378, JString, required = false,
                                 default = nil)
  if valid_589378 != nil:
    section.add "quotaUser", valid_589378
  var valid_589379 = query.getOrDefault("alt")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = newJString("json"))
  if valid_589379 != nil:
    section.add "alt", valid_589379
  var valid_589380 = query.getOrDefault("oauth_token")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "oauth_token", valid_589380
  var valid_589381 = query.getOrDefault("userIp")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "userIp", valid_589381
  var valid_589382 = query.getOrDefault("key")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = nil)
  if valid_589382 != nil:
    section.add "key", valid_589382
  var valid_589383 = query.getOrDefault("prettyPrint")
  valid_589383 = validateParameter(valid_589383, JBool, required = false,
                                 default = newJBool(true))
  if valid_589383 != nil:
    section.add "prettyPrint", valid_589383
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589384: Call_DirectorySchemasDelete_589372; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schema
  ## 
  let valid = call_589384.validator(path, query, header, formData, body)
  let scheme = call_589384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589384.url(scheme.get, call_589384.host, call_589384.base,
                         call_589384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589384, url, valid)

proc call*(call_589385: Call_DirectorySchemasDelete_589372; schemaKey: string;
          customerId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directorySchemasDelete
  ## Delete schema
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   schemaKey: string (required)
  ##            : Name or immutable ID of the schema
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   customerId: string (required)
  ##             : Immutable ID of the G Suite account
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589386 = newJObject()
  var query_589387 = newJObject()
  add(query_589387, "fields", newJString(fields))
  add(query_589387, "quotaUser", newJString(quotaUser))
  add(query_589387, "alt", newJString(alt))
  add(path_589386, "schemaKey", newJString(schemaKey))
  add(query_589387, "oauth_token", newJString(oauthToken))
  add(query_589387, "userIp", newJString(userIp))
  add(path_589386, "customerId", newJString(customerId))
  add(query_589387, "key", newJString(key))
  add(query_589387, "prettyPrint", newJBool(prettyPrint))
  result = call_589385.call(path_589386, query_589387, nil, nil, nil)

var directorySchemasDelete* = Call_DirectorySchemasDelete_589372(
    name: "directorySchemasDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasDelete_589373,
    base: "/admin/directory/v1", url: url_DirectorySchemasDelete_589374,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesInsert_589422 = ref object of OpenApiRestCall_588466
proc url_DirectoryDomainAliasesInsert_589424(protocol: Scheme; host: string;
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

proc validate_DirectoryDomainAliasesInsert_589423(path: JsonNode; query: JsonNode;
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
  var valid_589425 = path.getOrDefault("customer")
  valid_589425 = validateParameter(valid_589425, JString, required = true,
                                 default = nil)
  if valid_589425 != nil:
    section.add "customer", valid_589425
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
  var valid_589426 = query.getOrDefault("fields")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "fields", valid_589426
  var valid_589427 = query.getOrDefault("quotaUser")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "quotaUser", valid_589427
  var valid_589428 = query.getOrDefault("alt")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = newJString("json"))
  if valid_589428 != nil:
    section.add "alt", valid_589428
  var valid_589429 = query.getOrDefault("oauth_token")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "oauth_token", valid_589429
  var valid_589430 = query.getOrDefault("userIp")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "userIp", valid_589430
  var valid_589431 = query.getOrDefault("key")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "key", valid_589431
  var valid_589432 = query.getOrDefault("prettyPrint")
  valid_589432 = validateParameter(valid_589432, JBool, required = false,
                                 default = newJBool(true))
  if valid_589432 != nil:
    section.add "prettyPrint", valid_589432
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

proc call*(call_589434: Call_DirectoryDomainAliasesInsert_589422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a Domain alias of the customer.
  ## 
  let valid = call_589434.validator(path, query, header, formData, body)
  let scheme = call_589434.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589434.url(scheme.get, call_589434.host, call_589434.base,
                         call_589434.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589434, url, valid)

proc call*(call_589435: Call_DirectoryDomainAliasesInsert_589422; customer: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryDomainAliasesInsert
  ## Inserts a Domain alias of the customer.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589436 = newJObject()
  var query_589437 = newJObject()
  var body_589438 = newJObject()
  add(query_589437, "fields", newJString(fields))
  add(query_589437, "quotaUser", newJString(quotaUser))
  add(query_589437, "alt", newJString(alt))
  add(query_589437, "oauth_token", newJString(oauthToken))
  add(query_589437, "userIp", newJString(userIp))
  add(query_589437, "key", newJString(key))
  add(path_589436, "customer", newJString(customer))
  if body != nil:
    body_589438 = body
  add(query_589437, "prettyPrint", newJBool(prettyPrint))
  result = call_589435.call(path_589436, query_589437, nil, nil, body_589438)

var directoryDomainAliasesInsert* = Call_DirectoryDomainAliasesInsert_589422(
    name: "directoryDomainAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesInsert_589423,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesInsert_589424,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesList_589406 = ref object of OpenApiRestCall_588466
proc url_DirectoryDomainAliasesList_589408(protocol: Scheme; host: string;
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

proc validate_DirectoryDomainAliasesList_589407(path: JsonNode; query: JsonNode;
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
  var valid_589409 = path.getOrDefault("customer")
  valid_589409 = validateParameter(valid_589409, JString, required = true,
                                 default = nil)
  if valid_589409 != nil:
    section.add "customer", valid_589409
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   parentDomainName: JString
  ##                   : Name of the parent domain for which domain aliases are to be fetched.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589410 = query.getOrDefault("fields")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = nil)
  if valid_589410 != nil:
    section.add "fields", valid_589410
  var valid_589411 = query.getOrDefault("quotaUser")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "quotaUser", valid_589411
  var valid_589412 = query.getOrDefault("alt")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = newJString("json"))
  if valid_589412 != nil:
    section.add "alt", valid_589412
  var valid_589413 = query.getOrDefault("parentDomainName")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "parentDomainName", valid_589413
  var valid_589414 = query.getOrDefault("oauth_token")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "oauth_token", valid_589414
  var valid_589415 = query.getOrDefault("userIp")
  valid_589415 = validateParameter(valid_589415, JString, required = false,
                                 default = nil)
  if valid_589415 != nil:
    section.add "userIp", valid_589415
  var valid_589416 = query.getOrDefault("key")
  valid_589416 = validateParameter(valid_589416, JString, required = false,
                                 default = nil)
  if valid_589416 != nil:
    section.add "key", valid_589416
  var valid_589417 = query.getOrDefault("prettyPrint")
  valid_589417 = validateParameter(valid_589417, JBool, required = false,
                                 default = newJBool(true))
  if valid_589417 != nil:
    section.add "prettyPrint", valid_589417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589418: Call_DirectoryDomainAliasesList_589406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domain aliases of the customer.
  ## 
  let valid = call_589418.validator(path, query, header, formData, body)
  let scheme = call_589418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589418.url(scheme.get, call_589418.host, call_589418.base,
                         call_589418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589418, url, valid)

proc call*(call_589419: Call_DirectoryDomainAliasesList_589406; customer: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          parentDomainName: string = ""; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryDomainAliasesList
  ## Lists the domain aliases of the customer.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   parentDomainName: string
  ##                   : Name of the parent domain for which domain aliases are to be fetched.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589420 = newJObject()
  var query_589421 = newJObject()
  add(query_589421, "fields", newJString(fields))
  add(query_589421, "quotaUser", newJString(quotaUser))
  add(query_589421, "alt", newJString(alt))
  add(query_589421, "parentDomainName", newJString(parentDomainName))
  add(query_589421, "oauth_token", newJString(oauthToken))
  add(query_589421, "userIp", newJString(userIp))
  add(query_589421, "key", newJString(key))
  add(path_589420, "customer", newJString(customer))
  add(query_589421, "prettyPrint", newJBool(prettyPrint))
  result = call_589419.call(path_589420, query_589421, nil, nil, nil)

var directoryDomainAliasesList* = Call_DirectoryDomainAliasesList_589406(
    name: "directoryDomainAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesList_589407,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesList_589408,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesGet_589439 = ref object of OpenApiRestCall_588466
proc url_DirectoryDomainAliasesGet_589441(protocol: Scheme; host: string;
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

proc validate_DirectoryDomainAliasesGet_589440(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a domain alias of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   domainAliasName: JString (required)
  ##                  : Name of domain alias to be retrieved.
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `domainAliasName` field"
  var valid_589442 = path.getOrDefault("domainAliasName")
  valid_589442 = validateParameter(valid_589442, JString, required = true,
                                 default = nil)
  if valid_589442 != nil:
    section.add "domainAliasName", valid_589442
  var valid_589443 = path.getOrDefault("customer")
  valid_589443 = validateParameter(valid_589443, JString, required = true,
                                 default = nil)
  if valid_589443 != nil:
    section.add "customer", valid_589443
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
  var valid_589444 = query.getOrDefault("fields")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "fields", valid_589444
  var valid_589445 = query.getOrDefault("quotaUser")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = nil)
  if valid_589445 != nil:
    section.add "quotaUser", valid_589445
  var valid_589446 = query.getOrDefault("alt")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = newJString("json"))
  if valid_589446 != nil:
    section.add "alt", valid_589446
  var valid_589447 = query.getOrDefault("oauth_token")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "oauth_token", valid_589447
  var valid_589448 = query.getOrDefault("userIp")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "userIp", valid_589448
  var valid_589449 = query.getOrDefault("key")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "key", valid_589449
  var valid_589450 = query.getOrDefault("prettyPrint")
  valid_589450 = validateParameter(valid_589450, JBool, required = false,
                                 default = newJBool(true))
  if valid_589450 != nil:
    section.add "prettyPrint", valid_589450
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589451: Call_DirectoryDomainAliasesGet_589439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain alias of the customer.
  ## 
  let valid = call_589451.validator(path, query, header, formData, body)
  let scheme = call_589451.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589451.url(scheme.get, call_589451.host, call_589451.base,
                         call_589451.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589451, url, valid)

proc call*(call_589452: Call_DirectoryDomainAliasesGet_589439;
          domainAliasName: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryDomainAliasesGet
  ## Retrieves a domain alias of the customer.
  ##   domainAliasName: string (required)
  ##                  : Name of domain alias to be retrieved.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589453 = newJObject()
  var query_589454 = newJObject()
  add(path_589453, "domainAliasName", newJString(domainAliasName))
  add(query_589454, "fields", newJString(fields))
  add(query_589454, "quotaUser", newJString(quotaUser))
  add(query_589454, "alt", newJString(alt))
  add(query_589454, "oauth_token", newJString(oauthToken))
  add(query_589454, "userIp", newJString(userIp))
  add(query_589454, "key", newJString(key))
  add(path_589453, "customer", newJString(customer))
  add(query_589454, "prettyPrint", newJBool(prettyPrint))
  result = call_589452.call(path_589453, query_589454, nil, nil, nil)

var directoryDomainAliasesGet* = Call_DirectoryDomainAliasesGet_589439(
    name: "directoryDomainAliasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesGet_589440,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesGet_589441,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesDelete_589455 = ref object of OpenApiRestCall_588466
proc url_DirectoryDomainAliasesDelete_589457(protocol: Scheme; host: string;
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

proc validate_DirectoryDomainAliasesDelete_589456(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a Domain Alias of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   domainAliasName: JString (required)
  ##                  : Name of domain alias to be retrieved.
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `domainAliasName` field"
  var valid_589458 = path.getOrDefault("domainAliasName")
  valid_589458 = validateParameter(valid_589458, JString, required = true,
                                 default = nil)
  if valid_589458 != nil:
    section.add "domainAliasName", valid_589458
  var valid_589459 = path.getOrDefault("customer")
  valid_589459 = validateParameter(valid_589459, JString, required = true,
                                 default = nil)
  if valid_589459 != nil:
    section.add "customer", valid_589459
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
  var valid_589460 = query.getOrDefault("fields")
  valid_589460 = validateParameter(valid_589460, JString, required = false,
                                 default = nil)
  if valid_589460 != nil:
    section.add "fields", valid_589460
  var valid_589461 = query.getOrDefault("quotaUser")
  valid_589461 = validateParameter(valid_589461, JString, required = false,
                                 default = nil)
  if valid_589461 != nil:
    section.add "quotaUser", valid_589461
  var valid_589462 = query.getOrDefault("alt")
  valid_589462 = validateParameter(valid_589462, JString, required = false,
                                 default = newJString("json"))
  if valid_589462 != nil:
    section.add "alt", valid_589462
  var valid_589463 = query.getOrDefault("oauth_token")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "oauth_token", valid_589463
  var valid_589464 = query.getOrDefault("userIp")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "userIp", valid_589464
  var valid_589465 = query.getOrDefault("key")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = nil)
  if valid_589465 != nil:
    section.add "key", valid_589465
  var valid_589466 = query.getOrDefault("prettyPrint")
  valid_589466 = validateParameter(valid_589466, JBool, required = false,
                                 default = newJBool(true))
  if valid_589466 != nil:
    section.add "prettyPrint", valid_589466
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589467: Call_DirectoryDomainAliasesDelete_589455; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Domain Alias of the customer.
  ## 
  let valid = call_589467.validator(path, query, header, formData, body)
  let scheme = call_589467.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589467.url(scheme.get, call_589467.host, call_589467.base,
                         call_589467.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589467, url, valid)

proc call*(call_589468: Call_DirectoryDomainAliasesDelete_589455;
          domainAliasName: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryDomainAliasesDelete
  ## Deletes a Domain Alias of the customer.
  ##   domainAliasName: string (required)
  ##                  : Name of domain alias to be retrieved.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589469 = newJObject()
  var query_589470 = newJObject()
  add(path_589469, "domainAliasName", newJString(domainAliasName))
  add(query_589470, "fields", newJString(fields))
  add(query_589470, "quotaUser", newJString(quotaUser))
  add(query_589470, "alt", newJString(alt))
  add(query_589470, "oauth_token", newJString(oauthToken))
  add(query_589470, "userIp", newJString(userIp))
  add(query_589470, "key", newJString(key))
  add(path_589469, "customer", newJString(customer))
  add(query_589470, "prettyPrint", newJBool(prettyPrint))
  result = call_589468.call(path_589469, query_589470, nil, nil, nil)

var directoryDomainAliasesDelete* = Call_DirectoryDomainAliasesDelete_589455(
    name: "directoryDomainAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesDelete_589456,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesDelete_589457,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsInsert_589486 = ref object of OpenApiRestCall_588466
proc url_DirectoryDomainsInsert_589488(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryDomainsInsert_589487(path: JsonNode; query: JsonNode;
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
  var valid_589489 = path.getOrDefault("customer")
  valid_589489 = validateParameter(valid_589489, JString, required = true,
                                 default = nil)
  if valid_589489 != nil:
    section.add "customer", valid_589489
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
  var valid_589490 = query.getOrDefault("fields")
  valid_589490 = validateParameter(valid_589490, JString, required = false,
                                 default = nil)
  if valid_589490 != nil:
    section.add "fields", valid_589490
  var valid_589491 = query.getOrDefault("quotaUser")
  valid_589491 = validateParameter(valid_589491, JString, required = false,
                                 default = nil)
  if valid_589491 != nil:
    section.add "quotaUser", valid_589491
  var valid_589492 = query.getOrDefault("alt")
  valid_589492 = validateParameter(valid_589492, JString, required = false,
                                 default = newJString("json"))
  if valid_589492 != nil:
    section.add "alt", valid_589492
  var valid_589493 = query.getOrDefault("oauth_token")
  valid_589493 = validateParameter(valid_589493, JString, required = false,
                                 default = nil)
  if valid_589493 != nil:
    section.add "oauth_token", valid_589493
  var valid_589494 = query.getOrDefault("userIp")
  valid_589494 = validateParameter(valid_589494, JString, required = false,
                                 default = nil)
  if valid_589494 != nil:
    section.add "userIp", valid_589494
  var valid_589495 = query.getOrDefault("key")
  valid_589495 = validateParameter(valid_589495, JString, required = false,
                                 default = nil)
  if valid_589495 != nil:
    section.add "key", valid_589495
  var valid_589496 = query.getOrDefault("prettyPrint")
  valid_589496 = validateParameter(valid_589496, JBool, required = false,
                                 default = newJBool(true))
  if valid_589496 != nil:
    section.add "prettyPrint", valid_589496
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

proc call*(call_589498: Call_DirectoryDomainsInsert_589486; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a domain of the customer.
  ## 
  let valid = call_589498.validator(path, query, header, formData, body)
  let scheme = call_589498.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589498.url(scheme.get, call_589498.host, call_589498.base,
                         call_589498.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589498, url, valid)

proc call*(call_589499: Call_DirectoryDomainsInsert_589486; customer: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryDomainsInsert
  ## Inserts a domain of the customer.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589500 = newJObject()
  var query_589501 = newJObject()
  var body_589502 = newJObject()
  add(query_589501, "fields", newJString(fields))
  add(query_589501, "quotaUser", newJString(quotaUser))
  add(query_589501, "alt", newJString(alt))
  add(query_589501, "oauth_token", newJString(oauthToken))
  add(query_589501, "userIp", newJString(userIp))
  add(query_589501, "key", newJString(key))
  add(path_589500, "customer", newJString(customer))
  if body != nil:
    body_589502 = body
  add(query_589501, "prettyPrint", newJBool(prettyPrint))
  result = call_589499.call(path_589500, query_589501, nil, nil, body_589502)

var directoryDomainsInsert* = Call_DirectoryDomainsInsert_589486(
    name: "directoryDomainsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsInsert_589487,
    base: "/admin/directory/v1", url: url_DirectoryDomainsInsert_589488,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsList_589471 = ref object of OpenApiRestCall_588466
proc url_DirectoryDomainsList_589473(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryDomainsList_589472(path: JsonNode; query: JsonNode;
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
  var valid_589474 = path.getOrDefault("customer")
  valid_589474 = validateParameter(valid_589474, JString, required = true,
                                 default = nil)
  if valid_589474 != nil:
    section.add "customer", valid_589474
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
  var valid_589475 = query.getOrDefault("fields")
  valid_589475 = validateParameter(valid_589475, JString, required = false,
                                 default = nil)
  if valid_589475 != nil:
    section.add "fields", valid_589475
  var valid_589476 = query.getOrDefault("quotaUser")
  valid_589476 = validateParameter(valid_589476, JString, required = false,
                                 default = nil)
  if valid_589476 != nil:
    section.add "quotaUser", valid_589476
  var valid_589477 = query.getOrDefault("alt")
  valid_589477 = validateParameter(valid_589477, JString, required = false,
                                 default = newJString("json"))
  if valid_589477 != nil:
    section.add "alt", valid_589477
  var valid_589478 = query.getOrDefault("oauth_token")
  valid_589478 = validateParameter(valid_589478, JString, required = false,
                                 default = nil)
  if valid_589478 != nil:
    section.add "oauth_token", valid_589478
  var valid_589479 = query.getOrDefault("userIp")
  valid_589479 = validateParameter(valid_589479, JString, required = false,
                                 default = nil)
  if valid_589479 != nil:
    section.add "userIp", valid_589479
  var valid_589480 = query.getOrDefault("key")
  valid_589480 = validateParameter(valid_589480, JString, required = false,
                                 default = nil)
  if valid_589480 != nil:
    section.add "key", valid_589480
  var valid_589481 = query.getOrDefault("prettyPrint")
  valid_589481 = validateParameter(valid_589481, JBool, required = false,
                                 default = newJBool(true))
  if valid_589481 != nil:
    section.add "prettyPrint", valid_589481
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589482: Call_DirectoryDomainsList_589471; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domains of the customer.
  ## 
  let valid = call_589482.validator(path, query, header, formData, body)
  let scheme = call_589482.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589482.url(scheme.get, call_589482.host, call_589482.base,
                         call_589482.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589482, url, valid)

proc call*(call_589483: Call_DirectoryDomainsList_589471; customer: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryDomainsList
  ## Lists the domains of the customer.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589484 = newJObject()
  var query_589485 = newJObject()
  add(query_589485, "fields", newJString(fields))
  add(query_589485, "quotaUser", newJString(quotaUser))
  add(query_589485, "alt", newJString(alt))
  add(query_589485, "oauth_token", newJString(oauthToken))
  add(query_589485, "userIp", newJString(userIp))
  add(query_589485, "key", newJString(key))
  add(path_589484, "customer", newJString(customer))
  add(query_589485, "prettyPrint", newJBool(prettyPrint))
  result = call_589483.call(path_589484, query_589485, nil, nil, nil)

var directoryDomainsList* = Call_DirectoryDomainsList_589471(
    name: "directoryDomainsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsList_589472, base: "/admin/directory/v1",
    url: url_DirectoryDomainsList_589473, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsGet_589503 = ref object of OpenApiRestCall_588466
proc url_DirectoryDomainsGet_589505(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryDomainsGet_589504(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieves a domain of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   domainName: JString (required)
  ##             : Name of domain to be retrieved
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `domainName` field"
  var valid_589506 = path.getOrDefault("domainName")
  valid_589506 = validateParameter(valid_589506, JString, required = true,
                                 default = nil)
  if valid_589506 != nil:
    section.add "domainName", valid_589506
  var valid_589507 = path.getOrDefault("customer")
  valid_589507 = validateParameter(valid_589507, JString, required = true,
                                 default = nil)
  if valid_589507 != nil:
    section.add "customer", valid_589507
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
  var valid_589508 = query.getOrDefault("fields")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "fields", valid_589508
  var valid_589509 = query.getOrDefault("quotaUser")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = nil)
  if valid_589509 != nil:
    section.add "quotaUser", valid_589509
  var valid_589510 = query.getOrDefault("alt")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = newJString("json"))
  if valid_589510 != nil:
    section.add "alt", valid_589510
  var valid_589511 = query.getOrDefault("oauth_token")
  valid_589511 = validateParameter(valid_589511, JString, required = false,
                                 default = nil)
  if valid_589511 != nil:
    section.add "oauth_token", valid_589511
  var valid_589512 = query.getOrDefault("userIp")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "userIp", valid_589512
  var valid_589513 = query.getOrDefault("key")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "key", valid_589513
  var valid_589514 = query.getOrDefault("prettyPrint")
  valid_589514 = validateParameter(valid_589514, JBool, required = false,
                                 default = newJBool(true))
  if valid_589514 != nil:
    section.add "prettyPrint", valid_589514
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589515: Call_DirectoryDomainsGet_589503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain of the customer.
  ## 
  let valid = call_589515.validator(path, query, header, formData, body)
  let scheme = call_589515.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589515.url(scheme.get, call_589515.host, call_589515.base,
                         call_589515.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589515, url, valid)

proc call*(call_589516: Call_DirectoryDomainsGet_589503; domainName: string;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryDomainsGet
  ## Retrieves a domain of the customer.
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
  ##   domainName: string (required)
  ##             : Name of domain to be retrieved
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589517 = newJObject()
  var query_589518 = newJObject()
  add(query_589518, "fields", newJString(fields))
  add(query_589518, "quotaUser", newJString(quotaUser))
  add(query_589518, "alt", newJString(alt))
  add(query_589518, "oauth_token", newJString(oauthToken))
  add(query_589518, "userIp", newJString(userIp))
  add(query_589518, "key", newJString(key))
  add(path_589517, "domainName", newJString(domainName))
  add(path_589517, "customer", newJString(customer))
  add(query_589518, "prettyPrint", newJBool(prettyPrint))
  result = call_589516.call(path_589517, query_589518, nil, nil, nil)

var directoryDomainsGet* = Call_DirectoryDomainsGet_589503(
    name: "directoryDomainsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsGet_589504, base: "/admin/directory/v1",
    url: url_DirectoryDomainsGet_589505, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsDelete_589519 = ref object of OpenApiRestCall_588466
proc url_DirectoryDomainsDelete_589521(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryDomainsDelete_589520(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a domain of the customer.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   domainName: JString (required)
  ##             : Name of domain to be deleted
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `domainName` field"
  var valid_589522 = path.getOrDefault("domainName")
  valid_589522 = validateParameter(valid_589522, JString, required = true,
                                 default = nil)
  if valid_589522 != nil:
    section.add "domainName", valid_589522
  var valid_589523 = path.getOrDefault("customer")
  valid_589523 = validateParameter(valid_589523, JString, required = true,
                                 default = nil)
  if valid_589523 != nil:
    section.add "customer", valid_589523
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
  var valid_589524 = query.getOrDefault("fields")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "fields", valid_589524
  var valid_589525 = query.getOrDefault("quotaUser")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "quotaUser", valid_589525
  var valid_589526 = query.getOrDefault("alt")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = newJString("json"))
  if valid_589526 != nil:
    section.add "alt", valid_589526
  var valid_589527 = query.getOrDefault("oauth_token")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = nil)
  if valid_589527 != nil:
    section.add "oauth_token", valid_589527
  var valid_589528 = query.getOrDefault("userIp")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "userIp", valid_589528
  var valid_589529 = query.getOrDefault("key")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "key", valid_589529
  var valid_589530 = query.getOrDefault("prettyPrint")
  valid_589530 = validateParameter(valid_589530, JBool, required = false,
                                 default = newJBool(true))
  if valid_589530 != nil:
    section.add "prettyPrint", valid_589530
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589531: Call_DirectoryDomainsDelete_589519; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a domain of the customer.
  ## 
  let valid = call_589531.validator(path, query, header, formData, body)
  let scheme = call_589531.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589531.url(scheme.get, call_589531.host, call_589531.base,
                         call_589531.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589531, url, valid)

proc call*(call_589532: Call_DirectoryDomainsDelete_589519; domainName: string;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryDomainsDelete
  ## Deletes a domain of the customer.
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
  ##   domainName: string (required)
  ##             : Name of domain to be deleted
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589533 = newJObject()
  var query_589534 = newJObject()
  add(query_589534, "fields", newJString(fields))
  add(query_589534, "quotaUser", newJString(quotaUser))
  add(query_589534, "alt", newJString(alt))
  add(query_589534, "oauth_token", newJString(oauthToken))
  add(query_589534, "userIp", newJString(userIp))
  add(query_589534, "key", newJString(key))
  add(path_589533, "domainName", newJString(domainName))
  add(path_589533, "customer", newJString(customer))
  add(query_589534, "prettyPrint", newJBool(prettyPrint))
  result = call_589532.call(path_589533, query_589534, nil, nil, nil)

var directoryDomainsDelete* = Call_DirectoryDomainsDelete_589519(
    name: "directoryDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsDelete_589520,
    base: "/admin/directory/v1", url: url_DirectoryDomainsDelete_589521,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsList_589535 = ref object of OpenApiRestCall_588466
proc url_DirectoryNotificationsList_589537(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsList_589536(path: JsonNode; query: JsonNode;
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
  var valid_589538 = path.getOrDefault("customer")
  valid_589538 = validateParameter(valid_589538, JString, required = true,
                                 default = nil)
  if valid_589538 != nil:
    section.add "customer", valid_589538
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The token to specify the page of results to retrieve.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   language: JString
  ##           : The ISO 639-1 code of the language notifications are returned in. The default is English (en).
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of notifications to return per page. The default is 100.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589539 = query.getOrDefault("fields")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "fields", valid_589539
  var valid_589540 = query.getOrDefault("pageToken")
  valid_589540 = validateParameter(valid_589540, JString, required = false,
                                 default = nil)
  if valid_589540 != nil:
    section.add "pageToken", valid_589540
  var valid_589541 = query.getOrDefault("quotaUser")
  valid_589541 = validateParameter(valid_589541, JString, required = false,
                                 default = nil)
  if valid_589541 != nil:
    section.add "quotaUser", valid_589541
  var valid_589542 = query.getOrDefault("alt")
  valid_589542 = validateParameter(valid_589542, JString, required = false,
                                 default = newJString("json"))
  if valid_589542 != nil:
    section.add "alt", valid_589542
  var valid_589543 = query.getOrDefault("language")
  valid_589543 = validateParameter(valid_589543, JString, required = false,
                                 default = nil)
  if valid_589543 != nil:
    section.add "language", valid_589543
  var valid_589544 = query.getOrDefault("oauth_token")
  valid_589544 = validateParameter(valid_589544, JString, required = false,
                                 default = nil)
  if valid_589544 != nil:
    section.add "oauth_token", valid_589544
  var valid_589545 = query.getOrDefault("userIp")
  valid_589545 = validateParameter(valid_589545, JString, required = false,
                                 default = nil)
  if valid_589545 != nil:
    section.add "userIp", valid_589545
  var valid_589546 = query.getOrDefault("maxResults")
  valid_589546 = validateParameter(valid_589546, JInt, required = false, default = nil)
  if valid_589546 != nil:
    section.add "maxResults", valid_589546
  var valid_589547 = query.getOrDefault("key")
  valid_589547 = validateParameter(valid_589547, JString, required = false,
                                 default = nil)
  if valid_589547 != nil:
    section.add "key", valid_589547
  var valid_589548 = query.getOrDefault("prettyPrint")
  valid_589548 = validateParameter(valid_589548, JBool, required = false,
                                 default = newJBool(true))
  if valid_589548 != nil:
    section.add "prettyPrint", valid_589548
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589549: Call_DirectoryNotificationsList_589535; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notifications.
  ## 
  let valid = call_589549.validator(path, query, header, formData, body)
  let scheme = call_589549.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589549.url(scheme.get, call_589549.host, call_589549.base,
                         call_589549.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589549, url, valid)

proc call*(call_589550: Call_DirectoryNotificationsList_589535; customer: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; language: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryNotificationsList
  ## Retrieves a list of notifications.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The token to specify the page of results to retrieve.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   language: string
  ##           : The ISO 639-1 code of the language notifications are returned in. The default is English (en).
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of notifications to return per page. The default is 100.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589551 = newJObject()
  var query_589552 = newJObject()
  add(query_589552, "fields", newJString(fields))
  add(query_589552, "pageToken", newJString(pageToken))
  add(query_589552, "quotaUser", newJString(quotaUser))
  add(query_589552, "alt", newJString(alt))
  add(query_589552, "language", newJString(language))
  add(query_589552, "oauth_token", newJString(oauthToken))
  add(query_589552, "userIp", newJString(userIp))
  add(query_589552, "maxResults", newJInt(maxResults))
  add(query_589552, "key", newJString(key))
  add(path_589551, "customer", newJString(customer))
  add(query_589552, "prettyPrint", newJBool(prettyPrint))
  result = call_589550.call(path_589551, query_589552, nil, nil, nil)

var directoryNotificationsList* = Call_DirectoryNotificationsList_589535(
    name: "directoryNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/notifications",
    validator: validate_DirectoryNotificationsList_589536,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsList_589537,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsUpdate_589569 = ref object of OpenApiRestCall_588466
proc url_DirectoryNotificationsUpdate_589571(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsUpdate_589570(path: JsonNode; query: JsonNode;
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
  var valid_589572 = path.getOrDefault("notificationId")
  valid_589572 = validateParameter(valid_589572, JString, required = true,
                                 default = nil)
  if valid_589572 != nil:
    section.add "notificationId", valid_589572
  var valid_589573 = path.getOrDefault("customer")
  valid_589573 = validateParameter(valid_589573, JString, required = true,
                                 default = nil)
  if valid_589573 != nil:
    section.add "customer", valid_589573
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
  var valid_589574 = query.getOrDefault("fields")
  valid_589574 = validateParameter(valid_589574, JString, required = false,
                                 default = nil)
  if valid_589574 != nil:
    section.add "fields", valid_589574
  var valid_589575 = query.getOrDefault("quotaUser")
  valid_589575 = validateParameter(valid_589575, JString, required = false,
                                 default = nil)
  if valid_589575 != nil:
    section.add "quotaUser", valid_589575
  var valid_589576 = query.getOrDefault("alt")
  valid_589576 = validateParameter(valid_589576, JString, required = false,
                                 default = newJString("json"))
  if valid_589576 != nil:
    section.add "alt", valid_589576
  var valid_589577 = query.getOrDefault("oauth_token")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "oauth_token", valid_589577
  var valid_589578 = query.getOrDefault("userIp")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "userIp", valid_589578
  var valid_589579 = query.getOrDefault("key")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "key", valid_589579
  var valid_589580 = query.getOrDefault("prettyPrint")
  valid_589580 = validateParameter(valid_589580, JBool, required = false,
                                 default = newJBool(true))
  if valid_589580 != nil:
    section.add "prettyPrint", valid_589580
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

proc call*(call_589582: Call_DirectoryNotificationsUpdate_589569; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification.
  ## 
  let valid = call_589582.validator(path, query, header, formData, body)
  let scheme = call_589582.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589582.url(scheme.get, call_589582.host, call_589582.base,
                         call_589582.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589582, url, valid)

proc call*(call_589583: Call_DirectoryNotificationsUpdate_589569;
          notificationId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryNotificationsUpdate
  ## Updates a notification.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   notificationId: string (required)
  ##                 : The unique ID of the notification.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589584 = newJObject()
  var query_589585 = newJObject()
  var body_589586 = newJObject()
  add(query_589585, "fields", newJString(fields))
  add(query_589585, "quotaUser", newJString(quotaUser))
  add(query_589585, "alt", newJString(alt))
  add(path_589584, "notificationId", newJString(notificationId))
  add(query_589585, "oauth_token", newJString(oauthToken))
  add(query_589585, "userIp", newJString(userIp))
  add(query_589585, "key", newJString(key))
  add(path_589584, "customer", newJString(customer))
  if body != nil:
    body_589586 = body
  add(query_589585, "prettyPrint", newJBool(prettyPrint))
  result = call_589583.call(path_589584, query_589585, nil, nil, body_589586)

var directoryNotificationsUpdate* = Call_DirectoryNotificationsUpdate_589569(
    name: "directoryNotificationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsUpdate_589570,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsUpdate_589571,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsGet_589553 = ref object of OpenApiRestCall_588466
proc url_DirectoryNotificationsGet_589555(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsGet_589554(path: JsonNode; query: JsonNode;
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
  var valid_589556 = path.getOrDefault("notificationId")
  valid_589556 = validateParameter(valid_589556, JString, required = true,
                                 default = nil)
  if valid_589556 != nil:
    section.add "notificationId", valid_589556
  var valid_589557 = path.getOrDefault("customer")
  valid_589557 = validateParameter(valid_589557, JString, required = true,
                                 default = nil)
  if valid_589557 != nil:
    section.add "customer", valid_589557
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
  var valid_589558 = query.getOrDefault("fields")
  valid_589558 = validateParameter(valid_589558, JString, required = false,
                                 default = nil)
  if valid_589558 != nil:
    section.add "fields", valid_589558
  var valid_589559 = query.getOrDefault("quotaUser")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "quotaUser", valid_589559
  var valid_589560 = query.getOrDefault("alt")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = newJString("json"))
  if valid_589560 != nil:
    section.add "alt", valid_589560
  var valid_589561 = query.getOrDefault("oauth_token")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = nil)
  if valid_589561 != nil:
    section.add "oauth_token", valid_589561
  var valid_589562 = query.getOrDefault("userIp")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "userIp", valid_589562
  var valid_589563 = query.getOrDefault("key")
  valid_589563 = validateParameter(valid_589563, JString, required = false,
                                 default = nil)
  if valid_589563 != nil:
    section.add "key", valid_589563
  var valid_589564 = query.getOrDefault("prettyPrint")
  valid_589564 = validateParameter(valid_589564, JBool, required = false,
                                 default = newJBool(true))
  if valid_589564 != nil:
    section.add "prettyPrint", valid_589564
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589565: Call_DirectoryNotificationsGet_589553; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a notification.
  ## 
  let valid = call_589565.validator(path, query, header, formData, body)
  let scheme = call_589565.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589565.url(scheme.get, call_589565.host, call_589565.base,
                         call_589565.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589565, url, valid)

proc call*(call_589566: Call_DirectoryNotificationsGet_589553;
          notificationId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryNotificationsGet
  ## Retrieves a notification.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   notificationId: string (required)
  ##                 : The unique ID of the notification.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. The customerId is also returned as part of the Users resource.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589567 = newJObject()
  var query_589568 = newJObject()
  add(query_589568, "fields", newJString(fields))
  add(query_589568, "quotaUser", newJString(quotaUser))
  add(query_589568, "alt", newJString(alt))
  add(path_589567, "notificationId", newJString(notificationId))
  add(query_589568, "oauth_token", newJString(oauthToken))
  add(query_589568, "userIp", newJString(userIp))
  add(query_589568, "key", newJString(key))
  add(path_589567, "customer", newJString(customer))
  add(query_589568, "prettyPrint", newJBool(prettyPrint))
  result = call_589566.call(path_589567, query_589568, nil, nil, nil)

var directoryNotificationsGet* = Call_DirectoryNotificationsGet_589553(
    name: "directoryNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsGet_589554,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsGet_589555,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsPatch_589603 = ref object of OpenApiRestCall_588466
proc url_DirectoryNotificationsPatch_589605(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsPatch_589604(path: JsonNode; query: JsonNode;
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
  var valid_589606 = path.getOrDefault("notificationId")
  valid_589606 = validateParameter(valid_589606, JString, required = true,
                                 default = nil)
  if valid_589606 != nil:
    section.add "notificationId", valid_589606
  var valid_589607 = path.getOrDefault("customer")
  valid_589607 = validateParameter(valid_589607, JString, required = true,
                                 default = nil)
  if valid_589607 != nil:
    section.add "customer", valid_589607
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
  var valid_589608 = query.getOrDefault("fields")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = nil)
  if valid_589608 != nil:
    section.add "fields", valid_589608
  var valid_589609 = query.getOrDefault("quotaUser")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "quotaUser", valid_589609
  var valid_589610 = query.getOrDefault("alt")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = newJString("json"))
  if valid_589610 != nil:
    section.add "alt", valid_589610
  var valid_589611 = query.getOrDefault("oauth_token")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = nil)
  if valid_589611 != nil:
    section.add "oauth_token", valid_589611
  var valid_589612 = query.getOrDefault("userIp")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "userIp", valid_589612
  var valid_589613 = query.getOrDefault("key")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "key", valid_589613
  var valid_589614 = query.getOrDefault("prettyPrint")
  valid_589614 = validateParameter(valid_589614, JBool, required = false,
                                 default = newJBool(true))
  if valid_589614 != nil:
    section.add "prettyPrint", valid_589614
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

proc call*(call_589616: Call_DirectoryNotificationsPatch_589603; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification. This method supports patch semantics.
  ## 
  let valid = call_589616.validator(path, query, header, formData, body)
  let scheme = call_589616.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589616.url(scheme.get, call_589616.host, call_589616.base,
                         call_589616.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589616, url, valid)

proc call*(call_589617: Call_DirectoryNotificationsPatch_589603;
          notificationId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryNotificationsPatch
  ## Updates a notification. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   notificationId: string (required)
  ##                 : The unique ID of the notification.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589618 = newJObject()
  var query_589619 = newJObject()
  var body_589620 = newJObject()
  add(query_589619, "fields", newJString(fields))
  add(query_589619, "quotaUser", newJString(quotaUser))
  add(query_589619, "alt", newJString(alt))
  add(path_589618, "notificationId", newJString(notificationId))
  add(query_589619, "oauth_token", newJString(oauthToken))
  add(query_589619, "userIp", newJString(userIp))
  add(query_589619, "key", newJString(key))
  add(path_589618, "customer", newJString(customer))
  if body != nil:
    body_589620 = body
  add(query_589619, "prettyPrint", newJBool(prettyPrint))
  result = call_589617.call(path_589618, query_589619, nil, nil, body_589620)

var directoryNotificationsPatch* = Call_DirectoryNotificationsPatch_589603(
    name: "directoryNotificationsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsPatch_589604,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsPatch_589605,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsDelete_589587 = ref object of OpenApiRestCall_588466
proc url_DirectoryNotificationsDelete_589589(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsDelete_589588(path: JsonNode; query: JsonNode;
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
  var valid_589590 = path.getOrDefault("notificationId")
  valid_589590 = validateParameter(valid_589590, JString, required = true,
                                 default = nil)
  if valid_589590 != nil:
    section.add "notificationId", valid_589590
  var valid_589591 = path.getOrDefault("customer")
  valid_589591 = validateParameter(valid_589591, JString, required = true,
                                 default = nil)
  if valid_589591 != nil:
    section.add "customer", valid_589591
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
  var valid_589592 = query.getOrDefault("fields")
  valid_589592 = validateParameter(valid_589592, JString, required = false,
                                 default = nil)
  if valid_589592 != nil:
    section.add "fields", valid_589592
  var valid_589593 = query.getOrDefault("quotaUser")
  valid_589593 = validateParameter(valid_589593, JString, required = false,
                                 default = nil)
  if valid_589593 != nil:
    section.add "quotaUser", valid_589593
  var valid_589594 = query.getOrDefault("alt")
  valid_589594 = validateParameter(valid_589594, JString, required = false,
                                 default = newJString("json"))
  if valid_589594 != nil:
    section.add "alt", valid_589594
  var valid_589595 = query.getOrDefault("oauth_token")
  valid_589595 = validateParameter(valid_589595, JString, required = false,
                                 default = nil)
  if valid_589595 != nil:
    section.add "oauth_token", valid_589595
  var valid_589596 = query.getOrDefault("userIp")
  valid_589596 = validateParameter(valid_589596, JString, required = false,
                                 default = nil)
  if valid_589596 != nil:
    section.add "userIp", valid_589596
  var valid_589597 = query.getOrDefault("key")
  valid_589597 = validateParameter(valid_589597, JString, required = false,
                                 default = nil)
  if valid_589597 != nil:
    section.add "key", valid_589597
  var valid_589598 = query.getOrDefault("prettyPrint")
  valid_589598 = validateParameter(valid_589598, JBool, required = false,
                                 default = newJBool(true))
  if valid_589598 != nil:
    section.add "prettyPrint", valid_589598
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589599: Call_DirectoryNotificationsDelete_589587; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a notification
  ## 
  let valid = call_589599.validator(path, query, header, formData, body)
  let scheme = call_589599.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589599.url(scheme.get, call_589599.host, call_589599.base,
                         call_589599.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589599, url, valid)

proc call*(call_589600: Call_DirectoryNotificationsDelete_589587;
          notificationId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryNotificationsDelete
  ## Deletes a notification
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   notificationId: string (required)
  ##                 : The unique ID of the notification.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. The customerId is also returned as part of the Users resource.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589601 = newJObject()
  var query_589602 = newJObject()
  add(query_589602, "fields", newJString(fields))
  add(query_589602, "quotaUser", newJString(quotaUser))
  add(query_589602, "alt", newJString(alt))
  add(path_589601, "notificationId", newJString(notificationId))
  add(query_589602, "oauth_token", newJString(oauthToken))
  add(query_589602, "userIp", newJString(userIp))
  add(query_589602, "key", newJString(key))
  add(path_589601, "customer", newJString(customer))
  add(query_589602, "prettyPrint", newJBool(prettyPrint))
  result = call_589600.call(path_589601, query_589602, nil, nil, nil)

var directoryNotificationsDelete* = Call_DirectoryNotificationsDelete_589587(
    name: "directoryNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsDelete_589588,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsDelete_589589,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsInsert_589638 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesBuildingsInsert_589640(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsInsert_589639(path: JsonNode;
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
  var valid_589641 = path.getOrDefault("customer")
  valid_589641 = validateParameter(valid_589641, JString, required = true,
                                 default = nil)
  if valid_589641 != nil:
    section.add "customer", valid_589641
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   coordinatesSource: JString
  ##                    : Source from which Building.coordinates are derived.
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
  var valid_589642 = query.getOrDefault("fields")
  valid_589642 = validateParameter(valid_589642, JString, required = false,
                                 default = nil)
  if valid_589642 != nil:
    section.add "fields", valid_589642
  var valid_589643 = query.getOrDefault("quotaUser")
  valid_589643 = validateParameter(valid_589643, JString, required = false,
                                 default = nil)
  if valid_589643 != nil:
    section.add "quotaUser", valid_589643
  var valid_589644 = query.getOrDefault("coordinatesSource")
  valid_589644 = validateParameter(valid_589644, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_589644 != nil:
    section.add "coordinatesSource", valid_589644
  var valid_589645 = query.getOrDefault("alt")
  valid_589645 = validateParameter(valid_589645, JString, required = false,
                                 default = newJString("json"))
  if valid_589645 != nil:
    section.add "alt", valid_589645
  var valid_589646 = query.getOrDefault("oauth_token")
  valid_589646 = validateParameter(valid_589646, JString, required = false,
                                 default = nil)
  if valid_589646 != nil:
    section.add "oauth_token", valid_589646
  var valid_589647 = query.getOrDefault("userIp")
  valid_589647 = validateParameter(valid_589647, JString, required = false,
                                 default = nil)
  if valid_589647 != nil:
    section.add "userIp", valid_589647
  var valid_589648 = query.getOrDefault("key")
  valid_589648 = validateParameter(valid_589648, JString, required = false,
                                 default = nil)
  if valid_589648 != nil:
    section.add "key", valid_589648
  var valid_589649 = query.getOrDefault("prettyPrint")
  valid_589649 = validateParameter(valid_589649, JBool, required = false,
                                 default = newJBool(true))
  if valid_589649 != nil:
    section.add "prettyPrint", valid_589649
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

proc call*(call_589651: Call_DirectoryResourcesBuildingsInsert_589638;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a building.
  ## 
  let valid = call_589651.validator(path, query, header, formData, body)
  let scheme = call_589651.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589651.url(scheme.get, call_589651.host, call_589651.base,
                         call_589651.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589651, url, valid)

proc call*(call_589652: Call_DirectoryResourcesBuildingsInsert_589638;
          customer: string; fields: string = ""; quotaUser: string = "";
          coordinatesSource: string = "SOURCE_UNSPECIFIED"; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryResourcesBuildingsInsert
  ## Inserts a building.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   coordinatesSource: string
  ##                    : Source from which Building.coordinates are derived.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589653 = newJObject()
  var query_589654 = newJObject()
  var body_589655 = newJObject()
  add(query_589654, "fields", newJString(fields))
  add(query_589654, "quotaUser", newJString(quotaUser))
  add(query_589654, "coordinatesSource", newJString(coordinatesSource))
  add(query_589654, "alt", newJString(alt))
  add(query_589654, "oauth_token", newJString(oauthToken))
  add(query_589654, "userIp", newJString(userIp))
  add(query_589654, "key", newJString(key))
  add(path_589653, "customer", newJString(customer))
  if body != nil:
    body_589655 = body
  add(query_589654, "prettyPrint", newJBool(prettyPrint))
  result = call_589652.call(path_589653, query_589654, nil, nil, body_589655)

var directoryResourcesBuildingsInsert* = Call_DirectoryResourcesBuildingsInsert_589638(
    name: "directoryResourcesBuildingsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsInsert_589639,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsInsert_589640,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsList_589621 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesBuildingsList_589623(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsList_589622(path: JsonNode;
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
  var valid_589624 = path.getOrDefault("customer")
  valid_589624 = validateParameter(valid_589624, JString, required = true,
                                 default = nil)
  if valid_589624 != nil:
    section.add "customer", valid_589624
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589625 = query.getOrDefault("fields")
  valid_589625 = validateParameter(valid_589625, JString, required = false,
                                 default = nil)
  if valid_589625 != nil:
    section.add "fields", valid_589625
  var valid_589626 = query.getOrDefault("pageToken")
  valid_589626 = validateParameter(valid_589626, JString, required = false,
                                 default = nil)
  if valid_589626 != nil:
    section.add "pageToken", valid_589626
  var valid_589627 = query.getOrDefault("quotaUser")
  valid_589627 = validateParameter(valid_589627, JString, required = false,
                                 default = nil)
  if valid_589627 != nil:
    section.add "quotaUser", valid_589627
  var valid_589628 = query.getOrDefault("alt")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = newJString("json"))
  if valid_589628 != nil:
    section.add "alt", valid_589628
  var valid_589629 = query.getOrDefault("oauth_token")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "oauth_token", valid_589629
  var valid_589630 = query.getOrDefault("userIp")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "userIp", valid_589630
  var valid_589631 = query.getOrDefault("maxResults")
  valid_589631 = validateParameter(valid_589631, JInt, required = false, default = nil)
  if valid_589631 != nil:
    section.add "maxResults", valid_589631
  var valid_589632 = query.getOrDefault("key")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "key", valid_589632
  var valid_589633 = query.getOrDefault("prettyPrint")
  valid_589633 = validateParameter(valid_589633, JBool, required = false,
                                 default = newJBool(true))
  if valid_589633 != nil:
    section.add "prettyPrint", valid_589633
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589634: Call_DirectoryResourcesBuildingsList_589621;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of buildings for an account.
  ## 
  let valid = call_589634.validator(path, query, header, formData, body)
  let scheme = call_589634.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589634.url(scheme.get, call_589634.host, call_589634.base,
                         call_589634.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589634, url, valid)

proc call*(call_589635: Call_DirectoryResourcesBuildingsList_589621;
          customer: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryResourcesBuildingsList
  ## Retrieves a list of buildings for an account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589636 = newJObject()
  var query_589637 = newJObject()
  add(query_589637, "fields", newJString(fields))
  add(query_589637, "pageToken", newJString(pageToken))
  add(query_589637, "quotaUser", newJString(quotaUser))
  add(query_589637, "alt", newJString(alt))
  add(query_589637, "oauth_token", newJString(oauthToken))
  add(query_589637, "userIp", newJString(userIp))
  add(query_589637, "maxResults", newJInt(maxResults))
  add(query_589637, "key", newJString(key))
  add(path_589636, "customer", newJString(customer))
  add(query_589637, "prettyPrint", newJBool(prettyPrint))
  result = call_589635.call(path_589636, query_589637, nil, nil, nil)

var directoryResourcesBuildingsList* = Call_DirectoryResourcesBuildingsList_589621(
    name: "directoryResourcesBuildingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsList_589622,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsList_589623,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsUpdate_589672 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesBuildingsUpdate_589674(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsUpdate_589673(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a building.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   buildingId: JString (required)
  ##             : The ID of the building to update.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `buildingId` field"
  var valid_589675 = path.getOrDefault("buildingId")
  valid_589675 = validateParameter(valid_589675, JString, required = true,
                                 default = nil)
  if valid_589675 != nil:
    section.add "buildingId", valid_589675
  var valid_589676 = path.getOrDefault("customer")
  valid_589676 = validateParameter(valid_589676, JString, required = true,
                                 default = nil)
  if valid_589676 != nil:
    section.add "customer", valid_589676
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   coordinatesSource: JString
  ##                    : Source from which Building.coordinates are derived.
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
  var valid_589677 = query.getOrDefault("fields")
  valid_589677 = validateParameter(valid_589677, JString, required = false,
                                 default = nil)
  if valid_589677 != nil:
    section.add "fields", valid_589677
  var valid_589678 = query.getOrDefault("quotaUser")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "quotaUser", valid_589678
  var valid_589679 = query.getOrDefault("coordinatesSource")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_589679 != nil:
    section.add "coordinatesSource", valid_589679
  var valid_589680 = query.getOrDefault("alt")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = newJString("json"))
  if valid_589680 != nil:
    section.add "alt", valid_589680
  var valid_589681 = query.getOrDefault("oauth_token")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "oauth_token", valid_589681
  var valid_589682 = query.getOrDefault("userIp")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "userIp", valid_589682
  var valid_589683 = query.getOrDefault("key")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "key", valid_589683
  var valid_589684 = query.getOrDefault("prettyPrint")
  valid_589684 = validateParameter(valid_589684, JBool, required = false,
                                 default = newJBool(true))
  if valid_589684 != nil:
    section.add "prettyPrint", valid_589684
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

proc call*(call_589686: Call_DirectoryResourcesBuildingsUpdate_589672;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building.
  ## 
  let valid = call_589686.validator(path, query, header, formData, body)
  let scheme = call_589686.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589686.url(scheme.get, call_589686.host, call_589686.base,
                         call_589686.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589686, url, valid)

proc call*(call_589687: Call_DirectoryResourcesBuildingsUpdate_589672;
          buildingId: string; customer: string; fields: string = "";
          quotaUser: string = ""; coordinatesSource: string = "SOURCE_UNSPECIFIED";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryResourcesBuildingsUpdate
  ## Updates a building.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   coordinatesSource: string
  ##                    : Source from which Building.coordinates are derived.
  ##   buildingId: string (required)
  ##             : The ID of the building to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589688 = newJObject()
  var query_589689 = newJObject()
  var body_589690 = newJObject()
  add(query_589689, "fields", newJString(fields))
  add(query_589689, "quotaUser", newJString(quotaUser))
  add(query_589689, "coordinatesSource", newJString(coordinatesSource))
  add(path_589688, "buildingId", newJString(buildingId))
  add(query_589689, "alt", newJString(alt))
  add(query_589689, "oauth_token", newJString(oauthToken))
  add(query_589689, "userIp", newJString(userIp))
  add(query_589689, "key", newJString(key))
  add(path_589688, "customer", newJString(customer))
  if body != nil:
    body_589690 = body
  add(query_589689, "prettyPrint", newJBool(prettyPrint))
  result = call_589687.call(path_589688, query_589689, nil, nil, body_589690)

var directoryResourcesBuildingsUpdate* = Call_DirectoryResourcesBuildingsUpdate_589672(
    name: "directoryResourcesBuildingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsUpdate_589673,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsUpdate_589674,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsGet_589656 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesBuildingsGet_589658(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsGet_589657(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a building.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   buildingId: JString (required)
  ##             : The unique ID of the building to retrieve.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `buildingId` field"
  var valid_589659 = path.getOrDefault("buildingId")
  valid_589659 = validateParameter(valid_589659, JString, required = true,
                                 default = nil)
  if valid_589659 != nil:
    section.add "buildingId", valid_589659
  var valid_589660 = path.getOrDefault("customer")
  valid_589660 = validateParameter(valid_589660, JString, required = true,
                                 default = nil)
  if valid_589660 != nil:
    section.add "customer", valid_589660
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
  var valid_589661 = query.getOrDefault("fields")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = nil)
  if valid_589661 != nil:
    section.add "fields", valid_589661
  var valid_589662 = query.getOrDefault("quotaUser")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "quotaUser", valid_589662
  var valid_589663 = query.getOrDefault("alt")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = newJString("json"))
  if valid_589663 != nil:
    section.add "alt", valid_589663
  var valid_589664 = query.getOrDefault("oauth_token")
  valid_589664 = validateParameter(valid_589664, JString, required = false,
                                 default = nil)
  if valid_589664 != nil:
    section.add "oauth_token", valid_589664
  var valid_589665 = query.getOrDefault("userIp")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "userIp", valid_589665
  var valid_589666 = query.getOrDefault("key")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "key", valid_589666
  var valid_589667 = query.getOrDefault("prettyPrint")
  valid_589667 = validateParameter(valid_589667, JBool, required = false,
                                 default = newJBool(true))
  if valid_589667 != nil:
    section.add "prettyPrint", valid_589667
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589668: Call_DirectoryResourcesBuildingsGet_589656; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a building.
  ## 
  let valid = call_589668.validator(path, query, header, formData, body)
  let scheme = call_589668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589668.url(scheme.get, call_589668.host, call_589668.base,
                         call_589668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589668, url, valid)

proc call*(call_589669: Call_DirectoryResourcesBuildingsGet_589656;
          buildingId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryResourcesBuildingsGet
  ## Retrieves a building.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   buildingId: string (required)
  ##             : The unique ID of the building to retrieve.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589670 = newJObject()
  var query_589671 = newJObject()
  add(query_589671, "fields", newJString(fields))
  add(query_589671, "quotaUser", newJString(quotaUser))
  add(path_589670, "buildingId", newJString(buildingId))
  add(query_589671, "alt", newJString(alt))
  add(query_589671, "oauth_token", newJString(oauthToken))
  add(query_589671, "userIp", newJString(userIp))
  add(query_589671, "key", newJString(key))
  add(path_589670, "customer", newJString(customer))
  add(query_589671, "prettyPrint", newJBool(prettyPrint))
  result = call_589669.call(path_589670, query_589671, nil, nil, nil)

var directoryResourcesBuildingsGet* = Call_DirectoryResourcesBuildingsGet_589656(
    name: "directoryResourcesBuildingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsGet_589657,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsGet_589658,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsPatch_589707 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesBuildingsPatch_589709(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsPatch_589708(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a building. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   buildingId: JString (required)
  ##             : The ID of the building to update.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `buildingId` field"
  var valid_589710 = path.getOrDefault("buildingId")
  valid_589710 = validateParameter(valid_589710, JString, required = true,
                                 default = nil)
  if valid_589710 != nil:
    section.add "buildingId", valid_589710
  var valid_589711 = path.getOrDefault("customer")
  valid_589711 = validateParameter(valid_589711, JString, required = true,
                                 default = nil)
  if valid_589711 != nil:
    section.add "customer", valid_589711
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   coordinatesSource: JString
  ##                    : Source from which Building.coordinates are derived.
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
  var valid_589712 = query.getOrDefault("fields")
  valid_589712 = validateParameter(valid_589712, JString, required = false,
                                 default = nil)
  if valid_589712 != nil:
    section.add "fields", valid_589712
  var valid_589713 = query.getOrDefault("quotaUser")
  valid_589713 = validateParameter(valid_589713, JString, required = false,
                                 default = nil)
  if valid_589713 != nil:
    section.add "quotaUser", valid_589713
  var valid_589714 = query.getOrDefault("coordinatesSource")
  valid_589714 = validateParameter(valid_589714, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_589714 != nil:
    section.add "coordinatesSource", valid_589714
  var valid_589715 = query.getOrDefault("alt")
  valid_589715 = validateParameter(valid_589715, JString, required = false,
                                 default = newJString("json"))
  if valid_589715 != nil:
    section.add "alt", valid_589715
  var valid_589716 = query.getOrDefault("oauth_token")
  valid_589716 = validateParameter(valid_589716, JString, required = false,
                                 default = nil)
  if valid_589716 != nil:
    section.add "oauth_token", valid_589716
  var valid_589717 = query.getOrDefault("userIp")
  valid_589717 = validateParameter(valid_589717, JString, required = false,
                                 default = nil)
  if valid_589717 != nil:
    section.add "userIp", valid_589717
  var valid_589718 = query.getOrDefault("key")
  valid_589718 = validateParameter(valid_589718, JString, required = false,
                                 default = nil)
  if valid_589718 != nil:
    section.add "key", valid_589718
  var valid_589719 = query.getOrDefault("prettyPrint")
  valid_589719 = validateParameter(valid_589719, JBool, required = false,
                                 default = newJBool(true))
  if valid_589719 != nil:
    section.add "prettyPrint", valid_589719
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

proc call*(call_589721: Call_DirectoryResourcesBuildingsPatch_589707;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building. This method supports patch semantics.
  ## 
  let valid = call_589721.validator(path, query, header, formData, body)
  let scheme = call_589721.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589721.url(scheme.get, call_589721.host, call_589721.base,
                         call_589721.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589721, url, valid)

proc call*(call_589722: Call_DirectoryResourcesBuildingsPatch_589707;
          buildingId: string; customer: string; fields: string = "";
          quotaUser: string = ""; coordinatesSource: string = "SOURCE_UNSPECIFIED";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryResourcesBuildingsPatch
  ## Updates a building. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   coordinatesSource: string
  ##                    : Source from which Building.coordinates are derived.
  ##   buildingId: string (required)
  ##             : The ID of the building to update.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589723 = newJObject()
  var query_589724 = newJObject()
  var body_589725 = newJObject()
  add(query_589724, "fields", newJString(fields))
  add(query_589724, "quotaUser", newJString(quotaUser))
  add(query_589724, "coordinatesSource", newJString(coordinatesSource))
  add(path_589723, "buildingId", newJString(buildingId))
  add(query_589724, "alt", newJString(alt))
  add(query_589724, "oauth_token", newJString(oauthToken))
  add(query_589724, "userIp", newJString(userIp))
  add(query_589724, "key", newJString(key))
  add(path_589723, "customer", newJString(customer))
  if body != nil:
    body_589725 = body
  add(query_589724, "prettyPrint", newJBool(prettyPrint))
  result = call_589722.call(path_589723, query_589724, nil, nil, body_589725)

var directoryResourcesBuildingsPatch* = Call_DirectoryResourcesBuildingsPatch_589707(
    name: "directoryResourcesBuildingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsPatch_589708,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsPatch_589709,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsDelete_589691 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesBuildingsDelete_589693(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsDelete_589692(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a building.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   buildingId: JString (required)
  ##             : The ID of the building to delete.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `buildingId` field"
  var valid_589694 = path.getOrDefault("buildingId")
  valid_589694 = validateParameter(valid_589694, JString, required = true,
                                 default = nil)
  if valid_589694 != nil:
    section.add "buildingId", valid_589694
  var valid_589695 = path.getOrDefault("customer")
  valid_589695 = validateParameter(valid_589695, JString, required = true,
                                 default = nil)
  if valid_589695 != nil:
    section.add "customer", valid_589695
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
  var valid_589696 = query.getOrDefault("fields")
  valid_589696 = validateParameter(valid_589696, JString, required = false,
                                 default = nil)
  if valid_589696 != nil:
    section.add "fields", valid_589696
  var valid_589697 = query.getOrDefault("quotaUser")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "quotaUser", valid_589697
  var valid_589698 = query.getOrDefault("alt")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = newJString("json"))
  if valid_589698 != nil:
    section.add "alt", valid_589698
  var valid_589699 = query.getOrDefault("oauth_token")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = nil)
  if valid_589699 != nil:
    section.add "oauth_token", valid_589699
  var valid_589700 = query.getOrDefault("userIp")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "userIp", valid_589700
  var valid_589701 = query.getOrDefault("key")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "key", valid_589701
  var valid_589702 = query.getOrDefault("prettyPrint")
  valid_589702 = validateParameter(valid_589702, JBool, required = false,
                                 default = newJBool(true))
  if valid_589702 != nil:
    section.add "prettyPrint", valid_589702
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589703: Call_DirectoryResourcesBuildingsDelete_589691;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a building.
  ## 
  let valid = call_589703.validator(path, query, header, formData, body)
  let scheme = call_589703.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589703.url(scheme.get, call_589703.host, call_589703.base,
                         call_589703.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589703, url, valid)

proc call*(call_589704: Call_DirectoryResourcesBuildingsDelete_589691;
          buildingId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryResourcesBuildingsDelete
  ## Deletes a building.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   buildingId: string (required)
  ##             : The ID of the building to delete.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589705 = newJObject()
  var query_589706 = newJObject()
  add(query_589706, "fields", newJString(fields))
  add(query_589706, "quotaUser", newJString(quotaUser))
  add(path_589705, "buildingId", newJString(buildingId))
  add(query_589706, "alt", newJString(alt))
  add(query_589706, "oauth_token", newJString(oauthToken))
  add(query_589706, "userIp", newJString(userIp))
  add(query_589706, "key", newJString(key))
  add(path_589705, "customer", newJString(customer))
  add(query_589706, "prettyPrint", newJBool(prettyPrint))
  result = call_589704.call(path_589705, query_589706, nil, nil, nil)

var directoryResourcesBuildingsDelete* = Call_DirectoryResourcesBuildingsDelete_589691(
    name: "directoryResourcesBuildingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsDelete_589692,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsDelete_589693,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsInsert_589745 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesCalendarsInsert_589747(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsInsert_589746(path: JsonNode;
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
  var valid_589748 = path.getOrDefault("customer")
  valid_589748 = validateParameter(valid_589748, JString, required = true,
                                 default = nil)
  if valid_589748 != nil:
    section.add "customer", valid_589748
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
  var valid_589749 = query.getOrDefault("fields")
  valid_589749 = validateParameter(valid_589749, JString, required = false,
                                 default = nil)
  if valid_589749 != nil:
    section.add "fields", valid_589749
  var valid_589750 = query.getOrDefault("quotaUser")
  valid_589750 = validateParameter(valid_589750, JString, required = false,
                                 default = nil)
  if valid_589750 != nil:
    section.add "quotaUser", valid_589750
  var valid_589751 = query.getOrDefault("alt")
  valid_589751 = validateParameter(valid_589751, JString, required = false,
                                 default = newJString("json"))
  if valid_589751 != nil:
    section.add "alt", valid_589751
  var valid_589752 = query.getOrDefault("oauth_token")
  valid_589752 = validateParameter(valid_589752, JString, required = false,
                                 default = nil)
  if valid_589752 != nil:
    section.add "oauth_token", valid_589752
  var valid_589753 = query.getOrDefault("userIp")
  valid_589753 = validateParameter(valid_589753, JString, required = false,
                                 default = nil)
  if valid_589753 != nil:
    section.add "userIp", valid_589753
  var valid_589754 = query.getOrDefault("key")
  valid_589754 = validateParameter(valid_589754, JString, required = false,
                                 default = nil)
  if valid_589754 != nil:
    section.add "key", valid_589754
  var valid_589755 = query.getOrDefault("prettyPrint")
  valid_589755 = validateParameter(valid_589755, JBool, required = false,
                                 default = newJBool(true))
  if valid_589755 != nil:
    section.add "prettyPrint", valid_589755
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

proc call*(call_589757: Call_DirectoryResourcesCalendarsInsert_589745;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a calendar resource.
  ## 
  let valid = call_589757.validator(path, query, header, formData, body)
  let scheme = call_589757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589757.url(scheme.get, call_589757.host, call_589757.base,
                         call_589757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589757, url, valid)

proc call*(call_589758: Call_DirectoryResourcesCalendarsInsert_589745;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryResourcesCalendarsInsert
  ## Inserts a calendar resource.
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
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589759 = newJObject()
  var query_589760 = newJObject()
  var body_589761 = newJObject()
  add(query_589760, "fields", newJString(fields))
  add(query_589760, "quotaUser", newJString(quotaUser))
  add(query_589760, "alt", newJString(alt))
  add(query_589760, "oauth_token", newJString(oauthToken))
  add(query_589760, "userIp", newJString(userIp))
  add(query_589760, "key", newJString(key))
  add(path_589759, "customer", newJString(customer))
  if body != nil:
    body_589761 = body
  add(query_589760, "prettyPrint", newJBool(prettyPrint))
  result = call_589758.call(path_589759, query_589760, nil, nil, body_589761)

var directoryResourcesCalendarsInsert* = Call_DirectoryResourcesCalendarsInsert_589745(
    name: "directoryResourcesCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsInsert_589746,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsInsert_589747,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsList_589726 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesCalendarsList_589728(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsList_589727(path: JsonNode;
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
  var valid_589729 = path.getOrDefault("customer")
  valid_589729 = validateParameter(valid_589729, JString, required = true,
                                 default = nil)
  if valid_589729 != nil:
    section.add "customer", valid_589729
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   query: JString
  ##        : String query used to filter results. Should be of the form "field operator value" where field can be any of supported fields and operators can be any of supported operations. Operators include '=' for exact match and ':' for prefix match or HAS match where applicable. For prefix match, the value should always be followed by a *. Supported fields include generatedResourceName, name, buildingId, featureInstances.feature.name. For example buildingId=US-NYC-9TH AND featureInstances.feature.name:Phone.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   orderBy: JString
  ##          : Field(s) to sort results by in either ascending or descending order. Supported fields include resourceId, resourceName, capacity, buildingId, and floorName. If no order is specified, defaults to ascending. Should be of the form "field [asc|desc], field [asc|desc], ...". For example buildingId, capacity desc would return results sorted first by buildingId in ascending order then by capacity in descending order.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589730 = query.getOrDefault("fields")
  valid_589730 = validateParameter(valid_589730, JString, required = false,
                                 default = nil)
  if valid_589730 != nil:
    section.add "fields", valid_589730
  var valid_589731 = query.getOrDefault("pageToken")
  valid_589731 = validateParameter(valid_589731, JString, required = false,
                                 default = nil)
  if valid_589731 != nil:
    section.add "pageToken", valid_589731
  var valid_589732 = query.getOrDefault("quotaUser")
  valid_589732 = validateParameter(valid_589732, JString, required = false,
                                 default = nil)
  if valid_589732 != nil:
    section.add "quotaUser", valid_589732
  var valid_589733 = query.getOrDefault("alt")
  valid_589733 = validateParameter(valid_589733, JString, required = false,
                                 default = newJString("json"))
  if valid_589733 != nil:
    section.add "alt", valid_589733
  var valid_589734 = query.getOrDefault("query")
  valid_589734 = validateParameter(valid_589734, JString, required = false,
                                 default = nil)
  if valid_589734 != nil:
    section.add "query", valid_589734
  var valid_589735 = query.getOrDefault("oauth_token")
  valid_589735 = validateParameter(valid_589735, JString, required = false,
                                 default = nil)
  if valid_589735 != nil:
    section.add "oauth_token", valid_589735
  var valid_589736 = query.getOrDefault("userIp")
  valid_589736 = validateParameter(valid_589736, JString, required = false,
                                 default = nil)
  if valid_589736 != nil:
    section.add "userIp", valid_589736
  var valid_589737 = query.getOrDefault("maxResults")
  valid_589737 = validateParameter(valid_589737, JInt, required = false, default = nil)
  if valid_589737 != nil:
    section.add "maxResults", valid_589737
  var valid_589738 = query.getOrDefault("orderBy")
  valid_589738 = validateParameter(valid_589738, JString, required = false,
                                 default = nil)
  if valid_589738 != nil:
    section.add "orderBy", valid_589738
  var valid_589739 = query.getOrDefault("key")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = nil)
  if valid_589739 != nil:
    section.add "key", valid_589739
  var valid_589740 = query.getOrDefault("prettyPrint")
  valid_589740 = validateParameter(valid_589740, JBool, required = false,
                                 default = newJBool(true))
  if valid_589740 != nil:
    section.add "prettyPrint", valid_589740
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589741: Call_DirectoryResourcesCalendarsList_589726;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of calendar resources for an account.
  ## 
  let valid = call_589741.validator(path, query, header, formData, body)
  let scheme = call_589741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589741.url(scheme.get, call_589741.host, call_589741.base,
                         call_589741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589741, url, valid)

proc call*(call_589742: Call_DirectoryResourcesCalendarsList_589726;
          customer: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; query: string = "";
          oauthToken: string = ""; userIp: string = ""; maxResults: int = 0;
          orderBy: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryResourcesCalendarsList
  ## Retrieves a list of calendar resources for an account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : String query used to filter results. Should be of the form "field operator value" where field can be any of supported fields and operators can be any of supported operations. Operators include '=' for exact match and ':' for prefix match or HAS match where applicable. For prefix match, the value should always be followed by a *. Supported fields include generatedResourceName, name, buildingId, featureInstances.feature.name. For example buildingId=US-NYC-9TH AND featureInstances.feature.name:Phone.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   orderBy: string
  ##          : Field(s) to sort results by in either ascending or descending order. Supported fields include resourceId, resourceName, capacity, buildingId, and floorName. If no order is specified, defaults to ascending. Should be of the form "field [asc|desc], field [asc|desc], ...". For example buildingId, capacity desc would return results sorted first by buildingId in ascending order then by capacity in descending order.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589743 = newJObject()
  var query_589744 = newJObject()
  add(query_589744, "fields", newJString(fields))
  add(query_589744, "pageToken", newJString(pageToken))
  add(query_589744, "quotaUser", newJString(quotaUser))
  add(query_589744, "alt", newJString(alt))
  add(query_589744, "query", newJString(query))
  add(query_589744, "oauth_token", newJString(oauthToken))
  add(query_589744, "userIp", newJString(userIp))
  add(query_589744, "maxResults", newJInt(maxResults))
  add(query_589744, "orderBy", newJString(orderBy))
  add(query_589744, "key", newJString(key))
  add(path_589743, "customer", newJString(customer))
  add(query_589744, "prettyPrint", newJBool(prettyPrint))
  result = call_589742.call(path_589743, query_589744, nil, nil, nil)

var directoryResourcesCalendarsList* = Call_DirectoryResourcesCalendarsList_589726(
    name: "directoryResourcesCalendarsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsList_589727,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsList_589728,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsUpdate_589778 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesCalendarsUpdate_589780(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsUpdate_589779(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarResourceId: JString (required)
  ##                     : The unique ID of the calendar resource to update.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarResourceId` field"
  var valid_589781 = path.getOrDefault("calendarResourceId")
  valid_589781 = validateParameter(valid_589781, JString, required = true,
                                 default = nil)
  if valid_589781 != nil:
    section.add "calendarResourceId", valid_589781
  var valid_589782 = path.getOrDefault("customer")
  valid_589782 = validateParameter(valid_589782, JString, required = true,
                                 default = nil)
  if valid_589782 != nil:
    section.add "customer", valid_589782
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
  var valid_589783 = query.getOrDefault("fields")
  valid_589783 = validateParameter(valid_589783, JString, required = false,
                                 default = nil)
  if valid_589783 != nil:
    section.add "fields", valid_589783
  var valid_589784 = query.getOrDefault("quotaUser")
  valid_589784 = validateParameter(valid_589784, JString, required = false,
                                 default = nil)
  if valid_589784 != nil:
    section.add "quotaUser", valid_589784
  var valid_589785 = query.getOrDefault("alt")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = newJString("json"))
  if valid_589785 != nil:
    section.add "alt", valid_589785
  var valid_589786 = query.getOrDefault("oauth_token")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "oauth_token", valid_589786
  var valid_589787 = query.getOrDefault("userIp")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "userIp", valid_589787
  var valid_589788 = query.getOrDefault("key")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "key", valid_589788
  var valid_589789 = query.getOrDefault("prettyPrint")
  valid_589789 = validateParameter(valid_589789, JBool, required = false,
                                 default = newJBool(true))
  if valid_589789 != nil:
    section.add "prettyPrint", valid_589789
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

proc call*(call_589791: Call_DirectoryResourcesCalendarsUpdate_589778;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
  ## 
  let valid = call_589791.validator(path, query, header, formData, body)
  let scheme = call_589791.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589791.url(scheme.get, call_589791.host, call_589791.base,
                         call_589791.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589791, url, valid)

proc call*(call_589792: Call_DirectoryResourcesCalendarsUpdate_589778;
          calendarResourceId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryResourcesCalendarsUpdate
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
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
  ##   calendarResourceId: string (required)
  ##                     : The unique ID of the calendar resource to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589793 = newJObject()
  var query_589794 = newJObject()
  var body_589795 = newJObject()
  add(query_589794, "fields", newJString(fields))
  add(query_589794, "quotaUser", newJString(quotaUser))
  add(query_589794, "alt", newJString(alt))
  add(query_589794, "oauth_token", newJString(oauthToken))
  add(query_589794, "userIp", newJString(userIp))
  add(path_589793, "calendarResourceId", newJString(calendarResourceId))
  add(query_589794, "key", newJString(key))
  add(path_589793, "customer", newJString(customer))
  if body != nil:
    body_589795 = body
  add(query_589794, "prettyPrint", newJBool(prettyPrint))
  result = call_589792.call(path_589793, query_589794, nil, nil, body_589795)

var directoryResourcesCalendarsUpdate* = Call_DirectoryResourcesCalendarsUpdate_589778(
    name: "directoryResourcesCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsUpdate_589779,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsUpdate_589780,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsGet_589762 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesCalendarsGet_589764(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsGet_589763(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a calendar resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarResourceId: JString (required)
  ##                     : The unique ID of the calendar resource to retrieve.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarResourceId` field"
  var valid_589765 = path.getOrDefault("calendarResourceId")
  valid_589765 = validateParameter(valid_589765, JString, required = true,
                                 default = nil)
  if valid_589765 != nil:
    section.add "calendarResourceId", valid_589765
  var valid_589766 = path.getOrDefault("customer")
  valid_589766 = validateParameter(valid_589766, JString, required = true,
                                 default = nil)
  if valid_589766 != nil:
    section.add "customer", valid_589766
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
  var valid_589767 = query.getOrDefault("fields")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = nil)
  if valid_589767 != nil:
    section.add "fields", valid_589767
  var valid_589768 = query.getOrDefault("quotaUser")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "quotaUser", valid_589768
  var valid_589769 = query.getOrDefault("alt")
  valid_589769 = validateParameter(valid_589769, JString, required = false,
                                 default = newJString("json"))
  if valid_589769 != nil:
    section.add "alt", valid_589769
  var valid_589770 = query.getOrDefault("oauth_token")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "oauth_token", valid_589770
  var valid_589771 = query.getOrDefault("userIp")
  valid_589771 = validateParameter(valid_589771, JString, required = false,
                                 default = nil)
  if valid_589771 != nil:
    section.add "userIp", valid_589771
  var valid_589772 = query.getOrDefault("key")
  valid_589772 = validateParameter(valid_589772, JString, required = false,
                                 default = nil)
  if valid_589772 != nil:
    section.add "key", valid_589772
  var valid_589773 = query.getOrDefault("prettyPrint")
  valid_589773 = validateParameter(valid_589773, JBool, required = false,
                                 default = newJBool(true))
  if valid_589773 != nil:
    section.add "prettyPrint", valid_589773
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589774: Call_DirectoryResourcesCalendarsGet_589762; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a calendar resource.
  ## 
  let valid = call_589774.validator(path, query, header, formData, body)
  let scheme = call_589774.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589774.url(scheme.get, call_589774.host, call_589774.base,
                         call_589774.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589774, url, valid)

proc call*(call_589775: Call_DirectoryResourcesCalendarsGet_589762;
          calendarResourceId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryResourcesCalendarsGet
  ## Retrieves a calendar resource.
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
  ##   calendarResourceId: string (required)
  ##                     : The unique ID of the calendar resource to retrieve.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589776 = newJObject()
  var query_589777 = newJObject()
  add(query_589777, "fields", newJString(fields))
  add(query_589777, "quotaUser", newJString(quotaUser))
  add(query_589777, "alt", newJString(alt))
  add(query_589777, "oauth_token", newJString(oauthToken))
  add(query_589777, "userIp", newJString(userIp))
  add(path_589776, "calendarResourceId", newJString(calendarResourceId))
  add(query_589777, "key", newJString(key))
  add(path_589776, "customer", newJString(customer))
  add(query_589777, "prettyPrint", newJBool(prettyPrint))
  result = call_589775.call(path_589776, query_589777, nil, nil, nil)

var directoryResourcesCalendarsGet* = Call_DirectoryResourcesCalendarsGet_589762(
    name: "directoryResourcesCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsGet_589763,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsGet_589764,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsPatch_589812 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesCalendarsPatch_589814(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsPatch_589813(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarResourceId: JString (required)
  ##                     : The unique ID of the calendar resource to update.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarResourceId` field"
  var valid_589815 = path.getOrDefault("calendarResourceId")
  valid_589815 = validateParameter(valid_589815, JString, required = true,
                                 default = nil)
  if valid_589815 != nil:
    section.add "calendarResourceId", valid_589815
  var valid_589816 = path.getOrDefault("customer")
  valid_589816 = validateParameter(valid_589816, JString, required = true,
                                 default = nil)
  if valid_589816 != nil:
    section.add "customer", valid_589816
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
  var valid_589817 = query.getOrDefault("fields")
  valid_589817 = validateParameter(valid_589817, JString, required = false,
                                 default = nil)
  if valid_589817 != nil:
    section.add "fields", valid_589817
  var valid_589818 = query.getOrDefault("quotaUser")
  valid_589818 = validateParameter(valid_589818, JString, required = false,
                                 default = nil)
  if valid_589818 != nil:
    section.add "quotaUser", valid_589818
  var valid_589819 = query.getOrDefault("alt")
  valid_589819 = validateParameter(valid_589819, JString, required = false,
                                 default = newJString("json"))
  if valid_589819 != nil:
    section.add "alt", valid_589819
  var valid_589820 = query.getOrDefault("oauth_token")
  valid_589820 = validateParameter(valid_589820, JString, required = false,
                                 default = nil)
  if valid_589820 != nil:
    section.add "oauth_token", valid_589820
  var valid_589821 = query.getOrDefault("userIp")
  valid_589821 = validateParameter(valid_589821, JString, required = false,
                                 default = nil)
  if valid_589821 != nil:
    section.add "userIp", valid_589821
  var valid_589822 = query.getOrDefault("key")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "key", valid_589822
  var valid_589823 = query.getOrDefault("prettyPrint")
  valid_589823 = validateParameter(valid_589823, JBool, required = false,
                                 default = newJBool(true))
  if valid_589823 != nil:
    section.add "prettyPrint", valid_589823
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

proc call*(call_589825: Call_DirectoryResourcesCalendarsPatch_589812;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
  ## 
  let valid = call_589825.validator(path, query, header, formData, body)
  let scheme = call_589825.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589825.url(scheme.get, call_589825.host, call_589825.base,
                         call_589825.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589825, url, valid)

proc call*(call_589826: Call_DirectoryResourcesCalendarsPatch_589812;
          calendarResourceId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryResourcesCalendarsPatch
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
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
  ##   calendarResourceId: string (required)
  ##                     : The unique ID of the calendar resource to update.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589827 = newJObject()
  var query_589828 = newJObject()
  var body_589829 = newJObject()
  add(query_589828, "fields", newJString(fields))
  add(query_589828, "quotaUser", newJString(quotaUser))
  add(query_589828, "alt", newJString(alt))
  add(query_589828, "oauth_token", newJString(oauthToken))
  add(query_589828, "userIp", newJString(userIp))
  add(path_589827, "calendarResourceId", newJString(calendarResourceId))
  add(query_589828, "key", newJString(key))
  add(path_589827, "customer", newJString(customer))
  if body != nil:
    body_589829 = body
  add(query_589828, "prettyPrint", newJBool(prettyPrint))
  result = call_589826.call(path_589827, query_589828, nil, nil, body_589829)

var directoryResourcesCalendarsPatch* = Call_DirectoryResourcesCalendarsPatch_589812(
    name: "directoryResourcesCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsPatch_589813,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsPatch_589814,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsDelete_589796 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesCalendarsDelete_589798(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsDelete_589797(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a calendar resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   calendarResourceId: JString (required)
  ##                     : The unique ID of the calendar resource to delete.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `calendarResourceId` field"
  var valid_589799 = path.getOrDefault("calendarResourceId")
  valid_589799 = validateParameter(valid_589799, JString, required = true,
                                 default = nil)
  if valid_589799 != nil:
    section.add "calendarResourceId", valid_589799
  var valid_589800 = path.getOrDefault("customer")
  valid_589800 = validateParameter(valid_589800, JString, required = true,
                                 default = nil)
  if valid_589800 != nil:
    section.add "customer", valid_589800
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
  var valid_589801 = query.getOrDefault("fields")
  valid_589801 = validateParameter(valid_589801, JString, required = false,
                                 default = nil)
  if valid_589801 != nil:
    section.add "fields", valid_589801
  var valid_589802 = query.getOrDefault("quotaUser")
  valid_589802 = validateParameter(valid_589802, JString, required = false,
                                 default = nil)
  if valid_589802 != nil:
    section.add "quotaUser", valid_589802
  var valid_589803 = query.getOrDefault("alt")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = newJString("json"))
  if valid_589803 != nil:
    section.add "alt", valid_589803
  var valid_589804 = query.getOrDefault("oauth_token")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = nil)
  if valid_589804 != nil:
    section.add "oauth_token", valid_589804
  var valid_589805 = query.getOrDefault("userIp")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = nil)
  if valid_589805 != nil:
    section.add "userIp", valid_589805
  var valid_589806 = query.getOrDefault("key")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "key", valid_589806
  var valid_589807 = query.getOrDefault("prettyPrint")
  valid_589807 = validateParameter(valid_589807, JBool, required = false,
                                 default = newJBool(true))
  if valid_589807 != nil:
    section.add "prettyPrint", valid_589807
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589808: Call_DirectoryResourcesCalendarsDelete_589796;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a calendar resource.
  ## 
  let valid = call_589808.validator(path, query, header, formData, body)
  let scheme = call_589808.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589808.url(scheme.get, call_589808.host, call_589808.base,
                         call_589808.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589808, url, valid)

proc call*(call_589809: Call_DirectoryResourcesCalendarsDelete_589796;
          calendarResourceId: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryResourcesCalendarsDelete
  ## Deletes a calendar resource.
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
  ##   calendarResourceId: string (required)
  ##                     : The unique ID of the calendar resource to delete.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589810 = newJObject()
  var query_589811 = newJObject()
  add(query_589811, "fields", newJString(fields))
  add(query_589811, "quotaUser", newJString(quotaUser))
  add(query_589811, "alt", newJString(alt))
  add(query_589811, "oauth_token", newJString(oauthToken))
  add(query_589811, "userIp", newJString(userIp))
  add(path_589810, "calendarResourceId", newJString(calendarResourceId))
  add(query_589811, "key", newJString(key))
  add(path_589810, "customer", newJString(customer))
  add(query_589811, "prettyPrint", newJBool(prettyPrint))
  result = call_589809.call(path_589810, query_589811, nil, nil, nil)

var directoryResourcesCalendarsDelete* = Call_DirectoryResourcesCalendarsDelete_589796(
    name: "directoryResourcesCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsDelete_589797,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsDelete_589798,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesInsert_589847 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesFeaturesInsert_589849(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesInsert_589848(path: JsonNode;
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
  var valid_589850 = path.getOrDefault("customer")
  valid_589850 = validateParameter(valid_589850, JString, required = true,
                                 default = nil)
  if valid_589850 != nil:
    section.add "customer", valid_589850
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
  var valid_589851 = query.getOrDefault("fields")
  valid_589851 = validateParameter(valid_589851, JString, required = false,
                                 default = nil)
  if valid_589851 != nil:
    section.add "fields", valid_589851
  var valid_589852 = query.getOrDefault("quotaUser")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "quotaUser", valid_589852
  var valid_589853 = query.getOrDefault("alt")
  valid_589853 = validateParameter(valid_589853, JString, required = false,
                                 default = newJString("json"))
  if valid_589853 != nil:
    section.add "alt", valid_589853
  var valid_589854 = query.getOrDefault("oauth_token")
  valid_589854 = validateParameter(valid_589854, JString, required = false,
                                 default = nil)
  if valid_589854 != nil:
    section.add "oauth_token", valid_589854
  var valid_589855 = query.getOrDefault("userIp")
  valid_589855 = validateParameter(valid_589855, JString, required = false,
                                 default = nil)
  if valid_589855 != nil:
    section.add "userIp", valid_589855
  var valid_589856 = query.getOrDefault("key")
  valid_589856 = validateParameter(valid_589856, JString, required = false,
                                 default = nil)
  if valid_589856 != nil:
    section.add "key", valid_589856
  var valid_589857 = query.getOrDefault("prettyPrint")
  valid_589857 = validateParameter(valid_589857, JBool, required = false,
                                 default = newJBool(true))
  if valid_589857 != nil:
    section.add "prettyPrint", valid_589857
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

proc call*(call_589859: Call_DirectoryResourcesFeaturesInsert_589847;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a feature.
  ## 
  let valid = call_589859.validator(path, query, header, formData, body)
  let scheme = call_589859.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589859.url(scheme.get, call_589859.host, call_589859.base,
                         call_589859.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589859, url, valid)

proc call*(call_589860: Call_DirectoryResourcesFeaturesInsert_589847;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryResourcesFeaturesInsert
  ## Inserts a feature.
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
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589861 = newJObject()
  var query_589862 = newJObject()
  var body_589863 = newJObject()
  add(query_589862, "fields", newJString(fields))
  add(query_589862, "quotaUser", newJString(quotaUser))
  add(query_589862, "alt", newJString(alt))
  add(query_589862, "oauth_token", newJString(oauthToken))
  add(query_589862, "userIp", newJString(userIp))
  add(query_589862, "key", newJString(key))
  add(path_589861, "customer", newJString(customer))
  if body != nil:
    body_589863 = body
  add(query_589862, "prettyPrint", newJBool(prettyPrint))
  result = call_589860.call(path_589861, query_589862, nil, nil, body_589863)

var directoryResourcesFeaturesInsert* = Call_DirectoryResourcesFeaturesInsert_589847(
    name: "directoryResourcesFeaturesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesInsert_589848,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesInsert_589849,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesList_589830 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesFeaturesList_589832(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesList_589831(path: JsonNode;
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
  var valid_589833 = path.getOrDefault("customer")
  valid_589833 = validateParameter(valid_589833, JString, required = true,
                                 default = nil)
  if valid_589833 != nil:
    section.add "customer", valid_589833
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589834 = query.getOrDefault("fields")
  valid_589834 = validateParameter(valid_589834, JString, required = false,
                                 default = nil)
  if valid_589834 != nil:
    section.add "fields", valid_589834
  var valid_589835 = query.getOrDefault("pageToken")
  valid_589835 = validateParameter(valid_589835, JString, required = false,
                                 default = nil)
  if valid_589835 != nil:
    section.add "pageToken", valid_589835
  var valid_589836 = query.getOrDefault("quotaUser")
  valid_589836 = validateParameter(valid_589836, JString, required = false,
                                 default = nil)
  if valid_589836 != nil:
    section.add "quotaUser", valid_589836
  var valid_589837 = query.getOrDefault("alt")
  valid_589837 = validateParameter(valid_589837, JString, required = false,
                                 default = newJString("json"))
  if valid_589837 != nil:
    section.add "alt", valid_589837
  var valid_589838 = query.getOrDefault("oauth_token")
  valid_589838 = validateParameter(valid_589838, JString, required = false,
                                 default = nil)
  if valid_589838 != nil:
    section.add "oauth_token", valid_589838
  var valid_589839 = query.getOrDefault("userIp")
  valid_589839 = validateParameter(valid_589839, JString, required = false,
                                 default = nil)
  if valid_589839 != nil:
    section.add "userIp", valid_589839
  var valid_589840 = query.getOrDefault("maxResults")
  valid_589840 = validateParameter(valid_589840, JInt, required = false, default = nil)
  if valid_589840 != nil:
    section.add "maxResults", valid_589840
  var valid_589841 = query.getOrDefault("key")
  valid_589841 = validateParameter(valid_589841, JString, required = false,
                                 default = nil)
  if valid_589841 != nil:
    section.add "key", valid_589841
  var valid_589842 = query.getOrDefault("prettyPrint")
  valid_589842 = validateParameter(valid_589842, JBool, required = false,
                                 default = newJBool(true))
  if valid_589842 != nil:
    section.add "prettyPrint", valid_589842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589843: Call_DirectoryResourcesFeaturesList_589830; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of features for an account.
  ## 
  let valid = call_589843.validator(path, query, header, formData, body)
  let scheme = call_589843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589843.url(scheme.get, call_589843.host, call_589843.base,
                         call_589843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589843, url, valid)

proc call*(call_589844: Call_DirectoryResourcesFeaturesList_589830;
          customer: string; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 0; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryResourcesFeaturesList
  ## Retrieves a list of features for an account.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589845 = newJObject()
  var query_589846 = newJObject()
  add(query_589846, "fields", newJString(fields))
  add(query_589846, "pageToken", newJString(pageToken))
  add(query_589846, "quotaUser", newJString(quotaUser))
  add(query_589846, "alt", newJString(alt))
  add(query_589846, "oauth_token", newJString(oauthToken))
  add(query_589846, "userIp", newJString(userIp))
  add(query_589846, "maxResults", newJInt(maxResults))
  add(query_589846, "key", newJString(key))
  add(path_589845, "customer", newJString(customer))
  add(query_589846, "prettyPrint", newJBool(prettyPrint))
  result = call_589844.call(path_589845, query_589846, nil, nil, nil)

var directoryResourcesFeaturesList* = Call_DirectoryResourcesFeaturesList_589830(
    name: "directoryResourcesFeaturesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesList_589831,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesList_589832,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesUpdate_589880 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesFeaturesUpdate_589882(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesUpdate_589881(path: JsonNode;
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
  var valid_589883 = path.getOrDefault("featureKey")
  valid_589883 = validateParameter(valid_589883, JString, required = true,
                                 default = nil)
  if valid_589883 != nil:
    section.add "featureKey", valid_589883
  var valid_589884 = path.getOrDefault("customer")
  valid_589884 = validateParameter(valid_589884, JString, required = true,
                                 default = nil)
  if valid_589884 != nil:
    section.add "customer", valid_589884
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
  var valid_589885 = query.getOrDefault("fields")
  valid_589885 = validateParameter(valid_589885, JString, required = false,
                                 default = nil)
  if valid_589885 != nil:
    section.add "fields", valid_589885
  var valid_589886 = query.getOrDefault("quotaUser")
  valid_589886 = validateParameter(valid_589886, JString, required = false,
                                 default = nil)
  if valid_589886 != nil:
    section.add "quotaUser", valid_589886
  var valid_589887 = query.getOrDefault("alt")
  valid_589887 = validateParameter(valid_589887, JString, required = false,
                                 default = newJString("json"))
  if valid_589887 != nil:
    section.add "alt", valid_589887
  var valid_589888 = query.getOrDefault("oauth_token")
  valid_589888 = validateParameter(valid_589888, JString, required = false,
                                 default = nil)
  if valid_589888 != nil:
    section.add "oauth_token", valid_589888
  var valid_589889 = query.getOrDefault("userIp")
  valid_589889 = validateParameter(valid_589889, JString, required = false,
                                 default = nil)
  if valid_589889 != nil:
    section.add "userIp", valid_589889
  var valid_589890 = query.getOrDefault("key")
  valid_589890 = validateParameter(valid_589890, JString, required = false,
                                 default = nil)
  if valid_589890 != nil:
    section.add "key", valid_589890
  var valid_589891 = query.getOrDefault("prettyPrint")
  valid_589891 = validateParameter(valid_589891, JBool, required = false,
                                 default = newJBool(true))
  if valid_589891 != nil:
    section.add "prettyPrint", valid_589891
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

proc call*(call_589893: Call_DirectoryResourcesFeaturesUpdate_589880;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature.
  ## 
  let valid = call_589893.validator(path, query, header, formData, body)
  let scheme = call_589893.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589893.url(scheme.get, call_589893.host, call_589893.base,
                         call_589893.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589893, url, valid)

proc call*(call_589894: Call_DirectoryResourcesFeaturesUpdate_589880;
          featureKey: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryResourcesFeaturesUpdate
  ## Updates a feature.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   featureKey: string (required)
  ##             : The unique ID of the feature to update.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589895 = newJObject()
  var query_589896 = newJObject()
  var body_589897 = newJObject()
  add(query_589896, "fields", newJString(fields))
  add(query_589896, "quotaUser", newJString(quotaUser))
  add(query_589896, "alt", newJString(alt))
  add(path_589895, "featureKey", newJString(featureKey))
  add(query_589896, "oauth_token", newJString(oauthToken))
  add(query_589896, "userIp", newJString(userIp))
  add(query_589896, "key", newJString(key))
  add(path_589895, "customer", newJString(customer))
  if body != nil:
    body_589897 = body
  add(query_589896, "prettyPrint", newJBool(prettyPrint))
  result = call_589894.call(path_589895, query_589896, nil, nil, body_589897)

var directoryResourcesFeaturesUpdate* = Call_DirectoryResourcesFeaturesUpdate_589880(
    name: "directoryResourcesFeaturesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesUpdate_589881,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesUpdate_589882,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesGet_589864 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesFeaturesGet_589866(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesGet_589865(path: JsonNode; query: JsonNode;
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
  var valid_589867 = path.getOrDefault("featureKey")
  valid_589867 = validateParameter(valid_589867, JString, required = true,
                                 default = nil)
  if valid_589867 != nil:
    section.add "featureKey", valid_589867
  var valid_589868 = path.getOrDefault("customer")
  valid_589868 = validateParameter(valid_589868, JString, required = true,
                                 default = nil)
  if valid_589868 != nil:
    section.add "customer", valid_589868
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
  var valid_589869 = query.getOrDefault("fields")
  valid_589869 = validateParameter(valid_589869, JString, required = false,
                                 default = nil)
  if valid_589869 != nil:
    section.add "fields", valid_589869
  var valid_589870 = query.getOrDefault("quotaUser")
  valid_589870 = validateParameter(valid_589870, JString, required = false,
                                 default = nil)
  if valid_589870 != nil:
    section.add "quotaUser", valid_589870
  var valid_589871 = query.getOrDefault("alt")
  valid_589871 = validateParameter(valid_589871, JString, required = false,
                                 default = newJString("json"))
  if valid_589871 != nil:
    section.add "alt", valid_589871
  var valid_589872 = query.getOrDefault("oauth_token")
  valid_589872 = validateParameter(valid_589872, JString, required = false,
                                 default = nil)
  if valid_589872 != nil:
    section.add "oauth_token", valid_589872
  var valid_589873 = query.getOrDefault("userIp")
  valid_589873 = validateParameter(valid_589873, JString, required = false,
                                 default = nil)
  if valid_589873 != nil:
    section.add "userIp", valid_589873
  var valid_589874 = query.getOrDefault("key")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "key", valid_589874
  var valid_589875 = query.getOrDefault("prettyPrint")
  valid_589875 = validateParameter(valid_589875, JBool, required = false,
                                 default = newJBool(true))
  if valid_589875 != nil:
    section.add "prettyPrint", valid_589875
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589876: Call_DirectoryResourcesFeaturesGet_589864; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a feature.
  ## 
  let valid = call_589876.validator(path, query, header, formData, body)
  let scheme = call_589876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589876.url(scheme.get, call_589876.host, call_589876.base,
                         call_589876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589876, url, valid)

proc call*(call_589877: Call_DirectoryResourcesFeaturesGet_589864;
          featureKey: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryResourcesFeaturesGet
  ## Retrieves a feature.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   featureKey: string (required)
  ##             : The unique ID of the feature to retrieve.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589878 = newJObject()
  var query_589879 = newJObject()
  add(query_589879, "fields", newJString(fields))
  add(query_589879, "quotaUser", newJString(quotaUser))
  add(query_589879, "alt", newJString(alt))
  add(path_589878, "featureKey", newJString(featureKey))
  add(query_589879, "oauth_token", newJString(oauthToken))
  add(query_589879, "userIp", newJString(userIp))
  add(query_589879, "key", newJString(key))
  add(path_589878, "customer", newJString(customer))
  add(query_589879, "prettyPrint", newJBool(prettyPrint))
  result = call_589877.call(path_589878, query_589879, nil, nil, nil)

var directoryResourcesFeaturesGet* = Call_DirectoryResourcesFeaturesGet_589864(
    name: "directoryResourcesFeaturesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesGet_589865,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesGet_589866,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesPatch_589914 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesFeaturesPatch_589916(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesPatch_589915(path: JsonNode;
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
  var valid_589917 = path.getOrDefault("featureKey")
  valid_589917 = validateParameter(valid_589917, JString, required = true,
                                 default = nil)
  if valid_589917 != nil:
    section.add "featureKey", valid_589917
  var valid_589918 = path.getOrDefault("customer")
  valid_589918 = validateParameter(valid_589918, JString, required = true,
                                 default = nil)
  if valid_589918 != nil:
    section.add "customer", valid_589918
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
  var valid_589919 = query.getOrDefault("fields")
  valid_589919 = validateParameter(valid_589919, JString, required = false,
                                 default = nil)
  if valid_589919 != nil:
    section.add "fields", valid_589919
  var valid_589920 = query.getOrDefault("quotaUser")
  valid_589920 = validateParameter(valid_589920, JString, required = false,
                                 default = nil)
  if valid_589920 != nil:
    section.add "quotaUser", valid_589920
  var valid_589921 = query.getOrDefault("alt")
  valid_589921 = validateParameter(valid_589921, JString, required = false,
                                 default = newJString("json"))
  if valid_589921 != nil:
    section.add "alt", valid_589921
  var valid_589922 = query.getOrDefault("oauth_token")
  valid_589922 = validateParameter(valid_589922, JString, required = false,
                                 default = nil)
  if valid_589922 != nil:
    section.add "oauth_token", valid_589922
  var valid_589923 = query.getOrDefault("userIp")
  valid_589923 = validateParameter(valid_589923, JString, required = false,
                                 default = nil)
  if valid_589923 != nil:
    section.add "userIp", valid_589923
  var valid_589924 = query.getOrDefault("key")
  valid_589924 = validateParameter(valid_589924, JString, required = false,
                                 default = nil)
  if valid_589924 != nil:
    section.add "key", valid_589924
  var valid_589925 = query.getOrDefault("prettyPrint")
  valid_589925 = validateParameter(valid_589925, JBool, required = false,
                                 default = newJBool(true))
  if valid_589925 != nil:
    section.add "prettyPrint", valid_589925
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

proc call*(call_589927: Call_DirectoryResourcesFeaturesPatch_589914;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature. This method supports patch semantics.
  ## 
  let valid = call_589927.validator(path, query, header, formData, body)
  let scheme = call_589927.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589927.url(scheme.get, call_589927.host, call_589927.base,
                         call_589927.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589927, url, valid)

proc call*(call_589928: Call_DirectoryResourcesFeaturesPatch_589914;
          featureKey: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryResourcesFeaturesPatch
  ## Updates a feature. This method supports patch semantics.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   featureKey: string (required)
  ##             : The unique ID of the feature to update.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589929 = newJObject()
  var query_589930 = newJObject()
  var body_589931 = newJObject()
  add(query_589930, "fields", newJString(fields))
  add(query_589930, "quotaUser", newJString(quotaUser))
  add(query_589930, "alt", newJString(alt))
  add(path_589929, "featureKey", newJString(featureKey))
  add(query_589930, "oauth_token", newJString(oauthToken))
  add(query_589930, "userIp", newJString(userIp))
  add(query_589930, "key", newJString(key))
  add(path_589929, "customer", newJString(customer))
  if body != nil:
    body_589931 = body
  add(query_589930, "prettyPrint", newJBool(prettyPrint))
  result = call_589928.call(path_589929, query_589930, nil, nil, body_589931)

var directoryResourcesFeaturesPatch* = Call_DirectoryResourcesFeaturesPatch_589914(
    name: "directoryResourcesFeaturesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesPatch_589915,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesPatch_589916,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesDelete_589898 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesFeaturesDelete_589900(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesDelete_589899(path: JsonNode;
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
  var valid_589901 = path.getOrDefault("featureKey")
  valid_589901 = validateParameter(valid_589901, JString, required = true,
                                 default = nil)
  if valid_589901 != nil:
    section.add "featureKey", valid_589901
  var valid_589902 = path.getOrDefault("customer")
  valid_589902 = validateParameter(valid_589902, JString, required = true,
                                 default = nil)
  if valid_589902 != nil:
    section.add "customer", valid_589902
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
  var valid_589903 = query.getOrDefault("fields")
  valid_589903 = validateParameter(valid_589903, JString, required = false,
                                 default = nil)
  if valid_589903 != nil:
    section.add "fields", valid_589903
  var valid_589904 = query.getOrDefault("quotaUser")
  valid_589904 = validateParameter(valid_589904, JString, required = false,
                                 default = nil)
  if valid_589904 != nil:
    section.add "quotaUser", valid_589904
  var valid_589905 = query.getOrDefault("alt")
  valid_589905 = validateParameter(valid_589905, JString, required = false,
                                 default = newJString("json"))
  if valid_589905 != nil:
    section.add "alt", valid_589905
  var valid_589906 = query.getOrDefault("oauth_token")
  valid_589906 = validateParameter(valid_589906, JString, required = false,
                                 default = nil)
  if valid_589906 != nil:
    section.add "oauth_token", valid_589906
  var valid_589907 = query.getOrDefault("userIp")
  valid_589907 = validateParameter(valid_589907, JString, required = false,
                                 default = nil)
  if valid_589907 != nil:
    section.add "userIp", valid_589907
  var valid_589908 = query.getOrDefault("key")
  valid_589908 = validateParameter(valid_589908, JString, required = false,
                                 default = nil)
  if valid_589908 != nil:
    section.add "key", valid_589908
  var valid_589909 = query.getOrDefault("prettyPrint")
  valid_589909 = validateParameter(valid_589909, JBool, required = false,
                                 default = newJBool(true))
  if valid_589909 != nil:
    section.add "prettyPrint", valid_589909
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589910: Call_DirectoryResourcesFeaturesDelete_589898;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a feature.
  ## 
  let valid = call_589910.validator(path, query, header, formData, body)
  let scheme = call_589910.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589910.url(scheme.get, call_589910.host, call_589910.base,
                         call_589910.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589910, url, valid)

proc call*(call_589911: Call_DirectoryResourcesFeaturesDelete_589898;
          featureKey: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryResourcesFeaturesDelete
  ## Deletes a feature.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   featureKey: string (required)
  ##             : The unique ID of the feature to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589912 = newJObject()
  var query_589913 = newJObject()
  add(query_589913, "fields", newJString(fields))
  add(query_589913, "quotaUser", newJString(quotaUser))
  add(query_589913, "alt", newJString(alt))
  add(path_589912, "featureKey", newJString(featureKey))
  add(query_589913, "oauth_token", newJString(oauthToken))
  add(query_589913, "userIp", newJString(userIp))
  add(query_589913, "key", newJString(key))
  add(path_589912, "customer", newJString(customer))
  add(query_589913, "prettyPrint", newJBool(prettyPrint))
  result = call_589911.call(path_589912, query_589913, nil, nil, nil)

var directoryResourcesFeaturesDelete* = Call_DirectoryResourcesFeaturesDelete_589898(
    name: "directoryResourcesFeaturesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesDelete_589899,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesDelete_589900,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesRename_589932 = ref object of OpenApiRestCall_588466
proc url_DirectoryResourcesFeaturesRename_589934(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesRename_589933(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Renames a feature.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   oldName: JString (required)
  ##          : The unique ID of the feature to rename.
  ##   customer: JString (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `oldName` field"
  var valid_589935 = path.getOrDefault("oldName")
  valid_589935 = validateParameter(valid_589935, JString, required = true,
                                 default = nil)
  if valid_589935 != nil:
    section.add "oldName", valid_589935
  var valid_589936 = path.getOrDefault("customer")
  valid_589936 = validateParameter(valid_589936, JString, required = true,
                                 default = nil)
  if valid_589936 != nil:
    section.add "customer", valid_589936
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
  var valid_589937 = query.getOrDefault("fields")
  valid_589937 = validateParameter(valid_589937, JString, required = false,
                                 default = nil)
  if valid_589937 != nil:
    section.add "fields", valid_589937
  var valid_589938 = query.getOrDefault("quotaUser")
  valid_589938 = validateParameter(valid_589938, JString, required = false,
                                 default = nil)
  if valid_589938 != nil:
    section.add "quotaUser", valid_589938
  var valid_589939 = query.getOrDefault("alt")
  valid_589939 = validateParameter(valid_589939, JString, required = false,
                                 default = newJString("json"))
  if valid_589939 != nil:
    section.add "alt", valid_589939
  var valid_589940 = query.getOrDefault("oauth_token")
  valid_589940 = validateParameter(valid_589940, JString, required = false,
                                 default = nil)
  if valid_589940 != nil:
    section.add "oauth_token", valid_589940
  var valid_589941 = query.getOrDefault("userIp")
  valid_589941 = validateParameter(valid_589941, JString, required = false,
                                 default = nil)
  if valid_589941 != nil:
    section.add "userIp", valid_589941
  var valid_589942 = query.getOrDefault("key")
  valid_589942 = validateParameter(valid_589942, JString, required = false,
                                 default = nil)
  if valid_589942 != nil:
    section.add "key", valid_589942
  var valid_589943 = query.getOrDefault("prettyPrint")
  valid_589943 = validateParameter(valid_589943, JBool, required = false,
                                 default = newJBool(true))
  if valid_589943 != nil:
    section.add "prettyPrint", valid_589943
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

proc call*(call_589945: Call_DirectoryResourcesFeaturesRename_589932;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a feature.
  ## 
  let valid = call_589945.validator(path, query, header, formData, body)
  let scheme = call_589945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589945.url(scheme.get, call_589945.host, call_589945.base,
                         call_589945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589945, url, valid)

proc call*(call_589946: Call_DirectoryResourcesFeaturesRename_589932;
          oldName: string; customer: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryResourcesFeaturesRename
  ## Renames a feature.
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
  ##   oldName: string (required)
  ##          : The unique ID of the feature to rename.
  ##   customer: string (required)
  ##           : The unique ID for the customer's G Suite account. As an account administrator, you can also use the my_customer alias to represent your account's customer ID.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589947 = newJObject()
  var query_589948 = newJObject()
  var body_589949 = newJObject()
  add(query_589948, "fields", newJString(fields))
  add(query_589948, "quotaUser", newJString(quotaUser))
  add(query_589948, "alt", newJString(alt))
  add(query_589948, "oauth_token", newJString(oauthToken))
  add(query_589948, "userIp", newJString(userIp))
  add(query_589948, "key", newJString(key))
  add(path_589947, "oldName", newJString(oldName))
  add(path_589947, "customer", newJString(customer))
  if body != nil:
    body_589949 = body
  add(query_589948, "prettyPrint", newJBool(prettyPrint))
  result = call_589946.call(path_589947, query_589948, nil, nil, body_589949)

var directoryResourcesFeaturesRename* = Call_DirectoryResourcesFeaturesRename_589932(
    name: "directoryResourcesFeaturesRename", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{oldName}/rename",
    validator: validate_DirectoryResourcesFeaturesRename_589933,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesRename_589934,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsInsert_589969 = ref object of OpenApiRestCall_588466
proc url_DirectoryRoleAssignmentsInsert_589971(protocol: Scheme; host: string;
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

proc validate_DirectoryRoleAssignmentsInsert_589970(path: JsonNode;
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
  var valid_589972 = path.getOrDefault("customer")
  valid_589972 = validateParameter(valid_589972, JString, required = true,
                                 default = nil)
  if valid_589972 != nil:
    section.add "customer", valid_589972
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
  var valid_589973 = query.getOrDefault("fields")
  valid_589973 = validateParameter(valid_589973, JString, required = false,
                                 default = nil)
  if valid_589973 != nil:
    section.add "fields", valid_589973
  var valid_589974 = query.getOrDefault("quotaUser")
  valid_589974 = validateParameter(valid_589974, JString, required = false,
                                 default = nil)
  if valid_589974 != nil:
    section.add "quotaUser", valid_589974
  var valid_589975 = query.getOrDefault("alt")
  valid_589975 = validateParameter(valid_589975, JString, required = false,
                                 default = newJString("json"))
  if valid_589975 != nil:
    section.add "alt", valid_589975
  var valid_589976 = query.getOrDefault("oauth_token")
  valid_589976 = validateParameter(valid_589976, JString, required = false,
                                 default = nil)
  if valid_589976 != nil:
    section.add "oauth_token", valid_589976
  var valid_589977 = query.getOrDefault("userIp")
  valid_589977 = validateParameter(valid_589977, JString, required = false,
                                 default = nil)
  if valid_589977 != nil:
    section.add "userIp", valid_589977
  var valid_589978 = query.getOrDefault("key")
  valid_589978 = validateParameter(valid_589978, JString, required = false,
                                 default = nil)
  if valid_589978 != nil:
    section.add "key", valid_589978
  var valid_589979 = query.getOrDefault("prettyPrint")
  valid_589979 = validateParameter(valid_589979, JBool, required = false,
                                 default = newJBool(true))
  if valid_589979 != nil:
    section.add "prettyPrint", valid_589979
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

proc call*(call_589981: Call_DirectoryRoleAssignmentsInsert_589969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment.
  ## 
  let valid = call_589981.validator(path, query, header, formData, body)
  let scheme = call_589981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589981.url(scheme.get, call_589981.host, call_589981.base,
                         call_589981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589981, url, valid)

proc call*(call_589982: Call_DirectoryRoleAssignmentsInsert_589969;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryRoleAssignmentsInsert
  ## Creates a role assignment.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589983 = newJObject()
  var query_589984 = newJObject()
  var body_589985 = newJObject()
  add(query_589984, "fields", newJString(fields))
  add(query_589984, "quotaUser", newJString(quotaUser))
  add(query_589984, "alt", newJString(alt))
  add(query_589984, "oauth_token", newJString(oauthToken))
  add(query_589984, "userIp", newJString(userIp))
  add(query_589984, "key", newJString(key))
  add(path_589983, "customer", newJString(customer))
  if body != nil:
    body_589985 = body
  add(query_589984, "prettyPrint", newJBool(prettyPrint))
  result = call_589982.call(path_589983, query_589984, nil, nil, body_589985)

var directoryRoleAssignmentsInsert* = Call_DirectoryRoleAssignmentsInsert_589969(
    name: "directoryRoleAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsInsert_589970,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsInsert_589971,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsList_589950 = ref object of OpenApiRestCall_588466
proc url_DirectoryRoleAssignmentsList_589952(protocol: Scheme; host: string;
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

proc validate_DirectoryRoleAssignmentsList_589951(path: JsonNode; query: JsonNode;
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
  var valid_589953 = path.getOrDefault("customer")
  valid_589953 = validateParameter(valid_589953, JString, required = true,
                                 default = nil)
  if valid_589953 != nil:
    section.add "customer", valid_589953
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   roleId: JString
  ##         : Immutable ID of a role. If included in the request, returns only role assignments containing this role ID.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   userKey: JString
  ##          : The user's primary email address, alias email address, or unique user ID. If included in the request, returns role assignments only for this user.
  section = newJObject()
  var valid_589954 = query.getOrDefault("fields")
  valid_589954 = validateParameter(valid_589954, JString, required = false,
                                 default = nil)
  if valid_589954 != nil:
    section.add "fields", valid_589954
  var valid_589955 = query.getOrDefault("pageToken")
  valid_589955 = validateParameter(valid_589955, JString, required = false,
                                 default = nil)
  if valid_589955 != nil:
    section.add "pageToken", valid_589955
  var valid_589956 = query.getOrDefault("quotaUser")
  valid_589956 = validateParameter(valid_589956, JString, required = false,
                                 default = nil)
  if valid_589956 != nil:
    section.add "quotaUser", valid_589956
  var valid_589957 = query.getOrDefault("alt")
  valid_589957 = validateParameter(valid_589957, JString, required = false,
                                 default = newJString("json"))
  if valid_589957 != nil:
    section.add "alt", valid_589957
  var valid_589958 = query.getOrDefault("oauth_token")
  valid_589958 = validateParameter(valid_589958, JString, required = false,
                                 default = nil)
  if valid_589958 != nil:
    section.add "oauth_token", valid_589958
  var valid_589959 = query.getOrDefault("userIp")
  valid_589959 = validateParameter(valid_589959, JString, required = false,
                                 default = nil)
  if valid_589959 != nil:
    section.add "userIp", valid_589959
  var valid_589960 = query.getOrDefault("maxResults")
  valid_589960 = validateParameter(valid_589960, JInt, required = false, default = nil)
  if valid_589960 != nil:
    section.add "maxResults", valid_589960
  var valid_589961 = query.getOrDefault("key")
  valid_589961 = validateParameter(valid_589961, JString, required = false,
                                 default = nil)
  if valid_589961 != nil:
    section.add "key", valid_589961
  var valid_589962 = query.getOrDefault("roleId")
  valid_589962 = validateParameter(valid_589962, JString, required = false,
                                 default = nil)
  if valid_589962 != nil:
    section.add "roleId", valid_589962
  var valid_589963 = query.getOrDefault("prettyPrint")
  valid_589963 = validateParameter(valid_589963, JBool, required = false,
                                 default = newJBool(true))
  if valid_589963 != nil:
    section.add "prettyPrint", valid_589963
  var valid_589964 = query.getOrDefault("userKey")
  valid_589964 = validateParameter(valid_589964, JString, required = false,
                                 default = nil)
  if valid_589964 != nil:
    section.add "userKey", valid_589964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589965: Call_DirectoryRoleAssignmentsList_589950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all roleAssignments.
  ## 
  let valid = call_589965.validator(path, query, header, formData, body)
  let scheme = call_589965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589965.url(scheme.get, call_589965.host, call_589965.base,
                         call_589965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589965, url, valid)

proc call*(call_589966: Call_DirectoryRoleAssignmentsList_589950; customer: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; roleId: string = "";
          prettyPrint: bool = true; userKey: string = ""): Recallable =
  ## directoryRoleAssignmentsList
  ## Retrieves a paginated list of all roleAssignments.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   roleId: string
  ##         : Immutable ID of a role. If included in the request, returns only role assignments containing this role ID.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   userKey: string
  ##          : The user's primary email address, alias email address, or unique user ID. If included in the request, returns role assignments only for this user.
  var path_589967 = newJObject()
  var query_589968 = newJObject()
  add(query_589968, "fields", newJString(fields))
  add(query_589968, "pageToken", newJString(pageToken))
  add(query_589968, "quotaUser", newJString(quotaUser))
  add(query_589968, "alt", newJString(alt))
  add(query_589968, "oauth_token", newJString(oauthToken))
  add(query_589968, "userIp", newJString(userIp))
  add(query_589968, "maxResults", newJInt(maxResults))
  add(query_589968, "key", newJString(key))
  add(query_589968, "roleId", newJString(roleId))
  add(path_589967, "customer", newJString(customer))
  add(query_589968, "prettyPrint", newJBool(prettyPrint))
  add(query_589968, "userKey", newJString(userKey))
  result = call_589966.call(path_589967, query_589968, nil, nil, nil)

var directoryRoleAssignmentsList* = Call_DirectoryRoleAssignmentsList_589950(
    name: "directoryRoleAssignmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsList_589951,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsList_589952,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsGet_589986 = ref object of OpenApiRestCall_588466
proc url_DirectoryRoleAssignmentsGet_589988(protocol: Scheme; host: string;
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

proc validate_DirectoryRoleAssignmentsGet_589987(path: JsonNode; query: JsonNode;
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
  var valid_589989 = path.getOrDefault("customer")
  valid_589989 = validateParameter(valid_589989, JString, required = true,
                                 default = nil)
  if valid_589989 != nil:
    section.add "customer", valid_589989
  var valid_589990 = path.getOrDefault("roleAssignmentId")
  valid_589990 = validateParameter(valid_589990, JString, required = true,
                                 default = nil)
  if valid_589990 != nil:
    section.add "roleAssignmentId", valid_589990
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
  var valid_589991 = query.getOrDefault("fields")
  valid_589991 = validateParameter(valid_589991, JString, required = false,
                                 default = nil)
  if valid_589991 != nil:
    section.add "fields", valid_589991
  var valid_589992 = query.getOrDefault("quotaUser")
  valid_589992 = validateParameter(valid_589992, JString, required = false,
                                 default = nil)
  if valid_589992 != nil:
    section.add "quotaUser", valid_589992
  var valid_589993 = query.getOrDefault("alt")
  valid_589993 = validateParameter(valid_589993, JString, required = false,
                                 default = newJString("json"))
  if valid_589993 != nil:
    section.add "alt", valid_589993
  var valid_589994 = query.getOrDefault("oauth_token")
  valid_589994 = validateParameter(valid_589994, JString, required = false,
                                 default = nil)
  if valid_589994 != nil:
    section.add "oauth_token", valid_589994
  var valid_589995 = query.getOrDefault("userIp")
  valid_589995 = validateParameter(valid_589995, JString, required = false,
                                 default = nil)
  if valid_589995 != nil:
    section.add "userIp", valid_589995
  var valid_589996 = query.getOrDefault("key")
  valid_589996 = validateParameter(valid_589996, JString, required = false,
                                 default = nil)
  if valid_589996 != nil:
    section.add "key", valid_589996
  var valid_589997 = query.getOrDefault("prettyPrint")
  valid_589997 = validateParameter(valid_589997, JBool, required = false,
                                 default = newJBool(true))
  if valid_589997 != nil:
    section.add "prettyPrint", valid_589997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589998: Call_DirectoryRoleAssignmentsGet_589986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a role assignment.
  ## 
  let valid = call_589998.validator(path, query, header, formData, body)
  let scheme = call_589998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589998.url(scheme.get, call_589998.host, call_589998.base,
                         call_589998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589998, url, valid)

proc call*(call_589999: Call_DirectoryRoleAssignmentsGet_589986; customer: string;
          roleAssignmentId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryRoleAssignmentsGet
  ## Retrieve a role assignment.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   roleAssignmentId: string (required)
  ##                   : Immutable ID of the role assignment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590000 = newJObject()
  var query_590001 = newJObject()
  add(query_590001, "fields", newJString(fields))
  add(query_590001, "quotaUser", newJString(quotaUser))
  add(query_590001, "alt", newJString(alt))
  add(query_590001, "oauth_token", newJString(oauthToken))
  add(query_590001, "userIp", newJString(userIp))
  add(query_590001, "key", newJString(key))
  add(path_590000, "customer", newJString(customer))
  add(path_590000, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_590001, "prettyPrint", newJBool(prettyPrint))
  result = call_589999.call(path_590000, query_590001, nil, nil, nil)

var directoryRoleAssignmentsGet* = Call_DirectoryRoleAssignmentsGet_589986(
    name: "directoryRoleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsGet_589987,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsGet_589988,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsDelete_590002 = ref object of OpenApiRestCall_588466
proc url_DirectoryRoleAssignmentsDelete_590004(protocol: Scheme; host: string;
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

proc validate_DirectoryRoleAssignmentsDelete_590003(path: JsonNode;
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
  var valid_590005 = path.getOrDefault("customer")
  valid_590005 = validateParameter(valid_590005, JString, required = true,
                                 default = nil)
  if valid_590005 != nil:
    section.add "customer", valid_590005
  var valid_590006 = path.getOrDefault("roleAssignmentId")
  valid_590006 = validateParameter(valid_590006, JString, required = true,
                                 default = nil)
  if valid_590006 != nil:
    section.add "roleAssignmentId", valid_590006
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
  var valid_590007 = query.getOrDefault("fields")
  valid_590007 = validateParameter(valid_590007, JString, required = false,
                                 default = nil)
  if valid_590007 != nil:
    section.add "fields", valid_590007
  var valid_590008 = query.getOrDefault("quotaUser")
  valid_590008 = validateParameter(valid_590008, JString, required = false,
                                 default = nil)
  if valid_590008 != nil:
    section.add "quotaUser", valid_590008
  var valid_590009 = query.getOrDefault("alt")
  valid_590009 = validateParameter(valid_590009, JString, required = false,
                                 default = newJString("json"))
  if valid_590009 != nil:
    section.add "alt", valid_590009
  var valid_590010 = query.getOrDefault("oauth_token")
  valid_590010 = validateParameter(valid_590010, JString, required = false,
                                 default = nil)
  if valid_590010 != nil:
    section.add "oauth_token", valid_590010
  var valid_590011 = query.getOrDefault("userIp")
  valid_590011 = validateParameter(valid_590011, JString, required = false,
                                 default = nil)
  if valid_590011 != nil:
    section.add "userIp", valid_590011
  var valid_590012 = query.getOrDefault("key")
  valid_590012 = validateParameter(valid_590012, JString, required = false,
                                 default = nil)
  if valid_590012 != nil:
    section.add "key", valid_590012
  var valid_590013 = query.getOrDefault("prettyPrint")
  valid_590013 = validateParameter(valid_590013, JBool, required = false,
                                 default = newJBool(true))
  if valid_590013 != nil:
    section.add "prettyPrint", valid_590013
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590014: Call_DirectoryRoleAssignmentsDelete_590002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_590014.validator(path, query, header, formData, body)
  let scheme = call_590014.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590014.url(scheme.get, call_590014.host, call_590014.base,
                         call_590014.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590014, url, valid)

proc call*(call_590015: Call_DirectoryRoleAssignmentsDelete_590002;
          customer: string; roleAssignmentId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryRoleAssignmentsDelete
  ## Deletes a role assignment.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   roleAssignmentId: string (required)
  ##                   : Immutable ID of the role assignment.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590016 = newJObject()
  var query_590017 = newJObject()
  add(query_590017, "fields", newJString(fields))
  add(query_590017, "quotaUser", newJString(quotaUser))
  add(query_590017, "alt", newJString(alt))
  add(query_590017, "oauth_token", newJString(oauthToken))
  add(query_590017, "userIp", newJString(userIp))
  add(query_590017, "key", newJString(key))
  add(path_590016, "customer", newJString(customer))
  add(path_590016, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_590017, "prettyPrint", newJBool(prettyPrint))
  result = call_590015.call(path_590016, query_590017, nil, nil, nil)

var directoryRoleAssignmentsDelete* = Call_DirectoryRoleAssignmentsDelete_590002(
    name: "directoryRoleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsDelete_590003,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsDelete_590004,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesInsert_590035 = ref object of OpenApiRestCall_588466
proc url_DirectoryRolesInsert_590037(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesInsert_590036(path: JsonNode; query: JsonNode;
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
  var valid_590038 = path.getOrDefault("customer")
  valid_590038 = validateParameter(valid_590038, JString, required = true,
                                 default = nil)
  if valid_590038 != nil:
    section.add "customer", valid_590038
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
  var valid_590039 = query.getOrDefault("fields")
  valid_590039 = validateParameter(valid_590039, JString, required = false,
                                 default = nil)
  if valid_590039 != nil:
    section.add "fields", valid_590039
  var valid_590040 = query.getOrDefault("quotaUser")
  valid_590040 = validateParameter(valid_590040, JString, required = false,
                                 default = nil)
  if valid_590040 != nil:
    section.add "quotaUser", valid_590040
  var valid_590041 = query.getOrDefault("alt")
  valid_590041 = validateParameter(valid_590041, JString, required = false,
                                 default = newJString("json"))
  if valid_590041 != nil:
    section.add "alt", valid_590041
  var valid_590042 = query.getOrDefault("oauth_token")
  valid_590042 = validateParameter(valid_590042, JString, required = false,
                                 default = nil)
  if valid_590042 != nil:
    section.add "oauth_token", valid_590042
  var valid_590043 = query.getOrDefault("userIp")
  valid_590043 = validateParameter(valid_590043, JString, required = false,
                                 default = nil)
  if valid_590043 != nil:
    section.add "userIp", valid_590043
  var valid_590044 = query.getOrDefault("key")
  valid_590044 = validateParameter(valid_590044, JString, required = false,
                                 default = nil)
  if valid_590044 != nil:
    section.add "key", valid_590044
  var valid_590045 = query.getOrDefault("prettyPrint")
  valid_590045 = validateParameter(valid_590045, JBool, required = false,
                                 default = newJBool(true))
  if valid_590045 != nil:
    section.add "prettyPrint", valid_590045
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

proc call*(call_590047: Call_DirectoryRolesInsert_590035; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role.
  ## 
  let valid = call_590047.validator(path, query, header, formData, body)
  let scheme = call_590047.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590047.url(scheme.get, call_590047.host, call_590047.base,
                         call_590047.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590047, url, valid)

proc call*(call_590048: Call_DirectoryRolesInsert_590035; customer: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryRolesInsert
  ## Creates a role.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590049 = newJObject()
  var query_590050 = newJObject()
  var body_590051 = newJObject()
  add(query_590050, "fields", newJString(fields))
  add(query_590050, "quotaUser", newJString(quotaUser))
  add(query_590050, "alt", newJString(alt))
  add(query_590050, "oauth_token", newJString(oauthToken))
  add(query_590050, "userIp", newJString(userIp))
  add(query_590050, "key", newJString(key))
  add(path_590049, "customer", newJString(customer))
  if body != nil:
    body_590051 = body
  add(query_590050, "prettyPrint", newJBool(prettyPrint))
  result = call_590048.call(path_590049, query_590050, nil, nil, body_590051)

var directoryRolesInsert* = Call_DirectoryRolesInsert_590035(
    name: "directoryRolesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesInsert_590036, base: "/admin/directory/v1",
    url: url_DirectoryRolesInsert_590037, schemes: {Scheme.Https})
type
  Call_DirectoryRolesList_590018 = ref object of OpenApiRestCall_588466
proc url_DirectoryRolesList_590020(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesList_590019(path: JsonNode; query: JsonNode;
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
  var valid_590021 = path.getOrDefault("customer")
  valid_590021 = validateParameter(valid_590021, JString, required = true,
                                 default = nil)
  if valid_590021 != nil:
    section.add "customer", valid_590021
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify the next page in the list.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590022 = query.getOrDefault("fields")
  valid_590022 = validateParameter(valid_590022, JString, required = false,
                                 default = nil)
  if valid_590022 != nil:
    section.add "fields", valid_590022
  var valid_590023 = query.getOrDefault("pageToken")
  valid_590023 = validateParameter(valid_590023, JString, required = false,
                                 default = nil)
  if valid_590023 != nil:
    section.add "pageToken", valid_590023
  var valid_590024 = query.getOrDefault("quotaUser")
  valid_590024 = validateParameter(valid_590024, JString, required = false,
                                 default = nil)
  if valid_590024 != nil:
    section.add "quotaUser", valid_590024
  var valid_590025 = query.getOrDefault("alt")
  valid_590025 = validateParameter(valid_590025, JString, required = false,
                                 default = newJString("json"))
  if valid_590025 != nil:
    section.add "alt", valid_590025
  var valid_590026 = query.getOrDefault("oauth_token")
  valid_590026 = validateParameter(valid_590026, JString, required = false,
                                 default = nil)
  if valid_590026 != nil:
    section.add "oauth_token", valid_590026
  var valid_590027 = query.getOrDefault("userIp")
  valid_590027 = validateParameter(valid_590027, JString, required = false,
                                 default = nil)
  if valid_590027 != nil:
    section.add "userIp", valid_590027
  var valid_590028 = query.getOrDefault("maxResults")
  valid_590028 = validateParameter(valid_590028, JInt, required = false, default = nil)
  if valid_590028 != nil:
    section.add "maxResults", valid_590028
  var valid_590029 = query.getOrDefault("key")
  valid_590029 = validateParameter(valid_590029, JString, required = false,
                                 default = nil)
  if valid_590029 != nil:
    section.add "key", valid_590029
  var valid_590030 = query.getOrDefault("prettyPrint")
  valid_590030 = validateParameter(valid_590030, JBool, required = false,
                                 default = newJBool(true))
  if valid_590030 != nil:
    section.add "prettyPrint", valid_590030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590031: Call_DirectoryRolesList_590018; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all the roles in a domain.
  ## 
  let valid = call_590031.validator(path, query, header, formData, body)
  let scheme = call_590031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590031.url(scheme.get, call_590031.host, call_590031.base,
                         call_590031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590031, url, valid)

proc call*(call_590032: Call_DirectoryRolesList_590018; customer: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryRolesList
  ## Retrieves a paginated list of all the roles in a domain.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify the next page in the list.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590033 = newJObject()
  var query_590034 = newJObject()
  add(query_590034, "fields", newJString(fields))
  add(query_590034, "pageToken", newJString(pageToken))
  add(query_590034, "quotaUser", newJString(quotaUser))
  add(query_590034, "alt", newJString(alt))
  add(query_590034, "oauth_token", newJString(oauthToken))
  add(query_590034, "userIp", newJString(userIp))
  add(query_590034, "maxResults", newJInt(maxResults))
  add(query_590034, "key", newJString(key))
  add(path_590033, "customer", newJString(customer))
  add(query_590034, "prettyPrint", newJBool(prettyPrint))
  result = call_590032.call(path_590033, query_590034, nil, nil, nil)

var directoryRolesList* = Call_DirectoryRolesList_590018(
    name: "directoryRolesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesList_590019, base: "/admin/directory/v1",
    url: url_DirectoryRolesList_590020, schemes: {Scheme.Https})
type
  Call_DirectoryPrivilegesList_590052 = ref object of OpenApiRestCall_588466
proc url_DirectoryPrivilegesList_590054(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryPrivilegesList_590053(path: JsonNode; query: JsonNode;
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
  var valid_590055 = path.getOrDefault("customer")
  valid_590055 = validateParameter(valid_590055, JString, required = true,
                                 default = nil)
  if valid_590055 != nil:
    section.add "customer", valid_590055
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
  var valid_590056 = query.getOrDefault("fields")
  valid_590056 = validateParameter(valid_590056, JString, required = false,
                                 default = nil)
  if valid_590056 != nil:
    section.add "fields", valid_590056
  var valid_590057 = query.getOrDefault("quotaUser")
  valid_590057 = validateParameter(valid_590057, JString, required = false,
                                 default = nil)
  if valid_590057 != nil:
    section.add "quotaUser", valid_590057
  var valid_590058 = query.getOrDefault("alt")
  valid_590058 = validateParameter(valid_590058, JString, required = false,
                                 default = newJString("json"))
  if valid_590058 != nil:
    section.add "alt", valid_590058
  var valid_590059 = query.getOrDefault("oauth_token")
  valid_590059 = validateParameter(valid_590059, JString, required = false,
                                 default = nil)
  if valid_590059 != nil:
    section.add "oauth_token", valid_590059
  var valid_590060 = query.getOrDefault("userIp")
  valid_590060 = validateParameter(valid_590060, JString, required = false,
                                 default = nil)
  if valid_590060 != nil:
    section.add "userIp", valid_590060
  var valid_590061 = query.getOrDefault("key")
  valid_590061 = validateParameter(valid_590061, JString, required = false,
                                 default = nil)
  if valid_590061 != nil:
    section.add "key", valid_590061
  var valid_590062 = query.getOrDefault("prettyPrint")
  valid_590062 = validateParameter(valid_590062, JBool, required = false,
                                 default = newJBool(true))
  if valid_590062 != nil:
    section.add "prettyPrint", valid_590062
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590063: Call_DirectoryPrivilegesList_590052; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all privileges for a customer.
  ## 
  let valid = call_590063.validator(path, query, header, formData, body)
  let scheme = call_590063.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590063.url(scheme.get, call_590063.host, call_590063.base,
                         call_590063.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590063, url, valid)

proc call*(call_590064: Call_DirectoryPrivilegesList_590052; customer: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryPrivilegesList
  ## Retrieves a paginated list of all privileges for a customer.
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
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590065 = newJObject()
  var query_590066 = newJObject()
  add(query_590066, "fields", newJString(fields))
  add(query_590066, "quotaUser", newJString(quotaUser))
  add(query_590066, "alt", newJString(alt))
  add(query_590066, "oauth_token", newJString(oauthToken))
  add(query_590066, "userIp", newJString(userIp))
  add(query_590066, "key", newJString(key))
  add(path_590065, "customer", newJString(customer))
  add(query_590066, "prettyPrint", newJBool(prettyPrint))
  result = call_590064.call(path_590065, query_590066, nil, nil, nil)

var directoryPrivilegesList* = Call_DirectoryPrivilegesList_590052(
    name: "directoryPrivilegesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roles/ALL/privileges",
    validator: validate_DirectoryPrivilegesList_590053,
    base: "/admin/directory/v1", url: url_DirectoryPrivilegesList_590054,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesUpdate_590083 = ref object of OpenApiRestCall_588466
proc url_DirectoryRolesUpdate_590085(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesUpdate_590084(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleId: JString (required)
  ##         : Immutable ID of the role.
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roleId` field"
  var valid_590086 = path.getOrDefault("roleId")
  valid_590086 = validateParameter(valid_590086, JString, required = true,
                                 default = nil)
  if valid_590086 != nil:
    section.add "roleId", valid_590086
  var valid_590087 = path.getOrDefault("customer")
  valid_590087 = validateParameter(valid_590087, JString, required = true,
                                 default = nil)
  if valid_590087 != nil:
    section.add "customer", valid_590087
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
  var valid_590088 = query.getOrDefault("fields")
  valid_590088 = validateParameter(valid_590088, JString, required = false,
                                 default = nil)
  if valid_590088 != nil:
    section.add "fields", valid_590088
  var valid_590089 = query.getOrDefault("quotaUser")
  valid_590089 = validateParameter(valid_590089, JString, required = false,
                                 default = nil)
  if valid_590089 != nil:
    section.add "quotaUser", valid_590089
  var valid_590090 = query.getOrDefault("alt")
  valid_590090 = validateParameter(valid_590090, JString, required = false,
                                 default = newJString("json"))
  if valid_590090 != nil:
    section.add "alt", valid_590090
  var valid_590091 = query.getOrDefault("oauth_token")
  valid_590091 = validateParameter(valid_590091, JString, required = false,
                                 default = nil)
  if valid_590091 != nil:
    section.add "oauth_token", valid_590091
  var valid_590092 = query.getOrDefault("userIp")
  valid_590092 = validateParameter(valid_590092, JString, required = false,
                                 default = nil)
  if valid_590092 != nil:
    section.add "userIp", valid_590092
  var valid_590093 = query.getOrDefault("key")
  valid_590093 = validateParameter(valid_590093, JString, required = false,
                                 default = nil)
  if valid_590093 != nil:
    section.add "key", valid_590093
  var valid_590094 = query.getOrDefault("prettyPrint")
  valid_590094 = validateParameter(valid_590094, JBool, required = false,
                                 default = newJBool(true))
  if valid_590094 != nil:
    section.add "prettyPrint", valid_590094
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

proc call*(call_590096: Call_DirectoryRolesUpdate_590083; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role.
  ## 
  let valid = call_590096.validator(path, query, header, formData, body)
  let scheme = call_590096.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590096.url(scheme.get, call_590096.host, call_590096.base,
                         call_590096.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590096, url, valid)

proc call*(call_590097: Call_DirectoryRolesUpdate_590083; roleId: string;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryRolesUpdate
  ## Updates a role.
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
  ##   roleId: string (required)
  ##         : Immutable ID of the role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590098 = newJObject()
  var query_590099 = newJObject()
  var body_590100 = newJObject()
  add(query_590099, "fields", newJString(fields))
  add(query_590099, "quotaUser", newJString(quotaUser))
  add(query_590099, "alt", newJString(alt))
  add(query_590099, "oauth_token", newJString(oauthToken))
  add(query_590099, "userIp", newJString(userIp))
  add(path_590098, "roleId", newJString(roleId))
  add(query_590099, "key", newJString(key))
  add(path_590098, "customer", newJString(customer))
  if body != nil:
    body_590100 = body
  add(query_590099, "prettyPrint", newJBool(prettyPrint))
  result = call_590097.call(path_590098, query_590099, nil, nil, body_590100)

var directoryRolesUpdate* = Call_DirectoryRolesUpdate_590083(
    name: "directoryRolesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesUpdate_590084, base: "/admin/directory/v1",
    url: url_DirectoryRolesUpdate_590085, schemes: {Scheme.Https})
type
  Call_DirectoryRolesGet_590067 = ref object of OpenApiRestCall_588466
proc url_DirectoryRolesGet_590069(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesGet_590068(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleId: JString (required)
  ##         : Immutable ID of the role.
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roleId` field"
  var valid_590070 = path.getOrDefault("roleId")
  valid_590070 = validateParameter(valid_590070, JString, required = true,
                                 default = nil)
  if valid_590070 != nil:
    section.add "roleId", valid_590070
  var valid_590071 = path.getOrDefault("customer")
  valid_590071 = validateParameter(valid_590071, JString, required = true,
                                 default = nil)
  if valid_590071 != nil:
    section.add "customer", valid_590071
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
  var valid_590072 = query.getOrDefault("fields")
  valid_590072 = validateParameter(valid_590072, JString, required = false,
                                 default = nil)
  if valid_590072 != nil:
    section.add "fields", valid_590072
  var valid_590073 = query.getOrDefault("quotaUser")
  valid_590073 = validateParameter(valid_590073, JString, required = false,
                                 default = nil)
  if valid_590073 != nil:
    section.add "quotaUser", valid_590073
  var valid_590074 = query.getOrDefault("alt")
  valid_590074 = validateParameter(valid_590074, JString, required = false,
                                 default = newJString("json"))
  if valid_590074 != nil:
    section.add "alt", valid_590074
  var valid_590075 = query.getOrDefault("oauth_token")
  valid_590075 = validateParameter(valid_590075, JString, required = false,
                                 default = nil)
  if valid_590075 != nil:
    section.add "oauth_token", valid_590075
  var valid_590076 = query.getOrDefault("userIp")
  valid_590076 = validateParameter(valid_590076, JString, required = false,
                                 default = nil)
  if valid_590076 != nil:
    section.add "userIp", valid_590076
  var valid_590077 = query.getOrDefault("key")
  valid_590077 = validateParameter(valid_590077, JString, required = false,
                                 default = nil)
  if valid_590077 != nil:
    section.add "key", valid_590077
  var valid_590078 = query.getOrDefault("prettyPrint")
  valid_590078 = validateParameter(valid_590078, JBool, required = false,
                                 default = newJBool(true))
  if valid_590078 != nil:
    section.add "prettyPrint", valid_590078
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590079: Call_DirectoryRolesGet_590067; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a role.
  ## 
  let valid = call_590079.validator(path, query, header, formData, body)
  let scheme = call_590079.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590079.url(scheme.get, call_590079.host, call_590079.base,
                         call_590079.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590079, url, valid)

proc call*(call_590080: Call_DirectoryRolesGet_590067; roleId: string;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryRolesGet
  ## Retrieves a role.
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
  ##   roleId: string (required)
  ##         : Immutable ID of the role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590081 = newJObject()
  var query_590082 = newJObject()
  add(query_590082, "fields", newJString(fields))
  add(query_590082, "quotaUser", newJString(quotaUser))
  add(query_590082, "alt", newJString(alt))
  add(query_590082, "oauth_token", newJString(oauthToken))
  add(query_590082, "userIp", newJString(userIp))
  add(path_590081, "roleId", newJString(roleId))
  add(query_590082, "key", newJString(key))
  add(path_590081, "customer", newJString(customer))
  add(query_590082, "prettyPrint", newJBool(prettyPrint))
  result = call_590080.call(path_590081, query_590082, nil, nil, nil)

var directoryRolesGet* = Call_DirectoryRolesGet_590067(name: "directoryRolesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesGet_590068, base: "/admin/directory/v1",
    url: url_DirectoryRolesGet_590069, schemes: {Scheme.Https})
type
  Call_DirectoryRolesPatch_590117 = ref object of OpenApiRestCall_588466
proc url_DirectoryRolesPatch_590119(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesPatch_590118(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a role. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleId: JString (required)
  ##         : Immutable ID of the role.
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roleId` field"
  var valid_590120 = path.getOrDefault("roleId")
  valid_590120 = validateParameter(valid_590120, JString, required = true,
                                 default = nil)
  if valid_590120 != nil:
    section.add "roleId", valid_590120
  var valid_590121 = path.getOrDefault("customer")
  valid_590121 = validateParameter(valid_590121, JString, required = true,
                                 default = nil)
  if valid_590121 != nil:
    section.add "customer", valid_590121
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
  var valid_590122 = query.getOrDefault("fields")
  valid_590122 = validateParameter(valid_590122, JString, required = false,
                                 default = nil)
  if valid_590122 != nil:
    section.add "fields", valid_590122
  var valid_590123 = query.getOrDefault("quotaUser")
  valid_590123 = validateParameter(valid_590123, JString, required = false,
                                 default = nil)
  if valid_590123 != nil:
    section.add "quotaUser", valid_590123
  var valid_590124 = query.getOrDefault("alt")
  valid_590124 = validateParameter(valid_590124, JString, required = false,
                                 default = newJString("json"))
  if valid_590124 != nil:
    section.add "alt", valid_590124
  var valid_590125 = query.getOrDefault("oauth_token")
  valid_590125 = validateParameter(valid_590125, JString, required = false,
                                 default = nil)
  if valid_590125 != nil:
    section.add "oauth_token", valid_590125
  var valid_590126 = query.getOrDefault("userIp")
  valid_590126 = validateParameter(valid_590126, JString, required = false,
                                 default = nil)
  if valid_590126 != nil:
    section.add "userIp", valid_590126
  var valid_590127 = query.getOrDefault("key")
  valid_590127 = validateParameter(valid_590127, JString, required = false,
                                 default = nil)
  if valid_590127 != nil:
    section.add "key", valid_590127
  var valid_590128 = query.getOrDefault("prettyPrint")
  valid_590128 = validateParameter(valid_590128, JBool, required = false,
                                 default = newJBool(true))
  if valid_590128 != nil:
    section.add "prettyPrint", valid_590128
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

proc call*(call_590130: Call_DirectoryRolesPatch_590117; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role. This method supports patch semantics.
  ## 
  let valid = call_590130.validator(path, query, header, formData, body)
  let scheme = call_590130.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590130.url(scheme.get, call_590130.host, call_590130.base,
                         call_590130.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590130, url, valid)

proc call*(call_590131: Call_DirectoryRolesPatch_590117; roleId: string;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryRolesPatch
  ## Updates a role. This method supports patch semantics.
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
  ##   roleId: string (required)
  ##         : Immutable ID of the role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590132 = newJObject()
  var query_590133 = newJObject()
  var body_590134 = newJObject()
  add(query_590133, "fields", newJString(fields))
  add(query_590133, "quotaUser", newJString(quotaUser))
  add(query_590133, "alt", newJString(alt))
  add(query_590133, "oauth_token", newJString(oauthToken))
  add(query_590133, "userIp", newJString(userIp))
  add(path_590132, "roleId", newJString(roleId))
  add(query_590133, "key", newJString(key))
  add(path_590132, "customer", newJString(customer))
  if body != nil:
    body_590134 = body
  add(query_590133, "prettyPrint", newJBool(prettyPrint))
  result = call_590131.call(path_590132, query_590133, nil, nil, body_590134)

var directoryRolesPatch* = Call_DirectoryRolesPatch_590117(
    name: "directoryRolesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesPatch_590118, base: "/admin/directory/v1",
    url: url_DirectoryRolesPatch_590119, schemes: {Scheme.Https})
type
  Call_DirectoryRolesDelete_590101 = ref object of OpenApiRestCall_588466
proc url_DirectoryRolesDelete_590103(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesDelete_590102(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a role.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   roleId: JString (required)
  ##         : Immutable ID of the role.
  ##   customer: JString (required)
  ##           : Immutable ID of the G Suite account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `roleId` field"
  var valid_590104 = path.getOrDefault("roleId")
  valid_590104 = validateParameter(valid_590104, JString, required = true,
                                 default = nil)
  if valid_590104 != nil:
    section.add "roleId", valid_590104
  var valid_590105 = path.getOrDefault("customer")
  valid_590105 = validateParameter(valid_590105, JString, required = true,
                                 default = nil)
  if valid_590105 != nil:
    section.add "customer", valid_590105
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
  var valid_590106 = query.getOrDefault("fields")
  valid_590106 = validateParameter(valid_590106, JString, required = false,
                                 default = nil)
  if valid_590106 != nil:
    section.add "fields", valid_590106
  var valid_590107 = query.getOrDefault("quotaUser")
  valid_590107 = validateParameter(valid_590107, JString, required = false,
                                 default = nil)
  if valid_590107 != nil:
    section.add "quotaUser", valid_590107
  var valid_590108 = query.getOrDefault("alt")
  valid_590108 = validateParameter(valid_590108, JString, required = false,
                                 default = newJString("json"))
  if valid_590108 != nil:
    section.add "alt", valid_590108
  var valid_590109 = query.getOrDefault("oauth_token")
  valid_590109 = validateParameter(valid_590109, JString, required = false,
                                 default = nil)
  if valid_590109 != nil:
    section.add "oauth_token", valid_590109
  var valid_590110 = query.getOrDefault("userIp")
  valid_590110 = validateParameter(valid_590110, JString, required = false,
                                 default = nil)
  if valid_590110 != nil:
    section.add "userIp", valid_590110
  var valid_590111 = query.getOrDefault("key")
  valid_590111 = validateParameter(valid_590111, JString, required = false,
                                 default = nil)
  if valid_590111 != nil:
    section.add "key", valid_590111
  var valid_590112 = query.getOrDefault("prettyPrint")
  valid_590112 = validateParameter(valid_590112, JBool, required = false,
                                 default = newJBool(true))
  if valid_590112 != nil:
    section.add "prettyPrint", valid_590112
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590113: Call_DirectoryRolesDelete_590101; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role.
  ## 
  let valid = call_590113.validator(path, query, header, formData, body)
  let scheme = call_590113.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590113.url(scheme.get, call_590113.host, call_590113.base,
                         call_590113.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590113, url, valid)

proc call*(call_590114: Call_DirectoryRolesDelete_590101; roleId: string;
          customer: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryRolesDelete
  ## Deletes a role.
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
  ##   roleId: string (required)
  ##         : Immutable ID of the role.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   customer: string (required)
  ##           : Immutable ID of the G Suite account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590115 = newJObject()
  var query_590116 = newJObject()
  add(query_590116, "fields", newJString(fields))
  add(query_590116, "quotaUser", newJString(quotaUser))
  add(query_590116, "alt", newJString(alt))
  add(query_590116, "oauth_token", newJString(oauthToken))
  add(query_590116, "userIp", newJString(userIp))
  add(path_590115, "roleId", newJString(roleId))
  add(query_590116, "key", newJString(key))
  add(path_590115, "customer", newJString(customer))
  add(query_590116, "prettyPrint", newJBool(prettyPrint))
  result = call_590114.call(path_590115, query_590116, nil, nil, nil)

var directoryRolesDelete* = Call_DirectoryRolesDelete_590101(
    name: "directoryRolesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesDelete_590102, base: "/admin/directory/v1",
    url: url_DirectoryRolesDelete_590103, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersUpdate_590150 = ref object of OpenApiRestCall_588466
proc url_DirectoryCustomersUpdate_590152(protocol: Scheme; host: string;
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

proc validate_DirectoryCustomersUpdate_590151(path: JsonNode; query: JsonNode;
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
  var valid_590153 = path.getOrDefault("customerKey")
  valid_590153 = validateParameter(valid_590153, JString, required = true,
                                 default = nil)
  if valid_590153 != nil:
    section.add "customerKey", valid_590153
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
  var valid_590154 = query.getOrDefault("fields")
  valid_590154 = validateParameter(valid_590154, JString, required = false,
                                 default = nil)
  if valid_590154 != nil:
    section.add "fields", valid_590154
  var valid_590155 = query.getOrDefault("quotaUser")
  valid_590155 = validateParameter(valid_590155, JString, required = false,
                                 default = nil)
  if valid_590155 != nil:
    section.add "quotaUser", valid_590155
  var valid_590156 = query.getOrDefault("alt")
  valid_590156 = validateParameter(valid_590156, JString, required = false,
                                 default = newJString("json"))
  if valid_590156 != nil:
    section.add "alt", valid_590156
  var valid_590157 = query.getOrDefault("oauth_token")
  valid_590157 = validateParameter(valid_590157, JString, required = false,
                                 default = nil)
  if valid_590157 != nil:
    section.add "oauth_token", valid_590157
  var valid_590158 = query.getOrDefault("userIp")
  valid_590158 = validateParameter(valid_590158, JString, required = false,
                                 default = nil)
  if valid_590158 != nil:
    section.add "userIp", valid_590158
  var valid_590159 = query.getOrDefault("key")
  valid_590159 = validateParameter(valid_590159, JString, required = false,
                                 default = nil)
  if valid_590159 != nil:
    section.add "key", valid_590159
  var valid_590160 = query.getOrDefault("prettyPrint")
  valid_590160 = validateParameter(valid_590160, JBool, required = false,
                                 default = newJBool(true))
  if valid_590160 != nil:
    section.add "prettyPrint", valid_590160
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

proc call*(call_590162: Call_DirectoryCustomersUpdate_590150; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer.
  ## 
  let valid = call_590162.validator(path, query, header, formData, body)
  let scheme = call_590162.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590162.url(scheme.get, call_590162.host, call_590162.base,
                         call_590162.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590162, url, valid)

proc call*(call_590163: Call_DirectoryCustomersUpdate_590150; customerKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryCustomersUpdate
  ## Updates a customer.
  ##   customerKey: string (required)
  ##              : Id of the customer to be updated
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
  var path_590164 = newJObject()
  var query_590165 = newJObject()
  var body_590166 = newJObject()
  add(path_590164, "customerKey", newJString(customerKey))
  add(query_590165, "fields", newJString(fields))
  add(query_590165, "quotaUser", newJString(quotaUser))
  add(query_590165, "alt", newJString(alt))
  add(query_590165, "oauth_token", newJString(oauthToken))
  add(query_590165, "userIp", newJString(userIp))
  add(query_590165, "key", newJString(key))
  if body != nil:
    body_590166 = body
  add(query_590165, "prettyPrint", newJBool(prettyPrint))
  result = call_590163.call(path_590164, query_590165, nil, nil, body_590166)

var directoryCustomersUpdate* = Call_DirectoryCustomersUpdate_590150(
    name: "directoryCustomersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersUpdate_590151,
    base: "/admin/directory/v1", url: url_DirectoryCustomersUpdate_590152,
    schemes: {Scheme.Https})
type
  Call_DirectoryCustomersGet_590135 = ref object of OpenApiRestCall_588466
proc url_DirectoryCustomersGet_590137(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryCustomersGet_590136(path: JsonNode; query: JsonNode;
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
  var valid_590138 = path.getOrDefault("customerKey")
  valid_590138 = validateParameter(valid_590138, JString, required = true,
                                 default = nil)
  if valid_590138 != nil:
    section.add "customerKey", valid_590138
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
  var valid_590139 = query.getOrDefault("fields")
  valid_590139 = validateParameter(valid_590139, JString, required = false,
                                 default = nil)
  if valid_590139 != nil:
    section.add "fields", valid_590139
  var valid_590140 = query.getOrDefault("quotaUser")
  valid_590140 = validateParameter(valid_590140, JString, required = false,
                                 default = nil)
  if valid_590140 != nil:
    section.add "quotaUser", valid_590140
  var valid_590141 = query.getOrDefault("alt")
  valid_590141 = validateParameter(valid_590141, JString, required = false,
                                 default = newJString("json"))
  if valid_590141 != nil:
    section.add "alt", valid_590141
  var valid_590142 = query.getOrDefault("oauth_token")
  valid_590142 = validateParameter(valid_590142, JString, required = false,
                                 default = nil)
  if valid_590142 != nil:
    section.add "oauth_token", valid_590142
  var valid_590143 = query.getOrDefault("userIp")
  valid_590143 = validateParameter(valid_590143, JString, required = false,
                                 default = nil)
  if valid_590143 != nil:
    section.add "userIp", valid_590143
  var valid_590144 = query.getOrDefault("key")
  valid_590144 = validateParameter(valid_590144, JString, required = false,
                                 default = nil)
  if valid_590144 != nil:
    section.add "key", valid_590144
  var valid_590145 = query.getOrDefault("prettyPrint")
  valid_590145 = validateParameter(valid_590145, JBool, required = false,
                                 default = newJBool(true))
  if valid_590145 != nil:
    section.add "prettyPrint", valid_590145
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590146: Call_DirectoryCustomersGet_590135; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a customer.
  ## 
  let valid = call_590146.validator(path, query, header, formData, body)
  let scheme = call_590146.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590146.url(scheme.get, call_590146.host, call_590146.base,
                         call_590146.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590146, url, valid)

proc call*(call_590147: Call_DirectoryCustomersGet_590135; customerKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryCustomersGet
  ## Retrieves a customer.
  ##   customerKey: string (required)
  ##              : Id of the customer to be retrieved
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
  var path_590148 = newJObject()
  var query_590149 = newJObject()
  add(path_590148, "customerKey", newJString(customerKey))
  add(query_590149, "fields", newJString(fields))
  add(query_590149, "quotaUser", newJString(quotaUser))
  add(query_590149, "alt", newJString(alt))
  add(query_590149, "oauth_token", newJString(oauthToken))
  add(query_590149, "userIp", newJString(userIp))
  add(query_590149, "key", newJString(key))
  add(query_590149, "prettyPrint", newJBool(prettyPrint))
  result = call_590147.call(path_590148, query_590149, nil, nil, nil)

var directoryCustomersGet* = Call_DirectoryCustomersGet_590135(
    name: "directoryCustomersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersGet_590136, base: "/admin/directory/v1",
    url: url_DirectoryCustomersGet_590137, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersPatch_590167 = ref object of OpenApiRestCall_588466
proc url_DirectoryCustomersPatch_590169(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryCustomersPatch_590168(path: JsonNode; query: JsonNode;
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
  var valid_590170 = path.getOrDefault("customerKey")
  valid_590170 = validateParameter(valid_590170, JString, required = true,
                                 default = nil)
  if valid_590170 != nil:
    section.add "customerKey", valid_590170
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
  var valid_590171 = query.getOrDefault("fields")
  valid_590171 = validateParameter(valid_590171, JString, required = false,
                                 default = nil)
  if valid_590171 != nil:
    section.add "fields", valid_590171
  var valid_590172 = query.getOrDefault("quotaUser")
  valid_590172 = validateParameter(valid_590172, JString, required = false,
                                 default = nil)
  if valid_590172 != nil:
    section.add "quotaUser", valid_590172
  var valid_590173 = query.getOrDefault("alt")
  valid_590173 = validateParameter(valid_590173, JString, required = false,
                                 default = newJString("json"))
  if valid_590173 != nil:
    section.add "alt", valid_590173
  var valid_590174 = query.getOrDefault("oauth_token")
  valid_590174 = validateParameter(valid_590174, JString, required = false,
                                 default = nil)
  if valid_590174 != nil:
    section.add "oauth_token", valid_590174
  var valid_590175 = query.getOrDefault("userIp")
  valid_590175 = validateParameter(valid_590175, JString, required = false,
                                 default = nil)
  if valid_590175 != nil:
    section.add "userIp", valid_590175
  var valid_590176 = query.getOrDefault("key")
  valid_590176 = validateParameter(valid_590176, JString, required = false,
                                 default = nil)
  if valid_590176 != nil:
    section.add "key", valid_590176
  var valid_590177 = query.getOrDefault("prettyPrint")
  valid_590177 = validateParameter(valid_590177, JBool, required = false,
                                 default = newJBool(true))
  if valid_590177 != nil:
    section.add "prettyPrint", valid_590177
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

proc call*(call_590179: Call_DirectoryCustomersPatch_590167; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer. This method supports patch semantics.
  ## 
  let valid = call_590179.validator(path, query, header, formData, body)
  let scheme = call_590179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590179.url(scheme.get, call_590179.host, call_590179.base,
                         call_590179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590179, url, valid)

proc call*(call_590180: Call_DirectoryCustomersPatch_590167; customerKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryCustomersPatch
  ## Updates a customer. This method supports patch semantics.
  ##   customerKey: string (required)
  ##              : Id of the customer to be updated
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
  var path_590181 = newJObject()
  var query_590182 = newJObject()
  var body_590183 = newJObject()
  add(path_590181, "customerKey", newJString(customerKey))
  add(query_590182, "fields", newJString(fields))
  add(query_590182, "quotaUser", newJString(quotaUser))
  add(query_590182, "alt", newJString(alt))
  add(query_590182, "oauth_token", newJString(oauthToken))
  add(query_590182, "userIp", newJString(userIp))
  add(query_590182, "key", newJString(key))
  if body != nil:
    body_590183 = body
  add(query_590182, "prettyPrint", newJBool(prettyPrint))
  result = call_590180.call(path_590181, query_590182, nil, nil, body_590183)

var directoryCustomersPatch* = Call_DirectoryCustomersPatch_590167(
    name: "directoryCustomersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersPatch_590168,
    base: "/admin/directory/v1", url: url_DirectoryCustomersPatch_590169,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsInsert_590205 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsInsert_590207(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryGroupsInsert_590206(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create Group
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
  var valid_590208 = query.getOrDefault("fields")
  valid_590208 = validateParameter(valid_590208, JString, required = false,
                                 default = nil)
  if valid_590208 != nil:
    section.add "fields", valid_590208
  var valid_590209 = query.getOrDefault("quotaUser")
  valid_590209 = validateParameter(valid_590209, JString, required = false,
                                 default = nil)
  if valid_590209 != nil:
    section.add "quotaUser", valid_590209
  var valid_590210 = query.getOrDefault("alt")
  valid_590210 = validateParameter(valid_590210, JString, required = false,
                                 default = newJString("json"))
  if valid_590210 != nil:
    section.add "alt", valid_590210
  var valid_590211 = query.getOrDefault("oauth_token")
  valid_590211 = validateParameter(valid_590211, JString, required = false,
                                 default = nil)
  if valid_590211 != nil:
    section.add "oauth_token", valid_590211
  var valid_590212 = query.getOrDefault("userIp")
  valid_590212 = validateParameter(valid_590212, JString, required = false,
                                 default = nil)
  if valid_590212 != nil:
    section.add "userIp", valid_590212
  var valid_590213 = query.getOrDefault("key")
  valid_590213 = validateParameter(valid_590213, JString, required = false,
                                 default = nil)
  if valid_590213 != nil:
    section.add "key", valid_590213
  var valid_590214 = query.getOrDefault("prettyPrint")
  valid_590214 = validateParameter(valid_590214, JBool, required = false,
                                 default = newJBool(true))
  if valid_590214 != nil:
    section.add "prettyPrint", valid_590214
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

proc call*(call_590216: Call_DirectoryGroupsInsert_590205; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Group
  ## 
  let valid = call_590216.validator(path, query, header, formData, body)
  let scheme = call_590216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590216.url(scheme.get, call_590216.host, call_590216.base,
                         call_590216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590216, url, valid)

proc call*(call_590217: Call_DirectoryGroupsInsert_590205; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryGroupsInsert
  ## Create Group
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
  var query_590218 = newJObject()
  var body_590219 = newJObject()
  add(query_590218, "fields", newJString(fields))
  add(query_590218, "quotaUser", newJString(quotaUser))
  add(query_590218, "alt", newJString(alt))
  add(query_590218, "oauth_token", newJString(oauthToken))
  add(query_590218, "userIp", newJString(userIp))
  add(query_590218, "key", newJString(key))
  if body != nil:
    body_590219 = body
  add(query_590218, "prettyPrint", newJBool(prettyPrint))
  result = call_590217.call(nil, query_590218, nil, nil, body_590219)

var directoryGroupsInsert* = Call_DirectoryGroupsInsert_590205(
    name: "directoryGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsInsert_590206, base: "/admin/directory/v1",
    url: url_DirectoryGroupsInsert_590207, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsList_590184 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsList_590186(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryGroupsList_590185(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   query: JString
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-groups
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Max allowed value is 200.
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   customer: JString
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all groups for a customer, fill this field instead of domain.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   domain: JString
  ##         : Name of the domain. Fill this field to get groups from only this domain. To return all groups in a multi-domain fill customer field instead.
  ##   userKey: JString
  ##          : Email or immutable ID of the user if only those groups are to be listed, the given user is a member of. If it's an ID, it should match with the ID of the user object.
  section = newJObject()
  var valid_590187 = query.getOrDefault("fields")
  valid_590187 = validateParameter(valid_590187, JString, required = false,
                                 default = nil)
  if valid_590187 != nil:
    section.add "fields", valid_590187
  var valid_590188 = query.getOrDefault("pageToken")
  valid_590188 = validateParameter(valid_590188, JString, required = false,
                                 default = nil)
  if valid_590188 != nil:
    section.add "pageToken", valid_590188
  var valid_590189 = query.getOrDefault("quotaUser")
  valid_590189 = validateParameter(valid_590189, JString, required = false,
                                 default = nil)
  if valid_590189 != nil:
    section.add "quotaUser", valid_590189
  var valid_590190 = query.getOrDefault("alt")
  valid_590190 = validateParameter(valid_590190, JString, required = false,
                                 default = newJString("json"))
  if valid_590190 != nil:
    section.add "alt", valid_590190
  var valid_590191 = query.getOrDefault("query")
  valid_590191 = validateParameter(valid_590191, JString, required = false,
                                 default = nil)
  if valid_590191 != nil:
    section.add "query", valid_590191
  var valid_590192 = query.getOrDefault("oauth_token")
  valid_590192 = validateParameter(valid_590192, JString, required = false,
                                 default = nil)
  if valid_590192 != nil:
    section.add "oauth_token", valid_590192
  var valid_590193 = query.getOrDefault("userIp")
  valid_590193 = validateParameter(valid_590193, JString, required = false,
                                 default = nil)
  if valid_590193 != nil:
    section.add "userIp", valid_590193
  var valid_590194 = query.getOrDefault("maxResults")
  valid_590194 = validateParameter(valid_590194, JInt, required = false,
                                 default = newJInt(200))
  if valid_590194 != nil:
    section.add "maxResults", valid_590194
  var valid_590195 = query.getOrDefault("orderBy")
  valid_590195 = validateParameter(valid_590195, JString, required = false,
                                 default = newJString("email"))
  if valid_590195 != nil:
    section.add "orderBy", valid_590195
  var valid_590196 = query.getOrDefault("key")
  valid_590196 = validateParameter(valid_590196, JString, required = false,
                                 default = nil)
  if valid_590196 != nil:
    section.add "key", valid_590196
  var valid_590197 = query.getOrDefault("sortOrder")
  valid_590197 = validateParameter(valid_590197, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_590197 != nil:
    section.add "sortOrder", valid_590197
  var valid_590198 = query.getOrDefault("customer")
  valid_590198 = validateParameter(valid_590198, JString, required = false,
                                 default = nil)
  if valid_590198 != nil:
    section.add "customer", valid_590198
  var valid_590199 = query.getOrDefault("prettyPrint")
  valid_590199 = validateParameter(valid_590199, JBool, required = false,
                                 default = newJBool(true))
  if valid_590199 != nil:
    section.add "prettyPrint", valid_590199
  var valid_590200 = query.getOrDefault("domain")
  valid_590200 = validateParameter(valid_590200, JString, required = false,
                                 default = nil)
  if valid_590200 != nil:
    section.add "domain", valid_590200
  var valid_590201 = query.getOrDefault("userKey")
  valid_590201 = validateParameter(valid_590201, JString, required = false,
                                 default = nil)
  if valid_590201 != nil:
    section.add "userKey", valid_590201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590202: Call_DirectoryGroupsList_590184; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
  ## 
  let valid = call_590202.validator(path, query, header, formData, body)
  let scheme = call_590202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590202.url(scheme.get, call_590202.host, call_590202.base,
                         call_590202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590202, url, valid)

proc call*(call_590203: Call_DirectoryGroupsList_590184; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          query: string = ""; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 200; orderBy: string = "email"; key: string = "";
          sortOrder: string = "ASCENDING"; customer: string = "";
          prettyPrint: bool = true; domain: string = ""; userKey: string = ""): Recallable =
  ## directoryGroupsList
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-groups
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return. Max allowed value is 200.
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order. Only of use when orderBy is also used
  ##   customer: string
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all groups for a customer, fill this field instead of domain.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   domain: string
  ##         : Name of the domain. Fill this field to get groups from only this domain. To return all groups in a multi-domain fill customer field instead.
  ##   userKey: string
  ##          : Email or immutable ID of the user if only those groups are to be listed, the given user is a member of. If it's an ID, it should match with the ID of the user object.
  var query_590204 = newJObject()
  add(query_590204, "fields", newJString(fields))
  add(query_590204, "pageToken", newJString(pageToken))
  add(query_590204, "quotaUser", newJString(quotaUser))
  add(query_590204, "alt", newJString(alt))
  add(query_590204, "query", newJString(query))
  add(query_590204, "oauth_token", newJString(oauthToken))
  add(query_590204, "userIp", newJString(userIp))
  add(query_590204, "maxResults", newJInt(maxResults))
  add(query_590204, "orderBy", newJString(orderBy))
  add(query_590204, "key", newJString(key))
  add(query_590204, "sortOrder", newJString(sortOrder))
  add(query_590204, "customer", newJString(customer))
  add(query_590204, "prettyPrint", newJBool(prettyPrint))
  add(query_590204, "domain", newJString(domain))
  add(query_590204, "userKey", newJString(userKey))
  result = call_590203.call(nil, query_590204, nil, nil, nil)

var directoryGroupsList* = Call_DirectoryGroupsList_590184(
    name: "directoryGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsList_590185, base: "/admin/directory/v1",
    url: url_DirectoryGroupsList_590186, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsUpdate_590235 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsUpdate_590237(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryGroupsUpdate_590236(path: JsonNode; query: JsonNode;
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
  var valid_590238 = path.getOrDefault("groupKey")
  valid_590238 = validateParameter(valid_590238, JString, required = true,
                                 default = nil)
  if valid_590238 != nil:
    section.add "groupKey", valid_590238
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
  var valid_590239 = query.getOrDefault("fields")
  valid_590239 = validateParameter(valid_590239, JString, required = false,
                                 default = nil)
  if valid_590239 != nil:
    section.add "fields", valid_590239
  var valid_590240 = query.getOrDefault("quotaUser")
  valid_590240 = validateParameter(valid_590240, JString, required = false,
                                 default = nil)
  if valid_590240 != nil:
    section.add "quotaUser", valid_590240
  var valid_590241 = query.getOrDefault("alt")
  valid_590241 = validateParameter(valid_590241, JString, required = false,
                                 default = newJString("json"))
  if valid_590241 != nil:
    section.add "alt", valid_590241
  var valid_590242 = query.getOrDefault("oauth_token")
  valid_590242 = validateParameter(valid_590242, JString, required = false,
                                 default = nil)
  if valid_590242 != nil:
    section.add "oauth_token", valid_590242
  var valid_590243 = query.getOrDefault("userIp")
  valid_590243 = validateParameter(valid_590243, JString, required = false,
                                 default = nil)
  if valid_590243 != nil:
    section.add "userIp", valid_590243
  var valid_590244 = query.getOrDefault("key")
  valid_590244 = validateParameter(valid_590244, JString, required = false,
                                 default = nil)
  if valid_590244 != nil:
    section.add "key", valid_590244
  var valid_590245 = query.getOrDefault("prettyPrint")
  valid_590245 = validateParameter(valid_590245, JBool, required = false,
                                 default = newJBool(true))
  if valid_590245 != nil:
    section.add "prettyPrint", valid_590245
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

proc call*(call_590247: Call_DirectoryGroupsUpdate_590235; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group
  ## 
  let valid = call_590247.validator(path, query, header, formData, body)
  let scheme = call_590247.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590247.url(scheme.get, call_590247.host, call_590247.base,
                         call_590247.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590247, url, valid)

proc call*(call_590248: Call_DirectoryGroupsUpdate_590235; groupKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryGroupsUpdate
  ## Update Group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  var path_590249 = newJObject()
  var query_590250 = newJObject()
  var body_590251 = newJObject()
  add(query_590250, "fields", newJString(fields))
  add(query_590250, "quotaUser", newJString(quotaUser))
  add(query_590250, "alt", newJString(alt))
  add(query_590250, "oauth_token", newJString(oauthToken))
  add(query_590250, "userIp", newJString(userIp))
  add(query_590250, "key", newJString(key))
  if body != nil:
    body_590251 = body
  add(query_590250, "prettyPrint", newJBool(prettyPrint))
  add(path_590249, "groupKey", newJString(groupKey))
  result = call_590248.call(path_590249, query_590250, nil, nil, body_590251)

var directoryGroupsUpdate* = Call_DirectoryGroupsUpdate_590235(
    name: "directoryGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsUpdate_590236, base: "/admin/directory/v1",
    url: url_DirectoryGroupsUpdate_590237, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsGet_590220 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsGet_590222(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryGroupsGet_590221(path: JsonNode; query: JsonNode;
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
  var valid_590223 = path.getOrDefault("groupKey")
  valid_590223 = validateParameter(valid_590223, JString, required = true,
                                 default = nil)
  if valid_590223 != nil:
    section.add "groupKey", valid_590223
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
  var valid_590224 = query.getOrDefault("fields")
  valid_590224 = validateParameter(valid_590224, JString, required = false,
                                 default = nil)
  if valid_590224 != nil:
    section.add "fields", valid_590224
  var valid_590225 = query.getOrDefault("quotaUser")
  valid_590225 = validateParameter(valid_590225, JString, required = false,
                                 default = nil)
  if valid_590225 != nil:
    section.add "quotaUser", valid_590225
  var valid_590226 = query.getOrDefault("alt")
  valid_590226 = validateParameter(valid_590226, JString, required = false,
                                 default = newJString("json"))
  if valid_590226 != nil:
    section.add "alt", valid_590226
  var valid_590227 = query.getOrDefault("oauth_token")
  valid_590227 = validateParameter(valid_590227, JString, required = false,
                                 default = nil)
  if valid_590227 != nil:
    section.add "oauth_token", valid_590227
  var valid_590228 = query.getOrDefault("userIp")
  valid_590228 = validateParameter(valid_590228, JString, required = false,
                                 default = nil)
  if valid_590228 != nil:
    section.add "userIp", valid_590228
  var valid_590229 = query.getOrDefault("key")
  valid_590229 = validateParameter(valid_590229, JString, required = false,
                                 default = nil)
  if valid_590229 != nil:
    section.add "key", valid_590229
  var valid_590230 = query.getOrDefault("prettyPrint")
  valid_590230 = validateParameter(valid_590230, JBool, required = false,
                                 default = newJBool(true))
  if valid_590230 != nil:
    section.add "prettyPrint", valid_590230
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590231: Call_DirectoryGroupsGet_590220; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group
  ## 
  let valid = call_590231.validator(path, query, header, formData, body)
  let scheme = call_590231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590231.url(scheme.get, call_590231.host, call_590231.base,
                         call_590231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590231, url, valid)

proc call*(call_590232: Call_DirectoryGroupsGet_590220; groupKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryGroupsGet
  ## Retrieve Group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  var path_590233 = newJObject()
  var query_590234 = newJObject()
  add(query_590234, "fields", newJString(fields))
  add(query_590234, "quotaUser", newJString(quotaUser))
  add(query_590234, "alt", newJString(alt))
  add(query_590234, "oauth_token", newJString(oauthToken))
  add(query_590234, "userIp", newJString(userIp))
  add(query_590234, "key", newJString(key))
  add(query_590234, "prettyPrint", newJBool(prettyPrint))
  add(path_590233, "groupKey", newJString(groupKey))
  result = call_590232.call(path_590233, query_590234, nil, nil, nil)

var directoryGroupsGet* = Call_DirectoryGroupsGet_590220(
    name: "directoryGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsGet_590221, base: "/admin/directory/v1",
    url: url_DirectoryGroupsGet_590222, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsPatch_590267 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsPatch_590269(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryGroupsPatch_590268(path: JsonNode; query: JsonNode;
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
  var valid_590270 = path.getOrDefault("groupKey")
  valid_590270 = validateParameter(valid_590270, JString, required = true,
                                 default = nil)
  if valid_590270 != nil:
    section.add "groupKey", valid_590270
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
  var valid_590271 = query.getOrDefault("fields")
  valid_590271 = validateParameter(valid_590271, JString, required = false,
                                 default = nil)
  if valid_590271 != nil:
    section.add "fields", valid_590271
  var valid_590272 = query.getOrDefault("quotaUser")
  valid_590272 = validateParameter(valid_590272, JString, required = false,
                                 default = nil)
  if valid_590272 != nil:
    section.add "quotaUser", valid_590272
  var valid_590273 = query.getOrDefault("alt")
  valid_590273 = validateParameter(valid_590273, JString, required = false,
                                 default = newJString("json"))
  if valid_590273 != nil:
    section.add "alt", valid_590273
  var valid_590274 = query.getOrDefault("oauth_token")
  valid_590274 = validateParameter(valid_590274, JString, required = false,
                                 default = nil)
  if valid_590274 != nil:
    section.add "oauth_token", valid_590274
  var valid_590275 = query.getOrDefault("userIp")
  valid_590275 = validateParameter(valid_590275, JString, required = false,
                                 default = nil)
  if valid_590275 != nil:
    section.add "userIp", valid_590275
  var valid_590276 = query.getOrDefault("key")
  valid_590276 = validateParameter(valid_590276, JString, required = false,
                                 default = nil)
  if valid_590276 != nil:
    section.add "key", valid_590276
  var valid_590277 = query.getOrDefault("prettyPrint")
  valid_590277 = validateParameter(valid_590277, JBool, required = false,
                                 default = newJBool(true))
  if valid_590277 != nil:
    section.add "prettyPrint", valid_590277
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

proc call*(call_590279: Call_DirectoryGroupsPatch_590267; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group. This method supports patch semantics.
  ## 
  let valid = call_590279.validator(path, query, header, formData, body)
  let scheme = call_590279.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590279.url(scheme.get, call_590279.host, call_590279.base,
                         call_590279.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590279, url, valid)

proc call*(call_590280: Call_DirectoryGroupsPatch_590267; groupKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryGroupsPatch
  ## Update Group. This method supports patch semantics.
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  var path_590281 = newJObject()
  var query_590282 = newJObject()
  var body_590283 = newJObject()
  add(query_590282, "fields", newJString(fields))
  add(query_590282, "quotaUser", newJString(quotaUser))
  add(query_590282, "alt", newJString(alt))
  add(query_590282, "oauth_token", newJString(oauthToken))
  add(query_590282, "userIp", newJString(userIp))
  add(query_590282, "key", newJString(key))
  if body != nil:
    body_590283 = body
  add(query_590282, "prettyPrint", newJBool(prettyPrint))
  add(path_590281, "groupKey", newJString(groupKey))
  result = call_590280.call(path_590281, query_590282, nil, nil, body_590283)

var directoryGroupsPatch* = Call_DirectoryGroupsPatch_590267(
    name: "directoryGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsPatch_590268, base: "/admin/directory/v1",
    url: url_DirectoryGroupsPatch_590269, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsDelete_590252 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsDelete_590254(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryGroupsDelete_590253(path: JsonNode; query: JsonNode;
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
  var valid_590255 = path.getOrDefault("groupKey")
  valid_590255 = validateParameter(valid_590255, JString, required = true,
                                 default = nil)
  if valid_590255 != nil:
    section.add "groupKey", valid_590255
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
  var valid_590256 = query.getOrDefault("fields")
  valid_590256 = validateParameter(valid_590256, JString, required = false,
                                 default = nil)
  if valid_590256 != nil:
    section.add "fields", valid_590256
  var valid_590257 = query.getOrDefault("quotaUser")
  valid_590257 = validateParameter(valid_590257, JString, required = false,
                                 default = nil)
  if valid_590257 != nil:
    section.add "quotaUser", valid_590257
  var valid_590258 = query.getOrDefault("alt")
  valid_590258 = validateParameter(valid_590258, JString, required = false,
                                 default = newJString("json"))
  if valid_590258 != nil:
    section.add "alt", valid_590258
  var valid_590259 = query.getOrDefault("oauth_token")
  valid_590259 = validateParameter(valid_590259, JString, required = false,
                                 default = nil)
  if valid_590259 != nil:
    section.add "oauth_token", valid_590259
  var valid_590260 = query.getOrDefault("userIp")
  valid_590260 = validateParameter(valid_590260, JString, required = false,
                                 default = nil)
  if valid_590260 != nil:
    section.add "userIp", valid_590260
  var valid_590261 = query.getOrDefault("key")
  valid_590261 = validateParameter(valid_590261, JString, required = false,
                                 default = nil)
  if valid_590261 != nil:
    section.add "key", valid_590261
  var valid_590262 = query.getOrDefault("prettyPrint")
  valid_590262 = validateParameter(valid_590262, JBool, required = false,
                                 default = newJBool(true))
  if valid_590262 != nil:
    section.add "prettyPrint", valid_590262
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590263: Call_DirectoryGroupsDelete_590252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group
  ## 
  let valid = call_590263.validator(path, query, header, formData, body)
  let scheme = call_590263.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590263.url(scheme.get, call_590263.host, call_590263.base,
                         call_590263.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590263, url, valid)

proc call*(call_590264: Call_DirectoryGroupsDelete_590252; groupKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryGroupsDelete
  ## Delete Group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  var path_590265 = newJObject()
  var query_590266 = newJObject()
  add(query_590266, "fields", newJString(fields))
  add(query_590266, "quotaUser", newJString(quotaUser))
  add(query_590266, "alt", newJString(alt))
  add(query_590266, "oauth_token", newJString(oauthToken))
  add(query_590266, "userIp", newJString(userIp))
  add(query_590266, "key", newJString(key))
  add(query_590266, "prettyPrint", newJBool(prettyPrint))
  add(path_590265, "groupKey", newJString(groupKey))
  result = call_590264.call(path_590265, query_590266, nil, nil, nil)

var directoryGroupsDelete* = Call_DirectoryGroupsDelete_590252(
    name: "directoryGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsDelete_590253, base: "/admin/directory/v1",
    url: url_DirectoryGroupsDelete_590254, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesInsert_590299 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsAliasesInsert_590301(protocol: Scheme; host: string;
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

proc validate_DirectoryGroupsAliasesInsert_590300(path: JsonNode; query: JsonNode;
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
  var valid_590302 = path.getOrDefault("groupKey")
  valid_590302 = validateParameter(valid_590302, JString, required = true,
                                 default = nil)
  if valid_590302 != nil:
    section.add "groupKey", valid_590302
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
  var valid_590303 = query.getOrDefault("fields")
  valid_590303 = validateParameter(valid_590303, JString, required = false,
                                 default = nil)
  if valid_590303 != nil:
    section.add "fields", valid_590303
  var valid_590304 = query.getOrDefault("quotaUser")
  valid_590304 = validateParameter(valid_590304, JString, required = false,
                                 default = nil)
  if valid_590304 != nil:
    section.add "quotaUser", valid_590304
  var valid_590305 = query.getOrDefault("alt")
  valid_590305 = validateParameter(valid_590305, JString, required = false,
                                 default = newJString("json"))
  if valid_590305 != nil:
    section.add "alt", valid_590305
  var valid_590306 = query.getOrDefault("oauth_token")
  valid_590306 = validateParameter(valid_590306, JString, required = false,
                                 default = nil)
  if valid_590306 != nil:
    section.add "oauth_token", valid_590306
  var valid_590307 = query.getOrDefault("userIp")
  valid_590307 = validateParameter(valid_590307, JString, required = false,
                                 default = nil)
  if valid_590307 != nil:
    section.add "userIp", valid_590307
  var valid_590308 = query.getOrDefault("key")
  valid_590308 = validateParameter(valid_590308, JString, required = false,
                                 default = nil)
  if valid_590308 != nil:
    section.add "key", valid_590308
  var valid_590309 = query.getOrDefault("prettyPrint")
  valid_590309 = validateParameter(valid_590309, JBool, required = false,
                                 default = newJBool(true))
  if valid_590309 != nil:
    section.add "prettyPrint", valid_590309
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

proc call*(call_590311: Call_DirectoryGroupsAliasesInsert_590299; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the group
  ## 
  let valid = call_590311.validator(path, query, header, formData, body)
  let scheme = call_590311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590311.url(scheme.get, call_590311.host, call_590311.base,
                         call_590311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590311, url, valid)

proc call*(call_590312: Call_DirectoryGroupsAliasesInsert_590299; groupKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryGroupsAliasesInsert
  ## Add a alias for the group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  var path_590313 = newJObject()
  var query_590314 = newJObject()
  var body_590315 = newJObject()
  add(query_590314, "fields", newJString(fields))
  add(query_590314, "quotaUser", newJString(quotaUser))
  add(query_590314, "alt", newJString(alt))
  add(query_590314, "oauth_token", newJString(oauthToken))
  add(query_590314, "userIp", newJString(userIp))
  add(query_590314, "key", newJString(key))
  if body != nil:
    body_590315 = body
  add(query_590314, "prettyPrint", newJBool(prettyPrint))
  add(path_590313, "groupKey", newJString(groupKey))
  result = call_590312.call(path_590313, query_590314, nil, nil, body_590315)

var directoryGroupsAliasesInsert* = Call_DirectoryGroupsAliasesInsert_590299(
    name: "directoryGroupsAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesInsert_590300,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesInsert_590301,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesList_590284 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsAliasesList_590286(protocol: Scheme; host: string;
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

proc validate_DirectoryGroupsAliasesList_590285(path: JsonNode; query: JsonNode;
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
  var valid_590287 = path.getOrDefault("groupKey")
  valid_590287 = validateParameter(valid_590287, JString, required = true,
                                 default = nil)
  if valid_590287 != nil:
    section.add "groupKey", valid_590287
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
  var valid_590288 = query.getOrDefault("fields")
  valid_590288 = validateParameter(valid_590288, JString, required = false,
                                 default = nil)
  if valid_590288 != nil:
    section.add "fields", valid_590288
  var valid_590289 = query.getOrDefault("quotaUser")
  valid_590289 = validateParameter(valid_590289, JString, required = false,
                                 default = nil)
  if valid_590289 != nil:
    section.add "quotaUser", valid_590289
  var valid_590290 = query.getOrDefault("alt")
  valid_590290 = validateParameter(valid_590290, JString, required = false,
                                 default = newJString("json"))
  if valid_590290 != nil:
    section.add "alt", valid_590290
  var valid_590291 = query.getOrDefault("oauth_token")
  valid_590291 = validateParameter(valid_590291, JString, required = false,
                                 default = nil)
  if valid_590291 != nil:
    section.add "oauth_token", valid_590291
  var valid_590292 = query.getOrDefault("userIp")
  valid_590292 = validateParameter(valid_590292, JString, required = false,
                                 default = nil)
  if valid_590292 != nil:
    section.add "userIp", valid_590292
  var valid_590293 = query.getOrDefault("key")
  valid_590293 = validateParameter(valid_590293, JString, required = false,
                                 default = nil)
  if valid_590293 != nil:
    section.add "key", valid_590293
  var valid_590294 = query.getOrDefault("prettyPrint")
  valid_590294 = validateParameter(valid_590294, JBool, required = false,
                                 default = newJBool(true))
  if valid_590294 != nil:
    section.add "prettyPrint", valid_590294
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590295: Call_DirectoryGroupsAliasesList_590284; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a group
  ## 
  let valid = call_590295.validator(path, query, header, formData, body)
  let scheme = call_590295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590295.url(scheme.get, call_590295.host, call_590295.base,
                         call_590295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590295, url, valid)

proc call*(call_590296: Call_DirectoryGroupsAliasesList_590284; groupKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryGroupsAliasesList
  ## List all aliases for a group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  var path_590297 = newJObject()
  var query_590298 = newJObject()
  add(query_590298, "fields", newJString(fields))
  add(query_590298, "quotaUser", newJString(quotaUser))
  add(query_590298, "alt", newJString(alt))
  add(query_590298, "oauth_token", newJString(oauthToken))
  add(query_590298, "userIp", newJString(userIp))
  add(query_590298, "key", newJString(key))
  add(query_590298, "prettyPrint", newJBool(prettyPrint))
  add(path_590297, "groupKey", newJString(groupKey))
  result = call_590296.call(path_590297, query_590298, nil, nil, nil)

var directoryGroupsAliasesList* = Call_DirectoryGroupsAliasesList_590284(
    name: "directoryGroupsAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesList_590285,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesList_590286,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesDelete_590316 = ref object of OpenApiRestCall_588466
proc url_DirectoryGroupsAliasesDelete_590318(protocol: Scheme; host: string;
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

proc validate_DirectoryGroupsAliasesDelete_590317(path: JsonNode; query: JsonNode;
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
  var valid_590319 = path.getOrDefault("groupKey")
  valid_590319 = validateParameter(valid_590319, JString, required = true,
                                 default = nil)
  if valid_590319 != nil:
    section.add "groupKey", valid_590319
  var valid_590320 = path.getOrDefault("alias")
  valid_590320 = validateParameter(valid_590320, JString, required = true,
                                 default = nil)
  if valid_590320 != nil:
    section.add "alias", valid_590320
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
  var valid_590321 = query.getOrDefault("fields")
  valid_590321 = validateParameter(valid_590321, JString, required = false,
                                 default = nil)
  if valid_590321 != nil:
    section.add "fields", valid_590321
  var valid_590322 = query.getOrDefault("quotaUser")
  valid_590322 = validateParameter(valid_590322, JString, required = false,
                                 default = nil)
  if valid_590322 != nil:
    section.add "quotaUser", valid_590322
  var valid_590323 = query.getOrDefault("alt")
  valid_590323 = validateParameter(valid_590323, JString, required = false,
                                 default = newJString("json"))
  if valid_590323 != nil:
    section.add "alt", valid_590323
  var valid_590324 = query.getOrDefault("oauth_token")
  valid_590324 = validateParameter(valid_590324, JString, required = false,
                                 default = nil)
  if valid_590324 != nil:
    section.add "oauth_token", valid_590324
  var valid_590325 = query.getOrDefault("userIp")
  valid_590325 = validateParameter(valid_590325, JString, required = false,
                                 default = nil)
  if valid_590325 != nil:
    section.add "userIp", valid_590325
  var valid_590326 = query.getOrDefault("key")
  valid_590326 = validateParameter(valid_590326, JString, required = false,
                                 default = nil)
  if valid_590326 != nil:
    section.add "key", valid_590326
  var valid_590327 = query.getOrDefault("prettyPrint")
  valid_590327 = validateParameter(valid_590327, JBool, required = false,
                                 default = newJBool(true))
  if valid_590327 != nil:
    section.add "prettyPrint", valid_590327
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590328: Call_DirectoryGroupsAliasesDelete_590316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the group
  ## 
  let valid = call_590328.validator(path, query, header, formData, body)
  let scheme = call_590328.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590328.url(scheme.get, call_590328.host, call_590328.base,
                         call_590328.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590328, url, valid)

proc call*(call_590329: Call_DirectoryGroupsAliasesDelete_590316; groupKey: string;
          alias: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryGroupsAliasesDelete
  ## Remove a alias for the group
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  ##   alias: string (required)
  ##        : The alias to be removed
  var path_590330 = newJObject()
  var query_590331 = newJObject()
  add(query_590331, "fields", newJString(fields))
  add(query_590331, "quotaUser", newJString(quotaUser))
  add(query_590331, "alt", newJString(alt))
  add(query_590331, "oauth_token", newJString(oauthToken))
  add(query_590331, "userIp", newJString(userIp))
  add(query_590331, "key", newJString(key))
  add(query_590331, "prettyPrint", newJBool(prettyPrint))
  add(path_590330, "groupKey", newJString(groupKey))
  add(path_590330, "alias", newJString(alias))
  result = call_590329.call(path_590330, query_590331, nil, nil, nil)

var directoryGroupsAliasesDelete* = Call_DirectoryGroupsAliasesDelete_590316(
    name: "directoryGroupsAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases/{alias}",
    validator: validate_DirectoryGroupsAliasesDelete_590317,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesDelete_590318,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersHasMember_590332 = ref object of OpenApiRestCall_588466
proc url_DirectoryMembersHasMember_590334(protocol: Scheme; host: string;
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

proc validate_DirectoryMembersHasMember_590333(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   memberKey: JString (required)
  ##            : Identifies the user member in the API request. The value can be the user's primary email address, alias, or unique ID.
  ##   groupKey: JString (required)
  ##           : Identifies the group in the API request. The value can be the group's email address, group alias, or the unique group ID.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `memberKey` field"
  var valid_590335 = path.getOrDefault("memberKey")
  valid_590335 = validateParameter(valid_590335, JString, required = true,
                                 default = nil)
  if valid_590335 != nil:
    section.add "memberKey", valid_590335
  var valid_590336 = path.getOrDefault("groupKey")
  valid_590336 = validateParameter(valid_590336, JString, required = true,
                                 default = nil)
  if valid_590336 != nil:
    section.add "groupKey", valid_590336
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
  var valid_590337 = query.getOrDefault("fields")
  valid_590337 = validateParameter(valid_590337, JString, required = false,
                                 default = nil)
  if valid_590337 != nil:
    section.add "fields", valid_590337
  var valid_590338 = query.getOrDefault("quotaUser")
  valid_590338 = validateParameter(valid_590338, JString, required = false,
                                 default = nil)
  if valid_590338 != nil:
    section.add "quotaUser", valid_590338
  var valid_590339 = query.getOrDefault("alt")
  valid_590339 = validateParameter(valid_590339, JString, required = false,
                                 default = newJString("json"))
  if valid_590339 != nil:
    section.add "alt", valid_590339
  var valid_590340 = query.getOrDefault("oauth_token")
  valid_590340 = validateParameter(valid_590340, JString, required = false,
                                 default = nil)
  if valid_590340 != nil:
    section.add "oauth_token", valid_590340
  var valid_590341 = query.getOrDefault("userIp")
  valid_590341 = validateParameter(valid_590341, JString, required = false,
                                 default = nil)
  if valid_590341 != nil:
    section.add "userIp", valid_590341
  var valid_590342 = query.getOrDefault("key")
  valid_590342 = validateParameter(valid_590342, JString, required = false,
                                 default = nil)
  if valid_590342 != nil:
    section.add "key", valid_590342
  var valid_590343 = query.getOrDefault("prettyPrint")
  valid_590343 = validateParameter(valid_590343, JBool, required = false,
                                 default = newJBool(true))
  if valid_590343 != nil:
    section.add "prettyPrint", valid_590343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590344: Call_DirectoryMembersHasMember_590332; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
  ## 
  let valid = call_590344.validator(path, query, header, formData, body)
  let scheme = call_590344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590344.url(scheme.get, call_590344.host, call_590344.base,
                         call_590344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590344, url, valid)

proc call*(call_590345: Call_DirectoryMembersHasMember_590332; memberKey: string;
          groupKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryMembersHasMember
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
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
  ##   memberKey: string (required)
  ##            : Identifies the user member in the API request. The value can be the user's primary email address, alias, or unique ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   groupKey: string (required)
  ##           : Identifies the group in the API request. The value can be the group's email address, group alias, or the unique group ID.
  var path_590346 = newJObject()
  var query_590347 = newJObject()
  add(query_590347, "fields", newJString(fields))
  add(query_590347, "quotaUser", newJString(quotaUser))
  add(query_590347, "alt", newJString(alt))
  add(query_590347, "oauth_token", newJString(oauthToken))
  add(query_590347, "userIp", newJString(userIp))
  add(path_590346, "memberKey", newJString(memberKey))
  add(query_590347, "key", newJString(key))
  add(query_590347, "prettyPrint", newJBool(prettyPrint))
  add(path_590346, "groupKey", newJString(groupKey))
  result = call_590345.call(path_590346, query_590347, nil, nil, nil)

var directoryMembersHasMember* = Call_DirectoryMembersHasMember_590332(
    name: "directoryMembersHasMember", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/hasMember/{memberKey}",
    validator: validate_DirectoryMembersHasMember_590333,
    base: "/admin/directory/v1", url: url_DirectoryMembersHasMember_590334,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersInsert_590367 = ref object of OpenApiRestCall_588466
proc url_DirectoryMembersInsert_590369(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersInsert_590368(path: JsonNode; query: JsonNode;
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
  var valid_590370 = path.getOrDefault("groupKey")
  valid_590370 = validateParameter(valid_590370, JString, required = true,
                                 default = nil)
  if valid_590370 != nil:
    section.add "groupKey", valid_590370
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
  var valid_590371 = query.getOrDefault("fields")
  valid_590371 = validateParameter(valid_590371, JString, required = false,
                                 default = nil)
  if valid_590371 != nil:
    section.add "fields", valid_590371
  var valid_590372 = query.getOrDefault("quotaUser")
  valid_590372 = validateParameter(valid_590372, JString, required = false,
                                 default = nil)
  if valid_590372 != nil:
    section.add "quotaUser", valid_590372
  var valid_590373 = query.getOrDefault("alt")
  valid_590373 = validateParameter(valid_590373, JString, required = false,
                                 default = newJString("json"))
  if valid_590373 != nil:
    section.add "alt", valid_590373
  var valid_590374 = query.getOrDefault("oauth_token")
  valid_590374 = validateParameter(valid_590374, JString, required = false,
                                 default = nil)
  if valid_590374 != nil:
    section.add "oauth_token", valid_590374
  var valid_590375 = query.getOrDefault("userIp")
  valid_590375 = validateParameter(valid_590375, JString, required = false,
                                 default = nil)
  if valid_590375 != nil:
    section.add "userIp", valid_590375
  var valid_590376 = query.getOrDefault("key")
  valid_590376 = validateParameter(valid_590376, JString, required = false,
                                 default = nil)
  if valid_590376 != nil:
    section.add "key", valid_590376
  var valid_590377 = query.getOrDefault("prettyPrint")
  valid_590377 = validateParameter(valid_590377, JBool, required = false,
                                 default = newJBool(true))
  if valid_590377 != nil:
    section.add "prettyPrint", valid_590377
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

proc call*(call_590379: Call_DirectoryMembersInsert_590367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add user to the specified group.
  ## 
  let valid = call_590379.validator(path, query, header, formData, body)
  let scheme = call_590379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590379.url(scheme.get, call_590379.host, call_590379.base,
                         call_590379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590379, url, valid)

proc call*(call_590380: Call_DirectoryMembersInsert_590367; groupKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryMembersInsert
  ## Add user to the specified group.
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
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  var path_590381 = newJObject()
  var query_590382 = newJObject()
  var body_590383 = newJObject()
  add(query_590382, "fields", newJString(fields))
  add(query_590382, "quotaUser", newJString(quotaUser))
  add(query_590382, "alt", newJString(alt))
  add(query_590382, "oauth_token", newJString(oauthToken))
  add(query_590382, "userIp", newJString(userIp))
  add(query_590382, "key", newJString(key))
  if body != nil:
    body_590383 = body
  add(query_590382, "prettyPrint", newJBool(prettyPrint))
  add(path_590381, "groupKey", newJString(groupKey))
  result = call_590380.call(path_590381, query_590382, nil, nil, body_590383)

var directoryMembersInsert* = Call_DirectoryMembersInsert_590367(
    name: "directoryMembersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersInsert_590368,
    base: "/admin/directory/v1", url: url_DirectoryMembersInsert_590369,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersList_590348 = ref object of OpenApiRestCall_588466
proc url_DirectoryMembersList_590350(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersList_590349(path: JsonNode; query: JsonNode;
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
  var valid_590351 = path.getOrDefault("groupKey")
  valid_590351 = validateParameter(valid_590351, JString, required = true,
                                 default = nil)
  if valid_590351 != nil:
    section.add "groupKey", valid_590351
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeDerivedMembership: JBool
  ##                           : Whether to list indirect memberships. Default: false.
  ##   roles: JString
  ##        : Comma separated role values to filter list results on.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return. Max allowed value is 200.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_590352 = query.getOrDefault("fields")
  valid_590352 = validateParameter(valid_590352, JString, required = false,
                                 default = nil)
  if valid_590352 != nil:
    section.add "fields", valid_590352
  var valid_590353 = query.getOrDefault("pageToken")
  valid_590353 = validateParameter(valid_590353, JString, required = false,
                                 default = nil)
  if valid_590353 != nil:
    section.add "pageToken", valid_590353
  var valid_590354 = query.getOrDefault("quotaUser")
  valid_590354 = validateParameter(valid_590354, JString, required = false,
                                 default = nil)
  if valid_590354 != nil:
    section.add "quotaUser", valid_590354
  var valid_590355 = query.getOrDefault("includeDerivedMembership")
  valid_590355 = validateParameter(valid_590355, JBool, required = false, default = nil)
  if valid_590355 != nil:
    section.add "includeDerivedMembership", valid_590355
  var valid_590356 = query.getOrDefault("roles")
  valid_590356 = validateParameter(valid_590356, JString, required = false,
                                 default = nil)
  if valid_590356 != nil:
    section.add "roles", valid_590356
  var valid_590357 = query.getOrDefault("alt")
  valid_590357 = validateParameter(valid_590357, JString, required = false,
                                 default = newJString("json"))
  if valid_590357 != nil:
    section.add "alt", valid_590357
  var valid_590358 = query.getOrDefault("oauth_token")
  valid_590358 = validateParameter(valid_590358, JString, required = false,
                                 default = nil)
  if valid_590358 != nil:
    section.add "oauth_token", valid_590358
  var valid_590359 = query.getOrDefault("userIp")
  valid_590359 = validateParameter(valid_590359, JString, required = false,
                                 default = nil)
  if valid_590359 != nil:
    section.add "userIp", valid_590359
  var valid_590360 = query.getOrDefault("maxResults")
  valid_590360 = validateParameter(valid_590360, JInt, required = false,
                                 default = newJInt(200))
  if valid_590360 != nil:
    section.add "maxResults", valid_590360
  var valid_590361 = query.getOrDefault("key")
  valid_590361 = validateParameter(valid_590361, JString, required = false,
                                 default = nil)
  if valid_590361 != nil:
    section.add "key", valid_590361
  var valid_590362 = query.getOrDefault("prettyPrint")
  valid_590362 = validateParameter(valid_590362, JBool, required = false,
                                 default = newJBool(true))
  if valid_590362 != nil:
    section.add "prettyPrint", valid_590362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590363: Call_DirectoryMembersList_590348; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all members in a group (paginated)
  ## 
  let valid = call_590363.validator(path, query, header, formData, body)
  let scheme = call_590363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590363.url(scheme.get, call_590363.host, call_590363.base,
                         call_590363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590363, url, valid)

proc call*(call_590364: Call_DirectoryMembersList_590348; groupKey: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          includeDerivedMembership: bool = false; roles: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 200; key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryMembersList
  ## Retrieve all members in a group (paginated)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeDerivedMembership: bool
  ##                           : Whether to list indirect memberships. Default: false.
  ##   roles: string
  ##        : Comma separated role values to filter list results on.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return. Max allowed value is 200.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  var path_590365 = newJObject()
  var query_590366 = newJObject()
  add(query_590366, "fields", newJString(fields))
  add(query_590366, "pageToken", newJString(pageToken))
  add(query_590366, "quotaUser", newJString(quotaUser))
  add(query_590366, "includeDerivedMembership", newJBool(includeDerivedMembership))
  add(query_590366, "roles", newJString(roles))
  add(query_590366, "alt", newJString(alt))
  add(query_590366, "oauth_token", newJString(oauthToken))
  add(query_590366, "userIp", newJString(userIp))
  add(query_590366, "maxResults", newJInt(maxResults))
  add(query_590366, "key", newJString(key))
  add(query_590366, "prettyPrint", newJBool(prettyPrint))
  add(path_590365, "groupKey", newJString(groupKey))
  result = call_590364.call(path_590365, query_590366, nil, nil, nil)

var directoryMembersList* = Call_DirectoryMembersList_590348(
    name: "directoryMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersList_590349, base: "/admin/directory/v1",
    url: url_DirectoryMembersList_590350, schemes: {Scheme.Https})
type
  Call_DirectoryMembersUpdate_590400 = ref object of OpenApiRestCall_588466
proc url_DirectoryMembersUpdate_590402(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersUpdate_590401(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update membership of a user in the specified group.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   memberKey: JString (required)
  ##            : Email or immutable ID of the user. If ID, it should match with id of member object
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `memberKey` field"
  var valid_590403 = path.getOrDefault("memberKey")
  valid_590403 = validateParameter(valid_590403, JString, required = true,
                                 default = nil)
  if valid_590403 != nil:
    section.add "memberKey", valid_590403
  var valid_590404 = path.getOrDefault("groupKey")
  valid_590404 = validateParameter(valid_590404, JString, required = true,
                                 default = nil)
  if valid_590404 != nil:
    section.add "groupKey", valid_590404
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
  var valid_590405 = query.getOrDefault("fields")
  valid_590405 = validateParameter(valid_590405, JString, required = false,
                                 default = nil)
  if valid_590405 != nil:
    section.add "fields", valid_590405
  var valid_590406 = query.getOrDefault("quotaUser")
  valid_590406 = validateParameter(valid_590406, JString, required = false,
                                 default = nil)
  if valid_590406 != nil:
    section.add "quotaUser", valid_590406
  var valid_590407 = query.getOrDefault("alt")
  valid_590407 = validateParameter(valid_590407, JString, required = false,
                                 default = newJString("json"))
  if valid_590407 != nil:
    section.add "alt", valid_590407
  var valid_590408 = query.getOrDefault("oauth_token")
  valid_590408 = validateParameter(valid_590408, JString, required = false,
                                 default = nil)
  if valid_590408 != nil:
    section.add "oauth_token", valid_590408
  var valid_590409 = query.getOrDefault("userIp")
  valid_590409 = validateParameter(valid_590409, JString, required = false,
                                 default = nil)
  if valid_590409 != nil:
    section.add "userIp", valid_590409
  var valid_590410 = query.getOrDefault("key")
  valid_590410 = validateParameter(valid_590410, JString, required = false,
                                 default = nil)
  if valid_590410 != nil:
    section.add "key", valid_590410
  var valid_590411 = query.getOrDefault("prettyPrint")
  valid_590411 = validateParameter(valid_590411, JBool, required = false,
                                 default = newJBool(true))
  if valid_590411 != nil:
    section.add "prettyPrint", valid_590411
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

proc call*(call_590413: Call_DirectoryMembersUpdate_590400; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group.
  ## 
  let valid = call_590413.validator(path, query, header, formData, body)
  let scheme = call_590413.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590413.url(scheme.get, call_590413.host, call_590413.base,
                         call_590413.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590413, url, valid)

proc call*(call_590414: Call_DirectoryMembersUpdate_590400; memberKey: string;
          groupKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryMembersUpdate
  ## Update membership of a user in the specified group.
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
  ##   memberKey: string (required)
  ##            : Email or immutable ID of the user. If ID, it should match with id of member object
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  var path_590415 = newJObject()
  var query_590416 = newJObject()
  var body_590417 = newJObject()
  add(query_590416, "fields", newJString(fields))
  add(query_590416, "quotaUser", newJString(quotaUser))
  add(query_590416, "alt", newJString(alt))
  add(query_590416, "oauth_token", newJString(oauthToken))
  add(query_590416, "userIp", newJString(userIp))
  add(path_590415, "memberKey", newJString(memberKey))
  add(query_590416, "key", newJString(key))
  if body != nil:
    body_590417 = body
  add(query_590416, "prettyPrint", newJBool(prettyPrint))
  add(path_590415, "groupKey", newJString(groupKey))
  result = call_590414.call(path_590415, query_590416, nil, nil, body_590417)

var directoryMembersUpdate* = Call_DirectoryMembersUpdate_590400(
    name: "directoryMembersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersUpdate_590401,
    base: "/admin/directory/v1", url: url_DirectoryMembersUpdate_590402,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersGet_590384 = ref object of OpenApiRestCall_588466
proc url_DirectoryMembersGet_590386(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersGet_590385(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Retrieve Group Member
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   memberKey: JString (required)
  ##            : Email or immutable ID of the member
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `memberKey` field"
  var valid_590387 = path.getOrDefault("memberKey")
  valid_590387 = validateParameter(valid_590387, JString, required = true,
                                 default = nil)
  if valid_590387 != nil:
    section.add "memberKey", valid_590387
  var valid_590388 = path.getOrDefault("groupKey")
  valid_590388 = validateParameter(valid_590388, JString, required = true,
                                 default = nil)
  if valid_590388 != nil:
    section.add "groupKey", valid_590388
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
  var valid_590389 = query.getOrDefault("fields")
  valid_590389 = validateParameter(valid_590389, JString, required = false,
                                 default = nil)
  if valid_590389 != nil:
    section.add "fields", valid_590389
  var valid_590390 = query.getOrDefault("quotaUser")
  valid_590390 = validateParameter(valid_590390, JString, required = false,
                                 default = nil)
  if valid_590390 != nil:
    section.add "quotaUser", valid_590390
  var valid_590391 = query.getOrDefault("alt")
  valid_590391 = validateParameter(valid_590391, JString, required = false,
                                 default = newJString("json"))
  if valid_590391 != nil:
    section.add "alt", valid_590391
  var valid_590392 = query.getOrDefault("oauth_token")
  valid_590392 = validateParameter(valid_590392, JString, required = false,
                                 default = nil)
  if valid_590392 != nil:
    section.add "oauth_token", valid_590392
  var valid_590393 = query.getOrDefault("userIp")
  valid_590393 = validateParameter(valid_590393, JString, required = false,
                                 default = nil)
  if valid_590393 != nil:
    section.add "userIp", valid_590393
  var valid_590394 = query.getOrDefault("key")
  valid_590394 = validateParameter(valid_590394, JString, required = false,
                                 default = nil)
  if valid_590394 != nil:
    section.add "key", valid_590394
  var valid_590395 = query.getOrDefault("prettyPrint")
  valid_590395 = validateParameter(valid_590395, JBool, required = false,
                                 default = newJBool(true))
  if valid_590395 != nil:
    section.add "prettyPrint", valid_590395
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590396: Call_DirectoryMembersGet_590384; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group Member
  ## 
  let valid = call_590396.validator(path, query, header, formData, body)
  let scheme = call_590396.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590396.url(scheme.get, call_590396.host, call_590396.base,
                         call_590396.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590396, url, valid)

proc call*(call_590397: Call_DirectoryMembersGet_590384; memberKey: string;
          groupKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryMembersGet
  ## Retrieve Group Member
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
  ##   memberKey: string (required)
  ##            : Email or immutable ID of the member
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  var path_590398 = newJObject()
  var query_590399 = newJObject()
  add(query_590399, "fields", newJString(fields))
  add(query_590399, "quotaUser", newJString(quotaUser))
  add(query_590399, "alt", newJString(alt))
  add(query_590399, "oauth_token", newJString(oauthToken))
  add(query_590399, "userIp", newJString(userIp))
  add(path_590398, "memberKey", newJString(memberKey))
  add(query_590399, "key", newJString(key))
  add(query_590399, "prettyPrint", newJBool(prettyPrint))
  add(path_590398, "groupKey", newJString(groupKey))
  result = call_590397.call(path_590398, query_590399, nil, nil, nil)

var directoryMembersGet* = Call_DirectoryMembersGet_590384(
    name: "directoryMembersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersGet_590385, base: "/admin/directory/v1",
    url: url_DirectoryMembersGet_590386, schemes: {Scheme.Https})
type
  Call_DirectoryMembersPatch_590434 = ref object of OpenApiRestCall_588466
proc url_DirectoryMembersPatch_590436(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersPatch_590435(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Update membership of a user in the specified group. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   memberKey: JString (required)
  ##            : Email or immutable ID of the user. If ID, it should match with id of member object
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `memberKey` field"
  var valid_590437 = path.getOrDefault("memberKey")
  valid_590437 = validateParameter(valid_590437, JString, required = true,
                                 default = nil)
  if valid_590437 != nil:
    section.add "memberKey", valid_590437
  var valid_590438 = path.getOrDefault("groupKey")
  valid_590438 = validateParameter(valid_590438, JString, required = true,
                                 default = nil)
  if valid_590438 != nil:
    section.add "groupKey", valid_590438
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
  var valid_590439 = query.getOrDefault("fields")
  valid_590439 = validateParameter(valid_590439, JString, required = false,
                                 default = nil)
  if valid_590439 != nil:
    section.add "fields", valid_590439
  var valid_590440 = query.getOrDefault("quotaUser")
  valid_590440 = validateParameter(valid_590440, JString, required = false,
                                 default = nil)
  if valid_590440 != nil:
    section.add "quotaUser", valid_590440
  var valid_590441 = query.getOrDefault("alt")
  valid_590441 = validateParameter(valid_590441, JString, required = false,
                                 default = newJString("json"))
  if valid_590441 != nil:
    section.add "alt", valid_590441
  var valid_590442 = query.getOrDefault("oauth_token")
  valid_590442 = validateParameter(valid_590442, JString, required = false,
                                 default = nil)
  if valid_590442 != nil:
    section.add "oauth_token", valid_590442
  var valid_590443 = query.getOrDefault("userIp")
  valid_590443 = validateParameter(valid_590443, JString, required = false,
                                 default = nil)
  if valid_590443 != nil:
    section.add "userIp", valid_590443
  var valid_590444 = query.getOrDefault("key")
  valid_590444 = validateParameter(valid_590444, JString, required = false,
                                 default = nil)
  if valid_590444 != nil:
    section.add "key", valid_590444
  var valid_590445 = query.getOrDefault("prettyPrint")
  valid_590445 = validateParameter(valid_590445, JBool, required = false,
                                 default = newJBool(true))
  if valid_590445 != nil:
    section.add "prettyPrint", valid_590445
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

proc call*(call_590447: Call_DirectoryMembersPatch_590434; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group. This method supports patch semantics.
  ## 
  let valid = call_590447.validator(path, query, header, formData, body)
  let scheme = call_590447.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590447.url(scheme.get, call_590447.host, call_590447.base,
                         call_590447.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590447, url, valid)

proc call*(call_590448: Call_DirectoryMembersPatch_590434; memberKey: string;
          groupKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryMembersPatch
  ## Update membership of a user in the specified group. This method supports patch semantics.
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
  ##   memberKey: string (required)
  ##            : Email or immutable ID of the user. If ID, it should match with id of member object
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group. If ID, it should match with id of group object
  var path_590449 = newJObject()
  var query_590450 = newJObject()
  var body_590451 = newJObject()
  add(query_590450, "fields", newJString(fields))
  add(query_590450, "quotaUser", newJString(quotaUser))
  add(query_590450, "alt", newJString(alt))
  add(query_590450, "oauth_token", newJString(oauthToken))
  add(query_590450, "userIp", newJString(userIp))
  add(path_590449, "memberKey", newJString(memberKey))
  add(query_590450, "key", newJString(key))
  if body != nil:
    body_590451 = body
  add(query_590450, "prettyPrint", newJBool(prettyPrint))
  add(path_590449, "groupKey", newJString(groupKey))
  result = call_590448.call(path_590449, query_590450, nil, nil, body_590451)

var directoryMembersPatch* = Call_DirectoryMembersPatch_590434(
    name: "directoryMembersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersPatch_590435, base: "/admin/directory/v1",
    url: url_DirectoryMembersPatch_590436, schemes: {Scheme.Https})
type
  Call_DirectoryMembersDelete_590418 = ref object of OpenApiRestCall_588466
proc url_DirectoryMembersDelete_590420(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersDelete_590419(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove membership.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   memberKey: JString (required)
  ##            : Email or immutable ID of the member
  ##   groupKey: JString (required)
  ##           : Email or immutable ID of the group
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `memberKey` field"
  var valid_590421 = path.getOrDefault("memberKey")
  valid_590421 = validateParameter(valid_590421, JString, required = true,
                                 default = nil)
  if valid_590421 != nil:
    section.add "memberKey", valid_590421
  var valid_590422 = path.getOrDefault("groupKey")
  valid_590422 = validateParameter(valid_590422, JString, required = true,
                                 default = nil)
  if valid_590422 != nil:
    section.add "groupKey", valid_590422
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
  var valid_590423 = query.getOrDefault("fields")
  valid_590423 = validateParameter(valid_590423, JString, required = false,
                                 default = nil)
  if valid_590423 != nil:
    section.add "fields", valid_590423
  var valid_590424 = query.getOrDefault("quotaUser")
  valid_590424 = validateParameter(valid_590424, JString, required = false,
                                 default = nil)
  if valid_590424 != nil:
    section.add "quotaUser", valid_590424
  var valid_590425 = query.getOrDefault("alt")
  valid_590425 = validateParameter(valid_590425, JString, required = false,
                                 default = newJString("json"))
  if valid_590425 != nil:
    section.add "alt", valid_590425
  var valid_590426 = query.getOrDefault("oauth_token")
  valid_590426 = validateParameter(valid_590426, JString, required = false,
                                 default = nil)
  if valid_590426 != nil:
    section.add "oauth_token", valid_590426
  var valid_590427 = query.getOrDefault("userIp")
  valid_590427 = validateParameter(valid_590427, JString, required = false,
                                 default = nil)
  if valid_590427 != nil:
    section.add "userIp", valid_590427
  var valid_590428 = query.getOrDefault("key")
  valid_590428 = validateParameter(valid_590428, JString, required = false,
                                 default = nil)
  if valid_590428 != nil:
    section.add "key", valid_590428
  var valid_590429 = query.getOrDefault("prettyPrint")
  valid_590429 = validateParameter(valid_590429, JBool, required = false,
                                 default = newJBool(true))
  if valid_590429 != nil:
    section.add "prettyPrint", valid_590429
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590430: Call_DirectoryMembersDelete_590418; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove membership.
  ## 
  let valid = call_590430.validator(path, query, header, formData, body)
  let scheme = call_590430.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590430.url(scheme.get, call_590430.host, call_590430.base,
                         call_590430.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590430, url, valid)

proc call*(call_590431: Call_DirectoryMembersDelete_590418; memberKey: string;
          groupKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryMembersDelete
  ## Remove membership.
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
  ##   memberKey: string (required)
  ##            : Email or immutable ID of the member
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   groupKey: string (required)
  ##           : Email or immutable ID of the group
  var path_590432 = newJObject()
  var query_590433 = newJObject()
  add(query_590433, "fields", newJString(fields))
  add(query_590433, "quotaUser", newJString(quotaUser))
  add(query_590433, "alt", newJString(alt))
  add(query_590433, "oauth_token", newJString(oauthToken))
  add(query_590433, "userIp", newJString(userIp))
  add(path_590432, "memberKey", newJString(memberKey))
  add(query_590433, "key", newJString(key))
  add(query_590433, "prettyPrint", newJBool(prettyPrint))
  add(path_590432, "groupKey", newJString(groupKey))
  result = call_590431.call(path_590432, query_590433, nil, nil, nil)

var directoryMembersDelete* = Call_DirectoryMembersDelete_590418(
    name: "directoryMembersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersDelete_590419,
    base: "/admin/directory/v1", url: url_DirectoryMembersDelete_590420,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsGetSettings_590452 = ref object of OpenApiRestCall_588466
proc url_DirectoryResolvedAppAccessSettingsGetSettings_590454(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsGetSettings_590453(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves resolved app access settings of the logged in user.
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
  var valid_590455 = query.getOrDefault("fields")
  valid_590455 = validateParameter(valid_590455, JString, required = false,
                                 default = nil)
  if valid_590455 != nil:
    section.add "fields", valid_590455
  var valid_590456 = query.getOrDefault("quotaUser")
  valid_590456 = validateParameter(valid_590456, JString, required = false,
                                 default = nil)
  if valid_590456 != nil:
    section.add "quotaUser", valid_590456
  var valid_590457 = query.getOrDefault("alt")
  valid_590457 = validateParameter(valid_590457, JString, required = false,
                                 default = newJString("json"))
  if valid_590457 != nil:
    section.add "alt", valid_590457
  var valid_590458 = query.getOrDefault("oauth_token")
  valid_590458 = validateParameter(valid_590458, JString, required = false,
                                 default = nil)
  if valid_590458 != nil:
    section.add "oauth_token", valid_590458
  var valid_590459 = query.getOrDefault("userIp")
  valid_590459 = validateParameter(valid_590459, JString, required = false,
                                 default = nil)
  if valid_590459 != nil:
    section.add "userIp", valid_590459
  var valid_590460 = query.getOrDefault("key")
  valid_590460 = validateParameter(valid_590460, JString, required = false,
                                 default = nil)
  if valid_590460 != nil:
    section.add "key", valid_590460
  var valid_590461 = query.getOrDefault("prettyPrint")
  valid_590461 = validateParameter(valid_590461, JBool, required = false,
                                 default = newJBool(true))
  if valid_590461 != nil:
    section.add "prettyPrint", valid_590461
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590462: Call_DirectoryResolvedAppAccessSettingsGetSettings_590452;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves resolved app access settings of the logged in user.
  ## 
  let valid = call_590462.validator(path, query, header, formData, body)
  let scheme = call_590462.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590462.url(scheme.get, call_590462.host, call_590462.base,
                         call_590462.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590462, url, valid)

proc call*(call_590463: Call_DirectoryResolvedAppAccessSettingsGetSettings_590452;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryResolvedAppAccessSettingsGetSettings
  ## Retrieves resolved app access settings of the logged in user.
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
  var query_590464 = newJObject()
  add(query_590464, "fields", newJString(fields))
  add(query_590464, "quotaUser", newJString(quotaUser))
  add(query_590464, "alt", newJString(alt))
  add(query_590464, "oauth_token", newJString(oauthToken))
  add(query_590464, "userIp", newJString(userIp))
  add(query_590464, "key", newJString(key))
  add(query_590464, "prettyPrint", newJBool(prettyPrint))
  result = call_590463.call(nil, query_590464, nil, nil, nil)

var directoryResolvedAppAccessSettingsGetSettings* = Call_DirectoryResolvedAppAccessSettingsGetSettings_590452(
    name: "directoryResolvedAppAccessSettingsGetSettings",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/resolvedappaccesssettings",
    validator: validate_DirectoryResolvedAppAccessSettingsGetSettings_590453,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsGetSettings_590454,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsListTrustedApps_590465 = ref object of OpenApiRestCall_588466
proc url_DirectoryResolvedAppAccessSettingsListTrustedApps_590467(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsListTrustedApps_590466(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Retrieves the list of apps trusted by the admin of the logged in user.
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
  var valid_590468 = query.getOrDefault("fields")
  valid_590468 = validateParameter(valid_590468, JString, required = false,
                                 default = nil)
  if valid_590468 != nil:
    section.add "fields", valid_590468
  var valid_590469 = query.getOrDefault("quotaUser")
  valid_590469 = validateParameter(valid_590469, JString, required = false,
                                 default = nil)
  if valid_590469 != nil:
    section.add "quotaUser", valid_590469
  var valid_590470 = query.getOrDefault("alt")
  valid_590470 = validateParameter(valid_590470, JString, required = false,
                                 default = newJString("json"))
  if valid_590470 != nil:
    section.add "alt", valid_590470
  var valid_590471 = query.getOrDefault("oauth_token")
  valid_590471 = validateParameter(valid_590471, JString, required = false,
                                 default = nil)
  if valid_590471 != nil:
    section.add "oauth_token", valid_590471
  var valid_590472 = query.getOrDefault("userIp")
  valid_590472 = validateParameter(valid_590472, JString, required = false,
                                 default = nil)
  if valid_590472 != nil:
    section.add "userIp", valid_590472
  var valid_590473 = query.getOrDefault("key")
  valid_590473 = validateParameter(valid_590473, JString, required = false,
                                 default = nil)
  if valid_590473 != nil:
    section.add "key", valid_590473
  var valid_590474 = query.getOrDefault("prettyPrint")
  valid_590474 = validateParameter(valid_590474, JBool, required = false,
                                 default = newJBool(true))
  if valid_590474 != nil:
    section.add "prettyPrint", valid_590474
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590475: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_590465;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of apps trusted by the admin of the logged in user.
  ## 
  let valid = call_590475.validator(path, query, header, formData, body)
  let scheme = call_590475.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590475.url(scheme.get, call_590475.host, call_590475.base,
                         call_590475.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590475, url, valid)

proc call*(call_590476: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_590465;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryResolvedAppAccessSettingsListTrustedApps
  ## Retrieves the list of apps trusted by the admin of the logged in user.
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
  var query_590477 = newJObject()
  add(query_590477, "fields", newJString(fields))
  add(query_590477, "quotaUser", newJString(quotaUser))
  add(query_590477, "alt", newJString(alt))
  add(query_590477, "oauth_token", newJString(oauthToken))
  add(query_590477, "userIp", newJString(userIp))
  add(query_590477, "key", newJString(key))
  add(query_590477, "prettyPrint", newJBool(prettyPrint))
  result = call_590476.call(nil, query_590477, nil, nil, nil)

var directoryResolvedAppAccessSettingsListTrustedApps* = Call_DirectoryResolvedAppAccessSettingsListTrustedApps_590465(
    name: "directoryResolvedAppAccessSettingsListTrustedApps",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/trustedapps",
    validator: validate_DirectoryResolvedAppAccessSettingsListTrustedApps_590466,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsListTrustedApps_590467,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersInsert_590503 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersInsert_590505(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersInsert_590504(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## create user.
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
  var valid_590506 = query.getOrDefault("fields")
  valid_590506 = validateParameter(valid_590506, JString, required = false,
                                 default = nil)
  if valid_590506 != nil:
    section.add "fields", valid_590506
  var valid_590507 = query.getOrDefault("quotaUser")
  valid_590507 = validateParameter(valid_590507, JString, required = false,
                                 default = nil)
  if valid_590507 != nil:
    section.add "quotaUser", valid_590507
  var valid_590508 = query.getOrDefault("alt")
  valid_590508 = validateParameter(valid_590508, JString, required = false,
                                 default = newJString("json"))
  if valid_590508 != nil:
    section.add "alt", valid_590508
  var valid_590509 = query.getOrDefault("oauth_token")
  valid_590509 = validateParameter(valid_590509, JString, required = false,
                                 default = nil)
  if valid_590509 != nil:
    section.add "oauth_token", valid_590509
  var valid_590510 = query.getOrDefault("userIp")
  valid_590510 = validateParameter(valid_590510, JString, required = false,
                                 default = nil)
  if valid_590510 != nil:
    section.add "userIp", valid_590510
  var valid_590511 = query.getOrDefault("key")
  valid_590511 = validateParameter(valid_590511, JString, required = false,
                                 default = nil)
  if valid_590511 != nil:
    section.add "key", valid_590511
  var valid_590512 = query.getOrDefault("prettyPrint")
  valid_590512 = validateParameter(valid_590512, JBool, required = false,
                                 default = newJBool(true))
  if valid_590512 != nil:
    section.add "prettyPrint", valid_590512
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

proc call*(call_590514: Call_DirectoryUsersInsert_590503; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## create user.
  ## 
  let valid = call_590514.validator(path, query, header, formData, body)
  let scheme = call_590514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590514.url(scheme.get, call_590514.host, call_590514.base,
                         call_590514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590514, url, valid)

proc call*(call_590515: Call_DirectoryUsersInsert_590503; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## directoryUsersInsert
  ## create user.
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
  var query_590516 = newJObject()
  var body_590517 = newJObject()
  add(query_590516, "fields", newJString(fields))
  add(query_590516, "quotaUser", newJString(quotaUser))
  add(query_590516, "alt", newJString(alt))
  add(query_590516, "oauth_token", newJString(oauthToken))
  add(query_590516, "userIp", newJString(userIp))
  add(query_590516, "key", newJString(key))
  if body != nil:
    body_590517 = body
  add(query_590516, "prettyPrint", newJBool(prettyPrint))
  result = call_590515.call(nil, query_590516, nil, nil, body_590517)

var directoryUsersInsert* = Call_DirectoryUsersInsert_590503(
    name: "directoryUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersInsert_590504, base: "/admin/directory/v1",
    url: url_DirectoryUsersInsert_590505, schemes: {Scheme.Https})
type
  Call_DirectoryUsersList_590478 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersList_590480(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersList_590479(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieve either deleted users or all users in a domain (paginated)
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   event: JString
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: JString
  ##      : Data format for the response.
  ##   query: JString
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-users
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   showDeleted: JString
  ##              : If set to true, retrieves the list of deleted users. (Default: false)
  ##   customFieldMask: JString
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : What subset of fields to fetch for this user.
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order.
  ##   customer: JString
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all users for a customer, fill this field instead of domain.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   viewType: JString
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   domain: JString
  ##         : Name of the domain. Fill this field to get users from only this domain. To return all users in a multi-domain fill customer field instead.
  section = newJObject()
  var valid_590481 = query.getOrDefault("fields")
  valid_590481 = validateParameter(valid_590481, JString, required = false,
                                 default = nil)
  if valid_590481 != nil:
    section.add "fields", valid_590481
  var valid_590482 = query.getOrDefault("pageToken")
  valid_590482 = validateParameter(valid_590482, JString, required = false,
                                 default = nil)
  if valid_590482 != nil:
    section.add "pageToken", valid_590482
  var valid_590483 = query.getOrDefault("quotaUser")
  valid_590483 = validateParameter(valid_590483, JString, required = false,
                                 default = nil)
  if valid_590483 != nil:
    section.add "quotaUser", valid_590483
  var valid_590484 = query.getOrDefault("event")
  valid_590484 = validateParameter(valid_590484, JString, required = false,
                                 default = newJString("add"))
  if valid_590484 != nil:
    section.add "event", valid_590484
  var valid_590485 = query.getOrDefault("alt")
  valid_590485 = validateParameter(valid_590485, JString, required = false,
                                 default = newJString("json"))
  if valid_590485 != nil:
    section.add "alt", valid_590485
  var valid_590486 = query.getOrDefault("query")
  valid_590486 = validateParameter(valid_590486, JString, required = false,
                                 default = nil)
  if valid_590486 != nil:
    section.add "query", valid_590486
  var valid_590487 = query.getOrDefault("oauth_token")
  valid_590487 = validateParameter(valid_590487, JString, required = false,
                                 default = nil)
  if valid_590487 != nil:
    section.add "oauth_token", valid_590487
  var valid_590488 = query.getOrDefault("userIp")
  valid_590488 = validateParameter(valid_590488, JString, required = false,
                                 default = nil)
  if valid_590488 != nil:
    section.add "userIp", valid_590488
  var valid_590489 = query.getOrDefault("maxResults")
  valid_590489 = validateParameter(valid_590489, JInt, required = false,
                                 default = newJInt(100))
  if valid_590489 != nil:
    section.add "maxResults", valid_590489
  var valid_590490 = query.getOrDefault("orderBy")
  valid_590490 = validateParameter(valid_590490, JString, required = false,
                                 default = newJString("email"))
  if valid_590490 != nil:
    section.add "orderBy", valid_590490
  var valid_590491 = query.getOrDefault("showDeleted")
  valid_590491 = validateParameter(valid_590491, JString, required = false,
                                 default = nil)
  if valid_590491 != nil:
    section.add "showDeleted", valid_590491
  var valid_590492 = query.getOrDefault("customFieldMask")
  valid_590492 = validateParameter(valid_590492, JString, required = false,
                                 default = nil)
  if valid_590492 != nil:
    section.add "customFieldMask", valid_590492
  var valid_590493 = query.getOrDefault("key")
  valid_590493 = validateParameter(valid_590493, JString, required = false,
                                 default = nil)
  if valid_590493 != nil:
    section.add "key", valid_590493
  var valid_590494 = query.getOrDefault("projection")
  valid_590494 = validateParameter(valid_590494, JString, required = false,
                                 default = newJString("basic"))
  if valid_590494 != nil:
    section.add "projection", valid_590494
  var valid_590495 = query.getOrDefault("sortOrder")
  valid_590495 = validateParameter(valid_590495, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_590495 != nil:
    section.add "sortOrder", valid_590495
  var valid_590496 = query.getOrDefault("customer")
  valid_590496 = validateParameter(valid_590496, JString, required = false,
                                 default = nil)
  if valid_590496 != nil:
    section.add "customer", valid_590496
  var valid_590497 = query.getOrDefault("prettyPrint")
  valid_590497 = validateParameter(valid_590497, JBool, required = false,
                                 default = newJBool(true))
  if valid_590497 != nil:
    section.add "prettyPrint", valid_590497
  var valid_590498 = query.getOrDefault("viewType")
  valid_590498 = validateParameter(valid_590498, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_590498 != nil:
    section.add "viewType", valid_590498
  var valid_590499 = query.getOrDefault("domain")
  valid_590499 = validateParameter(valid_590499, JString, required = false,
                                 default = nil)
  if valid_590499 != nil:
    section.add "domain", valid_590499
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590500: Call_DirectoryUsersList_590478; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve either deleted users or all users in a domain (paginated)
  ## 
  let valid = call_590500.validator(path, query, header, formData, body)
  let scheme = call_590500.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590500.url(scheme.get, call_590500.host, call_590500.base,
                         call_590500.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590500, url, valid)

proc call*(call_590501: Call_DirectoryUsersList_590478; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; event: string = "add";
          alt: string = "json"; query: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 100; orderBy: string = "email";
          showDeleted: string = ""; customFieldMask: string = ""; key: string = "";
          projection: string = "basic"; sortOrder: string = "ASCENDING";
          customer: string = ""; prettyPrint: bool = true;
          viewType: string = "admin_view"; domain: string = ""): Recallable =
  ## directoryUsersList
  ## Retrieve either deleted users or all users in a domain (paginated)
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   event: string
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-users
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   showDeleted: string
  ##              : If set to true, retrieves the list of deleted users. (Default: false)
  ##   customFieldMask: string
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : What subset of fields to fetch for this user.
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order.
  ##   customer: string
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all users for a customer, fill this field instead of domain.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   viewType: string
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   domain: string
  ##         : Name of the domain. Fill this field to get users from only this domain. To return all users in a multi-domain fill customer field instead.
  var query_590502 = newJObject()
  add(query_590502, "fields", newJString(fields))
  add(query_590502, "pageToken", newJString(pageToken))
  add(query_590502, "quotaUser", newJString(quotaUser))
  add(query_590502, "event", newJString(event))
  add(query_590502, "alt", newJString(alt))
  add(query_590502, "query", newJString(query))
  add(query_590502, "oauth_token", newJString(oauthToken))
  add(query_590502, "userIp", newJString(userIp))
  add(query_590502, "maxResults", newJInt(maxResults))
  add(query_590502, "orderBy", newJString(orderBy))
  add(query_590502, "showDeleted", newJString(showDeleted))
  add(query_590502, "customFieldMask", newJString(customFieldMask))
  add(query_590502, "key", newJString(key))
  add(query_590502, "projection", newJString(projection))
  add(query_590502, "sortOrder", newJString(sortOrder))
  add(query_590502, "customer", newJString(customer))
  add(query_590502, "prettyPrint", newJBool(prettyPrint))
  add(query_590502, "viewType", newJString(viewType))
  add(query_590502, "domain", newJString(domain))
  result = call_590501.call(nil, query_590502, nil, nil, nil)

var directoryUsersList* = Call_DirectoryUsersList_590478(
    name: "directoryUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersList_590479, base: "/admin/directory/v1",
    url: url_DirectoryUsersList_590480, schemes: {Scheme.Https})
type
  Call_DirectoryUsersWatch_590518 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersWatch_590520(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersWatch_590519(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Watch for changes in users list
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : Token to specify next page in the list
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   event: JString
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: JString
  ##      : Data format for the response.
  ##   query: JString
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-users
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of results to return.
  ##   orderBy: JString
  ##          : Column to use for sorting results
  ##   showDeleted: JString
  ##              : If set to true, retrieves the list of deleted users. (Default: false)
  ##   customFieldMask: JString
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : What subset of fields to fetch for this user.
  ##   sortOrder: JString
  ##            : Whether to return results in ascending or descending order.
  ##   customer: JString
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all users for a customer, fill this field instead of domain.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   viewType: JString
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   domain: JString
  ##         : Name of the domain. Fill this field to get users from only this domain. To return all users in a multi-domain fill customer field instead.
  section = newJObject()
  var valid_590521 = query.getOrDefault("fields")
  valid_590521 = validateParameter(valid_590521, JString, required = false,
                                 default = nil)
  if valid_590521 != nil:
    section.add "fields", valid_590521
  var valid_590522 = query.getOrDefault("pageToken")
  valid_590522 = validateParameter(valid_590522, JString, required = false,
                                 default = nil)
  if valid_590522 != nil:
    section.add "pageToken", valid_590522
  var valid_590523 = query.getOrDefault("quotaUser")
  valid_590523 = validateParameter(valid_590523, JString, required = false,
                                 default = nil)
  if valid_590523 != nil:
    section.add "quotaUser", valid_590523
  var valid_590524 = query.getOrDefault("event")
  valid_590524 = validateParameter(valid_590524, JString, required = false,
                                 default = newJString("add"))
  if valid_590524 != nil:
    section.add "event", valid_590524
  var valid_590525 = query.getOrDefault("alt")
  valid_590525 = validateParameter(valid_590525, JString, required = false,
                                 default = newJString("json"))
  if valid_590525 != nil:
    section.add "alt", valid_590525
  var valid_590526 = query.getOrDefault("query")
  valid_590526 = validateParameter(valid_590526, JString, required = false,
                                 default = nil)
  if valid_590526 != nil:
    section.add "query", valid_590526
  var valid_590527 = query.getOrDefault("oauth_token")
  valid_590527 = validateParameter(valid_590527, JString, required = false,
                                 default = nil)
  if valid_590527 != nil:
    section.add "oauth_token", valid_590527
  var valid_590528 = query.getOrDefault("userIp")
  valid_590528 = validateParameter(valid_590528, JString, required = false,
                                 default = nil)
  if valid_590528 != nil:
    section.add "userIp", valid_590528
  var valid_590529 = query.getOrDefault("maxResults")
  valid_590529 = validateParameter(valid_590529, JInt, required = false,
                                 default = newJInt(100))
  if valid_590529 != nil:
    section.add "maxResults", valid_590529
  var valid_590530 = query.getOrDefault("orderBy")
  valid_590530 = validateParameter(valid_590530, JString, required = false,
                                 default = newJString("email"))
  if valid_590530 != nil:
    section.add "orderBy", valid_590530
  var valid_590531 = query.getOrDefault("showDeleted")
  valid_590531 = validateParameter(valid_590531, JString, required = false,
                                 default = nil)
  if valid_590531 != nil:
    section.add "showDeleted", valid_590531
  var valid_590532 = query.getOrDefault("customFieldMask")
  valid_590532 = validateParameter(valid_590532, JString, required = false,
                                 default = nil)
  if valid_590532 != nil:
    section.add "customFieldMask", valid_590532
  var valid_590533 = query.getOrDefault("key")
  valid_590533 = validateParameter(valid_590533, JString, required = false,
                                 default = nil)
  if valid_590533 != nil:
    section.add "key", valid_590533
  var valid_590534 = query.getOrDefault("projection")
  valid_590534 = validateParameter(valid_590534, JString, required = false,
                                 default = newJString("basic"))
  if valid_590534 != nil:
    section.add "projection", valid_590534
  var valid_590535 = query.getOrDefault("sortOrder")
  valid_590535 = validateParameter(valid_590535, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_590535 != nil:
    section.add "sortOrder", valid_590535
  var valid_590536 = query.getOrDefault("customer")
  valid_590536 = validateParameter(valid_590536, JString, required = false,
                                 default = nil)
  if valid_590536 != nil:
    section.add "customer", valid_590536
  var valid_590537 = query.getOrDefault("prettyPrint")
  valid_590537 = validateParameter(valid_590537, JBool, required = false,
                                 default = newJBool(true))
  if valid_590537 != nil:
    section.add "prettyPrint", valid_590537
  var valid_590538 = query.getOrDefault("viewType")
  valid_590538 = validateParameter(valid_590538, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_590538 != nil:
    section.add "viewType", valid_590538
  var valid_590539 = query.getOrDefault("domain")
  valid_590539 = validateParameter(valid_590539, JString, required = false,
                                 default = nil)
  if valid_590539 != nil:
    section.add "domain", valid_590539
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

proc call*(call_590541: Call_DirectoryUsersWatch_590518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in users list
  ## 
  let valid = call_590541.validator(path, query, header, formData, body)
  let scheme = call_590541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590541.url(scheme.get, call_590541.host, call_590541.base,
                         call_590541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590541, url, valid)

proc call*(call_590542: Call_DirectoryUsersWatch_590518; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; event: string = "add";
          alt: string = "json"; query: string = ""; oauthToken: string = "";
          userIp: string = ""; maxResults: int = 100; orderBy: string = "email";
          showDeleted: string = ""; customFieldMask: string = ""; key: string = "";
          projection: string = "basic"; sortOrder: string = "ASCENDING";
          resource: JsonNode = nil; customer: string = ""; prettyPrint: bool = true;
          viewType: string = "admin_view"; domain: string = ""): Recallable =
  ## directoryUsersWatch
  ## Watch for changes in users list
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : Token to specify next page in the list
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   event: string
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: string
  ##      : Data format for the response.
  ##   query: string
  ##        : Query string search. Should be of the form "". Complete documentation is at https://developers.google.com/admin-sdk/directory/v1/guides/search-users
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of results to return.
  ##   orderBy: string
  ##          : Column to use for sorting results
  ##   showDeleted: string
  ##              : If set to true, retrieves the list of deleted users. (Default: false)
  ##   customFieldMask: string
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : What subset of fields to fetch for this user.
  ##   sortOrder: string
  ##            : Whether to return results in ascending or descending order.
  ##   resource: JObject
  ##   customer: string
  ##           : Immutable ID of the G Suite account. In case of multi-domain, to fetch all users for a customer, fill this field instead of domain.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   viewType: string
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  ##   domain: string
  ##         : Name of the domain. Fill this field to get users from only this domain. To return all users in a multi-domain fill customer field instead.
  var query_590543 = newJObject()
  var body_590544 = newJObject()
  add(query_590543, "fields", newJString(fields))
  add(query_590543, "pageToken", newJString(pageToken))
  add(query_590543, "quotaUser", newJString(quotaUser))
  add(query_590543, "event", newJString(event))
  add(query_590543, "alt", newJString(alt))
  add(query_590543, "query", newJString(query))
  add(query_590543, "oauth_token", newJString(oauthToken))
  add(query_590543, "userIp", newJString(userIp))
  add(query_590543, "maxResults", newJInt(maxResults))
  add(query_590543, "orderBy", newJString(orderBy))
  add(query_590543, "showDeleted", newJString(showDeleted))
  add(query_590543, "customFieldMask", newJString(customFieldMask))
  add(query_590543, "key", newJString(key))
  add(query_590543, "projection", newJString(projection))
  add(query_590543, "sortOrder", newJString(sortOrder))
  if resource != nil:
    body_590544 = resource
  add(query_590543, "customer", newJString(customer))
  add(query_590543, "prettyPrint", newJBool(prettyPrint))
  add(query_590543, "viewType", newJString(viewType))
  add(query_590543, "domain", newJString(domain))
  result = call_590542.call(nil, query_590543, nil, nil, body_590544)

var directoryUsersWatch* = Call_DirectoryUsersWatch_590518(
    name: "directoryUsersWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/watch",
    validator: validate_DirectoryUsersWatch_590519, base: "/admin/directory/v1",
    url: url_DirectoryUsersWatch_590520, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUpdate_590563 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersUpdate_590565(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersUpdate_590564(path: JsonNode; query: JsonNode;
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
  var valid_590566 = path.getOrDefault("userKey")
  valid_590566 = validateParameter(valid_590566, JString, required = true,
                                 default = nil)
  if valid_590566 != nil:
    section.add "userKey", valid_590566
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
  var valid_590567 = query.getOrDefault("fields")
  valid_590567 = validateParameter(valid_590567, JString, required = false,
                                 default = nil)
  if valid_590567 != nil:
    section.add "fields", valid_590567
  var valid_590568 = query.getOrDefault("quotaUser")
  valid_590568 = validateParameter(valid_590568, JString, required = false,
                                 default = nil)
  if valid_590568 != nil:
    section.add "quotaUser", valid_590568
  var valid_590569 = query.getOrDefault("alt")
  valid_590569 = validateParameter(valid_590569, JString, required = false,
                                 default = newJString("json"))
  if valid_590569 != nil:
    section.add "alt", valid_590569
  var valid_590570 = query.getOrDefault("oauth_token")
  valid_590570 = validateParameter(valid_590570, JString, required = false,
                                 default = nil)
  if valid_590570 != nil:
    section.add "oauth_token", valid_590570
  var valid_590571 = query.getOrDefault("userIp")
  valid_590571 = validateParameter(valid_590571, JString, required = false,
                                 default = nil)
  if valid_590571 != nil:
    section.add "userIp", valid_590571
  var valid_590572 = query.getOrDefault("key")
  valid_590572 = validateParameter(valid_590572, JString, required = false,
                                 default = nil)
  if valid_590572 != nil:
    section.add "key", valid_590572
  var valid_590573 = query.getOrDefault("prettyPrint")
  valid_590573 = validateParameter(valid_590573, JBool, required = false,
                                 default = newJBool(true))
  if valid_590573 != nil:
    section.add "prettyPrint", valid_590573
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

proc call*(call_590575: Call_DirectoryUsersUpdate_590563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user
  ## 
  let valid = call_590575.validator(path, query, header, formData, body)
  let scheme = call_590575.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590575.url(scheme.get, call_590575.host, call_590575.base,
                         call_590575.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590575, url, valid)

proc call*(call_590576: Call_DirectoryUsersUpdate_590563; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryUsersUpdate
  ## update user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user. If ID, it should match with id of user object
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590577 = newJObject()
  var query_590578 = newJObject()
  var body_590579 = newJObject()
  add(query_590578, "fields", newJString(fields))
  add(query_590578, "quotaUser", newJString(quotaUser))
  add(query_590578, "alt", newJString(alt))
  add(query_590578, "oauth_token", newJString(oauthToken))
  add(query_590578, "userIp", newJString(userIp))
  add(path_590577, "userKey", newJString(userKey))
  add(query_590578, "key", newJString(key))
  if body != nil:
    body_590579 = body
  add(query_590578, "prettyPrint", newJBool(prettyPrint))
  result = call_590576.call(path_590577, query_590578, nil, nil, body_590579)

var directoryUsersUpdate* = Call_DirectoryUsersUpdate_590563(
    name: "directoryUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersUpdate_590564, base: "/admin/directory/v1",
    url: url_DirectoryUsersUpdate_590565, schemes: {Scheme.Https})
type
  Call_DirectoryUsersGet_590545 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersGet_590547(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersGet_590546(path: JsonNode; query: JsonNode;
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
  var valid_590548 = path.getOrDefault("userKey")
  valid_590548 = validateParameter(valid_590548, JString, required = true,
                                 default = nil)
  if valid_590548 != nil:
    section.add "userKey", valid_590548
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
  ##   customFieldMask: JString
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : What subset of fields to fetch for this user.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   viewType: JString
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  section = newJObject()
  var valid_590549 = query.getOrDefault("fields")
  valid_590549 = validateParameter(valid_590549, JString, required = false,
                                 default = nil)
  if valid_590549 != nil:
    section.add "fields", valid_590549
  var valid_590550 = query.getOrDefault("quotaUser")
  valid_590550 = validateParameter(valid_590550, JString, required = false,
                                 default = nil)
  if valid_590550 != nil:
    section.add "quotaUser", valid_590550
  var valid_590551 = query.getOrDefault("alt")
  valid_590551 = validateParameter(valid_590551, JString, required = false,
                                 default = newJString("json"))
  if valid_590551 != nil:
    section.add "alt", valid_590551
  var valid_590552 = query.getOrDefault("oauth_token")
  valid_590552 = validateParameter(valid_590552, JString, required = false,
                                 default = nil)
  if valid_590552 != nil:
    section.add "oauth_token", valid_590552
  var valid_590553 = query.getOrDefault("userIp")
  valid_590553 = validateParameter(valid_590553, JString, required = false,
                                 default = nil)
  if valid_590553 != nil:
    section.add "userIp", valid_590553
  var valid_590554 = query.getOrDefault("customFieldMask")
  valid_590554 = validateParameter(valid_590554, JString, required = false,
                                 default = nil)
  if valid_590554 != nil:
    section.add "customFieldMask", valid_590554
  var valid_590555 = query.getOrDefault("key")
  valid_590555 = validateParameter(valid_590555, JString, required = false,
                                 default = nil)
  if valid_590555 != nil:
    section.add "key", valid_590555
  var valid_590556 = query.getOrDefault("projection")
  valid_590556 = validateParameter(valid_590556, JString, required = false,
                                 default = newJString("basic"))
  if valid_590556 != nil:
    section.add "projection", valid_590556
  var valid_590557 = query.getOrDefault("prettyPrint")
  valid_590557 = validateParameter(valid_590557, JBool, required = false,
                                 default = newJBool(true))
  if valid_590557 != nil:
    section.add "prettyPrint", valid_590557
  var valid_590558 = query.getOrDefault("viewType")
  valid_590558 = validateParameter(valid_590558, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_590558 != nil:
    section.add "viewType", valid_590558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590559: Call_DirectoryUsersGet_590545; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## retrieve user
  ## 
  let valid = call_590559.validator(path, query, header, formData, body)
  let scheme = call_590559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590559.url(scheme.get, call_590559.host, call_590559.base,
                         call_590559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590559, url, valid)

proc call*(call_590560: Call_DirectoryUsersGet_590545; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; customFieldMask: string = "";
          key: string = ""; projection: string = "basic"; prettyPrint: bool = true;
          viewType: string = "admin_view"): Recallable =
  ## directoryUsersGet
  ## retrieve user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   customFieldMask: string
  ##                  : Comma-separated list of schema names. All fields from these schemas are fetched. This should only be set when projection=custom.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : What subset of fields to fetch for this user.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   viewType: string
  ##           : Whether to fetch the ADMIN_VIEW or DOMAIN_PUBLIC view of the user.
  var path_590561 = newJObject()
  var query_590562 = newJObject()
  add(query_590562, "fields", newJString(fields))
  add(query_590562, "quotaUser", newJString(quotaUser))
  add(query_590562, "alt", newJString(alt))
  add(query_590562, "oauth_token", newJString(oauthToken))
  add(query_590562, "userIp", newJString(userIp))
  add(path_590561, "userKey", newJString(userKey))
  add(query_590562, "customFieldMask", newJString(customFieldMask))
  add(query_590562, "key", newJString(key))
  add(query_590562, "projection", newJString(projection))
  add(query_590562, "prettyPrint", newJBool(prettyPrint))
  add(query_590562, "viewType", newJString(viewType))
  result = call_590560.call(path_590561, query_590562, nil, nil, nil)

var directoryUsersGet* = Call_DirectoryUsersGet_590545(name: "directoryUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersGet_590546, base: "/admin/directory/v1",
    url: url_DirectoryUsersGet_590547, schemes: {Scheme.Https})
type
  Call_DirectoryUsersPatch_590595 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersPatch_590597(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersPatch_590596(path: JsonNode; query: JsonNode;
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
  var valid_590598 = path.getOrDefault("userKey")
  valid_590598 = validateParameter(valid_590598, JString, required = true,
                                 default = nil)
  if valid_590598 != nil:
    section.add "userKey", valid_590598
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
  var valid_590599 = query.getOrDefault("fields")
  valid_590599 = validateParameter(valid_590599, JString, required = false,
                                 default = nil)
  if valid_590599 != nil:
    section.add "fields", valid_590599
  var valid_590600 = query.getOrDefault("quotaUser")
  valid_590600 = validateParameter(valid_590600, JString, required = false,
                                 default = nil)
  if valid_590600 != nil:
    section.add "quotaUser", valid_590600
  var valid_590601 = query.getOrDefault("alt")
  valid_590601 = validateParameter(valid_590601, JString, required = false,
                                 default = newJString("json"))
  if valid_590601 != nil:
    section.add "alt", valid_590601
  var valid_590602 = query.getOrDefault("oauth_token")
  valid_590602 = validateParameter(valid_590602, JString, required = false,
                                 default = nil)
  if valid_590602 != nil:
    section.add "oauth_token", valid_590602
  var valid_590603 = query.getOrDefault("userIp")
  valid_590603 = validateParameter(valid_590603, JString, required = false,
                                 default = nil)
  if valid_590603 != nil:
    section.add "userIp", valid_590603
  var valid_590604 = query.getOrDefault("key")
  valid_590604 = validateParameter(valid_590604, JString, required = false,
                                 default = nil)
  if valid_590604 != nil:
    section.add "key", valid_590604
  var valid_590605 = query.getOrDefault("prettyPrint")
  valid_590605 = validateParameter(valid_590605, JBool, required = false,
                                 default = newJBool(true))
  if valid_590605 != nil:
    section.add "prettyPrint", valid_590605
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

proc call*(call_590607: Call_DirectoryUsersPatch_590595; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user. This method supports patch semantics.
  ## 
  let valid = call_590607.validator(path, query, header, formData, body)
  let scheme = call_590607.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590607.url(scheme.get, call_590607.host, call_590607.base,
                         call_590607.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590607, url, valid)

proc call*(call_590608: Call_DirectoryUsersPatch_590595; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryUsersPatch
  ## update user. This method supports patch semantics.
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user. If ID, it should match with id of user object
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590609 = newJObject()
  var query_590610 = newJObject()
  var body_590611 = newJObject()
  add(query_590610, "fields", newJString(fields))
  add(query_590610, "quotaUser", newJString(quotaUser))
  add(query_590610, "alt", newJString(alt))
  add(query_590610, "oauth_token", newJString(oauthToken))
  add(query_590610, "userIp", newJString(userIp))
  add(path_590609, "userKey", newJString(userKey))
  add(query_590610, "key", newJString(key))
  if body != nil:
    body_590611 = body
  add(query_590610, "prettyPrint", newJBool(prettyPrint))
  result = call_590608.call(path_590609, query_590610, nil, nil, body_590611)

var directoryUsersPatch* = Call_DirectoryUsersPatch_590595(
    name: "directoryUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersPatch_590596, base: "/admin/directory/v1",
    url: url_DirectoryUsersPatch_590597, schemes: {Scheme.Https})
type
  Call_DirectoryUsersDelete_590580 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersDelete_590582(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersDelete_590581(path: JsonNode; query: JsonNode;
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
  var valid_590583 = path.getOrDefault("userKey")
  valid_590583 = validateParameter(valid_590583, JString, required = true,
                                 default = nil)
  if valid_590583 != nil:
    section.add "userKey", valid_590583
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
  var valid_590584 = query.getOrDefault("fields")
  valid_590584 = validateParameter(valid_590584, JString, required = false,
                                 default = nil)
  if valid_590584 != nil:
    section.add "fields", valid_590584
  var valid_590585 = query.getOrDefault("quotaUser")
  valid_590585 = validateParameter(valid_590585, JString, required = false,
                                 default = nil)
  if valid_590585 != nil:
    section.add "quotaUser", valid_590585
  var valid_590586 = query.getOrDefault("alt")
  valid_590586 = validateParameter(valid_590586, JString, required = false,
                                 default = newJString("json"))
  if valid_590586 != nil:
    section.add "alt", valid_590586
  var valid_590587 = query.getOrDefault("oauth_token")
  valid_590587 = validateParameter(valid_590587, JString, required = false,
                                 default = nil)
  if valid_590587 != nil:
    section.add "oauth_token", valid_590587
  var valid_590588 = query.getOrDefault("userIp")
  valid_590588 = validateParameter(valid_590588, JString, required = false,
                                 default = nil)
  if valid_590588 != nil:
    section.add "userIp", valid_590588
  var valid_590589 = query.getOrDefault("key")
  valid_590589 = validateParameter(valid_590589, JString, required = false,
                                 default = nil)
  if valid_590589 != nil:
    section.add "key", valid_590589
  var valid_590590 = query.getOrDefault("prettyPrint")
  valid_590590 = validateParameter(valid_590590, JBool, required = false,
                                 default = newJBool(true))
  if valid_590590 != nil:
    section.add "prettyPrint", valid_590590
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590591: Call_DirectoryUsersDelete_590580; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user
  ## 
  let valid = call_590591.validator(path, query, header, formData, body)
  let scheme = call_590591.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590591.url(scheme.get, call_590591.host, call_590591.base,
                         call_590591.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590591, url, valid)

proc call*(call_590592: Call_DirectoryUsersDelete_590580; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryUsersDelete
  ## Delete user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590593 = newJObject()
  var query_590594 = newJObject()
  add(query_590594, "fields", newJString(fields))
  add(query_590594, "quotaUser", newJString(quotaUser))
  add(query_590594, "alt", newJString(alt))
  add(query_590594, "oauth_token", newJString(oauthToken))
  add(query_590594, "userIp", newJString(userIp))
  add(path_590593, "userKey", newJString(userKey))
  add(query_590594, "key", newJString(key))
  add(query_590594, "prettyPrint", newJBool(prettyPrint))
  result = call_590592.call(path_590593, query_590594, nil, nil, nil)

var directoryUsersDelete* = Call_DirectoryUsersDelete_590580(
    name: "directoryUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersDelete_590581, base: "/admin/directory/v1",
    url: url_DirectoryUsersDelete_590582, schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesInsert_590628 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersAliasesInsert_590630(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersAliasesInsert_590629(path: JsonNode; query: JsonNode;
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
  var valid_590631 = path.getOrDefault("userKey")
  valid_590631 = validateParameter(valid_590631, JString, required = true,
                                 default = nil)
  if valid_590631 != nil:
    section.add "userKey", valid_590631
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
  var valid_590632 = query.getOrDefault("fields")
  valid_590632 = validateParameter(valid_590632, JString, required = false,
                                 default = nil)
  if valid_590632 != nil:
    section.add "fields", valid_590632
  var valid_590633 = query.getOrDefault("quotaUser")
  valid_590633 = validateParameter(valid_590633, JString, required = false,
                                 default = nil)
  if valid_590633 != nil:
    section.add "quotaUser", valid_590633
  var valid_590634 = query.getOrDefault("alt")
  valid_590634 = validateParameter(valid_590634, JString, required = false,
                                 default = newJString("json"))
  if valid_590634 != nil:
    section.add "alt", valid_590634
  var valid_590635 = query.getOrDefault("oauth_token")
  valid_590635 = validateParameter(valid_590635, JString, required = false,
                                 default = nil)
  if valid_590635 != nil:
    section.add "oauth_token", valid_590635
  var valid_590636 = query.getOrDefault("userIp")
  valid_590636 = validateParameter(valid_590636, JString, required = false,
                                 default = nil)
  if valid_590636 != nil:
    section.add "userIp", valid_590636
  var valid_590637 = query.getOrDefault("key")
  valid_590637 = validateParameter(valid_590637, JString, required = false,
                                 default = nil)
  if valid_590637 != nil:
    section.add "key", valid_590637
  var valid_590638 = query.getOrDefault("prettyPrint")
  valid_590638 = validateParameter(valid_590638, JBool, required = false,
                                 default = newJBool(true))
  if valid_590638 != nil:
    section.add "prettyPrint", valid_590638
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

proc call*(call_590640: Call_DirectoryUsersAliasesInsert_590628; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the user
  ## 
  let valid = call_590640.validator(path, query, header, formData, body)
  let scheme = call_590640.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590640.url(scheme.get, call_590640.host, call_590640.base,
                         call_590640.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590640, url, valid)

proc call*(call_590641: Call_DirectoryUsersAliasesInsert_590628; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryUsersAliasesInsert
  ## Add a alias for the user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590642 = newJObject()
  var query_590643 = newJObject()
  var body_590644 = newJObject()
  add(query_590643, "fields", newJString(fields))
  add(query_590643, "quotaUser", newJString(quotaUser))
  add(query_590643, "alt", newJString(alt))
  add(query_590643, "oauth_token", newJString(oauthToken))
  add(query_590643, "userIp", newJString(userIp))
  add(path_590642, "userKey", newJString(userKey))
  add(query_590643, "key", newJString(key))
  if body != nil:
    body_590644 = body
  add(query_590643, "prettyPrint", newJBool(prettyPrint))
  result = call_590641.call(path_590642, query_590643, nil, nil, body_590644)

var directoryUsersAliasesInsert* = Call_DirectoryUsersAliasesInsert_590628(
    name: "directoryUsersAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesInsert_590629,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesInsert_590630,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesList_590612 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersAliasesList_590614(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersAliasesList_590613(path: JsonNode; query: JsonNode;
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
  var valid_590615 = path.getOrDefault("userKey")
  valid_590615 = validateParameter(valid_590615, JString, required = true,
                                 default = nil)
  if valid_590615 != nil:
    section.add "userKey", valid_590615
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   event: JString
  ##        : Event on which subscription is intended (if subscribing)
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
  var valid_590616 = query.getOrDefault("fields")
  valid_590616 = validateParameter(valid_590616, JString, required = false,
                                 default = nil)
  if valid_590616 != nil:
    section.add "fields", valid_590616
  var valid_590617 = query.getOrDefault("quotaUser")
  valid_590617 = validateParameter(valid_590617, JString, required = false,
                                 default = nil)
  if valid_590617 != nil:
    section.add "quotaUser", valid_590617
  var valid_590618 = query.getOrDefault("event")
  valid_590618 = validateParameter(valid_590618, JString, required = false,
                                 default = newJString("add"))
  if valid_590618 != nil:
    section.add "event", valid_590618
  var valid_590619 = query.getOrDefault("alt")
  valid_590619 = validateParameter(valid_590619, JString, required = false,
                                 default = newJString("json"))
  if valid_590619 != nil:
    section.add "alt", valid_590619
  var valid_590620 = query.getOrDefault("oauth_token")
  valid_590620 = validateParameter(valid_590620, JString, required = false,
                                 default = nil)
  if valid_590620 != nil:
    section.add "oauth_token", valid_590620
  var valid_590621 = query.getOrDefault("userIp")
  valid_590621 = validateParameter(valid_590621, JString, required = false,
                                 default = nil)
  if valid_590621 != nil:
    section.add "userIp", valid_590621
  var valid_590622 = query.getOrDefault("key")
  valid_590622 = validateParameter(valid_590622, JString, required = false,
                                 default = nil)
  if valid_590622 != nil:
    section.add "key", valid_590622
  var valid_590623 = query.getOrDefault("prettyPrint")
  valid_590623 = validateParameter(valid_590623, JBool, required = false,
                                 default = newJBool(true))
  if valid_590623 != nil:
    section.add "prettyPrint", valid_590623
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590624: Call_DirectoryUsersAliasesList_590612; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a user
  ## 
  let valid = call_590624.validator(path, query, header, formData, body)
  let scheme = call_590624.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590624.url(scheme.get, call_590624.host, call_590624.base,
                         call_590624.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590624, url, valid)

proc call*(call_590625: Call_DirectoryUsersAliasesList_590612; userKey: string;
          fields: string = ""; quotaUser: string = ""; event: string = "add";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryUsersAliasesList
  ## List all aliases for a user
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   event: string
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590626 = newJObject()
  var query_590627 = newJObject()
  add(query_590627, "fields", newJString(fields))
  add(query_590627, "quotaUser", newJString(quotaUser))
  add(query_590627, "event", newJString(event))
  add(query_590627, "alt", newJString(alt))
  add(query_590627, "oauth_token", newJString(oauthToken))
  add(query_590627, "userIp", newJString(userIp))
  add(path_590626, "userKey", newJString(userKey))
  add(query_590627, "key", newJString(key))
  add(query_590627, "prettyPrint", newJBool(prettyPrint))
  result = call_590625.call(path_590626, query_590627, nil, nil, nil)

var directoryUsersAliasesList* = Call_DirectoryUsersAliasesList_590612(
    name: "directoryUsersAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesList_590613,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesList_590614,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesWatch_590645 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersAliasesWatch_590647(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersAliasesWatch_590646(path: JsonNode; query: JsonNode;
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
  var valid_590648 = path.getOrDefault("userKey")
  valid_590648 = validateParameter(valid_590648, JString, required = true,
                                 default = nil)
  if valid_590648 != nil:
    section.add "userKey", valid_590648
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   event: JString
  ##        : Event on which subscription is intended (if subscribing)
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
  var valid_590649 = query.getOrDefault("fields")
  valid_590649 = validateParameter(valid_590649, JString, required = false,
                                 default = nil)
  if valid_590649 != nil:
    section.add "fields", valid_590649
  var valid_590650 = query.getOrDefault("quotaUser")
  valid_590650 = validateParameter(valid_590650, JString, required = false,
                                 default = nil)
  if valid_590650 != nil:
    section.add "quotaUser", valid_590650
  var valid_590651 = query.getOrDefault("event")
  valid_590651 = validateParameter(valid_590651, JString, required = false,
                                 default = newJString("add"))
  if valid_590651 != nil:
    section.add "event", valid_590651
  var valid_590652 = query.getOrDefault("alt")
  valid_590652 = validateParameter(valid_590652, JString, required = false,
                                 default = newJString("json"))
  if valid_590652 != nil:
    section.add "alt", valid_590652
  var valid_590653 = query.getOrDefault("oauth_token")
  valid_590653 = validateParameter(valid_590653, JString, required = false,
                                 default = nil)
  if valid_590653 != nil:
    section.add "oauth_token", valid_590653
  var valid_590654 = query.getOrDefault("userIp")
  valid_590654 = validateParameter(valid_590654, JString, required = false,
                                 default = nil)
  if valid_590654 != nil:
    section.add "userIp", valid_590654
  var valid_590655 = query.getOrDefault("key")
  valid_590655 = validateParameter(valid_590655, JString, required = false,
                                 default = nil)
  if valid_590655 != nil:
    section.add "key", valid_590655
  var valid_590656 = query.getOrDefault("prettyPrint")
  valid_590656 = validateParameter(valid_590656, JBool, required = false,
                                 default = newJBool(true))
  if valid_590656 != nil:
    section.add "prettyPrint", valid_590656
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

proc call*(call_590658: Call_DirectoryUsersAliasesWatch_590645; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in user aliases list
  ## 
  let valid = call_590658.validator(path, query, header, formData, body)
  let scheme = call_590658.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590658.url(scheme.get, call_590658.host, call_590658.base,
                         call_590658.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590658, url, valid)

proc call*(call_590659: Call_DirectoryUsersAliasesWatch_590645; userKey: string;
          fields: string = ""; quotaUser: string = ""; event: string = "add";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; resource: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryUsersAliasesWatch
  ## Watch for changes in user aliases list
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   event: string
  ##        : Event on which subscription is intended (if subscribing)
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590660 = newJObject()
  var query_590661 = newJObject()
  var body_590662 = newJObject()
  add(query_590661, "fields", newJString(fields))
  add(query_590661, "quotaUser", newJString(quotaUser))
  add(query_590661, "event", newJString(event))
  add(query_590661, "alt", newJString(alt))
  add(query_590661, "oauth_token", newJString(oauthToken))
  add(query_590661, "userIp", newJString(userIp))
  add(path_590660, "userKey", newJString(userKey))
  add(query_590661, "key", newJString(key))
  if resource != nil:
    body_590662 = resource
  add(query_590661, "prettyPrint", newJBool(prettyPrint))
  result = call_590659.call(path_590660, query_590661, nil, nil, body_590662)

var directoryUsersAliasesWatch* = Call_DirectoryUsersAliasesWatch_590645(
    name: "directoryUsersAliasesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/watch",
    validator: validate_DirectoryUsersAliasesWatch_590646,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesWatch_590647,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesDelete_590663 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersAliasesDelete_590665(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersAliasesDelete_590664(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Remove a alias for the user
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Email or immutable ID of the user
  ##   alias: JString (required)
  ##        : The alias to be removed
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_590666 = path.getOrDefault("userKey")
  valid_590666 = validateParameter(valid_590666, JString, required = true,
                                 default = nil)
  if valid_590666 != nil:
    section.add "userKey", valid_590666
  var valid_590667 = path.getOrDefault("alias")
  valid_590667 = validateParameter(valid_590667, JString, required = true,
                                 default = nil)
  if valid_590667 != nil:
    section.add "alias", valid_590667
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
  var valid_590668 = query.getOrDefault("fields")
  valid_590668 = validateParameter(valid_590668, JString, required = false,
                                 default = nil)
  if valid_590668 != nil:
    section.add "fields", valid_590668
  var valid_590669 = query.getOrDefault("quotaUser")
  valid_590669 = validateParameter(valid_590669, JString, required = false,
                                 default = nil)
  if valid_590669 != nil:
    section.add "quotaUser", valid_590669
  var valid_590670 = query.getOrDefault("alt")
  valid_590670 = validateParameter(valid_590670, JString, required = false,
                                 default = newJString("json"))
  if valid_590670 != nil:
    section.add "alt", valid_590670
  var valid_590671 = query.getOrDefault("oauth_token")
  valid_590671 = validateParameter(valid_590671, JString, required = false,
                                 default = nil)
  if valid_590671 != nil:
    section.add "oauth_token", valid_590671
  var valid_590672 = query.getOrDefault("userIp")
  valid_590672 = validateParameter(valid_590672, JString, required = false,
                                 default = nil)
  if valid_590672 != nil:
    section.add "userIp", valid_590672
  var valid_590673 = query.getOrDefault("key")
  valid_590673 = validateParameter(valid_590673, JString, required = false,
                                 default = nil)
  if valid_590673 != nil:
    section.add "key", valid_590673
  var valid_590674 = query.getOrDefault("prettyPrint")
  valid_590674 = validateParameter(valid_590674, JBool, required = false,
                                 default = newJBool(true))
  if valid_590674 != nil:
    section.add "prettyPrint", valid_590674
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590675: Call_DirectoryUsersAliasesDelete_590663; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the user
  ## 
  let valid = call_590675.validator(path, query, header, formData, body)
  let scheme = call_590675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590675.url(scheme.get, call_590675.host, call_590675.base,
                         call_590675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590675, url, valid)

proc call*(call_590676: Call_DirectoryUsersAliasesDelete_590663; userKey: string;
          alias: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryUsersAliasesDelete
  ## Remove a alias for the user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   alias: string (required)
  ##        : The alias to be removed
  var path_590677 = newJObject()
  var query_590678 = newJObject()
  add(query_590678, "fields", newJString(fields))
  add(query_590678, "quotaUser", newJString(quotaUser))
  add(query_590678, "alt", newJString(alt))
  add(query_590678, "oauth_token", newJString(oauthToken))
  add(query_590678, "userIp", newJString(userIp))
  add(path_590677, "userKey", newJString(userKey))
  add(query_590678, "key", newJString(key))
  add(query_590678, "prettyPrint", newJBool(prettyPrint))
  add(path_590677, "alias", newJString(alias))
  result = call_590676.call(path_590677, query_590678, nil, nil, nil)

var directoryUsersAliasesDelete* = Call_DirectoryUsersAliasesDelete_590663(
    name: "directoryUsersAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/{alias}",
    validator: validate_DirectoryUsersAliasesDelete_590664,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesDelete_590665,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsList_590679 = ref object of OpenApiRestCall_588466
proc url_DirectoryAspsList_590681(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryAspsList_590680(path: JsonNode; query: JsonNode;
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
  var valid_590682 = path.getOrDefault("userKey")
  valid_590682 = validateParameter(valid_590682, JString, required = true,
                                 default = nil)
  if valid_590682 != nil:
    section.add "userKey", valid_590682
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
  var valid_590683 = query.getOrDefault("fields")
  valid_590683 = validateParameter(valid_590683, JString, required = false,
                                 default = nil)
  if valid_590683 != nil:
    section.add "fields", valid_590683
  var valid_590684 = query.getOrDefault("quotaUser")
  valid_590684 = validateParameter(valid_590684, JString, required = false,
                                 default = nil)
  if valid_590684 != nil:
    section.add "quotaUser", valid_590684
  var valid_590685 = query.getOrDefault("alt")
  valid_590685 = validateParameter(valid_590685, JString, required = false,
                                 default = newJString("json"))
  if valid_590685 != nil:
    section.add "alt", valid_590685
  var valid_590686 = query.getOrDefault("oauth_token")
  valid_590686 = validateParameter(valid_590686, JString, required = false,
                                 default = nil)
  if valid_590686 != nil:
    section.add "oauth_token", valid_590686
  var valid_590687 = query.getOrDefault("userIp")
  valid_590687 = validateParameter(valid_590687, JString, required = false,
                                 default = nil)
  if valid_590687 != nil:
    section.add "userIp", valid_590687
  var valid_590688 = query.getOrDefault("key")
  valid_590688 = validateParameter(valid_590688, JString, required = false,
                                 default = nil)
  if valid_590688 != nil:
    section.add "key", valid_590688
  var valid_590689 = query.getOrDefault("prettyPrint")
  valid_590689 = validateParameter(valid_590689, JBool, required = false,
                                 default = newJBool(true))
  if valid_590689 != nil:
    section.add "prettyPrint", valid_590689
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590690: Call_DirectoryAspsList_590679; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the ASPs issued by a user.
  ## 
  let valid = call_590690.validator(path, query, header, formData, body)
  let scheme = call_590690.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590690.url(scheme.get, call_590690.host, call_590690.base,
                         call_590690.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590690, url, valid)

proc call*(call_590691: Call_DirectoryAspsList_590679; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryAspsList
  ## List the ASPs issued by a user.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590692 = newJObject()
  var query_590693 = newJObject()
  add(query_590693, "fields", newJString(fields))
  add(query_590693, "quotaUser", newJString(quotaUser))
  add(query_590693, "alt", newJString(alt))
  add(query_590693, "oauth_token", newJString(oauthToken))
  add(query_590693, "userIp", newJString(userIp))
  add(path_590692, "userKey", newJString(userKey))
  add(query_590693, "key", newJString(key))
  add(query_590693, "prettyPrint", newJBool(prettyPrint))
  result = call_590691.call(path_590692, query_590693, nil, nil, nil)

var directoryAspsList* = Call_DirectoryAspsList_590679(name: "directoryAspsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps", validator: validate_DirectoryAspsList_590680,
    base: "/admin/directory/v1", url: url_DirectoryAspsList_590681,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsGet_590694 = ref object of OpenApiRestCall_588466
proc url_DirectoryAspsGet_590696(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryAspsGet_590695(path: JsonNode; query: JsonNode;
                                     header: JsonNode; formData: JsonNode;
                                     body: JsonNode): JsonNode =
  ## Get information about an ASP issued by a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   codeId: JInt (required)
  ##         : The unique ID of the ASP.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_590697 = path.getOrDefault("userKey")
  valid_590697 = validateParameter(valid_590697, JString, required = true,
                                 default = nil)
  if valid_590697 != nil:
    section.add "userKey", valid_590697
  var valid_590698 = path.getOrDefault("codeId")
  valid_590698 = validateParameter(valid_590698, JInt, required = true, default = nil)
  if valid_590698 != nil:
    section.add "codeId", valid_590698
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
  var valid_590699 = query.getOrDefault("fields")
  valid_590699 = validateParameter(valid_590699, JString, required = false,
                                 default = nil)
  if valid_590699 != nil:
    section.add "fields", valid_590699
  var valid_590700 = query.getOrDefault("quotaUser")
  valid_590700 = validateParameter(valid_590700, JString, required = false,
                                 default = nil)
  if valid_590700 != nil:
    section.add "quotaUser", valid_590700
  var valid_590701 = query.getOrDefault("alt")
  valid_590701 = validateParameter(valid_590701, JString, required = false,
                                 default = newJString("json"))
  if valid_590701 != nil:
    section.add "alt", valid_590701
  var valid_590702 = query.getOrDefault("oauth_token")
  valid_590702 = validateParameter(valid_590702, JString, required = false,
                                 default = nil)
  if valid_590702 != nil:
    section.add "oauth_token", valid_590702
  var valid_590703 = query.getOrDefault("userIp")
  valid_590703 = validateParameter(valid_590703, JString, required = false,
                                 default = nil)
  if valid_590703 != nil:
    section.add "userIp", valid_590703
  var valid_590704 = query.getOrDefault("key")
  valid_590704 = validateParameter(valid_590704, JString, required = false,
                                 default = nil)
  if valid_590704 != nil:
    section.add "key", valid_590704
  var valid_590705 = query.getOrDefault("prettyPrint")
  valid_590705 = validateParameter(valid_590705, JBool, required = false,
                                 default = newJBool(true))
  if valid_590705 != nil:
    section.add "prettyPrint", valid_590705
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590706: Call_DirectoryAspsGet_590694; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an ASP issued by a user.
  ## 
  let valid = call_590706.validator(path, query, header, formData, body)
  let scheme = call_590706.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590706.url(scheme.get, call_590706.host, call_590706.base,
                         call_590706.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590706, url, valid)

proc call*(call_590707: Call_DirectoryAspsGet_590694; userKey: string; codeId: int;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryAspsGet
  ## Get information about an ASP issued by a user.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   codeId: int (required)
  ##         : The unique ID of the ASP.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590708 = newJObject()
  var query_590709 = newJObject()
  add(query_590709, "fields", newJString(fields))
  add(query_590709, "quotaUser", newJString(quotaUser))
  add(query_590709, "alt", newJString(alt))
  add(query_590709, "oauth_token", newJString(oauthToken))
  add(query_590709, "userIp", newJString(userIp))
  add(path_590708, "userKey", newJString(userKey))
  add(query_590709, "key", newJString(key))
  add(path_590708, "codeId", newJInt(codeId))
  add(query_590709, "prettyPrint", newJBool(prettyPrint))
  result = call_590707.call(path_590708, query_590709, nil, nil, nil)

var directoryAspsGet* = Call_DirectoryAspsGet_590694(name: "directoryAspsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps/{codeId}", validator: validate_DirectoryAspsGet_590695,
    base: "/admin/directory/v1", url: url_DirectoryAspsGet_590696,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsDelete_590710 = ref object of OpenApiRestCall_588466
proc url_DirectoryAspsDelete_590712(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryAspsDelete_590711(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Delete an ASP issued by a user.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   userKey: JString (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   codeId: JInt (required)
  ##         : The unique ID of the ASP to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `userKey` field"
  var valid_590713 = path.getOrDefault("userKey")
  valid_590713 = validateParameter(valid_590713, JString, required = true,
                                 default = nil)
  if valid_590713 != nil:
    section.add "userKey", valid_590713
  var valid_590714 = path.getOrDefault("codeId")
  valid_590714 = validateParameter(valid_590714, JInt, required = true, default = nil)
  if valid_590714 != nil:
    section.add "codeId", valid_590714
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
  var valid_590715 = query.getOrDefault("fields")
  valid_590715 = validateParameter(valid_590715, JString, required = false,
                                 default = nil)
  if valid_590715 != nil:
    section.add "fields", valid_590715
  var valid_590716 = query.getOrDefault("quotaUser")
  valid_590716 = validateParameter(valid_590716, JString, required = false,
                                 default = nil)
  if valid_590716 != nil:
    section.add "quotaUser", valid_590716
  var valid_590717 = query.getOrDefault("alt")
  valid_590717 = validateParameter(valid_590717, JString, required = false,
                                 default = newJString("json"))
  if valid_590717 != nil:
    section.add "alt", valid_590717
  var valid_590718 = query.getOrDefault("oauth_token")
  valid_590718 = validateParameter(valid_590718, JString, required = false,
                                 default = nil)
  if valid_590718 != nil:
    section.add "oauth_token", valid_590718
  var valid_590719 = query.getOrDefault("userIp")
  valid_590719 = validateParameter(valid_590719, JString, required = false,
                                 default = nil)
  if valid_590719 != nil:
    section.add "userIp", valid_590719
  var valid_590720 = query.getOrDefault("key")
  valid_590720 = validateParameter(valid_590720, JString, required = false,
                                 default = nil)
  if valid_590720 != nil:
    section.add "key", valid_590720
  var valid_590721 = query.getOrDefault("prettyPrint")
  valid_590721 = validateParameter(valid_590721, JBool, required = false,
                                 default = newJBool(true))
  if valid_590721 != nil:
    section.add "prettyPrint", valid_590721
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590722: Call_DirectoryAspsDelete_590710; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an ASP issued by a user.
  ## 
  let valid = call_590722.validator(path, query, header, formData, body)
  let scheme = call_590722.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590722.url(scheme.get, call_590722.host, call_590722.base,
                         call_590722.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590722, url, valid)

proc call*(call_590723: Call_DirectoryAspsDelete_590710; userKey: string;
          codeId: int; fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryAspsDelete
  ## Delete an ASP issued by a user.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   codeId: int (required)
  ##         : The unique ID of the ASP to be deleted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590724 = newJObject()
  var query_590725 = newJObject()
  add(query_590725, "fields", newJString(fields))
  add(query_590725, "quotaUser", newJString(quotaUser))
  add(query_590725, "alt", newJString(alt))
  add(query_590725, "oauth_token", newJString(oauthToken))
  add(query_590725, "userIp", newJString(userIp))
  add(path_590724, "userKey", newJString(userKey))
  add(query_590725, "key", newJString(key))
  add(path_590724, "codeId", newJInt(codeId))
  add(query_590725, "prettyPrint", newJBool(prettyPrint))
  result = call_590723.call(path_590724, query_590725, nil, nil, nil)

var directoryAspsDelete* = Call_DirectoryAspsDelete_590710(
    name: "directoryAspsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/asps/{codeId}",
    validator: validate_DirectoryAspsDelete_590711, base: "/admin/directory/v1",
    url: url_DirectoryAspsDelete_590712, schemes: {Scheme.Https})
type
  Call_DirectoryUsersMakeAdmin_590726 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersMakeAdmin_590728(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersMakeAdmin_590727(path: JsonNode; query: JsonNode;
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
  var valid_590729 = path.getOrDefault("userKey")
  valid_590729 = validateParameter(valid_590729, JString, required = true,
                                 default = nil)
  if valid_590729 != nil:
    section.add "userKey", valid_590729
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
  var valid_590730 = query.getOrDefault("fields")
  valid_590730 = validateParameter(valid_590730, JString, required = false,
                                 default = nil)
  if valid_590730 != nil:
    section.add "fields", valid_590730
  var valid_590731 = query.getOrDefault("quotaUser")
  valid_590731 = validateParameter(valid_590731, JString, required = false,
                                 default = nil)
  if valid_590731 != nil:
    section.add "quotaUser", valid_590731
  var valid_590732 = query.getOrDefault("alt")
  valid_590732 = validateParameter(valid_590732, JString, required = false,
                                 default = newJString("json"))
  if valid_590732 != nil:
    section.add "alt", valid_590732
  var valid_590733 = query.getOrDefault("oauth_token")
  valid_590733 = validateParameter(valid_590733, JString, required = false,
                                 default = nil)
  if valid_590733 != nil:
    section.add "oauth_token", valid_590733
  var valid_590734 = query.getOrDefault("userIp")
  valid_590734 = validateParameter(valid_590734, JString, required = false,
                                 default = nil)
  if valid_590734 != nil:
    section.add "userIp", valid_590734
  var valid_590735 = query.getOrDefault("key")
  valid_590735 = validateParameter(valid_590735, JString, required = false,
                                 default = nil)
  if valid_590735 != nil:
    section.add "key", valid_590735
  var valid_590736 = query.getOrDefault("prettyPrint")
  valid_590736 = validateParameter(valid_590736, JBool, required = false,
                                 default = newJBool(true))
  if valid_590736 != nil:
    section.add "prettyPrint", valid_590736
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

proc call*(call_590738: Call_DirectoryUsersMakeAdmin_590726; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## change admin status of a user
  ## 
  let valid = call_590738.validator(path, query, header, formData, body)
  let scheme = call_590738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590738.url(scheme.get, call_590738.host, call_590738.base,
                         call_590738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590738, url, valid)

proc call*(call_590739: Call_DirectoryUsersMakeAdmin_590726; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryUsersMakeAdmin
  ## change admin status of a user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user as admin
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590740 = newJObject()
  var query_590741 = newJObject()
  var body_590742 = newJObject()
  add(query_590741, "fields", newJString(fields))
  add(query_590741, "quotaUser", newJString(quotaUser))
  add(query_590741, "alt", newJString(alt))
  add(query_590741, "oauth_token", newJString(oauthToken))
  add(query_590741, "userIp", newJString(userIp))
  add(path_590740, "userKey", newJString(userKey))
  add(query_590741, "key", newJString(key))
  if body != nil:
    body_590742 = body
  add(query_590741, "prettyPrint", newJBool(prettyPrint))
  result = call_590739.call(path_590740, query_590741, nil, nil, body_590742)

var directoryUsersMakeAdmin* = Call_DirectoryUsersMakeAdmin_590726(
    name: "directoryUsersMakeAdmin", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/makeAdmin",
    validator: validate_DirectoryUsersMakeAdmin_590727,
    base: "/admin/directory/v1", url: url_DirectoryUsersMakeAdmin_590728,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosUpdate_590758 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersPhotosUpdate_590760(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersPhotosUpdate_590759(path: JsonNode; query: JsonNode;
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
  var valid_590761 = path.getOrDefault("userKey")
  valid_590761 = validateParameter(valid_590761, JString, required = true,
                                 default = nil)
  if valid_590761 != nil:
    section.add "userKey", valid_590761
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
  var valid_590762 = query.getOrDefault("fields")
  valid_590762 = validateParameter(valid_590762, JString, required = false,
                                 default = nil)
  if valid_590762 != nil:
    section.add "fields", valid_590762
  var valid_590763 = query.getOrDefault("quotaUser")
  valid_590763 = validateParameter(valid_590763, JString, required = false,
                                 default = nil)
  if valid_590763 != nil:
    section.add "quotaUser", valid_590763
  var valid_590764 = query.getOrDefault("alt")
  valid_590764 = validateParameter(valid_590764, JString, required = false,
                                 default = newJString("json"))
  if valid_590764 != nil:
    section.add "alt", valid_590764
  var valid_590765 = query.getOrDefault("oauth_token")
  valid_590765 = validateParameter(valid_590765, JString, required = false,
                                 default = nil)
  if valid_590765 != nil:
    section.add "oauth_token", valid_590765
  var valid_590766 = query.getOrDefault("userIp")
  valid_590766 = validateParameter(valid_590766, JString, required = false,
                                 default = nil)
  if valid_590766 != nil:
    section.add "userIp", valid_590766
  var valid_590767 = query.getOrDefault("key")
  valid_590767 = validateParameter(valid_590767, JString, required = false,
                                 default = nil)
  if valid_590767 != nil:
    section.add "key", valid_590767
  var valid_590768 = query.getOrDefault("prettyPrint")
  valid_590768 = validateParameter(valid_590768, JBool, required = false,
                                 default = newJBool(true))
  if valid_590768 != nil:
    section.add "prettyPrint", valid_590768
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

proc call*(call_590770: Call_DirectoryUsersPhotosUpdate_590758; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user
  ## 
  let valid = call_590770.validator(path, query, header, formData, body)
  let scheme = call_590770.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590770.url(scheme.get, call_590770.host, call_590770.base,
                         call_590770.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590770, url, valid)

proc call*(call_590771: Call_DirectoryUsersPhotosUpdate_590758; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryUsersPhotosUpdate
  ## Add a photo for the user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590772 = newJObject()
  var query_590773 = newJObject()
  var body_590774 = newJObject()
  add(query_590773, "fields", newJString(fields))
  add(query_590773, "quotaUser", newJString(quotaUser))
  add(query_590773, "alt", newJString(alt))
  add(query_590773, "oauth_token", newJString(oauthToken))
  add(query_590773, "userIp", newJString(userIp))
  add(path_590772, "userKey", newJString(userKey))
  add(query_590773, "key", newJString(key))
  if body != nil:
    body_590774 = body
  add(query_590773, "prettyPrint", newJBool(prettyPrint))
  result = call_590771.call(path_590772, query_590773, nil, nil, body_590774)

var directoryUsersPhotosUpdate* = Call_DirectoryUsersPhotosUpdate_590758(
    name: "directoryUsersPhotosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosUpdate_590759,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosUpdate_590760,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosGet_590743 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersPhotosGet_590745(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersPhotosGet_590744(path: JsonNode; query: JsonNode;
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
  var valid_590746 = path.getOrDefault("userKey")
  valid_590746 = validateParameter(valid_590746, JString, required = true,
                                 default = nil)
  if valid_590746 != nil:
    section.add "userKey", valid_590746
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
  var valid_590747 = query.getOrDefault("fields")
  valid_590747 = validateParameter(valid_590747, JString, required = false,
                                 default = nil)
  if valid_590747 != nil:
    section.add "fields", valid_590747
  var valid_590748 = query.getOrDefault("quotaUser")
  valid_590748 = validateParameter(valid_590748, JString, required = false,
                                 default = nil)
  if valid_590748 != nil:
    section.add "quotaUser", valid_590748
  var valid_590749 = query.getOrDefault("alt")
  valid_590749 = validateParameter(valid_590749, JString, required = false,
                                 default = newJString("json"))
  if valid_590749 != nil:
    section.add "alt", valid_590749
  var valid_590750 = query.getOrDefault("oauth_token")
  valid_590750 = validateParameter(valid_590750, JString, required = false,
                                 default = nil)
  if valid_590750 != nil:
    section.add "oauth_token", valid_590750
  var valid_590751 = query.getOrDefault("userIp")
  valid_590751 = validateParameter(valid_590751, JString, required = false,
                                 default = nil)
  if valid_590751 != nil:
    section.add "userIp", valid_590751
  var valid_590752 = query.getOrDefault("key")
  valid_590752 = validateParameter(valid_590752, JString, required = false,
                                 default = nil)
  if valid_590752 != nil:
    section.add "key", valid_590752
  var valid_590753 = query.getOrDefault("prettyPrint")
  valid_590753 = validateParameter(valid_590753, JBool, required = false,
                                 default = newJBool(true))
  if valid_590753 != nil:
    section.add "prettyPrint", valid_590753
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590754: Call_DirectoryUsersPhotosGet_590743; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve photo of a user
  ## 
  let valid = call_590754.validator(path, query, header, formData, body)
  let scheme = call_590754.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590754.url(scheme.get, call_590754.host, call_590754.base,
                         call_590754.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590754, url, valid)

proc call*(call_590755: Call_DirectoryUsersPhotosGet_590743; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryUsersPhotosGet
  ## Retrieve photo of a user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590756 = newJObject()
  var query_590757 = newJObject()
  add(query_590757, "fields", newJString(fields))
  add(query_590757, "quotaUser", newJString(quotaUser))
  add(query_590757, "alt", newJString(alt))
  add(query_590757, "oauth_token", newJString(oauthToken))
  add(query_590757, "userIp", newJString(userIp))
  add(path_590756, "userKey", newJString(userKey))
  add(query_590757, "key", newJString(key))
  add(query_590757, "prettyPrint", newJBool(prettyPrint))
  result = call_590755.call(path_590756, query_590757, nil, nil, nil)

var directoryUsersPhotosGet* = Call_DirectoryUsersPhotosGet_590743(
    name: "directoryUsersPhotosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosGet_590744,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosGet_590745,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosPatch_590790 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersPhotosPatch_590792(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersPhotosPatch_590791(path: JsonNode; query: JsonNode;
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
  var valid_590793 = path.getOrDefault("userKey")
  valid_590793 = validateParameter(valid_590793, JString, required = true,
                                 default = nil)
  if valid_590793 != nil:
    section.add "userKey", valid_590793
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
  var valid_590794 = query.getOrDefault("fields")
  valid_590794 = validateParameter(valid_590794, JString, required = false,
                                 default = nil)
  if valid_590794 != nil:
    section.add "fields", valid_590794
  var valid_590795 = query.getOrDefault("quotaUser")
  valid_590795 = validateParameter(valid_590795, JString, required = false,
                                 default = nil)
  if valid_590795 != nil:
    section.add "quotaUser", valid_590795
  var valid_590796 = query.getOrDefault("alt")
  valid_590796 = validateParameter(valid_590796, JString, required = false,
                                 default = newJString("json"))
  if valid_590796 != nil:
    section.add "alt", valid_590796
  var valid_590797 = query.getOrDefault("oauth_token")
  valid_590797 = validateParameter(valid_590797, JString, required = false,
                                 default = nil)
  if valid_590797 != nil:
    section.add "oauth_token", valid_590797
  var valid_590798 = query.getOrDefault("userIp")
  valid_590798 = validateParameter(valid_590798, JString, required = false,
                                 default = nil)
  if valid_590798 != nil:
    section.add "userIp", valid_590798
  var valid_590799 = query.getOrDefault("key")
  valid_590799 = validateParameter(valid_590799, JString, required = false,
                                 default = nil)
  if valid_590799 != nil:
    section.add "key", valid_590799
  var valid_590800 = query.getOrDefault("prettyPrint")
  valid_590800 = validateParameter(valid_590800, JBool, required = false,
                                 default = newJBool(true))
  if valid_590800 != nil:
    section.add "prettyPrint", valid_590800
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

proc call*(call_590802: Call_DirectoryUsersPhotosPatch_590790; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user. This method supports patch semantics.
  ## 
  let valid = call_590802.validator(path, query, header, formData, body)
  let scheme = call_590802.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590802.url(scheme.get, call_590802.host, call_590802.base,
                         call_590802.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590802, url, valid)

proc call*(call_590803: Call_DirectoryUsersPhotosPatch_590790; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryUsersPhotosPatch
  ## Add a photo for the user. This method supports patch semantics.
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590804 = newJObject()
  var query_590805 = newJObject()
  var body_590806 = newJObject()
  add(query_590805, "fields", newJString(fields))
  add(query_590805, "quotaUser", newJString(quotaUser))
  add(query_590805, "alt", newJString(alt))
  add(query_590805, "oauth_token", newJString(oauthToken))
  add(query_590805, "userIp", newJString(userIp))
  add(path_590804, "userKey", newJString(userKey))
  add(query_590805, "key", newJString(key))
  if body != nil:
    body_590806 = body
  add(query_590805, "prettyPrint", newJBool(prettyPrint))
  result = call_590803.call(path_590804, query_590805, nil, nil, body_590806)

var directoryUsersPhotosPatch* = Call_DirectoryUsersPhotosPatch_590790(
    name: "directoryUsersPhotosPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosPatch_590791,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosPatch_590792,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosDelete_590775 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersPhotosDelete_590777(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersPhotosDelete_590776(path: JsonNode; query: JsonNode;
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
  var valid_590778 = path.getOrDefault("userKey")
  valid_590778 = validateParameter(valid_590778, JString, required = true,
                                 default = nil)
  if valid_590778 != nil:
    section.add "userKey", valid_590778
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
  var valid_590779 = query.getOrDefault("fields")
  valid_590779 = validateParameter(valid_590779, JString, required = false,
                                 default = nil)
  if valid_590779 != nil:
    section.add "fields", valid_590779
  var valid_590780 = query.getOrDefault("quotaUser")
  valid_590780 = validateParameter(valid_590780, JString, required = false,
                                 default = nil)
  if valid_590780 != nil:
    section.add "quotaUser", valid_590780
  var valid_590781 = query.getOrDefault("alt")
  valid_590781 = validateParameter(valid_590781, JString, required = false,
                                 default = newJString("json"))
  if valid_590781 != nil:
    section.add "alt", valid_590781
  var valid_590782 = query.getOrDefault("oauth_token")
  valid_590782 = validateParameter(valid_590782, JString, required = false,
                                 default = nil)
  if valid_590782 != nil:
    section.add "oauth_token", valid_590782
  var valid_590783 = query.getOrDefault("userIp")
  valid_590783 = validateParameter(valid_590783, JString, required = false,
                                 default = nil)
  if valid_590783 != nil:
    section.add "userIp", valid_590783
  var valid_590784 = query.getOrDefault("key")
  valid_590784 = validateParameter(valid_590784, JString, required = false,
                                 default = nil)
  if valid_590784 != nil:
    section.add "key", valid_590784
  var valid_590785 = query.getOrDefault("prettyPrint")
  valid_590785 = validateParameter(valid_590785, JBool, required = false,
                                 default = newJBool(true))
  if valid_590785 != nil:
    section.add "prettyPrint", valid_590785
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590786: Call_DirectoryUsersPhotosDelete_590775; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove photos for the user
  ## 
  let valid = call_590786.validator(path, query, header, formData, body)
  let scheme = call_590786.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590786.url(scheme.get, call_590786.host, call_590786.base,
                         call_590786.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590786, url, valid)

proc call*(call_590787: Call_DirectoryUsersPhotosDelete_590775; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryUsersPhotosDelete
  ## Remove photos for the user
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590788 = newJObject()
  var query_590789 = newJObject()
  add(query_590789, "fields", newJString(fields))
  add(query_590789, "quotaUser", newJString(quotaUser))
  add(query_590789, "alt", newJString(alt))
  add(query_590789, "oauth_token", newJString(oauthToken))
  add(query_590789, "userIp", newJString(userIp))
  add(path_590788, "userKey", newJString(userKey))
  add(query_590789, "key", newJString(key))
  add(query_590789, "prettyPrint", newJBool(prettyPrint))
  result = call_590787.call(path_590788, query_590789, nil, nil, nil)

var directoryUsersPhotosDelete* = Call_DirectoryUsersPhotosDelete_590775(
    name: "directoryUsersPhotosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosDelete_590776,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosDelete_590777,
    schemes: {Scheme.Https})
type
  Call_DirectoryTokensList_590807 = ref object of OpenApiRestCall_588466
proc url_DirectoryTokensList_590809(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryTokensList_590808(path: JsonNode; query: JsonNode;
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
  var valid_590810 = path.getOrDefault("userKey")
  valid_590810 = validateParameter(valid_590810, JString, required = true,
                                 default = nil)
  if valid_590810 != nil:
    section.add "userKey", valid_590810
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
  var valid_590811 = query.getOrDefault("fields")
  valid_590811 = validateParameter(valid_590811, JString, required = false,
                                 default = nil)
  if valid_590811 != nil:
    section.add "fields", valid_590811
  var valid_590812 = query.getOrDefault("quotaUser")
  valid_590812 = validateParameter(valid_590812, JString, required = false,
                                 default = nil)
  if valid_590812 != nil:
    section.add "quotaUser", valid_590812
  var valid_590813 = query.getOrDefault("alt")
  valid_590813 = validateParameter(valid_590813, JString, required = false,
                                 default = newJString("json"))
  if valid_590813 != nil:
    section.add "alt", valid_590813
  var valid_590814 = query.getOrDefault("oauth_token")
  valid_590814 = validateParameter(valid_590814, JString, required = false,
                                 default = nil)
  if valid_590814 != nil:
    section.add "oauth_token", valid_590814
  var valid_590815 = query.getOrDefault("userIp")
  valid_590815 = validateParameter(valid_590815, JString, required = false,
                                 default = nil)
  if valid_590815 != nil:
    section.add "userIp", valid_590815
  var valid_590816 = query.getOrDefault("key")
  valid_590816 = validateParameter(valid_590816, JString, required = false,
                                 default = nil)
  if valid_590816 != nil:
    section.add "key", valid_590816
  var valid_590817 = query.getOrDefault("prettyPrint")
  valid_590817 = validateParameter(valid_590817, JBool, required = false,
                                 default = newJBool(true))
  if valid_590817 != nil:
    section.add "prettyPrint", valid_590817
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590818: Call_DirectoryTokensList_590807; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the set of tokens specified user has issued to 3rd party applications.
  ## 
  let valid = call_590818.validator(path, query, header, formData, body)
  let scheme = call_590818.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590818.url(scheme.get, call_590818.host, call_590818.base,
                         call_590818.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590818, url, valid)

proc call*(call_590819: Call_DirectoryTokensList_590807; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## directoryTokensList
  ## Returns the set of tokens specified user has issued to 3rd party applications.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590820 = newJObject()
  var query_590821 = newJObject()
  add(query_590821, "fields", newJString(fields))
  add(query_590821, "quotaUser", newJString(quotaUser))
  add(query_590821, "alt", newJString(alt))
  add(query_590821, "oauth_token", newJString(oauthToken))
  add(query_590821, "userIp", newJString(userIp))
  add(path_590820, "userKey", newJString(userKey))
  add(query_590821, "key", newJString(key))
  add(query_590821, "prettyPrint", newJBool(prettyPrint))
  result = call_590819.call(path_590820, query_590821, nil, nil, nil)

var directoryTokensList* = Call_DirectoryTokensList_590807(
    name: "directoryTokensList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens",
    validator: validate_DirectoryTokensList_590808, base: "/admin/directory/v1",
    url: url_DirectoryTokensList_590809, schemes: {Scheme.Https})
type
  Call_DirectoryTokensGet_590822 = ref object of OpenApiRestCall_588466
proc url_DirectoryTokensGet_590824(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryTokensGet_590823(path: JsonNode; query: JsonNode;
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
  var valid_590825 = path.getOrDefault("clientId")
  valid_590825 = validateParameter(valid_590825, JString, required = true,
                                 default = nil)
  if valid_590825 != nil:
    section.add "clientId", valid_590825
  var valid_590826 = path.getOrDefault("userKey")
  valid_590826 = validateParameter(valid_590826, JString, required = true,
                                 default = nil)
  if valid_590826 != nil:
    section.add "userKey", valid_590826
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
  var valid_590827 = query.getOrDefault("fields")
  valid_590827 = validateParameter(valid_590827, JString, required = false,
                                 default = nil)
  if valid_590827 != nil:
    section.add "fields", valid_590827
  var valid_590828 = query.getOrDefault("quotaUser")
  valid_590828 = validateParameter(valid_590828, JString, required = false,
                                 default = nil)
  if valid_590828 != nil:
    section.add "quotaUser", valid_590828
  var valid_590829 = query.getOrDefault("alt")
  valid_590829 = validateParameter(valid_590829, JString, required = false,
                                 default = newJString("json"))
  if valid_590829 != nil:
    section.add "alt", valid_590829
  var valid_590830 = query.getOrDefault("oauth_token")
  valid_590830 = validateParameter(valid_590830, JString, required = false,
                                 default = nil)
  if valid_590830 != nil:
    section.add "oauth_token", valid_590830
  var valid_590831 = query.getOrDefault("userIp")
  valid_590831 = validateParameter(valid_590831, JString, required = false,
                                 default = nil)
  if valid_590831 != nil:
    section.add "userIp", valid_590831
  var valid_590832 = query.getOrDefault("key")
  valid_590832 = validateParameter(valid_590832, JString, required = false,
                                 default = nil)
  if valid_590832 != nil:
    section.add "key", valid_590832
  var valid_590833 = query.getOrDefault("prettyPrint")
  valid_590833 = validateParameter(valid_590833, JBool, required = false,
                                 default = newJBool(true))
  if valid_590833 != nil:
    section.add "prettyPrint", valid_590833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590834: Call_DirectoryTokensGet_590822; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an access token issued by a user.
  ## 
  let valid = call_590834.validator(path, query, header, formData, body)
  let scheme = call_590834.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590834.url(scheme.get, call_590834.host, call_590834.base,
                         call_590834.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590834, url, valid)

proc call*(call_590835: Call_DirectoryTokensGet_590822; clientId: string;
          userKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryTokensGet
  ## Get information about an access token issued by a user.
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
  ##   clientId: string (required)
  ##           : The Client ID of the application the token is issued to.
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590836 = newJObject()
  var query_590837 = newJObject()
  add(query_590837, "fields", newJString(fields))
  add(query_590837, "quotaUser", newJString(quotaUser))
  add(query_590837, "alt", newJString(alt))
  add(query_590837, "oauth_token", newJString(oauthToken))
  add(query_590837, "userIp", newJString(userIp))
  add(path_590836, "clientId", newJString(clientId))
  add(path_590836, "userKey", newJString(userKey))
  add(query_590837, "key", newJString(key))
  add(query_590837, "prettyPrint", newJBool(prettyPrint))
  result = call_590835.call(path_590836, query_590837, nil, nil, nil)

var directoryTokensGet* = Call_DirectoryTokensGet_590822(
    name: "directoryTokensGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensGet_590823, base: "/admin/directory/v1",
    url: url_DirectoryTokensGet_590824, schemes: {Scheme.Https})
type
  Call_DirectoryTokensDelete_590838 = ref object of OpenApiRestCall_588466
proc url_DirectoryTokensDelete_590840(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryTokensDelete_590839(path: JsonNode; query: JsonNode;
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
  var valid_590841 = path.getOrDefault("clientId")
  valid_590841 = validateParameter(valid_590841, JString, required = true,
                                 default = nil)
  if valid_590841 != nil:
    section.add "clientId", valid_590841
  var valid_590842 = path.getOrDefault("userKey")
  valid_590842 = validateParameter(valid_590842, JString, required = true,
                                 default = nil)
  if valid_590842 != nil:
    section.add "userKey", valid_590842
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
  var valid_590843 = query.getOrDefault("fields")
  valid_590843 = validateParameter(valid_590843, JString, required = false,
                                 default = nil)
  if valid_590843 != nil:
    section.add "fields", valid_590843
  var valid_590844 = query.getOrDefault("quotaUser")
  valid_590844 = validateParameter(valid_590844, JString, required = false,
                                 default = nil)
  if valid_590844 != nil:
    section.add "quotaUser", valid_590844
  var valid_590845 = query.getOrDefault("alt")
  valid_590845 = validateParameter(valid_590845, JString, required = false,
                                 default = newJString("json"))
  if valid_590845 != nil:
    section.add "alt", valid_590845
  var valid_590846 = query.getOrDefault("oauth_token")
  valid_590846 = validateParameter(valid_590846, JString, required = false,
                                 default = nil)
  if valid_590846 != nil:
    section.add "oauth_token", valid_590846
  var valid_590847 = query.getOrDefault("userIp")
  valid_590847 = validateParameter(valid_590847, JString, required = false,
                                 default = nil)
  if valid_590847 != nil:
    section.add "userIp", valid_590847
  var valid_590848 = query.getOrDefault("key")
  valid_590848 = validateParameter(valid_590848, JString, required = false,
                                 default = nil)
  if valid_590848 != nil:
    section.add "key", valid_590848
  var valid_590849 = query.getOrDefault("prettyPrint")
  valid_590849 = validateParameter(valid_590849, JBool, required = false,
                                 default = newJBool(true))
  if valid_590849 != nil:
    section.add "prettyPrint", valid_590849
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590850: Call_DirectoryTokensDelete_590838; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all access tokens issued by a user for an application.
  ## 
  let valid = call_590850.validator(path, query, header, formData, body)
  let scheme = call_590850.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590850.url(scheme.get, call_590850.host, call_590850.base,
                         call_590850.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590850, url, valid)

proc call*(call_590851: Call_DirectoryTokensDelete_590838; clientId: string;
          userKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryTokensDelete
  ## Delete all access tokens issued by a user for an application.
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
  ##   clientId: string (required)
  ##           : The Client ID of the application the token is issued to.
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590852 = newJObject()
  var query_590853 = newJObject()
  add(query_590853, "fields", newJString(fields))
  add(query_590853, "quotaUser", newJString(quotaUser))
  add(query_590853, "alt", newJString(alt))
  add(query_590853, "oauth_token", newJString(oauthToken))
  add(query_590853, "userIp", newJString(userIp))
  add(path_590852, "clientId", newJString(clientId))
  add(path_590852, "userKey", newJString(userKey))
  add(query_590853, "key", newJString(key))
  add(query_590853, "prettyPrint", newJBool(prettyPrint))
  result = call_590851.call(path_590852, query_590853, nil, nil, nil)

var directoryTokensDelete* = Call_DirectoryTokensDelete_590838(
    name: "directoryTokensDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensDelete_590839, base: "/admin/directory/v1",
    url: url_DirectoryTokensDelete_590840, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUndelete_590854 = ref object of OpenApiRestCall_588466
proc url_DirectoryUsersUndelete_590856(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersUndelete_590855(path: JsonNode; query: JsonNode;
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
  var valid_590857 = path.getOrDefault("userKey")
  valid_590857 = validateParameter(valid_590857, JString, required = true,
                                 default = nil)
  if valid_590857 != nil:
    section.add "userKey", valid_590857
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
  var valid_590858 = query.getOrDefault("fields")
  valid_590858 = validateParameter(valid_590858, JString, required = false,
                                 default = nil)
  if valid_590858 != nil:
    section.add "fields", valid_590858
  var valid_590859 = query.getOrDefault("quotaUser")
  valid_590859 = validateParameter(valid_590859, JString, required = false,
                                 default = nil)
  if valid_590859 != nil:
    section.add "quotaUser", valid_590859
  var valid_590860 = query.getOrDefault("alt")
  valid_590860 = validateParameter(valid_590860, JString, required = false,
                                 default = newJString("json"))
  if valid_590860 != nil:
    section.add "alt", valid_590860
  var valid_590861 = query.getOrDefault("oauth_token")
  valid_590861 = validateParameter(valid_590861, JString, required = false,
                                 default = nil)
  if valid_590861 != nil:
    section.add "oauth_token", valid_590861
  var valid_590862 = query.getOrDefault("userIp")
  valid_590862 = validateParameter(valid_590862, JString, required = false,
                                 default = nil)
  if valid_590862 != nil:
    section.add "userIp", valid_590862
  var valid_590863 = query.getOrDefault("key")
  valid_590863 = validateParameter(valid_590863, JString, required = false,
                                 default = nil)
  if valid_590863 != nil:
    section.add "key", valid_590863
  var valid_590864 = query.getOrDefault("prettyPrint")
  valid_590864 = validateParameter(valid_590864, JBool, required = false,
                                 default = newJBool(true))
  if valid_590864 != nil:
    section.add "prettyPrint", valid_590864
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

proc call*(call_590866: Call_DirectoryUsersUndelete_590854; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted user
  ## 
  let valid = call_590866.validator(path, query, header, formData, body)
  let scheme = call_590866.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590866.url(scheme.get, call_590866.host, call_590866.base,
                         call_590866.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590866, url, valid)

proc call*(call_590867: Call_DirectoryUsersUndelete_590854; userKey: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## directoryUsersUndelete
  ## Undelete a deleted user
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
  ##   userKey: string (required)
  ##          : The immutable id of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590868 = newJObject()
  var query_590869 = newJObject()
  var body_590870 = newJObject()
  add(query_590869, "fields", newJString(fields))
  add(query_590869, "quotaUser", newJString(quotaUser))
  add(query_590869, "alt", newJString(alt))
  add(query_590869, "oauth_token", newJString(oauthToken))
  add(query_590869, "userIp", newJString(userIp))
  add(path_590868, "userKey", newJString(userKey))
  add(query_590869, "key", newJString(key))
  if body != nil:
    body_590870 = body
  add(query_590869, "prettyPrint", newJBool(prettyPrint))
  result = call_590867.call(path_590868, query_590869, nil, nil, body_590870)

var directoryUsersUndelete* = Call_DirectoryUsersUndelete_590854(
    name: "directoryUsersUndelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/undelete",
    validator: validate_DirectoryUsersUndelete_590855,
    base: "/admin/directory/v1", url: url_DirectoryUsersUndelete_590856,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesList_590871 = ref object of OpenApiRestCall_588466
proc url_DirectoryVerificationCodesList_590873(protocol: Scheme; host: string;
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

proc validate_DirectoryVerificationCodesList_590872(path: JsonNode;
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
  var valid_590874 = path.getOrDefault("userKey")
  valid_590874 = validateParameter(valid_590874, JString, required = true,
                                 default = nil)
  if valid_590874 != nil:
    section.add "userKey", valid_590874
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
  var valid_590875 = query.getOrDefault("fields")
  valid_590875 = validateParameter(valid_590875, JString, required = false,
                                 default = nil)
  if valid_590875 != nil:
    section.add "fields", valid_590875
  var valid_590876 = query.getOrDefault("quotaUser")
  valid_590876 = validateParameter(valid_590876, JString, required = false,
                                 default = nil)
  if valid_590876 != nil:
    section.add "quotaUser", valid_590876
  var valid_590877 = query.getOrDefault("alt")
  valid_590877 = validateParameter(valid_590877, JString, required = false,
                                 default = newJString("json"))
  if valid_590877 != nil:
    section.add "alt", valid_590877
  var valid_590878 = query.getOrDefault("oauth_token")
  valid_590878 = validateParameter(valid_590878, JString, required = false,
                                 default = nil)
  if valid_590878 != nil:
    section.add "oauth_token", valid_590878
  var valid_590879 = query.getOrDefault("userIp")
  valid_590879 = validateParameter(valid_590879, JString, required = false,
                                 default = nil)
  if valid_590879 != nil:
    section.add "userIp", valid_590879
  var valid_590880 = query.getOrDefault("key")
  valid_590880 = validateParameter(valid_590880, JString, required = false,
                                 default = nil)
  if valid_590880 != nil:
    section.add "key", valid_590880
  var valid_590881 = query.getOrDefault("prettyPrint")
  valid_590881 = validateParameter(valid_590881, JBool, required = false,
                                 default = newJBool(true))
  if valid_590881 != nil:
    section.add "prettyPrint", valid_590881
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590882: Call_DirectoryVerificationCodesList_590871; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current set of valid backup verification codes for the specified user.
  ## 
  let valid = call_590882.validator(path, query, header, formData, body)
  let scheme = call_590882.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590882.url(scheme.get, call_590882.host, call_590882.base,
                         call_590882.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590882, url, valid)

proc call*(call_590883: Call_DirectoryVerificationCodesList_590871;
          userKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryVerificationCodesList
  ## Returns the current set of valid backup verification codes for the specified user.
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
  ##   userKey: string (required)
  ##          : Identifies the user in the API request. The value can be the user's primary email address, alias email address, or unique user ID.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590884 = newJObject()
  var query_590885 = newJObject()
  add(query_590885, "fields", newJString(fields))
  add(query_590885, "quotaUser", newJString(quotaUser))
  add(query_590885, "alt", newJString(alt))
  add(query_590885, "oauth_token", newJString(oauthToken))
  add(query_590885, "userIp", newJString(userIp))
  add(path_590884, "userKey", newJString(userKey))
  add(query_590885, "key", newJString(key))
  add(query_590885, "prettyPrint", newJBool(prettyPrint))
  result = call_590883.call(path_590884, query_590885, nil, nil, nil)

var directoryVerificationCodesList* = Call_DirectoryVerificationCodesList_590871(
    name: "directoryVerificationCodesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/verificationCodes",
    validator: validate_DirectoryVerificationCodesList_590872,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesList_590873,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesGenerate_590886 = ref object of OpenApiRestCall_588466
proc url_DirectoryVerificationCodesGenerate_590888(protocol: Scheme; host: string;
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

proc validate_DirectoryVerificationCodesGenerate_590887(path: JsonNode;
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
  var valid_590889 = path.getOrDefault("userKey")
  valid_590889 = validateParameter(valid_590889, JString, required = true,
                                 default = nil)
  if valid_590889 != nil:
    section.add "userKey", valid_590889
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
  var valid_590890 = query.getOrDefault("fields")
  valid_590890 = validateParameter(valid_590890, JString, required = false,
                                 default = nil)
  if valid_590890 != nil:
    section.add "fields", valid_590890
  var valid_590891 = query.getOrDefault("quotaUser")
  valid_590891 = validateParameter(valid_590891, JString, required = false,
                                 default = nil)
  if valid_590891 != nil:
    section.add "quotaUser", valid_590891
  var valid_590892 = query.getOrDefault("alt")
  valid_590892 = validateParameter(valid_590892, JString, required = false,
                                 default = newJString("json"))
  if valid_590892 != nil:
    section.add "alt", valid_590892
  var valid_590893 = query.getOrDefault("oauth_token")
  valid_590893 = validateParameter(valid_590893, JString, required = false,
                                 default = nil)
  if valid_590893 != nil:
    section.add "oauth_token", valid_590893
  var valid_590894 = query.getOrDefault("userIp")
  valid_590894 = validateParameter(valid_590894, JString, required = false,
                                 default = nil)
  if valid_590894 != nil:
    section.add "userIp", valid_590894
  var valid_590895 = query.getOrDefault("key")
  valid_590895 = validateParameter(valid_590895, JString, required = false,
                                 default = nil)
  if valid_590895 != nil:
    section.add "key", valid_590895
  var valid_590896 = query.getOrDefault("prettyPrint")
  valid_590896 = validateParameter(valid_590896, JBool, required = false,
                                 default = newJBool(true))
  if valid_590896 != nil:
    section.add "prettyPrint", valid_590896
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590897: Call_DirectoryVerificationCodesGenerate_590886;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate new backup verification codes for the user.
  ## 
  let valid = call_590897.validator(path, query, header, formData, body)
  let scheme = call_590897.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590897.url(scheme.get, call_590897.host, call_590897.base,
                         call_590897.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590897, url, valid)

proc call*(call_590898: Call_DirectoryVerificationCodesGenerate_590886;
          userKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryVerificationCodesGenerate
  ## Generate new backup verification codes for the user.
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590899 = newJObject()
  var query_590900 = newJObject()
  add(query_590900, "fields", newJString(fields))
  add(query_590900, "quotaUser", newJString(quotaUser))
  add(query_590900, "alt", newJString(alt))
  add(query_590900, "oauth_token", newJString(oauthToken))
  add(query_590900, "userIp", newJString(userIp))
  add(path_590899, "userKey", newJString(userKey))
  add(query_590900, "key", newJString(key))
  add(query_590900, "prettyPrint", newJBool(prettyPrint))
  result = call_590898.call(path_590899, query_590900, nil, nil, nil)

var directoryVerificationCodesGenerate* = Call_DirectoryVerificationCodesGenerate_590886(
    name: "directoryVerificationCodesGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/generate",
    validator: validate_DirectoryVerificationCodesGenerate_590887,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesGenerate_590888,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesInvalidate_590901 = ref object of OpenApiRestCall_588466
proc url_DirectoryVerificationCodesInvalidate_590903(protocol: Scheme;
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

proc validate_DirectoryVerificationCodesInvalidate_590902(path: JsonNode;
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
  var valid_590904 = path.getOrDefault("userKey")
  valid_590904 = validateParameter(valid_590904, JString, required = true,
                                 default = nil)
  if valid_590904 != nil:
    section.add "userKey", valid_590904
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
  var valid_590905 = query.getOrDefault("fields")
  valid_590905 = validateParameter(valid_590905, JString, required = false,
                                 default = nil)
  if valid_590905 != nil:
    section.add "fields", valid_590905
  var valid_590906 = query.getOrDefault("quotaUser")
  valid_590906 = validateParameter(valid_590906, JString, required = false,
                                 default = nil)
  if valid_590906 != nil:
    section.add "quotaUser", valid_590906
  var valid_590907 = query.getOrDefault("alt")
  valid_590907 = validateParameter(valid_590907, JString, required = false,
                                 default = newJString("json"))
  if valid_590907 != nil:
    section.add "alt", valid_590907
  var valid_590908 = query.getOrDefault("oauth_token")
  valid_590908 = validateParameter(valid_590908, JString, required = false,
                                 default = nil)
  if valid_590908 != nil:
    section.add "oauth_token", valid_590908
  var valid_590909 = query.getOrDefault("userIp")
  valid_590909 = validateParameter(valid_590909, JString, required = false,
                                 default = nil)
  if valid_590909 != nil:
    section.add "userIp", valid_590909
  var valid_590910 = query.getOrDefault("key")
  valid_590910 = validateParameter(valid_590910, JString, required = false,
                                 default = nil)
  if valid_590910 != nil:
    section.add "key", valid_590910
  var valid_590911 = query.getOrDefault("prettyPrint")
  valid_590911 = validateParameter(valid_590911, JBool, required = false,
                                 default = newJBool(true))
  if valid_590911 != nil:
    section.add "prettyPrint", valid_590911
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590912: Call_DirectoryVerificationCodesInvalidate_590901;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invalidate the current backup verification codes for the user.
  ## 
  let valid = call_590912.validator(path, query, header, formData, body)
  let scheme = call_590912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590912.url(scheme.get, call_590912.host, call_590912.base,
                         call_590912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590912, url, valid)

proc call*(call_590913: Call_DirectoryVerificationCodesInvalidate_590901;
          userKey: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## directoryVerificationCodesInvalidate
  ## Invalidate the current backup verification codes for the user.
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
  ##   userKey: string (required)
  ##          : Email or immutable ID of the user
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_590914 = newJObject()
  var query_590915 = newJObject()
  add(query_590915, "fields", newJString(fields))
  add(query_590915, "quotaUser", newJString(quotaUser))
  add(query_590915, "alt", newJString(alt))
  add(query_590915, "oauth_token", newJString(oauthToken))
  add(query_590915, "userIp", newJString(userIp))
  add(path_590914, "userKey", newJString(userKey))
  add(query_590915, "key", newJString(key))
  add(query_590915, "prettyPrint", newJBool(prettyPrint))
  result = call_590913.call(path_590914, query_590915, nil, nil, nil)

var directoryVerificationCodesInvalidate* = Call_DirectoryVerificationCodesInvalidate_590901(
    name: "directoryVerificationCodesInvalidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/invalidate",
    validator: validate_DirectoryVerificationCodesInvalidate_590902,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesInvalidate_590903,
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
