
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

  OpenApiRestCall_579437 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579437](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579437): Option[Scheme] {.used.} =
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
  gcpServiceName = "admin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_AdminChannelsStop_579705 = ref object of OpenApiRestCall_579437
proc url_AdminChannelsStop_579707(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_AdminChannelsStop_579706(path: JsonNode; query: JsonNode;
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
  var valid_579819 = query.getOrDefault("fields")
  valid_579819 = validateParameter(valid_579819, JString, required = false,
                                 default = nil)
  if valid_579819 != nil:
    section.add "fields", valid_579819
  var valid_579820 = query.getOrDefault("quotaUser")
  valid_579820 = validateParameter(valid_579820, JString, required = false,
                                 default = nil)
  if valid_579820 != nil:
    section.add "quotaUser", valid_579820
  var valid_579834 = query.getOrDefault("alt")
  valid_579834 = validateParameter(valid_579834, JString, required = false,
                                 default = newJString("json"))
  if valid_579834 != nil:
    section.add "alt", valid_579834
  var valid_579835 = query.getOrDefault("oauth_token")
  valid_579835 = validateParameter(valid_579835, JString, required = false,
                                 default = nil)
  if valid_579835 != nil:
    section.add "oauth_token", valid_579835
  var valid_579836 = query.getOrDefault("userIp")
  valid_579836 = validateParameter(valid_579836, JString, required = false,
                                 default = nil)
  if valid_579836 != nil:
    section.add "userIp", valid_579836
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

proc call*(call_579862: Call_AdminChannelsStop_579705; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_579862.validator(path, query, header, formData, body)
  let scheme = call_579862.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579862.url(scheme.get, call_579862.host, call_579862.base,
                         call_579862.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579862, url, valid)

proc call*(call_579933: Call_AdminChannelsStop_579705; fields: string = "";
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
  var query_579934 = newJObject()
  var body_579936 = newJObject()
  add(query_579934, "fields", newJString(fields))
  add(query_579934, "quotaUser", newJString(quotaUser))
  add(query_579934, "alt", newJString(alt))
  add(query_579934, "oauth_token", newJString(oauthToken))
  add(query_579934, "userIp", newJString(userIp))
  add(query_579934, "key", newJString(key))
  if resource != nil:
    body_579936 = resource
  add(query_579934, "prettyPrint", newJBool(prettyPrint))
  result = call_579933.call(nil, query_579934, nil, nil, body_579936)

var adminChannelsStop* = Call_AdminChannelsStop_579705(name: "adminChannelsStop",
    meth: HttpMethod.HttpPost, host: "www.googleapis.com",
    route: "/admin/directory_v1/channels/stop",
    validator: validate_AdminChannelsStop_579706, base: "/admin/directory/v1",
    url: url_AdminChannelsStop_579707, schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesList_579975 = ref object of OpenApiRestCall_579437
proc url_DirectoryChromeosdevicesList_579977(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesList_579976(path: JsonNode; query: JsonNode;
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
  var valid_579992 = path.getOrDefault("customerId")
  valid_579992 = validateParameter(valid_579992, JString, required = true,
                                 default = nil)
  if valid_579992 != nil:
    section.add "customerId", valid_579992
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
  var valid_579993 = query.getOrDefault("fields")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "fields", valid_579993
  var valid_579994 = query.getOrDefault("pageToken")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "pageToken", valid_579994
  var valid_579995 = query.getOrDefault("quotaUser")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "quotaUser", valid_579995
  var valid_579996 = query.getOrDefault("alt")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = newJString("json"))
  if valid_579996 != nil:
    section.add "alt", valid_579996
  var valid_579997 = query.getOrDefault("query")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = nil)
  if valid_579997 != nil:
    section.add "query", valid_579997
  var valid_579998 = query.getOrDefault("orgUnitPath")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "orgUnitPath", valid_579998
  var valid_579999 = query.getOrDefault("oauth_token")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "oauth_token", valid_579999
  var valid_580000 = query.getOrDefault("userIp")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "userIp", valid_580000
  var valid_580002 = query.getOrDefault("maxResults")
  valid_580002 = validateParameter(valid_580002, JInt, required = false,
                                 default = newJInt(100))
  if valid_580002 != nil:
    section.add "maxResults", valid_580002
  var valid_580003 = query.getOrDefault("orderBy")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = newJString("annotatedLocation"))
  if valid_580003 != nil:
    section.add "orderBy", valid_580003
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("projection")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580005 != nil:
    section.add "projection", valid_580005
  var valid_580006 = query.getOrDefault("sortOrder")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_580006 != nil:
    section.add "sortOrder", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580008: Call_DirectoryChromeosdevicesList_579975; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Chrome OS Devices of a customer (paginated)
  ## 
  let valid = call_580008.validator(path, query, header, formData, body)
  let scheme = call_580008.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580008.url(scheme.get, call_580008.host, call_580008.base,
                         call_580008.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580008, url, valid)

proc call*(call_580009: Call_DirectoryChromeosdevicesList_579975;
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
  var path_580010 = newJObject()
  var query_580011 = newJObject()
  add(query_580011, "fields", newJString(fields))
  add(query_580011, "pageToken", newJString(pageToken))
  add(query_580011, "quotaUser", newJString(quotaUser))
  add(query_580011, "alt", newJString(alt))
  add(query_580011, "query", newJString(query))
  add(query_580011, "orgUnitPath", newJString(orgUnitPath))
  add(query_580011, "oauth_token", newJString(oauthToken))
  add(query_580011, "userIp", newJString(userIp))
  add(query_580011, "maxResults", newJInt(maxResults))
  add(query_580011, "orderBy", newJString(orderBy))
  add(path_580010, "customerId", newJString(customerId))
  add(query_580011, "key", newJString(key))
  add(query_580011, "projection", newJString(projection))
  add(query_580011, "sortOrder", newJString(sortOrder))
  add(query_580011, "prettyPrint", newJBool(prettyPrint))
  result = call_580009.call(path_580010, query_580011, nil, nil, nil)

var directoryChromeosdevicesList* = Call_DirectoryChromeosdevicesList_579975(
    name: "directoryChromeosdevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/chromeos",
    validator: validate_DirectoryChromeosdevicesList_579976,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesList_579977,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesMoveDevicesToOu_580012 = ref object of OpenApiRestCall_579437
proc url_DirectoryChromeosdevicesMoveDevicesToOu_580014(protocol: Scheme;
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

proc validate_DirectoryChromeosdevicesMoveDevicesToOu_580013(path: JsonNode;
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
  var valid_580015 = path.getOrDefault("customerId")
  valid_580015 = validateParameter(valid_580015, JString, required = true,
                                 default = nil)
  if valid_580015 != nil:
    section.add "customerId", valid_580015
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
  var valid_580016 = query.getOrDefault("fields")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "fields", valid_580016
  var valid_580017 = query.getOrDefault("quotaUser")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "quotaUser", valid_580017
  var valid_580018 = query.getOrDefault("alt")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = newJString("json"))
  if valid_580018 != nil:
    section.add "alt", valid_580018
  assert query != nil,
        "query argument is necessary due to required `orgUnitPath` field"
  var valid_580019 = query.getOrDefault("orgUnitPath")
  valid_580019 = validateParameter(valid_580019, JString, required = true,
                                 default = nil)
  if valid_580019 != nil:
    section.add "orgUnitPath", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("userIp")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "userIp", valid_580021
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

proc call*(call_580025: Call_DirectoryChromeosdevicesMoveDevicesToOu_580012;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Move or insert multiple Chrome OS Devices to organizational unit
  ## 
  let valid = call_580025.validator(path, query, header, formData, body)
  let scheme = call_580025.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580025.url(scheme.get, call_580025.host, call_580025.base,
                         call_580025.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580025, url, valid)

proc call*(call_580026: Call_DirectoryChromeosdevicesMoveDevicesToOu_580012;
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
  var path_580027 = newJObject()
  var query_580028 = newJObject()
  var body_580029 = newJObject()
  add(query_580028, "fields", newJString(fields))
  add(query_580028, "quotaUser", newJString(quotaUser))
  add(query_580028, "alt", newJString(alt))
  add(query_580028, "orgUnitPath", newJString(orgUnitPath))
  add(query_580028, "oauth_token", newJString(oauthToken))
  add(query_580028, "userIp", newJString(userIp))
  add(path_580027, "customerId", newJString(customerId))
  add(query_580028, "key", newJString(key))
  if body != nil:
    body_580029 = body
  add(query_580028, "prettyPrint", newJBool(prettyPrint))
  result = call_580026.call(path_580027, query_580028, nil, nil, body_580029)

var directoryChromeosdevicesMoveDevicesToOu* = Call_DirectoryChromeosdevicesMoveDevicesToOu_580012(
    name: "directoryChromeosdevicesMoveDevicesToOu", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/moveDevicesToOu",
    validator: validate_DirectoryChromeosdevicesMoveDevicesToOu_580013,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesMoveDevicesToOu_580014,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesUpdate_580047 = ref object of OpenApiRestCall_579437
proc url_DirectoryChromeosdevicesUpdate_580049(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesUpdate_580048(path: JsonNode;
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
  var valid_580050 = path.getOrDefault("deviceId")
  valid_580050 = validateParameter(valid_580050, JString, required = true,
                                 default = nil)
  if valid_580050 != nil:
    section.add "deviceId", valid_580050
  var valid_580051 = path.getOrDefault("customerId")
  valid_580051 = validateParameter(valid_580051, JString, required = true,
                                 default = nil)
  if valid_580051 != nil:
    section.add "customerId", valid_580051
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
  var valid_580052 = query.getOrDefault("fields")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "fields", valid_580052
  var valid_580053 = query.getOrDefault("quotaUser")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = nil)
  if valid_580053 != nil:
    section.add "quotaUser", valid_580053
  var valid_580054 = query.getOrDefault("alt")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = newJString("json"))
  if valid_580054 != nil:
    section.add "alt", valid_580054
  var valid_580055 = query.getOrDefault("oauth_token")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "oauth_token", valid_580055
  var valid_580056 = query.getOrDefault("userIp")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "userIp", valid_580056
  var valid_580057 = query.getOrDefault("key")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "key", valid_580057
  var valid_580058 = query.getOrDefault("projection")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580058 != nil:
    section.add "projection", valid_580058
  var valid_580059 = query.getOrDefault("prettyPrint")
  valid_580059 = validateParameter(valid_580059, JBool, required = false,
                                 default = newJBool(true))
  if valid_580059 != nil:
    section.add "prettyPrint", valid_580059
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

proc call*(call_580061: Call_DirectoryChromeosdevicesUpdate_580047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device
  ## 
  let valid = call_580061.validator(path, query, header, formData, body)
  let scheme = call_580061.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580061.url(scheme.get, call_580061.host, call_580061.base,
                         call_580061.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580061, url, valid)

proc call*(call_580062: Call_DirectoryChromeosdevicesUpdate_580047;
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
  var path_580063 = newJObject()
  var query_580064 = newJObject()
  var body_580065 = newJObject()
  add(query_580064, "fields", newJString(fields))
  add(query_580064, "quotaUser", newJString(quotaUser))
  add(query_580064, "alt", newJString(alt))
  add(path_580063, "deviceId", newJString(deviceId))
  add(query_580064, "oauth_token", newJString(oauthToken))
  add(query_580064, "userIp", newJString(userIp))
  add(path_580063, "customerId", newJString(customerId))
  add(query_580064, "key", newJString(key))
  add(query_580064, "projection", newJString(projection))
  if body != nil:
    body_580065 = body
  add(query_580064, "prettyPrint", newJBool(prettyPrint))
  result = call_580062.call(path_580063, query_580064, nil, nil, body_580065)

var directoryChromeosdevicesUpdate* = Call_DirectoryChromeosdevicesUpdate_580047(
    name: "directoryChromeosdevicesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesUpdate_580048,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesUpdate_580049,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesGet_580030 = ref object of OpenApiRestCall_579437
proc url_DirectoryChromeosdevicesGet_580032(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesGet_580031(path: JsonNode; query: JsonNode;
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
  var valid_580033 = path.getOrDefault("deviceId")
  valid_580033 = validateParameter(valid_580033, JString, required = true,
                                 default = nil)
  if valid_580033 != nil:
    section.add "deviceId", valid_580033
  var valid_580034 = path.getOrDefault("customerId")
  valid_580034 = validateParameter(valid_580034, JString, required = true,
                                 default = nil)
  if valid_580034 != nil:
    section.add "customerId", valid_580034
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
  var valid_580035 = query.getOrDefault("fields")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "fields", valid_580035
  var valid_580036 = query.getOrDefault("quotaUser")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "quotaUser", valid_580036
  var valid_580037 = query.getOrDefault("alt")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = newJString("json"))
  if valid_580037 != nil:
    section.add "alt", valid_580037
  var valid_580038 = query.getOrDefault("oauth_token")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "oauth_token", valid_580038
  var valid_580039 = query.getOrDefault("userIp")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "userIp", valid_580039
  var valid_580040 = query.getOrDefault("key")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "key", valid_580040
  var valid_580041 = query.getOrDefault("projection")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580041 != nil:
    section.add "projection", valid_580041
  var valid_580042 = query.getOrDefault("prettyPrint")
  valid_580042 = validateParameter(valid_580042, JBool, required = false,
                                 default = newJBool(true))
  if valid_580042 != nil:
    section.add "prettyPrint", valid_580042
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580043: Call_DirectoryChromeosdevicesGet_580030; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Chrome OS Device
  ## 
  let valid = call_580043.validator(path, query, header, formData, body)
  let scheme = call_580043.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580043.url(scheme.get, call_580043.host, call_580043.base,
                         call_580043.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580043, url, valid)

proc call*(call_580044: Call_DirectoryChromeosdevicesGet_580030; deviceId: string;
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
  var path_580045 = newJObject()
  var query_580046 = newJObject()
  add(query_580046, "fields", newJString(fields))
  add(query_580046, "quotaUser", newJString(quotaUser))
  add(query_580046, "alt", newJString(alt))
  add(path_580045, "deviceId", newJString(deviceId))
  add(query_580046, "oauth_token", newJString(oauthToken))
  add(query_580046, "userIp", newJString(userIp))
  add(path_580045, "customerId", newJString(customerId))
  add(query_580046, "key", newJString(key))
  add(query_580046, "projection", newJString(projection))
  add(query_580046, "prettyPrint", newJBool(prettyPrint))
  result = call_580044.call(path_580045, query_580046, nil, nil, nil)

var directoryChromeosdevicesGet* = Call_DirectoryChromeosdevicesGet_580030(
    name: "directoryChromeosdevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesGet_580031,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesGet_580032,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesPatch_580066 = ref object of OpenApiRestCall_579437
proc url_DirectoryChromeosdevicesPatch_580068(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesPatch_580067(path: JsonNode; query: JsonNode;
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
  var valid_580069 = path.getOrDefault("deviceId")
  valid_580069 = validateParameter(valid_580069, JString, required = true,
                                 default = nil)
  if valid_580069 != nil:
    section.add "deviceId", valid_580069
  var valid_580070 = path.getOrDefault("customerId")
  valid_580070 = validateParameter(valid_580070, JString, required = true,
                                 default = nil)
  if valid_580070 != nil:
    section.add "customerId", valid_580070
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
  var valid_580071 = query.getOrDefault("fields")
  valid_580071 = validateParameter(valid_580071, JString, required = false,
                                 default = nil)
  if valid_580071 != nil:
    section.add "fields", valid_580071
  var valid_580072 = query.getOrDefault("quotaUser")
  valid_580072 = validateParameter(valid_580072, JString, required = false,
                                 default = nil)
  if valid_580072 != nil:
    section.add "quotaUser", valid_580072
  var valid_580073 = query.getOrDefault("alt")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = newJString("json"))
  if valid_580073 != nil:
    section.add "alt", valid_580073
  var valid_580074 = query.getOrDefault("oauth_token")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "oauth_token", valid_580074
  var valid_580075 = query.getOrDefault("userIp")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "userIp", valid_580075
  var valid_580076 = query.getOrDefault("key")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = nil)
  if valid_580076 != nil:
    section.add "key", valid_580076
  var valid_580077 = query.getOrDefault("projection")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580077 != nil:
    section.add "projection", valid_580077
  var valid_580078 = query.getOrDefault("prettyPrint")
  valid_580078 = validateParameter(valid_580078, JBool, required = false,
                                 default = newJBool(true))
  if valid_580078 != nil:
    section.add "prettyPrint", valid_580078
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

proc call*(call_580080: Call_DirectoryChromeosdevicesPatch_580066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Chrome OS Device. This method supports patch semantics.
  ## 
  let valid = call_580080.validator(path, query, header, formData, body)
  let scheme = call_580080.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580080.url(scheme.get, call_580080.host, call_580080.base,
                         call_580080.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580080, url, valid)

proc call*(call_580081: Call_DirectoryChromeosdevicesPatch_580066;
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
  var path_580082 = newJObject()
  var query_580083 = newJObject()
  var body_580084 = newJObject()
  add(query_580083, "fields", newJString(fields))
  add(query_580083, "quotaUser", newJString(quotaUser))
  add(query_580083, "alt", newJString(alt))
  add(path_580082, "deviceId", newJString(deviceId))
  add(query_580083, "oauth_token", newJString(oauthToken))
  add(query_580083, "userIp", newJString(userIp))
  add(path_580082, "customerId", newJString(customerId))
  add(query_580083, "key", newJString(key))
  add(query_580083, "projection", newJString(projection))
  if body != nil:
    body_580084 = body
  add(query_580083, "prettyPrint", newJBool(prettyPrint))
  result = call_580081.call(path_580082, query_580083, nil, nil, body_580084)

var directoryChromeosdevicesPatch* = Call_DirectoryChromeosdevicesPatch_580066(
    name: "directoryChromeosdevicesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{deviceId}",
    validator: validate_DirectoryChromeosdevicesPatch_580067,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesPatch_580068,
    schemes: {Scheme.Https})
type
  Call_DirectoryChromeosdevicesAction_580085 = ref object of OpenApiRestCall_579437
proc url_DirectoryChromeosdevicesAction_580087(protocol: Scheme; host: string;
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

proc validate_DirectoryChromeosdevicesAction_580086(path: JsonNode;
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
  var valid_580088 = path.getOrDefault("customerId")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "customerId", valid_580088
  var valid_580089 = path.getOrDefault("resourceId")
  valid_580089 = validateParameter(valid_580089, JString, required = true,
                                 default = nil)
  if valid_580089 != nil:
    section.add "resourceId", valid_580089
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
  var valid_580090 = query.getOrDefault("fields")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "fields", valid_580090
  var valid_580091 = query.getOrDefault("quotaUser")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = nil)
  if valid_580091 != nil:
    section.add "quotaUser", valid_580091
  var valid_580092 = query.getOrDefault("alt")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = newJString("json"))
  if valid_580092 != nil:
    section.add "alt", valid_580092
  var valid_580093 = query.getOrDefault("oauth_token")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "oauth_token", valid_580093
  var valid_580094 = query.getOrDefault("userIp")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "userIp", valid_580094
  var valid_580095 = query.getOrDefault("key")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "key", valid_580095
  var valid_580096 = query.getOrDefault("prettyPrint")
  valid_580096 = validateParameter(valid_580096, JBool, required = false,
                                 default = newJBool(true))
  if valid_580096 != nil:
    section.add "prettyPrint", valid_580096
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

proc call*(call_580098: Call_DirectoryChromeosdevicesAction_580085; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Chrome OS Device
  ## 
  let valid = call_580098.validator(path, query, header, formData, body)
  let scheme = call_580098.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580098.url(scheme.get, call_580098.host, call_580098.base,
                         call_580098.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580098, url, valid)

proc call*(call_580099: Call_DirectoryChromeosdevicesAction_580085;
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
  var path_580100 = newJObject()
  var query_580101 = newJObject()
  var body_580102 = newJObject()
  add(query_580101, "fields", newJString(fields))
  add(query_580101, "quotaUser", newJString(quotaUser))
  add(query_580101, "alt", newJString(alt))
  add(query_580101, "oauth_token", newJString(oauthToken))
  add(query_580101, "userIp", newJString(userIp))
  add(path_580100, "customerId", newJString(customerId))
  add(query_580101, "key", newJString(key))
  add(path_580100, "resourceId", newJString(resourceId))
  if body != nil:
    body_580102 = body
  add(query_580101, "prettyPrint", newJBool(prettyPrint))
  result = call_580099.call(path_580100, query_580101, nil, nil, body_580102)

var directoryChromeosdevicesAction* = Call_DirectoryChromeosdevicesAction_580085(
    name: "directoryChromeosdevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/chromeos/{resourceId}/action",
    validator: validate_DirectoryChromeosdevicesAction_580086,
    base: "/admin/directory/v1", url: url_DirectoryChromeosdevicesAction_580087,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesList_580103 = ref object of OpenApiRestCall_579437
proc url_DirectoryMobiledevicesList_580105(protocol: Scheme; host: string;
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

proc validate_DirectoryMobiledevicesList_580104(path: JsonNode; query: JsonNode;
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
  var valid_580106 = path.getOrDefault("customerId")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "customerId", valid_580106
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
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("pageToken")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "pageToken", valid_580108
  var valid_580109 = query.getOrDefault("quotaUser")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = nil)
  if valid_580109 != nil:
    section.add "quotaUser", valid_580109
  var valid_580110 = query.getOrDefault("alt")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = newJString("json"))
  if valid_580110 != nil:
    section.add "alt", valid_580110
  var valid_580111 = query.getOrDefault("query")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "query", valid_580111
  var valid_580112 = query.getOrDefault("oauth_token")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "oauth_token", valid_580112
  var valid_580113 = query.getOrDefault("userIp")
  valid_580113 = validateParameter(valid_580113, JString, required = false,
                                 default = nil)
  if valid_580113 != nil:
    section.add "userIp", valid_580113
  var valid_580114 = query.getOrDefault("maxResults")
  valid_580114 = validateParameter(valid_580114, JInt, required = false,
                                 default = newJInt(100))
  if valid_580114 != nil:
    section.add "maxResults", valid_580114
  var valid_580115 = query.getOrDefault("orderBy")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = newJString("deviceId"))
  if valid_580115 != nil:
    section.add "orderBy", valid_580115
  var valid_580116 = query.getOrDefault("key")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "key", valid_580116
  var valid_580117 = query.getOrDefault("projection")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580117 != nil:
    section.add "projection", valid_580117
  var valid_580118 = query.getOrDefault("sortOrder")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_580118 != nil:
    section.add "sortOrder", valid_580118
  var valid_580119 = query.getOrDefault("prettyPrint")
  valid_580119 = validateParameter(valid_580119, JBool, required = false,
                                 default = newJBool(true))
  if valid_580119 != nil:
    section.add "prettyPrint", valid_580119
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580120: Call_DirectoryMobiledevicesList_580103; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all Mobile Devices of a customer (paginated)
  ## 
  let valid = call_580120.validator(path, query, header, formData, body)
  let scheme = call_580120.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580120.url(scheme.get, call_580120.host, call_580120.base,
                         call_580120.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580120, url, valid)

proc call*(call_580121: Call_DirectoryMobiledevicesList_580103; customerId: string;
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
  var path_580122 = newJObject()
  var query_580123 = newJObject()
  add(query_580123, "fields", newJString(fields))
  add(query_580123, "pageToken", newJString(pageToken))
  add(query_580123, "quotaUser", newJString(quotaUser))
  add(query_580123, "alt", newJString(alt))
  add(query_580123, "query", newJString(query))
  add(query_580123, "oauth_token", newJString(oauthToken))
  add(query_580123, "userIp", newJString(userIp))
  add(query_580123, "maxResults", newJInt(maxResults))
  add(query_580123, "orderBy", newJString(orderBy))
  add(path_580122, "customerId", newJString(customerId))
  add(query_580123, "key", newJString(key))
  add(query_580123, "projection", newJString(projection))
  add(query_580123, "sortOrder", newJString(sortOrder))
  add(query_580123, "prettyPrint", newJBool(prettyPrint))
  result = call_580121.call(path_580122, query_580123, nil, nil, nil)

var directoryMobiledevicesList* = Call_DirectoryMobiledevicesList_580103(
    name: "directoryMobiledevicesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/devices/mobile",
    validator: validate_DirectoryMobiledevicesList_580104,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesList_580105,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesGet_580124 = ref object of OpenApiRestCall_579437
proc url_DirectoryMobiledevicesGet_580126(protocol: Scheme; host: string;
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

proc validate_DirectoryMobiledevicesGet_580125(path: JsonNode; query: JsonNode;
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
  var valid_580127 = path.getOrDefault("customerId")
  valid_580127 = validateParameter(valid_580127, JString, required = true,
                                 default = nil)
  if valid_580127 != nil:
    section.add "customerId", valid_580127
  var valid_580128 = path.getOrDefault("resourceId")
  valid_580128 = validateParameter(valid_580128, JString, required = true,
                                 default = nil)
  if valid_580128 != nil:
    section.add "resourceId", valid_580128
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
  var valid_580129 = query.getOrDefault("fields")
  valid_580129 = validateParameter(valid_580129, JString, required = false,
                                 default = nil)
  if valid_580129 != nil:
    section.add "fields", valid_580129
  var valid_580130 = query.getOrDefault("quotaUser")
  valid_580130 = validateParameter(valid_580130, JString, required = false,
                                 default = nil)
  if valid_580130 != nil:
    section.add "quotaUser", valid_580130
  var valid_580131 = query.getOrDefault("alt")
  valid_580131 = validateParameter(valid_580131, JString, required = false,
                                 default = newJString("json"))
  if valid_580131 != nil:
    section.add "alt", valid_580131
  var valid_580132 = query.getOrDefault("oauth_token")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "oauth_token", valid_580132
  var valid_580133 = query.getOrDefault("userIp")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "userIp", valid_580133
  var valid_580134 = query.getOrDefault("key")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = nil)
  if valid_580134 != nil:
    section.add "key", valid_580134
  var valid_580135 = query.getOrDefault("projection")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = newJString("BASIC"))
  if valid_580135 != nil:
    section.add "projection", valid_580135
  var valid_580136 = query.getOrDefault("prettyPrint")
  valid_580136 = validateParameter(valid_580136, JBool, required = false,
                                 default = newJBool(true))
  if valid_580136 != nil:
    section.add "prettyPrint", valid_580136
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580137: Call_DirectoryMobiledevicesGet_580124; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Mobile Device
  ## 
  let valid = call_580137.validator(path, query, header, formData, body)
  let scheme = call_580137.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580137.url(scheme.get, call_580137.host, call_580137.base,
                         call_580137.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580137, url, valid)

proc call*(call_580138: Call_DirectoryMobiledevicesGet_580124; customerId: string;
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
  var path_580139 = newJObject()
  var query_580140 = newJObject()
  add(query_580140, "fields", newJString(fields))
  add(query_580140, "quotaUser", newJString(quotaUser))
  add(query_580140, "alt", newJString(alt))
  add(query_580140, "oauth_token", newJString(oauthToken))
  add(query_580140, "userIp", newJString(userIp))
  add(path_580139, "customerId", newJString(customerId))
  add(query_580140, "key", newJString(key))
  add(path_580139, "resourceId", newJString(resourceId))
  add(query_580140, "projection", newJString(projection))
  add(query_580140, "prettyPrint", newJBool(prettyPrint))
  result = call_580138.call(path_580139, query_580140, nil, nil, nil)

var directoryMobiledevicesGet* = Call_DirectoryMobiledevicesGet_580124(
    name: "directoryMobiledevicesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesGet_580125,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesGet_580126,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesDelete_580141 = ref object of OpenApiRestCall_579437
proc url_DirectoryMobiledevicesDelete_580143(protocol: Scheme; host: string;
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

proc validate_DirectoryMobiledevicesDelete_580142(path: JsonNode; query: JsonNode;
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
  var valid_580144 = path.getOrDefault("customerId")
  valid_580144 = validateParameter(valid_580144, JString, required = true,
                                 default = nil)
  if valid_580144 != nil:
    section.add "customerId", valid_580144
  var valid_580145 = path.getOrDefault("resourceId")
  valid_580145 = validateParameter(valid_580145, JString, required = true,
                                 default = nil)
  if valid_580145 != nil:
    section.add "resourceId", valid_580145
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
  var valid_580146 = query.getOrDefault("fields")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "fields", valid_580146
  var valid_580147 = query.getOrDefault("quotaUser")
  valid_580147 = validateParameter(valid_580147, JString, required = false,
                                 default = nil)
  if valid_580147 != nil:
    section.add "quotaUser", valid_580147
  var valid_580148 = query.getOrDefault("alt")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = newJString("json"))
  if valid_580148 != nil:
    section.add "alt", valid_580148
  var valid_580149 = query.getOrDefault("oauth_token")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "oauth_token", valid_580149
  var valid_580150 = query.getOrDefault("userIp")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = nil)
  if valid_580150 != nil:
    section.add "userIp", valid_580150
  var valid_580151 = query.getOrDefault("key")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "key", valid_580151
  var valid_580152 = query.getOrDefault("prettyPrint")
  valid_580152 = validateParameter(valid_580152, JBool, required = false,
                                 default = newJBool(true))
  if valid_580152 != nil:
    section.add "prettyPrint", valid_580152
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580153: Call_DirectoryMobiledevicesDelete_580141; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Mobile Device
  ## 
  let valid = call_580153.validator(path, query, header, formData, body)
  let scheme = call_580153.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580153.url(scheme.get, call_580153.host, call_580153.base,
                         call_580153.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580153, url, valid)

proc call*(call_580154: Call_DirectoryMobiledevicesDelete_580141;
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
  var path_580155 = newJObject()
  var query_580156 = newJObject()
  add(query_580156, "fields", newJString(fields))
  add(query_580156, "quotaUser", newJString(quotaUser))
  add(query_580156, "alt", newJString(alt))
  add(query_580156, "oauth_token", newJString(oauthToken))
  add(query_580156, "userIp", newJString(userIp))
  add(path_580155, "customerId", newJString(customerId))
  add(query_580156, "key", newJString(key))
  add(path_580155, "resourceId", newJString(resourceId))
  add(query_580156, "prettyPrint", newJBool(prettyPrint))
  result = call_580154.call(path_580155, query_580156, nil, nil, nil)

var directoryMobiledevicesDelete* = Call_DirectoryMobiledevicesDelete_580141(
    name: "directoryMobiledevicesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}",
    validator: validate_DirectoryMobiledevicesDelete_580142,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesDelete_580143,
    schemes: {Scheme.Https})
type
  Call_DirectoryMobiledevicesAction_580157 = ref object of OpenApiRestCall_579437
proc url_DirectoryMobiledevicesAction_580159(protocol: Scheme; host: string;
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

proc validate_DirectoryMobiledevicesAction_580158(path: JsonNode; query: JsonNode;
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
  var valid_580160 = path.getOrDefault("customerId")
  valid_580160 = validateParameter(valid_580160, JString, required = true,
                                 default = nil)
  if valid_580160 != nil:
    section.add "customerId", valid_580160
  var valid_580161 = path.getOrDefault("resourceId")
  valid_580161 = validateParameter(valid_580161, JString, required = true,
                                 default = nil)
  if valid_580161 != nil:
    section.add "resourceId", valid_580161
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
  var valid_580162 = query.getOrDefault("fields")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "fields", valid_580162
  var valid_580163 = query.getOrDefault("quotaUser")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "quotaUser", valid_580163
  var valid_580164 = query.getOrDefault("alt")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = newJString("json"))
  if valid_580164 != nil:
    section.add "alt", valid_580164
  var valid_580165 = query.getOrDefault("oauth_token")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "oauth_token", valid_580165
  var valid_580166 = query.getOrDefault("userIp")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "userIp", valid_580166
  var valid_580167 = query.getOrDefault("key")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "key", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
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

proc call*(call_580170: Call_DirectoryMobiledevicesAction_580157; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Take action on Mobile Device
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_DirectoryMobiledevicesAction_580157;
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
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  var body_580174 = newJObject()
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "userIp", newJString(userIp))
  add(path_580172, "customerId", newJString(customerId))
  add(query_580173, "key", newJString(key))
  add(path_580172, "resourceId", newJString(resourceId))
  if body != nil:
    body_580174 = body
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  result = call_580171.call(path_580172, query_580173, nil, nil, body_580174)

var directoryMobiledevicesAction* = Call_DirectoryMobiledevicesAction_580157(
    name: "directoryMobiledevicesAction", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/devices/mobile/{resourceId}/action",
    validator: validate_DirectoryMobiledevicesAction_580158,
    base: "/admin/directory/v1", url: url_DirectoryMobiledevicesAction_580159,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsInsert_580192 = ref object of OpenApiRestCall_579437
proc url_DirectoryOrgunitsInsert_580194(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsInsert_580193(path: JsonNode; query: JsonNode;
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
  var valid_580195 = path.getOrDefault("customerId")
  valid_580195 = validateParameter(valid_580195, JString, required = true,
                                 default = nil)
  if valid_580195 != nil:
    section.add "customerId", valid_580195
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
  var valid_580196 = query.getOrDefault("fields")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "fields", valid_580196
  var valid_580197 = query.getOrDefault("quotaUser")
  valid_580197 = validateParameter(valid_580197, JString, required = false,
                                 default = nil)
  if valid_580197 != nil:
    section.add "quotaUser", valid_580197
  var valid_580198 = query.getOrDefault("alt")
  valid_580198 = validateParameter(valid_580198, JString, required = false,
                                 default = newJString("json"))
  if valid_580198 != nil:
    section.add "alt", valid_580198
  var valid_580199 = query.getOrDefault("oauth_token")
  valid_580199 = validateParameter(valid_580199, JString, required = false,
                                 default = nil)
  if valid_580199 != nil:
    section.add "oauth_token", valid_580199
  var valid_580200 = query.getOrDefault("userIp")
  valid_580200 = validateParameter(valid_580200, JString, required = false,
                                 default = nil)
  if valid_580200 != nil:
    section.add "userIp", valid_580200
  var valid_580201 = query.getOrDefault("key")
  valid_580201 = validateParameter(valid_580201, JString, required = false,
                                 default = nil)
  if valid_580201 != nil:
    section.add "key", valid_580201
  var valid_580202 = query.getOrDefault("prettyPrint")
  valid_580202 = validateParameter(valid_580202, JBool, required = false,
                                 default = newJBool(true))
  if valid_580202 != nil:
    section.add "prettyPrint", valid_580202
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

proc call*(call_580204: Call_DirectoryOrgunitsInsert_580192; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add organizational unit
  ## 
  let valid = call_580204.validator(path, query, header, formData, body)
  let scheme = call_580204.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580204.url(scheme.get, call_580204.host, call_580204.base,
                         call_580204.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580204, url, valid)

proc call*(call_580205: Call_DirectoryOrgunitsInsert_580192; customerId: string;
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
  var path_580206 = newJObject()
  var query_580207 = newJObject()
  var body_580208 = newJObject()
  add(query_580207, "fields", newJString(fields))
  add(query_580207, "quotaUser", newJString(quotaUser))
  add(query_580207, "alt", newJString(alt))
  add(query_580207, "oauth_token", newJString(oauthToken))
  add(query_580207, "userIp", newJString(userIp))
  add(path_580206, "customerId", newJString(customerId))
  add(query_580207, "key", newJString(key))
  if body != nil:
    body_580208 = body
  add(query_580207, "prettyPrint", newJBool(prettyPrint))
  result = call_580205.call(path_580206, query_580207, nil, nil, body_580208)

var directoryOrgunitsInsert* = Call_DirectoryOrgunitsInsert_580192(
    name: "directoryOrgunitsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsInsert_580193,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsInsert_580194,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsList_580175 = ref object of OpenApiRestCall_579437
proc url_DirectoryOrgunitsList_580177(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsList_580176(path: JsonNode; query: JsonNode;
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
  var valid_580178 = path.getOrDefault("customerId")
  valid_580178 = validateParameter(valid_580178, JString, required = true,
                                 default = nil)
  if valid_580178 != nil:
    section.add "customerId", valid_580178
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
  var valid_580179 = query.getOrDefault("fields")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "fields", valid_580179
  var valid_580180 = query.getOrDefault("quotaUser")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "quotaUser", valid_580180
  var valid_580181 = query.getOrDefault("alt")
  valid_580181 = validateParameter(valid_580181, JString, required = false,
                                 default = newJString("json"))
  if valid_580181 != nil:
    section.add "alt", valid_580181
  var valid_580182 = query.getOrDefault("orgUnitPath")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = newJString(""))
  if valid_580182 != nil:
    section.add "orgUnitPath", valid_580182
  var valid_580183 = query.getOrDefault("type")
  valid_580183 = validateParameter(valid_580183, JString, required = false,
                                 default = newJString("all"))
  if valid_580183 != nil:
    section.add "type", valid_580183
  var valid_580184 = query.getOrDefault("oauth_token")
  valid_580184 = validateParameter(valid_580184, JString, required = false,
                                 default = nil)
  if valid_580184 != nil:
    section.add "oauth_token", valid_580184
  var valid_580185 = query.getOrDefault("userIp")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "userIp", valid_580185
  var valid_580186 = query.getOrDefault("key")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "key", valid_580186
  var valid_580187 = query.getOrDefault("prettyPrint")
  valid_580187 = validateParameter(valid_580187, JBool, required = false,
                                 default = newJBool(true))
  if valid_580187 != nil:
    section.add "prettyPrint", valid_580187
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580188: Call_DirectoryOrgunitsList_580175; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all organizational units
  ## 
  let valid = call_580188.validator(path, query, header, formData, body)
  let scheme = call_580188.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580188.url(scheme.get, call_580188.host, call_580188.base,
                         call_580188.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580188, url, valid)

proc call*(call_580189: Call_DirectoryOrgunitsList_580175; customerId: string;
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
  var path_580190 = newJObject()
  var query_580191 = newJObject()
  add(query_580191, "fields", newJString(fields))
  add(query_580191, "quotaUser", newJString(quotaUser))
  add(query_580191, "alt", newJString(alt))
  add(query_580191, "orgUnitPath", newJString(orgUnitPath))
  add(query_580191, "type", newJString(`type`))
  add(query_580191, "oauth_token", newJString(oauthToken))
  add(query_580191, "userIp", newJString(userIp))
  add(path_580190, "customerId", newJString(customerId))
  add(query_580191, "key", newJString(key))
  add(query_580191, "prettyPrint", newJBool(prettyPrint))
  result = call_580189.call(path_580190, query_580191, nil, nil, nil)

var directoryOrgunitsList* = Call_DirectoryOrgunitsList_580175(
    name: "directoryOrgunitsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/orgunits",
    validator: validate_DirectoryOrgunitsList_580176, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsList_580177, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsUpdate_580225 = ref object of OpenApiRestCall_579437
proc url_DirectoryOrgunitsUpdate_580227(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsUpdate_580226(path: JsonNode; query: JsonNode;
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
  var valid_580228 = path.getOrDefault("customerId")
  valid_580228 = validateParameter(valid_580228, JString, required = true,
                                 default = nil)
  if valid_580228 != nil:
    section.add "customerId", valid_580228
  var valid_580229 = path.getOrDefault("orgUnitPath")
  valid_580229 = validateParameter(valid_580229, JString, required = true,
                                 default = nil)
  if valid_580229 != nil:
    section.add "orgUnitPath", valid_580229
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
  var valid_580230 = query.getOrDefault("fields")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "fields", valid_580230
  var valid_580231 = query.getOrDefault("quotaUser")
  valid_580231 = validateParameter(valid_580231, JString, required = false,
                                 default = nil)
  if valid_580231 != nil:
    section.add "quotaUser", valid_580231
  var valid_580232 = query.getOrDefault("alt")
  valid_580232 = validateParameter(valid_580232, JString, required = false,
                                 default = newJString("json"))
  if valid_580232 != nil:
    section.add "alt", valid_580232
  var valid_580233 = query.getOrDefault("oauth_token")
  valid_580233 = validateParameter(valid_580233, JString, required = false,
                                 default = nil)
  if valid_580233 != nil:
    section.add "oauth_token", valid_580233
  var valid_580234 = query.getOrDefault("userIp")
  valid_580234 = validateParameter(valid_580234, JString, required = false,
                                 default = nil)
  if valid_580234 != nil:
    section.add "userIp", valid_580234
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

proc call*(call_580238: Call_DirectoryOrgunitsUpdate_580225; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit
  ## 
  let valid = call_580238.validator(path, query, header, formData, body)
  let scheme = call_580238.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580238.url(scheme.get, call_580238.host, call_580238.base,
                         call_580238.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580238, url, valid)

proc call*(call_580239: Call_DirectoryOrgunitsUpdate_580225; customerId: string;
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
  var path_580240 = newJObject()
  var query_580241 = newJObject()
  var body_580242 = newJObject()
  add(query_580241, "fields", newJString(fields))
  add(query_580241, "quotaUser", newJString(quotaUser))
  add(query_580241, "alt", newJString(alt))
  add(query_580241, "oauth_token", newJString(oauthToken))
  add(query_580241, "userIp", newJString(userIp))
  add(path_580240, "customerId", newJString(customerId))
  add(path_580240, "orgUnitPath", newJString(orgUnitPath))
  add(query_580241, "key", newJString(key))
  if body != nil:
    body_580242 = body
  add(query_580241, "prettyPrint", newJBool(prettyPrint))
  result = call_580239.call(path_580240, query_580241, nil, nil, body_580242)

var directoryOrgunitsUpdate* = Call_DirectoryOrgunitsUpdate_580225(
    name: "directoryOrgunitsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsUpdate_580226,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsUpdate_580227,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsGet_580209 = ref object of OpenApiRestCall_579437
proc url_DirectoryOrgunitsGet_580211(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsGet_580210(path: JsonNode; query: JsonNode;
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
  var valid_580212 = path.getOrDefault("customerId")
  valid_580212 = validateParameter(valid_580212, JString, required = true,
                                 default = nil)
  if valid_580212 != nil:
    section.add "customerId", valid_580212
  var valid_580213 = path.getOrDefault("orgUnitPath")
  valid_580213 = validateParameter(valid_580213, JString, required = true,
                                 default = nil)
  if valid_580213 != nil:
    section.add "orgUnitPath", valid_580213
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
  var valid_580214 = query.getOrDefault("fields")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "fields", valid_580214
  var valid_580215 = query.getOrDefault("quotaUser")
  valid_580215 = validateParameter(valid_580215, JString, required = false,
                                 default = nil)
  if valid_580215 != nil:
    section.add "quotaUser", valid_580215
  var valid_580216 = query.getOrDefault("alt")
  valid_580216 = validateParameter(valid_580216, JString, required = false,
                                 default = newJString("json"))
  if valid_580216 != nil:
    section.add "alt", valid_580216
  var valid_580217 = query.getOrDefault("oauth_token")
  valid_580217 = validateParameter(valid_580217, JString, required = false,
                                 default = nil)
  if valid_580217 != nil:
    section.add "oauth_token", valid_580217
  var valid_580218 = query.getOrDefault("userIp")
  valid_580218 = validateParameter(valid_580218, JString, required = false,
                                 default = nil)
  if valid_580218 != nil:
    section.add "userIp", valid_580218
  var valid_580219 = query.getOrDefault("key")
  valid_580219 = validateParameter(valid_580219, JString, required = false,
                                 default = nil)
  if valid_580219 != nil:
    section.add "key", valid_580219
  var valid_580220 = query.getOrDefault("prettyPrint")
  valid_580220 = validateParameter(valid_580220, JBool, required = false,
                                 default = newJBool(true))
  if valid_580220 != nil:
    section.add "prettyPrint", valid_580220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580221: Call_DirectoryOrgunitsGet_580209; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Organization Unit
  ## 
  let valid = call_580221.validator(path, query, header, formData, body)
  let scheme = call_580221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580221.url(scheme.get, call_580221.host, call_580221.base,
                         call_580221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580221, url, valid)

proc call*(call_580222: Call_DirectoryOrgunitsGet_580209; customerId: string;
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
  var path_580223 = newJObject()
  var query_580224 = newJObject()
  add(query_580224, "fields", newJString(fields))
  add(query_580224, "quotaUser", newJString(quotaUser))
  add(query_580224, "alt", newJString(alt))
  add(query_580224, "oauth_token", newJString(oauthToken))
  add(query_580224, "userIp", newJString(userIp))
  add(path_580223, "customerId", newJString(customerId))
  add(path_580223, "orgUnitPath", newJString(orgUnitPath))
  add(query_580224, "key", newJString(key))
  add(query_580224, "prettyPrint", newJBool(prettyPrint))
  result = call_580222.call(path_580223, query_580224, nil, nil, nil)

var directoryOrgunitsGet* = Call_DirectoryOrgunitsGet_580209(
    name: "directoryOrgunitsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsGet_580210, base: "/admin/directory/v1",
    url: url_DirectoryOrgunitsGet_580211, schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsPatch_580259 = ref object of OpenApiRestCall_579437
proc url_DirectoryOrgunitsPatch_580261(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsPatch_580260(path: JsonNode; query: JsonNode;
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
  var valid_580262 = path.getOrDefault("customerId")
  valid_580262 = validateParameter(valid_580262, JString, required = true,
                                 default = nil)
  if valid_580262 != nil:
    section.add "customerId", valid_580262
  var valid_580263 = path.getOrDefault("orgUnitPath")
  valid_580263 = validateParameter(valid_580263, JString, required = true,
                                 default = nil)
  if valid_580263 != nil:
    section.add "orgUnitPath", valid_580263
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
  var valid_580264 = query.getOrDefault("fields")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "fields", valid_580264
  var valid_580265 = query.getOrDefault("quotaUser")
  valid_580265 = validateParameter(valid_580265, JString, required = false,
                                 default = nil)
  if valid_580265 != nil:
    section.add "quotaUser", valid_580265
  var valid_580266 = query.getOrDefault("alt")
  valid_580266 = validateParameter(valid_580266, JString, required = false,
                                 default = newJString("json"))
  if valid_580266 != nil:
    section.add "alt", valid_580266
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
  var valid_580270 = query.getOrDefault("prettyPrint")
  valid_580270 = validateParameter(valid_580270, JBool, required = false,
                                 default = newJBool(true))
  if valid_580270 != nil:
    section.add "prettyPrint", valid_580270
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

proc call*(call_580272: Call_DirectoryOrgunitsPatch_580259; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Organization Unit. This method supports patch semantics.
  ## 
  let valid = call_580272.validator(path, query, header, formData, body)
  let scheme = call_580272.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580272.url(scheme.get, call_580272.host, call_580272.base,
                         call_580272.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580272, url, valid)

proc call*(call_580273: Call_DirectoryOrgunitsPatch_580259; customerId: string;
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
  var path_580274 = newJObject()
  var query_580275 = newJObject()
  var body_580276 = newJObject()
  add(query_580275, "fields", newJString(fields))
  add(query_580275, "quotaUser", newJString(quotaUser))
  add(query_580275, "alt", newJString(alt))
  add(query_580275, "oauth_token", newJString(oauthToken))
  add(query_580275, "userIp", newJString(userIp))
  add(path_580274, "customerId", newJString(customerId))
  add(path_580274, "orgUnitPath", newJString(orgUnitPath))
  add(query_580275, "key", newJString(key))
  if body != nil:
    body_580276 = body
  add(query_580275, "prettyPrint", newJBool(prettyPrint))
  result = call_580273.call(path_580274, query_580275, nil, nil, body_580276)

var directoryOrgunitsPatch* = Call_DirectoryOrgunitsPatch_580259(
    name: "directoryOrgunitsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsPatch_580260,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsPatch_580261,
    schemes: {Scheme.Https})
type
  Call_DirectoryOrgunitsDelete_580243 = ref object of OpenApiRestCall_579437
proc url_DirectoryOrgunitsDelete_580245(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryOrgunitsDelete_580244(path: JsonNode; query: JsonNode;
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
  var valid_580246 = path.getOrDefault("customerId")
  valid_580246 = validateParameter(valid_580246, JString, required = true,
                                 default = nil)
  if valid_580246 != nil:
    section.add "customerId", valid_580246
  var valid_580247 = path.getOrDefault("orgUnitPath")
  valid_580247 = validateParameter(valid_580247, JString, required = true,
                                 default = nil)
  if valid_580247 != nil:
    section.add "orgUnitPath", valid_580247
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
  var valid_580248 = query.getOrDefault("fields")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "fields", valid_580248
  var valid_580249 = query.getOrDefault("quotaUser")
  valid_580249 = validateParameter(valid_580249, JString, required = false,
                                 default = nil)
  if valid_580249 != nil:
    section.add "quotaUser", valid_580249
  var valid_580250 = query.getOrDefault("alt")
  valid_580250 = validateParameter(valid_580250, JString, required = false,
                                 default = newJString("json"))
  if valid_580250 != nil:
    section.add "alt", valid_580250
  var valid_580251 = query.getOrDefault("oauth_token")
  valid_580251 = validateParameter(valid_580251, JString, required = false,
                                 default = nil)
  if valid_580251 != nil:
    section.add "oauth_token", valid_580251
  var valid_580252 = query.getOrDefault("userIp")
  valid_580252 = validateParameter(valid_580252, JString, required = false,
                                 default = nil)
  if valid_580252 != nil:
    section.add "userIp", valid_580252
  var valid_580253 = query.getOrDefault("key")
  valid_580253 = validateParameter(valid_580253, JString, required = false,
                                 default = nil)
  if valid_580253 != nil:
    section.add "key", valid_580253
  var valid_580254 = query.getOrDefault("prettyPrint")
  valid_580254 = validateParameter(valid_580254, JBool, required = false,
                                 default = newJBool(true))
  if valid_580254 != nil:
    section.add "prettyPrint", valid_580254
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580255: Call_DirectoryOrgunitsDelete_580243; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove Organization Unit
  ## 
  let valid = call_580255.validator(path, query, header, formData, body)
  let scheme = call_580255.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580255.url(scheme.get, call_580255.host, call_580255.base,
                         call_580255.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580255, url, valid)

proc call*(call_580256: Call_DirectoryOrgunitsDelete_580243; customerId: string;
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
  var path_580257 = newJObject()
  var query_580258 = newJObject()
  add(query_580258, "fields", newJString(fields))
  add(query_580258, "quotaUser", newJString(quotaUser))
  add(query_580258, "alt", newJString(alt))
  add(query_580258, "oauth_token", newJString(oauthToken))
  add(query_580258, "userIp", newJString(userIp))
  add(path_580257, "customerId", newJString(customerId))
  add(path_580257, "orgUnitPath", newJString(orgUnitPath))
  add(query_580258, "key", newJString(key))
  add(query_580258, "prettyPrint", newJBool(prettyPrint))
  result = call_580256.call(path_580257, query_580258, nil, nil, nil)

var directoryOrgunitsDelete* = Call_DirectoryOrgunitsDelete_580243(
    name: "directoryOrgunitsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/orgunits/{orgUnitPath}",
    validator: validate_DirectoryOrgunitsDelete_580244,
    base: "/admin/directory/v1", url: url_DirectoryOrgunitsDelete_580245,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasInsert_580292 = ref object of OpenApiRestCall_579437
proc url_DirectorySchemasInsert_580294(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasInsert_580293(path: JsonNode; query: JsonNode;
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
  var valid_580295 = path.getOrDefault("customerId")
  valid_580295 = validateParameter(valid_580295, JString, required = true,
                                 default = nil)
  if valid_580295 != nil:
    section.add "customerId", valid_580295
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
  var valid_580296 = query.getOrDefault("fields")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "fields", valid_580296
  var valid_580297 = query.getOrDefault("quotaUser")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "quotaUser", valid_580297
  var valid_580298 = query.getOrDefault("alt")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = newJString("json"))
  if valid_580298 != nil:
    section.add "alt", valid_580298
  var valid_580299 = query.getOrDefault("oauth_token")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "oauth_token", valid_580299
  var valid_580300 = query.getOrDefault("userIp")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = nil)
  if valid_580300 != nil:
    section.add "userIp", valid_580300
  var valid_580301 = query.getOrDefault("key")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "key", valid_580301
  var valid_580302 = query.getOrDefault("prettyPrint")
  valid_580302 = validateParameter(valid_580302, JBool, required = false,
                                 default = newJBool(true))
  if valid_580302 != nil:
    section.add "prettyPrint", valid_580302
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

proc call*(call_580304: Call_DirectorySchemasInsert_580292; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create schema.
  ## 
  let valid = call_580304.validator(path, query, header, formData, body)
  let scheme = call_580304.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580304.url(scheme.get, call_580304.host, call_580304.base,
                         call_580304.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580304, url, valid)

proc call*(call_580305: Call_DirectorySchemasInsert_580292; customerId: string;
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
  var path_580306 = newJObject()
  var query_580307 = newJObject()
  var body_580308 = newJObject()
  add(query_580307, "fields", newJString(fields))
  add(query_580307, "quotaUser", newJString(quotaUser))
  add(query_580307, "alt", newJString(alt))
  add(query_580307, "oauth_token", newJString(oauthToken))
  add(query_580307, "userIp", newJString(userIp))
  add(path_580306, "customerId", newJString(customerId))
  add(query_580307, "key", newJString(key))
  if body != nil:
    body_580308 = body
  add(query_580307, "prettyPrint", newJBool(prettyPrint))
  result = call_580305.call(path_580306, query_580307, nil, nil, body_580308)

var directorySchemasInsert* = Call_DirectorySchemasInsert_580292(
    name: "directorySchemasInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasInsert_580293,
    base: "/admin/directory/v1", url: url_DirectorySchemasInsert_580294,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasList_580277 = ref object of OpenApiRestCall_579437
proc url_DirectorySchemasList_580279(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasList_580278(path: JsonNode; query: JsonNode;
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
  var valid_580280 = path.getOrDefault("customerId")
  valid_580280 = validateParameter(valid_580280, JString, required = true,
                                 default = nil)
  if valid_580280 != nil:
    section.add "customerId", valid_580280
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
  var valid_580281 = query.getOrDefault("fields")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "fields", valid_580281
  var valid_580282 = query.getOrDefault("quotaUser")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "quotaUser", valid_580282
  var valid_580283 = query.getOrDefault("alt")
  valid_580283 = validateParameter(valid_580283, JString, required = false,
                                 default = newJString("json"))
  if valid_580283 != nil:
    section.add "alt", valid_580283
  var valid_580284 = query.getOrDefault("oauth_token")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "oauth_token", valid_580284
  var valid_580285 = query.getOrDefault("userIp")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = nil)
  if valid_580285 != nil:
    section.add "userIp", valid_580285
  var valid_580286 = query.getOrDefault("key")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "key", valid_580286
  var valid_580287 = query.getOrDefault("prettyPrint")
  valid_580287 = validateParameter(valid_580287, JBool, required = false,
                                 default = newJBool(true))
  if valid_580287 != nil:
    section.add "prettyPrint", valid_580287
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580288: Call_DirectorySchemasList_580277; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all schemas for a customer
  ## 
  let valid = call_580288.validator(path, query, header, formData, body)
  let scheme = call_580288.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580288.url(scheme.get, call_580288.host, call_580288.base,
                         call_580288.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580288, url, valid)

proc call*(call_580289: Call_DirectorySchemasList_580277; customerId: string;
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
  var path_580290 = newJObject()
  var query_580291 = newJObject()
  add(query_580291, "fields", newJString(fields))
  add(query_580291, "quotaUser", newJString(quotaUser))
  add(query_580291, "alt", newJString(alt))
  add(query_580291, "oauth_token", newJString(oauthToken))
  add(query_580291, "userIp", newJString(userIp))
  add(path_580290, "customerId", newJString(customerId))
  add(query_580291, "key", newJString(key))
  add(query_580291, "prettyPrint", newJBool(prettyPrint))
  result = call_580289.call(path_580290, query_580291, nil, nil, nil)

var directorySchemasList* = Call_DirectorySchemasList_580277(
    name: "directorySchemasList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customerId}/schemas",
    validator: validate_DirectorySchemasList_580278, base: "/admin/directory/v1",
    url: url_DirectorySchemasList_580279, schemes: {Scheme.Https})
type
  Call_DirectorySchemasUpdate_580325 = ref object of OpenApiRestCall_579437
proc url_DirectorySchemasUpdate_580327(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasUpdate_580326(path: JsonNode; query: JsonNode;
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
  var valid_580328 = path.getOrDefault("schemaKey")
  valid_580328 = validateParameter(valid_580328, JString, required = true,
                                 default = nil)
  if valid_580328 != nil:
    section.add "schemaKey", valid_580328
  var valid_580329 = path.getOrDefault("customerId")
  valid_580329 = validateParameter(valid_580329, JString, required = true,
                                 default = nil)
  if valid_580329 != nil:
    section.add "customerId", valid_580329
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
  var valid_580330 = query.getOrDefault("fields")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "fields", valid_580330
  var valid_580331 = query.getOrDefault("quotaUser")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "quotaUser", valid_580331
  var valid_580332 = query.getOrDefault("alt")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = newJString("json"))
  if valid_580332 != nil:
    section.add "alt", valid_580332
  var valid_580333 = query.getOrDefault("oauth_token")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "oauth_token", valid_580333
  var valid_580334 = query.getOrDefault("userIp")
  valid_580334 = validateParameter(valid_580334, JString, required = false,
                                 default = nil)
  if valid_580334 != nil:
    section.add "userIp", valid_580334
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

proc call*(call_580338: Call_DirectorySchemasUpdate_580325; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema
  ## 
  let valid = call_580338.validator(path, query, header, formData, body)
  let scheme = call_580338.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580338.url(scheme.get, call_580338.host, call_580338.base,
                         call_580338.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580338, url, valid)

proc call*(call_580339: Call_DirectorySchemasUpdate_580325; schemaKey: string;
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
  var path_580340 = newJObject()
  var query_580341 = newJObject()
  var body_580342 = newJObject()
  add(query_580341, "fields", newJString(fields))
  add(query_580341, "quotaUser", newJString(quotaUser))
  add(query_580341, "alt", newJString(alt))
  add(path_580340, "schemaKey", newJString(schemaKey))
  add(query_580341, "oauth_token", newJString(oauthToken))
  add(query_580341, "userIp", newJString(userIp))
  add(path_580340, "customerId", newJString(customerId))
  add(query_580341, "key", newJString(key))
  if body != nil:
    body_580342 = body
  add(query_580341, "prettyPrint", newJBool(prettyPrint))
  result = call_580339.call(path_580340, query_580341, nil, nil, body_580342)

var directorySchemasUpdate* = Call_DirectorySchemasUpdate_580325(
    name: "directorySchemasUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasUpdate_580326,
    base: "/admin/directory/v1", url: url_DirectorySchemasUpdate_580327,
    schemes: {Scheme.Https})
type
  Call_DirectorySchemasGet_580309 = ref object of OpenApiRestCall_579437
proc url_DirectorySchemasGet_580311(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasGet_580310(path: JsonNode; query: JsonNode;
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
  var valid_580312 = path.getOrDefault("schemaKey")
  valid_580312 = validateParameter(valid_580312, JString, required = true,
                                 default = nil)
  if valid_580312 != nil:
    section.add "schemaKey", valid_580312
  var valid_580313 = path.getOrDefault("customerId")
  valid_580313 = validateParameter(valid_580313, JString, required = true,
                                 default = nil)
  if valid_580313 != nil:
    section.add "customerId", valid_580313
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
  var valid_580314 = query.getOrDefault("fields")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "fields", valid_580314
  var valid_580315 = query.getOrDefault("quotaUser")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "quotaUser", valid_580315
  var valid_580316 = query.getOrDefault("alt")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = newJString("json"))
  if valid_580316 != nil:
    section.add "alt", valid_580316
  var valid_580317 = query.getOrDefault("oauth_token")
  valid_580317 = validateParameter(valid_580317, JString, required = false,
                                 default = nil)
  if valid_580317 != nil:
    section.add "oauth_token", valid_580317
  var valid_580318 = query.getOrDefault("userIp")
  valid_580318 = validateParameter(valid_580318, JString, required = false,
                                 default = nil)
  if valid_580318 != nil:
    section.add "userIp", valid_580318
  var valid_580319 = query.getOrDefault("key")
  valid_580319 = validateParameter(valid_580319, JString, required = false,
                                 default = nil)
  if valid_580319 != nil:
    section.add "key", valid_580319
  var valid_580320 = query.getOrDefault("prettyPrint")
  valid_580320 = validateParameter(valid_580320, JBool, required = false,
                                 default = newJBool(true))
  if valid_580320 != nil:
    section.add "prettyPrint", valid_580320
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580321: Call_DirectorySchemasGet_580309; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve schema
  ## 
  let valid = call_580321.validator(path, query, header, formData, body)
  let scheme = call_580321.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580321.url(scheme.get, call_580321.host, call_580321.base,
                         call_580321.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580321, url, valid)

proc call*(call_580322: Call_DirectorySchemasGet_580309; schemaKey: string;
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
  var path_580323 = newJObject()
  var query_580324 = newJObject()
  add(query_580324, "fields", newJString(fields))
  add(query_580324, "quotaUser", newJString(quotaUser))
  add(query_580324, "alt", newJString(alt))
  add(path_580323, "schemaKey", newJString(schemaKey))
  add(query_580324, "oauth_token", newJString(oauthToken))
  add(query_580324, "userIp", newJString(userIp))
  add(path_580323, "customerId", newJString(customerId))
  add(query_580324, "key", newJString(key))
  add(query_580324, "prettyPrint", newJBool(prettyPrint))
  result = call_580322.call(path_580323, query_580324, nil, nil, nil)

var directorySchemasGet* = Call_DirectorySchemasGet_580309(
    name: "directorySchemasGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasGet_580310, base: "/admin/directory/v1",
    url: url_DirectorySchemasGet_580311, schemes: {Scheme.Https})
type
  Call_DirectorySchemasPatch_580359 = ref object of OpenApiRestCall_579437
proc url_DirectorySchemasPatch_580361(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasPatch_580360(path: JsonNode; query: JsonNode;
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
  var valid_580362 = path.getOrDefault("schemaKey")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "schemaKey", valid_580362
  var valid_580363 = path.getOrDefault("customerId")
  valid_580363 = validateParameter(valid_580363, JString, required = true,
                                 default = nil)
  if valid_580363 != nil:
    section.add "customerId", valid_580363
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
  var valid_580364 = query.getOrDefault("fields")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "fields", valid_580364
  var valid_580365 = query.getOrDefault("quotaUser")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "quotaUser", valid_580365
  var valid_580366 = query.getOrDefault("alt")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("json"))
  if valid_580366 != nil:
    section.add "alt", valid_580366
  var valid_580367 = query.getOrDefault("oauth_token")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "oauth_token", valid_580367
  var valid_580368 = query.getOrDefault("userIp")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "userIp", valid_580368
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

proc call*(call_580372: Call_DirectorySchemasPatch_580359; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update schema. This method supports patch semantics.
  ## 
  let valid = call_580372.validator(path, query, header, formData, body)
  let scheme = call_580372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580372.url(scheme.get, call_580372.host, call_580372.base,
                         call_580372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580372, url, valid)

proc call*(call_580373: Call_DirectorySchemasPatch_580359; schemaKey: string;
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
  var path_580374 = newJObject()
  var query_580375 = newJObject()
  var body_580376 = newJObject()
  add(query_580375, "fields", newJString(fields))
  add(query_580375, "quotaUser", newJString(quotaUser))
  add(query_580375, "alt", newJString(alt))
  add(path_580374, "schemaKey", newJString(schemaKey))
  add(query_580375, "oauth_token", newJString(oauthToken))
  add(query_580375, "userIp", newJString(userIp))
  add(path_580374, "customerId", newJString(customerId))
  add(query_580375, "key", newJString(key))
  if body != nil:
    body_580376 = body
  add(query_580375, "prettyPrint", newJBool(prettyPrint))
  result = call_580373.call(path_580374, query_580375, nil, nil, body_580376)

var directorySchemasPatch* = Call_DirectorySchemasPatch_580359(
    name: "directorySchemasPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasPatch_580360, base: "/admin/directory/v1",
    url: url_DirectorySchemasPatch_580361, schemes: {Scheme.Https})
type
  Call_DirectorySchemasDelete_580343 = ref object of OpenApiRestCall_579437
proc url_DirectorySchemasDelete_580345(protocol: Scheme; host: string; base: string;
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

proc validate_DirectorySchemasDelete_580344(path: JsonNode; query: JsonNode;
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
  var valid_580346 = path.getOrDefault("schemaKey")
  valid_580346 = validateParameter(valid_580346, JString, required = true,
                                 default = nil)
  if valid_580346 != nil:
    section.add "schemaKey", valid_580346
  var valid_580347 = path.getOrDefault("customerId")
  valid_580347 = validateParameter(valid_580347, JString, required = true,
                                 default = nil)
  if valid_580347 != nil:
    section.add "customerId", valid_580347
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
  var valid_580348 = query.getOrDefault("fields")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "fields", valid_580348
  var valid_580349 = query.getOrDefault("quotaUser")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "quotaUser", valid_580349
  var valid_580350 = query.getOrDefault("alt")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = newJString("json"))
  if valid_580350 != nil:
    section.add "alt", valid_580350
  var valid_580351 = query.getOrDefault("oauth_token")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "oauth_token", valid_580351
  var valid_580352 = query.getOrDefault("userIp")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "userIp", valid_580352
  var valid_580353 = query.getOrDefault("key")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "key", valid_580353
  var valid_580354 = query.getOrDefault("prettyPrint")
  valid_580354 = validateParameter(valid_580354, JBool, required = false,
                                 default = newJBool(true))
  if valid_580354 != nil:
    section.add "prettyPrint", valid_580354
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580355: Call_DirectorySchemasDelete_580343; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete schema
  ## 
  let valid = call_580355.validator(path, query, header, formData, body)
  let scheme = call_580355.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580355.url(scheme.get, call_580355.host, call_580355.base,
                         call_580355.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580355, url, valid)

proc call*(call_580356: Call_DirectorySchemasDelete_580343; schemaKey: string;
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
  var path_580357 = newJObject()
  var query_580358 = newJObject()
  add(query_580358, "fields", newJString(fields))
  add(query_580358, "quotaUser", newJString(quotaUser))
  add(query_580358, "alt", newJString(alt))
  add(path_580357, "schemaKey", newJString(schemaKey))
  add(query_580358, "oauth_token", newJString(oauthToken))
  add(query_580358, "userIp", newJString(userIp))
  add(path_580357, "customerId", newJString(customerId))
  add(query_580358, "key", newJString(key))
  add(query_580358, "prettyPrint", newJBool(prettyPrint))
  result = call_580356.call(path_580357, query_580358, nil, nil, nil)

var directorySchemasDelete* = Call_DirectorySchemasDelete_580343(
    name: "directorySchemasDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customerId}/schemas/{schemaKey}",
    validator: validate_DirectorySchemasDelete_580344,
    base: "/admin/directory/v1", url: url_DirectorySchemasDelete_580345,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesInsert_580393 = ref object of OpenApiRestCall_579437
proc url_DirectoryDomainAliasesInsert_580395(protocol: Scheme; host: string;
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

proc validate_DirectoryDomainAliasesInsert_580394(path: JsonNode; query: JsonNode;
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
  var valid_580396 = path.getOrDefault("customer")
  valid_580396 = validateParameter(valid_580396, JString, required = true,
                                 default = nil)
  if valid_580396 != nil:
    section.add "customer", valid_580396
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
  var valid_580397 = query.getOrDefault("fields")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "fields", valid_580397
  var valid_580398 = query.getOrDefault("quotaUser")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "quotaUser", valid_580398
  var valid_580399 = query.getOrDefault("alt")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = newJString("json"))
  if valid_580399 != nil:
    section.add "alt", valid_580399
  var valid_580400 = query.getOrDefault("oauth_token")
  valid_580400 = validateParameter(valid_580400, JString, required = false,
                                 default = nil)
  if valid_580400 != nil:
    section.add "oauth_token", valid_580400
  var valid_580401 = query.getOrDefault("userIp")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "userIp", valid_580401
  var valid_580402 = query.getOrDefault("key")
  valid_580402 = validateParameter(valid_580402, JString, required = false,
                                 default = nil)
  if valid_580402 != nil:
    section.add "key", valid_580402
  var valid_580403 = query.getOrDefault("prettyPrint")
  valid_580403 = validateParameter(valid_580403, JBool, required = false,
                                 default = newJBool(true))
  if valid_580403 != nil:
    section.add "prettyPrint", valid_580403
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

proc call*(call_580405: Call_DirectoryDomainAliasesInsert_580393; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a Domain alias of the customer.
  ## 
  let valid = call_580405.validator(path, query, header, formData, body)
  let scheme = call_580405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580405.url(scheme.get, call_580405.host, call_580405.base,
                         call_580405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580405, url, valid)

proc call*(call_580406: Call_DirectoryDomainAliasesInsert_580393; customer: string;
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
  var path_580407 = newJObject()
  var query_580408 = newJObject()
  var body_580409 = newJObject()
  add(query_580408, "fields", newJString(fields))
  add(query_580408, "quotaUser", newJString(quotaUser))
  add(query_580408, "alt", newJString(alt))
  add(query_580408, "oauth_token", newJString(oauthToken))
  add(query_580408, "userIp", newJString(userIp))
  add(query_580408, "key", newJString(key))
  add(path_580407, "customer", newJString(customer))
  if body != nil:
    body_580409 = body
  add(query_580408, "prettyPrint", newJBool(prettyPrint))
  result = call_580406.call(path_580407, query_580408, nil, nil, body_580409)

var directoryDomainAliasesInsert* = Call_DirectoryDomainAliasesInsert_580393(
    name: "directoryDomainAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesInsert_580394,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesInsert_580395,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesList_580377 = ref object of OpenApiRestCall_579437
proc url_DirectoryDomainAliasesList_580379(protocol: Scheme; host: string;
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

proc validate_DirectoryDomainAliasesList_580378(path: JsonNode; query: JsonNode;
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
  var valid_580380 = path.getOrDefault("customer")
  valid_580380 = validateParameter(valid_580380, JString, required = true,
                                 default = nil)
  if valid_580380 != nil:
    section.add "customer", valid_580380
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
  var valid_580381 = query.getOrDefault("fields")
  valid_580381 = validateParameter(valid_580381, JString, required = false,
                                 default = nil)
  if valid_580381 != nil:
    section.add "fields", valid_580381
  var valid_580382 = query.getOrDefault("quotaUser")
  valid_580382 = validateParameter(valid_580382, JString, required = false,
                                 default = nil)
  if valid_580382 != nil:
    section.add "quotaUser", valid_580382
  var valid_580383 = query.getOrDefault("alt")
  valid_580383 = validateParameter(valid_580383, JString, required = false,
                                 default = newJString("json"))
  if valid_580383 != nil:
    section.add "alt", valid_580383
  var valid_580384 = query.getOrDefault("parentDomainName")
  valid_580384 = validateParameter(valid_580384, JString, required = false,
                                 default = nil)
  if valid_580384 != nil:
    section.add "parentDomainName", valid_580384
  var valid_580385 = query.getOrDefault("oauth_token")
  valid_580385 = validateParameter(valid_580385, JString, required = false,
                                 default = nil)
  if valid_580385 != nil:
    section.add "oauth_token", valid_580385
  var valid_580386 = query.getOrDefault("userIp")
  valid_580386 = validateParameter(valid_580386, JString, required = false,
                                 default = nil)
  if valid_580386 != nil:
    section.add "userIp", valid_580386
  var valid_580387 = query.getOrDefault("key")
  valid_580387 = validateParameter(valid_580387, JString, required = false,
                                 default = nil)
  if valid_580387 != nil:
    section.add "key", valid_580387
  var valid_580388 = query.getOrDefault("prettyPrint")
  valid_580388 = validateParameter(valid_580388, JBool, required = false,
                                 default = newJBool(true))
  if valid_580388 != nil:
    section.add "prettyPrint", valid_580388
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580389: Call_DirectoryDomainAliasesList_580377; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domain aliases of the customer.
  ## 
  let valid = call_580389.validator(path, query, header, formData, body)
  let scheme = call_580389.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580389.url(scheme.get, call_580389.host, call_580389.base,
                         call_580389.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580389, url, valid)

proc call*(call_580390: Call_DirectoryDomainAliasesList_580377; customer: string;
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
  var path_580391 = newJObject()
  var query_580392 = newJObject()
  add(query_580392, "fields", newJString(fields))
  add(query_580392, "quotaUser", newJString(quotaUser))
  add(query_580392, "alt", newJString(alt))
  add(query_580392, "parentDomainName", newJString(parentDomainName))
  add(query_580392, "oauth_token", newJString(oauthToken))
  add(query_580392, "userIp", newJString(userIp))
  add(query_580392, "key", newJString(key))
  add(path_580391, "customer", newJString(customer))
  add(query_580392, "prettyPrint", newJBool(prettyPrint))
  result = call_580390.call(path_580391, query_580392, nil, nil, nil)

var directoryDomainAliasesList* = Call_DirectoryDomainAliasesList_580377(
    name: "directoryDomainAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domainaliases",
    validator: validate_DirectoryDomainAliasesList_580378,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesList_580379,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesGet_580410 = ref object of OpenApiRestCall_579437
proc url_DirectoryDomainAliasesGet_580412(protocol: Scheme; host: string;
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

proc validate_DirectoryDomainAliasesGet_580411(path: JsonNode; query: JsonNode;
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
  var valid_580413 = path.getOrDefault("domainAliasName")
  valid_580413 = validateParameter(valid_580413, JString, required = true,
                                 default = nil)
  if valid_580413 != nil:
    section.add "domainAliasName", valid_580413
  var valid_580414 = path.getOrDefault("customer")
  valid_580414 = validateParameter(valid_580414, JString, required = true,
                                 default = nil)
  if valid_580414 != nil:
    section.add "customer", valid_580414
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
  var valid_580415 = query.getOrDefault("fields")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "fields", valid_580415
  var valid_580416 = query.getOrDefault("quotaUser")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "quotaUser", valid_580416
  var valid_580417 = query.getOrDefault("alt")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = newJString("json"))
  if valid_580417 != nil:
    section.add "alt", valid_580417
  var valid_580418 = query.getOrDefault("oauth_token")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "oauth_token", valid_580418
  var valid_580419 = query.getOrDefault("userIp")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = nil)
  if valid_580419 != nil:
    section.add "userIp", valid_580419
  var valid_580420 = query.getOrDefault("key")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "key", valid_580420
  var valid_580421 = query.getOrDefault("prettyPrint")
  valid_580421 = validateParameter(valid_580421, JBool, required = false,
                                 default = newJBool(true))
  if valid_580421 != nil:
    section.add "prettyPrint", valid_580421
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580422: Call_DirectoryDomainAliasesGet_580410; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain alias of the customer.
  ## 
  let valid = call_580422.validator(path, query, header, formData, body)
  let scheme = call_580422.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580422.url(scheme.get, call_580422.host, call_580422.base,
                         call_580422.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580422, url, valid)

proc call*(call_580423: Call_DirectoryDomainAliasesGet_580410;
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
  var path_580424 = newJObject()
  var query_580425 = newJObject()
  add(path_580424, "domainAliasName", newJString(domainAliasName))
  add(query_580425, "fields", newJString(fields))
  add(query_580425, "quotaUser", newJString(quotaUser))
  add(query_580425, "alt", newJString(alt))
  add(query_580425, "oauth_token", newJString(oauthToken))
  add(query_580425, "userIp", newJString(userIp))
  add(query_580425, "key", newJString(key))
  add(path_580424, "customer", newJString(customer))
  add(query_580425, "prettyPrint", newJBool(prettyPrint))
  result = call_580423.call(path_580424, query_580425, nil, nil, nil)

var directoryDomainAliasesGet* = Call_DirectoryDomainAliasesGet_580410(
    name: "directoryDomainAliasesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesGet_580411,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesGet_580412,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainAliasesDelete_580426 = ref object of OpenApiRestCall_579437
proc url_DirectoryDomainAliasesDelete_580428(protocol: Scheme; host: string;
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

proc validate_DirectoryDomainAliasesDelete_580427(path: JsonNode; query: JsonNode;
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
  var valid_580429 = path.getOrDefault("domainAliasName")
  valid_580429 = validateParameter(valid_580429, JString, required = true,
                                 default = nil)
  if valid_580429 != nil:
    section.add "domainAliasName", valid_580429
  var valid_580430 = path.getOrDefault("customer")
  valid_580430 = validateParameter(valid_580430, JString, required = true,
                                 default = nil)
  if valid_580430 != nil:
    section.add "customer", valid_580430
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
  var valid_580431 = query.getOrDefault("fields")
  valid_580431 = validateParameter(valid_580431, JString, required = false,
                                 default = nil)
  if valid_580431 != nil:
    section.add "fields", valid_580431
  var valid_580432 = query.getOrDefault("quotaUser")
  valid_580432 = validateParameter(valid_580432, JString, required = false,
                                 default = nil)
  if valid_580432 != nil:
    section.add "quotaUser", valid_580432
  var valid_580433 = query.getOrDefault("alt")
  valid_580433 = validateParameter(valid_580433, JString, required = false,
                                 default = newJString("json"))
  if valid_580433 != nil:
    section.add "alt", valid_580433
  var valid_580434 = query.getOrDefault("oauth_token")
  valid_580434 = validateParameter(valid_580434, JString, required = false,
                                 default = nil)
  if valid_580434 != nil:
    section.add "oauth_token", valid_580434
  var valid_580435 = query.getOrDefault("userIp")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "userIp", valid_580435
  var valid_580436 = query.getOrDefault("key")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "key", valid_580436
  var valid_580437 = query.getOrDefault("prettyPrint")
  valid_580437 = validateParameter(valid_580437, JBool, required = false,
                                 default = newJBool(true))
  if valid_580437 != nil:
    section.add "prettyPrint", valid_580437
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580438: Call_DirectoryDomainAliasesDelete_580426; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a Domain Alias of the customer.
  ## 
  let valid = call_580438.validator(path, query, header, formData, body)
  let scheme = call_580438.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580438.url(scheme.get, call_580438.host, call_580438.base,
                         call_580438.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580438, url, valid)

proc call*(call_580439: Call_DirectoryDomainAliasesDelete_580426;
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
  var path_580440 = newJObject()
  var query_580441 = newJObject()
  add(path_580440, "domainAliasName", newJString(domainAliasName))
  add(query_580441, "fields", newJString(fields))
  add(query_580441, "quotaUser", newJString(quotaUser))
  add(query_580441, "alt", newJString(alt))
  add(query_580441, "oauth_token", newJString(oauthToken))
  add(query_580441, "userIp", newJString(userIp))
  add(query_580441, "key", newJString(key))
  add(path_580440, "customer", newJString(customer))
  add(query_580441, "prettyPrint", newJBool(prettyPrint))
  result = call_580439.call(path_580440, query_580441, nil, nil, nil)

var directoryDomainAliasesDelete* = Call_DirectoryDomainAliasesDelete_580426(
    name: "directoryDomainAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domainaliases/{domainAliasName}",
    validator: validate_DirectoryDomainAliasesDelete_580427,
    base: "/admin/directory/v1", url: url_DirectoryDomainAliasesDelete_580428,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsInsert_580457 = ref object of OpenApiRestCall_579437
proc url_DirectoryDomainsInsert_580459(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryDomainsInsert_580458(path: JsonNode; query: JsonNode;
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
  var valid_580460 = path.getOrDefault("customer")
  valid_580460 = validateParameter(valid_580460, JString, required = true,
                                 default = nil)
  if valid_580460 != nil:
    section.add "customer", valid_580460
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
  var valid_580461 = query.getOrDefault("fields")
  valid_580461 = validateParameter(valid_580461, JString, required = false,
                                 default = nil)
  if valid_580461 != nil:
    section.add "fields", valid_580461
  var valid_580462 = query.getOrDefault("quotaUser")
  valid_580462 = validateParameter(valid_580462, JString, required = false,
                                 default = nil)
  if valid_580462 != nil:
    section.add "quotaUser", valid_580462
  var valid_580463 = query.getOrDefault("alt")
  valid_580463 = validateParameter(valid_580463, JString, required = false,
                                 default = newJString("json"))
  if valid_580463 != nil:
    section.add "alt", valid_580463
  var valid_580464 = query.getOrDefault("oauth_token")
  valid_580464 = validateParameter(valid_580464, JString, required = false,
                                 default = nil)
  if valid_580464 != nil:
    section.add "oauth_token", valid_580464
  var valid_580465 = query.getOrDefault("userIp")
  valid_580465 = validateParameter(valid_580465, JString, required = false,
                                 default = nil)
  if valid_580465 != nil:
    section.add "userIp", valid_580465
  var valid_580466 = query.getOrDefault("key")
  valid_580466 = validateParameter(valid_580466, JString, required = false,
                                 default = nil)
  if valid_580466 != nil:
    section.add "key", valid_580466
  var valid_580467 = query.getOrDefault("prettyPrint")
  valid_580467 = validateParameter(valid_580467, JBool, required = false,
                                 default = newJBool(true))
  if valid_580467 != nil:
    section.add "prettyPrint", valid_580467
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

proc call*(call_580469: Call_DirectoryDomainsInsert_580457; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Inserts a domain of the customer.
  ## 
  let valid = call_580469.validator(path, query, header, formData, body)
  let scheme = call_580469.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580469.url(scheme.get, call_580469.host, call_580469.base,
                         call_580469.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580469, url, valid)

proc call*(call_580470: Call_DirectoryDomainsInsert_580457; customer: string;
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
  var path_580471 = newJObject()
  var query_580472 = newJObject()
  var body_580473 = newJObject()
  add(query_580472, "fields", newJString(fields))
  add(query_580472, "quotaUser", newJString(quotaUser))
  add(query_580472, "alt", newJString(alt))
  add(query_580472, "oauth_token", newJString(oauthToken))
  add(query_580472, "userIp", newJString(userIp))
  add(query_580472, "key", newJString(key))
  add(path_580471, "customer", newJString(customer))
  if body != nil:
    body_580473 = body
  add(query_580472, "prettyPrint", newJBool(prettyPrint))
  result = call_580470.call(path_580471, query_580472, nil, nil, body_580473)

var directoryDomainsInsert* = Call_DirectoryDomainsInsert_580457(
    name: "directoryDomainsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsInsert_580458,
    base: "/admin/directory/v1", url: url_DirectoryDomainsInsert_580459,
    schemes: {Scheme.Https})
type
  Call_DirectoryDomainsList_580442 = ref object of OpenApiRestCall_579437
proc url_DirectoryDomainsList_580444(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryDomainsList_580443(path: JsonNode; query: JsonNode;
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
  var valid_580445 = path.getOrDefault("customer")
  valid_580445 = validateParameter(valid_580445, JString, required = true,
                                 default = nil)
  if valid_580445 != nil:
    section.add "customer", valid_580445
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
  var valid_580446 = query.getOrDefault("fields")
  valid_580446 = validateParameter(valid_580446, JString, required = false,
                                 default = nil)
  if valid_580446 != nil:
    section.add "fields", valid_580446
  var valid_580447 = query.getOrDefault("quotaUser")
  valid_580447 = validateParameter(valid_580447, JString, required = false,
                                 default = nil)
  if valid_580447 != nil:
    section.add "quotaUser", valid_580447
  var valid_580448 = query.getOrDefault("alt")
  valid_580448 = validateParameter(valid_580448, JString, required = false,
                                 default = newJString("json"))
  if valid_580448 != nil:
    section.add "alt", valid_580448
  var valid_580449 = query.getOrDefault("oauth_token")
  valid_580449 = validateParameter(valid_580449, JString, required = false,
                                 default = nil)
  if valid_580449 != nil:
    section.add "oauth_token", valid_580449
  var valid_580450 = query.getOrDefault("userIp")
  valid_580450 = validateParameter(valid_580450, JString, required = false,
                                 default = nil)
  if valid_580450 != nil:
    section.add "userIp", valid_580450
  var valid_580451 = query.getOrDefault("key")
  valid_580451 = validateParameter(valid_580451, JString, required = false,
                                 default = nil)
  if valid_580451 != nil:
    section.add "key", valid_580451
  var valid_580452 = query.getOrDefault("prettyPrint")
  valid_580452 = validateParameter(valid_580452, JBool, required = false,
                                 default = newJBool(true))
  if valid_580452 != nil:
    section.add "prettyPrint", valid_580452
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580453: Call_DirectoryDomainsList_580442; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists the domains of the customer.
  ## 
  let valid = call_580453.validator(path, query, header, formData, body)
  let scheme = call_580453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580453.url(scheme.get, call_580453.host, call_580453.base,
                         call_580453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580453, url, valid)

proc call*(call_580454: Call_DirectoryDomainsList_580442; customer: string;
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
  var path_580455 = newJObject()
  var query_580456 = newJObject()
  add(query_580456, "fields", newJString(fields))
  add(query_580456, "quotaUser", newJString(quotaUser))
  add(query_580456, "alt", newJString(alt))
  add(query_580456, "oauth_token", newJString(oauthToken))
  add(query_580456, "userIp", newJString(userIp))
  add(query_580456, "key", newJString(key))
  add(path_580455, "customer", newJString(customer))
  add(query_580456, "prettyPrint", newJBool(prettyPrint))
  result = call_580454.call(path_580455, query_580456, nil, nil, nil)

var directoryDomainsList* = Call_DirectoryDomainsList_580442(
    name: "directoryDomainsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/domains",
    validator: validate_DirectoryDomainsList_580443, base: "/admin/directory/v1",
    url: url_DirectoryDomainsList_580444, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsGet_580474 = ref object of OpenApiRestCall_579437
proc url_DirectoryDomainsGet_580476(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryDomainsGet_580475(path: JsonNode; query: JsonNode;
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
  var valid_580477 = path.getOrDefault("domainName")
  valid_580477 = validateParameter(valid_580477, JString, required = true,
                                 default = nil)
  if valid_580477 != nil:
    section.add "domainName", valid_580477
  var valid_580478 = path.getOrDefault("customer")
  valid_580478 = validateParameter(valid_580478, JString, required = true,
                                 default = nil)
  if valid_580478 != nil:
    section.add "customer", valid_580478
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
  var valid_580479 = query.getOrDefault("fields")
  valid_580479 = validateParameter(valid_580479, JString, required = false,
                                 default = nil)
  if valid_580479 != nil:
    section.add "fields", valid_580479
  var valid_580480 = query.getOrDefault("quotaUser")
  valid_580480 = validateParameter(valid_580480, JString, required = false,
                                 default = nil)
  if valid_580480 != nil:
    section.add "quotaUser", valid_580480
  var valid_580481 = query.getOrDefault("alt")
  valid_580481 = validateParameter(valid_580481, JString, required = false,
                                 default = newJString("json"))
  if valid_580481 != nil:
    section.add "alt", valid_580481
  var valid_580482 = query.getOrDefault("oauth_token")
  valid_580482 = validateParameter(valid_580482, JString, required = false,
                                 default = nil)
  if valid_580482 != nil:
    section.add "oauth_token", valid_580482
  var valid_580483 = query.getOrDefault("userIp")
  valid_580483 = validateParameter(valid_580483, JString, required = false,
                                 default = nil)
  if valid_580483 != nil:
    section.add "userIp", valid_580483
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580486: Call_DirectoryDomainsGet_580474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a domain of the customer.
  ## 
  let valid = call_580486.validator(path, query, header, formData, body)
  let scheme = call_580486.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580486.url(scheme.get, call_580486.host, call_580486.base,
                         call_580486.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580486, url, valid)

proc call*(call_580487: Call_DirectoryDomainsGet_580474; domainName: string;
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
  var path_580488 = newJObject()
  var query_580489 = newJObject()
  add(query_580489, "fields", newJString(fields))
  add(query_580489, "quotaUser", newJString(quotaUser))
  add(query_580489, "alt", newJString(alt))
  add(query_580489, "oauth_token", newJString(oauthToken))
  add(query_580489, "userIp", newJString(userIp))
  add(query_580489, "key", newJString(key))
  add(path_580488, "domainName", newJString(domainName))
  add(path_580488, "customer", newJString(customer))
  add(query_580489, "prettyPrint", newJBool(prettyPrint))
  result = call_580487.call(path_580488, query_580489, nil, nil, nil)

var directoryDomainsGet* = Call_DirectoryDomainsGet_580474(
    name: "directoryDomainsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsGet_580475, base: "/admin/directory/v1",
    url: url_DirectoryDomainsGet_580476, schemes: {Scheme.Https})
type
  Call_DirectoryDomainsDelete_580490 = ref object of OpenApiRestCall_579437
proc url_DirectoryDomainsDelete_580492(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryDomainsDelete_580491(path: JsonNode; query: JsonNode;
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
  var valid_580493 = path.getOrDefault("domainName")
  valid_580493 = validateParameter(valid_580493, JString, required = true,
                                 default = nil)
  if valid_580493 != nil:
    section.add "domainName", valid_580493
  var valid_580494 = path.getOrDefault("customer")
  valid_580494 = validateParameter(valid_580494, JString, required = true,
                                 default = nil)
  if valid_580494 != nil:
    section.add "customer", valid_580494
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
  var valid_580495 = query.getOrDefault("fields")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "fields", valid_580495
  var valid_580496 = query.getOrDefault("quotaUser")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "quotaUser", valid_580496
  var valid_580497 = query.getOrDefault("alt")
  valid_580497 = validateParameter(valid_580497, JString, required = false,
                                 default = newJString("json"))
  if valid_580497 != nil:
    section.add "alt", valid_580497
  var valid_580498 = query.getOrDefault("oauth_token")
  valid_580498 = validateParameter(valid_580498, JString, required = false,
                                 default = nil)
  if valid_580498 != nil:
    section.add "oauth_token", valid_580498
  var valid_580499 = query.getOrDefault("userIp")
  valid_580499 = validateParameter(valid_580499, JString, required = false,
                                 default = nil)
  if valid_580499 != nil:
    section.add "userIp", valid_580499
  var valid_580500 = query.getOrDefault("key")
  valid_580500 = validateParameter(valid_580500, JString, required = false,
                                 default = nil)
  if valid_580500 != nil:
    section.add "key", valid_580500
  var valid_580501 = query.getOrDefault("prettyPrint")
  valid_580501 = validateParameter(valid_580501, JBool, required = false,
                                 default = newJBool(true))
  if valid_580501 != nil:
    section.add "prettyPrint", valid_580501
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580502: Call_DirectoryDomainsDelete_580490; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a domain of the customer.
  ## 
  let valid = call_580502.validator(path, query, header, formData, body)
  let scheme = call_580502.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580502.url(scheme.get, call_580502.host, call_580502.base,
                         call_580502.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580502, url, valid)

proc call*(call_580503: Call_DirectoryDomainsDelete_580490; domainName: string;
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
  var path_580504 = newJObject()
  var query_580505 = newJObject()
  add(query_580505, "fields", newJString(fields))
  add(query_580505, "quotaUser", newJString(quotaUser))
  add(query_580505, "alt", newJString(alt))
  add(query_580505, "oauth_token", newJString(oauthToken))
  add(query_580505, "userIp", newJString(userIp))
  add(query_580505, "key", newJString(key))
  add(path_580504, "domainName", newJString(domainName))
  add(path_580504, "customer", newJString(customer))
  add(query_580505, "prettyPrint", newJBool(prettyPrint))
  result = call_580503.call(path_580504, query_580505, nil, nil, nil)

var directoryDomainsDelete* = Call_DirectoryDomainsDelete_580490(
    name: "directoryDomainsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/domains/{domainName}",
    validator: validate_DirectoryDomainsDelete_580491,
    base: "/admin/directory/v1", url: url_DirectoryDomainsDelete_580492,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsList_580506 = ref object of OpenApiRestCall_579437
proc url_DirectoryNotificationsList_580508(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsList_580507(path: JsonNode; query: JsonNode;
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
  var valid_580509 = path.getOrDefault("customer")
  valid_580509 = validateParameter(valid_580509, JString, required = true,
                                 default = nil)
  if valid_580509 != nil:
    section.add "customer", valid_580509
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
  var valid_580510 = query.getOrDefault("fields")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "fields", valid_580510
  var valid_580511 = query.getOrDefault("pageToken")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "pageToken", valid_580511
  var valid_580512 = query.getOrDefault("quotaUser")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = nil)
  if valid_580512 != nil:
    section.add "quotaUser", valid_580512
  var valid_580513 = query.getOrDefault("alt")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = newJString("json"))
  if valid_580513 != nil:
    section.add "alt", valid_580513
  var valid_580514 = query.getOrDefault("language")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "language", valid_580514
  var valid_580515 = query.getOrDefault("oauth_token")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "oauth_token", valid_580515
  var valid_580516 = query.getOrDefault("userIp")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "userIp", valid_580516
  var valid_580517 = query.getOrDefault("maxResults")
  valid_580517 = validateParameter(valid_580517, JInt, required = false, default = nil)
  if valid_580517 != nil:
    section.add "maxResults", valid_580517
  var valid_580518 = query.getOrDefault("key")
  valid_580518 = validateParameter(valid_580518, JString, required = false,
                                 default = nil)
  if valid_580518 != nil:
    section.add "key", valid_580518
  var valid_580519 = query.getOrDefault("prettyPrint")
  valid_580519 = validateParameter(valid_580519, JBool, required = false,
                                 default = newJBool(true))
  if valid_580519 != nil:
    section.add "prettyPrint", valid_580519
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580520: Call_DirectoryNotificationsList_580506; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notifications.
  ## 
  let valid = call_580520.validator(path, query, header, formData, body)
  let scheme = call_580520.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580520.url(scheme.get, call_580520.host, call_580520.base,
                         call_580520.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580520, url, valid)

proc call*(call_580521: Call_DirectoryNotificationsList_580506; customer: string;
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
  var path_580522 = newJObject()
  var query_580523 = newJObject()
  add(query_580523, "fields", newJString(fields))
  add(query_580523, "pageToken", newJString(pageToken))
  add(query_580523, "quotaUser", newJString(quotaUser))
  add(query_580523, "alt", newJString(alt))
  add(query_580523, "language", newJString(language))
  add(query_580523, "oauth_token", newJString(oauthToken))
  add(query_580523, "userIp", newJString(userIp))
  add(query_580523, "maxResults", newJInt(maxResults))
  add(query_580523, "key", newJString(key))
  add(path_580522, "customer", newJString(customer))
  add(query_580523, "prettyPrint", newJBool(prettyPrint))
  result = call_580521.call(path_580522, query_580523, nil, nil, nil)

var directoryNotificationsList* = Call_DirectoryNotificationsList_580506(
    name: "directoryNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/notifications",
    validator: validate_DirectoryNotificationsList_580507,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsList_580508,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsUpdate_580540 = ref object of OpenApiRestCall_579437
proc url_DirectoryNotificationsUpdate_580542(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsUpdate_580541(path: JsonNode; query: JsonNode;
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
  var valid_580543 = path.getOrDefault("notificationId")
  valid_580543 = validateParameter(valid_580543, JString, required = true,
                                 default = nil)
  if valid_580543 != nil:
    section.add "notificationId", valid_580543
  var valid_580544 = path.getOrDefault("customer")
  valid_580544 = validateParameter(valid_580544, JString, required = true,
                                 default = nil)
  if valid_580544 != nil:
    section.add "customer", valid_580544
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
  var valid_580545 = query.getOrDefault("fields")
  valid_580545 = validateParameter(valid_580545, JString, required = false,
                                 default = nil)
  if valid_580545 != nil:
    section.add "fields", valid_580545
  var valid_580546 = query.getOrDefault("quotaUser")
  valid_580546 = validateParameter(valid_580546, JString, required = false,
                                 default = nil)
  if valid_580546 != nil:
    section.add "quotaUser", valid_580546
  var valid_580547 = query.getOrDefault("alt")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = newJString("json"))
  if valid_580547 != nil:
    section.add "alt", valid_580547
  var valid_580548 = query.getOrDefault("oauth_token")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "oauth_token", valid_580548
  var valid_580549 = query.getOrDefault("userIp")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "userIp", valid_580549
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

proc call*(call_580553: Call_DirectoryNotificationsUpdate_580540; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification.
  ## 
  let valid = call_580553.validator(path, query, header, formData, body)
  let scheme = call_580553.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580553.url(scheme.get, call_580553.host, call_580553.base,
                         call_580553.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580553, url, valid)

proc call*(call_580554: Call_DirectoryNotificationsUpdate_580540;
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
  var path_580555 = newJObject()
  var query_580556 = newJObject()
  var body_580557 = newJObject()
  add(query_580556, "fields", newJString(fields))
  add(query_580556, "quotaUser", newJString(quotaUser))
  add(query_580556, "alt", newJString(alt))
  add(path_580555, "notificationId", newJString(notificationId))
  add(query_580556, "oauth_token", newJString(oauthToken))
  add(query_580556, "userIp", newJString(userIp))
  add(query_580556, "key", newJString(key))
  add(path_580555, "customer", newJString(customer))
  if body != nil:
    body_580557 = body
  add(query_580556, "prettyPrint", newJBool(prettyPrint))
  result = call_580554.call(path_580555, query_580556, nil, nil, body_580557)

var directoryNotificationsUpdate* = Call_DirectoryNotificationsUpdate_580540(
    name: "directoryNotificationsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsUpdate_580541,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsUpdate_580542,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsGet_580524 = ref object of OpenApiRestCall_579437
proc url_DirectoryNotificationsGet_580526(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsGet_580525(path: JsonNode; query: JsonNode;
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
  var valid_580527 = path.getOrDefault("notificationId")
  valid_580527 = validateParameter(valid_580527, JString, required = true,
                                 default = nil)
  if valid_580527 != nil:
    section.add "notificationId", valid_580527
  var valid_580528 = path.getOrDefault("customer")
  valid_580528 = validateParameter(valid_580528, JString, required = true,
                                 default = nil)
  if valid_580528 != nil:
    section.add "customer", valid_580528
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
  var valid_580529 = query.getOrDefault("fields")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "fields", valid_580529
  var valid_580530 = query.getOrDefault("quotaUser")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = nil)
  if valid_580530 != nil:
    section.add "quotaUser", valid_580530
  var valid_580531 = query.getOrDefault("alt")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = newJString("json"))
  if valid_580531 != nil:
    section.add "alt", valid_580531
  var valid_580532 = query.getOrDefault("oauth_token")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "oauth_token", valid_580532
  var valid_580533 = query.getOrDefault("userIp")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "userIp", valid_580533
  var valid_580534 = query.getOrDefault("key")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "key", valid_580534
  var valid_580535 = query.getOrDefault("prettyPrint")
  valid_580535 = validateParameter(valid_580535, JBool, required = false,
                                 default = newJBool(true))
  if valid_580535 != nil:
    section.add "prettyPrint", valid_580535
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580536: Call_DirectoryNotificationsGet_580524; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a notification.
  ## 
  let valid = call_580536.validator(path, query, header, formData, body)
  let scheme = call_580536.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580536.url(scheme.get, call_580536.host, call_580536.base,
                         call_580536.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580536, url, valid)

proc call*(call_580537: Call_DirectoryNotificationsGet_580524;
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
  var path_580538 = newJObject()
  var query_580539 = newJObject()
  add(query_580539, "fields", newJString(fields))
  add(query_580539, "quotaUser", newJString(quotaUser))
  add(query_580539, "alt", newJString(alt))
  add(path_580538, "notificationId", newJString(notificationId))
  add(query_580539, "oauth_token", newJString(oauthToken))
  add(query_580539, "userIp", newJString(userIp))
  add(query_580539, "key", newJString(key))
  add(path_580538, "customer", newJString(customer))
  add(query_580539, "prettyPrint", newJBool(prettyPrint))
  result = call_580537.call(path_580538, query_580539, nil, nil, nil)

var directoryNotificationsGet* = Call_DirectoryNotificationsGet_580524(
    name: "directoryNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsGet_580525,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsGet_580526,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsPatch_580574 = ref object of OpenApiRestCall_579437
proc url_DirectoryNotificationsPatch_580576(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsPatch_580575(path: JsonNode; query: JsonNode;
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
  var valid_580577 = path.getOrDefault("notificationId")
  valid_580577 = validateParameter(valid_580577, JString, required = true,
                                 default = nil)
  if valid_580577 != nil:
    section.add "notificationId", valid_580577
  var valid_580578 = path.getOrDefault("customer")
  valid_580578 = validateParameter(valid_580578, JString, required = true,
                                 default = nil)
  if valid_580578 != nil:
    section.add "customer", valid_580578
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
  var valid_580579 = query.getOrDefault("fields")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "fields", valid_580579
  var valid_580580 = query.getOrDefault("quotaUser")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "quotaUser", valid_580580
  var valid_580581 = query.getOrDefault("alt")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = newJString("json"))
  if valid_580581 != nil:
    section.add "alt", valid_580581
  var valid_580582 = query.getOrDefault("oauth_token")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "oauth_token", valid_580582
  var valid_580583 = query.getOrDefault("userIp")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "userIp", valid_580583
  var valid_580584 = query.getOrDefault("key")
  valid_580584 = validateParameter(valid_580584, JString, required = false,
                                 default = nil)
  if valid_580584 != nil:
    section.add "key", valid_580584
  var valid_580585 = query.getOrDefault("prettyPrint")
  valid_580585 = validateParameter(valid_580585, JBool, required = false,
                                 default = newJBool(true))
  if valid_580585 != nil:
    section.add "prettyPrint", valid_580585
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

proc call*(call_580587: Call_DirectoryNotificationsPatch_580574; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a notification. This method supports patch semantics.
  ## 
  let valid = call_580587.validator(path, query, header, formData, body)
  let scheme = call_580587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580587.url(scheme.get, call_580587.host, call_580587.base,
                         call_580587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580587, url, valid)

proc call*(call_580588: Call_DirectoryNotificationsPatch_580574;
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
  var path_580589 = newJObject()
  var query_580590 = newJObject()
  var body_580591 = newJObject()
  add(query_580590, "fields", newJString(fields))
  add(query_580590, "quotaUser", newJString(quotaUser))
  add(query_580590, "alt", newJString(alt))
  add(path_580589, "notificationId", newJString(notificationId))
  add(query_580590, "oauth_token", newJString(oauthToken))
  add(query_580590, "userIp", newJString(userIp))
  add(query_580590, "key", newJString(key))
  add(path_580589, "customer", newJString(customer))
  if body != nil:
    body_580591 = body
  add(query_580590, "prettyPrint", newJBool(prettyPrint))
  result = call_580588.call(path_580589, query_580590, nil, nil, body_580591)

var directoryNotificationsPatch* = Call_DirectoryNotificationsPatch_580574(
    name: "directoryNotificationsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsPatch_580575,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsPatch_580576,
    schemes: {Scheme.Https})
type
  Call_DirectoryNotificationsDelete_580558 = ref object of OpenApiRestCall_579437
proc url_DirectoryNotificationsDelete_580560(protocol: Scheme; host: string;
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

proc validate_DirectoryNotificationsDelete_580559(path: JsonNode; query: JsonNode;
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
  var valid_580561 = path.getOrDefault("notificationId")
  valid_580561 = validateParameter(valid_580561, JString, required = true,
                                 default = nil)
  if valid_580561 != nil:
    section.add "notificationId", valid_580561
  var valid_580562 = path.getOrDefault("customer")
  valid_580562 = validateParameter(valid_580562, JString, required = true,
                                 default = nil)
  if valid_580562 != nil:
    section.add "customer", valid_580562
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
  var valid_580563 = query.getOrDefault("fields")
  valid_580563 = validateParameter(valid_580563, JString, required = false,
                                 default = nil)
  if valid_580563 != nil:
    section.add "fields", valid_580563
  var valid_580564 = query.getOrDefault("quotaUser")
  valid_580564 = validateParameter(valid_580564, JString, required = false,
                                 default = nil)
  if valid_580564 != nil:
    section.add "quotaUser", valid_580564
  var valid_580565 = query.getOrDefault("alt")
  valid_580565 = validateParameter(valid_580565, JString, required = false,
                                 default = newJString("json"))
  if valid_580565 != nil:
    section.add "alt", valid_580565
  var valid_580566 = query.getOrDefault("oauth_token")
  valid_580566 = validateParameter(valid_580566, JString, required = false,
                                 default = nil)
  if valid_580566 != nil:
    section.add "oauth_token", valid_580566
  var valid_580567 = query.getOrDefault("userIp")
  valid_580567 = validateParameter(valid_580567, JString, required = false,
                                 default = nil)
  if valid_580567 != nil:
    section.add "userIp", valid_580567
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580570: Call_DirectoryNotificationsDelete_580558; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a notification
  ## 
  let valid = call_580570.validator(path, query, header, formData, body)
  let scheme = call_580570.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580570.url(scheme.get, call_580570.host, call_580570.base,
                         call_580570.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580570, url, valid)

proc call*(call_580571: Call_DirectoryNotificationsDelete_580558;
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
  var path_580572 = newJObject()
  var query_580573 = newJObject()
  add(query_580573, "fields", newJString(fields))
  add(query_580573, "quotaUser", newJString(quotaUser))
  add(query_580573, "alt", newJString(alt))
  add(path_580572, "notificationId", newJString(notificationId))
  add(query_580573, "oauth_token", newJString(oauthToken))
  add(query_580573, "userIp", newJString(userIp))
  add(query_580573, "key", newJString(key))
  add(path_580572, "customer", newJString(customer))
  add(query_580573, "prettyPrint", newJBool(prettyPrint))
  result = call_580571.call(path_580572, query_580573, nil, nil, nil)

var directoryNotificationsDelete* = Call_DirectoryNotificationsDelete_580558(
    name: "directoryNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/notifications/{notificationId}",
    validator: validate_DirectoryNotificationsDelete_580559,
    base: "/admin/directory/v1", url: url_DirectoryNotificationsDelete_580560,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsInsert_580609 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesBuildingsInsert_580611(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsInsert_580610(path: JsonNode;
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
  var valid_580612 = path.getOrDefault("customer")
  valid_580612 = validateParameter(valid_580612, JString, required = true,
                                 default = nil)
  if valid_580612 != nil:
    section.add "customer", valid_580612
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
  var valid_580613 = query.getOrDefault("fields")
  valid_580613 = validateParameter(valid_580613, JString, required = false,
                                 default = nil)
  if valid_580613 != nil:
    section.add "fields", valid_580613
  var valid_580614 = query.getOrDefault("quotaUser")
  valid_580614 = validateParameter(valid_580614, JString, required = false,
                                 default = nil)
  if valid_580614 != nil:
    section.add "quotaUser", valid_580614
  var valid_580615 = query.getOrDefault("coordinatesSource")
  valid_580615 = validateParameter(valid_580615, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_580615 != nil:
    section.add "coordinatesSource", valid_580615
  var valid_580616 = query.getOrDefault("alt")
  valid_580616 = validateParameter(valid_580616, JString, required = false,
                                 default = newJString("json"))
  if valid_580616 != nil:
    section.add "alt", valid_580616
  var valid_580617 = query.getOrDefault("oauth_token")
  valid_580617 = validateParameter(valid_580617, JString, required = false,
                                 default = nil)
  if valid_580617 != nil:
    section.add "oauth_token", valid_580617
  var valid_580618 = query.getOrDefault("userIp")
  valid_580618 = validateParameter(valid_580618, JString, required = false,
                                 default = nil)
  if valid_580618 != nil:
    section.add "userIp", valid_580618
  var valid_580619 = query.getOrDefault("key")
  valid_580619 = validateParameter(valid_580619, JString, required = false,
                                 default = nil)
  if valid_580619 != nil:
    section.add "key", valid_580619
  var valid_580620 = query.getOrDefault("prettyPrint")
  valid_580620 = validateParameter(valid_580620, JBool, required = false,
                                 default = newJBool(true))
  if valid_580620 != nil:
    section.add "prettyPrint", valid_580620
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

proc call*(call_580622: Call_DirectoryResourcesBuildingsInsert_580609;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a building.
  ## 
  let valid = call_580622.validator(path, query, header, formData, body)
  let scheme = call_580622.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580622.url(scheme.get, call_580622.host, call_580622.base,
                         call_580622.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580622, url, valid)

proc call*(call_580623: Call_DirectoryResourcesBuildingsInsert_580609;
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
  var path_580624 = newJObject()
  var query_580625 = newJObject()
  var body_580626 = newJObject()
  add(query_580625, "fields", newJString(fields))
  add(query_580625, "quotaUser", newJString(quotaUser))
  add(query_580625, "coordinatesSource", newJString(coordinatesSource))
  add(query_580625, "alt", newJString(alt))
  add(query_580625, "oauth_token", newJString(oauthToken))
  add(query_580625, "userIp", newJString(userIp))
  add(query_580625, "key", newJString(key))
  add(path_580624, "customer", newJString(customer))
  if body != nil:
    body_580626 = body
  add(query_580625, "prettyPrint", newJBool(prettyPrint))
  result = call_580623.call(path_580624, query_580625, nil, nil, body_580626)

var directoryResourcesBuildingsInsert* = Call_DirectoryResourcesBuildingsInsert_580609(
    name: "directoryResourcesBuildingsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsInsert_580610,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsInsert_580611,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsList_580592 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesBuildingsList_580594(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsList_580593(path: JsonNode;
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
  var valid_580595 = path.getOrDefault("customer")
  valid_580595 = validateParameter(valid_580595, JString, required = true,
                                 default = nil)
  if valid_580595 != nil:
    section.add "customer", valid_580595
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
  var valid_580596 = query.getOrDefault("fields")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "fields", valid_580596
  var valid_580597 = query.getOrDefault("pageToken")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = nil)
  if valid_580597 != nil:
    section.add "pageToken", valid_580597
  var valid_580598 = query.getOrDefault("quotaUser")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "quotaUser", valid_580598
  var valid_580599 = query.getOrDefault("alt")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = newJString("json"))
  if valid_580599 != nil:
    section.add "alt", valid_580599
  var valid_580600 = query.getOrDefault("oauth_token")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "oauth_token", valid_580600
  var valid_580601 = query.getOrDefault("userIp")
  valid_580601 = validateParameter(valid_580601, JString, required = false,
                                 default = nil)
  if valid_580601 != nil:
    section.add "userIp", valid_580601
  var valid_580602 = query.getOrDefault("maxResults")
  valid_580602 = validateParameter(valid_580602, JInt, required = false, default = nil)
  if valid_580602 != nil:
    section.add "maxResults", valid_580602
  var valid_580603 = query.getOrDefault("key")
  valid_580603 = validateParameter(valid_580603, JString, required = false,
                                 default = nil)
  if valid_580603 != nil:
    section.add "key", valid_580603
  var valid_580604 = query.getOrDefault("prettyPrint")
  valid_580604 = validateParameter(valid_580604, JBool, required = false,
                                 default = newJBool(true))
  if valid_580604 != nil:
    section.add "prettyPrint", valid_580604
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580605: Call_DirectoryResourcesBuildingsList_580592;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of buildings for an account.
  ## 
  let valid = call_580605.validator(path, query, header, formData, body)
  let scheme = call_580605.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580605.url(scheme.get, call_580605.host, call_580605.base,
                         call_580605.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580605, url, valid)

proc call*(call_580606: Call_DirectoryResourcesBuildingsList_580592;
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
  var path_580607 = newJObject()
  var query_580608 = newJObject()
  add(query_580608, "fields", newJString(fields))
  add(query_580608, "pageToken", newJString(pageToken))
  add(query_580608, "quotaUser", newJString(quotaUser))
  add(query_580608, "alt", newJString(alt))
  add(query_580608, "oauth_token", newJString(oauthToken))
  add(query_580608, "userIp", newJString(userIp))
  add(query_580608, "maxResults", newJInt(maxResults))
  add(query_580608, "key", newJString(key))
  add(path_580607, "customer", newJString(customer))
  add(query_580608, "prettyPrint", newJBool(prettyPrint))
  result = call_580606.call(path_580607, query_580608, nil, nil, nil)

var directoryResourcesBuildingsList* = Call_DirectoryResourcesBuildingsList_580592(
    name: "directoryResourcesBuildingsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/buildings",
    validator: validate_DirectoryResourcesBuildingsList_580593,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsList_580594,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsUpdate_580643 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesBuildingsUpdate_580645(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsUpdate_580644(path: JsonNode;
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
  var valid_580646 = path.getOrDefault("buildingId")
  valid_580646 = validateParameter(valid_580646, JString, required = true,
                                 default = nil)
  if valid_580646 != nil:
    section.add "buildingId", valid_580646
  var valid_580647 = path.getOrDefault("customer")
  valid_580647 = validateParameter(valid_580647, JString, required = true,
                                 default = nil)
  if valid_580647 != nil:
    section.add "customer", valid_580647
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
  var valid_580648 = query.getOrDefault("fields")
  valid_580648 = validateParameter(valid_580648, JString, required = false,
                                 default = nil)
  if valid_580648 != nil:
    section.add "fields", valid_580648
  var valid_580649 = query.getOrDefault("quotaUser")
  valid_580649 = validateParameter(valid_580649, JString, required = false,
                                 default = nil)
  if valid_580649 != nil:
    section.add "quotaUser", valid_580649
  var valid_580650 = query.getOrDefault("coordinatesSource")
  valid_580650 = validateParameter(valid_580650, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_580650 != nil:
    section.add "coordinatesSource", valid_580650
  var valid_580651 = query.getOrDefault("alt")
  valid_580651 = validateParameter(valid_580651, JString, required = false,
                                 default = newJString("json"))
  if valid_580651 != nil:
    section.add "alt", valid_580651
  var valid_580652 = query.getOrDefault("oauth_token")
  valid_580652 = validateParameter(valid_580652, JString, required = false,
                                 default = nil)
  if valid_580652 != nil:
    section.add "oauth_token", valid_580652
  var valid_580653 = query.getOrDefault("userIp")
  valid_580653 = validateParameter(valid_580653, JString, required = false,
                                 default = nil)
  if valid_580653 != nil:
    section.add "userIp", valid_580653
  var valid_580654 = query.getOrDefault("key")
  valid_580654 = validateParameter(valid_580654, JString, required = false,
                                 default = nil)
  if valid_580654 != nil:
    section.add "key", valid_580654
  var valid_580655 = query.getOrDefault("prettyPrint")
  valid_580655 = validateParameter(valid_580655, JBool, required = false,
                                 default = newJBool(true))
  if valid_580655 != nil:
    section.add "prettyPrint", valid_580655
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

proc call*(call_580657: Call_DirectoryResourcesBuildingsUpdate_580643;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building.
  ## 
  let valid = call_580657.validator(path, query, header, formData, body)
  let scheme = call_580657.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580657.url(scheme.get, call_580657.host, call_580657.base,
                         call_580657.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580657, url, valid)

proc call*(call_580658: Call_DirectoryResourcesBuildingsUpdate_580643;
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
  var path_580659 = newJObject()
  var query_580660 = newJObject()
  var body_580661 = newJObject()
  add(query_580660, "fields", newJString(fields))
  add(query_580660, "quotaUser", newJString(quotaUser))
  add(query_580660, "coordinatesSource", newJString(coordinatesSource))
  add(path_580659, "buildingId", newJString(buildingId))
  add(query_580660, "alt", newJString(alt))
  add(query_580660, "oauth_token", newJString(oauthToken))
  add(query_580660, "userIp", newJString(userIp))
  add(query_580660, "key", newJString(key))
  add(path_580659, "customer", newJString(customer))
  if body != nil:
    body_580661 = body
  add(query_580660, "prettyPrint", newJBool(prettyPrint))
  result = call_580658.call(path_580659, query_580660, nil, nil, body_580661)

var directoryResourcesBuildingsUpdate* = Call_DirectoryResourcesBuildingsUpdate_580643(
    name: "directoryResourcesBuildingsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsUpdate_580644,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsUpdate_580645,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsGet_580627 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesBuildingsGet_580629(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsGet_580628(path: JsonNode;
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
  var valid_580630 = path.getOrDefault("buildingId")
  valid_580630 = validateParameter(valid_580630, JString, required = true,
                                 default = nil)
  if valid_580630 != nil:
    section.add "buildingId", valid_580630
  var valid_580631 = path.getOrDefault("customer")
  valid_580631 = validateParameter(valid_580631, JString, required = true,
                                 default = nil)
  if valid_580631 != nil:
    section.add "customer", valid_580631
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
  var valid_580632 = query.getOrDefault("fields")
  valid_580632 = validateParameter(valid_580632, JString, required = false,
                                 default = nil)
  if valid_580632 != nil:
    section.add "fields", valid_580632
  var valid_580633 = query.getOrDefault("quotaUser")
  valid_580633 = validateParameter(valid_580633, JString, required = false,
                                 default = nil)
  if valid_580633 != nil:
    section.add "quotaUser", valid_580633
  var valid_580634 = query.getOrDefault("alt")
  valid_580634 = validateParameter(valid_580634, JString, required = false,
                                 default = newJString("json"))
  if valid_580634 != nil:
    section.add "alt", valid_580634
  var valid_580635 = query.getOrDefault("oauth_token")
  valid_580635 = validateParameter(valid_580635, JString, required = false,
                                 default = nil)
  if valid_580635 != nil:
    section.add "oauth_token", valid_580635
  var valid_580636 = query.getOrDefault("userIp")
  valid_580636 = validateParameter(valid_580636, JString, required = false,
                                 default = nil)
  if valid_580636 != nil:
    section.add "userIp", valid_580636
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580639: Call_DirectoryResourcesBuildingsGet_580627; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a building.
  ## 
  let valid = call_580639.validator(path, query, header, formData, body)
  let scheme = call_580639.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580639.url(scheme.get, call_580639.host, call_580639.base,
                         call_580639.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580639, url, valid)

proc call*(call_580640: Call_DirectoryResourcesBuildingsGet_580627;
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
  var path_580641 = newJObject()
  var query_580642 = newJObject()
  add(query_580642, "fields", newJString(fields))
  add(query_580642, "quotaUser", newJString(quotaUser))
  add(path_580641, "buildingId", newJString(buildingId))
  add(query_580642, "alt", newJString(alt))
  add(query_580642, "oauth_token", newJString(oauthToken))
  add(query_580642, "userIp", newJString(userIp))
  add(query_580642, "key", newJString(key))
  add(path_580641, "customer", newJString(customer))
  add(query_580642, "prettyPrint", newJBool(prettyPrint))
  result = call_580640.call(path_580641, query_580642, nil, nil, nil)

var directoryResourcesBuildingsGet* = Call_DirectoryResourcesBuildingsGet_580627(
    name: "directoryResourcesBuildingsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsGet_580628,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsGet_580629,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsPatch_580678 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesBuildingsPatch_580680(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsPatch_580679(path: JsonNode;
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
  var valid_580681 = path.getOrDefault("buildingId")
  valid_580681 = validateParameter(valid_580681, JString, required = true,
                                 default = nil)
  if valid_580681 != nil:
    section.add "buildingId", valid_580681
  var valid_580682 = path.getOrDefault("customer")
  valid_580682 = validateParameter(valid_580682, JString, required = true,
                                 default = nil)
  if valid_580682 != nil:
    section.add "customer", valid_580682
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
  var valid_580683 = query.getOrDefault("fields")
  valid_580683 = validateParameter(valid_580683, JString, required = false,
                                 default = nil)
  if valid_580683 != nil:
    section.add "fields", valid_580683
  var valid_580684 = query.getOrDefault("quotaUser")
  valid_580684 = validateParameter(valid_580684, JString, required = false,
                                 default = nil)
  if valid_580684 != nil:
    section.add "quotaUser", valid_580684
  var valid_580685 = query.getOrDefault("coordinatesSource")
  valid_580685 = validateParameter(valid_580685, JString, required = false,
                                 default = newJString("SOURCE_UNSPECIFIED"))
  if valid_580685 != nil:
    section.add "coordinatesSource", valid_580685
  var valid_580686 = query.getOrDefault("alt")
  valid_580686 = validateParameter(valid_580686, JString, required = false,
                                 default = newJString("json"))
  if valid_580686 != nil:
    section.add "alt", valid_580686
  var valid_580687 = query.getOrDefault("oauth_token")
  valid_580687 = validateParameter(valid_580687, JString, required = false,
                                 default = nil)
  if valid_580687 != nil:
    section.add "oauth_token", valid_580687
  var valid_580688 = query.getOrDefault("userIp")
  valid_580688 = validateParameter(valid_580688, JString, required = false,
                                 default = nil)
  if valid_580688 != nil:
    section.add "userIp", valid_580688
  var valid_580689 = query.getOrDefault("key")
  valid_580689 = validateParameter(valid_580689, JString, required = false,
                                 default = nil)
  if valid_580689 != nil:
    section.add "key", valid_580689
  var valid_580690 = query.getOrDefault("prettyPrint")
  valid_580690 = validateParameter(valid_580690, JBool, required = false,
                                 default = newJBool(true))
  if valid_580690 != nil:
    section.add "prettyPrint", valid_580690
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

proc call*(call_580692: Call_DirectoryResourcesBuildingsPatch_580678;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a building. This method supports patch semantics.
  ## 
  let valid = call_580692.validator(path, query, header, formData, body)
  let scheme = call_580692.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580692.url(scheme.get, call_580692.host, call_580692.base,
                         call_580692.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580692, url, valid)

proc call*(call_580693: Call_DirectoryResourcesBuildingsPatch_580678;
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
  var path_580694 = newJObject()
  var query_580695 = newJObject()
  var body_580696 = newJObject()
  add(query_580695, "fields", newJString(fields))
  add(query_580695, "quotaUser", newJString(quotaUser))
  add(query_580695, "coordinatesSource", newJString(coordinatesSource))
  add(path_580694, "buildingId", newJString(buildingId))
  add(query_580695, "alt", newJString(alt))
  add(query_580695, "oauth_token", newJString(oauthToken))
  add(query_580695, "userIp", newJString(userIp))
  add(query_580695, "key", newJString(key))
  add(path_580694, "customer", newJString(customer))
  if body != nil:
    body_580696 = body
  add(query_580695, "prettyPrint", newJBool(prettyPrint))
  result = call_580693.call(path_580694, query_580695, nil, nil, body_580696)

var directoryResourcesBuildingsPatch* = Call_DirectoryResourcesBuildingsPatch_580678(
    name: "directoryResourcesBuildingsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsPatch_580679,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsPatch_580680,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesBuildingsDelete_580662 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesBuildingsDelete_580664(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesBuildingsDelete_580663(path: JsonNode;
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
  var valid_580665 = path.getOrDefault("buildingId")
  valid_580665 = validateParameter(valid_580665, JString, required = true,
                                 default = nil)
  if valid_580665 != nil:
    section.add "buildingId", valid_580665
  var valid_580666 = path.getOrDefault("customer")
  valid_580666 = validateParameter(valid_580666, JString, required = true,
                                 default = nil)
  if valid_580666 != nil:
    section.add "customer", valid_580666
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
  var valid_580667 = query.getOrDefault("fields")
  valid_580667 = validateParameter(valid_580667, JString, required = false,
                                 default = nil)
  if valid_580667 != nil:
    section.add "fields", valid_580667
  var valid_580668 = query.getOrDefault("quotaUser")
  valid_580668 = validateParameter(valid_580668, JString, required = false,
                                 default = nil)
  if valid_580668 != nil:
    section.add "quotaUser", valid_580668
  var valid_580669 = query.getOrDefault("alt")
  valid_580669 = validateParameter(valid_580669, JString, required = false,
                                 default = newJString("json"))
  if valid_580669 != nil:
    section.add "alt", valid_580669
  var valid_580670 = query.getOrDefault("oauth_token")
  valid_580670 = validateParameter(valid_580670, JString, required = false,
                                 default = nil)
  if valid_580670 != nil:
    section.add "oauth_token", valid_580670
  var valid_580671 = query.getOrDefault("userIp")
  valid_580671 = validateParameter(valid_580671, JString, required = false,
                                 default = nil)
  if valid_580671 != nil:
    section.add "userIp", valid_580671
  var valid_580672 = query.getOrDefault("key")
  valid_580672 = validateParameter(valid_580672, JString, required = false,
                                 default = nil)
  if valid_580672 != nil:
    section.add "key", valid_580672
  var valid_580673 = query.getOrDefault("prettyPrint")
  valid_580673 = validateParameter(valid_580673, JBool, required = false,
                                 default = newJBool(true))
  if valid_580673 != nil:
    section.add "prettyPrint", valid_580673
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580674: Call_DirectoryResourcesBuildingsDelete_580662;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a building.
  ## 
  let valid = call_580674.validator(path, query, header, formData, body)
  let scheme = call_580674.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580674.url(scheme.get, call_580674.host, call_580674.base,
                         call_580674.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580674, url, valid)

proc call*(call_580675: Call_DirectoryResourcesBuildingsDelete_580662;
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
  var path_580676 = newJObject()
  var query_580677 = newJObject()
  add(query_580677, "fields", newJString(fields))
  add(query_580677, "quotaUser", newJString(quotaUser))
  add(path_580676, "buildingId", newJString(buildingId))
  add(query_580677, "alt", newJString(alt))
  add(query_580677, "oauth_token", newJString(oauthToken))
  add(query_580677, "userIp", newJString(userIp))
  add(query_580677, "key", newJString(key))
  add(path_580676, "customer", newJString(customer))
  add(query_580677, "prettyPrint", newJBool(prettyPrint))
  result = call_580675.call(path_580676, query_580677, nil, nil, nil)

var directoryResourcesBuildingsDelete* = Call_DirectoryResourcesBuildingsDelete_580662(
    name: "directoryResourcesBuildingsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/buildings/{buildingId}",
    validator: validate_DirectoryResourcesBuildingsDelete_580663,
    base: "/admin/directory/v1", url: url_DirectoryResourcesBuildingsDelete_580664,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsInsert_580716 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesCalendarsInsert_580718(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsInsert_580717(path: JsonNode;
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
  var valid_580719 = path.getOrDefault("customer")
  valid_580719 = validateParameter(valid_580719, JString, required = true,
                                 default = nil)
  if valid_580719 != nil:
    section.add "customer", valid_580719
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
  var valid_580720 = query.getOrDefault("fields")
  valid_580720 = validateParameter(valid_580720, JString, required = false,
                                 default = nil)
  if valid_580720 != nil:
    section.add "fields", valid_580720
  var valid_580721 = query.getOrDefault("quotaUser")
  valid_580721 = validateParameter(valid_580721, JString, required = false,
                                 default = nil)
  if valid_580721 != nil:
    section.add "quotaUser", valid_580721
  var valid_580722 = query.getOrDefault("alt")
  valid_580722 = validateParameter(valid_580722, JString, required = false,
                                 default = newJString("json"))
  if valid_580722 != nil:
    section.add "alt", valid_580722
  var valid_580723 = query.getOrDefault("oauth_token")
  valid_580723 = validateParameter(valid_580723, JString, required = false,
                                 default = nil)
  if valid_580723 != nil:
    section.add "oauth_token", valid_580723
  var valid_580724 = query.getOrDefault("userIp")
  valid_580724 = validateParameter(valid_580724, JString, required = false,
                                 default = nil)
  if valid_580724 != nil:
    section.add "userIp", valid_580724
  var valid_580725 = query.getOrDefault("key")
  valid_580725 = validateParameter(valid_580725, JString, required = false,
                                 default = nil)
  if valid_580725 != nil:
    section.add "key", valid_580725
  var valid_580726 = query.getOrDefault("prettyPrint")
  valid_580726 = validateParameter(valid_580726, JBool, required = false,
                                 default = newJBool(true))
  if valid_580726 != nil:
    section.add "prettyPrint", valid_580726
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

proc call*(call_580728: Call_DirectoryResourcesCalendarsInsert_580716;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a calendar resource.
  ## 
  let valid = call_580728.validator(path, query, header, formData, body)
  let scheme = call_580728.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580728.url(scheme.get, call_580728.host, call_580728.base,
                         call_580728.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580728, url, valid)

proc call*(call_580729: Call_DirectoryResourcesCalendarsInsert_580716;
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
  var path_580730 = newJObject()
  var query_580731 = newJObject()
  var body_580732 = newJObject()
  add(query_580731, "fields", newJString(fields))
  add(query_580731, "quotaUser", newJString(quotaUser))
  add(query_580731, "alt", newJString(alt))
  add(query_580731, "oauth_token", newJString(oauthToken))
  add(query_580731, "userIp", newJString(userIp))
  add(query_580731, "key", newJString(key))
  add(path_580730, "customer", newJString(customer))
  if body != nil:
    body_580732 = body
  add(query_580731, "prettyPrint", newJBool(prettyPrint))
  result = call_580729.call(path_580730, query_580731, nil, nil, body_580732)

var directoryResourcesCalendarsInsert* = Call_DirectoryResourcesCalendarsInsert_580716(
    name: "directoryResourcesCalendarsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsInsert_580717,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsInsert_580718,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsList_580697 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesCalendarsList_580699(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsList_580698(path: JsonNode;
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
  var valid_580700 = path.getOrDefault("customer")
  valid_580700 = validateParameter(valid_580700, JString, required = true,
                                 default = nil)
  if valid_580700 != nil:
    section.add "customer", valid_580700
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
  var valid_580701 = query.getOrDefault("fields")
  valid_580701 = validateParameter(valid_580701, JString, required = false,
                                 default = nil)
  if valid_580701 != nil:
    section.add "fields", valid_580701
  var valid_580702 = query.getOrDefault("pageToken")
  valid_580702 = validateParameter(valid_580702, JString, required = false,
                                 default = nil)
  if valid_580702 != nil:
    section.add "pageToken", valid_580702
  var valid_580703 = query.getOrDefault("quotaUser")
  valid_580703 = validateParameter(valid_580703, JString, required = false,
                                 default = nil)
  if valid_580703 != nil:
    section.add "quotaUser", valid_580703
  var valid_580704 = query.getOrDefault("alt")
  valid_580704 = validateParameter(valid_580704, JString, required = false,
                                 default = newJString("json"))
  if valid_580704 != nil:
    section.add "alt", valid_580704
  var valid_580705 = query.getOrDefault("query")
  valid_580705 = validateParameter(valid_580705, JString, required = false,
                                 default = nil)
  if valid_580705 != nil:
    section.add "query", valid_580705
  var valid_580706 = query.getOrDefault("oauth_token")
  valid_580706 = validateParameter(valid_580706, JString, required = false,
                                 default = nil)
  if valid_580706 != nil:
    section.add "oauth_token", valid_580706
  var valid_580707 = query.getOrDefault("userIp")
  valid_580707 = validateParameter(valid_580707, JString, required = false,
                                 default = nil)
  if valid_580707 != nil:
    section.add "userIp", valid_580707
  var valid_580708 = query.getOrDefault("maxResults")
  valid_580708 = validateParameter(valid_580708, JInt, required = false, default = nil)
  if valid_580708 != nil:
    section.add "maxResults", valid_580708
  var valid_580709 = query.getOrDefault("orderBy")
  valid_580709 = validateParameter(valid_580709, JString, required = false,
                                 default = nil)
  if valid_580709 != nil:
    section.add "orderBy", valid_580709
  var valid_580710 = query.getOrDefault("key")
  valid_580710 = validateParameter(valid_580710, JString, required = false,
                                 default = nil)
  if valid_580710 != nil:
    section.add "key", valid_580710
  var valid_580711 = query.getOrDefault("prettyPrint")
  valid_580711 = validateParameter(valid_580711, JBool, required = false,
                                 default = newJBool(true))
  if valid_580711 != nil:
    section.add "prettyPrint", valid_580711
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580712: Call_DirectoryResourcesCalendarsList_580697;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves a list of calendar resources for an account.
  ## 
  let valid = call_580712.validator(path, query, header, formData, body)
  let scheme = call_580712.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580712.url(scheme.get, call_580712.host, call_580712.base,
                         call_580712.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580712, url, valid)

proc call*(call_580713: Call_DirectoryResourcesCalendarsList_580697;
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
  var path_580714 = newJObject()
  var query_580715 = newJObject()
  add(query_580715, "fields", newJString(fields))
  add(query_580715, "pageToken", newJString(pageToken))
  add(query_580715, "quotaUser", newJString(quotaUser))
  add(query_580715, "alt", newJString(alt))
  add(query_580715, "query", newJString(query))
  add(query_580715, "oauth_token", newJString(oauthToken))
  add(query_580715, "userIp", newJString(userIp))
  add(query_580715, "maxResults", newJInt(maxResults))
  add(query_580715, "orderBy", newJString(orderBy))
  add(query_580715, "key", newJString(key))
  add(path_580714, "customer", newJString(customer))
  add(query_580715, "prettyPrint", newJBool(prettyPrint))
  result = call_580713.call(path_580714, query_580715, nil, nil, nil)

var directoryResourcesCalendarsList* = Call_DirectoryResourcesCalendarsList_580697(
    name: "directoryResourcesCalendarsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/calendars",
    validator: validate_DirectoryResourcesCalendarsList_580698,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsList_580699,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsUpdate_580749 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesCalendarsUpdate_580751(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsUpdate_580750(path: JsonNode;
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
  var valid_580752 = path.getOrDefault("calendarResourceId")
  valid_580752 = validateParameter(valid_580752, JString, required = true,
                                 default = nil)
  if valid_580752 != nil:
    section.add "calendarResourceId", valid_580752
  var valid_580753 = path.getOrDefault("customer")
  valid_580753 = validateParameter(valid_580753, JString, required = true,
                                 default = nil)
  if valid_580753 != nil:
    section.add "customer", valid_580753
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
  var valid_580754 = query.getOrDefault("fields")
  valid_580754 = validateParameter(valid_580754, JString, required = false,
                                 default = nil)
  if valid_580754 != nil:
    section.add "fields", valid_580754
  var valid_580755 = query.getOrDefault("quotaUser")
  valid_580755 = validateParameter(valid_580755, JString, required = false,
                                 default = nil)
  if valid_580755 != nil:
    section.add "quotaUser", valid_580755
  var valid_580756 = query.getOrDefault("alt")
  valid_580756 = validateParameter(valid_580756, JString, required = false,
                                 default = newJString("json"))
  if valid_580756 != nil:
    section.add "alt", valid_580756
  var valid_580757 = query.getOrDefault("oauth_token")
  valid_580757 = validateParameter(valid_580757, JString, required = false,
                                 default = nil)
  if valid_580757 != nil:
    section.add "oauth_token", valid_580757
  var valid_580758 = query.getOrDefault("userIp")
  valid_580758 = validateParameter(valid_580758, JString, required = false,
                                 default = nil)
  if valid_580758 != nil:
    section.add "userIp", valid_580758
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

proc call*(call_580762: Call_DirectoryResourcesCalendarsUpdate_580749;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved.
  ## 
  let valid = call_580762.validator(path, query, header, formData, body)
  let scheme = call_580762.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580762.url(scheme.get, call_580762.host, call_580762.base,
                         call_580762.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580762, url, valid)

proc call*(call_580763: Call_DirectoryResourcesCalendarsUpdate_580749;
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
  var path_580764 = newJObject()
  var query_580765 = newJObject()
  var body_580766 = newJObject()
  add(query_580765, "fields", newJString(fields))
  add(query_580765, "quotaUser", newJString(quotaUser))
  add(query_580765, "alt", newJString(alt))
  add(query_580765, "oauth_token", newJString(oauthToken))
  add(query_580765, "userIp", newJString(userIp))
  add(path_580764, "calendarResourceId", newJString(calendarResourceId))
  add(query_580765, "key", newJString(key))
  add(path_580764, "customer", newJString(customer))
  if body != nil:
    body_580766 = body
  add(query_580765, "prettyPrint", newJBool(prettyPrint))
  result = call_580763.call(path_580764, query_580765, nil, nil, body_580766)

var directoryResourcesCalendarsUpdate* = Call_DirectoryResourcesCalendarsUpdate_580749(
    name: "directoryResourcesCalendarsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsUpdate_580750,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsUpdate_580751,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsGet_580733 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesCalendarsGet_580735(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsGet_580734(path: JsonNode;
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
  var valid_580736 = path.getOrDefault("calendarResourceId")
  valid_580736 = validateParameter(valid_580736, JString, required = true,
                                 default = nil)
  if valid_580736 != nil:
    section.add "calendarResourceId", valid_580736
  var valid_580737 = path.getOrDefault("customer")
  valid_580737 = validateParameter(valid_580737, JString, required = true,
                                 default = nil)
  if valid_580737 != nil:
    section.add "customer", valid_580737
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
  var valid_580738 = query.getOrDefault("fields")
  valid_580738 = validateParameter(valid_580738, JString, required = false,
                                 default = nil)
  if valid_580738 != nil:
    section.add "fields", valid_580738
  var valid_580739 = query.getOrDefault("quotaUser")
  valid_580739 = validateParameter(valid_580739, JString, required = false,
                                 default = nil)
  if valid_580739 != nil:
    section.add "quotaUser", valid_580739
  var valid_580740 = query.getOrDefault("alt")
  valid_580740 = validateParameter(valid_580740, JString, required = false,
                                 default = newJString("json"))
  if valid_580740 != nil:
    section.add "alt", valid_580740
  var valid_580741 = query.getOrDefault("oauth_token")
  valid_580741 = validateParameter(valid_580741, JString, required = false,
                                 default = nil)
  if valid_580741 != nil:
    section.add "oauth_token", valid_580741
  var valid_580742 = query.getOrDefault("userIp")
  valid_580742 = validateParameter(valid_580742, JString, required = false,
                                 default = nil)
  if valid_580742 != nil:
    section.add "userIp", valid_580742
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580745: Call_DirectoryResourcesCalendarsGet_580733; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a calendar resource.
  ## 
  let valid = call_580745.validator(path, query, header, formData, body)
  let scheme = call_580745.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580745.url(scheme.get, call_580745.host, call_580745.base,
                         call_580745.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580745, url, valid)

proc call*(call_580746: Call_DirectoryResourcesCalendarsGet_580733;
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
  var path_580747 = newJObject()
  var query_580748 = newJObject()
  add(query_580748, "fields", newJString(fields))
  add(query_580748, "quotaUser", newJString(quotaUser))
  add(query_580748, "alt", newJString(alt))
  add(query_580748, "oauth_token", newJString(oauthToken))
  add(query_580748, "userIp", newJString(userIp))
  add(path_580747, "calendarResourceId", newJString(calendarResourceId))
  add(query_580748, "key", newJString(key))
  add(path_580747, "customer", newJString(customer))
  add(query_580748, "prettyPrint", newJBool(prettyPrint))
  result = call_580746.call(path_580747, query_580748, nil, nil, nil)

var directoryResourcesCalendarsGet* = Call_DirectoryResourcesCalendarsGet_580733(
    name: "directoryResourcesCalendarsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsGet_580734,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsGet_580735,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsPatch_580783 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesCalendarsPatch_580785(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsPatch_580784(path: JsonNode;
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
  var valid_580786 = path.getOrDefault("calendarResourceId")
  valid_580786 = validateParameter(valid_580786, JString, required = true,
                                 default = nil)
  if valid_580786 != nil:
    section.add "calendarResourceId", valid_580786
  var valid_580787 = path.getOrDefault("customer")
  valid_580787 = validateParameter(valid_580787, JString, required = true,
                                 default = nil)
  if valid_580787 != nil:
    section.add "customer", valid_580787
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
  var valid_580788 = query.getOrDefault("fields")
  valid_580788 = validateParameter(valid_580788, JString, required = false,
                                 default = nil)
  if valid_580788 != nil:
    section.add "fields", valid_580788
  var valid_580789 = query.getOrDefault("quotaUser")
  valid_580789 = validateParameter(valid_580789, JString, required = false,
                                 default = nil)
  if valid_580789 != nil:
    section.add "quotaUser", valid_580789
  var valid_580790 = query.getOrDefault("alt")
  valid_580790 = validateParameter(valid_580790, JString, required = false,
                                 default = newJString("json"))
  if valid_580790 != nil:
    section.add "alt", valid_580790
  var valid_580791 = query.getOrDefault("oauth_token")
  valid_580791 = validateParameter(valid_580791, JString, required = false,
                                 default = nil)
  if valid_580791 != nil:
    section.add "oauth_token", valid_580791
  var valid_580792 = query.getOrDefault("userIp")
  valid_580792 = validateParameter(valid_580792, JString, required = false,
                                 default = nil)
  if valid_580792 != nil:
    section.add "userIp", valid_580792
  var valid_580793 = query.getOrDefault("key")
  valid_580793 = validateParameter(valid_580793, JString, required = false,
                                 default = nil)
  if valid_580793 != nil:
    section.add "key", valid_580793
  var valid_580794 = query.getOrDefault("prettyPrint")
  valid_580794 = validateParameter(valid_580794, JBool, required = false,
                                 default = newJBool(true))
  if valid_580794 != nil:
    section.add "prettyPrint", valid_580794
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

proc call*(call_580796: Call_DirectoryResourcesCalendarsPatch_580783;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a calendar resource.
  ## 
  ## This method supports patch semantics, meaning you only need to include the fields you wish to update. Fields that are not present in the request will be preserved. This method supports patch semantics.
  ## 
  let valid = call_580796.validator(path, query, header, formData, body)
  let scheme = call_580796.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580796.url(scheme.get, call_580796.host, call_580796.base,
                         call_580796.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580796, url, valid)

proc call*(call_580797: Call_DirectoryResourcesCalendarsPatch_580783;
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
  var path_580798 = newJObject()
  var query_580799 = newJObject()
  var body_580800 = newJObject()
  add(query_580799, "fields", newJString(fields))
  add(query_580799, "quotaUser", newJString(quotaUser))
  add(query_580799, "alt", newJString(alt))
  add(query_580799, "oauth_token", newJString(oauthToken))
  add(query_580799, "userIp", newJString(userIp))
  add(path_580798, "calendarResourceId", newJString(calendarResourceId))
  add(query_580799, "key", newJString(key))
  add(path_580798, "customer", newJString(customer))
  if body != nil:
    body_580800 = body
  add(query_580799, "prettyPrint", newJBool(prettyPrint))
  result = call_580797.call(path_580798, query_580799, nil, nil, body_580800)

var directoryResourcesCalendarsPatch* = Call_DirectoryResourcesCalendarsPatch_580783(
    name: "directoryResourcesCalendarsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsPatch_580784,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsPatch_580785,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesCalendarsDelete_580767 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesCalendarsDelete_580769(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesCalendarsDelete_580768(path: JsonNode;
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
  var valid_580770 = path.getOrDefault("calendarResourceId")
  valid_580770 = validateParameter(valid_580770, JString, required = true,
                                 default = nil)
  if valid_580770 != nil:
    section.add "calendarResourceId", valid_580770
  var valid_580771 = path.getOrDefault("customer")
  valid_580771 = validateParameter(valid_580771, JString, required = true,
                                 default = nil)
  if valid_580771 != nil:
    section.add "customer", valid_580771
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
  var valid_580772 = query.getOrDefault("fields")
  valid_580772 = validateParameter(valid_580772, JString, required = false,
                                 default = nil)
  if valid_580772 != nil:
    section.add "fields", valid_580772
  var valid_580773 = query.getOrDefault("quotaUser")
  valid_580773 = validateParameter(valid_580773, JString, required = false,
                                 default = nil)
  if valid_580773 != nil:
    section.add "quotaUser", valid_580773
  var valid_580774 = query.getOrDefault("alt")
  valid_580774 = validateParameter(valid_580774, JString, required = false,
                                 default = newJString("json"))
  if valid_580774 != nil:
    section.add "alt", valid_580774
  var valid_580775 = query.getOrDefault("oauth_token")
  valid_580775 = validateParameter(valid_580775, JString, required = false,
                                 default = nil)
  if valid_580775 != nil:
    section.add "oauth_token", valid_580775
  var valid_580776 = query.getOrDefault("userIp")
  valid_580776 = validateParameter(valid_580776, JString, required = false,
                                 default = nil)
  if valid_580776 != nil:
    section.add "userIp", valid_580776
  var valid_580777 = query.getOrDefault("key")
  valid_580777 = validateParameter(valid_580777, JString, required = false,
                                 default = nil)
  if valid_580777 != nil:
    section.add "key", valid_580777
  var valid_580778 = query.getOrDefault("prettyPrint")
  valid_580778 = validateParameter(valid_580778, JBool, required = false,
                                 default = newJBool(true))
  if valid_580778 != nil:
    section.add "prettyPrint", valid_580778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580779: Call_DirectoryResourcesCalendarsDelete_580767;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a calendar resource.
  ## 
  let valid = call_580779.validator(path, query, header, formData, body)
  let scheme = call_580779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580779.url(scheme.get, call_580779.host, call_580779.base,
                         call_580779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580779, url, valid)

proc call*(call_580780: Call_DirectoryResourcesCalendarsDelete_580767;
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
  var path_580781 = newJObject()
  var query_580782 = newJObject()
  add(query_580782, "fields", newJString(fields))
  add(query_580782, "quotaUser", newJString(quotaUser))
  add(query_580782, "alt", newJString(alt))
  add(query_580782, "oauth_token", newJString(oauthToken))
  add(query_580782, "userIp", newJString(userIp))
  add(path_580781, "calendarResourceId", newJString(calendarResourceId))
  add(query_580782, "key", newJString(key))
  add(path_580781, "customer", newJString(customer))
  add(query_580782, "prettyPrint", newJBool(prettyPrint))
  result = call_580780.call(path_580781, query_580782, nil, nil, nil)

var directoryResourcesCalendarsDelete* = Call_DirectoryResourcesCalendarsDelete_580767(
    name: "directoryResourcesCalendarsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/calendars/{calendarResourceId}",
    validator: validate_DirectoryResourcesCalendarsDelete_580768,
    base: "/admin/directory/v1", url: url_DirectoryResourcesCalendarsDelete_580769,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesInsert_580818 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesFeaturesInsert_580820(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesInsert_580819(path: JsonNode;
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
  var valid_580821 = path.getOrDefault("customer")
  valid_580821 = validateParameter(valid_580821, JString, required = true,
                                 default = nil)
  if valid_580821 != nil:
    section.add "customer", valid_580821
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
  var valid_580822 = query.getOrDefault("fields")
  valid_580822 = validateParameter(valid_580822, JString, required = false,
                                 default = nil)
  if valid_580822 != nil:
    section.add "fields", valid_580822
  var valid_580823 = query.getOrDefault("quotaUser")
  valid_580823 = validateParameter(valid_580823, JString, required = false,
                                 default = nil)
  if valid_580823 != nil:
    section.add "quotaUser", valid_580823
  var valid_580824 = query.getOrDefault("alt")
  valid_580824 = validateParameter(valid_580824, JString, required = false,
                                 default = newJString("json"))
  if valid_580824 != nil:
    section.add "alt", valid_580824
  var valid_580825 = query.getOrDefault("oauth_token")
  valid_580825 = validateParameter(valid_580825, JString, required = false,
                                 default = nil)
  if valid_580825 != nil:
    section.add "oauth_token", valid_580825
  var valid_580826 = query.getOrDefault("userIp")
  valid_580826 = validateParameter(valid_580826, JString, required = false,
                                 default = nil)
  if valid_580826 != nil:
    section.add "userIp", valid_580826
  var valid_580827 = query.getOrDefault("key")
  valid_580827 = validateParameter(valid_580827, JString, required = false,
                                 default = nil)
  if valid_580827 != nil:
    section.add "key", valid_580827
  var valid_580828 = query.getOrDefault("prettyPrint")
  valid_580828 = validateParameter(valid_580828, JBool, required = false,
                                 default = newJBool(true))
  if valid_580828 != nil:
    section.add "prettyPrint", valid_580828
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

proc call*(call_580830: Call_DirectoryResourcesFeaturesInsert_580818;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Inserts a feature.
  ## 
  let valid = call_580830.validator(path, query, header, formData, body)
  let scheme = call_580830.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580830.url(scheme.get, call_580830.host, call_580830.base,
                         call_580830.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580830, url, valid)

proc call*(call_580831: Call_DirectoryResourcesFeaturesInsert_580818;
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
  var path_580832 = newJObject()
  var query_580833 = newJObject()
  var body_580834 = newJObject()
  add(query_580833, "fields", newJString(fields))
  add(query_580833, "quotaUser", newJString(quotaUser))
  add(query_580833, "alt", newJString(alt))
  add(query_580833, "oauth_token", newJString(oauthToken))
  add(query_580833, "userIp", newJString(userIp))
  add(query_580833, "key", newJString(key))
  add(path_580832, "customer", newJString(customer))
  if body != nil:
    body_580834 = body
  add(query_580833, "prettyPrint", newJBool(prettyPrint))
  result = call_580831.call(path_580832, query_580833, nil, nil, body_580834)

var directoryResourcesFeaturesInsert* = Call_DirectoryResourcesFeaturesInsert_580818(
    name: "directoryResourcesFeaturesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesInsert_580819,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesInsert_580820,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesList_580801 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesFeaturesList_580803(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesList_580802(path: JsonNode;
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
  var valid_580804 = path.getOrDefault("customer")
  valid_580804 = validateParameter(valid_580804, JString, required = true,
                                 default = nil)
  if valid_580804 != nil:
    section.add "customer", valid_580804
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
  var valid_580805 = query.getOrDefault("fields")
  valid_580805 = validateParameter(valid_580805, JString, required = false,
                                 default = nil)
  if valid_580805 != nil:
    section.add "fields", valid_580805
  var valid_580806 = query.getOrDefault("pageToken")
  valid_580806 = validateParameter(valid_580806, JString, required = false,
                                 default = nil)
  if valid_580806 != nil:
    section.add "pageToken", valid_580806
  var valid_580807 = query.getOrDefault("quotaUser")
  valid_580807 = validateParameter(valid_580807, JString, required = false,
                                 default = nil)
  if valid_580807 != nil:
    section.add "quotaUser", valid_580807
  var valid_580808 = query.getOrDefault("alt")
  valid_580808 = validateParameter(valid_580808, JString, required = false,
                                 default = newJString("json"))
  if valid_580808 != nil:
    section.add "alt", valid_580808
  var valid_580809 = query.getOrDefault("oauth_token")
  valid_580809 = validateParameter(valid_580809, JString, required = false,
                                 default = nil)
  if valid_580809 != nil:
    section.add "oauth_token", valid_580809
  var valid_580810 = query.getOrDefault("userIp")
  valid_580810 = validateParameter(valid_580810, JString, required = false,
                                 default = nil)
  if valid_580810 != nil:
    section.add "userIp", valid_580810
  var valid_580811 = query.getOrDefault("maxResults")
  valid_580811 = validateParameter(valid_580811, JInt, required = false, default = nil)
  if valid_580811 != nil:
    section.add "maxResults", valid_580811
  var valid_580812 = query.getOrDefault("key")
  valid_580812 = validateParameter(valid_580812, JString, required = false,
                                 default = nil)
  if valid_580812 != nil:
    section.add "key", valid_580812
  var valid_580813 = query.getOrDefault("prettyPrint")
  valid_580813 = validateParameter(valid_580813, JBool, required = false,
                                 default = newJBool(true))
  if valid_580813 != nil:
    section.add "prettyPrint", valid_580813
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580814: Call_DirectoryResourcesFeaturesList_580801; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of features for an account.
  ## 
  let valid = call_580814.validator(path, query, header, formData, body)
  let scheme = call_580814.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580814.url(scheme.get, call_580814.host, call_580814.base,
                         call_580814.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580814, url, valid)

proc call*(call_580815: Call_DirectoryResourcesFeaturesList_580801;
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
  var path_580816 = newJObject()
  var query_580817 = newJObject()
  add(query_580817, "fields", newJString(fields))
  add(query_580817, "pageToken", newJString(pageToken))
  add(query_580817, "quotaUser", newJString(quotaUser))
  add(query_580817, "alt", newJString(alt))
  add(query_580817, "oauth_token", newJString(oauthToken))
  add(query_580817, "userIp", newJString(userIp))
  add(query_580817, "maxResults", newJInt(maxResults))
  add(query_580817, "key", newJString(key))
  add(path_580816, "customer", newJString(customer))
  add(query_580817, "prettyPrint", newJBool(prettyPrint))
  result = call_580815.call(path_580816, query_580817, nil, nil, nil)

var directoryResourcesFeaturesList* = Call_DirectoryResourcesFeaturesList_580801(
    name: "directoryResourcesFeaturesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/resources/features",
    validator: validate_DirectoryResourcesFeaturesList_580802,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesList_580803,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesUpdate_580851 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesFeaturesUpdate_580853(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesUpdate_580852(path: JsonNode;
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
  var valid_580854 = path.getOrDefault("featureKey")
  valid_580854 = validateParameter(valid_580854, JString, required = true,
                                 default = nil)
  if valid_580854 != nil:
    section.add "featureKey", valid_580854
  var valid_580855 = path.getOrDefault("customer")
  valid_580855 = validateParameter(valid_580855, JString, required = true,
                                 default = nil)
  if valid_580855 != nil:
    section.add "customer", valid_580855
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
  var valid_580856 = query.getOrDefault("fields")
  valid_580856 = validateParameter(valid_580856, JString, required = false,
                                 default = nil)
  if valid_580856 != nil:
    section.add "fields", valid_580856
  var valid_580857 = query.getOrDefault("quotaUser")
  valid_580857 = validateParameter(valid_580857, JString, required = false,
                                 default = nil)
  if valid_580857 != nil:
    section.add "quotaUser", valid_580857
  var valid_580858 = query.getOrDefault("alt")
  valid_580858 = validateParameter(valid_580858, JString, required = false,
                                 default = newJString("json"))
  if valid_580858 != nil:
    section.add "alt", valid_580858
  var valid_580859 = query.getOrDefault("oauth_token")
  valid_580859 = validateParameter(valid_580859, JString, required = false,
                                 default = nil)
  if valid_580859 != nil:
    section.add "oauth_token", valid_580859
  var valid_580860 = query.getOrDefault("userIp")
  valid_580860 = validateParameter(valid_580860, JString, required = false,
                                 default = nil)
  if valid_580860 != nil:
    section.add "userIp", valid_580860
  var valid_580861 = query.getOrDefault("key")
  valid_580861 = validateParameter(valid_580861, JString, required = false,
                                 default = nil)
  if valid_580861 != nil:
    section.add "key", valid_580861
  var valid_580862 = query.getOrDefault("prettyPrint")
  valid_580862 = validateParameter(valid_580862, JBool, required = false,
                                 default = newJBool(true))
  if valid_580862 != nil:
    section.add "prettyPrint", valid_580862
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

proc call*(call_580864: Call_DirectoryResourcesFeaturesUpdate_580851;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature.
  ## 
  let valid = call_580864.validator(path, query, header, formData, body)
  let scheme = call_580864.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580864.url(scheme.get, call_580864.host, call_580864.base,
                         call_580864.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580864, url, valid)

proc call*(call_580865: Call_DirectoryResourcesFeaturesUpdate_580851;
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
  var path_580866 = newJObject()
  var query_580867 = newJObject()
  var body_580868 = newJObject()
  add(query_580867, "fields", newJString(fields))
  add(query_580867, "quotaUser", newJString(quotaUser))
  add(query_580867, "alt", newJString(alt))
  add(path_580866, "featureKey", newJString(featureKey))
  add(query_580867, "oauth_token", newJString(oauthToken))
  add(query_580867, "userIp", newJString(userIp))
  add(query_580867, "key", newJString(key))
  add(path_580866, "customer", newJString(customer))
  if body != nil:
    body_580868 = body
  add(query_580867, "prettyPrint", newJBool(prettyPrint))
  result = call_580865.call(path_580866, query_580867, nil, nil, body_580868)

var directoryResourcesFeaturesUpdate* = Call_DirectoryResourcesFeaturesUpdate_580851(
    name: "directoryResourcesFeaturesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesUpdate_580852,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesUpdate_580853,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesGet_580835 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesFeaturesGet_580837(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesGet_580836(path: JsonNode; query: JsonNode;
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
  var valid_580838 = path.getOrDefault("featureKey")
  valid_580838 = validateParameter(valid_580838, JString, required = true,
                                 default = nil)
  if valid_580838 != nil:
    section.add "featureKey", valid_580838
  var valid_580839 = path.getOrDefault("customer")
  valid_580839 = validateParameter(valid_580839, JString, required = true,
                                 default = nil)
  if valid_580839 != nil:
    section.add "customer", valid_580839
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
  var valid_580840 = query.getOrDefault("fields")
  valid_580840 = validateParameter(valid_580840, JString, required = false,
                                 default = nil)
  if valid_580840 != nil:
    section.add "fields", valid_580840
  var valid_580841 = query.getOrDefault("quotaUser")
  valid_580841 = validateParameter(valid_580841, JString, required = false,
                                 default = nil)
  if valid_580841 != nil:
    section.add "quotaUser", valid_580841
  var valid_580842 = query.getOrDefault("alt")
  valid_580842 = validateParameter(valid_580842, JString, required = false,
                                 default = newJString("json"))
  if valid_580842 != nil:
    section.add "alt", valid_580842
  var valid_580843 = query.getOrDefault("oauth_token")
  valid_580843 = validateParameter(valid_580843, JString, required = false,
                                 default = nil)
  if valid_580843 != nil:
    section.add "oauth_token", valid_580843
  var valid_580844 = query.getOrDefault("userIp")
  valid_580844 = validateParameter(valid_580844, JString, required = false,
                                 default = nil)
  if valid_580844 != nil:
    section.add "userIp", valid_580844
  var valid_580845 = query.getOrDefault("key")
  valid_580845 = validateParameter(valid_580845, JString, required = false,
                                 default = nil)
  if valid_580845 != nil:
    section.add "key", valid_580845
  var valid_580846 = query.getOrDefault("prettyPrint")
  valid_580846 = validateParameter(valid_580846, JBool, required = false,
                                 default = newJBool(true))
  if valid_580846 != nil:
    section.add "prettyPrint", valid_580846
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580847: Call_DirectoryResourcesFeaturesGet_580835; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a feature.
  ## 
  let valid = call_580847.validator(path, query, header, formData, body)
  let scheme = call_580847.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580847.url(scheme.get, call_580847.host, call_580847.base,
                         call_580847.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580847, url, valid)

proc call*(call_580848: Call_DirectoryResourcesFeaturesGet_580835;
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
  var path_580849 = newJObject()
  var query_580850 = newJObject()
  add(query_580850, "fields", newJString(fields))
  add(query_580850, "quotaUser", newJString(quotaUser))
  add(query_580850, "alt", newJString(alt))
  add(path_580849, "featureKey", newJString(featureKey))
  add(query_580850, "oauth_token", newJString(oauthToken))
  add(query_580850, "userIp", newJString(userIp))
  add(query_580850, "key", newJString(key))
  add(path_580849, "customer", newJString(customer))
  add(query_580850, "prettyPrint", newJBool(prettyPrint))
  result = call_580848.call(path_580849, query_580850, nil, nil, nil)

var directoryResourcesFeaturesGet* = Call_DirectoryResourcesFeaturesGet_580835(
    name: "directoryResourcesFeaturesGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesGet_580836,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesGet_580837,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesPatch_580885 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesFeaturesPatch_580887(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesPatch_580886(path: JsonNode;
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
  var valid_580888 = path.getOrDefault("featureKey")
  valid_580888 = validateParameter(valid_580888, JString, required = true,
                                 default = nil)
  if valid_580888 != nil:
    section.add "featureKey", valid_580888
  var valid_580889 = path.getOrDefault("customer")
  valid_580889 = validateParameter(valid_580889, JString, required = true,
                                 default = nil)
  if valid_580889 != nil:
    section.add "customer", valid_580889
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
  var valid_580890 = query.getOrDefault("fields")
  valid_580890 = validateParameter(valid_580890, JString, required = false,
                                 default = nil)
  if valid_580890 != nil:
    section.add "fields", valid_580890
  var valid_580891 = query.getOrDefault("quotaUser")
  valid_580891 = validateParameter(valid_580891, JString, required = false,
                                 default = nil)
  if valid_580891 != nil:
    section.add "quotaUser", valid_580891
  var valid_580892 = query.getOrDefault("alt")
  valid_580892 = validateParameter(valid_580892, JString, required = false,
                                 default = newJString("json"))
  if valid_580892 != nil:
    section.add "alt", valid_580892
  var valid_580893 = query.getOrDefault("oauth_token")
  valid_580893 = validateParameter(valid_580893, JString, required = false,
                                 default = nil)
  if valid_580893 != nil:
    section.add "oauth_token", valid_580893
  var valid_580894 = query.getOrDefault("userIp")
  valid_580894 = validateParameter(valid_580894, JString, required = false,
                                 default = nil)
  if valid_580894 != nil:
    section.add "userIp", valid_580894
  var valid_580895 = query.getOrDefault("key")
  valid_580895 = validateParameter(valid_580895, JString, required = false,
                                 default = nil)
  if valid_580895 != nil:
    section.add "key", valid_580895
  var valid_580896 = query.getOrDefault("prettyPrint")
  valid_580896 = validateParameter(valid_580896, JBool, required = false,
                                 default = newJBool(true))
  if valid_580896 != nil:
    section.add "prettyPrint", valid_580896
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

proc call*(call_580898: Call_DirectoryResourcesFeaturesPatch_580885;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a feature. This method supports patch semantics.
  ## 
  let valid = call_580898.validator(path, query, header, formData, body)
  let scheme = call_580898.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580898.url(scheme.get, call_580898.host, call_580898.base,
                         call_580898.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580898, url, valid)

proc call*(call_580899: Call_DirectoryResourcesFeaturesPatch_580885;
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
  var path_580900 = newJObject()
  var query_580901 = newJObject()
  var body_580902 = newJObject()
  add(query_580901, "fields", newJString(fields))
  add(query_580901, "quotaUser", newJString(quotaUser))
  add(query_580901, "alt", newJString(alt))
  add(path_580900, "featureKey", newJString(featureKey))
  add(query_580901, "oauth_token", newJString(oauthToken))
  add(query_580901, "userIp", newJString(userIp))
  add(query_580901, "key", newJString(key))
  add(path_580900, "customer", newJString(customer))
  if body != nil:
    body_580902 = body
  add(query_580901, "prettyPrint", newJBool(prettyPrint))
  result = call_580899.call(path_580900, query_580901, nil, nil, body_580902)

var directoryResourcesFeaturesPatch* = Call_DirectoryResourcesFeaturesPatch_580885(
    name: "directoryResourcesFeaturesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesPatch_580886,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesPatch_580887,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesDelete_580869 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesFeaturesDelete_580871(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesDelete_580870(path: JsonNode;
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
  var valid_580872 = path.getOrDefault("featureKey")
  valid_580872 = validateParameter(valid_580872, JString, required = true,
                                 default = nil)
  if valid_580872 != nil:
    section.add "featureKey", valid_580872
  var valid_580873 = path.getOrDefault("customer")
  valid_580873 = validateParameter(valid_580873, JString, required = true,
                                 default = nil)
  if valid_580873 != nil:
    section.add "customer", valid_580873
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
  var valid_580874 = query.getOrDefault("fields")
  valid_580874 = validateParameter(valid_580874, JString, required = false,
                                 default = nil)
  if valid_580874 != nil:
    section.add "fields", valid_580874
  var valid_580875 = query.getOrDefault("quotaUser")
  valid_580875 = validateParameter(valid_580875, JString, required = false,
                                 default = nil)
  if valid_580875 != nil:
    section.add "quotaUser", valid_580875
  var valid_580876 = query.getOrDefault("alt")
  valid_580876 = validateParameter(valid_580876, JString, required = false,
                                 default = newJString("json"))
  if valid_580876 != nil:
    section.add "alt", valid_580876
  var valid_580877 = query.getOrDefault("oauth_token")
  valid_580877 = validateParameter(valid_580877, JString, required = false,
                                 default = nil)
  if valid_580877 != nil:
    section.add "oauth_token", valid_580877
  var valid_580878 = query.getOrDefault("userIp")
  valid_580878 = validateParameter(valid_580878, JString, required = false,
                                 default = nil)
  if valid_580878 != nil:
    section.add "userIp", valid_580878
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580881: Call_DirectoryResourcesFeaturesDelete_580869;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a feature.
  ## 
  let valid = call_580881.validator(path, query, header, formData, body)
  let scheme = call_580881.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580881.url(scheme.get, call_580881.host, call_580881.base,
                         call_580881.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580881, url, valid)

proc call*(call_580882: Call_DirectoryResourcesFeaturesDelete_580869;
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
  var path_580883 = newJObject()
  var query_580884 = newJObject()
  add(query_580884, "fields", newJString(fields))
  add(query_580884, "quotaUser", newJString(quotaUser))
  add(query_580884, "alt", newJString(alt))
  add(path_580883, "featureKey", newJString(featureKey))
  add(query_580884, "oauth_token", newJString(oauthToken))
  add(query_580884, "userIp", newJString(userIp))
  add(query_580884, "key", newJString(key))
  add(path_580883, "customer", newJString(customer))
  add(query_580884, "prettyPrint", newJBool(prettyPrint))
  result = call_580882.call(path_580883, query_580884, nil, nil, nil)

var directoryResourcesFeaturesDelete* = Call_DirectoryResourcesFeaturesDelete_580869(
    name: "directoryResourcesFeaturesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{featureKey}",
    validator: validate_DirectoryResourcesFeaturesDelete_580870,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesDelete_580871,
    schemes: {Scheme.Https})
type
  Call_DirectoryResourcesFeaturesRename_580903 = ref object of OpenApiRestCall_579437
proc url_DirectoryResourcesFeaturesRename_580905(protocol: Scheme; host: string;
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

proc validate_DirectoryResourcesFeaturesRename_580904(path: JsonNode;
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
  var valid_580906 = path.getOrDefault("oldName")
  valid_580906 = validateParameter(valid_580906, JString, required = true,
                                 default = nil)
  if valid_580906 != nil:
    section.add "oldName", valid_580906
  var valid_580907 = path.getOrDefault("customer")
  valid_580907 = validateParameter(valid_580907, JString, required = true,
                                 default = nil)
  if valid_580907 != nil:
    section.add "customer", valid_580907
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
  var valid_580908 = query.getOrDefault("fields")
  valid_580908 = validateParameter(valid_580908, JString, required = false,
                                 default = nil)
  if valid_580908 != nil:
    section.add "fields", valid_580908
  var valid_580909 = query.getOrDefault("quotaUser")
  valid_580909 = validateParameter(valid_580909, JString, required = false,
                                 default = nil)
  if valid_580909 != nil:
    section.add "quotaUser", valid_580909
  var valid_580910 = query.getOrDefault("alt")
  valid_580910 = validateParameter(valid_580910, JString, required = false,
                                 default = newJString("json"))
  if valid_580910 != nil:
    section.add "alt", valid_580910
  var valid_580911 = query.getOrDefault("oauth_token")
  valid_580911 = validateParameter(valid_580911, JString, required = false,
                                 default = nil)
  if valid_580911 != nil:
    section.add "oauth_token", valid_580911
  var valid_580912 = query.getOrDefault("userIp")
  valid_580912 = validateParameter(valid_580912, JString, required = false,
                                 default = nil)
  if valid_580912 != nil:
    section.add "userIp", valid_580912
  var valid_580913 = query.getOrDefault("key")
  valid_580913 = validateParameter(valid_580913, JString, required = false,
                                 default = nil)
  if valid_580913 != nil:
    section.add "key", valid_580913
  var valid_580914 = query.getOrDefault("prettyPrint")
  valid_580914 = validateParameter(valid_580914, JBool, required = false,
                                 default = newJBool(true))
  if valid_580914 != nil:
    section.add "prettyPrint", valid_580914
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

proc call*(call_580916: Call_DirectoryResourcesFeaturesRename_580903;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Renames a feature.
  ## 
  let valid = call_580916.validator(path, query, header, formData, body)
  let scheme = call_580916.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580916.url(scheme.get, call_580916.host, call_580916.base,
                         call_580916.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580916, url, valid)

proc call*(call_580917: Call_DirectoryResourcesFeaturesRename_580903;
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
  var path_580918 = newJObject()
  var query_580919 = newJObject()
  var body_580920 = newJObject()
  add(query_580919, "fields", newJString(fields))
  add(query_580919, "quotaUser", newJString(quotaUser))
  add(query_580919, "alt", newJString(alt))
  add(query_580919, "oauth_token", newJString(oauthToken))
  add(query_580919, "userIp", newJString(userIp))
  add(query_580919, "key", newJString(key))
  add(path_580918, "oldName", newJString(oldName))
  add(path_580918, "customer", newJString(customer))
  if body != nil:
    body_580920 = body
  add(query_580919, "prettyPrint", newJBool(prettyPrint))
  result = call_580917.call(path_580918, query_580919, nil, nil, body_580920)

var directoryResourcesFeaturesRename* = Call_DirectoryResourcesFeaturesRename_580903(
    name: "directoryResourcesFeaturesRename", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/customer/{customer}/resources/features/{oldName}/rename",
    validator: validate_DirectoryResourcesFeaturesRename_580904,
    base: "/admin/directory/v1", url: url_DirectoryResourcesFeaturesRename_580905,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsInsert_580940 = ref object of OpenApiRestCall_579437
proc url_DirectoryRoleAssignmentsInsert_580942(protocol: Scheme; host: string;
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

proc validate_DirectoryRoleAssignmentsInsert_580941(path: JsonNode;
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
  var valid_580943 = path.getOrDefault("customer")
  valid_580943 = validateParameter(valid_580943, JString, required = true,
                                 default = nil)
  if valid_580943 != nil:
    section.add "customer", valid_580943
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
  var valid_580944 = query.getOrDefault("fields")
  valid_580944 = validateParameter(valid_580944, JString, required = false,
                                 default = nil)
  if valid_580944 != nil:
    section.add "fields", valid_580944
  var valid_580945 = query.getOrDefault("quotaUser")
  valid_580945 = validateParameter(valid_580945, JString, required = false,
                                 default = nil)
  if valid_580945 != nil:
    section.add "quotaUser", valid_580945
  var valid_580946 = query.getOrDefault("alt")
  valid_580946 = validateParameter(valid_580946, JString, required = false,
                                 default = newJString("json"))
  if valid_580946 != nil:
    section.add "alt", valid_580946
  var valid_580947 = query.getOrDefault("oauth_token")
  valid_580947 = validateParameter(valid_580947, JString, required = false,
                                 default = nil)
  if valid_580947 != nil:
    section.add "oauth_token", valid_580947
  var valid_580948 = query.getOrDefault("userIp")
  valid_580948 = validateParameter(valid_580948, JString, required = false,
                                 default = nil)
  if valid_580948 != nil:
    section.add "userIp", valid_580948
  var valid_580949 = query.getOrDefault("key")
  valid_580949 = validateParameter(valid_580949, JString, required = false,
                                 default = nil)
  if valid_580949 != nil:
    section.add "key", valid_580949
  var valid_580950 = query.getOrDefault("prettyPrint")
  valid_580950 = validateParameter(valid_580950, JBool, required = false,
                                 default = newJBool(true))
  if valid_580950 != nil:
    section.add "prettyPrint", valid_580950
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

proc call*(call_580952: Call_DirectoryRoleAssignmentsInsert_580940; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role assignment.
  ## 
  let valid = call_580952.validator(path, query, header, formData, body)
  let scheme = call_580952.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580952.url(scheme.get, call_580952.host, call_580952.base,
                         call_580952.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580952, url, valid)

proc call*(call_580953: Call_DirectoryRoleAssignmentsInsert_580940;
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
  var path_580954 = newJObject()
  var query_580955 = newJObject()
  var body_580956 = newJObject()
  add(query_580955, "fields", newJString(fields))
  add(query_580955, "quotaUser", newJString(quotaUser))
  add(query_580955, "alt", newJString(alt))
  add(query_580955, "oauth_token", newJString(oauthToken))
  add(query_580955, "userIp", newJString(userIp))
  add(query_580955, "key", newJString(key))
  add(path_580954, "customer", newJString(customer))
  if body != nil:
    body_580956 = body
  add(query_580955, "prettyPrint", newJBool(prettyPrint))
  result = call_580953.call(path_580954, query_580955, nil, nil, body_580956)

var directoryRoleAssignmentsInsert* = Call_DirectoryRoleAssignmentsInsert_580940(
    name: "directoryRoleAssignmentsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsInsert_580941,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsInsert_580942,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsList_580921 = ref object of OpenApiRestCall_579437
proc url_DirectoryRoleAssignmentsList_580923(protocol: Scheme; host: string;
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

proc validate_DirectoryRoleAssignmentsList_580922(path: JsonNode; query: JsonNode;
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
  var valid_580924 = path.getOrDefault("customer")
  valid_580924 = validateParameter(valid_580924, JString, required = true,
                                 default = nil)
  if valid_580924 != nil:
    section.add "customer", valid_580924
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
  var valid_580925 = query.getOrDefault("fields")
  valid_580925 = validateParameter(valid_580925, JString, required = false,
                                 default = nil)
  if valid_580925 != nil:
    section.add "fields", valid_580925
  var valid_580926 = query.getOrDefault("pageToken")
  valid_580926 = validateParameter(valid_580926, JString, required = false,
                                 default = nil)
  if valid_580926 != nil:
    section.add "pageToken", valid_580926
  var valid_580927 = query.getOrDefault("quotaUser")
  valid_580927 = validateParameter(valid_580927, JString, required = false,
                                 default = nil)
  if valid_580927 != nil:
    section.add "quotaUser", valid_580927
  var valid_580928 = query.getOrDefault("alt")
  valid_580928 = validateParameter(valid_580928, JString, required = false,
                                 default = newJString("json"))
  if valid_580928 != nil:
    section.add "alt", valid_580928
  var valid_580929 = query.getOrDefault("oauth_token")
  valid_580929 = validateParameter(valid_580929, JString, required = false,
                                 default = nil)
  if valid_580929 != nil:
    section.add "oauth_token", valid_580929
  var valid_580930 = query.getOrDefault("userIp")
  valid_580930 = validateParameter(valid_580930, JString, required = false,
                                 default = nil)
  if valid_580930 != nil:
    section.add "userIp", valid_580930
  var valid_580931 = query.getOrDefault("maxResults")
  valid_580931 = validateParameter(valid_580931, JInt, required = false, default = nil)
  if valid_580931 != nil:
    section.add "maxResults", valid_580931
  var valid_580932 = query.getOrDefault("key")
  valid_580932 = validateParameter(valid_580932, JString, required = false,
                                 default = nil)
  if valid_580932 != nil:
    section.add "key", valid_580932
  var valid_580933 = query.getOrDefault("roleId")
  valid_580933 = validateParameter(valid_580933, JString, required = false,
                                 default = nil)
  if valid_580933 != nil:
    section.add "roleId", valid_580933
  var valid_580934 = query.getOrDefault("prettyPrint")
  valid_580934 = validateParameter(valid_580934, JBool, required = false,
                                 default = newJBool(true))
  if valid_580934 != nil:
    section.add "prettyPrint", valid_580934
  var valid_580935 = query.getOrDefault("userKey")
  valid_580935 = validateParameter(valid_580935, JString, required = false,
                                 default = nil)
  if valid_580935 != nil:
    section.add "userKey", valid_580935
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580936: Call_DirectoryRoleAssignmentsList_580921; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all roleAssignments.
  ## 
  let valid = call_580936.validator(path, query, header, formData, body)
  let scheme = call_580936.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580936.url(scheme.get, call_580936.host, call_580936.base,
                         call_580936.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580936, url, valid)

proc call*(call_580937: Call_DirectoryRoleAssignmentsList_580921; customer: string;
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
  var path_580938 = newJObject()
  var query_580939 = newJObject()
  add(query_580939, "fields", newJString(fields))
  add(query_580939, "pageToken", newJString(pageToken))
  add(query_580939, "quotaUser", newJString(quotaUser))
  add(query_580939, "alt", newJString(alt))
  add(query_580939, "oauth_token", newJString(oauthToken))
  add(query_580939, "userIp", newJString(userIp))
  add(query_580939, "maxResults", newJInt(maxResults))
  add(query_580939, "key", newJString(key))
  add(query_580939, "roleId", newJString(roleId))
  add(path_580938, "customer", newJString(customer))
  add(query_580939, "prettyPrint", newJBool(prettyPrint))
  add(query_580939, "userKey", newJString(userKey))
  result = call_580937.call(path_580938, query_580939, nil, nil, nil)

var directoryRoleAssignmentsList* = Call_DirectoryRoleAssignmentsList_580921(
    name: "directoryRoleAssignmentsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roleassignments",
    validator: validate_DirectoryRoleAssignmentsList_580922,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsList_580923,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsGet_580957 = ref object of OpenApiRestCall_579437
proc url_DirectoryRoleAssignmentsGet_580959(protocol: Scheme; host: string;
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

proc validate_DirectoryRoleAssignmentsGet_580958(path: JsonNode; query: JsonNode;
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
  var valid_580960 = path.getOrDefault("customer")
  valid_580960 = validateParameter(valid_580960, JString, required = true,
                                 default = nil)
  if valid_580960 != nil:
    section.add "customer", valid_580960
  var valid_580961 = path.getOrDefault("roleAssignmentId")
  valid_580961 = validateParameter(valid_580961, JString, required = true,
                                 default = nil)
  if valid_580961 != nil:
    section.add "roleAssignmentId", valid_580961
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
  var valid_580962 = query.getOrDefault("fields")
  valid_580962 = validateParameter(valid_580962, JString, required = false,
                                 default = nil)
  if valid_580962 != nil:
    section.add "fields", valid_580962
  var valid_580963 = query.getOrDefault("quotaUser")
  valid_580963 = validateParameter(valid_580963, JString, required = false,
                                 default = nil)
  if valid_580963 != nil:
    section.add "quotaUser", valid_580963
  var valid_580964 = query.getOrDefault("alt")
  valid_580964 = validateParameter(valid_580964, JString, required = false,
                                 default = newJString("json"))
  if valid_580964 != nil:
    section.add "alt", valid_580964
  var valid_580965 = query.getOrDefault("oauth_token")
  valid_580965 = validateParameter(valid_580965, JString, required = false,
                                 default = nil)
  if valid_580965 != nil:
    section.add "oauth_token", valid_580965
  var valid_580966 = query.getOrDefault("userIp")
  valid_580966 = validateParameter(valid_580966, JString, required = false,
                                 default = nil)
  if valid_580966 != nil:
    section.add "userIp", valid_580966
  var valid_580967 = query.getOrDefault("key")
  valid_580967 = validateParameter(valid_580967, JString, required = false,
                                 default = nil)
  if valid_580967 != nil:
    section.add "key", valid_580967
  var valid_580968 = query.getOrDefault("prettyPrint")
  valid_580968 = validateParameter(valid_580968, JBool, required = false,
                                 default = newJBool(true))
  if valid_580968 != nil:
    section.add "prettyPrint", valid_580968
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580969: Call_DirectoryRoleAssignmentsGet_580957; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve a role assignment.
  ## 
  let valid = call_580969.validator(path, query, header, formData, body)
  let scheme = call_580969.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580969.url(scheme.get, call_580969.host, call_580969.base,
                         call_580969.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580969, url, valid)

proc call*(call_580970: Call_DirectoryRoleAssignmentsGet_580957; customer: string;
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
  var path_580971 = newJObject()
  var query_580972 = newJObject()
  add(query_580972, "fields", newJString(fields))
  add(query_580972, "quotaUser", newJString(quotaUser))
  add(query_580972, "alt", newJString(alt))
  add(query_580972, "oauth_token", newJString(oauthToken))
  add(query_580972, "userIp", newJString(userIp))
  add(query_580972, "key", newJString(key))
  add(path_580971, "customer", newJString(customer))
  add(path_580971, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_580972, "prettyPrint", newJBool(prettyPrint))
  result = call_580970.call(path_580971, query_580972, nil, nil, nil)

var directoryRoleAssignmentsGet* = Call_DirectoryRoleAssignmentsGet_580957(
    name: "directoryRoleAssignmentsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsGet_580958,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsGet_580959,
    schemes: {Scheme.Https})
type
  Call_DirectoryRoleAssignmentsDelete_580973 = ref object of OpenApiRestCall_579437
proc url_DirectoryRoleAssignmentsDelete_580975(protocol: Scheme; host: string;
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

proc validate_DirectoryRoleAssignmentsDelete_580974(path: JsonNode;
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
  var valid_580976 = path.getOrDefault("customer")
  valid_580976 = validateParameter(valid_580976, JString, required = true,
                                 default = nil)
  if valid_580976 != nil:
    section.add "customer", valid_580976
  var valid_580977 = path.getOrDefault("roleAssignmentId")
  valid_580977 = validateParameter(valid_580977, JString, required = true,
                                 default = nil)
  if valid_580977 != nil:
    section.add "roleAssignmentId", valid_580977
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
  var valid_580978 = query.getOrDefault("fields")
  valid_580978 = validateParameter(valid_580978, JString, required = false,
                                 default = nil)
  if valid_580978 != nil:
    section.add "fields", valid_580978
  var valid_580979 = query.getOrDefault("quotaUser")
  valid_580979 = validateParameter(valid_580979, JString, required = false,
                                 default = nil)
  if valid_580979 != nil:
    section.add "quotaUser", valid_580979
  var valid_580980 = query.getOrDefault("alt")
  valid_580980 = validateParameter(valid_580980, JString, required = false,
                                 default = newJString("json"))
  if valid_580980 != nil:
    section.add "alt", valid_580980
  var valid_580981 = query.getOrDefault("oauth_token")
  valid_580981 = validateParameter(valid_580981, JString, required = false,
                                 default = nil)
  if valid_580981 != nil:
    section.add "oauth_token", valid_580981
  var valid_580982 = query.getOrDefault("userIp")
  valid_580982 = validateParameter(valid_580982, JString, required = false,
                                 default = nil)
  if valid_580982 != nil:
    section.add "userIp", valid_580982
  var valid_580983 = query.getOrDefault("key")
  valid_580983 = validateParameter(valid_580983, JString, required = false,
                                 default = nil)
  if valid_580983 != nil:
    section.add "key", valid_580983
  var valid_580984 = query.getOrDefault("prettyPrint")
  valid_580984 = validateParameter(valid_580984, JBool, required = false,
                                 default = newJBool(true))
  if valid_580984 != nil:
    section.add "prettyPrint", valid_580984
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580985: Call_DirectoryRoleAssignmentsDelete_580973; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role assignment.
  ## 
  let valid = call_580985.validator(path, query, header, formData, body)
  let scheme = call_580985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580985.url(scheme.get, call_580985.host, call_580985.base,
                         call_580985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580985, url, valid)

proc call*(call_580986: Call_DirectoryRoleAssignmentsDelete_580973;
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
  var path_580987 = newJObject()
  var query_580988 = newJObject()
  add(query_580988, "fields", newJString(fields))
  add(query_580988, "quotaUser", newJString(quotaUser))
  add(query_580988, "alt", newJString(alt))
  add(query_580988, "oauth_token", newJString(oauthToken))
  add(query_580988, "userIp", newJString(userIp))
  add(query_580988, "key", newJString(key))
  add(path_580987, "customer", newJString(customer))
  add(path_580987, "roleAssignmentId", newJString(roleAssignmentId))
  add(query_580988, "prettyPrint", newJBool(prettyPrint))
  result = call_580986.call(path_580987, query_580988, nil, nil, nil)

var directoryRoleAssignmentsDelete* = Call_DirectoryRoleAssignmentsDelete_580973(
    name: "directoryRoleAssignmentsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roleassignments/{roleAssignmentId}",
    validator: validate_DirectoryRoleAssignmentsDelete_580974,
    base: "/admin/directory/v1", url: url_DirectoryRoleAssignmentsDelete_580975,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesInsert_581006 = ref object of OpenApiRestCall_579437
proc url_DirectoryRolesInsert_581008(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesInsert_581007(path: JsonNode; query: JsonNode;
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
  var valid_581009 = path.getOrDefault("customer")
  valid_581009 = validateParameter(valid_581009, JString, required = true,
                                 default = nil)
  if valid_581009 != nil:
    section.add "customer", valid_581009
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
  var valid_581010 = query.getOrDefault("fields")
  valid_581010 = validateParameter(valid_581010, JString, required = false,
                                 default = nil)
  if valid_581010 != nil:
    section.add "fields", valid_581010
  var valid_581011 = query.getOrDefault("quotaUser")
  valid_581011 = validateParameter(valid_581011, JString, required = false,
                                 default = nil)
  if valid_581011 != nil:
    section.add "quotaUser", valid_581011
  var valid_581012 = query.getOrDefault("alt")
  valid_581012 = validateParameter(valid_581012, JString, required = false,
                                 default = newJString("json"))
  if valid_581012 != nil:
    section.add "alt", valid_581012
  var valid_581013 = query.getOrDefault("oauth_token")
  valid_581013 = validateParameter(valid_581013, JString, required = false,
                                 default = nil)
  if valid_581013 != nil:
    section.add "oauth_token", valid_581013
  var valid_581014 = query.getOrDefault("userIp")
  valid_581014 = validateParameter(valid_581014, JString, required = false,
                                 default = nil)
  if valid_581014 != nil:
    section.add "userIp", valid_581014
  var valid_581015 = query.getOrDefault("key")
  valid_581015 = validateParameter(valid_581015, JString, required = false,
                                 default = nil)
  if valid_581015 != nil:
    section.add "key", valid_581015
  var valid_581016 = query.getOrDefault("prettyPrint")
  valid_581016 = validateParameter(valid_581016, JBool, required = false,
                                 default = newJBool(true))
  if valid_581016 != nil:
    section.add "prettyPrint", valid_581016
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

proc call*(call_581018: Call_DirectoryRolesInsert_581006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a role.
  ## 
  let valid = call_581018.validator(path, query, header, formData, body)
  let scheme = call_581018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581018.url(scheme.get, call_581018.host, call_581018.base,
                         call_581018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581018, url, valid)

proc call*(call_581019: Call_DirectoryRolesInsert_581006; customer: string;
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
  var path_581020 = newJObject()
  var query_581021 = newJObject()
  var body_581022 = newJObject()
  add(query_581021, "fields", newJString(fields))
  add(query_581021, "quotaUser", newJString(quotaUser))
  add(query_581021, "alt", newJString(alt))
  add(query_581021, "oauth_token", newJString(oauthToken))
  add(query_581021, "userIp", newJString(userIp))
  add(query_581021, "key", newJString(key))
  add(path_581020, "customer", newJString(customer))
  if body != nil:
    body_581022 = body
  add(query_581021, "prettyPrint", newJBool(prettyPrint))
  result = call_581019.call(path_581020, query_581021, nil, nil, body_581022)

var directoryRolesInsert* = Call_DirectoryRolesInsert_581006(
    name: "directoryRolesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesInsert_581007, base: "/admin/directory/v1",
    url: url_DirectoryRolesInsert_581008, schemes: {Scheme.Https})
type
  Call_DirectoryRolesList_580989 = ref object of OpenApiRestCall_579437
proc url_DirectoryRolesList_580991(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesList_580990(path: JsonNode; query: JsonNode;
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
  var valid_580992 = path.getOrDefault("customer")
  valid_580992 = validateParameter(valid_580992, JString, required = true,
                                 default = nil)
  if valid_580992 != nil:
    section.add "customer", valid_580992
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
  var valid_580993 = query.getOrDefault("fields")
  valid_580993 = validateParameter(valid_580993, JString, required = false,
                                 default = nil)
  if valid_580993 != nil:
    section.add "fields", valid_580993
  var valid_580994 = query.getOrDefault("pageToken")
  valid_580994 = validateParameter(valid_580994, JString, required = false,
                                 default = nil)
  if valid_580994 != nil:
    section.add "pageToken", valid_580994
  var valid_580995 = query.getOrDefault("quotaUser")
  valid_580995 = validateParameter(valid_580995, JString, required = false,
                                 default = nil)
  if valid_580995 != nil:
    section.add "quotaUser", valid_580995
  var valid_580996 = query.getOrDefault("alt")
  valid_580996 = validateParameter(valid_580996, JString, required = false,
                                 default = newJString("json"))
  if valid_580996 != nil:
    section.add "alt", valid_580996
  var valid_580997 = query.getOrDefault("oauth_token")
  valid_580997 = validateParameter(valid_580997, JString, required = false,
                                 default = nil)
  if valid_580997 != nil:
    section.add "oauth_token", valid_580997
  var valid_580998 = query.getOrDefault("userIp")
  valid_580998 = validateParameter(valid_580998, JString, required = false,
                                 default = nil)
  if valid_580998 != nil:
    section.add "userIp", valid_580998
  var valid_580999 = query.getOrDefault("maxResults")
  valid_580999 = validateParameter(valid_580999, JInt, required = false, default = nil)
  if valid_580999 != nil:
    section.add "maxResults", valid_580999
  var valid_581000 = query.getOrDefault("key")
  valid_581000 = validateParameter(valid_581000, JString, required = false,
                                 default = nil)
  if valid_581000 != nil:
    section.add "key", valid_581000
  var valid_581001 = query.getOrDefault("prettyPrint")
  valid_581001 = validateParameter(valid_581001, JBool, required = false,
                                 default = newJBool(true))
  if valid_581001 != nil:
    section.add "prettyPrint", valid_581001
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581002: Call_DirectoryRolesList_580989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all the roles in a domain.
  ## 
  let valid = call_581002.validator(path, query, header, formData, body)
  let scheme = call_581002.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581002.url(scheme.get, call_581002.host, call_581002.base,
                         call_581002.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581002, url, valid)

proc call*(call_581003: Call_DirectoryRolesList_580989; customer: string;
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
  var path_581004 = newJObject()
  var query_581005 = newJObject()
  add(query_581005, "fields", newJString(fields))
  add(query_581005, "pageToken", newJString(pageToken))
  add(query_581005, "quotaUser", newJString(quotaUser))
  add(query_581005, "alt", newJString(alt))
  add(query_581005, "oauth_token", newJString(oauthToken))
  add(query_581005, "userIp", newJString(userIp))
  add(query_581005, "maxResults", newJInt(maxResults))
  add(query_581005, "key", newJString(key))
  add(path_581004, "customer", newJString(customer))
  add(query_581005, "prettyPrint", newJBool(prettyPrint))
  result = call_581003.call(path_581004, query_581005, nil, nil, nil)

var directoryRolesList* = Call_DirectoryRolesList_580989(
    name: "directoryRolesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customer/{customer}/roles",
    validator: validate_DirectoryRolesList_580990, base: "/admin/directory/v1",
    url: url_DirectoryRolesList_580991, schemes: {Scheme.Https})
type
  Call_DirectoryPrivilegesList_581023 = ref object of OpenApiRestCall_579437
proc url_DirectoryPrivilegesList_581025(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryPrivilegesList_581024(path: JsonNode; query: JsonNode;
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
  var valid_581026 = path.getOrDefault("customer")
  valid_581026 = validateParameter(valid_581026, JString, required = true,
                                 default = nil)
  if valid_581026 != nil:
    section.add "customer", valid_581026
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
  var valid_581027 = query.getOrDefault("fields")
  valid_581027 = validateParameter(valid_581027, JString, required = false,
                                 default = nil)
  if valid_581027 != nil:
    section.add "fields", valid_581027
  var valid_581028 = query.getOrDefault("quotaUser")
  valid_581028 = validateParameter(valid_581028, JString, required = false,
                                 default = nil)
  if valid_581028 != nil:
    section.add "quotaUser", valid_581028
  var valid_581029 = query.getOrDefault("alt")
  valid_581029 = validateParameter(valid_581029, JString, required = false,
                                 default = newJString("json"))
  if valid_581029 != nil:
    section.add "alt", valid_581029
  var valid_581030 = query.getOrDefault("oauth_token")
  valid_581030 = validateParameter(valid_581030, JString, required = false,
                                 default = nil)
  if valid_581030 != nil:
    section.add "oauth_token", valid_581030
  var valid_581031 = query.getOrDefault("userIp")
  valid_581031 = validateParameter(valid_581031, JString, required = false,
                                 default = nil)
  if valid_581031 != nil:
    section.add "userIp", valid_581031
  var valid_581032 = query.getOrDefault("key")
  valid_581032 = validateParameter(valid_581032, JString, required = false,
                                 default = nil)
  if valid_581032 != nil:
    section.add "key", valid_581032
  var valid_581033 = query.getOrDefault("prettyPrint")
  valid_581033 = validateParameter(valid_581033, JBool, required = false,
                                 default = newJBool(true))
  if valid_581033 != nil:
    section.add "prettyPrint", valid_581033
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581034: Call_DirectoryPrivilegesList_581023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a paginated list of all privileges for a customer.
  ## 
  let valid = call_581034.validator(path, query, header, formData, body)
  let scheme = call_581034.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581034.url(scheme.get, call_581034.host, call_581034.base,
                         call_581034.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581034, url, valid)

proc call*(call_581035: Call_DirectoryPrivilegesList_581023; customer: string;
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
  var path_581036 = newJObject()
  var query_581037 = newJObject()
  add(query_581037, "fields", newJString(fields))
  add(query_581037, "quotaUser", newJString(quotaUser))
  add(query_581037, "alt", newJString(alt))
  add(query_581037, "oauth_token", newJString(oauthToken))
  add(query_581037, "userIp", newJString(userIp))
  add(query_581037, "key", newJString(key))
  add(path_581036, "customer", newJString(customer))
  add(query_581037, "prettyPrint", newJBool(prettyPrint))
  result = call_581035.call(path_581036, query_581037, nil, nil, nil)

var directoryPrivilegesList* = Call_DirectoryPrivilegesList_581023(
    name: "directoryPrivilegesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/customer/{customer}/roles/ALL/privileges",
    validator: validate_DirectoryPrivilegesList_581024,
    base: "/admin/directory/v1", url: url_DirectoryPrivilegesList_581025,
    schemes: {Scheme.Https})
type
  Call_DirectoryRolesUpdate_581054 = ref object of OpenApiRestCall_579437
proc url_DirectoryRolesUpdate_581056(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesUpdate_581055(path: JsonNode; query: JsonNode;
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
  var valid_581057 = path.getOrDefault("roleId")
  valid_581057 = validateParameter(valid_581057, JString, required = true,
                                 default = nil)
  if valid_581057 != nil:
    section.add "roleId", valid_581057
  var valid_581058 = path.getOrDefault("customer")
  valid_581058 = validateParameter(valid_581058, JString, required = true,
                                 default = nil)
  if valid_581058 != nil:
    section.add "customer", valid_581058
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
  var valid_581059 = query.getOrDefault("fields")
  valid_581059 = validateParameter(valid_581059, JString, required = false,
                                 default = nil)
  if valid_581059 != nil:
    section.add "fields", valid_581059
  var valid_581060 = query.getOrDefault("quotaUser")
  valid_581060 = validateParameter(valid_581060, JString, required = false,
                                 default = nil)
  if valid_581060 != nil:
    section.add "quotaUser", valid_581060
  var valid_581061 = query.getOrDefault("alt")
  valid_581061 = validateParameter(valid_581061, JString, required = false,
                                 default = newJString("json"))
  if valid_581061 != nil:
    section.add "alt", valid_581061
  var valid_581062 = query.getOrDefault("oauth_token")
  valid_581062 = validateParameter(valid_581062, JString, required = false,
                                 default = nil)
  if valid_581062 != nil:
    section.add "oauth_token", valid_581062
  var valid_581063 = query.getOrDefault("userIp")
  valid_581063 = validateParameter(valid_581063, JString, required = false,
                                 default = nil)
  if valid_581063 != nil:
    section.add "userIp", valid_581063
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

proc call*(call_581067: Call_DirectoryRolesUpdate_581054; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role.
  ## 
  let valid = call_581067.validator(path, query, header, formData, body)
  let scheme = call_581067.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581067.url(scheme.get, call_581067.host, call_581067.base,
                         call_581067.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581067, url, valid)

proc call*(call_581068: Call_DirectoryRolesUpdate_581054; roleId: string;
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
  var path_581069 = newJObject()
  var query_581070 = newJObject()
  var body_581071 = newJObject()
  add(query_581070, "fields", newJString(fields))
  add(query_581070, "quotaUser", newJString(quotaUser))
  add(query_581070, "alt", newJString(alt))
  add(query_581070, "oauth_token", newJString(oauthToken))
  add(query_581070, "userIp", newJString(userIp))
  add(path_581069, "roleId", newJString(roleId))
  add(query_581070, "key", newJString(key))
  add(path_581069, "customer", newJString(customer))
  if body != nil:
    body_581071 = body
  add(query_581070, "prettyPrint", newJBool(prettyPrint))
  result = call_581068.call(path_581069, query_581070, nil, nil, body_581071)

var directoryRolesUpdate* = Call_DirectoryRolesUpdate_581054(
    name: "directoryRolesUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesUpdate_581055, base: "/admin/directory/v1",
    url: url_DirectoryRolesUpdate_581056, schemes: {Scheme.Https})
type
  Call_DirectoryRolesGet_581038 = ref object of OpenApiRestCall_579437
proc url_DirectoryRolesGet_581040(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesGet_581039(path: JsonNode; query: JsonNode;
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
  var valid_581041 = path.getOrDefault("roleId")
  valid_581041 = validateParameter(valid_581041, JString, required = true,
                                 default = nil)
  if valid_581041 != nil:
    section.add "roleId", valid_581041
  var valid_581042 = path.getOrDefault("customer")
  valid_581042 = validateParameter(valid_581042, JString, required = true,
                                 default = nil)
  if valid_581042 != nil:
    section.add "customer", valid_581042
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
  var valid_581043 = query.getOrDefault("fields")
  valid_581043 = validateParameter(valid_581043, JString, required = false,
                                 default = nil)
  if valid_581043 != nil:
    section.add "fields", valid_581043
  var valid_581044 = query.getOrDefault("quotaUser")
  valid_581044 = validateParameter(valid_581044, JString, required = false,
                                 default = nil)
  if valid_581044 != nil:
    section.add "quotaUser", valid_581044
  var valid_581045 = query.getOrDefault("alt")
  valid_581045 = validateParameter(valid_581045, JString, required = false,
                                 default = newJString("json"))
  if valid_581045 != nil:
    section.add "alt", valid_581045
  var valid_581046 = query.getOrDefault("oauth_token")
  valid_581046 = validateParameter(valid_581046, JString, required = false,
                                 default = nil)
  if valid_581046 != nil:
    section.add "oauth_token", valid_581046
  var valid_581047 = query.getOrDefault("userIp")
  valid_581047 = validateParameter(valid_581047, JString, required = false,
                                 default = nil)
  if valid_581047 != nil:
    section.add "userIp", valid_581047
  var valid_581048 = query.getOrDefault("key")
  valid_581048 = validateParameter(valid_581048, JString, required = false,
                                 default = nil)
  if valid_581048 != nil:
    section.add "key", valid_581048
  var valid_581049 = query.getOrDefault("prettyPrint")
  valid_581049 = validateParameter(valid_581049, JBool, required = false,
                                 default = newJBool(true))
  if valid_581049 != nil:
    section.add "prettyPrint", valid_581049
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581050: Call_DirectoryRolesGet_581038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a role.
  ## 
  let valid = call_581050.validator(path, query, header, formData, body)
  let scheme = call_581050.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581050.url(scheme.get, call_581050.host, call_581050.base,
                         call_581050.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581050, url, valid)

proc call*(call_581051: Call_DirectoryRolesGet_581038; roleId: string;
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
  var path_581052 = newJObject()
  var query_581053 = newJObject()
  add(query_581053, "fields", newJString(fields))
  add(query_581053, "quotaUser", newJString(quotaUser))
  add(query_581053, "alt", newJString(alt))
  add(query_581053, "oauth_token", newJString(oauthToken))
  add(query_581053, "userIp", newJString(userIp))
  add(path_581052, "roleId", newJString(roleId))
  add(query_581053, "key", newJString(key))
  add(path_581052, "customer", newJString(customer))
  add(query_581053, "prettyPrint", newJBool(prettyPrint))
  result = call_581051.call(path_581052, query_581053, nil, nil, nil)

var directoryRolesGet* = Call_DirectoryRolesGet_581038(name: "directoryRolesGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesGet_581039, base: "/admin/directory/v1",
    url: url_DirectoryRolesGet_581040, schemes: {Scheme.Https})
type
  Call_DirectoryRolesPatch_581088 = ref object of OpenApiRestCall_579437
proc url_DirectoryRolesPatch_581090(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesPatch_581089(path: JsonNode; query: JsonNode;
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
  var valid_581091 = path.getOrDefault("roleId")
  valid_581091 = validateParameter(valid_581091, JString, required = true,
                                 default = nil)
  if valid_581091 != nil:
    section.add "roleId", valid_581091
  var valid_581092 = path.getOrDefault("customer")
  valid_581092 = validateParameter(valid_581092, JString, required = true,
                                 default = nil)
  if valid_581092 != nil:
    section.add "customer", valid_581092
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
  var valid_581093 = query.getOrDefault("fields")
  valid_581093 = validateParameter(valid_581093, JString, required = false,
                                 default = nil)
  if valid_581093 != nil:
    section.add "fields", valid_581093
  var valid_581094 = query.getOrDefault("quotaUser")
  valid_581094 = validateParameter(valid_581094, JString, required = false,
                                 default = nil)
  if valid_581094 != nil:
    section.add "quotaUser", valid_581094
  var valid_581095 = query.getOrDefault("alt")
  valid_581095 = validateParameter(valid_581095, JString, required = false,
                                 default = newJString("json"))
  if valid_581095 != nil:
    section.add "alt", valid_581095
  var valid_581096 = query.getOrDefault("oauth_token")
  valid_581096 = validateParameter(valid_581096, JString, required = false,
                                 default = nil)
  if valid_581096 != nil:
    section.add "oauth_token", valid_581096
  var valid_581097 = query.getOrDefault("userIp")
  valid_581097 = validateParameter(valid_581097, JString, required = false,
                                 default = nil)
  if valid_581097 != nil:
    section.add "userIp", valid_581097
  var valid_581098 = query.getOrDefault("key")
  valid_581098 = validateParameter(valid_581098, JString, required = false,
                                 default = nil)
  if valid_581098 != nil:
    section.add "key", valid_581098
  var valid_581099 = query.getOrDefault("prettyPrint")
  valid_581099 = validateParameter(valid_581099, JBool, required = false,
                                 default = newJBool(true))
  if valid_581099 != nil:
    section.add "prettyPrint", valid_581099
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

proc call*(call_581101: Call_DirectoryRolesPatch_581088; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a role. This method supports patch semantics.
  ## 
  let valid = call_581101.validator(path, query, header, formData, body)
  let scheme = call_581101.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581101.url(scheme.get, call_581101.host, call_581101.base,
                         call_581101.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581101, url, valid)

proc call*(call_581102: Call_DirectoryRolesPatch_581088; roleId: string;
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
  var path_581103 = newJObject()
  var query_581104 = newJObject()
  var body_581105 = newJObject()
  add(query_581104, "fields", newJString(fields))
  add(query_581104, "quotaUser", newJString(quotaUser))
  add(query_581104, "alt", newJString(alt))
  add(query_581104, "oauth_token", newJString(oauthToken))
  add(query_581104, "userIp", newJString(userIp))
  add(path_581103, "roleId", newJString(roleId))
  add(query_581104, "key", newJString(key))
  add(path_581103, "customer", newJString(customer))
  if body != nil:
    body_581105 = body
  add(query_581104, "prettyPrint", newJBool(prettyPrint))
  result = call_581102.call(path_581103, query_581104, nil, nil, body_581105)

var directoryRolesPatch* = Call_DirectoryRolesPatch_581088(
    name: "directoryRolesPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesPatch_581089, base: "/admin/directory/v1",
    url: url_DirectoryRolesPatch_581090, schemes: {Scheme.Https})
type
  Call_DirectoryRolesDelete_581072 = ref object of OpenApiRestCall_579437
proc url_DirectoryRolesDelete_581074(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryRolesDelete_581073(path: JsonNode; query: JsonNode;
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
  var valid_581075 = path.getOrDefault("roleId")
  valid_581075 = validateParameter(valid_581075, JString, required = true,
                                 default = nil)
  if valid_581075 != nil:
    section.add "roleId", valid_581075
  var valid_581076 = path.getOrDefault("customer")
  valid_581076 = validateParameter(valid_581076, JString, required = true,
                                 default = nil)
  if valid_581076 != nil:
    section.add "customer", valid_581076
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
  var valid_581077 = query.getOrDefault("fields")
  valid_581077 = validateParameter(valid_581077, JString, required = false,
                                 default = nil)
  if valid_581077 != nil:
    section.add "fields", valid_581077
  var valid_581078 = query.getOrDefault("quotaUser")
  valid_581078 = validateParameter(valid_581078, JString, required = false,
                                 default = nil)
  if valid_581078 != nil:
    section.add "quotaUser", valid_581078
  var valid_581079 = query.getOrDefault("alt")
  valid_581079 = validateParameter(valid_581079, JString, required = false,
                                 default = newJString("json"))
  if valid_581079 != nil:
    section.add "alt", valid_581079
  var valid_581080 = query.getOrDefault("oauth_token")
  valid_581080 = validateParameter(valid_581080, JString, required = false,
                                 default = nil)
  if valid_581080 != nil:
    section.add "oauth_token", valid_581080
  var valid_581081 = query.getOrDefault("userIp")
  valid_581081 = validateParameter(valid_581081, JString, required = false,
                                 default = nil)
  if valid_581081 != nil:
    section.add "userIp", valid_581081
  var valid_581082 = query.getOrDefault("key")
  valid_581082 = validateParameter(valid_581082, JString, required = false,
                                 default = nil)
  if valid_581082 != nil:
    section.add "key", valid_581082
  var valid_581083 = query.getOrDefault("prettyPrint")
  valid_581083 = validateParameter(valid_581083, JBool, required = false,
                                 default = newJBool(true))
  if valid_581083 != nil:
    section.add "prettyPrint", valid_581083
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581084: Call_DirectoryRolesDelete_581072; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a role.
  ## 
  let valid = call_581084.validator(path, query, header, formData, body)
  let scheme = call_581084.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581084.url(scheme.get, call_581084.host, call_581084.base,
                         call_581084.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581084, url, valid)

proc call*(call_581085: Call_DirectoryRolesDelete_581072; roleId: string;
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
  var path_581086 = newJObject()
  var query_581087 = newJObject()
  add(query_581087, "fields", newJString(fields))
  add(query_581087, "quotaUser", newJString(quotaUser))
  add(query_581087, "alt", newJString(alt))
  add(query_581087, "oauth_token", newJString(oauthToken))
  add(query_581087, "userIp", newJString(userIp))
  add(path_581086, "roleId", newJString(roleId))
  add(query_581087, "key", newJString(key))
  add(path_581086, "customer", newJString(customer))
  add(query_581087, "prettyPrint", newJBool(prettyPrint))
  result = call_581085.call(path_581086, query_581087, nil, nil, nil)

var directoryRolesDelete* = Call_DirectoryRolesDelete_581072(
    name: "directoryRolesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/customer/{customer}/roles/{roleId}",
    validator: validate_DirectoryRolesDelete_581073, base: "/admin/directory/v1",
    url: url_DirectoryRolesDelete_581074, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersUpdate_581121 = ref object of OpenApiRestCall_579437
proc url_DirectoryCustomersUpdate_581123(protocol: Scheme; host: string;
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

proc validate_DirectoryCustomersUpdate_581122(path: JsonNode; query: JsonNode;
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
  var valid_581124 = path.getOrDefault("customerKey")
  valid_581124 = validateParameter(valid_581124, JString, required = true,
                                 default = nil)
  if valid_581124 != nil:
    section.add "customerKey", valid_581124
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
  var valid_581125 = query.getOrDefault("fields")
  valid_581125 = validateParameter(valid_581125, JString, required = false,
                                 default = nil)
  if valid_581125 != nil:
    section.add "fields", valid_581125
  var valid_581126 = query.getOrDefault("quotaUser")
  valid_581126 = validateParameter(valid_581126, JString, required = false,
                                 default = nil)
  if valid_581126 != nil:
    section.add "quotaUser", valid_581126
  var valid_581127 = query.getOrDefault("alt")
  valid_581127 = validateParameter(valid_581127, JString, required = false,
                                 default = newJString("json"))
  if valid_581127 != nil:
    section.add "alt", valid_581127
  var valid_581128 = query.getOrDefault("oauth_token")
  valid_581128 = validateParameter(valid_581128, JString, required = false,
                                 default = nil)
  if valid_581128 != nil:
    section.add "oauth_token", valid_581128
  var valid_581129 = query.getOrDefault("userIp")
  valid_581129 = validateParameter(valid_581129, JString, required = false,
                                 default = nil)
  if valid_581129 != nil:
    section.add "userIp", valid_581129
  var valid_581130 = query.getOrDefault("key")
  valid_581130 = validateParameter(valid_581130, JString, required = false,
                                 default = nil)
  if valid_581130 != nil:
    section.add "key", valid_581130
  var valid_581131 = query.getOrDefault("prettyPrint")
  valid_581131 = validateParameter(valid_581131, JBool, required = false,
                                 default = newJBool(true))
  if valid_581131 != nil:
    section.add "prettyPrint", valid_581131
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

proc call*(call_581133: Call_DirectoryCustomersUpdate_581121; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer.
  ## 
  let valid = call_581133.validator(path, query, header, formData, body)
  let scheme = call_581133.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581133.url(scheme.get, call_581133.host, call_581133.base,
                         call_581133.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581133, url, valid)

proc call*(call_581134: Call_DirectoryCustomersUpdate_581121; customerKey: string;
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
  var path_581135 = newJObject()
  var query_581136 = newJObject()
  var body_581137 = newJObject()
  add(path_581135, "customerKey", newJString(customerKey))
  add(query_581136, "fields", newJString(fields))
  add(query_581136, "quotaUser", newJString(quotaUser))
  add(query_581136, "alt", newJString(alt))
  add(query_581136, "oauth_token", newJString(oauthToken))
  add(query_581136, "userIp", newJString(userIp))
  add(query_581136, "key", newJString(key))
  if body != nil:
    body_581137 = body
  add(query_581136, "prettyPrint", newJBool(prettyPrint))
  result = call_581134.call(path_581135, query_581136, nil, nil, body_581137)

var directoryCustomersUpdate* = Call_DirectoryCustomersUpdate_581121(
    name: "directoryCustomersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersUpdate_581122,
    base: "/admin/directory/v1", url: url_DirectoryCustomersUpdate_581123,
    schemes: {Scheme.Https})
type
  Call_DirectoryCustomersGet_581106 = ref object of OpenApiRestCall_579437
proc url_DirectoryCustomersGet_581108(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryCustomersGet_581107(path: JsonNode; query: JsonNode;
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
  var valid_581109 = path.getOrDefault("customerKey")
  valid_581109 = validateParameter(valid_581109, JString, required = true,
                                 default = nil)
  if valid_581109 != nil:
    section.add "customerKey", valid_581109
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
  var valid_581110 = query.getOrDefault("fields")
  valid_581110 = validateParameter(valid_581110, JString, required = false,
                                 default = nil)
  if valid_581110 != nil:
    section.add "fields", valid_581110
  var valid_581111 = query.getOrDefault("quotaUser")
  valid_581111 = validateParameter(valid_581111, JString, required = false,
                                 default = nil)
  if valid_581111 != nil:
    section.add "quotaUser", valid_581111
  var valid_581112 = query.getOrDefault("alt")
  valid_581112 = validateParameter(valid_581112, JString, required = false,
                                 default = newJString("json"))
  if valid_581112 != nil:
    section.add "alt", valid_581112
  var valid_581113 = query.getOrDefault("oauth_token")
  valid_581113 = validateParameter(valid_581113, JString, required = false,
                                 default = nil)
  if valid_581113 != nil:
    section.add "oauth_token", valid_581113
  var valid_581114 = query.getOrDefault("userIp")
  valid_581114 = validateParameter(valid_581114, JString, required = false,
                                 default = nil)
  if valid_581114 != nil:
    section.add "userIp", valid_581114
  var valid_581115 = query.getOrDefault("key")
  valid_581115 = validateParameter(valid_581115, JString, required = false,
                                 default = nil)
  if valid_581115 != nil:
    section.add "key", valid_581115
  var valid_581116 = query.getOrDefault("prettyPrint")
  valid_581116 = validateParameter(valid_581116, JBool, required = false,
                                 default = newJBool(true))
  if valid_581116 != nil:
    section.add "prettyPrint", valid_581116
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581117: Call_DirectoryCustomersGet_581106; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a customer.
  ## 
  let valid = call_581117.validator(path, query, header, formData, body)
  let scheme = call_581117.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581117.url(scheme.get, call_581117.host, call_581117.base,
                         call_581117.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581117, url, valid)

proc call*(call_581118: Call_DirectoryCustomersGet_581106; customerKey: string;
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
  var path_581119 = newJObject()
  var query_581120 = newJObject()
  add(path_581119, "customerKey", newJString(customerKey))
  add(query_581120, "fields", newJString(fields))
  add(query_581120, "quotaUser", newJString(quotaUser))
  add(query_581120, "alt", newJString(alt))
  add(query_581120, "oauth_token", newJString(oauthToken))
  add(query_581120, "userIp", newJString(userIp))
  add(query_581120, "key", newJString(key))
  add(query_581120, "prettyPrint", newJBool(prettyPrint))
  result = call_581118.call(path_581119, query_581120, nil, nil, nil)

var directoryCustomersGet* = Call_DirectoryCustomersGet_581106(
    name: "directoryCustomersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersGet_581107, base: "/admin/directory/v1",
    url: url_DirectoryCustomersGet_581108, schemes: {Scheme.Https})
type
  Call_DirectoryCustomersPatch_581138 = ref object of OpenApiRestCall_579437
proc url_DirectoryCustomersPatch_581140(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryCustomersPatch_581139(path: JsonNode; query: JsonNode;
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
  var valid_581141 = path.getOrDefault("customerKey")
  valid_581141 = validateParameter(valid_581141, JString, required = true,
                                 default = nil)
  if valid_581141 != nil:
    section.add "customerKey", valid_581141
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
  var valid_581142 = query.getOrDefault("fields")
  valid_581142 = validateParameter(valid_581142, JString, required = false,
                                 default = nil)
  if valid_581142 != nil:
    section.add "fields", valid_581142
  var valid_581143 = query.getOrDefault("quotaUser")
  valid_581143 = validateParameter(valid_581143, JString, required = false,
                                 default = nil)
  if valid_581143 != nil:
    section.add "quotaUser", valid_581143
  var valid_581144 = query.getOrDefault("alt")
  valid_581144 = validateParameter(valid_581144, JString, required = false,
                                 default = newJString("json"))
  if valid_581144 != nil:
    section.add "alt", valid_581144
  var valid_581145 = query.getOrDefault("oauth_token")
  valid_581145 = validateParameter(valid_581145, JString, required = false,
                                 default = nil)
  if valid_581145 != nil:
    section.add "oauth_token", valid_581145
  var valid_581146 = query.getOrDefault("userIp")
  valid_581146 = validateParameter(valid_581146, JString, required = false,
                                 default = nil)
  if valid_581146 != nil:
    section.add "userIp", valid_581146
  var valid_581147 = query.getOrDefault("key")
  valid_581147 = validateParameter(valid_581147, JString, required = false,
                                 default = nil)
  if valid_581147 != nil:
    section.add "key", valid_581147
  var valid_581148 = query.getOrDefault("prettyPrint")
  valid_581148 = validateParameter(valid_581148, JBool, required = false,
                                 default = newJBool(true))
  if valid_581148 != nil:
    section.add "prettyPrint", valid_581148
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

proc call*(call_581150: Call_DirectoryCustomersPatch_581138; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a customer. This method supports patch semantics.
  ## 
  let valid = call_581150.validator(path, query, header, formData, body)
  let scheme = call_581150.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581150.url(scheme.get, call_581150.host, call_581150.base,
                         call_581150.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581150, url, valid)

proc call*(call_581151: Call_DirectoryCustomersPatch_581138; customerKey: string;
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
  var path_581152 = newJObject()
  var query_581153 = newJObject()
  var body_581154 = newJObject()
  add(path_581152, "customerKey", newJString(customerKey))
  add(query_581153, "fields", newJString(fields))
  add(query_581153, "quotaUser", newJString(quotaUser))
  add(query_581153, "alt", newJString(alt))
  add(query_581153, "oauth_token", newJString(oauthToken))
  add(query_581153, "userIp", newJString(userIp))
  add(query_581153, "key", newJString(key))
  if body != nil:
    body_581154 = body
  add(query_581153, "prettyPrint", newJBool(prettyPrint))
  result = call_581151.call(path_581152, query_581153, nil, nil, body_581154)

var directoryCustomersPatch* = Call_DirectoryCustomersPatch_581138(
    name: "directoryCustomersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/customers/{customerKey}",
    validator: validate_DirectoryCustomersPatch_581139,
    base: "/admin/directory/v1", url: url_DirectoryCustomersPatch_581140,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsInsert_581176 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsInsert_581178(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryGroupsInsert_581177(path: JsonNode; query: JsonNode;
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
  var valid_581179 = query.getOrDefault("fields")
  valid_581179 = validateParameter(valid_581179, JString, required = false,
                                 default = nil)
  if valid_581179 != nil:
    section.add "fields", valid_581179
  var valid_581180 = query.getOrDefault("quotaUser")
  valid_581180 = validateParameter(valid_581180, JString, required = false,
                                 default = nil)
  if valid_581180 != nil:
    section.add "quotaUser", valid_581180
  var valid_581181 = query.getOrDefault("alt")
  valid_581181 = validateParameter(valid_581181, JString, required = false,
                                 default = newJString("json"))
  if valid_581181 != nil:
    section.add "alt", valid_581181
  var valid_581182 = query.getOrDefault("oauth_token")
  valid_581182 = validateParameter(valid_581182, JString, required = false,
                                 default = nil)
  if valid_581182 != nil:
    section.add "oauth_token", valid_581182
  var valid_581183 = query.getOrDefault("userIp")
  valid_581183 = validateParameter(valid_581183, JString, required = false,
                                 default = nil)
  if valid_581183 != nil:
    section.add "userIp", valid_581183
  var valid_581184 = query.getOrDefault("key")
  valid_581184 = validateParameter(valid_581184, JString, required = false,
                                 default = nil)
  if valid_581184 != nil:
    section.add "key", valid_581184
  var valid_581185 = query.getOrDefault("prettyPrint")
  valid_581185 = validateParameter(valid_581185, JBool, required = false,
                                 default = newJBool(true))
  if valid_581185 != nil:
    section.add "prettyPrint", valid_581185
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

proc call*(call_581187: Call_DirectoryGroupsInsert_581176; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Create Group
  ## 
  let valid = call_581187.validator(path, query, header, formData, body)
  let scheme = call_581187.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581187.url(scheme.get, call_581187.host, call_581187.base,
                         call_581187.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581187, url, valid)

proc call*(call_581188: Call_DirectoryGroupsInsert_581176; fields: string = "";
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
  var query_581189 = newJObject()
  var body_581190 = newJObject()
  add(query_581189, "fields", newJString(fields))
  add(query_581189, "quotaUser", newJString(quotaUser))
  add(query_581189, "alt", newJString(alt))
  add(query_581189, "oauth_token", newJString(oauthToken))
  add(query_581189, "userIp", newJString(userIp))
  add(query_581189, "key", newJString(key))
  if body != nil:
    body_581190 = body
  add(query_581189, "prettyPrint", newJBool(prettyPrint))
  result = call_581188.call(nil, query_581189, nil, nil, body_581190)

var directoryGroupsInsert* = Call_DirectoryGroupsInsert_581176(
    name: "directoryGroupsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsInsert_581177, base: "/admin/directory/v1",
    url: url_DirectoryGroupsInsert_581178, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsList_581155 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsList_581157(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryGroupsList_581156(path: JsonNode; query: JsonNode;
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
  var valid_581158 = query.getOrDefault("fields")
  valid_581158 = validateParameter(valid_581158, JString, required = false,
                                 default = nil)
  if valid_581158 != nil:
    section.add "fields", valid_581158
  var valid_581159 = query.getOrDefault("pageToken")
  valid_581159 = validateParameter(valid_581159, JString, required = false,
                                 default = nil)
  if valid_581159 != nil:
    section.add "pageToken", valid_581159
  var valid_581160 = query.getOrDefault("quotaUser")
  valid_581160 = validateParameter(valid_581160, JString, required = false,
                                 default = nil)
  if valid_581160 != nil:
    section.add "quotaUser", valid_581160
  var valid_581161 = query.getOrDefault("alt")
  valid_581161 = validateParameter(valid_581161, JString, required = false,
                                 default = newJString("json"))
  if valid_581161 != nil:
    section.add "alt", valid_581161
  var valid_581162 = query.getOrDefault("query")
  valid_581162 = validateParameter(valid_581162, JString, required = false,
                                 default = nil)
  if valid_581162 != nil:
    section.add "query", valid_581162
  var valid_581163 = query.getOrDefault("oauth_token")
  valid_581163 = validateParameter(valid_581163, JString, required = false,
                                 default = nil)
  if valid_581163 != nil:
    section.add "oauth_token", valid_581163
  var valid_581164 = query.getOrDefault("userIp")
  valid_581164 = validateParameter(valid_581164, JString, required = false,
                                 default = nil)
  if valid_581164 != nil:
    section.add "userIp", valid_581164
  var valid_581165 = query.getOrDefault("maxResults")
  valid_581165 = validateParameter(valid_581165, JInt, required = false,
                                 default = newJInt(200))
  if valid_581165 != nil:
    section.add "maxResults", valid_581165
  var valid_581166 = query.getOrDefault("orderBy")
  valid_581166 = validateParameter(valid_581166, JString, required = false,
                                 default = newJString("email"))
  if valid_581166 != nil:
    section.add "orderBy", valid_581166
  var valid_581167 = query.getOrDefault("key")
  valid_581167 = validateParameter(valid_581167, JString, required = false,
                                 default = nil)
  if valid_581167 != nil:
    section.add "key", valid_581167
  var valid_581168 = query.getOrDefault("sortOrder")
  valid_581168 = validateParameter(valid_581168, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_581168 != nil:
    section.add "sortOrder", valid_581168
  var valid_581169 = query.getOrDefault("customer")
  valid_581169 = validateParameter(valid_581169, JString, required = false,
                                 default = nil)
  if valid_581169 != nil:
    section.add "customer", valid_581169
  var valid_581170 = query.getOrDefault("prettyPrint")
  valid_581170 = validateParameter(valid_581170, JBool, required = false,
                                 default = newJBool(true))
  if valid_581170 != nil:
    section.add "prettyPrint", valid_581170
  var valid_581171 = query.getOrDefault("domain")
  valid_581171 = validateParameter(valid_581171, JString, required = false,
                                 default = nil)
  if valid_581171 != nil:
    section.add "domain", valid_581171
  var valid_581172 = query.getOrDefault("userKey")
  valid_581172 = validateParameter(valid_581172, JString, required = false,
                                 default = nil)
  if valid_581172 != nil:
    section.add "userKey", valid_581172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581173: Call_DirectoryGroupsList_581155; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all groups of a domain or of a user given a userKey (paginated)
  ## 
  let valid = call_581173.validator(path, query, header, formData, body)
  let scheme = call_581173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581173.url(scheme.get, call_581173.host, call_581173.base,
                         call_581173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581173, url, valid)

proc call*(call_581174: Call_DirectoryGroupsList_581155; fields: string = "";
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
  var query_581175 = newJObject()
  add(query_581175, "fields", newJString(fields))
  add(query_581175, "pageToken", newJString(pageToken))
  add(query_581175, "quotaUser", newJString(quotaUser))
  add(query_581175, "alt", newJString(alt))
  add(query_581175, "query", newJString(query))
  add(query_581175, "oauth_token", newJString(oauthToken))
  add(query_581175, "userIp", newJString(userIp))
  add(query_581175, "maxResults", newJInt(maxResults))
  add(query_581175, "orderBy", newJString(orderBy))
  add(query_581175, "key", newJString(key))
  add(query_581175, "sortOrder", newJString(sortOrder))
  add(query_581175, "customer", newJString(customer))
  add(query_581175, "prettyPrint", newJBool(prettyPrint))
  add(query_581175, "domain", newJString(domain))
  add(query_581175, "userKey", newJString(userKey))
  result = call_581174.call(nil, query_581175, nil, nil, nil)

var directoryGroupsList* = Call_DirectoryGroupsList_581155(
    name: "directoryGroupsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups",
    validator: validate_DirectoryGroupsList_581156, base: "/admin/directory/v1",
    url: url_DirectoryGroupsList_581157, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsUpdate_581206 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsUpdate_581208(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryGroupsUpdate_581207(path: JsonNode; query: JsonNode;
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
  var valid_581209 = path.getOrDefault("groupKey")
  valid_581209 = validateParameter(valid_581209, JString, required = true,
                                 default = nil)
  if valid_581209 != nil:
    section.add "groupKey", valid_581209
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
  var valid_581210 = query.getOrDefault("fields")
  valid_581210 = validateParameter(valid_581210, JString, required = false,
                                 default = nil)
  if valid_581210 != nil:
    section.add "fields", valid_581210
  var valid_581211 = query.getOrDefault("quotaUser")
  valid_581211 = validateParameter(valid_581211, JString, required = false,
                                 default = nil)
  if valid_581211 != nil:
    section.add "quotaUser", valid_581211
  var valid_581212 = query.getOrDefault("alt")
  valid_581212 = validateParameter(valid_581212, JString, required = false,
                                 default = newJString("json"))
  if valid_581212 != nil:
    section.add "alt", valid_581212
  var valid_581213 = query.getOrDefault("oauth_token")
  valid_581213 = validateParameter(valid_581213, JString, required = false,
                                 default = nil)
  if valid_581213 != nil:
    section.add "oauth_token", valid_581213
  var valid_581214 = query.getOrDefault("userIp")
  valid_581214 = validateParameter(valid_581214, JString, required = false,
                                 default = nil)
  if valid_581214 != nil:
    section.add "userIp", valid_581214
  var valid_581215 = query.getOrDefault("key")
  valid_581215 = validateParameter(valid_581215, JString, required = false,
                                 default = nil)
  if valid_581215 != nil:
    section.add "key", valid_581215
  var valid_581216 = query.getOrDefault("prettyPrint")
  valid_581216 = validateParameter(valid_581216, JBool, required = false,
                                 default = newJBool(true))
  if valid_581216 != nil:
    section.add "prettyPrint", valid_581216
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

proc call*(call_581218: Call_DirectoryGroupsUpdate_581206; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group
  ## 
  let valid = call_581218.validator(path, query, header, formData, body)
  let scheme = call_581218.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581218.url(scheme.get, call_581218.host, call_581218.base,
                         call_581218.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581218, url, valid)

proc call*(call_581219: Call_DirectoryGroupsUpdate_581206; groupKey: string;
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
  var path_581220 = newJObject()
  var query_581221 = newJObject()
  var body_581222 = newJObject()
  add(query_581221, "fields", newJString(fields))
  add(query_581221, "quotaUser", newJString(quotaUser))
  add(query_581221, "alt", newJString(alt))
  add(query_581221, "oauth_token", newJString(oauthToken))
  add(query_581221, "userIp", newJString(userIp))
  add(query_581221, "key", newJString(key))
  if body != nil:
    body_581222 = body
  add(query_581221, "prettyPrint", newJBool(prettyPrint))
  add(path_581220, "groupKey", newJString(groupKey))
  result = call_581219.call(path_581220, query_581221, nil, nil, body_581222)

var directoryGroupsUpdate* = Call_DirectoryGroupsUpdate_581206(
    name: "directoryGroupsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsUpdate_581207, base: "/admin/directory/v1",
    url: url_DirectoryGroupsUpdate_581208, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsGet_581191 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsGet_581193(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryGroupsGet_581192(path: JsonNode; query: JsonNode;
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
  var valid_581194 = path.getOrDefault("groupKey")
  valid_581194 = validateParameter(valid_581194, JString, required = true,
                                 default = nil)
  if valid_581194 != nil:
    section.add "groupKey", valid_581194
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
  var valid_581195 = query.getOrDefault("fields")
  valid_581195 = validateParameter(valid_581195, JString, required = false,
                                 default = nil)
  if valid_581195 != nil:
    section.add "fields", valid_581195
  var valid_581196 = query.getOrDefault("quotaUser")
  valid_581196 = validateParameter(valid_581196, JString, required = false,
                                 default = nil)
  if valid_581196 != nil:
    section.add "quotaUser", valid_581196
  var valid_581197 = query.getOrDefault("alt")
  valid_581197 = validateParameter(valid_581197, JString, required = false,
                                 default = newJString("json"))
  if valid_581197 != nil:
    section.add "alt", valid_581197
  var valid_581198 = query.getOrDefault("oauth_token")
  valid_581198 = validateParameter(valid_581198, JString, required = false,
                                 default = nil)
  if valid_581198 != nil:
    section.add "oauth_token", valid_581198
  var valid_581199 = query.getOrDefault("userIp")
  valid_581199 = validateParameter(valid_581199, JString, required = false,
                                 default = nil)
  if valid_581199 != nil:
    section.add "userIp", valid_581199
  var valid_581200 = query.getOrDefault("key")
  valid_581200 = validateParameter(valid_581200, JString, required = false,
                                 default = nil)
  if valid_581200 != nil:
    section.add "key", valid_581200
  var valid_581201 = query.getOrDefault("prettyPrint")
  valid_581201 = validateParameter(valid_581201, JBool, required = false,
                                 default = newJBool(true))
  if valid_581201 != nil:
    section.add "prettyPrint", valid_581201
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581202: Call_DirectoryGroupsGet_581191; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group
  ## 
  let valid = call_581202.validator(path, query, header, formData, body)
  let scheme = call_581202.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581202.url(scheme.get, call_581202.host, call_581202.base,
                         call_581202.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581202, url, valid)

proc call*(call_581203: Call_DirectoryGroupsGet_581191; groupKey: string;
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
  var path_581204 = newJObject()
  var query_581205 = newJObject()
  add(query_581205, "fields", newJString(fields))
  add(query_581205, "quotaUser", newJString(quotaUser))
  add(query_581205, "alt", newJString(alt))
  add(query_581205, "oauth_token", newJString(oauthToken))
  add(query_581205, "userIp", newJString(userIp))
  add(query_581205, "key", newJString(key))
  add(query_581205, "prettyPrint", newJBool(prettyPrint))
  add(path_581204, "groupKey", newJString(groupKey))
  result = call_581203.call(path_581204, query_581205, nil, nil, nil)

var directoryGroupsGet* = Call_DirectoryGroupsGet_581191(
    name: "directoryGroupsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsGet_581192, base: "/admin/directory/v1",
    url: url_DirectoryGroupsGet_581193, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsPatch_581238 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsPatch_581240(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryGroupsPatch_581239(path: JsonNode; query: JsonNode;
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
  var valid_581241 = path.getOrDefault("groupKey")
  valid_581241 = validateParameter(valid_581241, JString, required = true,
                                 default = nil)
  if valid_581241 != nil:
    section.add "groupKey", valid_581241
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
  var valid_581242 = query.getOrDefault("fields")
  valid_581242 = validateParameter(valid_581242, JString, required = false,
                                 default = nil)
  if valid_581242 != nil:
    section.add "fields", valid_581242
  var valid_581243 = query.getOrDefault("quotaUser")
  valid_581243 = validateParameter(valid_581243, JString, required = false,
                                 default = nil)
  if valid_581243 != nil:
    section.add "quotaUser", valid_581243
  var valid_581244 = query.getOrDefault("alt")
  valid_581244 = validateParameter(valid_581244, JString, required = false,
                                 default = newJString("json"))
  if valid_581244 != nil:
    section.add "alt", valid_581244
  var valid_581245 = query.getOrDefault("oauth_token")
  valid_581245 = validateParameter(valid_581245, JString, required = false,
                                 default = nil)
  if valid_581245 != nil:
    section.add "oauth_token", valid_581245
  var valid_581246 = query.getOrDefault("userIp")
  valid_581246 = validateParameter(valid_581246, JString, required = false,
                                 default = nil)
  if valid_581246 != nil:
    section.add "userIp", valid_581246
  var valid_581247 = query.getOrDefault("key")
  valid_581247 = validateParameter(valid_581247, JString, required = false,
                                 default = nil)
  if valid_581247 != nil:
    section.add "key", valid_581247
  var valid_581248 = query.getOrDefault("prettyPrint")
  valid_581248 = validateParameter(valid_581248, JBool, required = false,
                                 default = newJBool(true))
  if valid_581248 != nil:
    section.add "prettyPrint", valid_581248
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

proc call*(call_581250: Call_DirectoryGroupsPatch_581238; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update Group. This method supports patch semantics.
  ## 
  let valid = call_581250.validator(path, query, header, formData, body)
  let scheme = call_581250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581250.url(scheme.get, call_581250.host, call_581250.base,
                         call_581250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581250, url, valid)

proc call*(call_581251: Call_DirectoryGroupsPatch_581238; groupKey: string;
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
  var path_581252 = newJObject()
  var query_581253 = newJObject()
  var body_581254 = newJObject()
  add(query_581253, "fields", newJString(fields))
  add(query_581253, "quotaUser", newJString(quotaUser))
  add(query_581253, "alt", newJString(alt))
  add(query_581253, "oauth_token", newJString(oauthToken))
  add(query_581253, "userIp", newJString(userIp))
  add(query_581253, "key", newJString(key))
  if body != nil:
    body_581254 = body
  add(query_581253, "prettyPrint", newJBool(prettyPrint))
  add(path_581252, "groupKey", newJString(groupKey))
  result = call_581251.call(path_581252, query_581253, nil, nil, body_581254)

var directoryGroupsPatch* = Call_DirectoryGroupsPatch_581238(
    name: "directoryGroupsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsPatch_581239, base: "/admin/directory/v1",
    url: url_DirectoryGroupsPatch_581240, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsDelete_581223 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsDelete_581225(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryGroupsDelete_581224(path: JsonNode; query: JsonNode;
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
  var valid_581226 = path.getOrDefault("groupKey")
  valid_581226 = validateParameter(valid_581226, JString, required = true,
                                 default = nil)
  if valid_581226 != nil:
    section.add "groupKey", valid_581226
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
  var valid_581227 = query.getOrDefault("fields")
  valid_581227 = validateParameter(valid_581227, JString, required = false,
                                 default = nil)
  if valid_581227 != nil:
    section.add "fields", valid_581227
  var valid_581228 = query.getOrDefault("quotaUser")
  valid_581228 = validateParameter(valid_581228, JString, required = false,
                                 default = nil)
  if valid_581228 != nil:
    section.add "quotaUser", valid_581228
  var valid_581229 = query.getOrDefault("alt")
  valid_581229 = validateParameter(valid_581229, JString, required = false,
                                 default = newJString("json"))
  if valid_581229 != nil:
    section.add "alt", valid_581229
  var valid_581230 = query.getOrDefault("oauth_token")
  valid_581230 = validateParameter(valid_581230, JString, required = false,
                                 default = nil)
  if valid_581230 != nil:
    section.add "oauth_token", valid_581230
  var valid_581231 = query.getOrDefault("userIp")
  valid_581231 = validateParameter(valid_581231, JString, required = false,
                                 default = nil)
  if valid_581231 != nil:
    section.add "userIp", valid_581231
  var valid_581232 = query.getOrDefault("key")
  valid_581232 = validateParameter(valid_581232, JString, required = false,
                                 default = nil)
  if valid_581232 != nil:
    section.add "key", valid_581232
  var valid_581233 = query.getOrDefault("prettyPrint")
  valid_581233 = validateParameter(valid_581233, JBool, required = false,
                                 default = newJBool(true))
  if valid_581233 != nil:
    section.add "prettyPrint", valid_581233
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581234: Call_DirectoryGroupsDelete_581223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete Group
  ## 
  let valid = call_581234.validator(path, query, header, formData, body)
  let scheme = call_581234.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581234.url(scheme.get, call_581234.host, call_581234.base,
                         call_581234.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581234, url, valid)

proc call*(call_581235: Call_DirectoryGroupsDelete_581223; groupKey: string;
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
  var path_581236 = newJObject()
  var query_581237 = newJObject()
  add(query_581237, "fields", newJString(fields))
  add(query_581237, "quotaUser", newJString(quotaUser))
  add(query_581237, "alt", newJString(alt))
  add(query_581237, "oauth_token", newJString(oauthToken))
  add(query_581237, "userIp", newJString(userIp))
  add(query_581237, "key", newJString(key))
  add(query_581237, "prettyPrint", newJBool(prettyPrint))
  add(path_581236, "groupKey", newJString(groupKey))
  result = call_581235.call(path_581236, query_581237, nil, nil, nil)

var directoryGroupsDelete* = Call_DirectoryGroupsDelete_581223(
    name: "directoryGroupsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}",
    validator: validate_DirectoryGroupsDelete_581224, base: "/admin/directory/v1",
    url: url_DirectoryGroupsDelete_581225, schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesInsert_581270 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsAliasesInsert_581272(protocol: Scheme; host: string;
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

proc validate_DirectoryGroupsAliasesInsert_581271(path: JsonNode; query: JsonNode;
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
  var valid_581273 = path.getOrDefault("groupKey")
  valid_581273 = validateParameter(valid_581273, JString, required = true,
                                 default = nil)
  if valid_581273 != nil:
    section.add "groupKey", valid_581273
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
  var valid_581274 = query.getOrDefault("fields")
  valid_581274 = validateParameter(valid_581274, JString, required = false,
                                 default = nil)
  if valid_581274 != nil:
    section.add "fields", valid_581274
  var valid_581275 = query.getOrDefault("quotaUser")
  valid_581275 = validateParameter(valid_581275, JString, required = false,
                                 default = nil)
  if valid_581275 != nil:
    section.add "quotaUser", valid_581275
  var valid_581276 = query.getOrDefault("alt")
  valid_581276 = validateParameter(valid_581276, JString, required = false,
                                 default = newJString("json"))
  if valid_581276 != nil:
    section.add "alt", valid_581276
  var valid_581277 = query.getOrDefault("oauth_token")
  valid_581277 = validateParameter(valid_581277, JString, required = false,
                                 default = nil)
  if valid_581277 != nil:
    section.add "oauth_token", valid_581277
  var valid_581278 = query.getOrDefault("userIp")
  valid_581278 = validateParameter(valid_581278, JString, required = false,
                                 default = nil)
  if valid_581278 != nil:
    section.add "userIp", valid_581278
  var valid_581279 = query.getOrDefault("key")
  valid_581279 = validateParameter(valid_581279, JString, required = false,
                                 default = nil)
  if valid_581279 != nil:
    section.add "key", valid_581279
  var valid_581280 = query.getOrDefault("prettyPrint")
  valid_581280 = validateParameter(valid_581280, JBool, required = false,
                                 default = newJBool(true))
  if valid_581280 != nil:
    section.add "prettyPrint", valid_581280
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

proc call*(call_581282: Call_DirectoryGroupsAliasesInsert_581270; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the group
  ## 
  let valid = call_581282.validator(path, query, header, formData, body)
  let scheme = call_581282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581282.url(scheme.get, call_581282.host, call_581282.base,
                         call_581282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581282, url, valid)

proc call*(call_581283: Call_DirectoryGroupsAliasesInsert_581270; groupKey: string;
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
  var path_581284 = newJObject()
  var query_581285 = newJObject()
  var body_581286 = newJObject()
  add(query_581285, "fields", newJString(fields))
  add(query_581285, "quotaUser", newJString(quotaUser))
  add(query_581285, "alt", newJString(alt))
  add(query_581285, "oauth_token", newJString(oauthToken))
  add(query_581285, "userIp", newJString(userIp))
  add(query_581285, "key", newJString(key))
  if body != nil:
    body_581286 = body
  add(query_581285, "prettyPrint", newJBool(prettyPrint))
  add(path_581284, "groupKey", newJString(groupKey))
  result = call_581283.call(path_581284, query_581285, nil, nil, body_581286)

var directoryGroupsAliasesInsert* = Call_DirectoryGroupsAliasesInsert_581270(
    name: "directoryGroupsAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesInsert_581271,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesInsert_581272,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesList_581255 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsAliasesList_581257(protocol: Scheme; host: string;
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

proc validate_DirectoryGroupsAliasesList_581256(path: JsonNode; query: JsonNode;
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
  var valid_581258 = path.getOrDefault("groupKey")
  valid_581258 = validateParameter(valid_581258, JString, required = true,
                                 default = nil)
  if valid_581258 != nil:
    section.add "groupKey", valid_581258
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
  var valid_581259 = query.getOrDefault("fields")
  valid_581259 = validateParameter(valid_581259, JString, required = false,
                                 default = nil)
  if valid_581259 != nil:
    section.add "fields", valid_581259
  var valid_581260 = query.getOrDefault("quotaUser")
  valid_581260 = validateParameter(valid_581260, JString, required = false,
                                 default = nil)
  if valid_581260 != nil:
    section.add "quotaUser", valid_581260
  var valid_581261 = query.getOrDefault("alt")
  valid_581261 = validateParameter(valid_581261, JString, required = false,
                                 default = newJString("json"))
  if valid_581261 != nil:
    section.add "alt", valid_581261
  var valid_581262 = query.getOrDefault("oauth_token")
  valid_581262 = validateParameter(valid_581262, JString, required = false,
                                 default = nil)
  if valid_581262 != nil:
    section.add "oauth_token", valid_581262
  var valid_581263 = query.getOrDefault("userIp")
  valid_581263 = validateParameter(valid_581263, JString, required = false,
                                 default = nil)
  if valid_581263 != nil:
    section.add "userIp", valid_581263
  var valid_581264 = query.getOrDefault("key")
  valid_581264 = validateParameter(valid_581264, JString, required = false,
                                 default = nil)
  if valid_581264 != nil:
    section.add "key", valid_581264
  var valid_581265 = query.getOrDefault("prettyPrint")
  valid_581265 = validateParameter(valid_581265, JBool, required = false,
                                 default = newJBool(true))
  if valid_581265 != nil:
    section.add "prettyPrint", valid_581265
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581266: Call_DirectoryGroupsAliasesList_581255; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a group
  ## 
  let valid = call_581266.validator(path, query, header, formData, body)
  let scheme = call_581266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581266.url(scheme.get, call_581266.host, call_581266.base,
                         call_581266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581266, url, valid)

proc call*(call_581267: Call_DirectoryGroupsAliasesList_581255; groupKey: string;
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
  var path_581268 = newJObject()
  var query_581269 = newJObject()
  add(query_581269, "fields", newJString(fields))
  add(query_581269, "quotaUser", newJString(quotaUser))
  add(query_581269, "alt", newJString(alt))
  add(query_581269, "oauth_token", newJString(oauthToken))
  add(query_581269, "userIp", newJString(userIp))
  add(query_581269, "key", newJString(key))
  add(query_581269, "prettyPrint", newJBool(prettyPrint))
  add(path_581268, "groupKey", newJString(groupKey))
  result = call_581267.call(path_581268, query_581269, nil, nil, nil)

var directoryGroupsAliasesList* = Call_DirectoryGroupsAliasesList_581255(
    name: "directoryGroupsAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases",
    validator: validate_DirectoryGroupsAliasesList_581256,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesList_581257,
    schemes: {Scheme.Https})
type
  Call_DirectoryGroupsAliasesDelete_581287 = ref object of OpenApiRestCall_579437
proc url_DirectoryGroupsAliasesDelete_581289(protocol: Scheme; host: string;
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

proc validate_DirectoryGroupsAliasesDelete_581288(path: JsonNode; query: JsonNode;
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
  var valid_581290 = path.getOrDefault("groupKey")
  valid_581290 = validateParameter(valid_581290, JString, required = true,
                                 default = nil)
  if valid_581290 != nil:
    section.add "groupKey", valid_581290
  var valid_581291 = path.getOrDefault("alias")
  valid_581291 = validateParameter(valid_581291, JString, required = true,
                                 default = nil)
  if valid_581291 != nil:
    section.add "alias", valid_581291
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
  var valid_581292 = query.getOrDefault("fields")
  valid_581292 = validateParameter(valid_581292, JString, required = false,
                                 default = nil)
  if valid_581292 != nil:
    section.add "fields", valid_581292
  var valid_581293 = query.getOrDefault("quotaUser")
  valid_581293 = validateParameter(valid_581293, JString, required = false,
                                 default = nil)
  if valid_581293 != nil:
    section.add "quotaUser", valid_581293
  var valid_581294 = query.getOrDefault("alt")
  valid_581294 = validateParameter(valid_581294, JString, required = false,
                                 default = newJString("json"))
  if valid_581294 != nil:
    section.add "alt", valid_581294
  var valid_581295 = query.getOrDefault("oauth_token")
  valid_581295 = validateParameter(valid_581295, JString, required = false,
                                 default = nil)
  if valid_581295 != nil:
    section.add "oauth_token", valid_581295
  var valid_581296 = query.getOrDefault("userIp")
  valid_581296 = validateParameter(valid_581296, JString, required = false,
                                 default = nil)
  if valid_581296 != nil:
    section.add "userIp", valid_581296
  var valid_581297 = query.getOrDefault("key")
  valid_581297 = validateParameter(valid_581297, JString, required = false,
                                 default = nil)
  if valid_581297 != nil:
    section.add "key", valid_581297
  var valid_581298 = query.getOrDefault("prettyPrint")
  valid_581298 = validateParameter(valid_581298, JBool, required = false,
                                 default = newJBool(true))
  if valid_581298 != nil:
    section.add "prettyPrint", valid_581298
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581299: Call_DirectoryGroupsAliasesDelete_581287; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the group
  ## 
  let valid = call_581299.validator(path, query, header, formData, body)
  let scheme = call_581299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581299.url(scheme.get, call_581299.host, call_581299.base,
                         call_581299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581299, url, valid)

proc call*(call_581300: Call_DirectoryGroupsAliasesDelete_581287; groupKey: string;
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
  var path_581301 = newJObject()
  var query_581302 = newJObject()
  add(query_581302, "fields", newJString(fields))
  add(query_581302, "quotaUser", newJString(quotaUser))
  add(query_581302, "alt", newJString(alt))
  add(query_581302, "oauth_token", newJString(oauthToken))
  add(query_581302, "userIp", newJString(userIp))
  add(query_581302, "key", newJString(key))
  add(query_581302, "prettyPrint", newJBool(prettyPrint))
  add(path_581301, "groupKey", newJString(groupKey))
  add(path_581301, "alias", newJString(alias))
  result = call_581300.call(path_581301, query_581302, nil, nil, nil)

var directoryGroupsAliasesDelete* = Call_DirectoryGroupsAliasesDelete_581287(
    name: "directoryGroupsAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/aliases/{alias}",
    validator: validate_DirectoryGroupsAliasesDelete_581288,
    base: "/admin/directory/v1", url: url_DirectoryGroupsAliasesDelete_581289,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersHasMember_581303 = ref object of OpenApiRestCall_579437
proc url_DirectoryMembersHasMember_581305(protocol: Scheme; host: string;
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

proc validate_DirectoryMembersHasMember_581304(path: JsonNode; query: JsonNode;
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
  var valid_581306 = path.getOrDefault("memberKey")
  valid_581306 = validateParameter(valid_581306, JString, required = true,
                                 default = nil)
  if valid_581306 != nil:
    section.add "memberKey", valid_581306
  var valid_581307 = path.getOrDefault("groupKey")
  valid_581307 = validateParameter(valid_581307, JString, required = true,
                                 default = nil)
  if valid_581307 != nil:
    section.add "groupKey", valid_581307
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
  var valid_581308 = query.getOrDefault("fields")
  valid_581308 = validateParameter(valid_581308, JString, required = false,
                                 default = nil)
  if valid_581308 != nil:
    section.add "fields", valid_581308
  var valid_581309 = query.getOrDefault("quotaUser")
  valid_581309 = validateParameter(valid_581309, JString, required = false,
                                 default = nil)
  if valid_581309 != nil:
    section.add "quotaUser", valid_581309
  var valid_581310 = query.getOrDefault("alt")
  valid_581310 = validateParameter(valid_581310, JString, required = false,
                                 default = newJString("json"))
  if valid_581310 != nil:
    section.add "alt", valid_581310
  var valid_581311 = query.getOrDefault("oauth_token")
  valid_581311 = validateParameter(valid_581311, JString, required = false,
                                 default = nil)
  if valid_581311 != nil:
    section.add "oauth_token", valid_581311
  var valid_581312 = query.getOrDefault("userIp")
  valid_581312 = validateParameter(valid_581312, JString, required = false,
                                 default = nil)
  if valid_581312 != nil:
    section.add "userIp", valid_581312
  var valid_581313 = query.getOrDefault("key")
  valid_581313 = validateParameter(valid_581313, JString, required = false,
                                 default = nil)
  if valid_581313 != nil:
    section.add "key", valid_581313
  var valid_581314 = query.getOrDefault("prettyPrint")
  valid_581314 = validateParameter(valid_581314, JBool, required = false,
                                 default = newJBool(true))
  if valid_581314 != nil:
    section.add "prettyPrint", valid_581314
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581315: Call_DirectoryMembersHasMember_581303; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Checks whether the given user is a member of the group. Membership can be direct or nested.
  ## 
  let valid = call_581315.validator(path, query, header, formData, body)
  let scheme = call_581315.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581315.url(scheme.get, call_581315.host, call_581315.base,
                         call_581315.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581315, url, valid)

proc call*(call_581316: Call_DirectoryMembersHasMember_581303; memberKey: string;
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
  var path_581317 = newJObject()
  var query_581318 = newJObject()
  add(query_581318, "fields", newJString(fields))
  add(query_581318, "quotaUser", newJString(quotaUser))
  add(query_581318, "alt", newJString(alt))
  add(query_581318, "oauth_token", newJString(oauthToken))
  add(query_581318, "userIp", newJString(userIp))
  add(path_581317, "memberKey", newJString(memberKey))
  add(query_581318, "key", newJString(key))
  add(query_581318, "prettyPrint", newJBool(prettyPrint))
  add(path_581317, "groupKey", newJString(groupKey))
  result = call_581316.call(path_581317, query_581318, nil, nil, nil)

var directoryMembersHasMember* = Call_DirectoryMembersHasMember_581303(
    name: "directoryMembersHasMember", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/hasMember/{memberKey}",
    validator: validate_DirectoryMembersHasMember_581304,
    base: "/admin/directory/v1", url: url_DirectoryMembersHasMember_581305,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersInsert_581338 = ref object of OpenApiRestCall_579437
proc url_DirectoryMembersInsert_581340(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersInsert_581339(path: JsonNode; query: JsonNode;
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
  var valid_581341 = path.getOrDefault("groupKey")
  valid_581341 = validateParameter(valid_581341, JString, required = true,
                                 default = nil)
  if valid_581341 != nil:
    section.add "groupKey", valid_581341
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
  var valid_581342 = query.getOrDefault("fields")
  valid_581342 = validateParameter(valid_581342, JString, required = false,
                                 default = nil)
  if valid_581342 != nil:
    section.add "fields", valid_581342
  var valid_581343 = query.getOrDefault("quotaUser")
  valid_581343 = validateParameter(valid_581343, JString, required = false,
                                 default = nil)
  if valid_581343 != nil:
    section.add "quotaUser", valid_581343
  var valid_581344 = query.getOrDefault("alt")
  valid_581344 = validateParameter(valid_581344, JString, required = false,
                                 default = newJString("json"))
  if valid_581344 != nil:
    section.add "alt", valid_581344
  var valid_581345 = query.getOrDefault("oauth_token")
  valid_581345 = validateParameter(valid_581345, JString, required = false,
                                 default = nil)
  if valid_581345 != nil:
    section.add "oauth_token", valid_581345
  var valid_581346 = query.getOrDefault("userIp")
  valid_581346 = validateParameter(valid_581346, JString, required = false,
                                 default = nil)
  if valid_581346 != nil:
    section.add "userIp", valid_581346
  var valid_581347 = query.getOrDefault("key")
  valid_581347 = validateParameter(valid_581347, JString, required = false,
                                 default = nil)
  if valid_581347 != nil:
    section.add "key", valid_581347
  var valid_581348 = query.getOrDefault("prettyPrint")
  valid_581348 = validateParameter(valid_581348, JBool, required = false,
                                 default = newJBool(true))
  if valid_581348 != nil:
    section.add "prettyPrint", valid_581348
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

proc call*(call_581350: Call_DirectoryMembersInsert_581338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add user to the specified group.
  ## 
  let valid = call_581350.validator(path, query, header, formData, body)
  let scheme = call_581350.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581350.url(scheme.get, call_581350.host, call_581350.base,
                         call_581350.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581350, url, valid)

proc call*(call_581351: Call_DirectoryMembersInsert_581338; groupKey: string;
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
  var path_581352 = newJObject()
  var query_581353 = newJObject()
  var body_581354 = newJObject()
  add(query_581353, "fields", newJString(fields))
  add(query_581353, "quotaUser", newJString(quotaUser))
  add(query_581353, "alt", newJString(alt))
  add(query_581353, "oauth_token", newJString(oauthToken))
  add(query_581353, "userIp", newJString(userIp))
  add(query_581353, "key", newJString(key))
  if body != nil:
    body_581354 = body
  add(query_581353, "prettyPrint", newJBool(prettyPrint))
  add(path_581352, "groupKey", newJString(groupKey))
  result = call_581351.call(path_581352, query_581353, nil, nil, body_581354)

var directoryMembersInsert* = Call_DirectoryMembersInsert_581338(
    name: "directoryMembersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersInsert_581339,
    base: "/admin/directory/v1", url: url_DirectoryMembersInsert_581340,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersList_581319 = ref object of OpenApiRestCall_579437
proc url_DirectoryMembersList_581321(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersList_581320(path: JsonNode; query: JsonNode;
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
  var valid_581322 = path.getOrDefault("groupKey")
  valid_581322 = validateParameter(valid_581322, JString, required = true,
                                 default = nil)
  if valid_581322 != nil:
    section.add "groupKey", valid_581322
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
  var valid_581323 = query.getOrDefault("fields")
  valid_581323 = validateParameter(valid_581323, JString, required = false,
                                 default = nil)
  if valid_581323 != nil:
    section.add "fields", valid_581323
  var valid_581324 = query.getOrDefault("pageToken")
  valid_581324 = validateParameter(valid_581324, JString, required = false,
                                 default = nil)
  if valid_581324 != nil:
    section.add "pageToken", valid_581324
  var valid_581325 = query.getOrDefault("quotaUser")
  valid_581325 = validateParameter(valid_581325, JString, required = false,
                                 default = nil)
  if valid_581325 != nil:
    section.add "quotaUser", valid_581325
  var valid_581326 = query.getOrDefault("includeDerivedMembership")
  valid_581326 = validateParameter(valid_581326, JBool, required = false, default = nil)
  if valid_581326 != nil:
    section.add "includeDerivedMembership", valid_581326
  var valid_581327 = query.getOrDefault("roles")
  valid_581327 = validateParameter(valid_581327, JString, required = false,
                                 default = nil)
  if valid_581327 != nil:
    section.add "roles", valid_581327
  var valid_581328 = query.getOrDefault("alt")
  valid_581328 = validateParameter(valid_581328, JString, required = false,
                                 default = newJString("json"))
  if valid_581328 != nil:
    section.add "alt", valid_581328
  var valid_581329 = query.getOrDefault("oauth_token")
  valid_581329 = validateParameter(valid_581329, JString, required = false,
                                 default = nil)
  if valid_581329 != nil:
    section.add "oauth_token", valid_581329
  var valid_581330 = query.getOrDefault("userIp")
  valid_581330 = validateParameter(valid_581330, JString, required = false,
                                 default = nil)
  if valid_581330 != nil:
    section.add "userIp", valid_581330
  var valid_581331 = query.getOrDefault("maxResults")
  valid_581331 = validateParameter(valid_581331, JInt, required = false,
                                 default = newJInt(200))
  if valid_581331 != nil:
    section.add "maxResults", valid_581331
  var valid_581332 = query.getOrDefault("key")
  valid_581332 = validateParameter(valid_581332, JString, required = false,
                                 default = nil)
  if valid_581332 != nil:
    section.add "key", valid_581332
  var valid_581333 = query.getOrDefault("prettyPrint")
  valid_581333 = validateParameter(valid_581333, JBool, required = false,
                                 default = newJBool(true))
  if valid_581333 != nil:
    section.add "prettyPrint", valid_581333
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581334: Call_DirectoryMembersList_581319; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve all members in a group (paginated)
  ## 
  let valid = call_581334.validator(path, query, header, formData, body)
  let scheme = call_581334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581334.url(scheme.get, call_581334.host, call_581334.base,
                         call_581334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581334, url, valid)

proc call*(call_581335: Call_DirectoryMembersList_581319; groupKey: string;
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
  var path_581336 = newJObject()
  var query_581337 = newJObject()
  add(query_581337, "fields", newJString(fields))
  add(query_581337, "pageToken", newJString(pageToken))
  add(query_581337, "quotaUser", newJString(quotaUser))
  add(query_581337, "includeDerivedMembership", newJBool(includeDerivedMembership))
  add(query_581337, "roles", newJString(roles))
  add(query_581337, "alt", newJString(alt))
  add(query_581337, "oauth_token", newJString(oauthToken))
  add(query_581337, "userIp", newJString(userIp))
  add(query_581337, "maxResults", newJInt(maxResults))
  add(query_581337, "key", newJString(key))
  add(query_581337, "prettyPrint", newJBool(prettyPrint))
  add(path_581336, "groupKey", newJString(groupKey))
  result = call_581335.call(path_581336, query_581337, nil, nil, nil)

var directoryMembersList* = Call_DirectoryMembersList_581319(
    name: "directoryMembersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members",
    validator: validate_DirectoryMembersList_581320, base: "/admin/directory/v1",
    url: url_DirectoryMembersList_581321, schemes: {Scheme.Https})
type
  Call_DirectoryMembersUpdate_581371 = ref object of OpenApiRestCall_579437
proc url_DirectoryMembersUpdate_581373(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersUpdate_581372(path: JsonNode; query: JsonNode;
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
  var valid_581374 = path.getOrDefault("memberKey")
  valid_581374 = validateParameter(valid_581374, JString, required = true,
                                 default = nil)
  if valid_581374 != nil:
    section.add "memberKey", valid_581374
  var valid_581375 = path.getOrDefault("groupKey")
  valid_581375 = validateParameter(valid_581375, JString, required = true,
                                 default = nil)
  if valid_581375 != nil:
    section.add "groupKey", valid_581375
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
  var valid_581376 = query.getOrDefault("fields")
  valid_581376 = validateParameter(valid_581376, JString, required = false,
                                 default = nil)
  if valid_581376 != nil:
    section.add "fields", valid_581376
  var valid_581377 = query.getOrDefault("quotaUser")
  valid_581377 = validateParameter(valid_581377, JString, required = false,
                                 default = nil)
  if valid_581377 != nil:
    section.add "quotaUser", valid_581377
  var valid_581378 = query.getOrDefault("alt")
  valid_581378 = validateParameter(valid_581378, JString, required = false,
                                 default = newJString("json"))
  if valid_581378 != nil:
    section.add "alt", valid_581378
  var valid_581379 = query.getOrDefault("oauth_token")
  valid_581379 = validateParameter(valid_581379, JString, required = false,
                                 default = nil)
  if valid_581379 != nil:
    section.add "oauth_token", valid_581379
  var valid_581380 = query.getOrDefault("userIp")
  valid_581380 = validateParameter(valid_581380, JString, required = false,
                                 default = nil)
  if valid_581380 != nil:
    section.add "userIp", valid_581380
  var valid_581381 = query.getOrDefault("key")
  valid_581381 = validateParameter(valid_581381, JString, required = false,
                                 default = nil)
  if valid_581381 != nil:
    section.add "key", valid_581381
  var valid_581382 = query.getOrDefault("prettyPrint")
  valid_581382 = validateParameter(valid_581382, JBool, required = false,
                                 default = newJBool(true))
  if valid_581382 != nil:
    section.add "prettyPrint", valid_581382
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

proc call*(call_581384: Call_DirectoryMembersUpdate_581371; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group.
  ## 
  let valid = call_581384.validator(path, query, header, formData, body)
  let scheme = call_581384.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581384.url(scheme.get, call_581384.host, call_581384.base,
                         call_581384.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581384, url, valid)

proc call*(call_581385: Call_DirectoryMembersUpdate_581371; memberKey: string;
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
  var path_581386 = newJObject()
  var query_581387 = newJObject()
  var body_581388 = newJObject()
  add(query_581387, "fields", newJString(fields))
  add(query_581387, "quotaUser", newJString(quotaUser))
  add(query_581387, "alt", newJString(alt))
  add(query_581387, "oauth_token", newJString(oauthToken))
  add(query_581387, "userIp", newJString(userIp))
  add(path_581386, "memberKey", newJString(memberKey))
  add(query_581387, "key", newJString(key))
  if body != nil:
    body_581388 = body
  add(query_581387, "prettyPrint", newJBool(prettyPrint))
  add(path_581386, "groupKey", newJString(groupKey))
  result = call_581385.call(path_581386, query_581387, nil, nil, body_581388)

var directoryMembersUpdate* = Call_DirectoryMembersUpdate_581371(
    name: "directoryMembersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersUpdate_581372,
    base: "/admin/directory/v1", url: url_DirectoryMembersUpdate_581373,
    schemes: {Scheme.Https})
type
  Call_DirectoryMembersGet_581355 = ref object of OpenApiRestCall_579437
proc url_DirectoryMembersGet_581357(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersGet_581356(path: JsonNode; query: JsonNode;
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
  var valid_581358 = path.getOrDefault("memberKey")
  valid_581358 = validateParameter(valid_581358, JString, required = true,
                                 default = nil)
  if valid_581358 != nil:
    section.add "memberKey", valid_581358
  var valid_581359 = path.getOrDefault("groupKey")
  valid_581359 = validateParameter(valid_581359, JString, required = true,
                                 default = nil)
  if valid_581359 != nil:
    section.add "groupKey", valid_581359
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
  var valid_581360 = query.getOrDefault("fields")
  valid_581360 = validateParameter(valid_581360, JString, required = false,
                                 default = nil)
  if valid_581360 != nil:
    section.add "fields", valid_581360
  var valid_581361 = query.getOrDefault("quotaUser")
  valid_581361 = validateParameter(valid_581361, JString, required = false,
                                 default = nil)
  if valid_581361 != nil:
    section.add "quotaUser", valid_581361
  var valid_581362 = query.getOrDefault("alt")
  valid_581362 = validateParameter(valid_581362, JString, required = false,
                                 default = newJString("json"))
  if valid_581362 != nil:
    section.add "alt", valid_581362
  var valid_581363 = query.getOrDefault("oauth_token")
  valid_581363 = validateParameter(valid_581363, JString, required = false,
                                 default = nil)
  if valid_581363 != nil:
    section.add "oauth_token", valid_581363
  var valid_581364 = query.getOrDefault("userIp")
  valid_581364 = validateParameter(valid_581364, JString, required = false,
                                 default = nil)
  if valid_581364 != nil:
    section.add "userIp", valid_581364
  var valid_581365 = query.getOrDefault("key")
  valid_581365 = validateParameter(valid_581365, JString, required = false,
                                 default = nil)
  if valid_581365 != nil:
    section.add "key", valid_581365
  var valid_581366 = query.getOrDefault("prettyPrint")
  valid_581366 = validateParameter(valid_581366, JBool, required = false,
                                 default = newJBool(true))
  if valid_581366 != nil:
    section.add "prettyPrint", valid_581366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581367: Call_DirectoryMembersGet_581355; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve Group Member
  ## 
  let valid = call_581367.validator(path, query, header, formData, body)
  let scheme = call_581367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581367.url(scheme.get, call_581367.host, call_581367.base,
                         call_581367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581367, url, valid)

proc call*(call_581368: Call_DirectoryMembersGet_581355; memberKey: string;
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
  var path_581369 = newJObject()
  var query_581370 = newJObject()
  add(query_581370, "fields", newJString(fields))
  add(query_581370, "quotaUser", newJString(quotaUser))
  add(query_581370, "alt", newJString(alt))
  add(query_581370, "oauth_token", newJString(oauthToken))
  add(query_581370, "userIp", newJString(userIp))
  add(path_581369, "memberKey", newJString(memberKey))
  add(query_581370, "key", newJString(key))
  add(query_581370, "prettyPrint", newJBool(prettyPrint))
  add(path_581369, "groupKey", newJString(groupKey))
  result = call_581368.call(path_581369, query_581370, nil, nil, nil)

var directoryMembersGet* = Call_DirectoryMembersGet_581355(
    name: "directoryMembersGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersGet_581356, base: "/admin/directory/v1",
    url: url_DirectoryMembersGet_581357, schemes: {Scheme.Https})
type
  Call_DirectoryMembersPatch_581405 = ref object of OpenApiRestCall_579437
proc url_DirectoryMembersPatch_581407(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersPatch_581406(path: JsonNode; query: JsonNode;
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
  var valid_581408 = path.getOrDefault("memberKey")
  valid_581408 = validateParameter(valid_581408, JString, required = true,
                                 default = nil)
  if valid_581408 != nil:
    section.add "memberKey", valid_581408
  var valid_581409 = path.getOrDefault("groupKey")
  valid_581409 = validateParameter(valid_581409, JString, required = true,
                                 default = nil)
  if valid_581409 != nil:
    section.add "groupKey", valid_581409
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
  var valid_581410 = query.getOrDefault("fields")
  valid_581410 = validateParameter(valid_581410, JString, required = false,
                                 default = nil)
  if valid_581410 != nil:
    section.add "fields", valid_581410
  var valid_581411 = query.getOrDefault("quotaUser")
  valid_581411 = validateParameter(valid_581411, JString, required = false,
                                 default = nil)
  if valid_581411 != nil:
    section.add "quotaUser", valid_581411
  var valid_581412 = query.getOrDefault("alt")
  valid_581412 = validateParameter(valid_581412, JString, required = false,
                                 default = newJString("json"))
  if valid_581412 != nil:
    section.add "alt", valid_581412
  var valid_581413 = query.getOrDefault("oauth_token")
  valid_581413 = validateParameter(valid_581413, JString, required = false,
                                 default = nil)
  if valid_581413 != nil:
    section.add "oauth_token", valid_581413
  var valid_581414 = query.getOrDefault("userIp")
  valid_581414 = validateParameter(valid_581414, JString, required = false,
                                 default = nil)
  if valid_581414 != nil:
    section.add "userIp", valid_581414
  var valid_581415 = query.getOrDefault("key")
  valid_581415 = validateParameter(valid_581415, JString, required = false,
                                 default = nil)
  if valid_581415 != nil:
    section.add "key", valid_581415
  var valid_581416 = query.getOrDefault("prettyPrint")
  valid_581416 = validateParameter(valid_581416, JBool, required = false,
                                 default = newJBool(true))
  if valid_581416 != nil:
    section.add "prettyPrint", valid_581416
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

proc call*(call_581418: Call_DirectoryMembersPatch_581405; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Update membership of a user in the specified group. This method supports patch semantics.
  ## 
  let valid = call_581418.validator(path, query, header, formData, body)
  let scheme = call_581418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581418.url(scheme.get, call_581418.host, call_581418.base,
                         call_581418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581418, url, valid)

proc call*(call_581419: Call_DirectoryMembersPatch_581405; memberKey: string;
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
  var path_581420 = newJObject()
  var query_581421 = newJObject()
  var body_581422 = newJObject()
  add(query_581421, "fields", newJString(fields))
  add(query_581421, "quotaUser", newJString(quotaUser))
  add(query_581421, "alt", newJString(alt))
  add(query_581421, "oauth_token", newJString(oauthToken))
  add(query_581421, "userIp", newJString(userIp))
  add(path_581420, "memberKey", newJString(memberKey))
  add(query_581421, "key", newJString(key))
  if body != nil:
    body_581422 = body
  add(query_581421, "prettyPrint", newJBool(prettyPrint))
  add(path_581420, "groupKey", newJString(groupKey))
  result = call_581419.call(path_581420, query_581421, nil, nil, body_581422)

var directoryMembersPatch* = Call_DirectoryMembersPatch_581405(
    name: "directoryMembersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersPatch_581406, base: "/admin/directory/v1",
    url: url_DirectoryMembersPatch_581407, schemes: {Scheme.Https})
type
  Call_DirectoryMembersDelete_581389 = ref object of OpenApiRestCall_579437
proc url_DirectoryMembersDelete_581391(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryMembersDelete_581390(path: JsonNode; query: JsonNode;
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
  var valid_581392 = path.getOrDefault("memberKey")
  valid_581392 = validateParameter(valid_581392, JString, required = true,
                                 default = nil)
  if valid_581392 != nil:
    section.add "memberKey", valid_581392
  var valid_581393 = path.getOrDefault("groupKey")
  valid_581393 = validateParameter(valid_581393, JString, required = true,
                                 default = nil)
  if valid_581393 != nil:
    section.add "groupKey", valid_581393
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
  var valid_581394 = query.getOrDefault("fields")
  valid_581394 = validateParameter(valid_581394, JString, required = false,
                                 default = nil)
  if valid_581394 != nil:
    section.add "fields", valid_581394
  var valid_581395 = query.getOrDefault("quotaUser")
  valid_581395 = validateParameter(valid_581395, JString, required = false,
                                 default = nil)
  if valid_581395 != nil:
    section.add "quotaUser", valid_581395
  var valid_581396 = query.getOrDefault("alt")
  valid_581396 = validateParameter(valid_581396, JString, required = false,
                                 default = newJString("json"))
  if valid_581396 != nil:
    section.add "alt", valid_581396
  var valid_581397 = query.getOrDefault("oauth_token")
  valid_581397 = validateParameter(valid_581397, JString, required = false,
                                 default = nil)
  if valid_581397 != nil:
    section.add "oauth_token", valid_581397
  var valid_581398 = query.getOrDefault("userIp")
  valid_581398 = validateParameter(valid_581398, JString, required = false,
                                 default = nil)
  if valid_581398 != nil:
    section.add "userIp", valid_581398
  var valid_581399 = query.getOrDefault("key")
  valid_581399 = validateParameter(valid_581399, JString, required = false,
                                 default = nil)
  if valid_581399 != nil:
    section.add "key", valid_581399
  var valid_581400 = query.getOrDefault("prettyPrint")
  valid_581400 = validateParameter(valid_581400, JBool, required = false,
                                 default = newJBool(true))
  if valid_581400 != nil:
    section.add "prettyPrint", valid_581400
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581401: Call_DirectoryMembersDelete_581389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove membership.
  ## 
  let valid = call_581401.validator(path, query, header, formData, body)
  let scheme = call_581401.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581401.url(scheme.get, call_581401.host, call_581401.base,
                         call_581401.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581401, url, valid)

proc call*(call_581402: Call_DirectoryMembersDelete_581389; memberKey: string;
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
  var path_581403 = newJObject()
  var query_581404 = newJObject()
  add(query_581404, "fields", newJString(fields))
  add(query_581404, "quotaUser", newJString(quotaUser))
  add(query_581404, "alt", newJString(alt))
  add(query_581404, "oauth_token", newJString(oauthToken))
  add(query_581404, "userIp", newJString(userIp))
  add(path_581403, "memberKey", newJString(memberKey))
  add(query_581404, "key", newJString(key))
  add(query_581404, "prettyPrint", newJBool(prettyPrint))
  add(path_581403, "groupKey", newJString(groupKey))
  result = call_581402.call(path_581403, query_581404, nil, nil, nil)

var directoryMembersDelete* = Call_DirectoryMembersDelete_581389(
    name: "directoryMembersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/groups/{groupKey}/members/{memberKey}",
    validator: validate_DirectoryMembersDelete_581390,
    base: "/admin/directory/v1", url: url_DirectoryMembersDelete_581391,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsGetSettings_581423 = ref object of OpenApiRestCall_579437
proc url_DirectoryResolvedAppAccessSettingsGetSettings_581425(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsGetSettings_581424(
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
  var valid_581426 = query.getOrDefault("fields")
  valid_581426 = validateParameter(valid_581426, JString, required = false,
                                 default = nil)
  if valid_581426 != nil:
    section.add "fields", valid_581426
  var valid_581427 = query.getOrDefault("quotaUser")
  valid_581427 = validateParameter(valid_581427, JString, required = false,
                                 default = nil)
  if valid_581427 != nil:
    section.add "quotaUser", valid_581427
  var valid_581428 = query.getOrDefault("alt")
  valid_581428 = validateParameter(valid_581428, JString, required = false,
                                 default = newJString("json"))
  if valid_581428 != nil:
    section.add "alt", valid_581428
  var valid_581429 = query.getOrDefault("oauth_token")
  valid_581429 = validateParameter(valid_581429, JString, required = false,
                                 default = nil)
  if valid_581429 != nil:
    section.add "oauth_token", valid_581429
  var valid_581430 = query.getOrDefault("userIp")
  valid_581430 = validateParameter(valid_581430, JString, required = false,
                                 default = nil)
  if valid_581430 != nil:
    section.add "userIp", valid_581430
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581433: Call_DirectoryResolvedAppAccessSettingsGetSettings_581423;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves resolved app access settings of the logged in user.
  ## 
  let valid = call_581433.validator(path, query, header, formData, body)
  let scheme = call_581433.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581433.url(scheme.get, call_581433.host, call_581433.base,
                         call_581433.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581433, url, valid)

proc call*(call_581434: Call_DirectoryResolvedAppAccessSettingsGetSettings_581423;
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
  var query_581435 = newJObject()
  add(query_581435, "fields", newJString(fields))
  add(query_581435, "quotaUser", newJString(quotaUser))
  add(query_581435, "alt", newJString(alt))
  add(query_581435, "oauth_token", newJString(oauthToken))
  add(query_581435, "userIp", newJString(userIp))
  add(query_581435, "key", newJString(key))
  add(query_581435, "prettyPrint", newJBool(prettyPrint))
  result = call_581434.call(nil, query_581435, nil, nil, nil)

var directoryResolvedAppAccessSettingsGetSettings* = Call_DirectoryResolvedAppAccessSettingsGetSettings_581423(
    name: "directoryResolvedAppAccessSettingsGetSettings",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/resolvedappaccesssettings",
    validator: validate_DirectoryResolvedAppAccessSettingsGetSettings_581424,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsGetSettings_581425,
    schemes: {Scheme.Https})
type
  Call_DirectoryResolvedAppAccessSettingsListTrustedApps_581436 = ref object of OpenApiRestCall_579437
proc url_DirectoryResolvedAppAccessSettingsListTrustedApps_581438(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryResolvedAppAccessSettingsListTrustedApps_581437(
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
  var valid_581439 = query.getOrDefault("fields")
  valid_581439 = validateParameter(valid_581439, JString, required = false,
                                 default = nil)
  if valid_581439 != nil:
    section.add "fields", valid_581439
  var valid_581440 = query.getOrDefault("quotaUser")
  valid_581440 = validateParameter(valid_581440, JString, required = false,
                                 default = nil)
  if valid_581440 != nil:
    section.add "quotaUser", valid_581440
  var valid_581441 = query.getOrDefault("alt")
  valid_581441 = validateParameter(valid_581441, JString, required = false,
                                 default = newJString("json"))
  if valid_581441 != nil:
    section.add "alt", valid_581441
  var valid_581442 = query.getOrDefault("oauth_token")
  valid_581442 = validateParameter(valid_581442, JString, required = false,
                                 default = nil)
  if valid_581442 != nil:
    section.add "oauth_token", valid_581442
  var valid_581443 = query.getOrDefault("userIp")
  valid_581443 = validateParameter(valid_581443, JString, required = false,
                                 default = nil)
  if valid_581443 != nil:
    section.add "userIp", valid_581443
  var valid_581444 = query.getOrDefault("key")
  valid_581444 = validateParameter(valid_581444, JString, required = false,
                                 default = nil)
  if valid_581444 != nil:
    section.add "key", valid_581444
  var valid_581445 = query.getOrDefault("prettyPrint")
  valid_581445 = validateParameter(valid_581445, JBool, required = false,
                                 default = newJBool(true))
  if valid_581445 != nil:
    section.add "prettyPrint", valid_581445
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581446: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_581436;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves the list of apps trusted by the admin of the logged in user.
  ## 
  let valid = call_581446.validator(path, query, header, formData, body)
  let scheme = call_581446.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581446.url(scheme.get, call_581446.host, call_581446.base,
                         call_581446.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581446, url, valid)

proc call*(call_581447: Call_DirectoryResolvedAppAccessSettingsListTrustedApps_581436;
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
  var query_581448 = newJObject()
  add(query_581448, "fields", newJString(fields))
  add(query_581448, "quotaUser", newJString(quotaUser))
  add(query_581448, "alt", newJString(alt))
  add(query_581448, "oauth_token", newJString(oauthToken))
  add(query_581448, "userIp", newJString(userIp))
  add(query_581448, "key", newJString(key))
  add(query_581448, "prettyPrint", newJBool(prettyPrint))
  result = call_581447.call(nil, query_581448, nil, nil, nil)

var directoryResolvedAppAccessSettingsListTrustedApps* = Call_DirectoryResolvedAppAccessSettingsListTrustedApps_581436(
    name: "directoryResolvedAppAccessSettingsListTrustedApps",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/trustedapps",
    validator: validate_DirectoryResolvedAppAccessSettingsListTrustedApps_581437,
    base: "/admin/directory/v1",
    url: url_DirectoryResolvedAppAccessSettingsListTrustedApps_581438,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersInsert_581474 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersInsert_581476(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersInsert_581475(path: JsonNode; query: JsonNode;
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
  var valid_581477 = query.getOrDefault("fields")
  valid_581477 = validateParameter(valid_581477, JString, required = false,
                                 default = nil)
  if valid_581477 != nil:
    section.add "fields", valid_581477
  var valid_581478 = query.getOrDefault("quotaUser")
  valid_581478 = validateParameter(valid_581478, JString, required = false,
                                 default = nil)
  if valid_581478 != nil:
    section.add "quotaUser", valid_581478
  var valid_581479 = query.getOrDefault("alt")
  valid_581479 = validateParameter(valid_581479, JString, required = false,
                                 default = newJString("json"))
  if valid_581479 != nil:
    section.add "alt", valid_581479
  var valid_581480 = query.getOrDefault("oauth_token")
  valid_581480 = validateParameter(valid_581480, JString, required = false,
                                 default = nil)
  if valid_581480 != nil:
    section.add "oauth_token", valid_581480
  var valid_581481 = query.getOrDefault("userIp")
  valid_581481 = validateParameter(valid_581481, JString, required = false,
                                 default = nil)
  if valid_581481 != nil:
    section.add "userIp", valid_581481
  var valid_581482 = query.getOrDefault("key")
  valid_581482 = validateParameter(valid_581482, JString, required = false,
                                 default = nil)
  if valid_581482 != nil:
    section.add "key", valid_581482
  var valid_581483 = query.getOrDefault("prettyPrint")
  valid_581483 = validateParameter(valid_581483, JBool, required = false,
                                 default = newJBool(true))
  if valid_581483 != nil:
    section.add "prettyPrint", valid_581483
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

proc call*(call_581485: Call_DirectoryUsersInsert_581474; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## create user.
  ## 
  let valid = call_581485.validator(path, query, header, formData, body)
  let scheme = call_581485.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581485.url(scheme.get, call_581485.host, call_581485.base,
                         call_581485.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581485, url, valid)

proc call*(call_581486: Call_DirectoryUsersInsert_581474; fields: string = "";
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
  var query_581487 = newJObject()
  var body_581488 = newJObject()
  add(query_581487, "fields", newJString(fields))
  add(query_581487, "quotaUser", newJString(quotaUser))
  add(query_581487, "alt", newJString(alt))
  add(query_581487, "oauth_token", newJString(oauthToken))
  add(query_581487, "userIp", newJString(userIp))
  add(query_581487, "key", newJString(key))
  if body != nil:
    body_581488 = body
  add(query_581487, "prettyPrint", newJBool(prettyPrint))
  result = call_581486.call(nil, query_581487, nil, nil, body_581488)

var directoryUsersInsert* = Call_DirectoryUsersInsert_581474(
    name: "directoryUsersInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersInsert_581475, base: "/admin/directory/v1",
    url: url_DirectoryUsersInsert_581476, schemes: {Scheme.Https})
type
  Call_DirectoryUsersList_581449 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersList_581451(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersList_581450(path: JsonNode; query: JsonNode;
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
  var valid_581452 = query.getOrDefault("fields")
  valid_581452 = validateParameter(valid_581452, JString, required = false,
                                 default = nil)
  if valid_581452 != nil:
    section.add "fields", valid_581452
  var valid_581453 = query.getOrDefault("pageToken")
  valid_581453 = validateParameter(valid_581453, JString, required = false,
                                 default = nil)
  if valid_581453 != nil:
    section.add "pageToken", valid_581453
  var valid_581454 = query.getOrDefault("quotaUser")
  valid_581454 = validateParameter(valid_581454, JString, required = false,
                                 default = nil)
  if valid_581454 != nil:
    section.add "quotaUser", valid_581454
  var valid_581455 = query.getOrDefault("event")
  valid_581455 = validateParameter(valid_581455, JString, required = false,
                                 default = newJString("add"))
  if valid_581455 != nil:
    section.add "event", valid_581455
  var valid_581456 = query.getOrDefault("alt")
  valid_581456 = validateParameter(valid_581456, JString, required = false,
                                 default = newJString("json"))
  if valid_581456 != nil:
    section.add "alt", valid_581456
  var valid_581457 = query.getOrDefault("query")
  valid_581457 = validateParameter(valid_581457, JString, required = false,
                                 default = nil)
  if valid_581457 != nil:
    section.add "query", valid_581457
  var valid_581458 = query.getOrDefault("oauth_token")
  valid_581458 = validateParameter(valid_581458, JString, required = false,
                                 default = nil)
  if valid_581458 != nil:
    section.add "oauth_token", valid_581458
  var valid_581459 = query.getOrDefault("userIp")
  valid_581459 = validateParameter(valid_581459, JString, required = false,
                                 default = nil)
  if valid_581459 != nil:
    section.add "userIp", valid_581459
  var valid_581460 = query.getOrDefault("maxResults")
  valid_581460 = validateParameter(valid_581460, JInt, required = false,
                                 default = newJInt(100))
  if valid_581460 != nil:
    section.add "maxResults", valid_581460
  var valid_581461 = query.getOrDefault("orderBy")
  valid_581461 = validateParameter(valid_581461, JString, required = false,
                                 default = newJString("email"))
  if valid_581461 != nil:
    section.add "orderBy", valid_581461
  var valid_581462 = query.getOrDefault("showDeleted")
  valid_581462 = validateParameter(valid_581462, JString, required = false,
                                 default = nil)
  if valid_581462 != nil:
    section.add "showDeleted", valid_581462
  var valid_581463 = query.getOrDefault("customFieldMask")
  valid_581463 = validateParameter(valid_581463, JString, required = false,
                                 default = nil)
  if valid_581463 != nil:
    section.add "customFieldMask", valid_581463
  var valid_581464 = query.getOrDefault("key")
  valid_581464 = validateParameter(valid_581464, JString, required = false,
                                 default = nil)
  if valid_581464 != nil:
    section.add "key", valid_581464
  var valid_581465 = query.getOrDefault("projection")
  valid_581465 = validateParameter(valid_581465, JString, required = false,
                                 default = newJString("basic"))
  if valid_581465 != nil:
    section.add "projection", valid_581465
  var valid_581466 = query.getOrDefault("sortOrder")
  valid_581466 = validateParameter(valid_581466, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_581466 != nil:
    section.add "sortOrder", valid_581466
  var valid_581467 = query.getOrDefault("customer")
  valid_581467 = validateParameter(valid_581467, JString, required = false,
                                 default = nil)
  if valid_581467 != nil:
    section.add "customer", valid_581467
  var valid_581468 = query.getOrDefault("prettyPrint")
  valid_581468 = validateParameter(valid_581468, JBool, required = false,
                                 default = newJBool(true))
  if valid_581468 != nil:
    section.add "prettyPrint", valid_581468
  var valid_581469 = query.getOrDefault("viewType")
  valid_581469 = validateParameter(valid_581469, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_581469 != nil:
    section.add "viewType", valid_581469
  var valid_581470 = query.getOrDefault("domain")
  valid_581470 = validateParameter(valid_581470, JString, required = false,
                                 default = nil)
  if valid_581470 != nil:
    section.add "domain", valid_581470
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581471: Call_DirectoryUsersList_581449; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve either deleted users or all users in a domain (paginated)
  ## 
  let valid = call_581471.validator(path, query, header, formData, body)
  let scheme = call_581471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581471.url(scheme.get, call_581471.host, call_581471.base,
                         call_581471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581471, url, valid)

proc call*(call_581472: Call_DirectoryUsersList_581449; fields: string = "";
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
  var query_581473 = newJObject()
  add(query_581473, "fields", newJString(fields))
  add(query_581473, "pageToken", newJString(pageToken))
  add(query_581473, "quotaUser", newJString(quotaUser))
  add(query_581473, "event", newJString(event))
  add(query_581473, "alt", newJString(alt))
  add(query_581473, "query", newJString(query))
  add(query_581473, "oauth_token", newJString(oauthToken))
  add(query_581473, "userIp", newJString(userIp))
  add(query_581473, "maxResults", newJInt(maxResults))
  add(query_581473, "orderBy", newJString(orderBy))
  add(query_581473, "showDeleted", newJString(showDeleted))
  add(query_581473, "customFieldMask", newJString(customFieldMask))
  add(query_581473, "key", newJString(key))
  add(query_581473, "projection", newJString(projection))
  add(query_581473, "sortOrder", newJString(sortOrder))
  add(query_581473, "customer", newJString(customer))
  add(query_581473, "prettyPrint", newJBool(prettyPrint))
  add(query_581473, "viewType", newJString(viewType))
  add(query_581473, "domain", newJString(domain))
  result = call_581472.call(nil, query_581473, nil, nil, nil)

var directoryUsersList* = Call_DirectoryUsersList_581449(
    name: "directoryUsersList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users",
    validator: validate_DirectoryUsersList_581450, base: "/admin/directory/v1",
    url: url_DirectoryUsersList_581451, schemes: {Scheme.Https})
type
  Call_DirectoryUsersWatch_581489 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersWatch_581491(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_DirectoryUsersWatch_581490(path: JsonNode; query: JsonNode;
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
  var valid_581492 = query.getOrDefault("fields")
  valid_581492 = validateParameter(valid_581492, JString, required = false,
                                 default = nil)
  if valid_581492 != nil:
    section.add "fields", valid_581492
  var valid_581493 = query.getOrDefault("pageToken")
  valid_581493 = validateParameter(valid_581493, JString, required = false,
                                 default = nil)
  if valid_581493 != nil:
    section.add "pageToken", valid_581493
  var valid_581494 = query.getOrDefault("quotaUser")
  valid_581494 = validateParameter(valid_581494, JString, required = false,
                                 default = nil)
  if valid_581494 != nil:
    section.add "quotaUser", valid_581494
  var valid_581495 = query.getOrDefault("event")
  valid_581495 = validateParameter(valid_581495, JString, required = false,
                                 default = newJString("add"))
  if valid_581495 != nil:
    section.add "event", valid_581495
  var valid_581496 = query.getOrDefault("alt")
  valid_581496 = validateParameter(valid_581496, JString, required = false,
                                 default = newJString("json"))
  if valid_581496 != nil:
    section.add "alt", valid_581496
  var valid_581497 = query.getOrDefault("query")
  valid_581497 = validateParameter(valid_581497, JString, required = false,
                                 default = nil)
  if valid_581497 != nil:
    section.add "query", valid_581497
  var valid_581498 = query.getOrDefault("oauth_token")
  valid_581498 = validateParameter(valid_581498, JString, required = false,
                                 default = nil)
  if valid_581498 != nil:
    section.add "oauth_token", valid_581498
  var valid_581499 = query.getOrDefault("userIp")
  valid_581499 = validateParameter(valid_581499, JString, required = false,
                                 default = nil)
  if valid_581499 != nil:
    section.add "userIp", valid_581499
  var valid_581500 = query.getOrDefault("maxResults")
  valid_581500 = validateParameter(valid_581500, JInt, required = false,
                                 default = newJInt(100))
  if valid_581500 != nil:
    section.add "maxResults", valid_581500
  var valid_581501 = query.getOrDefault("orderBy")
  valid_581501 = validateParameter(valid_581501, JString, required = false,
                                 default = newJString("email"))
  if valid_581501 != nil:
    section.add "orderBy", valid_581501
  var valid_581502 = query.getOrDefault("showDeleted")
  valid_581502 = validateParameter(valid_581502, JString, required = false,
                                 default = nil)
  if valid_581502 != nil:
    section.add "showDeleted", valid_581502
  var valid_581503 = query.getOrDefault("customFieldMask")
  valid_581503 = validateParameter(valid_581503, JString, required = false,
                                 default = nil)
  if valid_581503 != nil:
    section.add "customFieldMask", valid_581503
  var valid_581504 = query.getOrDefault("key")
  valid_581504 = validateParameter(valid_581504, JString, required = false,
                                 default = nil)
  if valid_581504 != nil:
    section.add "key", valid_581504
  var valid_581505 = query.getOrDefault("projection")
  valid_581505 = validateParameter(valid_581505, JString, required = false,
                                 default = newJString("basic"))
  if valid_581505 != nil:
    section.add "projection", valid_581505
  var valid_581506 = query.getOrDefault("sortOrder")
  valid_581506 = validateParameter(valid_581506, JString, required = false,
                                 default = newJString("ASCENDING"))
  if valid_581506 != nil:
    section.add "sortOrder", valid_581506
  var valid_581507 = query.getOrDefault("customer")
  valid_581507 = validateParameter(valid_581507, JString, required = false,
                                 default = nil)
  if valid_581507 != nil:
    section.add "customer", valid_581507
  var valid_581508 = query.getOrDefault("prettyPrint")
  valid_581508 = validateParameter(valid_581508, JBool, required = false,
                                 default = newJBool(true))
  if valid_581508 != nil:
    section.add "prettyPrint", valid_581508
  var valid_581509 = query.getOrDefault("viewType")
  valid_581509 = validateParameter(valid_581509, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_581509 != nil:
    section.add "viewType", valid_581509
  var valid_581510 = query.getOrDefault("domain")
  valid_581510 = validateParameter(valid_581510, JString, required = false,
                                 default = nil)
  if valid_581510 != nil:
    section.add "domain", valid_581510
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

proc call*(call_581512: Call_DirectoryUsersWatch_581489; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in users list
  ## 
  let valid = call_581512.validator(path, query, header, formData, body)
  let scheme = call_581512.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581512.url(scheme.get, call_581512.host, call_581512.base,
                         call_581512.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581512, url, valid)

proc call*(call_581513: Call_DirectoryUsersWatch_581489; fields: string = "";
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
  var query_581514 = newJObject()
  var body_581515 = newJObject()
  add(query_581514, "fields", newJString(fields))
  add(query_581514, "pageToken", newJString(pageToken))
  add(query_581514, "quotaUser", newJString(quotaUser))
  add(query_581514, "event", newJString(event))
  add(query_581514, "alt", newJString(alt))
  add(query_581514, "query", newJString(query))
  add(query_581514, "oauth_token", newJString(oauthToken))
  add(query_581514, "userIp", newJString(userIp))
  add(query_581514, "maxResults", newJInt(maxResults))
  add(query_581514, "orderBy", newJString(orderBy))
  add(query_581514, "showDeleted", newJString(showDeleted))
  add(query_581514, "customFieldMask", newJString(customFieldMask))
  add(query_581514, "key", newJString(key))
  add(query_581514, "projection", newJString(projection))
  add(query_581514, "sortOrder", newJString(sortOrder))
  if resource != nil:
    body_581515 = resource
  add(query_581514, "customer", newJString(customer))
  add(query_581514, "prettyPrint", newJBool(prettyPrint))
  add(query_581514, "viewType", newJString(viewType))
  add(query_581514, "domain", newJString(domain))
  result = call_581513.call(nil, query_581514, nil, nil, body_581515)

var directoryUsersWatch* = Call_DirectoryUsersWatch_581489(
    name: "directoryUsersWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/watch",
    validator: validate_DirectoryUsersWatch_581490, base: "/admin/directory/v1",
    url: url_DirectoryUsersWatch_581491, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUpdate_581534 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersUpdate_581536(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersUpdate_581535(path: JsonNode; query: JsonNode;
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
  var valid_581537 = path.getOrDefault("userKey")
  valid_581537 = validateParameter(valid_581537, JString, required = true,
                                 default = nil)
  if valid_581537 != nil:
    section.add "userKey", valid_581537
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
  var valid_581538 = query.getOrDefault("fields")
  valid_581538 = validateParameter(valid_581538, JString, required = false,
                                 default = nil)
  if valid_581538 != nil:
    section.add "fields", valid_581538
  var valid_581539 = query.getOrDefault("quotaUser")
  valid_581539 = validateParameter(valid_581539, JString, required = false,
                                 default = nil)
  if valid_581539 != nil:
    section.add "quotaUser", valid_581539
  var valid_581540 = query.getOrDefault("alt")
  valid_581540 = validateParameter(valid_581540, JString, required = false,
                                 default = newJString("json"))
  if valid_581540 != nil:
    section.add "alt", valid_581540
  var valid_581541 = query.getOrDefault("oauth_token")
  valid_581541 = validateParameter(valid_581541, JString, required = false,
                                 default = nil)
  if valid_581541 != nil:
    section.add "oauth_token", valid_581541
  var valid_581542 = query.getOrDefault("userIp")
  valid_581542 = validateParameter(valid_581542, JString, required = false,
                                 default = nil)
  if valid_581542 != nil:
    section.add "userIp", valid_581542
  var valid_581543 = query.getOrDefault("key")
  valid_581543 = validateParameter(valid_581543, JString, required = false,
                                 default = nil)
  if valid_581543 != nil:
    section.add "key", valid_581543
  var valid_581544 = query.getOrDefault("prettyPrint")
  valid_581544 = validateParameter(valid_581544, JBool, required = false,
                                 default = newJBool(true))
  if valid_581544 != nil:
    section.add "prettyPrint", valid_581544
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

proc call*(call_581546: Call_DirectoryUsersUpdate_581534; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user
  ## 
  let valid = call_581546.validator(path, query, header, formData, body)
  let scheme = call_581546.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581546.url(scheme.get, call_581546.host, call_581546.base,
                         call_581546.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581546, url, valid)

proc call*(call_581547: Call_DirectoryUsersUpdate_581534; userKey: string;
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
  var path_581548 = newJObject()
  var query_581549 = newJObject()
  var body_581550 = newJObject()
  add(query_581549, "fields", newJString(fields))
  add(query_581549, "quotaUser", newJString(quotaUser))
  add(query_581549, "alt", newJString(alt))
  add(query_581549, "oauth_token", newJString(oauthToken))
  add(query_581549, "userIp", newJString(userIp))
  add(path_581548, "userKey", newJString(userKey))
  add(query_581549, "key", newJString(key))
  if body != nil:
    body_581550 = body
  add(query_581549, "prettyPrint", newJBool(prettyPrint))
  result = call_581547.call(path_581548, query_581549, nil, nil, body_581550)

var directoryUsersUpdate* = Call_DirectoryUsersUpdate_581534(
    name: "directoryUsersUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersUpdate_581535, base: "/admin/directory/v1",
    url: url_DirectoryUsersUpdate_581536, schemes: {Scheme.Https})
type
  Call_DirectoryUsersGet_581516 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersGet_581518(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersGet_581517(path: JsonNode; query: JsonNode;
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
  var valid_581519 = path.getOrDefault("userKey")
  valid_581519 = validateParameter(valid_581519, JString, required = true,
                                 default = nil)
  if valid_581519 != nil:
    section.add "userKey", valid_581519
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
  var valid_581520 = query.getOrDefault("fields")
  valid_581520 = validateParameter(valid_581520, JString, required = false,
                                 default = nil)
  if valid_581520 != nil:
    section.add "fields", valid_581520
  var valid_581521 = query.getOrDefault("quotaUser")
  valid_581521 = validateParameter(valid_581521, JString, required = false,
                                 default = nil)
  if valid_581521 != nil:
    section.add "quotaUser", valid_581521
  var valid_581522 = query.getOrDefault("alt")
  valid_581522 = validateParameter(valid_581522, JString, required = false,
                                 default = newJString("json"))
  if valid_581522 != nil:
    section.add "alt", valid_581522
  var valid_581523 = query.getOrDefault("oauth_token")
  valid_581523 = validateParameter(valid_581523, JString, required = false,
                                 default = nil)
  if valid_581523 != nil:
    section.add "oauth_token", valid_581523
  var valid_581524 = query.getOrDefault("userIp")
  valid_581524 = validateParameter(valid_581524, JString, required = false,
                                 default = nil)
  if valid_581524 != nil:
    section.add "userIp", valid_581524
  var valid_581525 = query.getOrDefault("customFieldMask")
  valid_581525 = validateParameter(valid_581525, JString, required = false,
                                 default = nil)
  if valid_581525 != nil:
    section.add "customFieldMask", valid_581525
  var valid_581526 = query.getOrDefault("key")
  valid_581526 = validateParameter(valid_581526, JString, required = false,
                                 default = nil)
  if valid_581526 != nil:
    section.add "key", valid_581526
  var valid_581527 = query.getOrDefault("projection")
  valid_581527 = validateParameter(valid_581527, JString, required = false,
                                 default = newJString("basic"))
  if valid_581527 != nil:
    section.add "projection", valid_581527
  var valid_581528 = query.getOrDefault("prettyPrint")
  valid_581528 = validateParameter(valid_581528, JBool, required = false,
                                 default = newJBool(true))
  if valid_581528 != nil:
    section.add "prettyPrint", valid_581528
  var valid_581529 = query.getOrDefault("viewType")
  valid_581529 = validateParameter(valid_581529, JString, required = false,
                                 default = newJString("admin_view"))
  if valid_581529 != nil:
    section.add "viewType", valid_581529
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581530: Call_DirectoryUsersGet_581516; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## retrieve user
  ## 
  let valid = call_581530.validator(path, query, header, formData, body)
  let scheme = call_581530.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581530.url(scheme.get, call_581530.host, call_581530.base,
                         call_581530.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581530, url, valid)

proc call*(call_581531: Call_DirectoryUsersGet_581516; userKey: string;
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
  var path_581532 = newJObject()
  var query_581533 = newJObject()
  add(query_581533, "fields", newJString(fields))
  add(query_581533, "quotaUser", newJString(quotaUser))
  add(query_581533, "alt", newJString(alt))
  add(query_581533, "oauth_token", newJString(oauthToken))
  add(query_581533, "userIp", newJString(userIp))
  add(path_581532, "userKey", newJString(userKey))
  add(query_581533, "customFieldMask", newJString(customFieldMask))
  add(query_581533, "key", newJString(key))
  add(query_581533, "projection", newJString(projection))
  add(query_581533, "prettyPrint", newJBool(prettyPrint))
  add(query_581533, "viewType", newJString(viewType))
  result = call_581531.call(path_581532, query_581533, nil, nil, nil)

var directoryUsersGet* = Call_DirectoryUsersGet_581516(name: "directoryUsersGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersGet_581517, base: "/admin/directory/v1",
    url: url_DirectoryUsersGet_581518, schemes: {Scheme.Https})
type
  Call_DirectoryUsersPatch_581566 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersPatch_581568(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersPatch_581567(path: JsonNode; query: JsonNode;
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
  var valid_581569 = path.getOrDefault("userKey")
  valid_581569 = validateParameter(valid_581569, JString, required = true,
                                 default = nil)
  if valid_581569 != nil:
    section.add "userKey", valid_581569
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
  var valid_581570 = query.getOrDefault("fields")
  valid_581570 = validateParameter(valid_581570, JString, required = false,
                                 default = nil)
  if valid_581570 != nil:
    section.add "fields", valid_581570
  var valid_581571 = query.getOrDefault("quotaUser")
  valid_581571 = validateParameter(valid_581571, JString, required = false,
                                 default = nil)
  if valid_581571 != nil:
    section.add "quotaUser", valid_581571
  var valid_581572 = query.getOrDefault("alt")
  valid_581572 = validateParameter(valid_581572, JString, required = false,
                                 default = newJString("json"))
  if valid_581572 != nil:
    section.add "alt", valid_581572
  var valid_581573 = query.getOrDefault("oauth_token")
  valid_581573 = validateParameter(valid_581573, JString, required = false,
                                 default = nil)
  if valid_581573 != nil:
    section.add "oauth_token", valid_581573
  var valid_581574 = query.getOrDefault("userIp")
  valid_581574 = validateParameter(valid_581574, JString, required = false,
                                 default = nil)
  if valid_581574 != nil:
    section.add "userIp", valid_581574
  var valid_581575 = query.getOrDefault("key")
  valid_581575 = validateParameter(valid_581575, JString, required = false,
                                 default = nil)
  if valid_581575 != nil:
    section.add "key", valid_581575
  var valid_581576 = query.getOrDefault("prettyPrint")
  valid_581576 = validateParameter(valid_581576, JBool, required = false,
                                 default = newJBool(true))
  if valid_581576 != nil:
    section.add "prettyPrint", valid_581576
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

proc call*(call_581578: Call_DirectoryUsersPatch_581566; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## update user. This method supports patch semantics.
  ## 
  let valid = call_581578.validator(path, query, header, formData, body)
  let scheme = call_581578.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581578.url(scheme.get, call_581578.host, call_581578.base,
                         call_581578.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581578, url, valid)

proc call*(call_581579: Call_DirectoryUsersPatch_581566; userKey: string;
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
  var path_581580 = newJObject()
  var query_581581 = newJObject()
  var body_581582 = newJObject()
  add(query_581581, "fields", newJString(fields))
  add(query_581581, "quotaUser", newJString(quotaUser))
  add(query_581581, "alt", newJString(alt))
  add(query_581581, "oauth_token", newJString(oauthToken))
  add(query_581581, "userIp", newJString(userIp))
  add(path_581580, "userKey", newJString(userKey))
  add(query_581581, "key", newJString(key))
  if body != nil:
    body_581582 = body
  add(query_581581, "prettyPrint", newJBool(prettyPrint))
  result = call_581579.call(path_581580, query_581581, nil, nil, body_581582)

var directoryUsersPatch* = Call_DirectoryUsersPatch_581566(
    name: "directoryUsersPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersPatch_581567, base: "/admin/directory/v1",
    url: url_DirectoryUsersPatch_581568, schemes: {Scheme.Https})
type
  Call_DirectoryUsersDelete_581551 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersDelete_581553(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersDelete_581552(path: JsonNode; query: JsonNode;
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
  var valid_581554 = path.getOrDefault("userKey")
  valid_581554 = validateParameter(valid_581554, JString, required = true,
                                 default = nil)
  if valid_581554 != nil:
    section.add "userKey", valid_581554
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
  var valid_581555 = query.getOrDefault("fields")
  valid_581555 = validateParameter(valid_581555, JString, required = false,
                                 default = nil)
  if valid_581555 != nil:
    section.add "fields", valid_581555
  var valid_581556 = query.getOrDefault("quotaUser")
  valid_581556 = validateParameter(valid_581556, JString, required = false,
                                 default = nil)
  if valid_581556 != nil:
    section.add "quotaUser", valid_581556
  var valid_581557 = query.getOrDefault("alt")
  valid_581557 = validateParameter(valid_581557, JString, required = false,
                                 default = newJString("json"))
  if valid_581557 != nil:
    section.add "alt", valid_581557
  var valid_581558 = query.getOrDefault("oauth_token")
  valid_581558 = validateParameter(valid_581558, JString, required = false,
                                 default = nil)
  if valid_581558 != nil:
    section.add "oauth_token", valid_581558
  var valid_581559 = query.getOrDefault("userIp")
  valid_581559 = validateParameter(valid_581559, JString, required = false,
                                 default = nil)
  if valid_581559 != nil:
    section.add "userIp", valid_581559
  var valid_581560 = query.getOrDefault("key")
  valid_581560 = validateParameter(valid_581560, JString, required = false,
                                 default = nil)
  if valid_581560 != nil:
    section.add "key", valid_581560
  var valid_581561 = query.getOrDefault("prettyPrint")
  valid_581561 = validateParameter(valid_581561, JBool, required = false,
                                 default = newJBool(true))
  if valid_581561 != nil:
    section.add "prettyPrint", valid_581561
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581562: Call_DirectoryUsersDelete_581551; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete user
  ## 
  let valid = call_581562.validator(path, query, header, formData, body)
  let scheme = call_581562.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581562.url(scheme.get, call_581562.host, call_581562.base,
                         call_581562.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581562, url, valid)

proc call*(call_581563: Call_DirectoryUsersDelete_581551; userKey: string;
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
  var path_581564 = newJObject()
  var query_581565 = newJObject()
  add(query_581565, "fields", newJString(fields))
  add(query_581565, "quotaUser", newJString(quotaUser))
  add(query_581565, "alt", newJString(alt))
  add(query_581565, "oauth_token", newJString(oauthToken))
  add(query_581565, "userIp", newJString(userIp))
  add(path_581564, "userKey", newJString(userKey))
  add(query_581565, "key", newJString(key))
  add(query_581565, "prettyPrint", newJBool(prettyPrint))
  result = call_581563.call(path_581564, query_581565, nil, nil, nil)

var directoryUsersDelete* = Call_DirectoryUsersDelete_581551(
    name: "directoryUsersDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}",
    validator: validate_DirectoryUsersDelete_581552, base: "/admin/directory/v1",
    url: url_DirectoryUsersDelete_581553, schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesInsert_581599 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersAliasesInsert_581601(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersAliasesInsert_581600(path: JsonNode; query: JsonNode;
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
  var valid_581602 = path.getOrDefault("userKey")
  valid_581602 = validateParameter(valid_581602, JString, required = true,
                                 default = nil)
  if valid_581602 != nil:
    section.add "userKey", valid_581602
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
  var valid_581603 = query.getOrDefault("fields")
  valid_581603 = validateParameter(valid_581603, JString, required = false,
                                 default = nil)
  if valid_581603 != nil:
    section.add "fields", valid_581603
  var valid_581604 = query.getOrDefault("quotaUser")
  valid_581604 = validateParameter(valid_581604, JString, required = false,
                                 default = nil)
  if valid_581604 != nil:
    section.add "quotaUser", valid_581604
  var valid_581605 = query.getOrDefault("alt")
  valid_581605 = validateParameter(valid_581605, JString, required = false,
                                 default = newJString("json"))
  if valid_581605 != nil:
    section.add "alt", valid_581605
  var valid_581606 = query.getOrDefault("oauth_token")
  valid_581606 = validateParameter(valid_581606, JString, required = false,
                                 default = nil)
  if valid_581606 != nil:
    section.add "oauth_token", valid_581606
  var valid_581607 = query.getOrDefault("userIp")
  valid_581607 = validateParameter(valid_581607, JString, required = false,
                                 default = nil)
  if valid_581607 != nil:
    section.add "userIp", valid_581607
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

proc call*(call_581611: Call_DirectoryUsersAliasesInsert_581599; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a alias for the user
  ## 
  let valid = call_581611.validator(path, query, header, formData, body)
  let scheme = call_581611.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581611.url(scheme.get, call_581611.host, call_581611.base,
                         call_581611.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581611, url, valid)

proc call*(call_581612: Call_DirectoryUsersAliasesInsert_581599; userKey: string;
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
  var path_581613 = newJObject()
  var query_581614 = newJObject()
  var body_581615 = newJObject()
  add(query_581614, "fields", newJString(fields))
  add(query_581614, "quotaUser", newJString(quotaUser))
  add(query_581614, "alt", newJString(alt))
  add(query_581614, "oauth_token", newJString(oauthToken))
  add(query_581614, "userIp", newJString(userIp))
  add(path_581613, "userKey", newJString(userKey))
  add(query_581614, "key", newJString(key))
  if body != nil:
    body_581615 = body
  add(query_581614, "prettyPrint", newJBool(prettyPrint))
  result = call_581612.call(path_581613, query_581614, nil, nil, body_581615)

var directoryUsersAliasesInsert* = Call_DirectoryUsersAliasesInsert_581599(
    name: "directoryUsersAliasesInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesInsert_581600,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesInsert_581601,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesList_581583 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersAliasesList_581585(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersAliasesList_581584(path: JsonNode; query: JsonNode;
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
  var valid_581586 = path.getOrDefault("userKey")
  valid_581586 = validateParameter(valid_581586, JString, required = true,
                                 default = nil)
  if valid_581586 != nil:
    section.add "userKey", valid_581586
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
  var valid_581587 = query.getOrDefault("fields")
  valid_581587 = validateParameter(valid_581587, JString, required = false,
                                 default = nil)
  if valid_581587 != nil:
    section.add "fields", valid_581587
  var valid_581588 = query.getOrDefault("quotaUser")
  valid_581588 = validateParameter(valid_581588, JString, required = false,
                                 default = nil)
  if valid_581588 != nil:
    section.add "quotaUser", valid_581588
  var valid_581589 = query.getOrDefault("event")
  valid_581589 = validateParameter(valid_581589, JString, required = false,
                                 default = newJString("add"))
  if valid_581589 != nil:
    section.add "event", valid_581589
  var valid_581590 = query.getOrDefault("alt")
  valid_581590 = validateParameter(valid_581590, JString, required = false,
                                 default = newJString("json"))
  if valid_581590 != nil:
    section.add "alt", valid_581590
  var valid_581591 = query.getOrDefault("oauth_token")
  valid_581591 = validateParameter(valid_581591, JString, required = false,
                                 default = nil)
  if valid_581591 != nil:
    section.add "oauth_token", valid_581591
  var valid_581592 = query.getOrDefault("userIp")
  valid_581592 = validateParameter(valid_581592, JString, required = false,
                                 default = nil)
  if valid_581592 != nil:
    section.add "userIp", valid_581592
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
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581595: Call_DirectoryUsersAliasesList_581583; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List all aliases for a user
  ## 
  let valid = call_581595.validator(path, query, header, formData, body)
  let scheme = call_581595.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581595.url(scheme.get, call_581595.host, call_581595.base,
                         call_581595.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581595, url, valid)

proc call*(call_581596: Call_DirectoryUsersAliasesList_581583; userKey: string;
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
  var path_581597 = newJObject()
  var query_581598 = newJObject()
  add(query_581598, "fields", newJString(fields))
  add(query_581598, "quotaUser", newJString(quotaUser))
  add(query_581598, "event", newJString(event))
  add(query_581598, "alt", newJString(alt))
  add(query_581598, "oauth_token", newJString(oauthToken))
  add(query_581598, "userIp", newJString(userIp))
  add(path_581597, "userKey", newJString(userKey))
  add(query_581598, "key", newJString(key))
  add(query_581598, "prettyPrint", newJBool(prettyPrint))
  result = call_581596.call(path_581597, query_581598, nil, nil, nil)

var directoryUsersAliasesList* = Call_DirectoryUsersAliasesList_581583(
    name: "directoryUsersAliasesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases",
    validator: validate_DirectoryUsersAliasesList_581584,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesList_581585,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesWatch_581616 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersAliasesWatch_581618(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersAliasesWatch_581617(path: JsonNode; query: JsonNode;
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
  var valid_581619 = path.getOrDefault("userKey")
  valid_581619 = validateParameter(valid_581619, JString, required = true,
                                 default = nil)
  if valid_581619 != nil:
    section.add "userKey", valid_581619
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
  var valid_581620 = query.getOrDefault("fields")
  valid_581620 = validateParameter(valid_581620, JString, required = false,
                                 default = nil)
  if valid_581620 != nil:
    section.add "fields", valid_581620
  var valid_581621 = query.getOrDefault("quotaUser")
  valid_581621 = validateParameter(valid_581621, JString, required = false,
                                 default = nil)
  if valid_581621 != nil:
    section.add "quotaUser", valid_581621
  var valid_581622 = query.getOrDefault("event")
  valid_581622 = validateParameter(valid_581622, JString, required = false,
                                 default = newJString("add"))
  if valid_581622 != nil:
    section.add "event", valid_581622
  var valid_581623 = query.getOrDefault("alt")
  valid_581623 = validateParameter(valid_581623, JString, required = false,
                                 default = newJString("json"))
  if valid_581623 != nil:
    section.add "alt", valid_581623
  var valid_581624 = query.getOrDefault("oauth_token")
  valid_581624 = validateParameter(valid_581624, JString, required = false,
                                 default = nil)
  if valid_581624 != nil:
    section.add "oauth_token", valid_581624
  var valid_581625 = query.getOrDefault("userIp")
  valid_581625 = validateParameter(valid_581625, JString, required = false,
                                 default = nil)
  if valid_581625 != nil:
    section.add "userIp", valid_581625
  var valid_581626 = query.getOrDefault("key")
  valid_581626 = validateParameter(valid_581626, JString, required = false,
                                 default = nil)
  if valid_581626 != nil:
    section.add "key", valid_581626
  var valid_581627 = query.getOrDefault("prettyPrint")
  valid_581627 = validateParameter(valid_581627, JBool, required = false,
                                 default = newJBool(true))
  if valid_581627 != nil:
    section.add "prettyPrint", valid_581627
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

proc call*(call_581629: Call_DirectoryUsersAliasesWatch_581616; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes in user aliases list
  ## 
  let valid = call_581629.validator(path, query, header, formData, body)
  let scheme = call_581629.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581629.url(scheme.get, call_581629.host, call_581629.base,
                         call_581629.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581629, url, valid)

proc call*(call_581630: Call_DirectoryUsersAliasesWatch_581616; userKey: string;
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
  var path_581631 = newJObject()
  var query_581632 = newJObject()
  var body_581633 = newJObject()
  add(query_581632, "fields", newJString(fields))
  add(query_581632, "quotaUser", newJString(quotaUser))
  add(query_581632, "event", newJString(event))
  add(query_581632, "alt", newJString(alt))
  add(query_581632, "oauth_token", newJString(oauthToken))
  add(query_581632, "userIp", newJString(userIp))
  add(path_581631, "userKey", newJString(userKey))
  add(query_581632, "key", newJString(key))
  if resource != nil:
    body_581633 = resource
  add(query_581632, "prettyPrint", newJBool(prettyPrint))
  result = call_581630.call(path_581631, query_581632, nil, nil, body_581633)

var directoryUsersAliasesWatch* = Call_DirectoryUsersAliasesWatch_581616(
    name: "directoryUsersAliasesWatch", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/watch",
    validator: validate_DirectoryUsersAliasesWatch_581617,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesWatch_581618,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersAliasesDelete_581634 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersAliasesDelete_581636(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersAliasesDelete_581635(path: JsonNode; query: JsonNode;
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
  var valid_581637 = path.getOrDefault("userKey")
  valid_581637 = validateParameter(valid_581637, JString, required = true,
                                 default = nil)
  if valid_581637 != nil:
    section.add "userKey", valid_581637
  var valid_581638 = path.getOrDefault("alias")
  valid_581638 = validateParameter(valid_581638, JString, required = true,
                                 default = nil)
  if valid_581638 != nil:
    section.add "alias", valid_581638
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
  var valid_581639 = query.getOrDefault("fields")
  valid_581639 = validateParameter(valid_581639, JString, required = false,
                                 default = nil)
  if valid_581639 != nil:
    section.add "fields", valid_581639
  var valid_581640 = query.getOrDefault("quotaUser")
  valid_581640 = validateParameter(valid_581640, JString, required = false,
                                 default = nil)
  if valid_581640 != nil:
    section.add "quotaUser", valid_581640
  var valid_581641 = query.getOrDefault("alt")
  valid_581641 = validateParameter(valid_581641, JString, required = false,
                                 default = newJString("json"))
  if valid_581641 != nil:
    section.add "alt", valid_581641
  var valid_581642 = query.getOrDefault("oauth_token")
  valid_581642 = validateParameter(valid_581642, JString, required = false,
                                 default = nil)
  if valid_581642 != nil:
    section.add "oauth_token", valid_581642
  var valid_581643 = query.getOrDefault("userIp")
  valid_581643 = validateParameter(valid_581643, JString, required = false,
                                 default = nil)
  if valid_581643 != nil:
    section.add "userIp", valid_581643
  var valid_581644 = query.getOrDefault("key")
  valid_581644 = validateParameter(valid_581644, JString, required = false,
                                 default = nil)
  if valid_581644 != nil:
    section.add "key", valid_581644
  var valid_581645 = query.getOrDefault("prettyPrint")
  valid_581645 = validateParameter(valid_581645, JBool, required = false,
                                 default = newJBool(true))
  if valid_581645 != nil:
    section.add "prettyPrint", valid_581645
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581646: Call_DirectoryUsersAliasesDelete_581634; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove a alias for the user
  ## 
  let valid = call_581646.validator(path, query, header, formData, body)
  let scheme = call_581646.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581646.url(scheme.get, call_581646.host, call_581646.base,
                         call_581646.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581646, url, valid)

proc call*(call_581647: Call_DirectoryUsersAliasesDelete_581634; userKey: string;
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
  var path_581648 = newJObject()
  var query_581649 = newJObject()
  add(query_581649, "fields", newJString(fields))
  add(query_581649, "quotaUser", newJString(quotaUser))
  add(query_581649, "alt", newJString(alt))
  add(query_581649, "oauth_token", newJString(oauthToken))
  add(query_581649, "userIp", newJString(userIp))
  add(path_581648, "userKey", newJString(userKey))
  add(query_581649, "key", newJString(key))
  add(query_581649, "prettyPrint", newJBool(prettyPrint))
  add(path_581648, "alias", newJString(alias))
  result = call_581647.call(path_581648, query_581649, nil, nil, nil)

var directoryUsersAliasesDelete* = Call_DirectoryUsersAliasesDelete_581634(
    name: "directoryUsersAliasesDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/aliases/{alias}",
    validator: validate_DirectoryUsersAliasesDelete_581635,
    base: "/admin/directory/v1", url: url_DirectoryUsersAliasesDelete_581636,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsList_581650 = ref object of OpenApiRestCall_579437
proc url_DirectoryAspsList_581652(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryAspsList_581651(path: JsonNode; query: JsonNode;
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
  var valid_581653 = path.getOrDefault("userKey")
  valid_581653 = validateParameter(valid_581653, JString, required = true,
                                 default = nil)
  if valid_581653 != nil:
    section.add "userKey", valid_581653
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
  var valid_581654 = query.getOrDefault("fields")
  valid_581654 = validateParameter(valid_581654, JString, required = false,
                                 default = nil)
  if valid_581654 != nil:
    section.add "fields", valid_581654
  var valid_581655 = query.getOrDefault("quotaUser")
  valid_581655 = validateParameter(valid_581655, JString, required = false,
                                 default = nil)
  if valid_581655 != nil:
    section.add "quotaUser", valid_581655
  var valid_581656 = query.getOrDefault("alt")
  valid_581656 = validateParameter(valid_581656, JString, required = false,
                                 default = newJString("json"))
  if valid_581656 != nil:
    section.add "alt", valid_581656
  var valid_581657 = query.getOrDefault("oauth_token")
  valid_581657 = validateParameter(valid_581657, JString, required = false,
                                 default = nil)
  if valid_581657 != nil:
    section.add "oauth_token", valid_581657
  var valid_581658 = query.getOrDefault("userIp")
  valid_581658 = validateParameter(valid_581658, JString, required = false,
                                 default = nil)
  if valid_581658 != nil:
    section.add "userIp", valid_581658
  var valid_581659 = query.getOrDefault("key")
  valid_581659 = validateParameter(valid_581659, JString, required = false,
                                 default = nil)
  if valid_581659 != nil:
    section.add "key", valid_581659
  var valid_581660 = query.getOrDefault("prettyPrint")
  valid_581660 = validateParameter(valid_581660, JBool, required = false,
                                 default = newJBool(true))
  if valid_581660 != nil:
    section.add "prettyPrint", valid_581660
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581661: Call_DirectoryAspsList_581650; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## List the ASPs issued by a user.
  ## 
  let valid = call_581661.validator(path, query, header, formData, body)
  let scheme = call_581661.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581661.url(scheme.get, call_581661.host, call_581661.base,
                         call_581661.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581661, url, valid)

proc call*(call_581662: Call_DirectoryAspsList_581650; userKey: string;
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
  var path_581663 = newJObject()
  var query_581664 = newJObject()
  add(query_581664, "fields", newJString(fields))
  add(query_581664, "quotaUser", newJString(quotaUser))
  add(query_581664, "alt", newJString(alt))
  add(query_581664, "oauth_token", newJString(oauthToken))
  add(query_581664, "userIp", newJString(userIp))
  add(path_581663, "userKey", newJString(userKey))
  add(query_581664, "key", newJString(key))
  add(query_581664, "prettyPrint", newJBool(prettyPrint))
  result = call_581662.call(path_581663, query_581664, nil, nil, nil)

var directoryAspsList* = Call_DirectoryAspsList_581650(name: "directoryAspsList",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps", validator: validate_DirectoryAspsList_581651,
    base: "/admin/directory/v1", url: url_DirectoryAspsList_581652,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsGet_581665 = ref object of OpenApiRestCall_579437
proc url_DirectoryAspsGet_581667(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryAspsGet_581666(path: JsonNode; query: JsonNode;
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
  var valid_581668 = path.getOrDefault("userKey")
  valid_581668 = validateParameter(valid_581668, JString, required = true,
                                 default = nil)
  if valid_581668 != nil:
    section.add "userKey", valid_581668
  var valid_581669 = path.getOrDefault("codeId")
  valid_581669 = validateParameter(valid_581669, JInt, required = true, default = nil)
  if valid_581669 != nil:
    section.add "codeId", valid_581669
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
  var valid_581670 = query.getOrDefault("fields")
  valid_581670 = validateParameter(valid_581670, JString, required = false,
                                 default = nil)
  if valid_581670 != nil:
    section.add "fields", valid_581670
  var valid_581671 = query.getOrDefault("quotaUser")
  valid_581671 = validateParameter(valid_581671, JString, required = false,
                                 default = nil)
  if valid_581671 != nil:
    section.add "quotaUser", valid_581671
  var valid_581672 = query.getOrDefault("alt")
  valid_581672 = validateParameter(valid_581672, JString, required = false,
                                 default = newJString("json"))
  if valid_581672 != nil:
    section.add "alt", valid_581672
  var valid_581673 = query.getOrDefault("oauth_token")
  valid_581673 = validateParameter(valid_581673, JString, required = false,
                                 default = nil)
  if valid_581673 != nil:
    section.add "oauth_token", valid_581673
  var valid_581674 = query.getOrDefault("userIp")
  valid_581674 = validateParameter(valid_581674, JString, required = false,
                                 default = nil)
  if valid_581674 != nil:
    section.add "userIp", valid_581674
  var valid_581675 = query.getOrDefault("key")
  valid_581675 = validateParameter(valid_581675, JString, required = false,
                                 default = nil)
  if valid_581675 != nil:
    section.add "key", valid_581675
  var valid_581676 = query.getOrDefault("prettyPrint")
  valid_581676 = validateParameter(valid_581676, JBool, required = false,
                                 default = newJBool(true))
  if valid_581676 != nil:
    section.add "prettyPrint", valid_581676
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581677: Call_DirectoryAspsGet_581665; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an ASP issued by a user.
  ## 
  let valid = call_581677.validator(path, query, header, formData, body)
  let scheme = call_581677.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581677.url(scheme.get, call_581677.host, call_581677.base,
                         call_581677.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581677, url, valid)

proc call*(call_581678: Call_DirectoryAspsGet_581665; userKey: string; codeId: int;
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
  var path_581679 = newJObject()
  var query_581680 = newJObject()
  add(query_581680, "fields", newJString(fields))
  add(query_581680, "quotaUser", newJString(quotaUser))
  add(query_581680, "alt", newJString(alt))
  add(query_581680, "oauth_token", newJString(oauthToken))
  add(query_581680, "userIp", newJString(userIp))
  add(path_581679, "userKey", newJString(userKey))
  add(query_581680, "key", newJString(key))
  add(path_581679, "codeId", newJInt(codeId))
  add(query_581680, "prettyPrint", newJBool(prettyPrint))
  result = call_581678.call(path_581679, query_581680, nil, nil, nil)

var directoryAspsGet* = Call_DirectoryAspsGet_581665(name: "directoryAspsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/users/{userKey}/asps/{codeId}", validator: validate_DirectoryAspsGet_581666,
    base: "/admin/directory/v1", url: url_DirectoryAspsGet_581667,
    schemes: {Scheme.Https})
type
  Call_DirectoryAspsDelete_581681 = ref object of OpenApiRestCall_579437
proc url_DirectoryAspsDelete_581683(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryAspsDelete_581682(path: JsonNode; query: JsonNode;
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
  var valid_581684 = path.getOrDefault("userKey")
  valid_581684 = validateParameter(valid_581684, JString, required = true,
                                 default = nil)
  if valid_581684 != nil:
    section.add "userKey", valid_581684
  var valid_581685 = path.getOrDefault("codeId")
  valid_581685 = validateParameter(valid_581685, JInt, required = true, default = nil)
  if valid_581685 != nil:
    section.add "codeId", valid_581685
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
  var valid_581686 = query.getOrDefault("fields")
  valid_581686 = validateParameter(valid_581686, JString, required = false,
                                 default = nil)
  if valid_581686 != nil:
    section.add "fields", valid_581686
  var valid_581687 = query.getOrDefault("quotaUser")
  valid_581687 = validateParameter(valid_581687, JString, required = false,
                                 default = nil)
  if valid_581687 != nil:
    section.add "quotaUser", valid_581687
  var valid_581688 = query.getOrDefault("alt")
  valid_581688 = validateParameter(valid_581688, JString, required = false,
                                 default = newJString("json"))
  if valid_581688 != nil:
    section.add "alt", valid_581688
  var valid_581689 = query.getOrDefault("oauth_token")
  valid_581689 = validateParameter(valid_581689, JString, required = false,
                                 default = nil)
  if valid_581689 != nil:
    section.add "oauth_token", valid_581689
  var valid_581690 = query.getOrDefault("userIp")
  valid_581690 = validateParameter(valid_581690, JString, required = false,
                                 default = nil)
  if valid_581690 != nil:
    section.add "userIp", valid_581690
  var valid_581691 = query.getOrDefault("key")
  valid_581691 = validateParameter(valid_581691, JString, required = false,
                                 default = nil)
  if valid_581691 != nil:
    section.add "key", valid_581691
  var valid_581692 = query.getOrDefault("prettyPrint")
  valid_581692 = validateParameter(valid_581692, JBool, required = false,
                                 default = newJBool(true))
  if valid_581692 != nil:
    section.add "prettyPrint", valid_581692
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581693: Call_DirectoryAspsDelete_581681; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete an ASP issued by a user.
  ## 
  let valid = call_581693.validator(path, query, header, formData, body)
  let scheme = call_581693.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581693.url(scheme.get, call_581693.host, call_581693.base,
                         call_581693.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581693, url, valid)

proc call*(call_581694: Call_DirectoryAspsDelete_581681; userKey: string;
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
  var path_581695 = newJObject()
  var query_581696 = newJObject()
  add(query_581696, "fields", newJString(fields))
  add(query_581696, "quotaUser", newJString(quotaUser))
  add(query_581696, "alt", newJString(alt))
  add(query_581696, "oauth_token", newJString(oauthToken))
  add(query_581696, "userIp", newJString(userIp))
  add(path_581695, "userKey", newJString(userKey))
  add(query_581696, "key", newJString(key))
  add(path_581695, "codeId", newJInt(codeId))
  add(query_581696, "prettyPrint", newJBool(prettyPrint))
  result = call_581694.call(path_581695, query_581696, nil, nil, nil)

var directoryAspsDelete* = Call_DirectoryAspsDelete_581681(
    name: "directoryAspsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/asps/{codeId}",
    validator: validate_DirectoryAspsDelete_581682, base: "/admin/directory/v1",
    url: url_DirectoryAspsDelete_581683, schemes: {Scheme.Https})
type
  Call_DirectoryUsersMakeAdmin_581697 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersMakeAdmin_581699(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersMakeAdmin_581698(path: JsonNode; query: JsonNode;
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
  var valid_581700 = path.getOrDefault("userKey")
  valid_581700 = validateParameter(valid_581700, JString, required = true,
                                 default = nil)
  if valid_581700 != nil:
    section.add "userKey", valid_581700
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
  var valid_581701 = query.getOrDefault("fields")
  valid_581701 = validateParameter(valid_581701, JString, required = false,
                                 default = nil)
  if valid_581701 != nil:
    section.add "fields", valid_581701
  var valid_581702 = query.getOrDefault("quotaUser")
  valid_581702 = validateParameter(valid_581702, JString, required = false,
                                 default = nil)
  if valid_581702 != nil:
    section.add "quotaUser", valid_581702
  var valid_581703 = query.getOrDefault("alt")
  valid_581703 = validateParameter(valid_581703, JString, required = false,
                                 default = newJString("json"))
  if valid_581703 != nil:
    section.add "alt", valid_581703
  var valid_581704 = query.getOrDefault("oauth_token")
  valid_581704 = validateParameter(valid_581704, JString, required = false,
                                 default = nil)
  if valid_581704 != nil:
    section.add "oauth_token", valid_581704
  var valid_581705 = query.getOrDefault("userIp")
  valid_581705 = validateParameter(valid_581705, JString, required = false,
                                 default = nil)
  if valid_581705 != nil:
    section.add "userIp", valid_581705
  var valid_581706 = query.getOrDefault("key")
  valid_581706 = validateParameter(valid_581706, JString, required = false,
                                 default = nil)
  if valid_581706 != nil:
    section.add "key", valid_581706
  var valid_581707 = query.getOrDefault("prettyPrint")
  valid_581707 = validateParameter(valid_581707, JBool, required = false,
                                 default = newJBool(true))
  if valid_581707 != nil:
    section.add "prettyPrint", valid_581707
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

proc call*(call_581709: Call_DirectoryUsersMakeAdmin_581697; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## change admin status of a user
  ## 
  let valid = call_581709.validator(path, query, header, formData, body)
  let scheme = call_581709.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581709.url(scheme.get, call_581709.host, call_581709.base,
                         call_581709.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581709, url, valid)

proc call*(call_581710: Call_DirectoryUsersMakeAdmin_581697; userKey: string;
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
  var path_581711 = newJObject()
  var query_581712 = newJObject()
  var body_581713 = newJObject()
  add(query_581712, "fields", newJString(fields))
  add(query_581712, "quotaUser", newJString(quotaUser))
  add(query_581712, "alt", newJString(alt))
  add(query_581712, "oauth_token", newJString(oauthToken))
  add(query_581712, "userIp", newJString(userIp))
  add(path_581711, "userKey", newJString(userKey))
  add(query_581712, "key", newJString(key))
  if body != nil:
    body_581713 = body
  add(query_581712, "prettyPrint", newJBool(prettyPrint))
  result = call_581710.call(path_581711, query_581712, nil, nil, body_581713)

var directoryUsersMakeAdmin* = Call_DirectoryUsersMakeAdmin_581697(
    name: "directoryUsersMakeAdmin", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/makeAdmin",
    validator: validate_DirectoryUsersMakeAdmin_581698,
    base: "/admin/directory/v1", url: url_DirectoryUsersMakeAdmin_581699,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosUpdate_581729 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersPhotosUpdate_581731(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersPhotosUpdate_581730(path: JsonNode; query: JsonNode;
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
  var valid_581732 = path.getOrDefault("userKey")
  valid_581732 = validateParameter(valid_581732, JString, required = true,
                                 default = nil)
  if valid_581732 != nil:
    section.add "userKey", valid_581732
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
  var valid_581733 = query.getOrDefault("fields")
  valid_581733 = validateParameter(valid_581733, JString, required = false,
                                 default = nil)
  if valid_581733 != nil:
    section.add "fields", valid_581733
  var valid_581734 = query.getOrDefault("quotaUser")
  valid_581734 = validateParameter(valid_581734, JString, required = false,
                                 default = nil)
  if valid_581734 != nil:
    section.add "quotaUser", valid_581734
  var valid_581735 = query.getOrDefault("alt")
  valid_581735 = validateParameter(valid_581735, JString, required = false,
                                 default = newJString("json"))
  if valid_581735 != nil:
    section.add "alt", valid_581735
  var valid_581736 = query.getOrDefault("oauth_token")
  valid_581736 = validateParameter(valid_581736, JString, required = false,
                                 default = nil)
  if valid_581736 != nil:
    section.add "oauth_token", valid_581736
  var valid_581737 = query.getOrDefault("userIp")
  valid_581737 = validateParameter(valid_581737, JString, required = false,
                                 default = nil)
  if valid_581737 != nil:
    section.add "userIp", valid_581737
  var valid_581738 = query.getOrDefault("key")
  valid_581738 = validateParameter(valid_581738, JString, required = false,
                                 default = nil)
  if valid_581738 != nil:
    section.add "key", valid_581738
  var valid_581739 = query.getOrDefault("prettyPrint")
  valid_581739 = validateParameter(valid_581739, JBool, required = false,
                                 default = newJBool(true))
  if valid_581739 != nil:
    section.add "prettyPrint", valid_581739
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

proc call*(call_581741: Call_DirectoryUsersPhotosUpdate_581729; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user
  ## 
  let valid = call_581741.validator(path, query, header, formData, body)
  let scheme = call_581741.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581741.url(scheme.get, call_581741.host, call_581741.base,
                         call_581741.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581741, url, valid)

proc call*(call_581742: Call_DirectoryUsersPhotosUpdate_581729; userKey: string;
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
  var path_581743 = newJObject()
  var query_581744 = newJObject()
  var body_581745 = newJObject()
  add(query_581744, "fields", newJString(fields))
  add(query_581744, "quotaUser", newJString(quotaUser))
  add(query_581744, "alt", newJString(alt))
  add(query_581744, "oauth_token", newJString(oauthToken))
  add(query_581744, "userIp", newJString(userIp))
  add(path_581743, "userKey", newJString(userKey))
  add(query_581744, "key", newJString(key))
  if body != nil:
    body_581745 = body
  add(query_581744, "prettyPrint", newJBool(prettyPrint))
  result = call_581742.call(path_581743, query_581744, nil, nil, body_581745)

var directoryUsersPhotosUpdate* = Call_DirectoryUsersPhotosUpdate_581729(
    name: "directoryUsersPhotosUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosUpdate_581730,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosUpdate_581731,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosGet_581714 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersPhotosGet_581716(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersPhotosGet_581715(path: JsonNode; query: JsonNode;
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
  var valid_581717 = path.getOrDefault("userKey")
  valid_581717 = validateParameter(valid_581717, JString, required = true,
                                 default = nil)
  if valid_581717 != nil:
    section.add "userKey", valid_581717
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
  var valid_581718 = query.getOrDefault("fields")
  valid_581718 = validateParameter(valid_581718, JString, required = false,
                                 default = nil)
  if valid_581718 != nil:
    section.add "fields", valid_581718
  var valid_581719 = query.getOrDefault("quotaUser")
  valid_581719 = validateParameter(valid_581719, JString, required = false,
                                 default = nil)
  if valid_581719 != nil:
    section.add "quotaUser", valid_581719
  var valid_581720 = query.getOrDefault("alt")
  valid_581720 = validateParameter(valid_581720, JString, required = false,
                                 default = newJString("json"))
  if valid_581720 != nil:
    section.add "alt", valid_581720
  var valid_581721 = query.getOrDefault("oauth_token")
  valid_581721 = validateParameter(valid_581721, JString, required = false,
                                 default = nil)
  if valid_581721 != nil:
    section.add "oauth_token", valid_581721
  var valid_581722 = query.getOrDefault("userIp")
  valid_581722 = validateParameter(valid_581722, JString, required = false,
                                 default = nil)
  if valid_581722 != nil:
    section.add "userIp", valid_581722
  var valid_581723 = query.getOrDefault("key")
  valid_581723 = validateParameter(valid_581723, JString, required = false,
                                 default = nil)
  if valid_581723 != nil:
    section.add "key", valid_581723
  var valid_581724 = query.getOrDefault("prettyPrint")
  valid_581724 = validateParameter(valid_581724, JBool, required = false,
                                 default = newJBool(true))
  if valid_581724 != nil:
    section.add "prettyPrint", valid_581724
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581725: Call_DirectoryUsersPhotosGet_581714; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieve photo of a user
  ## 
  let valid = call_581725.validator(path, query, header, formData, body)
  let scheme = call_581725.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581725.url(scheme.get, call_581725.host, call_581725.base,
                         call_581725.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581725, url, valid)

proc call*(call_581726: Call_DirectoryUsersPhotosGet_581714; userKey: string;
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
  var path_581727 = newJObject()
  var query_581728 = newJObject()
  add(query_581728, "fields", newJString(fields))
  add(query_581728, "quotaUser", newJString(quotaUser))
  add(query_581728, "alt", newJString(alt))
  add(query_581728, "oauth_token", newJString(oauthToken))
  add(query_581728, "userIp", newJString(userIp))
  add(path_581727, "userKey", newJString(userKey))
  add(query_581728, "key", newJString(key))
  add(query_581728, "prettyPrint", newJBool(prettyPrint))
  result = call_581726.call(path_581727, query_581728, nil, nil, nil)

var directoryUsersPhotosGet* = Call_DirectoryUsersPhotosGet_581714(
    name: "directoryUsersPhotosGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosGet_581715,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosGet_581716,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosPatch_581761 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersPhotosPatch_581763(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersPhotosPatch_581762(path: JsonNode; query: JsonNode;
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
  var valid_581764 = path.getOrDefault("userKey")
  valid_581764 = validateParameter(valid_581764, JString, required = true,
                                 default = nil)
  if valid_581764 != nil:
    section.add "userKey", valid_581764
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
  var valid_581765 = query.getOrDefault("fields")
  valid_581765 = validateParameter(valid_581765, JString, required = false,
                                 default = nil)
  if valid_581765 != nil:
    section.add "fields", valid_581765
  var valid_581766 = query.getOrDefault("quotaUser")
  valid_581766 = validateParameter(valid_581766, JString, required = false,
                                 default = nil)
  if valid_581766 != nil:
    section.add "quotaUser", valid_581766
  var valid_581767 = query.getOrDefault("alt")
  valid_581767 = validateParameter(valid_581767, JString, required = false,
                                 default = newJString("json"))
  if valid_581767 != nil:
    section.add "alt", valid_581767
  var valid_581768 = query.getOrDefault("oauth_token")
  valid_581768 = validateParameter(valid_581768, JString, required = false,
                                 default = nil)
  if valid_581768 != nil:
    section.add "oauth_token", valid_581768
  var valid_581769 = query.getOrDefault("userIp")
  valid_581769 = validateParameter(valid_581769, JString, required = false,
                                 default = nil)
  if valid_581769 != nil:
    section.add "userIp", valid_581769
  var valid_581770 = query.getOrDefault("key")
  valid_581770 = validateParameter(valid_581770, JString, required = false,
                                 default = nil)
  if valid_581770 != nil:
    section.add "key", valid_581770
  var valid_581771 = query.getOrDefault("prettyPrint")
  valid_581771 = validateParameter(valid_581771, JBool, required = false,
                                 default = newJBool(true))
  if valid_581771 != nil:
    section.add "prettyPrint", valid_581771
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

proc call*(call_581773: Call_DirectoryUsersPhotosPatch_581761; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Add a photo for the user. This method supports patch semantics.
  ## 
  let valid = call_581773.validator(path, query, header, formData, body)
  let scheme = call_581773.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581773.url(scheme.get, call_581773.host, call_581773.base,
                         call_581773.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581773, url, valid)

proc call*(call_581774: Call_DirectoryUsersPhotosPatch_581761; userKey: string;
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
  var path_581775 = newJObject()
  var query_581776 = newJObject()
  var body_581777 = newJObject()
  add(query_581776, "fields", newJString(fields))
  add(query_581776, "quotaUser", newJString(quotaUser))
  add(query_581776, "alt", newJString(alt))
  add(query_581776, "oauth_token", newJString(oauthToken))
  add(query_581776, "userIp", newJString(userIp))
  add(path_581775, "userKey", newJString(userKey))
  add(query_581776, "key", newJString(key))
  if body != nil:
    body_581777 = body
  add(query_581776, "prettyPrint", newJBool(prettyPrint))
  result = call_581774.call(path_581775, query_581776, nil, nil, body_581777)

var directoryUsersPhotosPatch* = Call_DirectoryUsersPhotosPatch_581761(
    name: "directoryUsersPhotosPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosPatch_581762,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosPatch_581763,
    schemes: {Scheme.Https})
type
  Call_DirectoryUsersPhotosDelete_581746 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersPhotosDelete_581748(protocol: Scheme; host: string;
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

proc validate_DirectoryUsersPhotosDelete_581747(path: JsonNode; query: JsonNode;
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
  var valid_581749 = path.getOrDefault("userKey")
  valid_581749 = validateParameter(valid_581749, JString, required = true,
                                 default = nil)
  if valid_581749 != nil:
    section.add "userKey", valid_581749
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
  var valid_581750 = query.getOrDefault("fields")
  valid_581750 = validateParameter(valid_581750, JString, required = false,
                                 default = nil)
  if valid_581750 != nil:
    section.add "fields", valid_581750
  var valid_581751 = query.getOrDefault("quotaUser")
  valid_581751 = validateParameter(valid_581751, JString, required = false,
                                 default = nil)
  if valid_581751 != nil:
    section.add "quotaUser", valid_581751
  var valid_581752 = query.getOrDefault("alt")
  valid_581752 = validateParameter(valid_581752, JString, required = false,
                                 default = newJString("json"))
  if valid_581752 != nil:
    section.add "alt", valid_581752
  var valid_581753 = query.getOrDefault("oauth_token")
  valid_581753 = validateParameter(valid_581753, JString, required = false,
                                 default = nil)
  if valid_581753 != nil:
    section.add "oauth_token", valid_581753
  var valid_581754 = query.getOrDefault("userIp")
  valid_581754 = validateParameter(valid_581754, JString, required = false,
                                 default = nil)
  if valid_581754 != nil:
    section.add "userIp", valid_581754
  var valid_581755 = query.getOrDefault("key")
  valid_581755 = validateParameter(valid_581755, JString, required = false,
                                 default = nil)
  if valid_581755 != nil:
    section.add "key", valid_581755
  var valid_581756 = query.getOrDefault("prettyPrint")
  valid_581756 = validateParameter(valid_581756, JBool, required = false,
                                 default = newJBool(true))
  if valid_581756 != nil:
    section.add "prettyPrint", valid_581756
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581757: Call_DirectoryUsersPhotosDelete_581746; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Remove photos for the user
  ## 
  let valid = call_581757.validator(path, query, header, formData, body)
  let scheme = call_581757.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581757.url(scheme.get, call_581757.host, call_581757.base,
                         call_581757.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581757, url, valid)

proc call*(call_581758: Call_DirectoryUsersPhotosDelete_581746; userKey: string;
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
  var path_581759 = newJObject()
  var query_581760 = newJObject()
  add(query_581760, "fields", newJString(fields))
  add(query_581760, "quotaUser", newJString(quotaUser))
  add(query_581760, "alt", newJString(alt))
  add(query_581760, "oauth_token", newJString(oauthToken))
  add(query_581760, "userIp", newJString(userIp))
  add(path_581759, "userKey", newJString(userKey))
  add(query_581760, "key", newJString(key))
  add(query_581760, "prettyPrint", newJBool(prettyPrint))
  result = call_581758.call(path_581759, query_581760, nil, nil, nil)

var directoryUsersPhotosDelete* = Call_DirectoryUsersPhotosDelete_581746(
    name: "directoryUsersPhotosDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/photos/thumbnail",
    validator: validate_DirectoryUsersPhotosDelete_581747,
    base: "/admin/directory/v1", url: url_DirectoryUsersPhotosDelete_581748,
    schemes: {Scheme.Https})
type
  Call_DirectoryTokensList_581778 = ref object of OpenApiRestCall_579437
proc url_DirectoryTokensList_581780(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryTokensList_581779(path: JsonNode; query: JsonNode;
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
  var valid_581781 = path.getOrDefault("userKey")
  valid_581781 = validateParameter(valid_581781, JString, required = true,
                                 default = nil)
  if valid_581781 != nil:
    section.add "userKey", valid_581781
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
  var valid_581782 = query.getOrDefault("fields")
  valid_581782 = validateParameter(valid_581782, JString, required = false,
                                 default = nil)
  if valid_581782 != nil:
    section.add "fields", valid_581782
  var valid_581783 = query.getOrDefault("quotaUser")
  valid_581783 = validateParameter(valid_581783, JString, required = false,
                                 default = nil)
  if valid_581783 != nil:
    section.add "quotaUser", valid_581783
  var valid_581784 = query.getOrDefault("alt")
  valid_581784 = validateParameter(valid_581784, JString, required = false,
                                 default = newJString("json"))
  if valid_581784 != nil:
    section.add "alt", valid_581784
  var valid_581785 = query.getOrDefault("oauth_token")
  valid_581785 = validateParameter(valid_581785, JString, required = false,
                                 default = nil)
  if valid_581785 != nil:
    section.add "oauth_token", valid_581785
  var valid_581786 = query.getOrDefault("userIp")
  valid_581786 = validateParameter(valid_581786, JString, required = false,
                                 default = nil)
  if valid_581786 != nil:
    section.add "userIp", valid_581786
  var valid_581787 = query.getOrDefault("key")
  valid_581787 = validateParameter(valid_581787, JString, required = false,
                                 default = nil)
  if valid_581787 != nil:
    section.add "key", valid_581787
  var valid_581788 = query.getOrDefault("prettyPrint")
  valid_581788 = validateParameter(valid_581788, JBool, required = false,
                                 default = newJBool(true))
  if valid_581788 != nil:
    section.add "prettyPrint", valid_581788
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581789: Call_DirectoryTokensList_581778; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the set of tokens specified user has issued to 3rd party applications.
  ## 
  let valid = call_581789.validator(path, query, header, formData, body)
  let scheme = call_581789.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581789.url(scheme.get, call_581789.host, call_581789.base,
                         call_581789.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581789, url, valid)

proc call*(call_581790: Call_DirectoryTokensList_581778; userKey: string;
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
  var path_581791 = newJObject()
  var query_581792 = newJObject()
  add(query_581792, "fields", newJString(fields))
  add(query_581792, "quotaUser", newJString(quotaUser))
  add(query_581792, "alt", newJString(alt))
  add(query_581792, "oauth_token", newJString(oauthToken))
  add(query_581792, "userIp", newJString(userIp))
  add(path_581791, "userKey", newJString(userKey))
  add(query_581792, "key", newJString(key))
  add(query_581792, "prettyPrint", newJBool(prettyPrint))
  result = call_581790.call(path_581791, query_581792, nil, nil, nil)

var directoryTokensList* = Call_DirectoryTokensList_581778(
    name: "directoryTokensList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens",
    validator: validate_DirectoryTokensList_581779, base: "/admin/directory/v1",
    url: url_DirectoryTokensList_581780, schemes: {Scheme.Https})
type
  Call_DirectoryTokensGet_581793 = ref object of OpenApiRestCall_579437
proc url_DirectoryTokensGet_581795(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryTokensGet_581794(path: JsonNode; query: JsonNode;
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
  var valid_581796 = path.getOrDefault("clientId")
  valid_581796 = validateParameter(valid_581796, JString, required = true,
                                 default = nil)
  if valid_581796 != nil:
    section.add "clientId", valid_581796
  var valid_581797 = path.getOrDefault("userKey")
  valid_581797 = validateParameter(valid_581797, JString, required = true,
                                 default = nil)
  if valid_581797 != nil:
    section.add "userKey", valid_581797
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
  var valid_581798 = query.getOrDefault("fields")
  valid_581798 = validateParameter(valid_581798, JString, required = false,
                                 default = nil)
  if valid_581798 != nil:
    section.add "fields", valid_581798
  var valid_581799 = query.getOrDefault("quotaUser")
  valid_581799 = validateParameter(valid_581799, JString, required = false,
                                 default = nil)
  if valid_581799 != nil:
    section.add "quotaUser", valid_581799
  var valid_581800 = query.getOrDefault("alt")
  valid_581800 = validateParameter(valid_581800, JString, required = false,
                                 default = newJString("json"))
  if valid_581800 != nil:
    section.add "alt", valid_581800
  var valid_581801 = query.getOrDefault("oauth_token")
  valid_581801 = validateParameter(valid_581801, JString, required = false,
                                 default = nil)
  if valid_581801 != nil:
    section.add "oauth_token", valid_581801
  var valid_581802 = query.getOrDefault("userIp")
  valid_581802 = validateParameter(valid_581802, JString, required = false,
                                 default = nil)
  if valid_581802 != nil:
    section.add "userIp", valid_581802
  var valid_581803 = query.getOrDefault("key")
  valid_581803 = validateParameter(valid_581803, JString, required = false,
                                 default = nil)
  if valid_581803 != nil:
    section.add "key", valid_581803
  var valid_581804 = query.getOrDefault("prettyPrint")
  valid_581804 = validateParameter(valid_581804, JBool, required = false,
                                 default = newJBool(true))
  if valid_581804 != nil:
    section.add "prettyPrint", valid_581804
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581805: Call_DirectoryTokensGet_581793; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Get information about an access token issued by a user.
  ## 
  let valid = call_581805.validator(path, query, header, formData, body)
  let scheme = call_581805.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581805.url(scheme.get, call_581805.host, call_581805.base,
                         call_581805.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581805, url, valid)

proc call*(call_581806: Call_DirectoryTokensGet_581793; clientId: string;
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
  var path_581807 = newJObject()
  var query_581808 = newJObject()
  add(query_581808, "fields", newJString(fields))
  add(query_581808, "quotaUser", newJString(quotaUser))
  add(query_581808, "alt", newJString(alt))
  add(query_581808, "oauth_token", newJString(oauthToken))
  add(query_581808, "userIp", newJString(userIp))
  add(path_581807, "clientId", newJString(clientId))
  add(path_581807, "userKey", newJString(userKey))
  add(query_581808, "key", newJString(key))
  add(query_581808, "prettyPrint", newJBool(prettyPrint))
  result = call_581806.call(path_581807, query_581808, nil, nil, nil)

var directoryTokensGet* = Call_DirectoryTokensGet_581793(
    name: "directoryTokensGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensGet_581794, base: "/admin/directory/v1",
    url: url_DirectoryTokensGet_581795, schemes: {Scheme.Https})
type
  Call_DirectoryTokensDelete_581809 = ref object of OpenApiRestCall_579437
proc url_DirectoryTokensDelete_581811(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryTokensDelete_581810(path: JsonNode; query: JsonNode;
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
  var valid_581812 = path.getOrDefault("clientId")
  valid_581812 = validateParameter(valid_581812, JString, required = true,
                                 default = nil)
  if valid_581812 != nil:
    section.add "clientId", valid_581812
  var valid_581813 = path.getOrDefault("userKey")
  valid_581813 = validateParameter(valid_581813, JString, required = true,
                                 default = nil)
  if valid_581813 != nil:
    section.add "userKey", valid_581813
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
  var valid_581814 = query.getOrDefault("fields")
  valid_581814 = validateParameter(valid_581814, JString, required = false,
                                 default = nil)
  if valid_581814 != nil:
    section.add "fields", valid_581814
  var valid_581815 = query.getOrDefault("quotaUser")
  valid_581815 = validateParameter(valid_581815, JString, required = false,
                                 default = nil)
  if valid_581815 != nil:
    section.add "quotaUser", valid_581815
  var valid_581816 = query.getOrDefault("alt")
  valid_581816 = validateParameter(valid_581816, JString, required = false,
                                 default = newJString("json"))
  if valid_581816 != nil:
    section.add "alt", valid_581816
  var valid_581817 = query.getOrDefault("oauth_token")
  valid_581817 = validateParameter(valid_581817, JString, required = false,
                                 default = nil)
  if valid_581817 != nil:
    section.add "oauth_token", valid_581817
  var valid_581818 = query.getOrDefault("userIp")
  valid_581818 = validateParameter(valid_581818, JString, required = false,
                                 default = nil)
  if valid_581818 != nil:
    section.add "userIp", valid_581818
  var valid_581819 = query.getOrDefault("key")
  valid_581819 = validateParameter(valid_581819, JString, required = false,
                                 default = nil)
  if valid_581819 != nil:
    section.add "key", valid_581819
  var valid_581820 = query.getOrDefault("prettyPrint")
  valid_581820 = validateParameter(valid_581820, JBool, required = false,
                                 default = newJBool(true))
  if valid_581820 != nil:
    section.add "prettyPrint", valid_581820
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581821: Call_DirectoryTokensDelete_581809; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Delete all access tokens issued by a user for an application.
  ## 
  let valid = call_581821.validator(path, query, header, formData, body)
  let scheme = call_581821.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581821.url(scheme.get, call_581821.host, call_581821.base,
                         call_581821.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581821, url, valid)

proc call*(call_581822: Call_DirectoryTokensDelete_581809; clientId: string;
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
  var path_581823 = newJObject()
  var query_581824 = newJObject()
  add(query_581824, "fields", newJString(fields))
  add(query_581824, "quotaUser", newJString(quotaUser))
  add(query_581824, "alt", newJString(alt))
  add(query_581824, "oauth_token", newJString(oauthToken))
  add(query_581824, "userIp", newJString(userIp))
  add(path_581823, "clientId", newJString(clientId))
  add(path_581823, "userKey", newJString(userKey))
  add(query_581824, "key", newJString(key))
  add(query_581824, "prettyPrint", newJBool(prettyPrint))
  result = call_581822.call(path_581823, query_581824, nil, nil, nil)

var directoryTokensDelete* = Call_DirectoryTokensDelete_581809(
    name: "directoryTokensDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/users/{userKey}/tokens/{clientId}",
    validator: validate_DirectoryTokensDelete_581810, base: "/admin/directory/v1",
    url: url_DirectoryTokensDelete_581811, schemes: {Scheme.Https})
type
  Call_DirectoryUsersUndelete_581825 = ref object of OpenApiRestCall_579437
proc url_DirectoryUsersUndelete_581827(protocol: Scheme; host: string; base: string;
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

proc validate_DirectoryUsersUndelete_581826(path: JsonNode; query: JsonNode;
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
  var valid_581828 = path.getOrDefault("userKey")
  valid_581828 = validateParameter(valid_581828, JString, required = true,
                                 default = nil)
  if valid_581828 != nil:
    section.add "userKey", valid_581828
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
  var valid_581829 = query.getOrDefault("fields")
  valid_581829 = validateParameter(valid_581829, JString, required = false,
                                 default = nil)
  if valid_581829 != nil:
    section.add "fields", valid_581829
  var valid_581830 = query.getOrDefault("quotaUser")
  valid_581830 = validateParameter(valid_581830, JString, required = false,
                                 default = nil)
  if valid_581830 != nil:
    section.add "quotaUser", valid_581830
  var valid_581831 = query.getOrDefault("alt")
  valid_581831 = validateParameter(valid_581831, JString, required = false,
                                 default = newJString("json"))
  if valid_581831 != nil:
    section.add "alt", valid_581831
  var valid_581832 = query.getOrDefault("oauth_token")
  valid_581832 = validateParameter(valid_581832, JString, required = false,
                                 default = nil)
  if valid_581832 != nil:
    section.add "oauth_token", valid_581832
  var valid_581833 = query.getOrDefault("userIp")
  valid_581833 = validateParameter(valid_581833, JString, required = false,
                                 default = nil)
  if valid_581833 != nil:
    section.add "userIp", valid_581833
  var valid_581834 = query.getOrDefault("key")
  valid_581834 = validateParameter(valid_581834, JString, required = false,
                                 default = nil)
  if valid_581834 != nil:
    section.add "key", valid_581834
  var valid_581835 = query.getOrDefault("prettyPrint")
  valid_581835 = validateParameter(valid_581835, JBool, required = false,
                                 default = newJBool(true))
  if valid_581835 != nil:
    section.add "prettyPrint", valid_581835
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

proc call*(call_581837: Call_DirectoryUsersUndelete_581825; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Undelete a deleted user
  ## 
  let valid = call_581837.validator(path, query, header, formData, body)
  let scheme = call_581837.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581837.url(scheme.get, call_581837.host, call_581837.base,
                         call_581837.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581837, url, valid)

proc call*(call_581838: Call_DirectoryUsersUndelete_581825; userKey: string;
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
  var path_581839 = newJObject()
  var query_581840 = newJObject()
  var body_581841 = newJObject()
  add(query_581840, "fields", newJString(fields))
  add(query_581840, "quotaUser", newJString(quotaUser))
  add(query_581840, "alt", newJString(alt))
  add(query_581840, "oauth_token", newJString(oauthToken))
  add(query_581840, "userIp", newJString(userIp))
  add(path_581839, "userKey", newJString(userKey))
  add(query_581840, "key", newJString(key))
  if body != nil:
    body_581841 = body
  add(query_581840, "prettyPrint", newJBool(prettyPrint))
  result = call_581838.call(path_581839, query_581840, nil, nil, body_581841)

var directoryUsersUndelete* = Call_DirectoryUsersUndelete_581825(
    name: "directoryUsersUndelete", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/users/{userKey}/undelete",
    validator: validate_DirectoryUsersUndelete_581826,
    base: "/admin/directory/v1", url: url_DirectoryUsersUndelete_581827,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesList_581842 = ref object of OpenApiRestCall_579437
proc url_DirectoryVerificationCodesList_581844(protocol: Scheme; host: string;
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

proc validate_DirectoryVerificationCodesList_581843(path: JsonNode;
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
  var valid_581845 = path.getOrDefault("userKey")
  valid_581845 = validateParameter(valid_581845, JString, required = true,
                                 default = nil)
  if valid_581845 != nil:
    section.add "userKey", valid_581845
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
  var valid_581846 = query.getOrDefault("fields")
  valid_581846 = validateParameter(valid_581846, JString, required = false,
                                 default = nil)
  if valid_581846 != nil:
    section.add "fields", valid_581846
  var valid_581847 = query.getOrDefault("quotaUser")
  valid_581847 = validateParameter(valid_581847, JString, required = false,
                                 default = nil)
  if valid_581847 != nil:
    section.add "quotaUser", valid_581847
  var valid_581848 = query.getOrDefault("alt")
  valid_581848 = validateParameter(valid_581848, JString, required = false,
                                 default = newJString("json"))
  if valid_581848 != nil:
    section.add "alt", valid_581848
  var valid_581849 = query.getOrDefault("oauth_token")
  valid_581849 = validateParameter(valid_581849, JString, required = false,
                                 default = nil)
  if valid_581849 != nil:
    section.add "oauth_token", valid_581849
  var valid_581850 = query.getOrDefault("userIp")
  valid_581850 = validateParameter(valid_581850, JString, required = false,
                                 default = nil)
  if valid_581850 != nil:
    section.add "userIp", valid_581850
  var valid_581851 = query.getOrDefault("key")
  valid_581851 = validateParameter(valid_581851, JString, required = false,
                                 default = nil)
  if valid_581851 != nil:
    section.add "key", valid_581851
  var valid_581852 = query.getOrDefault("prettyPrint")
  valid_581852 = validateParameter(valid_581852, JBool, required = false,
                                 default = newJBool(true))
  if valid_581852 != nil:
    section.add "prettyPrint", valid_581852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581853: Call_DirectoryVerificationCodesList_581842; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the current set of valid backup verification codes for the specified user.
  ## 
  let valid = call_581853.validator(path, query, header, formData, body)
  let scheme = call_581853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581853.url(scheme.get, call_581853.host, call_581853.base,
                         call_581853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581853, url, valid)

proc call*(call_581854: Call_DirectoryVerificationCodesList_581842;
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
  var path_581855 = newJObject()
  var query_581856 = newJObject()
  add(query_581856, "fields", newJString(fields))
  add(query_581856, "quotaUser", newJString(quotaUser))
  add(query_581856, "alt", newJString(alt))
  add(query_581856, "oauth_token", newJString(oauthToken))
  add(query_581856, "userIp", newJString(userIp))
  add(path_581855, "userKey", newJString(userKey))
  add(query_581856, "key", newJString(key))
  add(query_581856, "prettyPrint", newJBool(prettyPrint))
  result = call_581854.call(path_581855, query_581856, nil, nil, nil)

var directoryVerificationCodesList* = Call_DirectoryVerificationCodesList_581842(
    name: "directoryVerificationCodesList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/users/{userKey}/verificationCodes",
    validator: validate_DirectoryVerificationCodesList_581843,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesList_581844,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesGenerate_581857 = ref object of OpenApiRestCall_579437
proc url_DirectoryVerificationCodesGenerate_581859(protocol: Scheme; host: string;
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

proc validate_DirectoryVerificationCodesGenerate_581858(path: JsonNode;
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
  var valid_581860 = path.getOrDefault("userKey")
  valid_581860 = validateParameter(valid_581860, JString, required = true,
                                 default = nil)
  if valid_581860 != nil:
    section.add "userKey", valid_581860
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
  var valid_581861 = query.getOrDefault("fields")
  valid_581861 = validateParameter(valid_581861, JString, required = false,
                                 default = nil)
  if valid_581861 != nil:
    section.add "fields", valid_581861
  var valid_581862 = query.getOrDefault("quotaUser")
  valid_581862 = validateParameter(valid_581862, JString, required = false,
                                 default = nil)
  if valid_581862 != nil:
    section.add "quotaUser", valid_581862
  var valid_581863 = query.getOrDefault("alt")
  valid_581863 = validateParameter(valid_581863, JString, required = false,
                                 default = newJString("json"))
  if valid_581863 != nil:
    section.add "alt", valid_581863
  var valid_581864 = query.getOrDefault("oauth_token")
  valid_581864 = validateParameter(valid_581864, JString, required = false,
                                 default = nil)
  if valid_581864 != nil:
    section.add "oauth_token", valid_581864
  var valid_581865 = query.getOrDefault("userIp")
  valid_581865 = validateParameter(valid_581865, JString, required = false,
                                 default = nil)
  if valid_581865 != nil:
    section.add "userIp", valid_581865
  var valid_581866 = query.getOrDefault("key")
  valid_581866 = validateParameter(valid_581866, JString, required = false,
                                 default = nil)
  if valid_581866 != nil:
    section.add "key", valid_581866
  var valid_581867 = query.getOrDefault("prettyPrint")
  valid_581867 = validateParameter(valid_581867, JBool, required = false,
                                 default = newJBool(true))
  if valid_581867 != nil:
    section.add "prettyPrint", valid_581867
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581868: Call_DirectoryVerificationCodesGenerate_581857;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generate new backup verification codes for the user.
  ## 
  let valid = call_581868.validator(path, query, header, formData, body)
  let scheme = call_581868.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581868.url(scheme.get, call_581868.host, call_581868.base,
                         call_581868.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581868, url, valid)

proc call*(call_581869: Call_DirectoryVerificationCodesGenerate_581857;
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
  var path_581870 = newJObject()
  var query_581871 = newJObject()
  add(query_581871, "fields", newJString(fields))
  add(query_581871, "quotaUser", newJString(quotaUser))
  add(query_581871, "alt", newJString(alt))
  add(query_581871, "oauth_token", newJString(oauthToken))
  add(query_581871, "userIp", newJString(userIp))
  add(path_581870, "userKey", newJString(userKey))
  add(query_581871, "key", newJString(key))
  add(query_581871, "prettyPrint", newJBool(prettyPrint))
  result = call_581869.call(path_581870, query_581871, nil, nil, nil)

var directoryVerificationCodesGenerate* = Call_DirectoryVerificationCodesGenerate_581857(
    name: "directoryVerificationCodesGenerate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/generate",
    validator: validate_DirectoryVerificationCodesGenerate_581858,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesGenerate_581859,
    schemes: {Scheme.Https})
type
  Call_DirectoryVerificationCodesInvalidate_581872 = ref object of OpenApiRestCall_579437
proc url_DirectoryVerificationCodesInvalidate_581874(protocol: Scheme;
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

proc validate_DirectoryVerificationCodesInvalidate_581873(path: JsonNode;
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
  var valid_581875 = path.getOrDefault("userKey")
  valid_581875 = validateParameter(valid_581875, JString, required = true,
                                 default = nil)
  if valid_581875 != nil:
    section.add "userKey", valid_581875
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
  var valid_581876 = query.getOrDefault("fields")
  valid_581876 = validateParameter(valid_581876, JString, required = false,
                                 default = nil)
  if valid_581876 != nil:
    section.add "fields", valid_581876
  var valid_581877 = query.getOrDefault("quotaUser")
  valid_581877 = validateParameter(valid_581877, JString, required = false,
                                 default = nil)
  if valid_581877 != nil:
    section.add "quotaUser", valid_581877
  var valid_581878 = query.getOrDefault("alt")
  valid_581878 = validateParameter(valid_581878, JString, required = false,
                                 default = newJString("json"))
  if valid_581878 != nil:
    section.add "alt", valid_581878
  var valid_581879 = query.getOrDefault("oauth_token")
  valid_581879 = validateParameter(valid_581879, JString, required = false,
                                 default = nil)
  if valid_581879 != nil:
    section.add "oauth_token", valid_581879
  var valid_581880 = query.getOrDefault("userIp")
  valid_581880 = validateParameter(valid_581880, JString, required = false,
                                 default = nil)
  if valid_581880 != nil:
    section.add "userIp", valid_581880
  var valid_581881 = query.getOrDefault("key")
  valid_581881 = validateParameter(valid_581881, JString, required = false,
                                 default = nil)
  if valid_581881 != nil:
    section.add "key", valid_581881
  var valid_581882 = query.getOrDefault("prettyPrint")
  valid_581882 = validateParameter(valid_581882, JBool, required = false,
                                 default = newJBool(true))
  if valid_581882 != nil:
    section.add "prettyPrint", valid_581882
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_581883: Call_DirectoryVerificationCodesInvalidate_581872;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Invalidate the current backup verification codes for the user.
  ## 
  let valid = call_581883.validator(path, query, header, formData, body)
  let scheme = call_581883.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_581883.url(scheme.get, call_581883.host, call_581883.base,
                         call_581883.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_581883, url, valid)

proc call*(call_581884: Call_DirectoryVerificationCodesInvalidate_581872;
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
  var path_581885 = newJObject()
  var query_581886 = newJObject()
  add(query_581886, "fields", newJString(fields))
  add(query_581886, "quotaUser", newJString(quotaUser))
  add(query_581886, "alt", newJString(alt))
  add(query_581886, "oauth_token", newJString(oauthToken))
  add(query_581886, "userIp", newJString(userIp))
  add(path_581885, "userKey", newJString(userKey))
  add(query_581886, "key", newJString(key))
  add(query_581886, "prettyPrint", newJBool(prettyPrint))
  result = call_581884.call(path_581885, query_581886, nil, nil, nil)

var directoryVerificationCodesInvalidate* = Call_DirectoryVerificationCodesInvalidate_581872(
    name: "directoryVerificationCodesInvalidate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/users/{userKey}/verificationCodes/invalidate",
    validator: validate_DirectoryVerificationCodesInvalidate_581873,
    base: "/admin/directory/v1", url: url_DirectoryVerificationCodesInvalidate_581874,
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
